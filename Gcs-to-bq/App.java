/*
  * Licensed to the Apache Software Foundation (ASF) under one
  * or more contributor license agreements.  See the NOTICE file
  * distributed with this work for additional information
  * regarding copyright ownership.  The ASF licenses this file
  * to you under the Apache License, Version 2.0 (the
  * "License"); you may not use this file except in compliance
  * with the License.  You may obtain a copy of the License at
  *
  *     http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */
package com.bachinalabs;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.apache.beam.runners.dataflow.DataflowRunner;
import org.apache.beam.runners.dataflow.options.DataflowPipelineOptions;
import org.apache.beam.sdk.Pipeline;
import org.apache.beam.sdk.io.FileIO;
import org.apache.beam.sdk.io.TextIO;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO;
import org.apache.beam.sdk.options.PipelineOptions;
import org.apache.beam.sdk.options.PipelineOptionsFactory;
import org.apache.beam.sdk.transforms.Create;
import org.apache.beam.sdk.transforms.DoFn;
import org.apache.beam.sdk.transforms.MapElements;
import org.apache.beam.sdk.transforms.ParDo;
import org.apache.beam.sdk.transforms.SimpleFunction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.api.services.bigquery.model.TableReference;
import com.google.api.services.bigquery.model.TableRow;
import com.google.api.services.bigquery.model.TableSchema;
import com.google.api.services.bigquery.model.TableFieldSchema;
import org.apache.beam.runners.dataflow.DataflowRunner;
import org.apache.beam.runners.dataflow.options.DataflowPipelineOptions;
import org.apache.beam.sdk.Pipeline;
import org.apache.beam.sdk.io.TextIO;
import org.apache.beam.sdk.options.PipelineOptionsFactory;
import org.apache.beam.sdk.options.PipelineOptions;
import org.apache.beam.sdk.transforms.MapElements;
import org.apache.beam.sdk.transforms.Watch;
import org.apache.beam.sdk.transforms.windowing.FixedWindows;
import org.apache.beam.sdk.transforms.windowing.Window;
import org.apache.beam.sdk.transforms.Create;
import org.apache.beam.sdk.values.KV;
import org.apache.beam.sdk.values.PCollection;
import org.apache.beam.sdk.values.TypeDescriptors;
import org.joda.time.Duration;
import java.util.*;
/**
  * A starter example for writing Beam programs.
  *
  * <p>
  * The example takes two strings, converts them to their upper-case
  * representation and logs them.
  *
  * <p>
  * To run this starter example locally using DirectRunner, just execute it
  * without any additional parameters from your favorite development environment.
  *
  * <p>
  * To run this starter example using managed resource in Google Cloud Platform,
  * you should specify the following command-line options:
  * --project=<YOUR_PROJECT_ID>
  * --stagingLocation=<STAGING_LOCATION_IN_CLOUD_STORAGE> --runner=DataflowRunner
  */
public class App {
    private static final Logger LOG = LoggerFactory.getLogger(App.class);
     private static String HEADERS = "EMPID,FNAME,LNAME,SALARY";
    public static class FormatForBigquery extends DoFn<String, TableRow> {
        private String[] columnNames = HEADERS.split(",");
        @ProcessElement
         public void processElement(ProcessContext c) {
             TableRow row = new TableRow();
             String[] parts = c.element().split(",");
            if (!c.element().contains(HEADERS)) {
                 for (int i = 0; i < parts.length; i++) {
                     // No typy conversion at the moment.
                     row.set(columnNames[i], parts[i]);
                 }
                 c.output(row);
             }
         }
        /** Defines the BigQuery schema used for the output. */
        static TableSchema getSchema() {
             List<TableFieldSchema> fields = new ArrayList<>();
             // Currently store all values as String
             fields.add(new TableFieldSchema().setName("EMPID").setType("STRING"));
             fields.add(new TableFieldSchema().setName("FNAME").setType("STRING"));
             fields.add(new TableFieldSchema().setName("LNAME").setType("STRING"));
             fields.add(new TableFieldSchema().setName("SALARY").setType("STRING"));
            return new TableSchema().setFields(fields);
         }
     }
    public static void main(String[] args) throws Throwable {
         // Currently hard-code the variables, this can be passed into as parameters
         String sourceFilePath = "gs://df-src-gcp-training-01-303001/*.csv";
         String tempLocationPath = "gs://df-temp-gcp-training-01-303001/bq";
         boolean isStreaming = true;
         TableReference tableRef = new TableReference();
         // Replace this with your own GCP project id
         tableRef.setProjectId("gcp-training-01-303001");
         tableRef.setDatasetId("emp_ds");
         tableRef.setTableId("emp_tb");
        PipelineOptions options = PipelineOptionsFactory.fromArgs(args).withValidation().create();
         // This is required for BigQuery
         options.setTempLocation(tempLocationPath);
         options.setJobName("csvtobq");
         Pipeline p = Pipeline.create(options);
        p.apply("Read CSV File", TextIO.read().from(sourceFilePath).watchForNewFiles(
            // Check for new files every minute.
            Duration.standardMinutes(1),
            // Stop watching the file pattern if no new files appear for an hour.
            Watch.Growth.afterTimeSinceNewOutput(Duration.standardHours(1))))
                 .apply("Log messages", ParDo.of(new DoFn<String, String>() {
                     @ProcessElement
                     public void processElement(ProcessContext c) {
                         LOG.info("Processing row: " + c.element());
                         c.output(c.element());
                     }
                 })).apply("Convert to BigQuery TableRow", ParDo.of(new FormatForBigquery()))
                 .apply("Write into BigQuery",
                         BigQueryIO.writeTableRows().to(tableRef).withSchema(FormatForBigquery.getSchema())
                                 .withCreateDisposition(BigQueryIO.Write.CreateDisposition.CREATE_IF_NEEDED)
                                 .withWriteDisposition(isStreaming ? BigQueryIO.Write.WriteDisposition.WRITE_APPEND
                                         : BigQueryIO.Write.WriteDisposition.WRITE_TRUNCATE));

        p.apply(
    FileIO.match()
        .filepattern("...")
        .continuously(
            Duration.standardSeconds(30),
            Watch.Growth.afterTimeSinceNewOutput(Duration.standardHours(1))));                
        p.run().waitUntilFinish();
    }
}
