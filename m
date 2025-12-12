Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF1A29BDA2
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 21:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765576652; cv=none; b=dKdSzANsjW2xZ+mLqwmiz3flM5D7qxEoMqmrWD80Q8rlvL62Y7RMHijCG+RtqlAAS7/r8VqTXOW1J6vzsR75uxOZcBAy0yPbqkxlpBg9zq/1qOrFfpFQZzTPNqqDajWxOLInWnU6hCxL0fxZVHafX/sFwP7Nv2g8sDPjTRL5UH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765576652; c=relaxed/simple;
	bh=NlpkVeg5Ojh2ggxmqolrGBOVaXh8bWthQ3O9t+AoYGU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=fYJ7bUrG3R4Xn6lb9CvVPfts4mH7uyLZpaucY1UHLvt3pVi7A02yna6sC/oVrldJz5a4CpD44ZICTdT1ECfQ9TJRPJ957FZ9dmyLeQ4qV3x+hVwM4oPeLWrVDl+HnrNVzdcZMWXgJWrc1Y7MLTG1CCUy3gnWbL/2IYB+EqKoQog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E5m8usC0; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5m8usC0"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-65b2cd67cceso2323754eaf.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 13:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765576650; x=1766181450; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2ttJ6xmtoO+TMjpy3jngL8UwbOyul+Pr/ModRoYytt4=;
        b=E5m8usC04oMQqy0X2p+nrj9LPSI80kxsGH5MgSNXIcK+oU4K2JPc/n9ywLfC+vG34z
         8gHhxRYYwO3rCxxeUTnxfXcYpAxYIpLM2+/7QPWdNQZYkR8PN4KdUyO9cDtFUpjpGuUb
         7TeBGIfqd91pnmtJKXLvZPReuksonRGSSdOiL+g6L0Pi0hgl2uXsfFOEsRajaCIUIbGi
         InzyXK46WbgrJvVNWnQURpLq4mnICZVy9PnKOA8WBvLTP7pUrp+c7xzjAWqmaqLOqRNG
         L57jfgkwVFAxS7T5aoLjMwePazb7RDOBwXeOsWJ8oloRnShzxRYJPACYt2GncNuAa2sv
         J4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765576650; x=1766181450;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ttJ6xmtoO+TMjpy3jngL8UwbOyul+Pr/ModRoYytt4=;
        b=OM7AXNdFVUa+QfaeLON6w17RWmW1GlKaV0dWtDKtIrmD0bTo5WJoJ1GvUglWOoQu9K
         0KvA+jORkxAclxTFFhMcCuip5dZOi3ttxpWCCSUA0LQdsFQbHTA4AgGX6/MlW0oLmVD3
         PVzILwRY/K7wLCSieB5GO+gLKAERFXnG+0WQq2p0+GHpeydEPFb/Uv1M9UkFCpe9y6WK
         duyEq34kRILFHp7YEM+Q8x8f14L7Vk6cbgtSIKNHgO+7DzIx0RdUMNv/w1SHq3wpMMwM
         0LNFR7KjJJ2xErD+xFuuxTaR3IMg7gOoIdbaOjwJmT/TsQn0tJUeHqYaxkJGNJJgbeMo
         LGiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtmN2UmLMi6md86Vc+c3MgJnwcwEMmDg7OA5/qp6AfJYMZKrVf7WW5j3qQl0uUlss/RLFQgwg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+oBUyzqJmtyhVVBRwjzpNsAc6wXsfTnngu3wAvkPMZlXkGQVb
	TmV5qIYAtN8WWgWjXl50alMFXmal2faTdrMChOBjQo6ugh6sa8GEwngxeMtAPY3H710RfzGh6VI
	dk/4j8cm5S4gS3bRLevNiLURCbw==
X-Google-Smtp-Source: AGHT+IG3WpSlSfg4uPyoIkKPRJzL2gMsw3+TvqLsZPR6R0Vcjs/oN1S1khI3YeVjrDNr+bCuGt/vCHZ4HeQH6JCXGw==
X-Received: from ilbbs17.prod.google.com ([2002:a05:6e02:2411:b0:434:972f:bf8f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4d0a:b0:659:9a49:8fdf with SMTP id 006d021491bc7-65b4516d5aemr1505706eaf.12.1765576650099;
 Fri, 12 Dec 2025 13:57:30 -0800 (PST)
Date: Fri, 12 Dec 2025 21:57:29 +0000
In-Reply-To: <aTia74R74upcsMEA@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 13:55:59 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntjyyr2wja.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 17/24] KVM: arm64: Context swap Partitioned PMU guest registers
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

> On Tue, Dec 09, 2025 at 08:51:14PM +0000, Colton Lewis wrote:
>> +/**
>> + * kvm_pmu_load() - Load untrapped PMU registers
>> + * @vcpu: Pointer to struct kvm_vcpu
>> + *
>> + * Load all untrapped PMU registers from the VCPU into the PCPU. Mask
>> + * to only bits belonging to guest-reserved counters and leave
>> + * host-reserved counters alone in bitmask registers.
>> + */
>> +void kvm_pmu_load(struct kvm_vcpu *vcpu)
>> +{
>> +	struct arm_pmu *pmu;
>> +	u64 mask;
>> +	u8 i;
>> +	u64 val;
>> +

> Assert that preemption is disabled.

Will do.

>> +	/*
>> +	 * If we aren't using FGT then we are trapping everything
>> +	 * anyway, so no need to bother with the swap.
>> +	 */
>> +	if (!kvm_vcpu_pmu_use_fgt(vcpu))
>> +		return;

> Uhh... Then how do events count in this case?

> The absence of FEAT_FGT shouldn't affect the residence of the guest PMU
> context. We just need to handle the extra traps, ideally by reading the
> PMU registers directly as a fast path exit handler.

Agreed. Yeah I fixed this in my internal backports but looks like I
skipped incorperating the fix here.

>> +	pmu = vcpu->kvm->arch.arm_pmu;
>> +
>> +	for (i = 0; i < pmu->hpmn_max; i++) {
>> +		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
>> +		write_pmevcntrn(i, val);
>> +	}
>> +
>> +	val = __vcpu_sys_reg(vcpu, PMCCNTR_EL0);
>> +	write_pmccntr(val);
>> +
>> +	val = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> +	write_pmuserenr(val);

> What about the host's value for PMUSERENR?
>> +	val = __vcpu_sys_reg(vcpu, PMSELR_EL0);
>> +	write_pmselr(val);

> PMSELR_EL0 needs to be switched late, e.g. at  
> sysreg_restore_guest_state_vhe().
> Even though the host doesn't currently use the selector-based accessor,
> I'd prefer we not load things that'd affect the host context until we're
> about to enter the guest.


There's a spot in __activate_traps_common() where the host value for
PMUSERENR is saved and PMSELR is zeroed. I stopped that branch when
partitioning because it was clobbering my loaded values, but I can
modify instead to handle these things as they should be handled.

>> +	/* Save only the stateful writable bits. */
>> +	val = __vcpu_sys_reg(vcpu, PMCR_EL0);
>> +	mask = ARMV8_PMU_PMCR_MASK &
>> +		~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
>> +	write_pmcr(val & mask);
>> +
>> +	/*
>> +	 * When handling these:
>> +	 * 1. Apply only the bits for guest counters (indicated by mask)
>> +	 * 2. Use the different registers for set and clear
>> +	 */
>> +	mask = kvm_pmu_guest_counter_mask(pmu);
>> +
>> +	val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>> +	write_pmcntenset(val & mask);
>> +	write_pmcntenclr(~val & mask);
>> +
>> +	val = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
>> +	write_pmintenset(val & mask);
>> +	write_pmintenclr(~val & mask);

> Is this safe? What happens if we put the PMU into an overflow condition?

It gets handled by the host same as any other PMU interrupt. Though I
remember from our conversation you don't want the latency of an
additional interrupt so I can handle that here.

>> +}
>> +
>> +/**
>> + * kvm_pmu_put() - Put untrapped PMU registers
>> + * @vcpu: Pointer to struct kvm_vcpu
>> + *
>> + * Put all untrapped PMU registers from the VCPU into the PCPU. Mask
>> + * to only bits belonging to guest-reserved counters and leave
>> + * host-reserved counters alone in bitmask registers.
>> + */
>> +void kvm_pmu_put(struct kvm_vcpu *vcpu)
>> +{
>> +	struct arm_pmu *pmu;
>> +	u64 mask;
>> +	u8 i;
>> +	u64 val;
>> +
>> +	/*
>> +	 * If we aren't using FGT then we are trapping everything
>> +	 * anyway, so no need to bother with the swap.
>> +	 */
>> +	if (!kvm_vcpu_pmu_use_fgt(vcpu))
>> +		return;
>> +
>> +	pmu = vcpu->kvm->arch.arm_pmu;
>> +
>> +	for (i = 0; i < pmu->hpmn_max; i++) {
>> +		val = read_pmevcntrn(i);
>> +		__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, val);
>> +	}
>> +
>> +	val = read_pmccntr();
>> +	__vcpu_assign_sys_reg(vcpu, PMCCNTR_EL0, val);
>> +
>> +	val = read_pmuserenr();
>> +	__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0, val);
>> +
>> +	val = read_pmselr();
>> +	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
>> +
>> +	val = read_pmcr();
>> +	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, val);
>> +
>> +	/* Mask these to only save the guest relevant bits. */
>> +	mask = kvm_pmu_guest_counter_mask(pmu);
>> +
>> +	val = read_pmcntenset();
>> +	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
>> +
>> +	val = read_pmintenset();
>> +	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);

> What if the PMU is in an overflow state at this point?

Is this a separate concern from the point above? It gets loaded back
that way and the normal interrupt machinery handles it.
