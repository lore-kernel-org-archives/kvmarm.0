Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0773BF68F
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786721696; cv=none; b=BRHDBgoNAsI66wPH9GFjQwwdmZxUMX7TVoiTMzWqBxg5ryhQk8PMytBGa4NNuBOnMc+Gf2E8UHScUezwqDAQqzFsU2jIoDLFxArh9R5eWwISdjEuXgkmXH/VmaG8PNGV5d8HTVP6mIl6uYnTNpSPAAthzdBsoL61KAvmiZrxHnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786721696; c=relaxed/simple;
	bh=l1YkUpH2s8LKuu98nYU9z8hqWrhTTSLvhFGcnzShB+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UENFfSeYpIDKkIRPiqZ2widB3uxuZT8HqdYk9WhvAbz6loeSJqt4dJf1zamuIt91mc9XiZRtPZ4Y+SNO0BvH4l+B55Vo4gPXZoIX/v70vZqu175mpTXDSS36c7tSg5ZO1+RITdjof3z/iiVo8qs6cDNFTeLOsN/OOcOgBhcJQnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xx0bjIwH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xx0bjIwH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786721693;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7okoVJBLZWESdwgLg7Z5BVxv/ezHszMZAamDbVRePaQ=;
	b=Xx0bjIwHtuoxGa0tiwRMMMUwFyMhz2DRNNorgO4Tj7+soZwFLKFey7t1ftU1elo7xMQtu2
	6e2nSogN7Lhuu7euc4fGSFlPIjNHHKMWEEF0na9NWJEJOeUSYDH8kWJT0aoPTMEZzXKSag
	k+8CLsanAOJXxM9xjcY5+hfEiv85tL8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-kFm6cWhVNLiNTtyyVC-4Cw-1; Fri, 14 Aug 2026 11:34:52 -0400
X-MC-Unique: kFm6cWhVNLiNTtyyVC-4Cw-1
X-Mimecast-MFC-AGG-ID: kFm6cWhVNLiNTtyyVC-4Cw_1786721691
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4994aebe932so11921305e9.3
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 08:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786721691; x=1787326491;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7okoVJBLZWESdwgLg7Z5BVxv/ezHszMZAamDbVRePaQ=;
        b=qEQ5oU1t1AwDJMjf1BEY99MFe+hQyWCtgM1wQaMTJyGYFk+9xHDOTEcoXlXUgUx3KA
         G5CBmzZ6Oj2IDZJCx4JAqNnsFHQZThWYnL9/3941r/Xja4ld0kByM6HSgeaRN02Iq+gm
         2AU8MS1FBOcyR5iaLiAzGP0DBfL2x9hMkFoj714WSipL1SHkIPgKQCSvHuRWfCeS60Zb
         qhSUqJzjT64Kmik/V5X0/kUhyFod4IoMrW1gbl8nKGERZhP13RnXM7/pFDUeqKbmhSD9
         mH5nHFjdKa4pg3ymUQnyrP0T8RtAYM3MtbSZ5H4JT7i96yR1Mse1OqAsyKcsDRTCidVj
         5lfw==
X-Forwarded-Encrypted: i=1; AHgh+Rrsajw+FD7wcBryG05vq9MlCsLnSBOCsTtiTK2s+VYCc3Jw1Gu/in6STUQeQTf5yngKPjLXcEQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQOOBo3t6oHV0ovHRWl6f190+RURgOBttJURjholgTCFyARxjS
	+wFwMxjD7VpFJKb+y9wxZFvdIWbRHt/gJswQBXJdP2TpjDFWYEukZ62p/IvL5MEmPIla2WYBjxp
	+c3AyypG4HFwCn7tcR9a0xL36AYyygm23ko/XEJM0sOdLeZHlD8q9D5ZfSA==
X-Gm-Gg: AR+sD11/5wOANiwqMCH+Nr6CCj9QrLDhG6cphiDQd33J5p5jcI00DZkWRN2dp4tN5xG
	Dq5Qx9PZTuEN6p74JpSwvQFNuQbDgEoHa5/e/2Fh5+bPu7QP4EvLnly/mKlTtAwlOnSZs6qyuR8
	EDmUTgjMxALVat/TDV+ENoELdCNNw2+ylfhssLAwcK9TMQaWcxlNlyfSuD+UWROvWQYa8TEUVhp
	NgLKsGFl+gX+KOb1Hxr7gozaSZ5/nYjRfYfeA4M5XkCWOcOL4zUuz9lFj2g/LRaR9gb5TPS8onA
	WAOA4mexColSvwyWOGDHfOyGgsSY9GEqqf0zAJ4FGc+OuAQOmIQB3+3yAmacK3mZrJJZpJN7FUJ
	adD3dtYlVFgOH07/JVWOy2bgG06vO2Y7w6NSIcWDVo2qiKfVH
X-Received: by 2002:a05:600c:4e13:b0:498:11b5:3ff7 with SMTP id 5b1f17b1804b1-499879bd2e1mr94162185e9.18.1786721690582;
        Fri, 14 Aug 2026 08:34:50 -0700 (PDT)
X-Received: by 2002:a05:600c:4e13:b0:498:11b5:3ff7 with SMTP id 5b1f17b1804b1-499879bd2e1mr94161455e9.18.1786721690078;
        Fri, 14 Aug 2026 08:34:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49988ae8af3sm52203945e9.4.2026.08.14.08.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 08:34:48 -0700 (PDT)
Message-ID: <0cb9dba3-c905-4e2d-a3e9-539dbf2ea787@redhat.com>
Date: Fri, 14 Aug 2026 17:34:46 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 14/19] target/arm/kvm: compute supported values for
 ID register fields
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
 <20260716213858.609699-15-khushit.shah@nutanix.com>
 <fe76f638-81aa-43cf-aafb-c774ab1902f8@redhat.com>
 <82F566CD-CC65-4368-AE92-3A2E637CC27A@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <82F566CD-CC65-4368-AE92-3A2E637CC27A@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S43fTjQz47YUuRMlkILVkIdmTzvcy4G6r7icEmr5kqc_1786721691
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/5/26 11:58 AM, Khushit Shah wrote:
>
>> On 26 Jul 2026, at 7:52 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Hi Khushit,
>>
>> On 7/16/26 11:38 PM, Khushit Shah wrote:
>>> Add arm_field_get_supported_values() which, for a given ID register
>>> field, builds the set of values KVM allows it to take on the live host.
>>>
>>> Non-writable fields are pinned to the host value. Writable fields follow
>>> their per field constraints. This function likely needs change when
>>> KVM starts exposing a new writable field that is not lower-safe, hence,
>>> the special handling of TGranX_2/SpecSEI/L1Ip/MIDR/REVIDR/AIDR.
>> so this looks quite risky. 
> I agree.
>
> What are your thoughts on having a authoritative list in QEMU of all
> writable fields? No matter what KVM exposes as writable, actual fields
> we allow to be writable will be intersection of KVM writable + QEMU
> writable. When The QEMU list is updated we make sure things like this
> function is updated.
>
> This get’s rid of cases where we silently support writing to a field.
> It is similar to x86, QEMU only supports writing to specific CPUID
> leafs (by the defined Properties) and not just any CPUID leafs.
>
>>> Cross-field constraints are not modelled; for example ID_AA64ZFR0_EL1
>>> is gated by SVE. Reproducing every inter-field dependency in QEMU
>>> would only duplicate KVM's logic and drift out of sync with it.
>> Isn't qmp_query_cpu_model_expansion sufficient? In general upper layers
>> will try to apply raw named models. If ajustements are needed between
>> source and destination, we know field candidate values (either the
>> source or dest one) and this latter can be directly tried using
>> qmp_query_cpu_model_expansion write. On top of that
>> qmp_query_cpu_model_expansion can be directly checked against a scratch
>> vcpu reusing the logic implemented at kernel level.
> I am not sure if it is acceptable for query_cpu_model_expansion should fail
> if model is not realisable. On at least x86 it does not. It just returns the
> state which QEMU would request KVM for the given configurations.
>
> Ref:
> https://github.com/qemu/qemu/blob/3e3ccab106f879b1512f8e0d51a827dd4de30e22/target/i386/cpu.c#L9689

I need to further study that. I will come back to you.

Currently with v7 you get:
(QEMU) query-cpu-model-expansion type=full
model={"name":"host","props":{"SYSREG_ID_AA64MMFR1_EL1_AFP":0x1}}
{"error": {"class": "GenericError", "desc": "failed to apply new value
0x1 for field AFP (previous is 0x0): Invalid argument"}}

This can be implemented elsewhere though

Eric
>
> cpu-definitions is maybe a better candidate for algo you are describing, but
> it will not take the user overrides into considerations and only say if a
> base model is usable or not
>
>
>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>> ---
>>> target/arm/kvm.c     | 99 ++++++++++++++++++++++++++++++++++++++++++++
>>> target/arm/kvm_arm.h | 26 ++++++++++++
>>> 2 files changed, 125 insertions(+)
>>>
>>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>> index c38b99cfce..8f452f9570 100644
>>> --- a/target/arm/kvm.c
>>> +++ b/target/arm/kvm.c
>>> @@ -1262,6 +1262,105 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
>>>     return true;
>>> }
>>>
>>> +static bool arm_field_is_signed(const ARM64SysRegField *field)
>>> +{
>>> +    return field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4")    ||
>>> +           field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64")   ||
>>> +           field_matches(field, ID_MMFR0_EL1_IDX, "InnerShr")      ||
>>> +           field_matches(field, ID_MMFR0_EL1_IDX, "OuterShr")      ||
>>> +           field_matches(field, ID_AA64DFR0_EL1_IDX, "DoubleLock") ||
>>> +           field_matches(field, ID_AA64DFR0_EL1_IDX, "PMUVer")     ||
>>> +           field_matches(field, ID_DFR0_EL1_IDX, "PerfMon")        ||
>>> +           field_matches(field, ID_AA64PFR1_EL1_IDX, "MTE_frac")   ||
>>> +           field_matches(field, ID_AA64MMFR4_EL1_IDX, "E2H0")      ||
>>> +           field_matches(field, ID_DFR1_EL1_IDX, "MTPMU")          ||
>>> +           field_matches(field, ID_AA64PFR0_EL1_IDX, "FP")         ||
>>> +           field_matches(field, ID_AA64PFR0_EL1_IDX, "AdvSIMD");
>> Can't we extract this from Register.json instead?
> AFAIK, There is not signedness data in Register.json
>
>>> +}
>>> +
>>> +static void ranges_add(GArray *ranges, uint64_t min, uint64_t max)
>>> +{
>>> +    ArmFieldRange r = { .min = min, .max = max };
>>> +    g_array_append_val(ranges, r);
>>> +}
>>> +
>>> +void arm_field_get_supported_values(const ARM64SysRegField *field,
>>> +                                    const ARMISARegisters *host_isar,
>>> +                                    ArmFieldValueSet **value_set)
>>> +{
>>> +    bool is_signed = arm_field_is_signed(field);
>>> +    uint64_t host = extract64(host_isar->idregs[field->index],
>>> +                              field->shift, field->length);
>>> +    GArray *ranges = g_array_new(false, false, sizeof(ArmFieldRange));
>>> +
>>> +    /* A non-writable field can only ever hold the host value. */
>>> +    if (!arm_field_is_writable(field)) {
>>> +        ranges_add(ranges, host, host);
>>> +        goto done;
>> you already get this info from qmp_query_cpu_model_expansion
> Can you please elaborate how? I thought the current qmp_query_cpu_model_expansion
> (Your v6) only returns the writable field.
> (I have not yet looked at v7)
>
>>> +    }
>>> +
>>> +    if (field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran4_2")  ||
>>> +        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran16_2") ||
>>> +        field_matches(field, ID_AA64MMFR0_EL1_IDX, "TGran64_2")) {
>>> +        /* Either support the host value or the "off" value */
>>> +        ranges_add(ranges, host, host);
>>> +        if (host != 1) { /* 1 = "off" */
>>> +            ranges_add(ranges, 1, 1);
>>> +        }
>>> +    } else if (field_matches(field, CTR_EL0_IDX, "L1Ip")) {
>>> +        /* Only safe to downgrade to VIPT, other values are reserved. */
>>> +        ranges_add(ranges, host, host);
>>> +        if (host != 2) { /* 2 = "VIPT" */
>>> +            ranges_add(ranges, 2, 2);
>>> +        }
>>> +    } else if (field_matches(field, ID_AA64MMFR1_EL1_IDX, "SpecSEI") ||
>>> +               field_matches(field, ID_MMFR4_EL1_IDX, "SpecSEI")) {
>>> +        /* It is safe to upgrade SpecSEI to 1, other values are reserved. */
>>> +        ranges_add(ranges, host, host);
>>> +        if (host != 1) {
>>> +            ranges_add(ranges, 1, 1);
>>> +        }
>>> +    } else if (field->index == MIDR_EL1_IDX ||
>>> +               field->index == REVIDR_EL1_IDX ||
>>> +               field->index == AIDR_EL1_IDX) {
>>> +        /*
>>> +         * No restriction on value that can be set for implementation ID
>>> +         * registers fields.
>>> +         */
>>> +        uint64_t max = 0;
>>> +        if (field->length == 64) {
>>> +            max = ~0ULL;
>>> +        } else {
>>> +            max = (1ULL << field->length) - 1;
>>> +        }
>>> +        ranges_add(ranges, 0, max);
>>> +    } else {
>>> +        /*
>>> +         * After handling the special cases, other writable fields are
>>> +         * either lower-safe or signed lower-safe.
>>> +         */
>>> +        if (field->arch_vals_count) {
>>> +            for (uint32_t i = 0; i < field->arch_vals_count; i++) {
>>> +                uint64_t av = field->arch_vals[i].value;
>>> +                int64_t v = is_signed ?
>>> +                    sextract64(av, 0, field->length) : (int64_t)av;
>>> +                int64_t hv = is_signed ?
>>> +                    sextract64(host, 0, field->length) : (int64_t)host;
>>> +                if (v <= hv) {
>>> +                    ranges_add(ranges, av, av);
>>> +                }
>>> +            }
>>> +        } else {
>>> +            g_assert(!is_signed); /* No signed field with no arch vals */
>>> +            ranges_add(ranges, 0, host);
>>> +        }
>>> +    }
>>> +done:
>>> +    *value_set = g_new0(ArmFieldValueSet, 1);
>>> +    (*value_set)->n_ranges = ranges->len;
>>> +    (*value_set)->ranges = (ArmFieldRange *)g_array_free(ranges, false);
>>> +}
>>> +
>>> static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
>>> {
>>>     /*
>>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>>> index 133a026036..9f15c91c4e 100644
>>> --- a/target/arm/kvm_arm.h
>>> +++ b/target/arm/kvm_arm.h
>>> @@ -143,6 +143,32 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
>>> void kvm_arm_add_vcpu_properties(ARMCPU *cpu);
>>>
>>> typedef struct ARM64SysReg ARM64SysReg;
>>> +typedef struct ARM64SysRegField ARM64SysRegField;
>>> +typedef struct ARMISARegisters ARMISARegisters;
>>> +
>>> +typedef struct ArmFieldRange {
>>> +    uint64_t min;
>>> +    uint64_t max;
>>> +} ArmFieldRange;
>>> +
>>> +typedef struct ArmFieldValueSet {
>>> +    ArmFieldRange *ranges;
>>> +    size_t n_ranges;
>>> +} ArmFieldValueSet;
>>> +
>>> +/**
>>> + * arm_field_get_supported_values:
>>> + * @field: The field to get the supported values for
>>> + * @host_isar: The host ISAR registers
>>> + * @value_set: The set of supported values for the @field
>>> + *
>>> + * Will be allocated and filled in with the supported values for the @field
>>> + * based on the host_isar and whether the field is writable or not.
>>> + * The caller must free the value_set.
>>> + */
>>> +void arm_field_get_supported_values(const ARM64SysRegField *field,
>>> +                                    const ARMISARegisters *host_isar,
>>> +                                    ArmFieldValueSet **value_set);
>>>
>>> /**
>>>  * kvm_arm_steal_time_finalize:
>> Thanks
>>
>> Eric
>

