Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823C63C276F;
	Wed, 13 May 2026 09:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778663888; cv=none; b=KwDtgy9OB2Ta2EoxELBslMPeQ68ydh8wUgjp9sfZKgyeXKdViopXihL2zIlHBr37AOugQCAuKMbgH5XvTlIbJxfuUD5qpjYL2naSQ5PhRF00UWDUQj78CD/YvhG2xGO+AGsRQ2XOikOj16qH5Iq9ZAAjfluX0j9T3whO+4u9WlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778663888; c=relaxed/simple;
	bh=tK30HCaThkEdQqkifcwhGwd2vRsand6ahOgGAzNGZsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RW9q1p3l2eCMEy8nCBRfvgtu4pPCNFAevIPW+KdL5i2U1ucSP6+Ir6ApK+oPkM2OAc4RSMlpAxx7nIlUS7oj5R3enZ7Ln2SMIOb7qnLe7mmR1CC/2joFMt+V/JwODy/HmOEVTcI3BSP4VBGEMTJ7L01Y3ezE1gp1BOkNpqhsb+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E32QtEsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E32QtEsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA97C2BCB7;
	Wed, 13 May 2026 09:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778663888;
	bh=tK30HCaThkEdQqkifcwhGwd2vRsand6ahOgGAzNGZsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E32QtEsJ0lDRBSHnWJPUJHAeQ/WB4fwv2ObrZbpQs6suTi2LH2OvMZAvetLDjeT8Y
	 uI+UqkwPnQlmCI51uG8zoJdreaUqda5hR2v6tMtUhlX8dPKF3+QmuMq5afa8vWScXv
	 PHwrZ85CYCJTY363j7w5o5d4TPEqeLDs7YoLsoV0lwIiwS7TvuGo0r99p4iC8c2pH9
	 c3s0xhCNDco03N7MGmRnY0/NpC0PXPtxfGjvDVE0qK2O6uNCsqBh+sO1x6OzT0IMTe
	 y7kFrwgRKtDlOHW1w/s81n9+Ry8lLR2nmu8mc2PK1yEuogWAXtcQP79SgvnT1Q0Qel
	 riO6VF9SH9ZUQ==
Date: Wed, 13 May 2026 02:18:06 -0700
From: Oliver Upton <oupton@kernel.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v7 10/20] KVM: arm64: Context swap Partitioned PMU guest
 registers
Message-ID: <agRBzkVcR-qZZdx2@kernel.org>
References: <20260504211813.1804997-1-coltonlewis@google.com>
 <20260504211813.1804997-11-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504211813.1804997-11-coltonlewis@google.com>

On Mon, May 04, 2026 at 09:18:03PM +0000, Colton Lewis wrote:
> +
> +/**
> + * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
> + * @pmu: Pointer to arm_pmu struct
> + *
> + * Compute the bitmask that selects the host-reserved counters in the
> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
> + * in HPMN..N
> + *
> + * Return: Bitmask
> + */
> +u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
> +{
> +	u8 nr_counters = *host_data_ptr(nr_event_counters);
> +
> +	if (kvm_pmu_is_partitioned(pmu))
> +		return GENMASK(nr_counters - 1, pmu->max_guest_counters);
> +
> +	return ARMV8_PMU_CNT_MASK_ALL;
> +}
> +
> +/**
> + * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved counters
> + * @pmu: Pointer to arm_pmu struct
> + *
> + * Compute the bitmask that selects the guest-reserved counters in the
> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
> + * in 0..HPMN and the cycle and instruction counters.
> + *
> + * Return: Bitmask
> + */
> +u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
> +{
> +	if (kvm_pmu_is_partitioned(pmu))
> +		return ARMV8_PMU_CNT_MASK_C | GENMASK(pmu->max_guest_counters - 1, 0);
> +
> +	return 0;
> +}
> +
> +/**
> + * kvm_pmu_load() - Load untrapped PMU registers
> + * @vcpu: Pointer to struct kvm_vcpu
> + *
> + * Load all untrapped PMU registers from the VCPU into the PCPU. Mask
> + * to only bits belonging to guest-reserved counters and leave
> + * host-reserved counters alone in bitmask registers.
> + */
> +void kvm_pmu_load(struct kvm_vcpu *vcpu)
> +{
> +	struct arm_pmu *pmu;
> +	unsigned long guest_counters;
> +	u64 mask;
> +	u8 i;
> +	u64 val;
> +
> +	/*
> +	 * If we aren't guest-owned then we know the guest isn't using
> +	 * the PMU anyway, so no need to bother with the swap.
> +	 */
> +	if (!kvm_vcpu_pmu_is_partitioned(vcpu))
> +		return;
> +
> +	preempt_disable();
> +
> +	pmu = vcpu->kvm->arch.arm_pmu;
> +	guest_counters = kvm_pmu_guest_counter_mask(pmu);
> +
> +	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
> +		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
> +
> +		if (i == ARMV8_PMU_CYCLE_IDX) {
> +			write_sysreg(val, pmccntr_el0);
> +		} else {
> +			write_sysreg(i, pmselr_el0);
> +			write_sysreg(val, pmxevcntr_el0);

This is wrong, you would need an intervening ISB. It'd be better to
avoid the ISB altogether and just use {read,write}_pmevcntrn().

Thanks,
Oliver
