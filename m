Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F063FF1A4
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 17:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989709; cv=none; b=tcy+tOS1D8kkii+GWjHuRtZcO6cjcP57a8GAgyjfoj8RvHjvNsh+DlfH9SCzgl47hYUifaJiObd0SW1N2GbJU9yNTPIZhuxqx3kQp/3bjspKrbt8vQuCpT5knFVq+2GJD1ZppNdOX324nJ5onoCA17QWRnmwkHEwdXF1MakZ9yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989709; c=relaxed/simple;
	bh=9MF/mjHaSwiWcyS/I4iS1lt9Ukl0i826coOiBCqJ7QA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lnfUDrobA1y6fcaKN99qw+dTyTyJu0t3NKpla9mwYt7tzJGf4RxmQnm0HfTPT87haflRDUgnva+HVmHsPh7hx4x4UnpZPf6BdYulFYV4X5kZVT+JpmClJyTZuRf55DDOade40H5v44vfth32jdRLfx2e4jPFK44IuYsV9Iv5hg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pex3cAjr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pex3cAjr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779989706;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svwqtWrqzM3kGhhJFVDvd8OT+guNLpygpqwmA559IC8=;
	b=Pex3cAjrwAaM/lS4SwlZaNzF8NfwFw209Oq+SEX4P7B+IuQHZpPlJkqHwNVuU22awQv/sq
	3CK0w/KjXXJ2Z42mEUSc1c4F68calT3/UFE+JL6qN/XbMZGaYeyY0YAP5adn0RoG2KRBfF
	jc61YQUwT7WIamuZYndVp0wCkrhgMoc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-AUHON_jTOnqqbuhPJLb2yg-1; Thu, 28 May 2026 13:35:05 -0400
X-MC-Unique: AUHON_jTOnqqbuhPJLb2yg-1
X-Mimecast-MFC-AGG-ID: AUHON_jTOnqqbuhPJLb2yg_1779989704
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45eecec7667so400317f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 10:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779989704; x=1780594504;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=svwqtWrqzM3kGhhJFVDvd8OT+guNLpygpqwmA559IC8=;
        b=d2++8Ahyg0op0fVwtFK9uF78uckgWFSwwe72HAmk5xwU8c1yJaVUE/dyZX8noTPZwg
         pgI5PRv1sJp5R4TlgKSNipVXuuw2jMXb3l2pNDVIuP3YGIJUf7C7l+xsUzGK7g6quAUx
         S2mArxajR84/KR7TrWWySfoVjYZLBg5id8UCZOS10ssqRvg+efoqP/ww6plX6JNp0KGA
         ETbnWXO/Bc89d6Cgln5tlDucuuem6UF9ZQ+Ft5tEsJEBQRuaFExBquPnEqpOlgGdJWzt
         Lh5yeyzY1M5A9dBCiy1jMTh+9g5aOOz2BUIEanzzy3jqbJjIEv4SIVFwk+kvDMAgIPKT
         aqIA==
X-Forwarded-Encrypted: i=1; AFNElJ+0Nuln4KYEgMiaLH+auOIewMc1A6iGiG1rI3AnEINrcm1184s+VktyB+KoYDQBvh76dmMbOco=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5ubWIWJ8cMifitUGCUbEyz2dAbG4+xjZHR7El5EAtqgKrBxuN
	b3wqul7PW3QRYPlsIoZBaRIxFFNFb/i30c5OcwmyReCNkG4yMu1Sk0Po90Eo+naTMDBFj7kltA7
	W38o+LSvi2Uost5gWpwudQyqVqIvsXpZZRAA/7havb4B40fVSjf/1XIFKyw==
X-Gm-Gg: Acq92OHp2ntGCODDtS985t8YveJjHYMaNfG2+kaiyX0G059ADr53lbOThiytvOWym1J
	d33rci86y8DuOkveRAVNbl/cZ20N0k24rPDu/REi5qg64PdEPnG5BtEXlLDBo1AjL+pC6aJtyEI
	RYyYXc9ALKxRmqOfT0IPhBQZ1eTySxE+rBfQnGzrVXNpjTlG02/InEvHfODOYg5p1Xmqhic/DfP
	zHycaY0SpTmLgpJusYlOfpfmHqnWgLblhZMiT77d98ZrCAN4B1iqAMtYF1YU+idIdQV/LLNZ+5V
	Nfh3/b8pKKU0LaD7wHBPar9KMPzqGPC5t54J6kMfqGRO6NAbWJl+lQXUS7PGN4+ICEBsK8H4vBn
	kHUjiSJw+3a2hJNARgPOyQ+O61JtK5c8JvhIApnBxcrX7/NflPfc9zwjfCzebfCCs+Yt6CJqzrk
	cD9CdB
X-Received: by 2002:a05:6000:110a:b0:45e:ea65:d329 with SMTP id ffacd0b85a97d-45ef02900abmr246905f8f.7.1779989704173;
        Thu, 28 May 2026 10:35:04 -0700 (PDT)
X-Received: by 2002:a05:6000:110a:b0:45e:ea65:d329 with SMTP id ffacd0b85a97d-45ef02900abmr246840f8f.7.1779989703639;
        Thu, 28 May 2026 10:35:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eef267322sm948542f8f.12.2026.05.28.10.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 10:35:03 -0700 (PDT)
Message-ID: <f6c03ab6-7196-4160-acab-6a4a8dd35388@redhat.com>
Date: Thu, 28 May 2026 19:35:00 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 12/18] arm/kvm: write back modified ID regs to KVM
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
 <20260519132905.145643-13-eric.auger@redhat.com>
 <A29EDF01-278F-4975-9659-44359311204D@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <A29EDF01-278F-4975-9659-44359311204D@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rnHa3BsLuVGk4BX27J8H_3pSN-JcIFB1TzP2gZ3kYY8_1779989704
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 4:42 PM, Khushit Shah wrote:
>
>> On 19 May 2026, at 6:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> In case some ID reg values were overriden after their
>> initialization in kvm_arm_get_host_cpu_features() we need to
>> copy the new value stored in isar.idregs array back to the
>> cpreg_list and then sync the cpreg_list to KVM.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
>>
>> v4 -> v5:
>> - only call kvm_arm_writable_idregs_to_cpreg_list and
>>  write_list_to_kvmstate if writable_map is allocated
>> - reinitialize the cpreg list after sync (Jinqian)
>> ---
>> target/arm/kvm.c        | 69 ++++++++++++++++++++++++++++++++++++++++-
>> target/arm/trace-events |  1 +
>> 2 files changed, 69 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 92219ee62e..30c5175c68 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -274,6 +274,21 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
>>     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
>> }
>>
>> +static int kvm_feature_idx_to_idregs_idx(int kidx)
>> +{
>> +    int op1, crm, op2;
>> +    ARMSysRegs sysreg;
>> +
>> +    op1 = kidx / 64;
>> +    if (op1 == 2) {
>> +        op1 = 3;
>> +    }
>> +    crm = (kidx % 64) / 8;
>> +    op2 = kidx % 8;
>> +    sysreg = ENCODE_ID_REG(3, op1, 0, crm, op2);
>> +    return get_sysreg_idx(sysreg);
>> +}
>> +
>> static int idregs_idx_to_kvm_feature_idx(ARMIDRegisterIdx idx)
>> {
>>     ARMSysRegs sysreg = id_register_sysreg[idx];
>> @@ -1189,6 +1204,40 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
>>     return true;
>> }
>>
>> +/*
>> + * Copy writable ID regs from isar.idregs[] to cpreg_list
>> + * in case their value differs from the original init cpreg value
>> + */
>> +static void kvm_arm_writable_idregs_to_cpreg_list(ARMCPU *cpu)
>> +{
>> +    for (int i = 0; i < KVM_ARM_FEATURE_ID_RANGE_SIZE; i++) {
>> +        uint64_t writable_mask = cpu->writable_map[i];
>> +
>> +        if (writable_mask) {
>> +            int idx = kvm_feature_idx_to_idregs_idx(i);
>> +            ARM64SysReg *sysregdesc;
>> +            uint64_t previous, new;
>> +            uint64_t *cpreg;
>> +            uint32_t sysreg;
>> +
>> +            if (idx == -1) {
>> +                /* sysreg writable, but we don't know it */
>> +                continue;
>> +            }
>> +            sysregdesc = &arm64_id_regs[idx];
>> +            sysreg = id_register_sysreg[idx];
>> +            cpreg = kvm_arm_get_cpreg_ptr(cpu, idregs_sysreg_to_kvm_reg(sysreg));
>> +            previous = *cpreg;
>> +            new = cpu->isar.idregs[idx];
>> +            if (previous != new) {
>> +                *cpreg = new;
>> +                trace_kvm_arm_writable_idregs_to_cpreg_list(sysregdesc->name,
>> +                                                            previous, new);
>> +            }
>> +        }
>> +    }
>> +}
>> +
>> void kvm_arm_reset_vcpu(ARMCPU *cpu)
>> {
>>     int ret;
>> @@ -2140,7 +2189,25 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>     }
>>     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
>>
>> -    return kvm_arm_init_cpreg_list(cpu);
>> +    ret = kvm_arm_init_cpreg_list(cpu);
>> +    if (ret) {
>> +        return ret;
>> +    }
>> +    /* overwrite writable ID regs with their updated property values */
>> +    if (cpu->writable_map) {
>> +        kvm_arm_writable_idregs_to_cpreg_list(cpu);
>> +        ret = write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE);
>> +        if (!ret) {
>> +            return -1;
>> +        }
>> +        /*
>> +         * modified values may have changed the visibility of some regs,
>> +         * reinitialize the cpreg_list accordingly
>> +         */
>> +         ret = kvm_arm_init_cpreg_list(cpu);
>> +    }
>> +
>> +    return ret;
>> }
>>
>> int kvm_arch_destroy_vcpu(CPUState *cs)
>> diff --git a/target/arm/trace-events b/target/arm/trace-events
>> index 8c7faf57c7..c25d2a1191 100644
>> --- a/target/arm/trace-events
>> +++ b/target/arm/trace-events
>> @@ -14,6 +14,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
>> # kvm.c
>> kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
>> get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
>> +kvm_arm_writable_idregs_to_cpreg_list(const char *name, uint64_t previous, uint64_t new) "%s overwrite default 0x%"PRIx64" with 0x%"PRIx64
>>
>> # cpu.c
>> arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
>> -- 
>> 2.53.0
>>
> Hi Eric, 
>
> We can not safely rely on ahcf on all configurations. This will not work for a host kernel that is booted with nested virtualisation support but qemu started without virtualisation  (i.e. -machine virt (no virtualisation=on)).
>  This happens because scratch vCPU always enables EL2 support if supported
> by the host kernel. Why limits alot of ID register fields (see limit_nv_id_reg() in
> kernel). Then the actual vCPU is initialised with ahcf->isar.idregs[] (with EL2 support). When trying to write back this will result in error.

OK I see. Thank you for reporting the issue

Eric
>
> Will attach how we solved this is separate mail/reply.
>
> Warm Regards,
> Khushit. 

