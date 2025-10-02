<#macro userProfileFormFields>
    <#assign currentGroup="">

    <#list profile.attributes as attribute>
        <#assign group = (attribute.group)!"">
        <#if group != currentGroup>
            <#assign currentGroup=group>
            <#if currentGroup != "">
                <div class="itl-form-group"
                <#list group.html5DataAnnotations as key, value>
                    data-${key}="${value}"
                </#list>
                >
                    <#assign groupDisplayHeader=group.displayHeader!"">
                    <#if groupDisplayHeader != "">
                        <#assign groupHeaderText=advancedMsg(groupDisplayHeader)!group>
                    <#else>
                        <#assign groupHeaderText=group.name!"">
                    </#if>
                    <div class="itl-form-group-header">
                        <h3 id="header-${group.name}" class="itl-form-group-title">${groupHeaderText}</h3>
                    </div>

                    <#assign groupDisplayDescription=group.displayDescription!"">
                    <#if groupDisplayDescription != "">
                        <#assign groupDescriptionText=advancedMsg(groupDisplayDescription)!"">
                        <div class="itl-form-group-description">
                            <p id="description-${group.name}" class="itl-form-group-desc">${groupDescriptionText}</p>
                        </div>
                    </#if>
                </div>
            </#if>
        </#if>

        <div class="itl-form-field <#if attribute.required>itl-form-field--required</#if>">
            <@inputFieldByType attribute=attribute/>
        </div>
    </#list>
</#macro>

<#macro inputFieldByType attribute>
    <#switch attribute.name>
        <#case "username">
            <@inputDefault attribute=attribute autocomplete="username"/>
            <#break>
        <#case "email">
            <@inputDefault attribute=attribute autocomplete="email"/>
            <#break>
        <#case "firstName">
            <@inputDefault attribute=attribute autocomplete="given-name"/>
            <#break>
        <#case "lastName">
            <@inputDefault attribute=attribute autocomplete="family-name"/>
            <#break>
        <#default>
            <#if attribute.multivalued>
                <@inputMultiValue attribute=attribute/>
            <#else>
                <#switch attribute.annotations.inputType!''>
                    <#case "textarea">
                        <@inputTextarea attribute=attribute/>
                        <#break>
                    <#case "select">
                    <#case "multiselect">
                        <@inputSelect attribute=attribute/>
                        <#break>
                    <#case "select-radiobuttons">
                        <@inputSelectRadio attribute=attribute/>
                        <#break>
                    <#case "multiselect-checkboxes">
                        <@inputSelectCheckboxes attribute=attribute/>
                        <#break>
                    <#default>
                        <@inputDefault attribute=attribute/>
                </#switch>
            </#if>
    </#switch>
</#macro>

<#macro inputDefault attribute autocomplete="">
    <label for="${attribute.name}" class="itl-label">
        ${advancedMsg(attribute.displayName!'')}
        <#if attribute.required>*</#if>
    </label>
    <#if attribute.helpText?has_content>
        <div class="itl-field-help">
            ${advancedMsg(attribute.helpText)}
        </div>
    </#if>
    <#if messagesPerField.existsError('${attribute.name}')>
        <div class="itl-error-message" role="alert">
            <span class="itl-error-icon">⚠</span>
            ${kcSanitize(messagesPerField.get('${attribute.name}'))?no_esc}
        </div>
    </#if>
    <input 
        type="${inputType(attribute.annotations.inputType!'text')}" 
        id="${attribute.name}" 
        name="${attribute.name}" 
        value="${(attribute.value!'')}"
        class="itl-input <#if messagesPerField.existsError('${attribute.name}')>itl-input--error</#if>"
        aria-invalid="<#if messagesPerField.existsError('${attribute.name}')>true</#if>"
        <#if attribute.readOnly>disabled</#if>
        <#if attribute.required>required aria-required="true"</#if>
        <#if autocomplete?has_content>autocomplete="${autocomplete}"</#if>
        <#if attribute.annotations.inputTypePlaceholder?has_content>placeholder="${advancedMsg(attribute.annotations.inputTypePlaceholder)}"</#if>
        <#if attribute.annotations.inputTypePattern?has_content>pattern="${attribute.annotations.inputTypePattern}"</#if>
        <#if attribute.annotations.inputTypeSize?has_content>size="${attribute.annotations.inputTypeSize}"</#if>
        <#if attribute.annotations.inputTypeMaxlength?has_content>maxlength="${attribute.annotations.inputTypeMaxlength}"</#if>
        <#if attribute.annotations.inputTypeMinlength?has_content>minlength="${attribute.annotations.inputTypeMinlength}"</#if>
        <#if attribute.annotations.inputTypeMax?has_content>max="${attribute.annotations.inputTypeMax}"</#if>
        <#if attribute.annotations.inputTypeMin?has_content>min="${attribute.annotations.inputTypeMin}"</#if>
        <#if attribute.annotations.inputTypeStep?has_content>step="${attribute.annotations.inputTypeStep}"</#if>
        <#list attribute.html5DataAnnotations as key, value>data-${key}="${value}"</#list>
    />
</#macro>

<#macro inputTextarea attribute>
    <label for="${attribute.name}" class="itl-label">
        ${advancedMsg(attribute.displayName!'')}
        <#if attribute.required>*</#if>
    </label>
    <#if attribute.helpText?has_content>
        <div class="itl-field-help">
            ${advancedMsg(attribute.helpText)}
        </div>
    </#if>
    <#if messagesPerField.existsError('${attribute.name}')>
        <div class="itl-error-message" role="alert">
            <span class="itl-error-icon">⚠</span>
            ${kcSanitize(messagesPerField.get('${attribute.name}'))?no_esc}
        </div>
    </#if>
    <textarea 
        id="${attribute.name}" 
        name="${attribute.name}" 
        class="itl-textarea <#if messagesPerField.existsError('${attribute.name}')>itl-textarea--error</#if>"
        aria-invalid="<#if messagesPerField.existsError('${attribute.name}')>true</#if>"
        <#if attribute.readOnly>disabled</#if>
        <#if attribute.required>required aria-required="true"</#if>
        <#if attribute.annotations.inputTypeCols?has_content>cols="${attribute.annotations.inputTypeCols}"</#if>
        <#if attribute.annotations.inputTypeRows?has_content>rows="${attribute.annotations.inputTypeRows}"</#if>
        <#if attribute.annotations.inputTypeMaxlength?has_content>maxlength="${attribute.annotations.inputTypeMaxlength}"</#if>
        <#list attribute.html5DataAnnotations as key, value>data-${key}="${value}"</#list>
    >${(attribute.value!'')}</textarea>
</#macro>

<#function inputType type>
    <#switch type>
        <#case "password">
            <#return "password">
        <#case "email">
            <#return "email">
        <#case "number">
            <#return "number">
        <#case "range">
            <#return "range">
        <#case "date">
            <#return "date">
        <#case "datetime-local">
            <#return "datetime-local">
        <#case "time">
            <#return "time">
        <#case "tel">
            <#return "tel">
        <#case "url">
            <#return "url">
        <#case "color">
            <#return "color">
        <#default>
            <#return "text">
    </#switch>
</#function>