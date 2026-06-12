Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603F9363096;
	Fri, 12 Jun 2026 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781294003; cv=none; b=p9FAQNGkGyIvnwtWwyirkkbjUdzmR1bw9PV/YMcOk+2vYDyOTwPxz0nPbiCVPFU/NQsT1vTk8XP4flfKcp8Gr+CIAFbxEJBCt9AkgzCnMyg4KRV11TjWXY68E/QvoM6Xv30Pwc54Bgn57zQLZCRi4P/mUq27RLzwOObCbB0CyFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781294003; c=relaxed/simple;
	bh=kz2FbhLGl9LRodJ26wa2e3Bgs29CXqhcvDcmjtLbh8M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W8Bp4Ww0mh6m2GCajgtx91T/Y7PlaC54DUWCt/8KHbkBGxBj/C6jzeTcGm/49NgACipXYziqWnBZFUq+yJCJZsJww33H2mfvaT5Kfhyz7MU8FufCI9/sgdJ2mD11076zr4LhIWcntz7AbFjkU5ZE3TRNo/0gBtCS/eR42RoROG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oq7r7hLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oq7r7hLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26701F000E9;
	Fri, 12 Jun 2026 19:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781294002;
	bh=5ElwdHnQSKejgq6ow0GiWQE1dIST4DSNQfNU0hx8ICE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oq7r7hLbrYHX6YYbUSs1eZ/GXfnhGhea63zjtLr1QqPHf+kIed6ajfqiDS7wpMOV/
	 G5DAETB425oWfmVXotZHvYm/ZGi2npQsVEt44I3eQsJYf1+0xMp6yA90HJ7TNgpQfn
	 mhJSB0hDzR0h2MO++doEsDB+/xDw0ffh43Q4RJ7EZ2+suq7Q+pOoL+KDsUUh8Hxn+s
	 KDayZf1sEGCucr4gV7x+E9rqVz6sK3VgsAB4pLHPI0jdqCI40PifWtH7TKMBjA8jdE
	 CLQM/p+gqevTJvtynn9vFROXJyfuHhyqM4+yeKidJHWRZouMhOXIzykNzZAEyBLKF/
	 gISXYAdg/w7Ng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/21] KVM: arm64: Enforce PMU event filter at
 vcpu_load()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260612192909.1153907-13-coltonlewis@google.com>
References: <20260612192909.1153907-13-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:53:20 +0000
Message-Id: <20260612195321.B26701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Missing Context Synchronization Event (isb) after writing PMU even=
t configuration registers before enabling counters.
- [High] Guest PMU counters erroneously count guest EL2 execution when the =
guest hypervisor requested NOT to count at EL2.

Pre-existing issues:
- [High] Guest writes to PMEVTYPERn_EL0 and PMCCFILTR_EL0 under a partition=
ed PMU are trapped but not synchronously propagated to the hardware PMU, br=
eaking dynamic PMU configuration.
--

commit 0b5fddb99fdf908d09da2215064503d365b4feac
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Enforce PMU event filter at vcpu_load()

This commit enforces the KVM PMU event filter by rechecking and applying
the filter on every vcpu load. It excludes counting at all exception levels
if the event is filtered before writing to the hardware.

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -131,6 +131,57 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)

[ ... ]

> +	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
> +		if (i =3D=3D ARMV8_PMU_CYCLE_IDX) {
> +			val =3D __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
> +			evsel =3D ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
> +		} else {
> +			val =3D __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> +			evsel =3D val & kvm_pmu_event_mask(vcpu->kvm);
> +		}
> +
> +		guest_include_el2 =3D (val & ARMV8_PMU_INCLUDE_EL2);
> +		val &=3D ~evtyper_clr;
> +
> +		if (unlikely(is_hyp_ctxt(vcpu)) && guest_include_el2)
> +			val &=3D ~ARMV8_PMU_EXCLUDE_EL1;

[Severity: High]
When the guest is executing at guest EL2 (which runs at host EL1 under
nested virtualization), does this correctly handle the case where the guest
requested not to count at guest EL2?

If guest_include_el2 is false, but the guest's configuration originally had
ARMV8_PMU_EXCLUDE_EL1 cleared (for example, to profile guest EL1), this code
leaves it cleared. Will this cause the hardware PMU to erroneously count
guest EL2 execution at host EL1?

> +
> +		if (vcpu->kvm->arch.pmu_filter &&
> +		    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
> +			val |=3D evtyper_set;
> +
> +		if (i =3D=3D ARMV8_PMU_CYCLE_IDX)
> +			write_pmccfiltr(val);
> +		else
> +			write_pmevtypern(i, val);
> +	}
> +}

[Severity: High]
Does this sequence require a context synchronization event?

According to the ARM64 architecture rules, writes to control-plane system
registers must be followed by an isb() as the very next instruction. This
code loops over the counters and writes the registers without issuing an
isb().

Later, kvm_pmu_load() writes to PMCNTENSET_EL0 to enable the counters:

kvm_pmu_load() {
        ...
        kvm_pmu_apply_event_filter(vcpu);
        ...
        val =3D __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
        write_sysreg(val & mask, pmcntenset_el0);
}

Without an intervening isb(), could the PMU hardware start counting before
the pipeline resolves the new event configurations, leading to spurious
event counts or PMU filter bypass?

[Severity: High]
This is a pre-existing issue, but does applying the event filter only during
vcpu_load() break dynamic PMU configuration when the PMU is partitioned?

When the partitioned PMU is enabled, KVM traps guest writes to PMEVTYPERn_E=
L0
in pmu_reg_write() in arch/arm64/kvm/sys_regs.c:

pmu_reg_write() {
        ...
        if (kvm_pmu_is_partitioned(vcpu->kvm)) {
                mask =3D kvm_pmu_evtyper_mask(vcpu->kvm);
                __vcpu_assign_sys_reg(vcpu, reg, val & mask);
        }
        ...
}

This updates the in-memory sys_regs array but fails to push the new value to
the physical hardware registers or request a KVM_REQ_RELOAD_PMU.

If the guest subsequently enables the counter (which writes directly to the
physical PMCNTENSET_EL0 without a trap delay), the hardware PMU will use the
stale event type. The new configuration and the event filter applied here in
kvm_pmu_apply_event_filter() are delayed until the next VCPU reschedule.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D12
