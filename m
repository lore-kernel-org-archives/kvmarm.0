Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD08D313E2B
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781853873; cv=none; b=TLpE5Eas36k5Pyy5FSZnwybZXV36ZTCgLkMjWNKrbbKEgBMZEocMcu5eEL2zNb21S41Re80uwrO27DsY2RMWpSQvEmVnjUa5Zwv4kiGeMqrRZZgxEj3u3POIY5RXQ/7oX0Z/TP58XC6tHqdAN7fxJNNctMHS9Ytlq+GDpVkf/Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781853873; c=relaxed/simple;
	bh=Z+5B3LrI5BcQEwBO6vprxPNpNODY1h9dCHBe9eJbMfI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kUPhTrvdvMIaLWLo6RASIsCdbCUKf3PeJLlzFWtOsaLRC7AvsZfUL+TCHOLCrOoYubJRiAwrLPZeeHXWG/0PWGPilNcfgmA8mSLFDAtUpCY99fIxitX8Yf69eVZBFABjOlB0430OxsFV42cILa6RP23/Vb2xU700jTMWH/kry5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lx1HdJr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lx1HdJr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E331F000E9;
	Fri, 19 Jun 2026 07:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781853872;
	bh=0KOOxxS3smbu00HrrN1tB5DCZ1xonl0KVVjRbPopO/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lx1HdJr+nS3nSxAAWPfkeHLWnLAeMnkF097ImzErACL3t1CS5xUrP21UyLJvOHz3u
	 /+b5+Xchex9LFNDdRBXg1we43Fqq/viRN80VrlYID5RtoIThYbHe88K4+9XYcwJYBC
	 e+y8NoCOX9GHrBtpMLv2aHdKuLsEUS5KtMPUW0a3DUFCvdpVb81388+gL8Nx4y4v/u
	 Mr6qziWJ1XtHQxdTKqKv04dUrJCwriJay2qJHIDHM08qe+LRZL4wFYyJqIE4tex7+E
	 3m+SDpf67yTkaH0khBO3bLIw/BiVonf/WAs2ia+ZqAscCqkx7jdIouMX+OK4DhZwTb
	 q9MQVgkDazNcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <tabba@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260619070508.802802-9-tabba@google.com>
References: <20260619070508.802802-1-tabba@google.com>
 <20260619070508.802802-9-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 07:24:32 +0000
Message-Id: <20260619072432.80E331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Removal of `hcr_el2` sync-back causes infinite virtual SError =
injections.
- [High] Injected exceptions for Illegal Execution State (ARM_EXCEPTION_IL)=
 are silently dropped on re-entry.
- [High] Asynchronous guest context modifications (e.g., KVM_REQ_VCPU_RESET=
 via PSCI CPU_ON) are dropped, ignoring resets.
--

commit 479bc386009beb82e67cb9e9a04495d0872f077c
Author: Fuad Tabba <tabba@google.com>

KVM: arm64: Implement lazy vCPU state sync for non-protected guests

This commit defers copying a non-protected guest's register context
between the host and hypervisor until the host explicitly needs it or
modifies it. It introduces the PKVM_HOST_STATE_DIRTY flag to track when
the state must be flushed to the hypervisor on guest entry.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c

[ ... ]

> @@ -489,6 +503,22 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception=
_index)
>  /* For exit types that need handling before we can be preempted */
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  {
> +	bool inject_serror =3D ARM_SERROR_PENDING(exception_index) ||
> +		ARM_EXCEPTION_CODE(exception_index) =3D=3D ARM_EXCEPTION_EL1_SERROR;
> +
> +	/*
> +	 * An SError injected below writes the host ctxt; for a non-protected
> +	 * guest, sync from the hyp vCPU and keep it dirty so it isn't dropped.
> +	 */
> +	if (is_protected_kvm_enabled()) {
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);

[Severity: High]
Does unconditionally clearing the dirty flag here cause other injected
exceptions or asynchronous state changes to be silently dropped on the next
guest entry?

For instance, when a non-protected guest exits with an illegal execution
state (ARM_EXCEPTION_IL), handle_exit_early() clears PKVM_HOST_STATE_DIRTY.
Later, handle_exit() processes the exception by calling
kvm_inject_undefined(), which modifies the host's copy of the guest register
context (vcpu->arch.ctxt) to deliver an UNDEF exception. Because this happe=
ns
outside of handle_trap_exceptions(), the dirty flag is never set back to 1.
Consequently, on the next entry, flush_hyp_vcpu() skips syncing the modified
context, and the guest resumes execution with its previous state instead of
taking the UNDEF exception, leading to an infinite trap loop.

Similarly, if a PSCI CPU_ON call triggers an IPI, the target vCPU exits with
ARM_EXCEPTION_IRQ, and the dirty flag is cleared here. The run loop then
processes pending requests via check_vcpu_requests(), handling
KVM_REQ_VCPU_RESET by calling kvm_reset_vcpu(). The host's context is reset,
but since the dirty flag remains 0, the next entry skips syncing the reset
context to the hypervisor, causing the PSCI wake/reset request to be ignore=
d.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> =20
> -	host_vcpu->arch.ctxt		=3D hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		=3D hyp_vcpu->vcpu.arch.hcr_el2;

[Severity: Critical]
Does removing the synchronization of arch.hcr_el2 back to the host cause an
infinite loop of virtual SError injections?

The host uses HCR_VSE to inject a virtual SError. When the guest takes the
exception, the hardware clears the physical HCR_EL2.VSE bit, which is saved=
 in
the hyp vCPU's context on exit. Because this sync-back assignment is remove=
d,
host_vcpu->arch.hcr_el2 indefinitely retains the stale HCR_VSE bit set to 1.

On every subsequent guest entry, flush_hyp_vcpu() will re-apply this stale
bit from the host into the hyp context, causing infinite, spurious virtual
SError injections that will hang or crash the guest.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070508.8028=
02-1-tabba@google.com?part=3D8
