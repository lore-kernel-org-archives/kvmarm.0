Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF674E9C16
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616874; cv=none; b=MMUciOZXrhAVSoMAh+CmukQRmvMl3G2XbHm2ZMdehctkXtZlgoOeElGzayLSuzqGqZzEUFRoPFjCMpYM70e0HOXL/gKjRlv4O2YAQwz8YQLxGoxSE/41PGEK9CA+83A202IU13Dmp6hBQkT4NuhBQXgXHR4dJwaWZmhj+QtG4vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616874; c=relaxed/simple;
	bh=uh3nNIwDJbvQlWzXnPw0CQRfGHkttdb5zQRUKng+0mA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6PWHWVxhpfyARUBkKBR6npqJNodx+7mcdu7PUkxSmwYxA1MW1bl1GkBjp5U24HDZnSU6PZMFKyqMz/OuqFwyBQTLRTd4y+4MrtZKO/cLywCtXbnUHSOkf8FgDc+iTzRTWPeNLjdyv+ZylQEtREUlh1QjmO2lZxm6lCU1enXIWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cy1ocs6D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cy1ocs6D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790616869;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6QcRmKAZPk4+69MBsW2Ao6CpwFSl1GoQnOOgz4WoGyo=;
	b=cy1ocs6DxgB0NxA/S6PyphkDIw6Pe0AUn/kWiS3VkTVeDPWJRDEQq4tVbHHRL0nYV9DrmY
	JPKTrJzp+gs0PswyONfWtZ8dZbMs19ofNW08Sb+ZU7P8z70Wd0GxhxV1nPPl37lWVIBw6A
	p2Ntz8Tt3/0MYfRGiR/dWTw2f1YigtE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-SEg6QisYOqqF77ykwSbR2g-1; Mon, 28 Sep 2026 13:34:27 -0400
X-MC-Unique: SEg6QisYOqqF77ykwSbR2g-1
X-Mimecast-MFC-AGG-ID: SEg6QisYOqqF77ykwSbR2g_1790616867
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a0032846d7so13746015e9.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 10:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790616867; x=1791221667;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6QcRmKAZPk4+69MBsW2Ao6CpwFSl1GoQnOOgz4WoGyo=;
        b=HrT/3/Ptb5Z6ltfIDeOu0B0/QjPB9tIkL2Ut+vZVvI8AxJnAH3J7gGkjiYon2oxfww
         86XqWmSEo0fIa/aS3EBkL8eTZiqgM5sBpnOC6ReZ+NIZ1qp9ctsmCcWDb+LgkKiLeNoU
         9vsgPFMEI1hFI2MLVCT3THjh9cL5DjGph2MOGPxKtrKEp8Q6MFMNTQR8KodgF6zjJpEu
         /A86vuGfZ/mJ05WqDj5U2BiZAM/O9jnsKaHympFt+4n6wH4DZ3QCIaKVHl2pIY1zOQ5z
         q+BKboIhWcElPGyy2ydpxDqI0AzmYZrn+FyEjxZYDAJFM6p3FuQ7wUw2fNOrExhgTK9K
         mN8A==
X-Forwarded-Encrypted: i=1; AKwUvBy3W3J1LotQs6LPIDh9rK5hhYM9VBa0OvhNPTK5Y+GkIghYHku9MTxDLxyIgK7DPcsahPPIuQ8=@lists.linux.dev
X-Gm-Message-State: AFuF++mGJA64OVWtfwCG5h4kumGVTHfeXraVzlqAgFFtnMprf1JZi/W+
	4QnEjQzm4OkTONDS6fPZM1Q2H2tefgzrG8Lb9X6I7ytzcYNBsYLYDcr2jPsUHuAnRGPNdEu6ynb
	fYdS4dYLXyeX1gloJDzSnX0i++nFRnQF7RlnHtkl6dg9ax4vHX42/4xm6ew==
X-Gm-Gg: AYBFou0F2UB4k5KA39TUwLz6/oHKNB/XmiIb2UVPeTsxKly8eBO6pBopZqvAKJEpes0
	kdftsV9TS9l0VR1YGrXXf1wwRaeCGD0ooJxwxg8I13w54vJlh2WUfpmpuTlPTkNlRQbO0YzY7a3
	qnCIE5XP46qiZk+Mran8iE8HElAdaQpe7/81THCRlEXzRfgzvjjU1NhZmKuSpNSnWtUvbA5WYnL
	T/pYEiG9yn1YtvOmBBDnxR5vVpa6DIPu3pHshslOfZH8RrmucIMQZwXjCbvpYo5BvpEpQDuGMVr
	lZPZiN6+kogOojs5oRgkMw2ErC+Q4Gv3Y/7wXcLwbgiLEKEe8e9vGYF4BnLhP8OIevx9mS3r2Fc
	kpq3QoxJhDtpuUQQIMzSK7dMcK9nQMe3SWKZ1mazSx36URZTh
X-Received: by 2002:a05:600c:3b1b:b0:49f:e4d4:dd70 with SMTP id 5b1f17b1804b1-49fe6705bd7mr249667135e9.31.1790616866672;
        Mon, 28 Sep 2026 10:34:26 -0700 (PDT)
X-Received: by 2002:a05:600c:3b1b:b0:49f:e4d4:dd70 with SMTP id 5b1f17b1804b1-49fe6705bd7mr249666885e9.31.1790616866176;
        Mon, 28 Sep 2026 10:34:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cfa57d7sm7988175e9.10.2026.09.28.10.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:34:25 -0700 (PDT)
Message-ID: <3bcc8ccf-6daf-47a1-8620-a69915adf8ae@redhat.com>
Date: Mon, 28 Sep 2026 19:34:24 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 12/26] arm/kvm: Initialize isar.idregs[] with all
 writable host ID regs
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
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-13-eric.auger@redhat.com>
 <8C1A034C-C3E7-4EC3-89CF-6E3AD99AE90C@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <8C1A034C-C3E7-4EC3-89CF-6E3AD99AE90C@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GipW2dpagNv45MyIm5mjNHO7kzAy6IHkFk4rat-S5KQ_1790616867
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/25/26 3:27 PM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> kvm_arm_get_host_cpu_features() already retrieves the values of some
>> host id registers to analyze the available vcpu features.
>>
>> Eventually we want to be able to allow the user to change the value
>> of writable ID reg fields. So we need to store the initial value of all
>> writable ID regs into isar.idregs[].
>>
>> Introduce a new get_host_cpu_idregs() helper that populates isar.idregs[]
>> and call it from kvm_arm_get_host_cpu_features.
>>
>> This patch has no impact on cpreg values. isar.idregs[] is only
>> used as a temporary storage for register values to be updated in place
>> later.  Also it does not handle the writeback of isar.idregs[] into cpreg
>> value list after user update. This will be handled separately.
>>
>> Note the host values are retrieved from the scratch vcpu initialized with
>> all the available capabilities exposed by KVM, independently on the
>> final choice made by the suer.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> Hi Eric,
>
> As we discussed, in v10, there will be an option to also read all the ID registers, not only writable.
yes we can do that. reviewers may advocate the leave as is though as the
only call site in
this series will use writable mode.
>> ---
>> v8 -> v9:
>> - improve the commit msg. Only initialize in this patch and move the
>>  write back to cpreg value list in a different patch.
>> - Do not hack CLIDR here. The correct way to fix that temporarily is to
>>  do that in the machine instead.
>>
>> v7 -> v8
>> - fix indent and added Khushit's R-b
>>
>> v6 -> v7
>> - remove vcpu from prototypes (Khushit)
>>
>> v5 -> v6
>> - do not check writable_map anymore
>> ---
>> target/arm/kvm.c        | 43 ++++++++++++++++++++++++++++++++++++++++-
>> target/arm/trace-events |  2 ++
>> 2 files changed, 44 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index c6eac41991..958b25e550 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -43,6 +43,7 @@
>> #include "hw/acpi/ghes.h"
>> #include "target/arm/gtimer.h"
>> #include "migration/blocker.h"
>> +#include "cpu-idregs.h"
>>
>> const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>>     KVM_CAP_INFO(DEVICE_CTRL),
>> @@ -290,7 +291,44 @@ static int kvm_feature_idx_to_idregs_idx(int kidx)
>>     return get_sysreg_idx(sysreg);
>> }
>>
>> -static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>> +/*
>> + * get_host_cpu_idregs: Read all the writable ID reg host values
>> + *
>> + * Need to be called once the writable mask has been populated
>> + * Note we may want to read all the known id regs but some of them are not
>> + * writable and return an error, hence the choice of reading only those which
>> + * are writable. Those are also readable!
>> + */
>> +static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
>> +{
>> +    int err = 0;
>> +    int i;
>> +
>> +    for (i = 0; i < NUM_ID_IDX; i++) {
>> +        ARM64SysReg *sysregdesc = &arm64_id_regs[i];
>> +        ARMSysRegs sysreg = id_register_sysreg[i];
>> +        uint64_t *reg;
>> +        int ret;
>> +
>> +        if (!sysregdesc->writable_mask) {
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
>> +kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>> {
>>     /* Identify the feature bits corresponding to the host CPU, and
>>      * fill out the ARMHostCPUClass fields accordingly. To do this
>> @@ -376,6 +414,9 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>         SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
>>         err = 0;
>>     } else {
>> +        /* Make sure all writable ID reg values are initialized */
>> +        err |= get_host_cpu_idregs(fd, ahcf);
>> +
> Perhaps if we read “all” the ID registers, we should be able to get rid of all the manual reads below.
Yes if all are read, we can remove this. But for now this is depends on
the host capabilities, better to
leave as is I think.
>
>>         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
>>         err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR2_EL1_IDX);
>>         err |= get_host_cpu_reg(fd, ahcf, ID_AA64SMFR0_EL1_IDX);
>> diff --git a/target/arm/trace-events b/target/arm/trace-events
>> index 8502fb3265..c25d2a1191 100644
>> --- a/target/arm/trace-events
>> +++ b/target/arm/trace-events
>> @@ -13,6 +13,8 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>>
>> # kvm.c
>> kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>> +get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
>> +kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%”PRIx64
> ^^ leaked into this commit.
yup. Thanks!

Eric
>
> Warm Regards,
> Khushit
>
>> # cpu.c
>> arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
>> -- 
>> 2.53.0
>>

