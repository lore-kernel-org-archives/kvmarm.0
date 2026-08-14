Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD8A3148C9
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715657; cv=none; b=USutUBu+y55PdV6MI1VybpWid+tzIVLmIU5iONrBeVcWOYRcInEmnkr2iyf0K1Ni8BU2NqB2j2O5uMPkYgSp77L3P0JIDtuzJE3XgS/Uf22jutTd33GoS9UJgWDx8ktZVMEU4Niqgt/KI+aAqnl0TlbpLLtTGPmM1dWogupJMTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715657; c=relaxed/simple;
	bh=Kd4jXUGL6nDQ//O1hT6G2oUVVs9/UQkeDxS23+tteQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=elGiIqzag1etnkR03JgYBDmpVr07b0Hd8X82maghSXq1ws4DWSma3Yojax6+5KZ9wXNin3/bUppplVHnDsPR/Bzpkbj7IoHuV/tLxmI4bydbDQunp2N+9V8nVwLVMIbH871pFYJTuP4NOqo/W/7EkMGUOsRlApUYld1eOBQgsOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=As0Iriei; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="As0Iriei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786715653;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJnSlKJBSYX3/I7gZTqILoQicddzpp2MW7nmIyv5Cac=;
	b=As0IrieiLTUE5+8L4y3AzRdhkIIvgQT17JiqrNyfc0/DGTTFgWexnPL9HHD/Wn5PNcjnxF
	0lmWhsMbUpgoQI7o69ZGPithKYaX4d0LvMBMs+tasocDXx7hK12zdQAzWud1R/smMVPu8+
	0cx3l+MDx8VEF7WFv6CgNurZxrvN12M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-DIuEpiocMH66THM3ydVDeQ-1; Fri, 14 Aug 2026 09:54:07 -0400
X-MC-Unique: DIuEpiocMH66THM3ydVDeQ-1
X-Mimecast-MFC-AGG-ID: DIuEpiocMH66THM3ydVDeQ_1786715646
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-493bfc3b84aso6050265e9.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 06:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786715646; x=1787320446;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJnSlKJBSYX3/I7gZTqILoQicddzpp2MW7nmIyv5Cac=;
        b=nS7x3dMMHI8Pce7JWGbeq6WtsOMgnLQ92rNAdltEJoNbPpxWNWqQEoky+FYtamhuP2
         rlpgJQhm8fmJCAqW0yzO+2R6COb1ACSlhHbX7Eb0R4PnRSb7bRyCodn1itgjPgWXgbf/
         lvEvvs6BxaqnQNZM3tB4exmWwzYsXpl8kekb/3eUcOXQwOo7a2sNlSGrvevxwrxItqzc
         hhe8SHMP+YCKfLfTG9clH/vkDFBtnEh3ZzuRvYOtfbt31NSCOQwirWu4kFiFliYtumxc
         LkSfjQPaVNJJFdd3JytRrbdgaFl871J2Q3lpW728aMInXZeTOslHadbcSVJFlYTZ7X5s
         aOVQ==
X-Forwarded-Encrypted: i=1; AHgh+RrRtx0OxXGoQq8e1gFKjKku5IhjIS2sHHao/oC0EOqWH0PTsg4aMRsS0sls9/fcUmb6Dzse1PA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+fTnLHocp3fj+qHjoReCC65jIB/ORmHZ1H8LmpfkqnY3zobob
	nZEwGHGSBZB5ynt0bnBe660uk1mOxE2z6h0BItRUWrXvqUr4pi8WHju4b+JmiGTRljxNHq6xuNv
	/lIaRxeqcf7a9spXTjOTljcNYmmZNIq1wJQoSIAHygdfs0ddC9sfTPLjK+BmuqwpGbQ==
X-Gm-Gg: AR+sD10WjzTV8QYpqUbxtXY+1JOyj31B0yhMECpi2tOUCkldr7XSgm+qGu2M4RgiYF8
	X4zbogGZ/qX/N8v8oON2yStqieOUCiLmkcup2uFGHXrzI5Q+y/blKqwqPujXujDUyiWw71fweLG
	xy2s+V1bJwVmOSuciIyqs34JRkzyEaJxRzBUzOY+5lbH0Gw/pc6s8quBikB/FaVLY2UL6OKwpZ2
	AC7HcCcg7+ieiPtUoFvRAx4Iaa745pGi7cgmhwsMNhXAyAm9h1+uZlkUiF307maSf4J2jiQM+Sz
	U1KIMOgU1hf/R5neSRzWM5uC4jPeFBiGxM83GyI7ESpSaf6xSUDl/gXlZZFhIbpBxhKxUylNX7i
	KtRPtz2gtxe1ESs0tfCMOifPsqLO/X/fiIvnJFdBKYJdfdtvJ
X-Received: by 2002:a05:600c:2055:b0:499:819e:db2c with SMTP id 5b1f17b1804b1-499879ace10mr61364195e9.16.1786715645800;
        Fri, 14 Aug 2026 06:54:05 -0700 (PDT)
X-Received: by 2002:a05:600c:2055:b0:499:819e:db2c with SMTP id 5b1f17b1804b1-499879ace10mr61363615e9.16.1786715645258;
        Fri, 14 Aug 2026 06:54:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2b1a91sm7946219f8f.21.2026.08.14.06.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 06:54:04 -0700 (PDT)
Message-ID: <820a8685-8adf-44e7-bb8f-38a053da5773@redhat.com>
Date: Fri, 14 Aug 2026 15:54:01 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 04/19] target/arm: expose all ID regs fields as
 properties
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 Prerna Saxena <prerna.saxena@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-5-khushit.shah@nutanix.com>
 <2c79dd3a-389d-448d-bb6b-cbaef18210dd@redhat.com>
 <BB4783F9-D3CD-483D-8C3E-4CF8DA0ECED6@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <BB4783F9-D3CD-483D-8C3E-4CF8DA0ECED6@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u4nk44nQUhAsootDXHOurmgzQsZQXxUkRrgl-hdgr5Y_1786715646
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/3/26 5:05 PM, Khushit Shah wrote:
>
>> On 21 Jul 2026, at 8:14 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Hi Khushit,
>>
>> On 7/16/26 11:38 PM, Khushit Shah wrote:
>>> Upcoming named cpu models layer requires exposing all the ID register
>>> fields as properties.
>>>
>>> While doing so also move the code to cpu64.c to make it
>>> accelerator-agnostic, and rename the function to
>>> `aarch64_add_idregs_properties()`.
>> Better to split that patch into 2 to ease the review:
>> 1) update the code in kvm to expose all ID regs including those which
>> are not writable and adaptation in set_sysreg_prop to handle RAZ,
>> RES0/1, ...
>> 2) Move to cpu64.c
> This makes more sense, thanks, will do that in v4.
>
>> To me it is still arguable whether it makes sense to expose settings
>> which cannot be really set. To me It pollutes the qmp introspection
>> output and I don't know whether there is any case history.
>> Why can't we:
>> - only expose writable id regs as props
>> - other non writable settings you need to check could be registered in a
>> hash table during named cpu model definition in props. 
>> in arm_apply_model_props() when you enumerate all props you can check if
>> there is an existing prop for this name, in which case you really call
>>
>> object_property_set_bool(), otherwise, you go through another path, which is not visible by the end user where you check the KVM value matches your "prop" value. No need to pretend this is writable.
> Please refer to my below text. 
>
>> Also I am doubtful about RES/RAZ.
>>
>> +    MODEL_PROP("SYSREG_CTR_EL0_RES1_31", NUM, 1),
>>
>> does not make sense to me
>>
>> Why can't you enumate all ID regs and go through those fields and check the KVM value matches. Why would we need to explicitly set a RAS/RES0/1 field. Why can't that be checked transparently.
> Why do we need non-writable field props?:
> - Assume some non-writable field mismatches for the model and
>   host, why do we want to stop users from explicitly overriding
>   the model's field value to host value?
> - Even with cpu -host, how will upper layer know, if they can
>   migrate between host A and host B? (Without actually doing
>   the migration)
>      -> Only if all non-writable fields in both host matches
>         and writable fields in both host are “compatible”.

I do agree with you we need to check non writable fields do match. What
I am challenging is the fact you want to expose non writable idregs
through qemu properties. If it is not writable why would we pretend the
end user can change it through the cmd line. You can set the expected
field value in the vcpu model description through DEFINEs or whatever
method. Then on init, the model will read the host value and fails the
init if they don't match. The fact no prop is available for this field
would teach the end user the field is not writable. 

The above MODEL_PROP() could be a wrapper that either sets the actual
property if it exists (for a writable field) or just silently populate a
table of expected non writable field values that are checked on init, no?
>
> Why would we need to explicitly set a RAS/RES0/1 field?
> - Here my argument is a little weaker but, what if RES1 field
>   is repurposed in the future? We still want existing models
>   to show 1.
AARCHMRS description tells you which fields are RESx. You can read the
host value and fails the init in case of mismatch.

Thanks

Eric
>   RES0 does not need any special handling, only RES1 field needs
>   this special handling.
>
>
> Does the above arguments make sense? 
>
> Warm Regards,
> Khushit
>
>> Thanks
>>
>> Eric
>>
>>> This makes porting this solution to other accelerators easy in future.
>>>
>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>> ---
>>> target/arm/cpu64.c      | 116 +++++++++++++++++++++++++++++-
>>> target/arm/internals.h  |   3 +
>>> target/arm/kvm.c        | 151 ----------------------------------------
>>> target/arm/kvm_arm.h    |   8 ---
>>> target/arm/trace-events |   4 +-
>>> 5 files changed, 119 insertions(+), 163 deletions(-)
>>>
>>> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
>>> index 92a01d4ce7..cdad0fc46d 100644
>>> --- a/target/arm/cpu64.c
>>> +++ b/target/arm/cpu64.c
>>> @@ -38,6 +38,7 @@
>>> #include "internals.h"
>>> #include "cpu-features.h"
>>> #include "cpu-idregs.h"
>>> +#include "trace.h"
>>>
>>> /* convert between <register>_IDX and SYS_<register> */
>>> #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
>>> @@ -644,6 +645,113 @@ static const Property arm_cpu_pauth_qarma3_property =
>>> static Property arm_cpu_pauth_qarma5_property =
>>>     DEFINE_PROP_BOOL("pauth-qarma5", ARMCPU, prop_pauth_qarma5, false);
>>>
>>> +#ifndef CONFIG_USER_ONLY
>>> +static void set_sysreg_prop(Object *obj, Visitor *v,
>>> +                            const char *name, void *opaque,
>>> +                            Error **errp)
>>> +{
>>> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
>>> +    ARMCPU *cpu = ARM_CPU(obj);
>>> +    uint64_t *idregs = cpu->isar.idregs;
>>> +    uint64_t old, value, mask;
>>> +    int lower = field->shift;
>>> +    int length = field->length;
>>> +    int index = field->index;
>>> +
>>> +    if (!visit_type_uint64(v, name, &value, errp)) {
>>> +        return;
>>> +    }
>>> +
>>> +    if (length < 64 && value > ((1ULL << length) - 1)) {
>>> +        error_setg(errp,
>>> +                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
>>> +                   name, value, length);
>>> +        return;
>>> +    }
>>> +
>>> +    if (field->arch_vals) {
>>> +        /* this field has some enum values */
>>> +        for (int i = 0; i < field->arch_vals_count; i++) {
>>> +            if (value == field->arch_vals[i].value) {
>>> +                goto valid;
>>> +            }
>>> +        }
>>> +        error_setg(errp,
>>> +                   "idreg %s set value (0x%lx) does not match any "
>>> +                   "arch valid enum value!", name, value);
>>> +        return;
>>> +    }
>>> +
>>> +    /* If the field is RESx or RAZ, it should not be written anything else */
>>> +    if (strstr(field->name, "RES0") && value != 0) {
>>> +        error_setg(errp, "idreg %s is RES0 field and cannot write %ld",
>>> +            name, value);
>>> +        return;
>>> +    } else if (strstr(field->name, "RAZ") && value != 0) {
>>> +        error_setg(errp, "idreg %s is RAZ field and cannot write %ld",
>>> +            name, value);
>>> +        return;
>>> +    } else if (strstr(field->name, "RES1") && value != 1) {
>>> +        error_setg(errp, "idreg %s is RES1 field and cannot write %ld",
>>> +            name, value);
>>> +        return;
>>> +    }
>>> +
>>> +valid:
>>> +    mask = MAKE_64BIT_MASK(lower, length);
>>> +    value = value << lower;
>>> +    old = idregs[index];
>>> +    idregs[index] = old & ~mask;
>>> +    idregs[index] |= value;
>>> +    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
>>> +}
>>> +
>>> +static void get_sysreg_prop(Object *obj, Visitor *v,
>>> +                            const char *name, void *opaque,
>>> +                            Error **errp)
>>> +{
>>> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
>>> +    ARMCPU *cpu = ARM_CPU(obj);
>>> +    uint64_t *idregs = cpu->isar.idregs;
>>> +    uint64_t value, mask;
>>> +    int lower = field->shift;
>>> +    int length = field->length;
>>> +    int index = field->index;
>>> +
>>> +    mask = MAKE_64BIT_MASK(lower, length);
>>> +    value = (idregs[index] & mask) >> lower;
>>> +    visit_type_uint64(v, name, &value, errp);
>>> +    trace_get_sysreg_prop(name, value);
>>> +}
>>> +
>>> +static int
>>> +aarch64_add_idreg_properties(Object *obj, ARM64SysReg *reg)
>>> +{
>>> +    int nb_sysreg_props = 0;
>>> +
>>> +    for (int i = 0; i < reg->fields_count; i++) {
>>> +        ARM64SysRegField *field = &reg->fields[i];
>>> +        char *prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name,
>>> +                                          field->name);
>>> +        object_property_add(obj, prop_name, "uint64",
>>> +                            get_sysreg_prop, set_sysreg_prop, NULL, field);
>>> +        g_free(prop_name);
>>> +        nb_sysreg_props++;
>>> +    }
>>> +
>>> +    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
>>> +    return 0;
>>> +}
>>> +
>>> +void aarch64_add_idregs_properties(Object *obj)
>>> +{
>>> +    for (int i = 0; i < NUM_ID_IDX; i++) {
>>> +        ARM64SysReg *reg = &arm64_id_regs[i];
>>> +        aarch64_add_idreg_properties(obj, reg);
>>> +    }
>>> +}
>>> +#endif
>>> +
>>> void aarch64_add_pauth_properties(Object *obj)
>>> {
>>>     ARMCPU *cpu = ARM_CPU(obj);
>>> @@ -865,8 +973,12 @@ static void aarch64_host_initfn(Object *obj)
>>>     kvm_arm_set_cpu_features_from_host(cpu);
>>>     aarch64_add_sve_properties(obj);
>>>
>>> -    /* generate SYSREG properties according to writable masks */
>>> -    kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
>>> +#ifndef CONFIG_USER_ONLY
>>> +    /* generate SYSREG properties */
>>> +    if (kvm_enabled()) {
>>> +        aarch64_add_idregs_properties(obj);
>>> +    }
>>> +#endif
>>>
>>> #elif defined(CONFIG_HVF)
>>>     hvf_arm_set_cpu_features_from_host(cpu);
>>> diff --git a/target/arm/internals.h b/target/arm/internals.h
>>> index a632584a4e..7502b6db8a 100644
>>> --- a/target/arm/internals.h
>>> +++ b/target/arm/internals.h
>>> @@ -1754,6 +1754,9 @@ void aarch64_max_tcg_initfn(Object *obj);
>>> void aarch64_add_pauth_properties(Object *obj);
>>> void aarch64_add_sve_properties(Object *obj);
>>> void aarch64_add_sme_properties(Object *obj);
>>> +#ifndef CONFIG_USER_ONLY
>>> +void aarch64_add_idregs_properties(Object *obj);
>>> +#endif
>>>
>>> /* Return true if the gdbstub is presenting an AArch64 CPU */
>>> static inline bool arm_gdbstub_is_aarch64(ARMCPU *cpu)
>>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>> index 892433a612..76583db3f0 100644
>>> --- a/target/arm/kvm.c
>>> +++ b/target/arm/kvm.c
>>> @@ -327,157 +327,6 @@ static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
>>>     return err;
>>> }
>>>
>>> -static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
>>> -{
>>> -    for (int f = 0; f < reg->fields_count; f++) {
>>> -        struct ARM64SysRegField *field = &reg->fields[f];
>>> -        int upper = field->shift + field->length - 1;
>>> -
>>> -        if (i >= field->shift && i <= upper) {
>>> -            return field;
>>> -        }
>>> -    }
>>> -    return NULL;
>>> -}
>>> -
>>> -static void set_sysreg_prop(Object *obj, Visitor *v,
>>> -                            const char *name, void *opaque,
>>> -                            Error **errp)
>>> -{
>>> -    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
>>> -    ARMCPU *cpu = ARM_CPU(obj);
>>> -    uint64_t *idregs = cpu->isar.idregs;
>>> -    uint64_t old, value, mask;
>>> -    int lower = field->shift;
>>> -    int length = field->length;
>>> -    int index = field->index;
>>> -
>>> -    if (!visit_type_uint64(v, name, &value, errp)) {
>>> -        return;
>>> -    }
>>> -
>>> -    if (length < 64 && value > ((1 << length) - 1)) {
>>> -        error_setg(errp,
>>> -                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
>>> -                   name, value, length);
>>> -        return;
>>> -    }
>>> -
>>> -    if (field->arch_vals) {
>>> -        /* this field has some enum values */
>>> -        for (int i = 0; i < field->arch_vals_count; i++) {
>>> -            if (value == field->arch_vals[i].value) {
>>> -                goto valid;
>>> -            }
>>> -        }
>>> -        error_setg(errp,
>>> -                   "idreg %s set value (0x%lx) does not match any "
>>> -                   "arch valid enum value!", name, value);
>>> -        return;
>>> -    }
>>> -
>>> -valid:
>>> -
>>> -    mask = MAKE_64BIT_MASK(lower, length);
>>> -    value = value << lower;
>>> -    old = idregs[index];
>>> -    idregs[index] = old & ~mask;
>>> -    idregs[index] |= value;
>>> -    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
>>> -}
>>> -
>>> -static void get_sysreg_prop(Object *obj, Visitor *v,
>>> -                            const char *name, void *opaque,
>>> -                            Error **errp)
>>> -{
>>> -    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
>>> -    ARMCPU *cpu = ARM_CPU(obj);
>>> -    uint64_t *idregs = cpu->isar.idregs;
>>> -    uint64_t value, mask;
>>> -    int lower = field->shift;
>>> -    int length = field->length;
>>> -    int index = field->index;
>>> -
>>> -    mask = MAKE_64BIT_MASK(lower, length);
>>> -    value = (idregs[index] & mask) >> lower;
>>> -    visit_type_uint64(v, name, &value, errp);
>>> -    trace_get_sysreg_prop(name, value);
>>> -}
>>> -
>>> -/*
>>> - * decode_idreg_writemap: Generate props for writable fields
>>> - *
>>> - * @obj: CPU object
>>> - * @reg: description of the sysreg
>>> - */
>>> -static int
>>> -decode_idreg_writemap(Object *obj, ARM64SysReg *reg)
>>> -{
>>> -    uint64_t map = reg->writable_mask;
>>> -    int i = ctz64(map);
>>> -    int nb_sysreg_props = 0;
>>> -
>>> -    while (map) {
>>> -        ARM64SysRegField *field = get_field(i, reg);
>>> -        int lower, upper;
>>> -        char *prop_name;
>>> -        uint64_t field_mask;
>>> -
>>> -        if (!field) {
>>> -            warn_report("%s bit %d of %s is writable but no named field "
>>> -                        "in target/arm/cpu-idregs.h.inc",
>>> -                        __func__, i, reg->name);
>>> -            warn_report("%s is target/arm/cpu-idregs.h.inc up-to-date?", __func__);
>>> -            map =  map & ~BIT_ULL(i);
>>> -            i = ctz64(map);
>>> -            continue;
>>> -        }
>>> -        lower = field->shift;
>>> -        upper = field->shift + field->length - 1;
>>> -
>>> -        /* Sanity check the field is not a reserved field */
>>> -        if (strstr(field->name, "RES0") || strstr(field->name, "RES1") ||
>>> -            strstr(field->name, "RAZ")) {
>>> -            trace_unexpected_writable_reserved_field(reg->name, field->name,
>>> -                                                     lower, upper);
>>> -            continue;
>>> -        }
>>> -        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
>>> -        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
>>> -        object_property_add(obj, prop_name, "uint64",
>>> -                            get_sysreg_prop, set_sysreg_prop, NULL, field);
>>> -        g_free(prop_name);
>>> -        nb_sysreg_props++;
>>> -
>>> -        field_mask = MAKE_64BIT_MASK(lower, field->length);
>>> -        map = map & ~field_mask;
>>> -        i = ctz64(map);
>>> -    }
>>> -    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
>>> -    return 0;
>>> -}
>>> -
>>> -/* analyze the writable mask and generate properties for writable fields */
>>> -void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs)
>>> -{
>>> -    Object *obj = OBJECT(cpu);
>>> -
>>> -    for (int i = 0; i < NUM_ID_IDX; i++) {
>>> -        ARM64SysReg *sysregdesc = &regs[i];
>>> -
>>> -        if (sysregdesc->writable_mask) {
>>> -            /*
>>> -             * special case REVIDR_EL1 and AIDR_EL1 which are writable but
>>> -             * do not expose named fields. They will need to be handled
>>> -             * separately
>>> -             */
>>> -            if (strcmp(sysregdesc->name, "REVIDR_EL1") &&
>>> -                strcmp(sysregdesc->name, "AIDR_EL1")) {
>>> -                decode_idreg_writemap(obj, sysregdesc);
>>> -            }
>>> -        }
>>> -    }
>>> -}
>>>
>>> static void
>>> kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
>>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>>> index 2b3474cc36..133a026036 100644
>>> --- a/target/arm/kvm_arm.h
>>> +++ b/target/arm/kvm_arm.h
>>> @@ -143,14 +143,6 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
>>> void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
>>>
>>> typedef struct ARM64SysReg ARM64SysReg;
>>> -/**
>>> - * kvm_arm_expose_idreg_properties:
>>> - * @cpu: The CPU object to generate the properties for
>>> - * @reg: registers from the host
>>> - *
>>> - * analyze the writable mask and generate properties for writable fields
>>> - */
>>> -void kvm_arm_expose_idreg_properties(ARMCPU *cpu, ARM64SysReg *regs);
>>>
>>> /**
>>>  * kvm_arm_steal_time_finalize:
>>> diff --git a/target/arm/trace-events b/target/arm/trace-events
>>> index e67730de6b..f33b0d821d 100644
>>> --- a/target/arm/trace-events
>>> +++ b/target/arm/trace-events
>>> @@ -15,11 +15,11 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>>> kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>>> get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
>>> kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
>>> -decode_idreg_writemap(const char* name, int lower, int upper, char *prop_name) "%s [%d:%d] is writable (prop %s)"
>>> +
>>> +# cpu64.c
>>> get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
>>> set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
>>> nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
>>> -unexpected_writable_reserved_field(const char *reg_name, const char *field_name, int lower, int upper) "Unexpected writable reserved field: %s.%s [%d,%d], skip it ..."
>>>
>>> # cpu.c
>>> arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64

