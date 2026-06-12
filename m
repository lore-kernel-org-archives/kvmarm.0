Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1BE3537EE;
	Fri, 12 Jun 2026 19:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293876; cv=none; b=u9vfryxxv2knpY1yqh0MOohUvz0Lt1m+ryr3UE8WMeb4Zbmh6NTjGusDLQvmzD0zPYWQ8b9zD/A0hheoo5wjCkmoBlzFh60Viu8TPTJOFQcMMO4DkzE6NMiG/5eYyhQB6s4ZrIXZv8bGCp8YHtV6RQtiXi7+B4f3q6WGZ9SbUOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293876; c=relaxed/simple;
	bh=sTTYTbIyngo+CBUo+iR9kmt6aqUcyTbel6PLWbcR55I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u/7UKXUQuLGctT8PveeaPmLPri1BCRMS/cEhz3jPjkCiYSaYwLqlLCsbbyhL3RqCDrhVfmCgX+60DIn0VpL9kX8Y4wTFBGu4Ac3T8u81YZkiZ8b0/PVsctrl7wFpRjZjAHSsNHGHfTT96j/lSPgkENnsLZQqiaaJH0RFTixwAmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LpHefjrC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LpHefjrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098F21F000E9;
	Fri, 12 Jun 2026 19:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781293875;
	bh=Zv3gXuC99QH0pIrsO4C9yU69SM07F+ECJZ974l0tp7s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LpHefjrCMC0cBsmVqRIRMdJyuol0FJU4tVvWLHDxRVfnkXRmwnRw5VYPGY/AXaF01
	 0Sj+2xg1yd8A3TdW0zxd6iNPi3M8Vmtpj9X6z7QafsU8gRMB/PBscQ+8Tvgic5kCED
	 5fHt5j5bKsLqabSapjQQL53c8ya+dwOM3+6sW0+IDe0VRYuA0SSWaBOlvmW0izHExG
	 NE8+Jag5jjjXGgfsBbsJGPgviq7ERsQsLJPQLYH9HxD7kYE6ngbf2I5EUZewl2K55G
	 8Bhr8lAt6Lm0Ft5FuKRAKhxyNafGds7EAGtqIloMvZ9pxpqwDhpPde4+PqCP2qn+Xs
	 6X2k/33gQ6obg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/21] KVM: arm64: Context swap Partitioned PMU guest
 registers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260612192909.1153907-12-coltonlewis@google.com>
References: <20260612192909.1153907-12-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:51:11 +0000
Message-Id: <20260612195112.098F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] TOCTOU race in `kvm_pmu_put()` leads to lost hardware overflows an=
d inconsistent counter values.
- [High] `kvm_pmu_put()` clobbers the guest's virtual `PMCR_EL0` with host =
physical read-only fields.
- [High] Out-of-bounds bit shift and undefined behavior in `GENMASK_ULL` fo=
r `kvm_pmu_host_counter_mask()`.
- [High] Missing mandatory `isb()` after writing control-plane PMU register=
s in `kvm_pmu_put()`.
- [High] Guest accesses to the trapped `PMOVSSET_EL0` register return stale=
 data, causing the guest to permanently miss PMU overflows.
--

commit 1e067bf0381df5bfe1db83a20f08aa650fd65999
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Context swap Partitioned PMU guest registers

This commit saves and restores untrapped PMU registers when the PMU is
partitioned, bypassing the context swap for emulated vPMUs. It also clears
PMOVS guest hardware counters to avoid generating spurious interrupts.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 43f04c2f33d44..79022447cfb9a 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c

[ ... ]

> +u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
> +{
> +	u8 nr_counters =3D *host_data_ptr(nr_event_counters);
> +
> +	if (pmu_is_partitioned(pmu))
> +		return GENMASK_ULL(nr_counters - 1, pmu->max_guest_counters);

[Severity: High]
Does this code trigger undefined behavior if the PMU implements zero event
counters or if the guest is configured to use all available counters?

If nr_counters =3D=3D 0, nr_counters - 1 evaluates to -1, resulting in
GENMASK_ULL(-1, 0), which expands to a right shift by 64.

If max_guest_counters =3D=3D nr_counters, the high bound is strictly less t=
han
the low bound, violating the macro's constraints. Both cases require
explicit bounds checking.

> +
> +	return ARMV8_PMU_CNT_MASK_ALL;
> +}

[ ... ]

> +void kvm_pmu_put(struct kvm_vcpu *vcpu)
> +{

[ ... ]

> +	val =3D read_sysreg(pmselr_el0);
> +	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
> +
> +	val =3D read_sysreg(pmcr_el0);
> +	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, val);

[Severity: High]
Can this clobber the guest's virtual PMCR_EL0 with host-specific read-only
fields?

By reading the raw hardware pmcr_el0 and directly assigning it to the vCPU
state, KVM overwrites the virtualized read-only fields (such as IMP, IDCODE,
and N) with the host's physical values.

This might serialize the leaked host topology when userspace reads the
register, causing migration issues if the VM is moved to a host with
different PMU capabilities.

> +
> +	/* Mask these to only save the guest relevant bits. */
> +	mask =3D kvm_pmu_guest_counter_mask(pmu);

[ ... ]

> +	/* Save pending guest hardware overflows. */
> +	local_irq_save(flags);
> +	val =3D read_sysreg(pmovsset_el0);
> +	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=3D, val & mask);
> +	write_sysreg(val & mask, pmovsclr_el0);
> +	local_irq_restore(flags);
> +
> +	/* Stop guest counters and disable interrupts in hardware. */
> +	write_sysreg(mask, pmcntenclr_el0);

[Severity: High]
Does this create a race condition where hardware overflows can be
permanently lost?

The hardware counters are still running while kvm_pmu_put() reads their
state and the overflow register. A counter might overflow in the window
between reading pmovsset_el0 and stopping the counters with pmcntenclr_el0.

If the guest had disabled physical PMU interrupts for that counter, no IRQ
fires to rescue the overflow state. The overflow bit remains set in hardware
but is missed by KVM, and when the vCPU is scheduled back in, kvm_pmu_load()
will unconditionally clear pmovsclr_el0, destroying the unrecorded overflow.

Also, does this design lead to stale reads when the guest polls for
overflows?

Since the counters run directly in hardware without syncing back to memory
until vcpu_put, if a guest traps to pmu_reg_read() in
arch/arm64/kvm/sys_regs.c to read PMOVSSET_EL0:

pmu_reg_read()
    case PMOVSSET_EL0:
        val =3D __vcpu_sys_reg(vcpu, reg);
        break;

It will receive the stale in-memory value instead of seeing the active
hardware overflow accumulating in the physical register.

> +	write_sysreg(mask, pmintenclr_el1);
> +
> +	kvm_pmu_set_guest_counters(pmu, 0);
> +	preempt_enable();
> +}

[Severity: High]
Are we missing a mandatory Context Synchronization Event here?

After writing to control-plane registers like pmcntenclr_el0 and
pmintenclr_el1, an isb() must follow to ensure the CPU pipeline
resolves the new configuration.

Without the barrier, the CPU could continue executing the host kernel using
a stale configuration, potentially allowing hardware counters to run and
deliver spurious physical PMU interrupts during host execution.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D11
