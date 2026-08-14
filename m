Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF2B36B900
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 14:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786716300; cv=none; b=Ou/bXjzu1o8R8Zste0LcAogb4ocMf8Zqed1IXGl7akvmzYXJ2R7vpPyM+/am59Xce92q1ipEmiOoDvxYnEk3Wi3E4vT2eZXvPMQ4KIZ0igjpcMNKcbP3694V4S45A0AddJTYKWL/LE+yPuqSbdjTE8Fm5F7r+os/kP1GfkYbxBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786716300; c=relaxed/simple;
	bh=9ZMGMfmUm19BRrF9K1xWQcs3r4bU9UWHqb216uOySOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kS9YvqYrd/6E7h1cJV3UB9d1FJamUoEx6mjpZ7i0wHPatKXGRB801QporthsjhoWGacK+tBaOhP/7/5nhnYeXnQvqJpDd7PGRmV6G/dHBvIS+Rc2zG1hpoBvJPCj28fAh3UVN/94IF0Ll+gFyAVEy/NwtEXRkBeWIrJGBz+2kts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O4L3ItcG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O4L3ItcG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786716296;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z03wWnIUx6uQG21Lbd5gGDlrmG0/hLGULn7a2fJNKlU=;
	b=O4L3ItcGhEufyWUQ1UZpFBYUtpy2KapSyPtCXf0VNqqMDLH4/z1TjkPu7Ht3a/uDScpfrv
	fIKt1Dc2n1fyidSpCRl0wvAE5eJ/h93aw0xrqHXvPLfCw3oBVUFHRWjIgat//bPBHTBlfA
	JoRnE5Qj9mAsCmGB+HqZFPWcLjzE1Xg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-CpEJFhg7McWcH4tH_DGptg-1; Fri, 14 Aug 2026 10:04:54 -0400
X-MC-Unique: CpEJFhg7McWcH4tH_DGptg-1
X-Mimecast-MFC-AGG-ID: CpEJFhg7McWcH4tH_DGptg_1786716293
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-495474a5fbcso9489235e9.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 07:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786716293; x=1787321093;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z03wWnIUx6uQG21Lbd5gGDlrmG0/hLGULn7a2fJNKlU=;
        b=W9jLHeyqxlBhqvV3aZII+Px4HBT5A3GvcM8fq00+m+OHiqxDj/ZmsWWJOVr5wI1Kxb
         dEW12dJMwOofNwiHVghLVez9WtEgqp4TGqLWbgUiL9vybKyVpX9V74K9P58HSHouTTYL
         QT+dDbgxF+YVecCSkE49zdvATQB1ozDLrtm5KmIulz6/vsRwU2Mg+8eZu4Tueol30jGV
         8I5ZmpRjYVsagvgy4tSU506p4GbDX7wiVMv/IE1IZ01oz4RgKovnffHS4pfSIN16lF9C
         Uy7uwvfcOLmKW8H7GSi8IwiPUiugQ4x4NzDjUzUzoh+aFGi6LZGcBwL2ScyjjYN/YIT4
         cCXg==
X-Forwarded-Encrypted: i=1; AHgh+RpmwuinmgR5xfZkLJSelafR9uxy9KOAeQIYkGXnsfF+jZ9Scr0EuC+hohpE8JSK2gk/sQPTvN4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiYOxiPob+YsIanLEQl70e/GcFX1C6mi6Pf6J4zz+o4LuAeudI
	F4xVUVGRV+VeoDDRWYh+CgYfHt5efyhm79w3yp+6QkSlXmzuV2KKJRv2vzFWKm8c9v/NLxnkPwQ
	HEq+wB0VNHNo09m2T69/JUA6+vYV8eIt/uaPrSngxSKmLeaW/dgYwd9SPJQ==
X-Gm-Gg: AR+sD13X75n3fOOOl4THFTuNbGJKYOma1aHPGsYejukrpiZCOBUstqh4PrbRhgrBGU7
	DmOGAscYCDjga3G0xOF2v7Pv6Edr8XFPDcpWIleQn266LKTPMy12Q/wYugHo6VSwbDQy68CToCN
	H+y87QnZ4w/UWogu2h7gBU4EGopxysoo2D9ns2aa6he/FR0cRi/Upd24xD4rbmVazg/aePlDoQ8
	3bCSae+C/32ARh2i7w97m0+++fjk94u9S/EsvhoxBUr6rns5JwS1Sw4Cs+ymSurAypbW+s13E/8
	hIx68nWNII8RysyTID1N6WrR77cUs+pY7Mean9Q/0FWyyHaIqtGr0dIyN/EQRF2+PUNzwDT8sKY
	Nz5sDBKqu6fTOfY1UhRpl7Wtj5CH23jkelodpzU6uU0NQsBDq
X-Received: by 2002:a05:600c:68ca:b0:495:641a:bd3f with SMTP id 5b1f17b1804b1-49987995272mr67301675e9.13.1786716293225;
        Fri, 14 Aug 2026 07:04:53 -0700 (PDT)
X-Received: by 2002:a05:600c:68ca:b0:495:641a:bd3f with SMTP id 5b1f17b1804b1-49987995272mr67300685e9.13.1786716292710;
        Fri, 14 Aug 2026 07:04:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49988ae8af3sm47474275e9.4.2026.08.14.07.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 07:04:52 -0700 (PDT)
Message-ID: <e01c8e3b-f26e-47c5-b268-d5b145f1eb91@redhat.com>
Date: Fri, 14 Aug 2026 16:04:50 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 08/19] target/arm/kvm: Handle writeback for special
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
 <20260716213858.609699-9-khushit.shah@nutanix.com>
 <9fe4814a-5479-4180-9a61-7d2d5d2fbb92@redhat.com>
 <738A044F-B98E-4F94-8CD8-F19135FDBF57@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <738A044F-B98E-4F94-8CD8-F19135FDBF57@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XrD7ttG3IJTaEH8gS62Z7CawUa-dqs8N7V6eLqEbVMg_1786716293
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 8/3/26 6:03 PM, Khushit Shah wrote:
>
>> On 22 Jul 2026, at 5:35 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Hi Khushit,
>> On 7/16/26 11:38 PM, Khushit Shah wrote:
>>> Some fields should not be written back to KVM for various reasons:
>>> - ID_AA64PFR0_EL1.GIC / ID_PFR1_EL1.GIC are fabricated by KVM based on
>>>   the gic-version property.
>> so this is part of the overall handling of legacy composite options
>> versus sysreg settings. To be the fact they both are consistent should
>> be enforced upfront.
> I have one idea on how to handle this:
> - After we finalise cpu features, we recheck each command line prop
>           passed. The final idregs[]’s prop value should be same as the user
>           provided one from the cmdline.
>     For e.g., invalid configurations like:
>         -cpu host,sve=on,SYSREG_ID_AA64PFR0_EL1_SVE=0
>     Or
>         -cpu host,pauth=off,SYSREG_ID_AA64ISAR1_EL1_APA=2
>
>     will be caught after finalise as both of those cannot be true at
>     the same time.
>
> If this makes sense, I can implement it for v4.

Yes consistency checking between low level props and legacy composite
props is one of the next topic to be addressed on the prerequisite series.
I think the next one is to improve the scratch vcpu dry run
in qmp_query_cpu_model_expansion which is not precise enough (it applies
low level settings on a scratch vcpu whose init struct is based on some
host assumptions rather than comprehensive property settings, this
should be refined). If you want to work on this consistency checking
problematic, feel free. Otherwise I will.

Thanks

Eric
>
>>> - KVM does not allow writing 0 to ID_DFR0_EL1.CopDbg, which breaks
>>>   booting an AArch64-only guest on a host that also supports AArch32.
>>> - ID_DFR0_EL1.PerfMon is populated by KVM even for AArch64-only guests
>>>   but is not writable there.
>>> - MPIDR_EL1 is managed by KVM based on vCPU index.
>>> - Hold off writing back CLIDR_EL1 until we properly support exposing
>>>   cache topology to a KVM guest.
>> Sounds this deserves a prerequisite fix. I also have this hack in my
>> series but this should be dealt with separately I think.
>>> Some registers such as DCZID_EL0 are not exposed through the KVM cpreg
>>> list at all, but guest still sees the host value, we verify that vCPU's
>>> ID regs values match the host value.
>> why isn't it cpreg then? Shouldn't we add it instead?
> idk why KVM does not expose DCZID_EL0.
>
>>> To do this, refactor kvm_arm_writable_idregs_to_cpreg_list to
>>> kvm_arm_write_idregs_to_cpregs_list, which operates per field and now
>>> returns an error if a non-writable field mismatches with the host value.
>>>
>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>> ---
>>> target/arm/cpu-idregs.c |  19 +++++++
>>> target/arm/cpu-idregs.h |   4 ++
>>> target/arm/kvm.c        | 116 ++++++++++++++++++++++++++++++++++------
>>> target/arm/trace-events |   2 +-
>>> 4 files changed, 125 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
>>> index c41d0ab0c4..6fa02af0f3 100644
>>> --- a/target/arm/cpu-idregs.c
>>> +++ b/target/arm/cpu-idregs.c
>>> @@ -7,6 +7,7 @@
>>>  *  SPDX-License-Identifier: GPL-2.0-or-later
>>>  */
>>> #include "qemu/osdep.h"
>>> +#include "qemu/bitops.h"
>>> #include "qemu/error-report.h"
>>> #include "qapi/error.h"
>>> #include "cpu.h"
>>> @@ -94,3 +95,21 @@ ARM64SysReg arm64_id_regs[NUM_ID_IDX] = {
>>> #include "cpu-idregs.h.inc"
>>> };
>>>
>>> +uint64_t arm_get_field_mask(const ARM64SysRegField *field)
>>> +{
>>> +    return MAKE_64BIT_MASK(field->shift, field->length);
>>> +}
>>> +
>>> +bool arm_field_is_writable(const ARM64SysRegField *field)
>>> +{
>>> +    uint64_t field_mask = arm_get_field_mask(field);
>>> +
>>> +    return (arm64_id_regs[field->index].writable_mask & field_mask)
>>> +           == field_mask;
>>> +}
>>> +
>>> +bool field_matches(const ARM64SysRegField *field, ARMIDRegisterIdx index,
>>> +                   const char *name)
>>> +{
>>> +    return field->index == index && !strcmp(field->name, name);
>> why do you need to check both index and name. Only checking index should
>> be sufficient.
> Index gives register, name is field name.
>
>>> +}
>>> diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
>>> index 245f1c8103..d866bd9e0a 100644
>>> --- a/target/arm/cpu-idregs.h
>>> +++ b/target/arm/cpu-idregs.h
>>> @@ -38,4 +38,8 @@ typedef struct ARM64SysReg {
>>>  */
>>> extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
>>>
>>> +uint64_t arm_get_field_mask(const ARM64SysRegField *field);
>>> +bool arm_field_is_writable(const ARM64SysRegField *field);
>>> +bool field_matches(const ARM64SysRegField *field, ARMIDRegisterIdx index,
>>> +                   const char *name);
>>> #endif
>>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>> index 6974e5c551..c38b99cfce 100644
>>> --- a/target/arm/kvm.c
>>> +++ b/target/arm/kvm.c
>>> @@ -951,6 +951,16 @@ static uint64_t *kvm_arm_get_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
>>>     return &cpu->cpreg_values[res - cpu->cpreg_indexes];
>>> }
>>>
>>> +/* Like kvm_arm_get_cpreg_ptr, but returns NULL if the register is not found. */
>>> +static uint64_t *kvm_arm_find_cpreg_ptr(ARMCPU *cpu, uint64_t regidx)
>>> +{
>>> +    uint64_t *res;
>>> +    res = bsearch(&regidx, cpu->cpreg_indexes, cpu->cpreg_array_len,
>>> +                  sizeof(uint64_t), compare_u64);
>>> +
>>> +    return res ? &cpu->cpreg_values[res - cpu->cpreg_indexes] : NULL;
>>> +}
>>> +
>>> /**
>>>  * kvm_arm_reg_syncs_via_cpreg_list:
>>>  * @regidx: KVM register index
>>> @@ -1252,32 +1262,105 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
>>>     return true;
>>> }
>>>
>>> +static bool arm_field_skip_writeback_always(const ARM64SysRegField *field)
>>> +{
>>> +    /*
>>> +     * GIC is controlled by the gic-version property and fabricated by KVM
>>> +     * when the vGIC device is created, so a named CPU model must not touch
>>> +     * it. KVM also rejects writing 0 to ID_DFR0_EL1.CopDbg, which breaks
>>> +     * booting a model that lacks AArch32 support on a host that supports
>>> +     * it. MPIDR_EL1 is managed by KVM based on number of vCPUs, skip
>>> +     * writing it back. Similarly, skip writing back CLIDR_EL1 till we
>>> +     * properly support exposing cache for KVM guest.
>>> +     */
>>> +    return field_matches(field, ID_AA64PFR0_EL1_IDX, "GIC")
>>> +        || field_matches(field, ID_PFR1_EL1_IDX, "GIC")
>>> +        || field_matches(field, ID_DFR0_EL1_IDX, "CopDbg")
>>> +        || field->index == MPIDR_EL1_IDX
>>> +        || field->index == CLIDR_EL1_IDX;
>>> +}
>>> +
>>> +static bool arm_field_skip_writeback_if_not_writable(const ARM64SysRegField *field)
>>> +{
>>> +    /*
>>> +     * KVM populates ID_DFR0_EL1.PerfMon even for AArch64-only guests but
>>> +     * does not expose it as writable there, so skip it when it is not
>>> +     * writable.
>>> +     */
>>> +    return field_matches(field, ID_DFR0_EL1_IDX, "PerfMon");
>>> +}
>>> +
>>> /*
>>> - * Copy writable ID regs from isar.idregs[] to cpreg_list
>>> - * in case their value differs from the original init cpreg value
>>> + * Copy writable ID reg fields from isar.idregs[] into the KVM cpreg list,
>>> + * so the subsequent write_list_to_kvmstate() pushes them to KVM.
>>> + * Only writable fields are copied; fields that must not be written back
>>> + * (see arm_field_skip_writeback_*) are skipped.
>>> + * Returns -1 if any vCPU's ID reg value differs from the host value and the
>>> + * field is not writable.
>>>  */
>>> -static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
>>> +static int kvm_arm_write_idregs_to_cpreg_list(ARMCPU *cpu)
>>> {
>>>     for (int i = 0; i < NUM_ID_IDX; i++) {
>>>         ARM64SysReg *sysregdesc = &arm64_id_regs[i];
>>>         ARMSysRegs sysreg = id_register_sysreg[i];
>>> -        uint64_t previous, new;
>>> +        uint64_t writable_mask = sysregdesc->writable_mask;
>>> +        uint64_t desired = cpu->isar.idregs[i];
>>> +        uint64_t previous, updated;
>>>         uint64_t *cpreg;
>>>
>>> -        if (!sysregdesc->writable_mask) {
>>> +        cpreg = kvm_arm_find_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
>>> +        /*
>>> +         * Registers such as DCZID_EL0 are not exposed through the cpreg
>>> +         * list and are therefore not writable. Use the host value
>>> +         * snapshotted at probe time as the reference to check the vCPU ID
>>> +         * regs have the same value.
>>> +         */
>>> +        previous = cpreg ? *cpreg : arm_host_cpu_features.isar.idregs[i];
>>> +
>>> +        if (previous == desired) {
>>>             continue;
>>>         }
>> while at it you could also test all reserved fields here, RAZ, RES0/1
>> and make sure host value complies with the description.
> Noted, will add it in v4
>
> Warm Regards,
> Khushit
>>> -        cpreg = kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
>>> -        previous = *cpreg;
>>> -        new = cpu->isar.idregs[i];
>>> +        for (int j = 0; j < sysregdesc->fields_count; j++) {
>>> +            const ARM64SysRegField *field = &sysregdesc->fields[j];
>>> +            uint64_t field_mask = arm_get_field_mask(field);
>>> +            uint64_t prev_val = previous & field_mask;
>>> +            uint64_t new_val = desired & field_mask;
>>> +
>>> +            if (prev_val == new_val) {
>>> +                continue;
>>> +            }
>>> +
>>> +            if (arm_field_skip_writeback_always(field) ||
>>> +                (!arm_field_is_writable(field) &&
>>> +                 arm_field_skip_writeback_if_not_writable(field))) {
>>> +                /* Never write this field back; keep KVM's value. */
>>> +                writable_mask &= ~field_mask;
>>> +                continue;
>>> +            }
>>> +
>>> +            if (!arm_field_is_writable(field)) {
>>> +                error_report("%s.%s is not writable: host=0x%" PRIx64
>>> +                             ", requested=0x%" PRIx64,
>>> +                             sysregdesc->name, field->name,
>>> +                             prev_val >> field->shift, new_val >> field->shift);
>>> +                return -1;
>>> +            }
>>> +        }
>>> +
>>> +        if (!cpreg || !writable_mask) {
>>> +            continue;
>>> +        }
>>>
>>> -        if (previous != new) {
>>> -            *cpreg = new;
>>> -            trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
>>> -                                                        previous, new);
>>> -         }
>>> +        updated = (previous & ~writable_mask) | (desired & writable_mask);
>>> +        if (updated != previous) {
>>> +            *cpreg = updated;
>>> +            trace_kvm_arm_write_idregs_to_cpreg_list(sysregdesc->name,
>>> +                                                        previous, updated);
>>> +        }
>>>     }
>>> +
>>> +    return 0;
>>> }
>>>
>>> void kvm_arm_reset_vcpu(ARMCPU *cpu)
>>> @@ -2235,8 +2318,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>>     if (ret) {
>>>         return ret;
>>>     }
>>> -    /* overwrite writable ID regs with their updated property values */
>>> -    kvm_arm_writable_idregs_to_cpreg_list(cpu);
>>> +    /* overwrite ID reg fields with their updated property values */
>>> +    ret = kvm_arm_write_idregs_to_cpreg_list(cpu);
>>> +    if (ret) {
>>> +        return ret;
>>> +    }
>>>     ret = write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
>>>     if (!ret) {
>>>         return -1;
>>> diff --git a/target/arm/trace-events b/target/arm/trace-events
>>> index f33b0d821d..f042ab59b8 100644
>>> --- a/target/arm/trace-events
>>> +++ b/target/arm/trace-events
>>> @@ -14,7 +14,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>>> # kvm.c
>>> kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>>> get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
>>> -kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
>>> +kvm_arm_write_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
>>>
>>> # cpu64.c
>>> get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
>> Thanks
>>
>> Eric
>

