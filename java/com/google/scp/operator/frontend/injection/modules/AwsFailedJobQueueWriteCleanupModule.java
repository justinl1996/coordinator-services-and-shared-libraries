/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.scp.operator.frontend.injection.modules;

import com.google.inject.AbstractModule;
import com.google.inject.Provides;
import com.google.inject.Singleton;
import com.google.inject.multibindings.Multibinder;
import com.google.scp.operator.frontend.service.aws.changehandler.JobMetadataChangeHandler;
import com.google.scp.operator.frontend.service.aws.changehandler.MarkJobFailedToEnqueueHandler;
import com.google.scp.operator.shared.dao.metadatadb.aws.DynamoMetadataDb.MetadataDbDynamoTableName;
import com.google.scp.operator.shared.injection.factories.ModuleFactory;
import com.google.scp.operator.shared.injection.modules.BaseDataModule;
import software.amazon.awssdk.regions.Region;

/** Module for the frontend cleanup lambda for failed job queue writes. */
public final class AwsFailedJobQueueWriteCleanupModule extends AbstractModule {

  private static final String AWS_REGION_ENV_VAR = "AWS_REGION";
  private static final String JOB_METADATA_TABLE_ENV_VAR = "JOB_METADATA_TABLE";

  /** Configures injected dependencies for this module. */
  @Override
  public void configure() {
    Multibinder<JobMetadataChangeHandler> multibinder =
        Multibinder.newSetBinder(binder(), JobMetadataChangeHandler.class);
    multibinder.addBinding().to(MarkJobFailedToEnqueueHandler.class);
    install(ModuleFactory.getModule(BaseDataModule.class));
  }

  /** Provides a singleton instance of the {@code Region} class. */
  @Provides
  @Singleton
  Region provideAwsRegion() {
    String regionString = System.getenv(AWS_REGION_ENV_VAR);
    return Region.of(regionString);
  }

  /** Provides a string for the name of the DynamoDB metadata table. */
  @Provides
  @Singleton
  @MetadataDbDynamoTableName
  String provideMetadataDbDynamoTableName() {
    return System.getenv(JOB_METADATA_TABLE_ENV_VAR);
  }
}
