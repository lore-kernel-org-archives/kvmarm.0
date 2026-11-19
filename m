Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795116113;
	b=C8qi9owFft9PAenkSfhjpi07jMA0/xY86D0K9z1KrAxnZmA60meqHUf4NFmryx16tXYA
	 4Ioe6WbflqZmnhc8nuc7v8s5lZAzi+5/ryEzPzFacjo1fmFjigoiZO/VLXMce3mfWfpXh
	 KAaK0KH96c7SmiLpSduQC274Bbs694Op5HpyHVTuB+iNssIVNXnkAoKIAmeRPTtDX7wbD
	 cgnj/rbMTa7XtC94DspEUE7ESw2qEnjh1PSQHvh52BaHJg89p231dMK5Z8TD1iQmuQWdM
	 bQ16T1NwWflcmFpgif1BcjrCLD/QWxSFtD8Um/DopStneDw2HDB2S1Ce+AfPuW7Kawg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795116113;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wTHkt5SFjezPonUvxGIIH272hKX1zEkcMEjfgYbEI/4=;
	b=O8zq+XjLOkPfgbKr+EKICZVq2s9sNtXinHDQrSov6HlTjLn7TZ+FPCvfZtMdCStqxnf9
	 qbXxAM+kVLaLen089m14WzvD8rW6z6qpdmd29VsOddvqNpc4wWw0QQWq2+CcZwfQIGlNV
	 KI7EKJjNF++KeyEviPKs1IvPSleRp2mJ39jh2Ni3EBt47yTlMqKIEilvXorbZGwcQXfpn
	 7lzmH58IANp19IrhyWmDH+gtRWlTz2Z62blnRKKxzHSL0oWQiwZp9ivX3ZdANzy7hWV2D
	 Z97Ml9dNuOOC+CAsq9XcXT7ASkWm7D7HpBcSXTwhJZR6CSEs5lvfZqbk7/PNUaBHcbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZdymq7I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43750606A326;
	Thu, 19 Nov 2026 19:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZdymq7I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1221F000C7;
	Thu, 19 Nov 2026 19:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795116113;
	bh=wTHkt5SFjezPonUvxGIIH272hKX1zEkcMEjfgYbEI/4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oZdymq7IRx7lv947qNmtCzOeJc2+FZjZ94eCLRmiHbyekB7ITOHFpMFHSTatHxTR0
	 MP+n5fD9ga+3VGOhpCLdA3tRbILcrDslaSgsIdubg19cfFCm46QI5ICLqRuUKxS5g0
	 cloiH8knpmJdtUIoxDBB6qT6cctrz2zwVv5UPfw03BbNxU4y7uKA23yZzb+BebeUgM
	 acmGUruj+tSIJY1n5EGHpl5Jj9fPTnWDKSGlHX+ZAg8QvyxOf8qvE6wulPb+HF/oUI
	 EnZCNUXFC5rdmTxyjXESLc380/dnSS6HuG3A6xZ4ayN5KYt7c+IS2rjNf/gbFmqiF8
	 3wUtwgxVFhsWA==
Message-ID: <sashiko-outbox-223868@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 14/33] KVM: arm64: Add Partitioned PMU register trap
 handlers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261119185215.632334-15-coltonlewis@google.com>
References: <20261119185215.632334-1-coltonlewis@google.com>
 <20261119185215.632334-15-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 19:21:52 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: arm64: missing 32-bit counter mask in
  kvm_pmu_direct_cntr_read()
--

commit a61557b3819ee55851d36163d0d9444fd60c695d
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Add Partitioned PMU register trap handlers

This commit adds direct PMU register read and write handlers for VMs using
a Partitioned PMU and dispatches trapped PMU accesses to them.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index b1c180ae79d9d..13f5bcc2a9084 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c

[ ... ]

> @@ -79,6 +92,245 @@ static u64 kvm_vcpu_pmu_guest_counter_mask(struct kvm=
_vcpu *vcpu)
>  	return 0;
>  }

[ ... ]

> +static u64 kvm_pmu_direct_cntr_read(struct kvm_vcpu *vcpu, u8 idx)
> +{
> +	lockdep_assert_preemption_disabled();
> +
> +	if (!kvm_pmu_part_on_cpu(vcpu))
> +		return __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + idx);
> +
> +	if (idx =3D=3D ARMV8_PMU_CYCLE_IDX)
> +		return read_pmccntr();
> +
> +	return read_pmevcntrn(idx);
> +}
> +
> +static void kvm_pmu_direct_cntr_write(struct kvm_vcpu *vcpu, u8 idx, u64=
 val)
> +{
> +	lockdep_assert_preemption_disabled();
> +
> +	__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + idx, val);
> +	if (!kvm_pmu_part_on_cpu(vcpu))
> +		return;
> +
> +	if (idx =3D=3D ARMV8_PMU_CYCLE_IDX)
> +		write_pmccntr(val);
> +	else
> +		write_pmevcntrn(idx, val);
> +}

[ ... ]

> +void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu, unsigned int reg,
> +			      u64 val, bool set)
> +{
> +	unsigned long flags;
> +	u64 mask;
> +	int idx;
> +
> +	guard(preempt)();
> +
> +	switch (reg) {
> +	case PMCR_EL0:
> +		kvm_pmu_direct_pmcr_write(vcpu, val);
> +		break;
> +	case PMSELR_EL0:
> +		if (kvm_pmu_part_on_cpu(vcpu) &&
> +		    !(vcpu->arch.mdcr_el2 & MDCR_EL2_TPM))
> +			write_sysreg(val, pmselr_el0);
> +		__vcpu_assign_sys_reg(vcpu, reg, val);
> +		break;
> +	case PMEVCNTR0_EL0 ... PMCCNTR_EL0:
> +		idx =3D reg - PMEVCNTR0_EL0;
> +		if (vcpu_mode_is_32bit(vcpu) && idx !=3D ARMV8_PMU_CYCLE_IDX)
> +			val =3D (kvm_pmu_direct_cntr_read(vcpu, idx) &
> +			       GENMASK_ULL(63, 32)) |
> +			      lower_32_bits(val);
> +		kvm_pmu_direct_cntr_write(vcpu, idx, val);
> +		break;

[Severity: Low]
Should kvm_pmu_direct_cntr_read() and kvm_pmu_direct_reg_write() mask
general-purpose event counters to 32 bits when the VM does not have
FEAT_PMUv3p5?

kvm_pmu_direct_pmcr_read() and kvm_pmu_direct_pmcr_write() clear
ARMV8_PMU_PMCR_LP when !kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer,
V3P5), and the emulated path in kvm_pmu_get_pmc_value() truncates
general-purpose counters via lower_32_bits() when FEAT_PMUv3p5 is absent.
Here, trapped 64-bit guest accesses to PMEVCNTR<n>_EL0 or PMXEVCNTR_EL0
store and return the full 64-bit value, exposing bits [63:32] to a guest
configured without FEAT_PMUv3p5.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119185215.6323=
34-1-coltonlewis@google.com?part=3D14
