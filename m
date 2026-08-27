Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379EC23C4F3
	for <kvmarm@lists.linux.dev>; Thu, 27 Aug 2026 07:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787815133; cv=none; b=WZM9SMDn8R1uFYbT8hXbPM0FbxRjmSHwV/1e+OmtJjuqB8w1li3qtajZLPeT/6SyZ/DZTTc/zG8ez2CScTx6M7q/pRbEGzEezI9IO/IqXpHo0fzJV0XBhc178rPgNomruFJ9siw3GsO71o05QWvIgQlmTMeiVVNrfbks0vd1Kh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787815133; c=relaxed/simple;
	bh=qEwm3RJVYApylcgdmrxEravQECpV+OyLHLNGnx43ucE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sclIX0PsyLjxQiyFStfACQ1mdM/GZGrk7avGncMTkO2lSoGCND2n9qJgg99UpNuFjHl122YuvYrElM4hinbYUzU6l5pthIHhdKADbCnlOClywa5OxswIX/Mru1WGst8k2zOD/YuGvyp8Jd2JzBBGDPPKZ7t8+tzZaiAwXJKbRc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bHKUom02; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bHKUom02"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787815130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qekZvubITxc6u7uOIw6+GbxbzoRzAY6S05FDqtB0Q48=;
	b=bHKUom02qcEM3w8kwoUeo4mKFUxS5zjh/qlppyL3y3ARyv9pDlzhU/t0RaPgZUY6zLbwXs
	lMfe5pMMrBI6dR0IGuph/3Ip7hX6/sI6R2FU8nGSppcmkBEHn1Sfbd3mVWTZ8H5NvnTXcZ
	7f3OgtasbU/lKJDKC6OlRq89keonYOs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-lMIys4SGPvObWiNKrwVJSg-1; Thu, 27 Aug 2026 03:18:48 -0400
X-MC-Unique: lMIys4SGPvObWiNKrwVJSg-1
X-Mimecast-MFC-AGG-ID: lMIys4SGPvObWiNKrwVJSg_1787815127
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4997b060af8so9664195e9.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Aug 2026 00:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787815127; x=1788419927;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qekZvubITxc6u7uOIw6+GbxbzoRzAY6S05FDqtB0Q48=;
        b=QuzizE9TCVm8ArTcOSdyYjLQrNkUWRKM6jNzdPr6BS6NyZtMSWMV91J9gwU9d01hoH
         e1djjCEv5B0KPghwJcDqleqXIux9Ab70NR4X+4IFz52gVJGKT/D/RrdNPZ/9LtW06ain
         zvCov3NJnS0tOf4556VBcurrx1p0dxYSl5SNc0AWIcIY3rA7+MNWtFwG0bDSWRdcJ3s7
         AtRX+vv3aIB6PhJiuqyFtL/9WasvkkUqybcdCjg7SUEOYdnOlVTGmUgoGV1uTtGq9NnE
         t9kPlswrqBNvfoWs/TlMU4+g3L4mBeXTsHbcUGqLlU+g669LxB5HLF6/4m915c1KyOx4
         /nAA==
X-Forwarded-Encrypted: i=1; AHgh+Rr+ZepcDX1TtvtiiCkjxoexJD9+Yz7SjK3fdICItoZVfg1BRCFhL0UTvWJV1TaCJ0OEh60ilws=@lists.linux.dev
X-Gm-Message-State: AFuF++lZTKfnk4EtKgGEce89uIbOiiKDCCg7UbHsjKSI9u+aL2DSJw2d
	Sayb+z5hQjhwwAQeXJ33fkI1xKX5AwqvpFU5XbRMiaxdJZF9E+PFEh+M2No3HOGYHWKV9HCmHYF
	5b1F96Io9Ntm4SyVM1uUrZ3kmdmxViPUDjKYN1efE7+mRW7QEnQZUAMqIOw==
X-Gm-Gg: AR+sD10/YT3AOrZl05V4ouvdUmquhGSApwpnxvOxuBQ0m3BIvz5S+E4OHFgkHnfdUSN
	ED5Zh7gaqmRDFL83PPPgKCLRhM6PiVUwU9e7LfQ+YrLnuDsxDqMtFIvi7i0gpbw/8PMBGuh8ovG
	cq5GZbIC9jghm2BvhNT/J0KtmiLz/pz7jrEMh0KxKammyMjXxmYbDY4g+bENO8fpAPGIafUrGm6
	4W7zx8+I82wfsdxPFvyDYAtDu2Ce7g2rdJs8Gy+IURMHfcfeUVaBh7LjsPtOmbDrpR4Vb8plEck
	+ydqSZpV+pUm4c5raz+qFkcVRU1hTDDPtXXrrLkq2WTIrX8E9xmZ+bLdgjImpBJJ8bMIm8FKw8G
	eJaMwgB/r26damvXTeR+f9/mPBPjqnDGBOiTlrDVjAds=
X-Received: by 2002:a05:600c:8518:b0:499:dc34:bdc with SMTP id 5b1f17b1804b1-499dc6f553emr142837605e9.1.1787815126888;
        Thu, 27 Aug 2026 00:18:46 -0700 (PDT)
X-Received: by 2002:a05:600c:8518:b0:499:dc34:bdc with SMTP id 5b1f17b1804b1-499dc6f553emr142836745e9.1.1787815126461;
        Thu, 27 Aug 2026 00:18:46 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e28f854dsm6721563f8f.36.2026.08.27.00.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2026 00:18:45 -0700 (PDT)
Message-ID: <4beb153b-198b-4a6c-8de5-52334c934e61@redhat.com>
Date: Thu, 27 Aug 2026 09:18:43 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 18/18] arm-qmp-cmds: introspection for ID register
 props
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
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
 <07a65f67-0ac5-425a-af3f-e4e38a1a6500@redhat.com>
 <B9191525-673E-43D9-B7E1-04D05952EE8D@nutanix.com>
 <7bc2c3ae-8192-4622-82b7-6d88f11a6d82@redhat.com>
 <ad46c6f6-3b24-4e4a-870c-6e4c3be06d9a@redhat.com>
 <07D9A2EF-6EA5-4F58-87F4-4DE91E7D5E45@nutanix.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <07D9A2EF-6EA5-4F58-87F4-4DE91E7D5E45@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w3XbFx3t9tlzm3VPjoYA7wSC2XFY2lhUlLsakSYWPXE_1787815127
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/27/26 7:30 AM, Khushit Shah wrote:
> 
> 
>> On 26 Aug 2026, at 10:17 PM, Eric Auger <eauger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>>
>>
>> On 8/26/26 2:08 PM, Eric Auger wrote:
>>>
>>>
>>> On 8/26/26 1:27 PM, Khushit Shah wrote:
>>>>
>>>>> On 26 Aug 2026, at 12:20 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>>>>
>>>>> !-------------------------------------------------------------------|
>>>>> CAUTION: External Email
>>>>>
>>>>> |-------------------------------------------------------------------!
>>>>>
>>>>> Hi Khushit,
>>>>>
>>>>> On 8/24/26 1:59 PM, Khushit Shah wrote:
>>>>>>> On 26 Jul 2026, at 8:59 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>>>>>>
>>>>>>> !-------------------------------------------------------------------|
>>>>>>> CAUTION: External Email
>>>>>>>
>>>>>>> |-------------------------------------------------------------------!
>>>>>>>
>>>>>>> From: Cornelia Huck <cohuck@redhat.com>
>>>>>>>
>>>>>>> Implement the capability to query available ID register values by
>>>>>>> adding SYSREG_* options and values to the cpu model expansion for the
>>>>>>> host model, if available.
>>>>>>>
>>>>>>> Excerpt:
>>>>>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>>>>>>> {"return": {"model": {"name": "host", "props": {"SYSREG_ID_AA64PFR0_EL1_EL3": 1,
>>>>>>> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0, "SYSREG_CTR_EL0_L1Ip": 3,
>>>>>>> "SYSREG_MIDR_EL1_PartNum": 3407, "SYSREG_CTR_EL0_DminLine": 4,
>>>>>>> "SYSREG_ID_AA64MMFR0_EL1_PARange": 5, "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0
>>>>>>> ../..
>>>>>>>
>>>>>>> This allows the upper stack to detect available writable ID regs and
>>>>>>> the "host passthrough model" values.
>>>>>>>
>>>>>>> It also allows to test some ID reg field values:
>>>>>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x13}}
>>>>>>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x13) exceeds length of field (4)!"}}
>>>>>>>
>>>>>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host","props":{"SYSREG_ID_AA64ISAR0_EL1_DP":0x2}}
>>>>>>> {"error": {"class": "GenericError", "desc": "idreg SYSREG_ID_AA64ISAR0_EL1_DP set value (0x2) does not match any arch valid enum value!”}}
>>>>>> My reasoning here is: User never asked to run the CPU model/configuration. The QMP command is supposed to
>>>>>> return the final prop values which QEMU will set/request from KVM.
>>>>>>
>>>>>> Like on x86, the query-cpu-model-expansion type=full model={“host”: “props”: {“amx-tile": true}} does not return
>>>>>> with error even if host does not have AMX.
>>>>>>
>>>>>> But, maybe we can append CpuModelInfo or CpuModelExpansionInfo with optional ‘usable’ boolean. This even
>>>>>> fills an existing gap, as, query-cpu-definitions cannot take property values.
>>>>> Refering to docs/system/arm/cpu-features.rst it looks a normal case the
>>>>> command fails in case settings cannot apply:
>>>>>
>>>>> See 
>>>>>
>>>>> (3) Let's try to disable ``aarch64``, which enables the AArch32 CPU
>>>>> feature::
>>>>>
>>>>>      (QEMU) query-cpu-model-expansion type=full
>>>>> model={"name":"max","props":{"aarch64":false}}
>>>>>      {"error": {
>>>>>       "class": "GenericError", "desc":
>>>>>       "'aarch64' feature cannot be disabled unless KVM is enabled and
>>>>> 32-bit EL1 is supported"
>>>>>      }}
>>>>>
>>>>> So my understanding is query-cpu-model-expansion is well suited to
>>>>> settings dry-run
>>>> I don't really like the current handling from the named models
>>>> perspective.
>>>>
>>>> query-cpu-model-expansion should not be performing host-compatibility
>>>> checks. We should decouple applying the requested props from asking
>>>> whether this host can actually run them. x86 and s390x are designed
>>>> the same way.
>>>>
>>>> While this patch only dry-runs SYSREG_* props if they are passed,
>>>> once named models exist:
>>>>  query-cpu-model-expansion type=full model={"name":"ampere-1a"}
>>>>
>>>> should not fail because it is not host-compatible. It should still
>>>> return the model's SYSREG prop values on a host that cannot
>>>> realise it.
>> Isn't it the role of query-cpu-definitions:
> 
> Nope, query-cpu-definitions’s unavailable-features only list the
> problematic properties. While query-cpu-model-expansion should give
> the full ID reg view (all SYSREG props)
OK, for named vcpu models you can implement query-cpu-model-expansion
without scratch vcpu model validation and use this latter in
query-cpu-definitions’s unavailable-features. For custom host,
query-cpu-model-expansion can have a different implementation.

Thanks

Eric


> 
> Warm Regards,
> Khushit
>> # @unavailable-features: List of properties that prevent the CPU model
>> #     from running in the current host.  (since 2.8)
>>
>> in qapi/machine.json
> 
>> Thanks
>>
>> Eric
>>
>>> Looking at qapi/machine.json, 
>>>
>>> # Errors:
>>> #     - if expanding CPU models is not supported
>>> #     - if the model cannot be expanded
>>> #     - if the model contains an unknown CPU definition name, unknown
>>> #       properties or properties with a wrong type
>>> #     - if an expansion type is not supported
>>>
>>> Maybe we could use the "static" parameter which is not currently
>>> implement on ARM.
>>>
>>> # * machine options (including accelerator): in some architectures,
>>> #   CPU models may look different depending on machine and accelerator
>>> #   options.  (Except for CPU models reported as "static" in
>>> #   `query-cpu-definitions`.)
>>>
>>> in case you use static we don't expand against the accelerator, while
>>> with full we would do?
>>>
>>> Thanks
>>>
>>> Eric
>>>
>>>
>>>
>>>
>>>>
>>>> Warm Regards,
>>>> Khushit
>>>>
>>>>> Thanks
>>>>>
>>>>> Eric
>>>>>
>>>>>> Warm Regards,
>>>>>> Khushit
>>>>>>> The following checks are performed:
>>>>>>> - the value does not exceed the field size
>>>>>>> - if the field is associated to enum values, the set value must be one
>>>>>>> of those enum values
>>>>>>> - the value is applied against a scratch vcpu making sure the setting is
>>>>>>> not rejected for this host
>>>>>>>
>>>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>>>>>
>>>>>>> ---
>>>>>>>
>>>>>>> v5 -> v6:
>>>>>>> - add the write capability
>>>>>>> ---
>>>>>>> target/arm/arm-qmp-cmds.c | 98 +++++++++++++++++++++++++++++++++++++++
>>>>>>> 1 file changed, 98 insertions(+)
>>>>>>>
>>>>>>> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
>>>>>>> index 83ec95c290..41fefadcea 100644
>>>>>>> --- a/target/arm/arm-qmp-cmds.c
>>>>>>> +++ b/target/arm/arm-qmp-cmds.c
>>>>>>> @@ -21,6 +21,7 @@
>>>>>>> */
>>>>>>>
>>>>>>> #include "qemu/osdep.h"
>>>>>>> +#include "qemu/error-report.h"
>>>>>>> #include "qemu/target-info.h"
>>>>>>> #include "hw/core/boards.h"
>>>>>>> #include "kvm_arm.h"
>>>>>>> @@ -30,7 +31,10 @@
>>>>>>> #include "qapi/qapi-commands-machine.h"
>>>>>>> #include "qapi/qapi-commands-misc-arm.h"
>>>>>>> #include "qobject/qdict.h"
>>>>>>> +#include "qobject/qnum.h"
>>>>>>> #include "qom/qom-qobject.h"
>>>>>>> +#include <linux/kvm.h>
>>>>>>> +#include "system/kvm.h"
>>>>>>> #include "cpu.h"
>>>>>>>
>>>>>>> static GICCapability *gic_cap_new(int version)
>>>>>>> @@ -84,11 +88,14 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>>>>>                                                    Error **errp)
>>>>>>> {
>>>>>>>   CpuModelExpansionInfo *expansion_info;
>>>>>>> +    ObjectPropertyIterator iter;
>>>>>>>   const QDict *qdict_in;
>>>>>>> +    ObjectProperty *idregprop;
>>>>>>>   QDict *qdict_out;
>>>>>>>   ObjectClass *oc;
>>>>>>>   Object *obj;
>>>>>>>   const char *name;
>>>>>>> +    int fdarray[3];
>>>>>>>   int i;
>>>>>>>
>>>>>>>   if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
>>>>>>> @@ -133,6 +140,38 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>>>>>
>>>>>>>   obj = object_new(object_class_get_name(oc));
>>>>>>>
>>>>>>> +    if (kvm_enabled()) {
>>>>>>> +        bool pmuv3_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PMU_V3);
>>>>>>> +        bool sve_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
>>>>>>> +        struct kvm_vcpu_init init = { .target = -1, };
>>>>>>> +        bool el2_supported = kvm_arm_el2_supported();
>>>>>>> +        bool pauth_supported;
>>>>>>> +        int ret;
>>>>>>> +
>>>>>>> +        pauth_supported = kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
>>>>>>> +                          kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC);
>>>>>>> +
>>>>>>> +        if (sve_supported) {
>>>>>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_SVE;
>>>>>>> +        }
>>>>>>> +        if (el2_supported) {
>>>>>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
>>>>>>> +        }
>>>>>>> +        if (pauth_supported) {
>>>>>>> +            init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
>>>>>>> +                             1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>>>>>>> +        }
>>>>>>> +        if (pmuv3_supported) {
>>>>>>> +            init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>>>>>>> +        }
>>>>>>> +
>>>>>>> +        ret = kvm_arm_create_scratch_host_vcpu(fdarray, &init);
>>>>>>> +        if (!ret) {
>>>>>>> +            error_setg(errp, "failing creating a scratch vcpu");
>>>>>>> +            return NULL;
>>>>>>> +        }
>>>>>>> +    }
>>>>>>> +
>>>>>>>   if (model->props) {
>>>>>>>       Visitor *visitor;
>>>>>>>       Error *err = NULL;
>>>>>>> @@ -145,6 +184,49 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>>>>>       }
>>>>>>>
>>>>>>>       qdict_in = qobject_to(QDict, model->props);
>>>>>>> +
>>>>>>> +        for (const QDictEntry *entry = qdict_first(qdict_in);
>>>>>>> +                 entry != NULL; entry = qdict_next(qdict_in, entry)) {
>>>>>>> +            const char *key = qdict_entry_key(entry);
>>>>>>> +            QObject *val_obj = qdict_entry_value(entry);
>>>>>>> +            ObjectProperty *prop;
>>>>>>> +            Visitor *v;
>>>>>>> +            bool success;
>>>>>>> +            uint64_t val;
>>>>>>> +
>>>>>>> +            prop = object_property_find(obj, key);
>>>>>>> +            if (!prop) {
>>>>>>> +                error_setg(errp, "%s does not exist!", key);
>>>>>>> +                return NULL;
>>>>>>> +            }
>>>>>>> +
>>>>>>> +            if (!g_str_has_prefix(key, "SYSREG_")) {
>>>>>>> +                continue;
>>>>>>> +            }
>>>>>>> +
>>>>>>> +            /* consume the prop to avoid unexpected parameter */
>>>>>>> +            if (!visit_type_uint64(visitor, key, &val, errp)) {
>>>>>>> +                return NULL;
>>>>>>> +            }
>>>>>>> +
>>>>>>> +            v = qobject_input_visitor_new(val_obj);
>>>>>>> +
>>>>>>> +            if (!object_property_set(obj, key, v, &err)) {
>>>>>>> +                error_propagate(errp, err);
>>>>>>> +                visit_free(v);
>>>>>>> +                return NULL;
>>>>>>> +            }
>>>>>>> +
>>>>>>> +            success = kvm_idreg_write_scratch_vcpu(fdarray[2], v, key,
>>>>>>> +                                                   prop->opaque, &err);
>>>>>>> +            if (!success) {
>>>>>>> +                error_propagate(errp, err);
>>>>>>> +                visit_free(v);
>>>>>>> +                return NULL;
>>>>>>> +            }
>>>>>>> +            visit_free(v);
>>>>>>> +        }
>>>>>>> +
>>>>>>>       i = 0;
>>>>>>>       while ((name = cpu_model_advertised_features[i++]) != NULL) {
>>>>>>>           if (qdict_get(qdict_in, name)) {
>>>>>>> @@ -160,6 +242,10 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>>>>>       if (!err) {
>>>>>>>           arm_cpu_finalize_features(ARM_CPU(obj), &err);
>>>>>>>       }
>>>>>>> +
>>>>>>> +        if (kvm_enabled()) {
>>>>>>> +            kvm_arm_destroy_scratch_host_vcpu(fdarray);
>>>>>>> +        }
>>>>>>>       visit_end_struct(visitor, NULL);
>>>>>>>       visit_free(visitor);
>>>>>>>       if (err) {
>>>>>>> @@ -190,6 +276,18 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>>>>>>>       }
>>>>>>>   }
>>>>>>>
>>>>>>> +    object_property_iter_init(&iter, obj);
>>>>>>> +
>>>>>>> +    while ((idregprop = object_property_iter_next(&iter))) {
>>>>>>> +        QObject *value;
>>>>>>> +
>>>>>>> +        if (!g_str_has_prefix(idregprop->name, "SYSREG_")) {
>>>>>>> +            continue;
>>>>>>> +        }
>>>>>>> +        value = object_property_get_qobject(obj, idregprop->name, &error_abort);
>>>>>>> +        qdict_put_obj(qdict_out, idregprop->name, value);
>>>>>>> +    }
>>>>>>> +
>>>>>>>   if (!qdict_size(qdict_out)) {
>>>>>>>       qobject_unref(qdict_out);
>>>>>>>   } else {
>>>>>>> -- 
>>>>>>> 2.53.0
> 
> 

