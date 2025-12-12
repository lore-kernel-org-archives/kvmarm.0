Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550C529D292
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 21:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765574547; cv=none; b=C9hO5Thl6e03u++aW1eFm5yZa2yFEWeuMZWj5MGdQohZYyPqxi0/hSOsV0VCsOxVu+Wc+liV4uH72C9+CxMlgcNnn+8267BE/95Zb1juCzvdWwiXXzTqLLZMYbW+mbDz8lNgm8eA2Nw8IUDfZUl7lqLog6wbbjJpg1E5L1h2ACM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765574547; c=relaxed/simple;
	bh=zUcTgO8xFxXTIs2xi2maKe3MVihox+NtvOsRoMBmnbc=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Jz/q7mNG9TF05HTREEDoiQjia50lF8KG8wLPvQmN1YzJCcdYcWDbqVnbrCsV/wrKkjTP2k4ErHpQbzxHUqY5uIdQDR2JBcPVo1Nc4tAwBZZlk3fjEQXp11gxmMenmdNj+Q4YkkkUNYVpnWg8kAU+2kY6rRQ5tb3adNIwnjo/IOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KoEutaKd; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KoEutaKd"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-65b37e173faso2058729eaf.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 13:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765574544; x=1766179344; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TDikX7MxydgpkEhVgiFec0tbYtt4zp46Bk2PRaWMaw0=;
        b=KoEutaKdQKascyLESol2lv287ea7HNNpO1XXpP+bnXrLfBvbDzko+HGpg/rWz7eOqY
         nWxtCfpe0b5dtApxw/O4XESH58UHCxmUrjlnLw1gbkfy6SyGKzUl2wIvV2Bd3uhI1y6r
         +rA+Aoa2lKS4Am03L0gf6U3EYnvRlBOICwPxWVh1swol84mbnNal2XEpVpUucP2neB9G
         NOAJ+l4RmbLb4w29ghR9722dYnaiyx8QQOVDFnnwF+b8rYC3wKD62H/81/oHLyv5G25d
         UMKk7Vf5kQv6u88fKJgYe3ep9Nwq5clVJnSpPyogvGffc98Xc2Ae5WnlAxtY76VqzNkm
         9sXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765574544; x=1766179344;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDikX7MxydgpkEhVgiFec0tbYtt4zp46Bk2PRaWMaw0=;
        b=sPD5y6mI0YQcoSR1gMwYYbvb4Q/zHyzoqVM66HRhU0yh0zdAI+av83dkRYUoX/lXxZ
         afzg9j+R20tRiXJu4v7D9SyAQU/BEeyWxjQhEznjRBxZ3B6dWUsdYTPB36B0MmlhREd0
         IOUD8Unf/toPAjcxPWt4m1UMWcKKbog/7Fz7KyLJRbi4XeiLAamd6NmrNjf8LIclmPVH
         le7Mzxy0vevjZ45bQXY9goIj/DXc15KozDNORh3sxyrJbTavCG5sbLwhxvD7ESD4Ywga
         tkbCnJXENhZG3fD8tOMOQKAT7mljTpRIENvIwc1tDw6MDjmuOogyeORP2nr04qm7qpDf
         VyhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzP74hLpsoRQE9Q5shBliLzMzYvgYT0PoioPumzXxVjY+UG2WHmtMbALynnSV1D4jJoxlcXjo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmgmWONL4KOXQo2NzLUoW8k2sLZ2UEfZJmdqf1FZdoxsmgFilw
	pJUY3iyY1dYS+EERbY29gmhtflG+yr3wmArp8qqFle+M4Kp95uatqR9lXw+Ku0NW6NfF131mgGu
	Sit8NZe8K1p/ZZDsWDD/bA0sSPQ==
X-Google-Smtp-Source: AGHT+IFacNltyMpQaFsNK7rlABry0i4u7xBCuikCMLsDPxZN/lK6t81XIofzqcYLqh4pqGUQWt5vQ9Tbd4atv0DZBg==
X-Received: from jabbm9.prod.google.com ([2002:a05:6638:42c9:b0:5b7:27fd:4260])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:16a4:b0:657:6fdd:9875 with SMTP id 006d021491bc7-65b455bc09emr1840088eaf.5.1765574544449;
 Fri, 12 Dec 2025 13:22:24 -0800 (PST)
Date: Fri, 12 Dec 2025 21:22:23 +0000
In-Reply-To: <aTiVnI5ewoEVRztD@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 13:33:16 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntpl8j2y5s.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 15/24] KVM: arm64: Setup MDCR_EL2 to handle a
 partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oupton@kernel.org> writes:

> On Tue, Dec 09, 2025 at 08:51:12PM +0000, Colton Lewis wrote:
>> Setup MDCR_EL2 to handle a partitioned PMU. That means calculate an
>> appropriate value for HPMN instead of the default maximum setting the
>> host allows (which implies no partition) so hardware enforces that a
>> guest will only see the counters in the guest partition.

>> Setting HPMN to a non default value means the global enable bit for
>> the host counters is now MDCR_EL2.HPME instead of the usual
>> PMCR_EL0.E. Enable the HPME bit to allow the host to count guest
>> events. Since HPME only has an effect when HPMN is set which we only
>> do for the guest, it is correct to enable it unconditionally here.

>> Unset the TPM and TPMCR bits, which trap all PMU accesses, if
>> FGT (fine grain trapping) is being used.

>> If available, set the filtering bits HPMD and HCCD to be extra sure
>> nothing in the guest counts at EL2.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm64/include/asm/kvm_pmu.h | 11 ++++++
>>   arch/arm64/kvm/debug.c           | 29 ++++++++++++--
>>   arch/arm64/kvm/pmu-direct.c      | 65 ++++++++++++++++++++++++++++++++
>>   3 files changed, 102 insertions(+), 3 deletions(-)

>> diff --git a/arch/arm64/include/asm/kvm_pmu.h  
>> b/arch/arm64/include/asm/kvm_pmu.h
>> index 60b8a48cad456..8b634112eded2 100644
>> --- a/arch/arm64/include/asm/kvm_pmu.h
>> +++ b/arch/arm64/include/asm/kvm_pmu.h
>> @@ -101,6 +101,9 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
>>   void kvm_pmu_host_counters_enable(void);
>>   void kvm_pmu_host_counters_disable(void);

>> +u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
>> +u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
>> +
>>   #if !defined(__KVM_NVHE_HYPERVISOR__)
>>   bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
>>   bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
>> @@ -173,6 +176,14 @@ static inline u64 kvm_pmu_fgt2_bits(void)
>>   {
>>   	return 0;
>>   }
>> +static inline u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu)
>> +{
>> +	return 0;
>> +}
>> +static inline u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
>> +{
>> +	return 0;
>> +}
>>   static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
>>   					     u64 select_idx, u64 val) {}
>>   static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index 3ad6b7c6e4ba7..0ab89c91e19cb 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -36,20 +36,43 @@ static int cpu_has_spe(u64 dfr0)
>>    */
>>   static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>>   {
>> +	int hpmn = kvm_pmu_hpmn(vcpu);
>> +
>>   	preempt_disable();

>>   	/*
>>   	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
>>   	 * to disable guest access to the profiling and trace buffers
>>   	 */
>> -	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
>> -					 *host_data_ptr(nr_event_counters));
>> +
>> +	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
>>   	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
>>   				MDCR_EL2_TPMS |
>>   				MDCR_EL2_TTRF |
>>   				MDCR_EL2_TPMCR |
>>   				MDCR_EL2_TDRA |
>> -				MDCR_EL2_TDOSA);
>> +				MDCR_EL2_TDOSA |
>> +				MDCR_EL2_HPME);
>> +
>> +	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
>> +		/*
>> +		 * Filtering these should be redundant because we trap
>> +		 * all the TYPER and FILTR registers anyway and ensure
>> +		 * they filter EL2, but set the bits if they are here.
>> +		 */
>> +		if (is_pmuv3p1(read_pmuver()))
>> +			vcpu->arch.mdcr_el2 |= MDCR_EL2_HPMD;
>> +		if (is_pmuv3p5(read_pmuver()))
>> +			vcpu->arch.mdcr_el2 |= MDCR_EL2_HCCD;
>> +
>> +		/*
>> +		 * Take out the coarse grain traps if we are using
>> +		 * fine grain traps.
>> +		 */
>> +		if (kvm_vcpu_pmu_use_fgt(vcpu))
>> +			vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR);
>> +
>> +	}

>>   	/* Is the VM being debugged by userspace? */
>>   	if (vcpu->guest_debug)
>> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
>> index 4dd160c878862..7fb4fb5c22e2a 100644
>> --- a/arch/arm64/kvm/pmu-direct.c
>> +++ b/arch/arm64/kvm/pmu-direct.c
>> @@ -154,3 +154,68 @@ void kvm_pmu_host_counters_disable(void)
>>   	mdcr &= ~MDCR_EL2_HPME;
>>   	write_sysreg(mdcr, mdcr_el2);
>>   }

> <snip>

>> +/**
>> + * kvm_pmu_guest_num_counters() - Number of counters to show to guest
>> + * @vcpu: Pointer to struct kvm_vcpu
>> + *
>> + * Calculate the number of counters to show to the guest via
>> + * PMCR_EL0.N, making sure to respect the maximum the host allows,
>> + * which is hpmn_max if partitioned and host_max otherwise.
>> + *
>> + * Return: Valid value for PMCR_EL0.N
>> + */
>> +u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu)
>> +{
>> +	u8 nr_cnt = vcpu->kvm->arch.nr_pmu_counters;
>> +	int hpmn_max = armv8pmu_hpmn_max;
>> +	u8 host_max = *host_data_ptr(nr_event_counters);
>> +
>> +	if (vcpu->kvm->arch.arm_pmu)
>> +		hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
>> +
>> +	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
>> +		if (nr_cnt <= hpmn_max && nr_cnt <= host_max)
>> +			return nr_cnt;
>> +		if (hpmn_max <= host_max)
>> +			return hpmn_max;
>> +	}
>> +
>> +	if (nr_cnt <= host_max)
>> +		return nr_cnt;
>> +
>> +	return host_max;
>> +}
>> +
>> +/**
>> + * kvm_pmu_hpmn() - Calculate HPMN field value
>> + * @vcpu: Pointer to struct kvm_vcpu
>> + *
>> + * Calculate the appropriate value to set for MDCR_EL2.HPMN. If
>> + * partitioned, this is the number of counters set for the guest if
>> + * supported, falling back to hpmn_max if needed. If we are not
>> + * partitioned or can't set the implied HPMN value, fall back to the
>> + * host value.
>> + *
>> + * Return: A valid HPMN value
>> + */
>> +u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
>> +{
>> +	u8 nr_guest_cnt = kvm_pmu_guest_num_counters(vcpu);
>> +	int nr_guest_cnt_max = armv8pmu_hpmn_max;
>> +	u8 nr_host_cnt_max = *host_data_ptr(nr_event_counters);
>> +
>> +	if (vcpu->kvm->arch.arm_pmu)
>> +		nr_guest_cnt_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
>> +
>> +	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
>> +		if (cpus_have_final_cap(ARM64_HAS_HPMN0))
>> +			return nr_guest_cnt;
>> +		else if (nr_guest_cnt > 0)
>> +			return nr_guest_cnt;
>> +		else if (nr_guest_cnt_max > 0)
>> +			return nr_guest_cnt_max;
>> +	}
>> +
>> +	return nr_host_cnt_max;
>> +}

> </snip>

> I find all of this rather confusing. It seems like you're dealing with
> sanitizing kvm->arch.nr_pmu_counters vs. the underlying implementation.
> I'm not sure why you need to do that, I would expect that we reject
> unsupported values at the time of the ioctl.

I agree it makes more sense to do the validating at the ioctl. I'll do that.

> The only thing you do need to handle is if the vCPU has migrated to an
> "unsupported" CPU, for which we already have supporting helpers. I'm too
> lazy to fetch the Arm ARM and cite architecture but I'm pretty sure an
> out-of-range HPMN has UNPREDICTABLE behavior.

It does.

> I think you just need to move the vcpu_set_unsupported_cpu() call earlier  
> in
> kvm_arch_vcpu_load().

> Taking all that into consideration:

> u8 kvm_mdcr_hpmn(struct kvm_vcpu *vcpu)
> {
> 	u8 nr_counters = *host_data_ptr(nr_event_counters);

> 	if (!kvm_vcpu_pmu_is_partitioned(vcpu) || vcpu_on_unsupported_cpu(vcpu))
> 		return nr_counters;

> 	return vcpu->kvm->arch.nr_pmu_counters;
> }

Something like that will probably work. But I also need to account for
if arch.nr_pmu_counters is 0 and we don't have HPMN0, which is also
unpredictable. I don't think I can reject that at the ioctl because we
still want to support that case. Is there any way to handle that through
vcpu_on_unsupported_cpu()?

> Thanks,
> Oliver
