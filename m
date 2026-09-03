Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01C04A3F0D;
	Thu,  3 Sep 2026 16:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454141; cv=none; b=VTVsFVInUahwbSFHW+JO550DJ2THrlM07DVupcCBaGXRc0x8OiRK49wxRBF/Fet8wHYkNKY9SRSF/by0RZfVXuE1HKhFsVJczWTgbRO8V8UG3AR31X8FPfet3d4hIbeWTG+VMW0CIsXStVInX+VZygu06AOkMnvpQu6CcxAuTuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454141; c=relaxed/simple;
	bh=Z/Wm7259/ZiwtipWSc4z34MSksQQdsmekZtVDxpDQSo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FehZsRH2n82onmiRHCYGpkhtTAfLE6LUBp0wYYfCmePe/Pi9kuEgANNhWHzwL0tqxr538IOfmypxNL7xGi9GzTMMEwX7LeSnwXv7vLhLVn42ARlAun9i+z6WWXpBU0dJxfO7xX3dFfNx53N+Yi5cgR94bnglXfEyTnDX5s26Zc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4ywP/wi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4ywP/wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55DC1F000E9;
	Thu,  3 Sep 2026 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788454139;
	bh=vzmcTJYNjPdYn12zhqDO5qR4Zxbk1TgjV9BMrV7uBqo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k4ywP/wipNESNcttJ6pZHELr0DCOr8TnYXefjaVWOEvT6Kqo2QJRuIASxO3tOGbr6
	 nlNtcI+YpI7IyR7L71fMe0bKeM6mBoxG6kbkfdWc8ypEhrR05BNJ3xcvCsB0GXjVQd
	 Be1ZMI6o7zUFrRd/VhKXWvbJya0dHgkzU6ck+B0krc/WmOyGZYLuxZOLWK535/OQ+8
	 r0KX9hKyXLhZzSTbCGoVAmCAVg6d9HAthNukigvTyrNEi+FNiryB0CahLImU4OQ1wn
	 ko0oNmSDEanxz3hI/CH58sNFgiLx0xBw0/EIjZ9PIsd2Z1KHHaf0ouTnyi5hdZZM4k
	 l74CGroTaHufg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 20/28] KVM: arm64: Allow guest SPE physical
 timestamps only if kernel allows it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-21-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-21-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:48:58 +0000
Message-Id: <20260903164858.E55DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Inverted logic for `perf_allow_kernel()` grants physical timestamp=
s to unprivileged users and denies them to privileged users.
- [High] Capability check `perf_allow_kernel()` is evaluated at `KVM_RUN` t=
ime (TOCTOU) instead of VM/VCPU configuration time.
- [Medium] Silently-on guest-visible feature (SPE physical timestamps) brea=
ks live migration and violates subsystem guidelines.
- [Medium] Concurrent first `KVM_RUN` invocations on multiple vCPUs cause a=
 data race on the VM-wide `kvm_spe->guest_pmscr_el2`.
--

commit 8640bfaf0b943972e8c97350b961b39b15830f1b
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: arm64: Allow guest SPE physical timestamps only if kernel allows it

The SPE driver allows userspace to use physical timestamps for records only
if the kernel allows it, do the same for a virtual machine.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe=
-sr.c
> index 978620ad99fa5..3c32a1338cc8d 100644
> --- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c

[ ... ]

> @@ -120,10 +121,10 @@ void __kvm_spe_restore_guest_state_vhe(struct kvm_v=
cpu *vcpu, struct kvm_cpu_con
>  		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
>  	}
> =20
> -	__kvm_spe_restore_sampling_regs(vcpu->kvm, guest_ctxt);
> +	__kvm_spe_restore_sampling_regs(kvm, guest_ctxt);
> =20
>  	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
> -	write_sysreg_el2(0, SYS_PMSCR);
> +	write_sysreg_el2(kvm->arch.kvm_spe.guest_pmscr_el2, SYS_PMSCR);

[Severity: Medium]
Can this read of kvm->arch.kvm_spe.guest_pmscr_el2 race with a concurrent
write from another vCPU?

If multiple vCPUs are starting their first KVM_RUN, one vCPU might complete
kvm_arch_vcpu_run_pid_change(), proceed to enter the guest, and execute
__kvm_spe_restore_guest_state_vhe(), reading guest_pmscr_el2.

Because kvm_spe_vcpu_first_run_init() performs unlocked writes to this
shared VM-wide variable, another vCPU could be modifying it at the same
time. Should this use READ_ONCE() and WRITE_ONCE() to prevent LKMM
violations and KCSAN data race splats?

>  }
>  NOKPROBE_SYMBOL(__kvm_spe_restore_guest_state_vhe);
> =20
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index af1e19cb8e9ae..68b751bdb384b 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c

[ ... ]

> @@ -97,6 +99,12 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  	if (!kvm_spe->pmblimitr_el1_res0_mask)
>  		kvm_spe_compute_pmblimitr_el1_res0_mask(kvm);
> =20
> +	if (kvm_vm_has_ran_once(kvm))
> +		return 0;
> +
> +	if (perf_allow_kernel())
> +		kvm_spe->guest_pmscr_el2 =3D PMSCR_EL2_PCT_PHYS;

[Severity: High]
Does this logic invert the intended permission check?

The perf_allow_kernel() function returns 0 on success (access granted) and
a negative error code (like -EACCES) on failure. By evaluating to true when
access is denied, it seems we might be granting physical timestamps to
unprivileged users and incorrectly denying them to privileged users.

[Severity: High]
Is kvm_spe_vcpu_first_run_init() the right place to check these
capabilities?

Checking perf_allow_kernel() here means it is evaluated during the KVM_RUN
ioctl, rather than during VM configuration. VMMs typically configure VMs
with full privileges but drop privileges before executing KVM_RUN for
sandboxing. Checking at KVM_RUN time will incorrectly deny physical
timestamps to properly sandboxed VMMs.

Furthermore, an unprivileged process could configure a VM and pass the vCPU
file descriptor to a privileged process, improperly gaining access to
physical timestamps using the privileged thread's capabilities.

[Severity: Medium]
Could silently enabling SPE physical timestamps based on the host kernel
break live migration?

If a VM is migrated from a host where perf_allow_kernel() grants access to
one where it denies it, the guest would silently downgrade to virtual
timestamps, causing data corruption in the profiling trace.

The KVM guidelines require that new behavior the guest can observe must be
off by default and explicitly enabled through standard capability
negotiation (like a KVM_CAP_* or ID register flag). Should this require an
explicit opt-in from userspace instead?

[Severity: Medium]
Can this write to kvm_spe->guest_pmscr_el2 happen concurrently across
multiple vCPUs?

The kvm_vm_has_ran_once(kvm) flag is not set until the end of
kvm_arch_vcpu_run_pid_change(), which happens after
kvm_spe_vcpu_first_run_init() completes. If multiple vCPUs start their
first KVM_RUN concurrently, they will all see kvm_vm_has_ran_once(kvm) as
false and write to this shared variable without synchronization.

> +
>  	return 0;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D20
