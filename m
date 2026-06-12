Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6FF7E0FF
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781248766; cv=none; b=bJJKHZY1SvX3vUL6C0oVFKENJmmyIygVucq4RWjbgkX5cv/gxop9jdHtkkPCdRz++JlkUBZQsMyO6WghNZKaRoCrzA9q/MA6b1ntkbsLm023joYnGyXFH0RMaJ9d0QNu+c3OW1FV13EksR1XjljVm5v0KxZBe1D7gj8Q1OWyRfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781248766; c=relaxed/simple;
	bh=nRspC37WIaw6uBSJUsMMOLIc2MN0j+s0h56sbh9e+0I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tdxJwdtfDITzQe/Z8EFF89KA8H8BWbqhCGCqixIICEaKnMbfaqsulwSTDjBhxpsxULTcW0c2BjxG1r0ZPyXfwwyHtFd+NB5Ipjy+ggOmCkCHhYeCbsTFfZG/hLWmFut3NIKFUnxPFjK+Cb/y0Zb7i0pIs0sROkxh+0N15J7wIv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngjXlWbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngjXlWbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480E41F000E9;
	Fri, 12 Jun 2026 07:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781248764;
	bh=hBwosOfKeS4BgWh7sjsEn7o+3PovQQ70XUvBq46rGMY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ngjXlWblWuahAR95r8Jd/gWsKIBiZYRXBP8jDL/L/1keEgbEPXBl5+ex6BQqwNP64
	 W1QUDTXG3wQN0fRcWBk41kt5ZFE6pRmK+vQ1LWCsjKJi3yBXQs1o3oWQRg/9oGugsm
	 fNUHtZvBg75MIpYV7mCGJ+GWsVRQg0QVMw+ArwR0VvUama6iJh14CTdLrctS6gm5It
	 rlNqHgQXB7CfbCO2UX8DPkVcdJ1IO833tOWM1/QA3R8sRWOUo/uJ0dz+MME3CPHvFE
	 X8bZjA4gfF6Puzd6Dq00KSFrmM1UL4sx++pYgFXdj0IkBUzdXKYXV1LR6rhbL3gKuD
	 wb4bAYgeJPG/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 11/11] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: tabba@google.com
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260612065925.755562-12-tabba@google.com>
References: <20260612065925.755562-12-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 07:19:23 +0000
Message-Id: <20260612071924.480E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Lazy vCPU state sync bypasses vcpu_mode_is_bad_32bit() check on no=
n-trap VM exits due to stale CPSR.
- [High] Exceptions injected by the host and other context modifications du=
ring the KVM_RUN loop are silently dropped, causing infinite VM exit loops =
or ignored requests.

Pre-existing issues:
- [Critical] Protected VM register state is unconditionally copied between =
the hypervisor and untrusted host, violating pKVM confidentiality and integ=
rity guarantees.
--

commit 96ecd36038c29097f333a40bf0eebd7b62bffc92
Author: tabba@google.com <tabba@google.com>
Subject: KVM: arm64: Implement lazy vCPU state sync for non-protected guests

This commit implements lazy synchronization of vCPU register state for
non-protected guests running under pKVM. It defers copying the context from
the host to the hypervisor until the host marks it dirty, and from the
hypervisor to the host until the host requires it. The PC is synced on every
exit to maintain accurate tracepoints.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b6..dccc3786548b0 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
[ ... ]
> @@ -489,6 +504,13 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception=
_index)
>  /* For exit types that need handling before we can be preempted */
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  {
> +	/*
> +	 * We just exited, so the state is clean from a hypervisor
> +	 * perspective.
> +	 */
> +	if (is_protected_kvm_enabled())
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +

[Severity: High]
When a guest exits (such as for ARM_EXCEPTION_IL or an IRQ), this clears the
PKVM_HOST_STATE_DIRTY flag.

If the host handles the exit or processes pending requests (like
KVM_REQ_VCPU_RESET or injecting undefined/SErrors), those operations modify
the host's copy of the guest register context (vcpu->arch.ctxt).

However, since these paths bypass handle_trap_exceptions(), the
PKVM_HOST_STATE_DIRTY flag is never set again.

On the next guest entry, flush_hyp_vcpu() at EL2 will see the dirty flag is
clear and skip calling __flush_hyp_vcpu().

Will this cause exceptions injected by the host and other context modificat=
ions
made during the KVM_RUN loop to be silently dropped? For ARM_EXCEPTION_IL,
does this mean the hypervisor will re-enter the guest using the old,
unmodified register state, causing an instant re-trap?

>  	if (ARM_SERROR_PENDING(exception_index)) {
>  		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
>  			u64 disr =3D kvm_vcpu_get_disr(vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 23e644c24a03a..02383b372258f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -168,7 +211,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp=
_vcpu)
>  	fpsimd_sve_flush();
>  	flush_debug_state(hyp_vcpu);
> =20
> -	hyp_vcpu->vcpu.arch.ctxt	=3D host_vcpu->arch.ctxt;
> +	/*
> +	 * If we deal with a non-protected guest and the state is potentially
> +	 * dirty (from a host perspective), copy the state back into the hyp
> +	 * vcpu.
> +	 */
> +	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
> +			__flush_hyp_vcpu(hyp_vcpu);
> +	} else {
> +		hyp_vcpu->vcpu.arch.ctxt =3D host_vcpu->arch.ctxt;

[Severity: Critical]
This is a pre-existing issue, but I have a question about this copy operati=
on.

This executes at EL2 and copies the entire vcpu.arch.ctxt from host_vcpu
(memory accessible to the untrusted host EL1) into the protected VM's
private state.

Could this violate guest integrity by allowing the host to hijack the VM's
control flow?

> +	}
> =20
>  	hyp_vcpu->vcpu.arch.mdcr_el2	=3D host_vcpu->arch.mdcr_el2;
>  	hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWI | HCR_TWE);
[ ... ]
> @@ -191,9 +244,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> =20
> -	host_vcpu->arch.ctxt		=3D hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		=3D hyp_vcpu->vcpu.arch.hcr_el2;
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;

[Severity: Critical]
This is a pre-existing issue, but I have a similar question about copying
the protected guest's register state back to the host here.

Does copying hyp_vcpu->vcpu.arch.ctxt back into the untrusted
host_vcpu->arch.ctxt violate pKVM confidentiality guarantees by leaking
the state to the host?

> +	else
> +		/* Keep the PC current for the kvm_exit tracepoint (lazy ctxt sync). */
> +		host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt.regs.pc;

[Severity: High]
Since handle_trap_exceptions() is only called for traps, an exit like
ARM_EXCEPTION_IRQ won't trigger the __pkvm_vcpu_sync_state hypercall.

Because this code only synchronizes the pc field for non-protected guests,
vcpu->arch.ctxt.regs.pstate (CPSR) remains stale in the host vCPU context.

Does this lazy synchronization leave the host with a stale CPSR on non-trap
exits?

If the guest transitioned to an illegal 32-bit mode immediately before the
IRQ was taken, would the KVM_RUN inner loop evaluate vcpu_mode_is_bad_32bit=
()
using this stale CPSR, bypassing KVM's architectural protection against ill=
egal
AArch32 execution?

> =20
>  	host_vcpu->arch.fault		=3D hyp_vcpu->vcpu.arch.fault;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.7555=
62-1-tabba@google.com?part=3D11
