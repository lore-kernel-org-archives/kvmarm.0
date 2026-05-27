Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B148380FF9
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895849; cv=none; b=FanQza8xMMF6YRulZz+5iApsi1tY6ufuAZbNmc+1bMtShwR+hoOO0xt3AxbKNM+GUfm5sG53JSXxw4fx9/KKUNEryN7IUnfO7ZyaxVKZ8bThtvz3EUpZ7ybHtlg9WwEBZNGzKsfJ4+8jhwCQV+aTaWfoXYKh3JBWwfymhzVpqLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895849; c=relaxed/simple;
	bh=3mnXWrgnM3TURIK0c4zUUvP6Urjw7e6edmHMvp3XOp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bP/Vdx4DZmbo1DJ4KhzD2gLu/nI+LH1ydCQ7P6t2rjXRgqoJBkQPCOXhxhW6SDTHvs8GADqDgrWD+y8tYLlLOBCzFyoI8gAMvyyr9VM8vbcwU9PlMN1E60cz4fib/bIs1tcXVVplrDsQJWZ639gXZh5a6SduDH0zDdheEkVwJVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EL9Q4HQ3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EL9Q4HQ3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779895847;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnJCSe+uWFP66T9XonIRkjHBsSIKz38FDbggZYeLMyU=;
	b=EL9Q4HQ3IGLOpoqiFHoG2XiaHUICwfsMTqLVPoc5lhT6MClw3gDG97UdKwtkYnf2a3H3TV
	qrLod0npT76HkwEyJF4EIp/YRpmj9owAmBwgFzmiYdJ6w9aOKB6ElNtjekUQGDqGHBhZYw
	kBJVisdTvcPLqclB8josRcsnLLMyCeA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-WwaAQHPKONagM1kQOURrVw-1; Wed, 27 May 2026 11:30:42 -0400
X-MC-Unique: WwaAQHPKONagM1kQOURrVw-1
X-Mimecast-MFC-AGG-ID: WwaAQHPKONagM1kQOURrVw_1779895840
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490479c2911so59893135e9.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:30:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779895840; x=1780500640;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnJCSe+uWFP66T9XonIRkjHBsSIKz38FDbggZYeLMyU=;
        b=eROW3uE/x+BUSb2QjJNG8+wngJhfFHSudd09JjPqWkag1pF3Iu9AnGPuX+iCMS6SwE
         B5hagti5wMnFrw5IgZd2USk/mKG68BTUhy4awkK+3xqREfi6Varn1NSii/eceqou8vjz
         tzSsICP3EOpLamNy9yaDZJ4Y1nZ+LKeM9jemJ69OJeB9v7DexrXamFh/qebdSbTX2aZh
         tsOPGcf7hWgGCL8lYiVQIAIDzjtNSv8rgJn8Xt4elR7DtwIQM9m3ouzk2fHZizv4x/ax
         nFnToQNFBXM5p8aPSm0LtjDNWj2ofgSKzvGEZr1X1q4DmTgWURjiA17e6DraM/F7xND9
         c/eA==
X-Forwarded-Encrypted: i=1; AFNElJ/W+7AcTHIlOqei0llwKuVep4/LWCcLIKRh+guq5GS5lxwqPpfQ4f8tVfnXIpkQtxV3QHMYYQs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyU3zWXQjNHr5R+EweaZM7cCeVzZ66dlIRf9LUcDYRqsdDc9+yB
	cYxvatOkAkBq7jloaXaGmtrui2kvgvcjNN+mVfUlMO7o3C0cjO3yYowdTicXqX5EkRoz6HaaDJh
	IfucWcNcvTjvqZgGxDEf0ic7+An/AxGEgJObp1Ku5amjlcQEaNPFeGvNHmw==
X-Gm-Gg: Acq92OED0FbwtZCZ1Xw8OvErNZzkpYk9vqF/qJb/1j+ZfdyozcyuGnKpRiRCsyMu1g5
	2iTr14q7+6LSUuBK4arVLZw2001gMFfu3AIKcOLEjqV8unrhmiKfKgYHrs1U0VGW1GvZQySUzrA
	8w92Cw68eL/vjntFYujJdH5N+GogKOfMiWj7oZQKqu3bpXqDbiD6R0plEtFP9kzLaOt7ldhLS90
	enepakmg6yCLKWXJIneE9qC2eR2XtipT7ovmFAwF4mKD3dQk/YRrxIRL0QTK7IWFEXvQwyXm56V
	2/nvNJhye06X4132GkpcNk6b9docEhy4B4gzdwGwtvFQ8H4XG5MO4K3wSXmxk6lPUfhCVdRGgkw
	2IIhXOyHDAWZGisDaHTL0dHuHp5XGrDviE3iqlintEyaZX3M9guQ/DOo2hh3ezsi4D5XsKo61gd
	8dYUdt
X-Received: by 2002:a05:600c:a402:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-490426d1a91mr278965325e9.19.1779895839413;
        Wed, 27 May 2026 08:30:39 -0700 (PDT)
X-Received: by 2002:a05:600c:a402:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-490426d1a91mr278964615e9.19.1779895838739;
        Wed, 27 May 2026 08:30:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904561a160sm462805075e9.9.2026.05.27.08.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 08:30:38 -0700 (PDT)
Message-ID: <de7ddfac-3a93-43f2-abcb-e38bb20debf5@redhat.com>
Date: Wed, 27 May 2026 17:30:36 +0200
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
X-Mimecast-MFC-PROC-ID: p6d4-hraRZcbg2IqHVy6RM0f8EKCPfySBkm1MTJOG-g_1779895840
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

I sent a separate question to the contributor in
https://lore.kernel.org/all/0fc08e52-d62c-4c40-9221-9f4e659c2aa5@redhat.com/.
You can also reply in the separate thread

This looks we need a separate fix for that, no?

Thanks

Eric
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

