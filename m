Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5571D63F0;
	Fri, 12 Jun 2026 19:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293883; cv=none; b=AclayFykX7c9t+u+EHmkNbegiI1LRoSwfLlgcNHTvKsSxFxp/OadKD4s1423L+14GrnOPswnjq8pTfXHbgz+zwq1b+2tIjzRtJL91uQCCAY1GludXVGAeUsAbxs2diEvgtApLy6iNM2PkqbBDltpQ2cR46KBuvIYdP3C1N01Jt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293883; c=relaxed/simple;
	bh=Tiukp5C0ikHreHq5IHQkN2/JeEa310UbgXv2jOEwtrg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SWNbVOFPHvOwsM6i9FfGcycVqed6bAVCXmDLAjosPHG6acDSBW91dFYGd0Nvv+xAbaNwX41qpxGxndyzFXS3rjHHDp0ieCFYPHLGbShrpTBb+Ft1PQ/VPjq3KCqsAGGEc3BJmVS8mKF1pGCtkUWrPwLUZieubLujIa6qCBHvyM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hd1XjLOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hd1XjLOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC171F000E9;
	Fri, 12 Jun 2026 19:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781293882;
	bh=QMoCozeInde8P/rmaUvxrHGH2PEH2FqYDNLhAOVbcPE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hd1XjLOsSyGm9hOjcspVOUXMV/mPG8OIQfk/vCylkGw6dcJ7qlNCOl6lQC5+5OBbA
	 k+FpItBgUrwDjmeLgS9UM6oKA+auMSH/FGBlD3/+6goUngge8hf/KNU6gN02KDsHx9
	 5IzeUZmE9DUcNHs4rqWSfE8dlgQV52qQttS5lF27EWGBoaq8sX5FhXyKs4rk71skHj
	 cknCnMIv96cJ4PCy6fNC07wcf7mjXVI/nskM3YDYeml5Nz/0snP6NzUwO+bjOdVU0l
	 TjDM6WxghJZl4rCUAq9fdvkg7XZ9ehiFkH8H5V+dk9HSyB10meb7/3Gm3jQwwezNGM
	 zN30R59x6A6/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/21] KVM: arm64: Add Partitioned PMU register trap
 handlers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260612192909.1153907-10-coltonlewis@google.com>
References: <20260612192909.1153907-10-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:51:21 +0000
Message-Id: <20260612195122.0EC171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Writes to PMU control-plane system registers lack the architectura=
lly mandated immediate `isb()` synchronization barrier.
- [High] Trapped accesses to `PMEVTYPER`, `PMCCFILTR_EL0`, and `PMOVSSET_EL=
0` fail to synchronize with the active hardware PMU state while the vCPU is=
 running.
- [High] `kvm_pmu_direct_pmcr_read` bypasses Nested Virtualization (NV) cou=
nter limits, exposing incorrect `PMCR_EL0.N` to L2 guests.
- [High] Guest `PMSELR_EL0` and `PMUSERENR_EL0` state is irrevocably lost a=
cross vCPU context switches in partitioned PMU mode.
--

commit 62a57b5fbe8c480374618085132cc6e2e40657b1
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Add Partitioned PMU register trap handlers
   =20
We may want a partitioned PMU but not have FEAT_FGT to untrap the
specific registers that would normally be untrapped. Add handling for
those trapped register accesses that does the right thing if the PMU
is partitioned.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 0135989667564..43f04c2f33d44 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -56,3 +57,32 @@ bool kvm_pmu_is_partitioned(struct kvm *kvm)
>  	return pmu_is_partitioned(kvm->arch.arm_pmu) &&
>  		test_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
>  }
> +
> +void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
> +{
> +	bool reset_p =3D val & ARMV8_PMU_PMCR_P;
> +	unsigned long mask;
> +	int i;
> +
> +	val &=3D ~ARMV8_PMU_PMCR_P;
> +
> +	write_sysreg(val, pmcr_el0);
> +
> +	if (reset_p) {

[Severity: High]
Does this write to pmcr_el0 need an isb() barrier before we evaluate reset_=
p?

The ARM64 architecture requires updates to control-plane system registers
like pmcr_el0 to be followed immediately by an isb() instruction. Without
it, the pipeline might execute the subsequent instructions under an undefin=
ed
state.

> +		mask =3D kvm_pmu_implemented_counter_mask(vcpu) & ~BIT(ARMV8_PMU_CYCLE=
_IDX);
> +
> +		if (!vcpu_is_el2(vcpu))
> +			mask &=3D ~kvm_pmu_hyp_counter_mask(vcpu);
> +
> +		for_each_set_bit(i, &mask, ARMV8_PMU_MAX_GENERAL_COUNTERS)
> +			write_pmevcntrn(i, 0);
> +	}
> +}
> +
> +u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
> +{
> +	return u64_replace_bits(
> +		read_sysreg(pmcr_el0),
> +		vcpu->kvm->arch.nr_pmu_counters,
> +		ARMV8_PMU_PMCR_N);

[Severity: High]
Can this bypass Nested Virtualization counter limits and expose an incorrect
PMCR_EL0.N value to L2 guests?

The existing kvm_vcpu_read_pmcr() function properly accounts for nested
virtualization by checking for nested guests and restricting PMCR_EL0.N bas=
ed
on the L1 hypervisor's MDCR_EL2.HPMN limit. This direct read inserts the
full vcpu->kvm->arch.nr_pmu_counters, which means L2 guests under a
partitioned PMU might escape the L1 limit and observe the full count
provisioned to L1.

> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c52873a6f91ed..94572bc52c32a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> +static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u=
64 val, bool set)
> +{
> +	unsigned long flags;
> +	u64 mask;
> +	int idx;
> +
> +	switch (reg) {
[ ... ]
> +	case PMSELR_EL0:
> +		if (kvm_pmu_is_partitioned(vcpu->kvm))
> +			write_sysreg(val, pmselr_el0);

[Severity: High]
Does this need an isb() after writing pmselr_el0? Like pmcr_el0, writes to
control-plane registers require an immediate synchronization barrier before
returning or executing further instructions.

Also, if we are untrapping or writing directly to the physical pmselr_el0
and pmuserenr_el0 registers, won't this state be irrevocably lost across
vCPU context switches?

When entering a guest, __activate_traps_common() in
arch/arm64/kvm/hyp/include/hyp/switch.h unconditionally clobbers the
physical pmselr_el0 to 0 and pmuserenr_el0 to ARMV8_PMU_USERENR_MASK.
Any state restored by kvm_pmu_load() or set here would be destroyed
before the guest actually executes.

[ ... ]
> +	case PMEVTYPER0_EL0 ... PMCCFILTR_EL0:
> +		idx =3D reg - PMEVTYPER0_EL0;
> +
> +		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
> +			mask =3D kvm_pmu_evtyper_mask(vcpu->kvm);
> +			__vcpu_assign_sys_reg(vcpu, reg, val & mask);

[Severity: High]
Since traps are processed synchronously while the vCPU is loaded, doesn't
updating only the virtual sysreg array leave the active hardware with stale
configurations?

Writing to the virtual array here without requesting a PMU reload
(KVM_REQ_RELOAD_PMU) or updating the hardware means that upon ERET back to
the guest, the physical PMU will continue executing with the old state.

[ ... ]
> +	case PMCNTENSET_EL0:
> +		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
> +			if (set)
> +				write_sysreg(val, pmcntenset_el0);
> +			else
> +				write_sysreg(val, pmcntenclr_el0);

[Severity: High]
Does returning after this write without an isb() violate the architectural
requirements?=20

Writing to pmcntenset_el0 or pmcntenclr_el0 needs an immediate isb() to
ensure the state change is resolved before returning to the caller or
executing subsequent pipeline instructions.

[ ... ]
> +	case PMUSERENR_EL0:
> +		if (kvm_pmu_is_partitioned(vcpu->kvm))
> +			write_sysreg(val, pmuserenr_el0);

[Severity: High]
Is an isb() barrier required here after writing pmuserenr_el0, similar to t=
he
other control-plane registers?

[ ... ]
> +static u64 pmu_reg_read(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
> +{
> +	u64 val =3D 0;
> +	int idx;
> +
> +	switch (reg) {
[ ... ]
> +	case PMOVSSET_EL0:
> +		val =3D __vcpu_sys_reg(vcpu, reg);

[Severity: High]
Will this return an accurate value if there are unhandled physical hardware
overflows?

Because we only read the virtual array here, we could mask unhandled physic=
al
hardware overflows from polling guests if the host hasn't yet processed the
IRQ and updated the virtual state.

> +		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D9
