Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD354A386D;
	Thu, 24 Sep 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790273241; cv=none; b=bXQZLAjN9qkbmQgpH9Z9DWx+/rQ+3/4McnbR+KplQE/LThbv5Hvxc6oxMpkWBrpbGIeG4kS7yBBqoK59Mm+1YuBuAzwKOgMik1TnOWL8UrkILF1fHhuJYUoJIPMcO5RaEQbT/WAstlHutnj/dUcLCM8RLu/lGeCfyYzC9jOVK50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790273241; c=relaxed/simple;
	bh=QTADa+FhIxUlxG6MXI1foJIul5G3DiJBAFn/qjY0HNw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CS8t2x3AS1B7Zvb5nvmkiNJjVneKJnKSDxS7TUtGYd+L6f2SSyjU8DWv7mJWpy7ZfxmTO1/dycxbMU0cjUPfwnkfkzQOOBU89/n6Ga1EGdhBGH3Ry455lMos9WuZ38Yk5R6aOuUTeCKfeWpsr/1llPZHWWHYUL6UbDWx/fuYtqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nl0xuJIT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nl0xuJIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DF81F000FF;
	Thu, 24 Sep 2026 18:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790273240;
	bh=g/EOuW3OQyQk+/jztAPPOuiWKoxO/McPBzlGeSgrEOQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nl0xuJITVygldgfdyf706DX7nG34pg7uHEwKUBL6eKWKzVisoJQ90dmp3FHsVO4Pv
	 Ulz+2HwOvhixfCWyCO2d+jR59xj3hlxAYZS4umURLi24t0WM+gV4gk5pZW/fesywrA
	 gxYv/84vy6ieduqwGtqEtw/8u9JsPQFYRkhnTQ7HN6OJSVGl/cYGAAZFjdR/ib2Qpw
	 +H38B+OqtJxAx7Sle5n2/0l3YJmPIMZq/gAlIUc8zUgM3TBhwGwAKuK5zOreqdxXuE
	 PQWDXE4QfscEaeu5u3aPrOg+4+9ZbMJdH+5bIzTACv8i9L5eDC/gGNP00AzDn+Zz7z
	 NWrC42d/u6Upg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 19/22] KVM: arm64: Detect overflows for the
 Partitioned PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260924172928.2110956-20-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-20-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 18:07:19 +0000
Message-Id: <20260924180719.93DF81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] kvm: arm64: PMU partition clears hardware PMOVSSET_EL0 without=
 restore
- [High] kvm: arm64: Data race in PMOVSSET_EL0 update against NMI handler
- [Medium] kvm: arm64: kvm_pmu_should_notify_user() indirectly alters hardw=
are PMU state
--

commit ff8f6a7646a20c591702abbe44679f3e9bd4462d
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Detect overflows for the Partitioned PMU

When re-entering the VM or synchronizing PMU state after a guest counter
overflow interrupt, evaluate whether any enabled and unmasked guest
counter has overflowed and update the virtual PMU interrupt level in
the vGIC accordingly.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c

[ ... ]

> @@ -534,6 +534,61 @@ void kvm_pmu_handle_guest_irq(u64 pmovsr)
> =20
>  	for_each_set_bit(i, (unsigned long *)&govf, 64)
>  		set_bit(i, (unsigned long *)__ctxt_sys_reg(&vcpu->arch.ctxt, PMOVSSET_=
EL0));
> +
> +	if (kvm_pmu_part_overflow_status(vcpu)) {
> +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +
> +		if (!in_nmi())
> +			kvm_vcpu_kick(vcpu);
> +		else
> +			irq_work_queue(&vcpu->arch.pmu.overflow_work);
> +	}
> +}
> +
> +/**
> + * kvm_pmu_part_overflow_status() - Determine if any guest counters have=
 overflowed
[ ... ]
> +bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
> +{
> +	u64 mask =3D kvm_vcpu_pmu_guest_counter_mask(vcpu);
> +	u64 pmovs, pmint, pmcr;
> +	unsigned long flags;
> +	bool overflow;
> +
> +	local_irq_save(flags);
> +	if (vcpu->arch.pmu.loaded_on_cpu &&
> +	    vcpu =3D=3D kvm_get_running_vcpu()) {
> +		u64 hw_ovf =3D read_sysreg(pmovsset_el0) & mask;
> +
> +		if (hw_ovf) {
> +			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=3D, hw_ovf);

[Severity: High]
Is this non-atomic update vulnerable to a race with pseudo-NMIs?

Since local_irq_save() does not mask pseudo-NMIs on ARM64, the PMU interrupt
can fire as an NMI and invoke kvm_pmu_handle_guest_irq(), which updates this
exact software state using an atomic set_bit().

When the NMI returns, this interrupted non-atomic read-modify-write
operation will complete and could silently overwrite the NMI handler's
updates, resulting in lost interrupts and corrupted hardware state.

> +			write_sysreg(hw_ovf, pmovsclr_el0);

[Severity: Critical]
Does this break the guest's ability to read the overflow bit?

The hardware overflow register is cleared here and the state is saved to the
software context, but the canonical software state is never written back to
the hardware before the guest accesses it directly.

Because the partitioned PMU grants the guest direct, untrapped EL0/EL1
access to PMOVSSET_EL0 for its assigned counters, failing to restore this
will cause the guest to read a cleared hardware register (a 0 value) upon
resuming execution, permanently breaking its ability to identify which
counter overflowed.

> +		}
> +		pmint =3D read_pmintenset();
> +		pmcr =3D read_pmcr();
> +	} else {
> +		pmint =3D __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
> +		pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0);
> +	}
> +
> +	pmovs =3D __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
> +	local_irq_restore(flags);
> +
> +	overflow =3D (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
> +
> +	if (overflow && kvm_pmu_get_access(vcpu) =3D=3D VCPU_PMU_ACCESS_FREE)
> +		kvm_pmu_set_guest_owned(vcpu);
> +
> +	return overflow;
>  }

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c

[ ... ]

> @@ -296,8 +296,14 @@ bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcp=
u)
>  {
>  	struct kvm_sync_regs *sregs =3D &vcpu->run->s.regs;
>  	bool run_level =3D sregs->device_irq_level & KVM_ARM_DEV_PMU;
> +	bool overflow;
> =20
> -	return kvm_pmu_overflow_status(vcpu) !=3D run_level;
> +	if (kvm_pmu_is_partitioned(vcpu->kvm))
> +		overflow =3D kvm_pmu_part_overflow_status(vcpu);

[Severity: Medium]
Does this call introduce hardware-altering side effects into a runnable
status predicate?

kvm_arch_vcpu_runnable() evaluates kvm_pmu_should_notify_user() in sleep
polling loops (like kvm_vcpu_block). However, kvm_pmu_part_overflow_status()
conditionally transitions PMU access to VCPU_PMU_ACCESS_GUEST_OWNED and
invokes kvm_pmu_load(), forcing hardware register writes from a pure getter.

Triggering hardware reprogramming inside waitqueue checks violates
architectural layering and could introduce latency or synchronization issue=
s.

> +	else
> +		overflow =3D kvm_pmu_emul_overflow_status(vcpu);
> +
> +	return overflow !=3D run_level;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D19
