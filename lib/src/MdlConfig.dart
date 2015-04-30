/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdlcore;

typedef void MdlCallback(final dom.HtmlElement element);

typedef MdlComponent MdlComponentFactory(final dom.HtmlElement element,final di.Injector injector);

class MdlConfig<T extends MdlComponent> {
    final List<MdlCallback> callbacks = new List<MdlCallback>();

    /// {_componentFactory} is more or less a function that constructs the appropriate
    /// Object.
    /// Sample:
    ///     (final dom.HtmlElement element,final di.Injector injector)
    ///         => new MaterialAccordion.fromElement(element,injector));
    ///
    final MdlComponentFactory _componentFactory;

    /// Hold the Component-Class
    /// Sample:
    ///    mdl-js-accordion
    String cssClass;

    /// The higher the priority the later the component will be upgraded.
    /// This is important for the ripple-effect. Must be called as last upgrade process
    /// Default {priority} is 1, materialRippleConfig sets {priority} to 10
    int priority = 1;

    /// Avoids problems with Components and Helpers like MaterialRipple
    final bool isWidget;

    MdlConfig(this.cssClass, T componentFactory(final dom.HtmlElement element,final di.Injector injector),
              { final bool isWidget: false }) : _componentFactory = componentFactory, this.isWidget = isWidget {

        Validate.isTrue(T != "dynamic", "Add a type-information to your MdlConfig like new MdlConfig<MaterialButton>()");
        Validate.notBlank(cssClass, "cssClass must not be blank.");
        Validate.notNull(_componentFactory);
    }

    String get classAsString => type.toString();

    Type get type => T;

    MdlComponent newComponent(final dom.HtmlElement element,final di.Injector injector) {
        return _componentFactory(element,injector);
    }

    //- private -----------------------------------------------------------------------------------

}

/// Helps to decide what is a real Widget and what is just a helper.
/// MaterialRipple would be such a "helper-Widget"
class MdlWidgetConfig<T extends MdlComponent> extends MdlConfig<T> {
    MdlWidgetConfig(final String cssClass,
                    T componentFactory(final dom.HtmlElement element,final di.Injector injector)) :
                        super(cssClass, componentFactory, isWidget: true);
}