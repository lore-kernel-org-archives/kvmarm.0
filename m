Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28929441035
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 23:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784675111; cv=none; b=ak7brxLXpopxNstrX6+WRI4XfkkFB72MVKP+rbzl2HPS2o+DRzmDksAcIyfj1JwobEgk8Icjz2il5nyGz+7SThbfRNiJln8McKOKOLzqh00y+CCRDkYEdezx9KLG7BzZ5QJVg/JtL37fMp9Uxwnt+Qy4NoC0vbsemjyquo2elT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784675111; c=relaxed/simple;
	bh=/d5+Ct9ll6b1HxibJ3keb46nwT+WlmFOnNHUX+rzbEg=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Y7vDCiwX0jTf0vCobIUNZ2HS3OqvyHeE7X7K1eQdB9T581nTgRpVaGAxAgCpn+1wDZxPTxMj+RZ5K5l5qUPO2ZroAlinPgwgDQTds4JH/Zclc7F0hoGN3aihdjV+9IcxPxAx16hHILXhNm/Tt1NNMaBkR032kX5+J48Hrtus1lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ofvkvvo8; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ofvkvvo8"
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-49d4cb3ca23so20045494b6e.3
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 16:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784675107; x=1785279907; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QYXaYDgqkJqtd2+svQngfiSlGiL9bXTJTobnSbO9Md4=;
        b=Ofvkvvo8CdY4S6s7aclaGqKEzM/NJPUarZ1wIIq6VJou2mmprWuNsofmIs518KZz67
         mwe2wmR4ckh7PpFxhk/1wctUIbjuFZouhiPzCN3aGhPH+0QNm5EEEvYukJgmOyN6j2wv
         B6O4tzaT5KXfHwTwo3JzS+08d8JW3bjDSoYrC5J4E8BJMOZWI6hJZtD2wLATV9trQTtR
         JOeV38oSK6e0TLZgvRshVd+taqGIb8rLKTT4DJdVZhFKgNI+4Zn8dj4OgtYh0J0GEstD
         Dp6wx9n7qbcbs+tVBw2Rx5sdLRENGUMwB5amTjbtDYMwEeIYVOTeCuigIAe/hqkD7UbE
         NgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784675107; x=1785279907;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QYXaYDgqkJqtd2+svQngfiSlGiL9bXTJTobnSbO9Md4=;
        b=C2mGAHCw7uMFreWv2RYZKnqJ/45BeGNNHbzvXLN4RHnEtw6wdn+sNNRx8mSqkIgs8o
         C/aE4GvhUvzxRfelZmrPOjTJzsFQurPV+A61SISNi0OcuDnbNWGIVaWDoH4Uy6Ce1ABm
         pW0h/6p0sd8M1DSoIF77He0Xy+Y8XSnJHYO2Ps9LvFE/ANooIm3K+Mm76d/H5KIHGr/O
         uw2ad0jOWtimUlQEinSqVnpygjOe6AZqD80hR9id4Td53VU2W2/i+adCNyRTLEfYXvUx
         NutcVeSWxuend8ehJauDQH2xYhP6kv7Z2JkzDmcR0pDF7tn0g+7eAG8e/gX9VFjUZGFy
         GvMA==
X-Forwarded-Encrypted: i=1; AHgh+RodC4pO4ce2//4frchxRSsZG8SuqROpQrH+Td7uP7yqA6VbwlC272XHAKyFJaJfgIzwSSF2vlo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+fatMj/TGi5NeHXfrx5Ngp+70C1ad/NMd8XgLOkuG0bEGwz0F
	h3tHCNcXnYr82rk306h5Ea6nBoHQ4OzGQKNucwJNURO4Upf9cl8+9WOP/boTMYdQulFe4cULRX3
	OGrgJzMomYrdYGTag5SuhKlXGKw==
X-Received: from iowx7.prod.google.com ([2002:a05:6602:1607:b0:9a8:4cf8:3078])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1719:b0:495:f230:a340 with SMTP id 5614622812f47-4a4d049ce3emr10719954b6e.28.1784675106606;
 Tue, 21 Jul 2026 16:05:06 -0700 (PDT)
Date: Tue, 21 Jul 2026 23:05:06 +0000
In-Reply-To: <3fc867c3-67a0-4fdd-b871-f2ba4d642f1f@linaro.org> (message from
 James Clark on Mon, 20 Jul 2026 17:46:37 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt8q7454gt.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 11/21] KVM: arm64: Context swap Partitioned PMU guest registers
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

James Clark <james.clark@linaro.org> writes:

> On 12/06/2026 20:28, Colton Lewis wrote:
>> Save and restore newly untrapped registers that can be directly
>> accessed by the guest when the PMU is partitioned.

>> * PMEVCNTRn_EL0
>> * PMCCNTR_EL0
>> * PMSELR_EL0
>> * PMCR_EL0
>> * PMCNTEN_EL0
>> * PMINTEN_EL1

>> If we know we are not partitioned (that is, using the emulated vPMU),
>> then return immediately. A later patch will make this lazy so the
>> context swaps don't happen unless the guest has accessed the PMU.

>> PMEVTYPER is handled in a following patch since we must apply the KVM
>> event filter before writing values to hardware.

>> PMOVS guest counters are cleared to avoid the possibility of
>> generating spurious interrupts when PMINTEN is written. This is fine
>> because the virtual register for PMOVS is always the canonical value.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    arch/arm/include/asm/arm_pmuv3.h |   4 +
>>    arch/arm64/kvm/arm.c             |   2 +
>>    arch/arm64/kvm/pmu-direct.c      | 183 +++++++++++++++++++++++++++++++
>>    include/kvm/arm_pmu.h            |  16 +++
>>    4 files changed, 205 insertions(+)


> [...]

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
>> +	unsigned long guest_counters;
>> +	unsigned long flags;
>> +	u64 mask;
>> +	u8 i;
>> +	u64 val;
>> +
>> +	/*
>> +	 * If we aren't guest-owned then we know the guest is not
>> +	 * accessing the PMU anyway, so no need to bother with the
>> +	 * swap.
>> +	 */
>> +	if (!kvm_pmu_is_partitioned(vcpu->kvm))
>> +		return;
>> +
>> +	preempt_disable();
>> +
>> +	pmu = vcpu->kvm->arch.arm_pmu;
>> +	guest_counters = kvm_pmu_guest_counter_mask(pmu);
>> +
>> +	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
>> +		if (i == ARMV8_PMU_CYCLE_IDX)
>> +			val = read_pmccntr();
>> +		else
>> +			val = read_pmevcntrn(i);
>> +
>> +		__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, val);
>> +	}
>> +
>> +	val = read_sysreg(pmselr_el0);
>> +	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
>> +
>> +	val = read_sysreg(pmcr_el0);
>> +	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, val);
>> +
>> +	/* Mask these to only save the guest relevant bits. */
>> +	mask = kvm_pmu_guest_counter_mask(pmu);
>> +
>> +	val = read_sysreg(pmcntenset_el0);
>> +	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
>> +
>> +	val = read_sysreg(pmintenset_el1);
>> +	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
>> +
>> +	/* Save pending guest hardware overflows. */
>> +	local_irq_save(flags);
>> +	val = read_sysreg(pmovsset_el0);
>> +	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val & mask);
>> +	write_sysreg(val & mask, pmovsclr_el0);
>> +	local_irq_restore(flags);
>> +
>> +	/* Stop guest counters and disable interrupts in hardware. */
>> +	write_sysreg(mask, pmcntenclr_el0);
>> +	write_sysreg(mask, pmintenclr_el1);
>> +
>> +	kvm_pmu_set_guest_counters(pmu, 0);

> Hi Colton,

> This function doesn't get added until "KVM: arm64: Apply dynamic guest
> counter reservations" a few commits later.

> kvm_pmu_guest_counter_mask() is also used in a commit before it's added.

My bad. I'll correct that.
