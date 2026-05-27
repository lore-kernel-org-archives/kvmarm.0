Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E2735F180
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895542; cv=none; b=fGiodAo9N4kLUawlxdsUTfn1azqjRQQB+ljqz/fFC5MSPA4kEn1PdihoTtgAaZEReVeP0/kblmyK89Ve5aWS+O+j1Zex4bnNaQUyP4sJVnSD8Rq69NeJf4LRbnlx46eEyCBBSVJ4qjO3N6cw+wofdht/pWUww1uM9bsPdkYlKaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895542; c=relaxed/simple;
	bh=frcJ/SbNqQ1l6vZKllwo8x15uocvpu1ggYuqoKCSr5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CSZVGMcZ4TuJ53gTq5M9wZ0E8xsd6qQDJsYGEPS0WkgTg/jkDtAavRnya/hLIlOd0t7A3no4Q1UhvbMZ9iKhKpMNkcX7eHBRFzc8dTDkicWQXpJ0PQzjwfJiyF/Jhm9TQNvFKXFUApetizfrCU4KZySraUEcqA4WoYlNmSARYfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MlrVo3m+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MlrVo3m+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779895539;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U1nI+GF+M4+fmcHYxJlm8wHF1Cjb5e40BGTagKIjuqU=;
	b=MlrVo3m+51Vav+IYk2BvGsKSAKXNbyFd2jbZsN7t5EICYVat7c4EW6uNDsSevzOkHIagdH
	pj8wMQjaRJIu6hwO3EW4wn83USeOpLaYF/w9e1EQO4EvBoDCmgKGzCLoX7zwfvaS3NH5S5
	ZJOlB4cojHUpIBhWzFG9ruoQLE+QWbI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-RcnLe70RO6mzY4TWEVqNYA-1; Wed, 27 May 2026 11:25:38 -0400
X-MC-Unique: RcnLe70RO6mzY4TWEVqNYA-1
X-Mimecast-MFC-AGG-ID: RcnLe70RO6mzY4TWEVqNYA_1779895537
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-447f2ce5556so8729769f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779895537; x=1780500337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1nI+GF+M4+fmcHYxJlm8wHF1Cjb5e40BGTagKIjuqU=;
        b=M0RBZldVErUcDnN/iMrDWwGuaU4nks4qn9Wo/qi5ThQLPFubXtGnxxG4pOTj5ReV0u
         CzgNX/U4NOHPMgNhcPXHPNBZTw2Tx98mHOao3qJFwPE5YFLvgWymmmIzOoRA6SqALxFE
         rX3v2jV6QfAv85DYbZ90zqMoy502PV5BLnMHsWka+tkMIGp7PFcVmiFHOIeaiuwbrQK6
         wJUNHdgdu21IPK4BKuh/dkcrB3KX5qv7Vr1IavOFoDZBKji7i2DbT67fmrHPSN6XV6iH
         U8UMpEHNHSD7tLbIgI4bJDF3O6y/YO6zIzb1aeCh6Kc5mWe23BfqGHsJPozIM90LsDsz
         4iSw==
X-Forwarded-Encrypted: i=1; AFNElJ9fUlLsk2dnH8qrJZyPMj9lrN/Tdgex17KcbpZCr4vZBm14tVRs/U9cbQWwkcEgesoFl4r9lfw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDroa9WEq474e7lpx9A/vvLf9IWgip7opFIxxOuG+JxNsiGz4T
	+4Dkg6Y4/JQzfTeM/fY9sQAjTaLPPtEWHBFNcumnADmbu966UwsJLfAN4801Ap4NEDVOyKxsJfq
	+6spZxXyBwMjEC8qMRWWD4uWsvlrKBdlYwN/pAgempQuVP2+9UcjFd8m4jQ==
X-Gm-Gg: Acq92OFXOK1dMLyvsp7BGCMQ8oy0v49Q1c4MmjUESUQVBDuN2cFUnkq6d4MbowRylVk
	pFM5Hwac5ZbMsxlORY51AIIL5dk2265GGVnebdx0UVuPnPT+lEqPO/FOE08Pj47ktegKTYtaPf8
	v55GFWHl9k3oYZw4We7IAZsKzEJK6gqrtWA/SQcdnMSTJd1RBEAvl8J6nIAR/rCf3Ty1YJCBifw
	X7ndOI6517eSbQN57xQS6gk+vcnMYq4oR/scDI8/LVKmHmW/z23Bb575IWZyEbbMh1Xx725Fbxk
	nYEinG61IeIQ9ztADNdDAvtVPMwfMD6wJ4glBLfrNUZLVOO2JUBf1SFl73v2qmXgKkoYEEPzbmN
	JyNs5hgOcDl6yHZivHUQW/GHzebDPsmH5SvQiaauMFRA3DvR7HcE3uibCg1ASta3bZrelnA==
X-Received: by 2002:a05:6000:98b:b0:44d:821:1a0b with SMTP id ffacd0b85a97d-45eb38a1692mr37288795f8f.29.1779895536867;
        Wed, 27 May 2026 08:25:36 -0700 (PDT)
X-Received: by 2002:a05:6000:98b:b0:44d:821:1a0b with SMTP id ffacd0b85a97d-45eb38a1692mr37288730f8f.29.1779895536309;
        Wed, 27 May 2026 08:25:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5a281dsm6498794f8f.24.2026.05.27.08.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 08:25:35 -0700 (PDT)
Message-ID: <eded7708-c2b5-4a0c-a871-69b01d3358bb@redhat.com>
Date: Wed, 27 May 2026 17:25:34 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 11/18] arm/kvm: Initialize all writable ID registers
 from host
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
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-12-eric.auger@redhat.com>
 <7CF06975-A0CB-43CD-9B3D-FF74DBF55AB9@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <7CF06975-A0CB-43CD-9B3D-FF74DBF55AB9@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KyB7b02G3HQM0TJXJQ8027xvCA0GHnZIT-Z_vLT6Bzw_1779895537
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 5:02 PM, Khushit Shah wrote:
>
>> On 19 May 2026, at 6:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> We want to allow overwriting writable fields of some ID registers.
>> However currently some of them are never touched, neither read nor
>> w. Examples are CLIDR_EL1, CTR_EL0, REVIDR_EL1, MIDR_EL1.
>>
>> We want to initialize them from the host value, allow overwrite
>> and write back for kvm afterwards. This patch implements the
>> initialization.
>>
>> Introduce a new get_host_cpu_idregs() helper that gets the host
>> values for all writable ID regs and store them in isar.idregs[].
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
>> ---
>> target/arm/kvm.c        | 72 +++++++++++++++++++++++++++++++++++++++--
>> target/arm/trace-events |  1 +
>> 2 files changed, 71 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 4adfd20050..92219ee62e 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -42,6 +42,7 @@
>> #include "hw/acpi/ghes.h"
>> #include "target/arm/gtimer.h"
>> #include "migration/blocker.h"
>> +#include "cpu-idregs.h"
>>
>> const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>>     KVM_CAP_INFO(DEVICE_CTRL),
>> @@ -273,7 +274,62 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
>>     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
>> }
>>
>> -static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>> +static int idregs_idx_to_kvm_feature_idx(ARMIDRegisterIdx idx)
>> +{
>> +    ARMSysRegs sysreg = id_register_sysreg[idx];
>> +
>> +    return KVM_ARM_FEATURE_ID_RANGE_IDX((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK)
>> +                                            >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
>> +                                        (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK)
>> +                                            >> CP_REG_ARM64_SYSREG_OP1_SHIFT,
>> +                                        (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK)
>> +                                            >> CP_REG_ARM64_SYSREG_CRN_SHIFT,
>> +                                        (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK)
>> +                                            >> CP_REG_ARM64_SYSREG_CRM_SHIFT,
>> +                                        (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK)
>> +                                            >> CP_REG_ARM64_SYSREG_OP2_SHIFT);
>> +}
>> +
>> +/*
>> + * get_host_cpu_idregs: Read all the writable ID reg host values
>> + *
>> + * Need to be called once the writable mask has been populated
>> + * Note we may want to read all the known id regs but some of them are not
>> + * writable and return an error, hence the choice of reading only those which
>> + * are writable. Those are also readable!
>> + */
>> +static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures *ahcf)
>> +{
>> +    int err = 0;
>> +    int i;
>> +
>> +    for (i = 0; i < NUM_ID_IDX; i++) {
>> +        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
>> +        ARMSysRegs sysreg = id_register_sysreg[i];
>> +        uint64_t writable_mask =
>> +             cpu->writable_map[idregs_idx_to_kvm_feature_idx(i)];
>> +        uint64_t *reg;
>> +        int ret;
>> +
>> +        if (!writable_mask) {
>> +            continue;
>> +        }
>> +
>> +        reg = &ahcf->isar.idregs[i];
>> +        ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
>> +        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
>> +        if (ret) {
>> +            error_report("%s error reading value of host %s register (%m)",
>> +                         __func__, sysregdesc->name);
>> +
>> +            err = ret;
>> +        }
>> +    }
>> +    return err;
>> +}
>> +
>> +static void
>> +kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures *ahcf)
>> {
>>     /* Identify the feature bits corresponding to the host CPU, and
>>      * fill out the ARMHostCPUClass fields accordingly. To do this
>> @@ -359,6 +415,18 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
>>         err = 0;
>>     } else {
>> +        /* Make sure all writable ID reg values are initialized */
>> +        if (cpu->writable_map) {
>> +            err |= get_host_cpu_idregs(cpu, fd, ahcf);
>> +        }
> Again, I do not like writable_map being in ARMCPU.
>
> Why should kvm_arm_get_host_cpu_features care if writable
> map is populated or not?
the cpu->writable_map check can be moved to get_host_cpu_idregs or we
use the copied bitmask in the idreg struct

Thanks

Eric
>
>> +        /*
>> +         * temporarily override the CLIDR_EL1 value since some host values
>> +         * trigger "Unified type is not implemented at level n" error in
>> +         * fdt_add_cpu_nodes()
>> +         */
>> +        SET_IDREG(&ahcf->isar, CLIDR, 0x0);
>> +
> This is because by default KVM exposes a 1 level unified, 1 way 1 set simple
> cache, to efficiently handle set/way based cache operations.
>
> TBH this is slightly ugly. Should make the virt machine code to not expose
> cache fdt nodes if using KVM.
>
> For our v2 (WIP), we have handled this by a new property ‘expose-cache’ for
> named cpu models which is used to set CLIDR and CCSIDR banks based
> on values provided by the model and only creating fdt nodes if those
> values are provided.
>
>>         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
>>         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR2_EL1_IDX);
>>         err |= get_host_cpu_reg(fd, ahcf, ID_AA64SMFR0_EL1_IDX);
>> @@ -485,7 +553,7 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
>>     CPUARMState *env = &cpu->env;
>>
>>     if (!arm_host_cpu_features.dtb_compatible) {
>> -        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
>> +        kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features);
>>     }
>>
>>     cpu->kvm_target = arm_host_cpu_features.target;
>> diff --git a/target/arm/trace-events b/target/arm/trace-events
>> index 8502fb3265..8c7faf57c7 100644
>> --- a/target/arm/trace-events
>> +++ b/target/arm/trace-events
>> @@ -13,6 +13,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>>
>> # kvm.c
>> kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>> +get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
>>
>> # cpu.c
>> arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
>> -- 
>> 2.53.0
>>
>
> Warm Regards,
> Khushit
>

