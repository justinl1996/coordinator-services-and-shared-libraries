/*
 * Copyright 2023 Google LLC
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

package com.google.scp.operator.cpio.notificationclient;

import com.google.inject.AbstractModule;

/**
 * Module class which binds NotificationClient to the actual implementation used by the service.
 */
public abstract class NotificationClientModule extends AbstractModule {

  /** Returns a {@code Class} object for the notification client implementation. */
  public abstract Class<? extends NotificationClient> getNotificationClientImpl();

  /**
   * Arbitrary Guice configurations that can be done by the implementing class to support
   * dependencies that are specific to that implementation.
   */
  public void customConfigure() {}

  /**
   * Configures injected dependencies for this module. Includes a binding for {@code
   * NotificationClient} in addition to any bindings in the {@code customConfigure} method.
   */
  @Override
  protected final void configure() {
    bind(NotificationClient.class).to(getNotificationClientImpl());
    customConfigure();
  }
}
