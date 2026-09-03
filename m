Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8175C4F0526;
	Thu,  3 Sep 2026 16:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453795; cv=none; b=nYefTHe5eJ3i0E9OAsCg2LZBfzIUc09NA+BV+e+Jmd9u6cZ0ihPhG4FiZMYvhKQAW3+cYpJg5R8VlKCW/HQPprV3lkRQe/lbyb4KsqWalQq1S3xMBVxk46QCxPkGbVQVGt6nuIr77rP1FAGN+rZi7jGC3I8KbnCApe2w30sNurs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453795; c=relaxed/simple;
	bh=ruthwdcgNXRMh1iMLpZh+ZVmUdADNUQe5UENTdH8Ojk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dCY7DL2HigV/IFAfR06wMGQzJ9LIfhQFW+UuPnJ4MAyfjX1MvYaKvsxv8Rpt99xrOHN3HnaN8J3r9izfFSmpM6CkUCMm/qXfqPAqFYbyJyk2NLGUgxIm0WePvbarPgMWj8gpwL9FQE7bwvw6YhS/dbKdQFnjc0iIv/KPi8roEOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjGBtaLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjGBtaLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9716A1F000E9;
	Thu,  3 Sep 2026 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788453793;
	bh=GrNFBaQ/bi9wTfwsPk8pg2hjAaH4xTOE5iqvD7edL3g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KjGBtaLNTY4GXwRNT+d0Eg2v98Uar+vMtvG5FNEDHIkYlHTLZa97FYgvLvzbA+rY0
	 d/uai079trgaTLLbsaIF1b43ao1pnviPnsKIuJzrN5pQdOs5pB1dQHWb4iu5+SJyfG
	 4lrKl4aXUvesS7vN5kFpsAdgACpUQo/lckqtg0nhBznzR8UlwgTfX26slDymoUc2ID
	 /jEFtOo1hd1J6bUvyEFMN+i9xQy80Ar1y9mMCSf0d8Jz3OskjBweYsHfrFPIxU30PR
	 e4TGJDiBuQlEiLan5Pg+zqASqiWe+zAz7Y1dah8pAsrl6CaCUMF/7R0Ec0SGcG6O9R
	 OJ+//+Y6jGVbA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 19/28] KVM: arm64: VHE: Context switch SPE state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-20-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-20-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:43:13 +0000
Message-Id: <20260903164313.9716A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Writing to PMBSR_EL1 after enabling the SPE profiling buffer via P=
MBLIMITR_EL1 is CONSTRAINED UNPREDICTABLE and can corrupt hardware events.
- [High] Host SPE sampling control registers (e.g., PMSNEVFR_EL1, PMSDSFR_E=
L1) can be permanently corrupted by a malicious guest.
--

commit 32125a6226fde42baaf9001e75434e4177067f24
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: arm64: VHE: Context switch SPE state

Save and restore the SPE register state when a VCPU is run. The SPE
resources are shared between the guest and the host (the resources are not
partitioned) so KVM has to save the host state, change the owning
translation regime, and then restore the guest state before entering a
guest.

> diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe=
-sr.c
> new file mode 100644
> index 0000000000000..978620ad99fa5
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> @@ -0,0 +1,209 @@
[ ... ]
> +static void __kvm_spe_save_sampling_regs(struct kvm *kvm, struct kvm_cpu=
_context *ctxt)
> +{
> +	/*
> +	 * This is dependent on the VM features, and not the hardware features,
> +	 * even for the host, because (a) guest accesses to PMSNEVFR_EL1 and
> +	 * PMSDSFR_EL1 result in an undefined exception in the guest and (b)
> +	 * they don't affect the guest unless the guest explicitly enables them,
> +	 * and a well-behaved guest shouldn't enable them when the corresponding
> +	 * feature is not advertised.
> +	 */
> +	if (kvm_spe_has_feat_spe_fne(kvm))
> +		ctxt_sys_reg(ctxt, PMSNEVFR_EL1) =3D read_sysreg_s(SYS_PMSNEVFR_EL1);

[Severity: High]
Does this check of the guest's advertised features (kvm_spe_has_feat_spe_fn=
e)
leave the host's sampling control registers vulnerable to corruption?

If the host physically supports FEAT_SPE_FNE but the KVM VM does not
advertise it, KVM will skip saving and restoring the host's PMSNEVFR_EL1
register. Because MDCR_EL2.TPMS =3D 0 is cleared on guest entry, these
registers will not trap to EL2.

A malicious guest could execute an msr instruction to PMSNEVFR_EL1 directly,
overwriting the hardware register. When the guest exits, KVM skips restoring
the host's value in __kvm_spe_restore_sampling_regs(), allowing the guest's
malicious configuration to persist in the host execution context.

Could this be checking the host's physical capabilities instead of the VM's
advertised features when saving and restoring host state?

[ ... ]
> +void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm=
_cpu_context *guest_ctxt)
> +{
> +	u64 pmblimitr, pmbsr;
> +
> +	pmbsr =3D ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
> +	pmblimitr =3D ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
> +	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
> +		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
> +		isb();
> +		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
> +		isb();
> +		/* A buffer management event preserves fields in PMBSR_EL1 */
> +		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);

[Severity: High]
Is it safe to write to PMBSR_EL1 after enabling the SPE profiling buffer via
PMBLIMITR_EL1?

According to the ARM Architecture Reference Manual, when the profiling buff=
er
is enabled, a direct write to PMBSR_EL1 is constrained unpredictable. This
can corrupt hardware events or lead to unknown exceptions.

In __kvm_spe_restore_host_state_vhe(), the PMBSR_EL1 register is correctly
restored before PMBLIMITR_EL1. Should the guest restoration follow the same
sequence to avoid unpredictable behavior?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D19
