Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C908D26ED3D
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 06:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787727031; cv=none; b=PitP75FiuPIrnGFI5OasfCpqvpfiDTJnE4IZcY7PzFBjGqOvQTWhKmtU0u4J9+k4TBvYiuzzro67rV1hSyOhP7Yqujgh+zbfQ7ywnhg90NOE66Klv1GTEI4yFwnpYIrTXr0xS/nMVid1P5pyWR7ZGMXxxeTYcqZUcYtu5zgRoR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787727031; c=relaxed/simple;
	bh=L03qJjepeIgIsfCXhf5aMo133KBgYhVJcDE+N4hzVHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U+psPJ3G9nrlP+8q9RfrlJlDAiftwGsfn1TXkpOrKZ8Zmkq+3C3EH91+fmqOyrRsNS5mD8DciM0uAKPhqURubaJaozJc2wRw5C3cG5K3VJL1I+zCFPJRmf8K9e3uxLCfMnGRqTckz2cyPU+Sb8OImhyUesmKJMVsNbBjnKolzEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CyCy7pjC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CyCy7pjC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787727027;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=emv//XrvYholXANOqMWwHQIYAyRIppZnX63sxgczXdU=;
	b=CyCy7pjCi07HXlzqu8poAE/XuBl1rm4bmqeK4GUn4yrtts6c+C3firS2Smxiq8lt7upJyU
	4+f87R+e9v+uiOzYzgQ9+L25jJ3HutpRHbmGvWON/8jaDcqOPlLZFKM+tRhsGoP1ppGRVk
	7UsPcPh2jceQTaSrm9WHCBLXW1zPHWw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-HoI6TP_BO9WmAzy9QAEFiQ-1; Wed, 26 Aug 2026 02:50:26 -0400
X-MC-Unique: HoI6TP_BO9WmAzy9QAEFiQ-1
X-Mimecast-MFC-AGG-ID: HoI6TP_BO9WmAzy9QAEFiQ_1787727025
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c1c25c44d15so75011666b.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 23:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787727025; x=1788331825;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=emv//XrvYholXANOqMWwHQIYAyRIppZnX63sxgczXdU=;
        b=QNVFRtUPxruz2araE5v54zDfG8pgve0izBG3nXsIQWg1qvdb9qRDils6BE/C52fTXl
         gL6xbQVPoaAuX3M+D8soSuiy+xY74wEIYnNw8dtT9AyqwbZy7FpIgIvlvwU3OLP093fL
         KWry3X/jYqNKL/3sC5IxyguBAeh2ea1722+5BP8tNYpt4gByUTZtmqMlYuZ8wxbZ584e
         hjh1ggqxV5eJdmtPdJLyFhw8bcRjkh6nEAx2R3oSvbRCNFlnlp6Iy0ZwK2FTYHbGSrE6
         a2rJkpnmm6+8M/yM68+/7I3XmGxKPaDDtGY9BKi+YY2J2qtrvSODYoSLDqLlEhyJvw3p
         ANEw==
X-Forwarded-Encrypted: i=1; AHgh+RqyuBJAXdYuL0p6dnK87T5mglHeifVG6jRPC1x57awdiINmrbLRDbS1vS1jKAwz43BwKLPkanQ=@lists.linux.dev
X-Gm-Message-State: AFuF++kq85z1PA5CFj4/HhEx+Gl9BQSeioLCOx20L0rYyMJt6fA54M9s
	K14ay8TNEEDNND8uPqZWAt0iDwjbx/fsOvP0y2D9gFFTqE62jXbofAzK/b2rye2sLc8NVIh2JxG
	pAHb3nKZ+aJ4qlnnZ8YUB0aTr78ucSZWqUEW6UGGFKzdwthLcw+mEft7Eew==
X-Gm-Gg: AR+sD10MRz3a+Xdpv8u1QGylZb63Z1WR9KQgEFiPOnHPX//QOQTNO8FRIGhZFM5blCw
	F9aHsQb9hY+UmELDdnS0V07N1+as8GWeI5f4RyNwPafean+CLwfD5riJrURu8XMp/TasTnqPv+E
	rkVSZvoDabMVG0WEs+d9UEM8loK0d4j8AksOU9M2d2sxWFJBoxzFXzKga47AWn9pcjC5yaGJeaK
	h5d3SI0PdjZHxYWy2P9aGVh32dOSRzB38KQOyJy9hBmMlRFzupkDBFyAFBMb/FgUux5m3nd0bet
	PS4dUgT9qKGTVIyLwwM0k53naaEYd/sKblD0Lr0z2+keUaXnyO/HRufXLoSOTm6PyCr2/yqCVyr
	af2Awd2Wacj/JgkxVWl3Yh+q/7wBtwFXbTVY8ufQVuPYHN0f5
X-Received: by 2002:a17:907:94cd:b0:c20:d90b:2ccf with SMTP id a640c23a62f3a-c250bb7d9ecmr522182066b.7.1787727025192;
        Tue, 25 Aug 2026 23:50:25 -0700 (PDT)
X-Received: by 2002:a17:907:94cd:b0:c20:d90b:2ccf with SMTP id a640c23a62f3a-c250bb7d9ecmr522172866b.7.1787727024169;
        Tue, 25 Aug 2026 23:50:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a9e96bdsm249263366b.55.2026.08.25.23.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 23:50:23 -0700 (PDT)
Message-ID: <07a65f67-0ac5-425a-af3f-e4e38a1a6500@redhat.com>
Date: Wed, 26 Aug 2026 08:50:20 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v7 18/18] arm-qmp-cmds: introspection for ID register
 props
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-19-eric.auger@redhat.com>
 <C950721B-25A3-477F-ABF0-56491A2C968F@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <C950721B-25A3-477F-ABF0-56491A2C968F@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TXbfQbjuAC00sKX9rXEZVFSjO0N1GSQXWXJKuKM7u8o_1787727025
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 8/24/26 1:59 PM, Khushit Shah wrote:
>
>> On 26 Jul 2026, at 8:59 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Implement the capability to query available ID register values by
>> adding SYSREG_* options and values to the cpu model expansion for the
>> host model, if available.
>>
>> Excerpt:
>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>> {"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
>> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
>> "SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
>> "SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
>> ../..
>>
>> This allows the upper stack to detect available writable ID regs and
>> the "host passthrough model" values.
>>
>> It also allows to test some ID reg field values:
>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}
>>
>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!”}}
> My reasoning here is: User never asked to run the CPU model/configuration. The QMP command is supposed to
> return the final prop values which QEMU will set/request from KVM.
>
> Like on x86, the query-cpu-model-expansion type=full model={“host”: “props”: {“amx-tile": true}} does not return
> with error even if host does not have AMX.
>
> But, maybe we can append CpuModelInfo or CpuModelExpansionInfo with optional ‘usable’ boolean. This even
> fills an existing gap, as, query-cpu-definitions cannot take property values.

Refering to docs/system/arm/cpu-features.rst it looks a normal case the
command fails in case settings cannot apply:

See 

(3) Let's try to disable ``aarch64``, which enables the AArch32 CPU
feature::

      (QEMU) query-cpu-model-expansion type=full
model={"name":"max","props":{"aarch64":false}}
      {"error": {
       "class": "GenericError", "desc":
       "'aarch64' feature cannot be disabled unless KVM is enabled and
32-bit EL1 is supported"
      }}

So my understanding is query-cpu-model-expansion is well suited to
settings dry-run

Thanks

Eric

> Warm Regards,
> Khushit
>> The following checks are performed:
>> - the value does not exceed the field size
>> - if the field is associated to enum values, the set value must be one
>>  of those enum values
>> - the value is applied against a scratch vcpu making sure the setting is
>>  not rejected for this host
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
>>
>> v5 -> v6:
>> - add the write capability
>> ---
>> target/arm/arm-qmp-cmds.c | 98 +++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 98 insertions(+)
>>
>> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
>> index 83ec95c290..41fefadcea 100644
>> --- a/target/arm/arm-qmp-cmds.c
>> +++ b/target/arm/arm-qmp-cmds.c
>> @@ -21,6 +21,7 @@
>>  */
>>
>> #include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> #include "qemu/target-info.h"
>> #include "hw/core/boards.h"
>> #include "kvm_arm.h"
>> @@ -30,7 +31,10 @@
>> #include "qapi/qapi-commands-machine.h"
>> #include "qapi/qapi-commands-misc-arm.h"
>> #include "qobject/qdict.h"
>> +#include "qobject/qnum.h"
>> #include "qom/qom-qobject.h"
>> +#include <linux/kvm.h>
>> +#include "system/kvm.h"
>> #include "cpu.h"
>>
>> static GICCapability *gic_cap_new(int version)
>> @@ -84,11 +88,14 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>                                                      Error **errp)
>> {
>>     CpuModelExpansionInfo *expansion_info;
>> +    ObjectPropertyIterator iter;
>>     const QDict *qdict_in;
>> +    ObjectProperty *idregprop;
>>     QDict *qdict_out;
>>     ObjectClass *oc;
>>     Object *obj;
>>     const char *name;
>> +    int fdarray[3];
>>     int i;
>>
>>     if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
>> @@ -133,6 +140,38 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>
>>     obj = object_new(object_class_get_name(oc));
>>
>> +    if (kvm_enabled()) {
>> +        bool pmuv3_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
>> +        bool sve_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
>> +        struct kvm_vcpu_init init = { .target = -1, };
>> +        bool el2_supported = kvm_arm_el2_supported();
>> +        bool pauth_supported;
>> +        int ret;
>> +
>> +        pauth_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
>> +                          kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC);
>> +
>> +        if (sve_supported) {
>> +            init.features[0] |= 1 << KVM_ARM_VCPU_SVE;
>> +        }
>> +        if (el2_supported) {
>> +            init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
>> +        }
>> +        if (pauth_supported) {
>> +            init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
>> +                             1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>> +        }
>> +        if (pmuv3_supported) {
>> +            init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>> +        }
>> +
>> +        ret = kvm_arm_create_scratch_host_vcpu(fdarray, &init);
>> +        if (!ret) {
>> +            error_setg(errp, "failing creating a scratch vcpu");
>> +            return NULL;
>> +        }
>> +    }
>> +
>>     if (model->props) {
>>         Visitor *visitor;
>>         Error *err = NULL;
>> @@ -145,6 +184,49 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>         }
>>
>>         qdict_in = qobject_to(QDict, model->props);
>> +
>> +        for (const QDictEntry *entry = qdict_first(qdict_in);
>> +                 entry != NULL; entry = qdict_next(qdict_in, entry)) {
>> +            const char *key = qdict_entry_key(entry);
>> +            QObject *val_obj = qdict_entry_value(entry);
>> +            ObjectProperty *prop;
>> +            Visitor *v;
>> +            bool success;
>> +            uint64_t val;
>> +
>> +            prop = object_property_find(obj, key);
>> +            if (!prop) {
>> +                error_setg(errp, "%s does not exist!", key);
>> +                return NULL;
>> +            }
>> +
>> +            if (!g_str_has_prefix(key, "SYSREG_")) {
>> +                continue;
>> +            }
>> +
>> +            /* consume the prop to avoid unexpected parameter */
>> +            if (!visit_type_uint64(visitor, key, &val, errp)) {
>> +                return NULL;
>> +            }
>> +
>> +            v = qobject_input_visitor_new(val_obj);
>> +
>> +            if (!object_property_set(obj, key, v, &err)) {
>> +                error_propagate(errp, err);
>> +                visit_free(v);
>> +                return NULL;
>> +            }
>> +
>> +            success = kvm_idreg_write_scratch_vcpu(fdarray[2], v, key,
>> +                                                   prop->opaque, &err);
>> +            if (!success) {
>> +                error_propagate(errp, err);
>> +                visit_free(v);
>> +                return NULL;
>> +            }
>> +            visit_free(v);
>> +        }
>> +
>>         i = 0;
>>         while ((name = cpu_model_advertised_features[i++]) != NULL) {
>>             if (qdict_get(qdict_in, name)) {
>> @@ -160,6 +242,10 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>         if (!err) {
>>             arm_cpu_finalize_features(ARM_CPU(obj), &err);
>>         }
>> +
>> +        if (kvm_enabled()) {
>> +            kvm_arm_destroy_scratch_host_vcpu(fdarray);
>> +        }
>>         visit_end_struct(visitor, NULL);
>>         visit_free(visitor);
>>         if (err) {
>> @@ -190,6 +276,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>         }
>>     }
>>
>> +    object_property_iter_init(&iter, obj);
>> +
>> +    while ((idregprop = object_property_iter_next(&iter))) {
>> +        QObject *value;
>> +
>> +        if (!g_str_has_prefix(idregprop->name, "SYSREG_")) {
>> +            continue;
>> +        }
>> +        value = object_property_get_qobject(obj, idregprop->name, &error_abort);
>> +        qdict_put_obj(qdict_out, idregprop->name, value);
>> +    }
>> +
>>     if (!qdict_size(qdict_out)) {
>>         qobject_unref(qdict_out);
>>     } else {
>> -- 
>> 2.53.0
>>

