Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B2B374E62
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783334212; cv=none; b=K8NnPpmdF84t7s9Z0rx/fZuUPW5IpUqPlbO/54sFDnKUEJEhZsWhUYWMJjB8ttPd/on3XLUpJtU5oGBjw97UUgm7UQ4finxAgDeuyFlMwaDSTv9g8T5s5SEg/idITVI+gQRy/A6sO6nxnIShOP6z6yrlRns2nBzkhn8jApb4VQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783334212; c=relaxed/simple;
	bh=wfY30cjnNkse06YocelR0HoCMOAO2g5XSzjEgov4Sic=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kfH0B4VJZJWck2i0NifKPVBRMPXYquh94RrqMqkk10dGZOEkwKYM/BMB3fLgYwZsJ4oK6NYcJdhntzuD9bap2Kf5aWUKQsi1GxD8pzd0rl4rPBlQP3HyWJxBU9vs56Lc1c+/PbEHZoo8sXkKKdDhOAZRTIT8pFQOlrbA71jwxN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZv0yOPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZv0yOPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1A41F000E9;
	Mon,  6 Jul 2026 10:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783334211;
	bh=m/yiEM4fwYaeTFPMqoS/pObw9GrqXZouLF56dfKk+No=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DZv0yOPGXCfmPliHHBtGRmV4y+I0sGLA7jFkY4CoX9wYEXU+LGLlVJoqE7nvXBbOg
	 UP1xrCb8uEPQfW+9EYHTSZSxz2baAAL4Q4dh8wdgucjjSyAmWfZVpXu11JZRyZZ3IN
	 6I7rd8nFddtivDnNEs7v/PXS8nFmD+PdtxhKweNR/THKdZEEXt3pdPtYmBMMKDwrrT
	 rLAuHrvSLPtMr/GlZXoASpQxbNUiP5rAdHIYB2mEjot9CE7rLmG5emY/2nv81Ndo/p
	 X4aJz+MJO//m6fjXX11ccKymuZLRGd6u5jblplal6PoeIT3Qo9xghxUb0ZxLuvnBEW
	 s0kTGlFFOmaRw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260706095927.560795-9-fuad.tabba@linux.dev>
References: <20260706095927.560795-1-fuad.tabba@linux.dev>
 <20260706095927.560795-9-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 10:36:50 +0000
Message-Id: <20260706103651.3D1A41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The commit silently removes the synchronization of hcr_el2 from th=
e hyp vCPU back to the host vCPU on guest exit, breaking host-injected runt=
ime signals like virtual SErrors.
- [High] Host-side modifications to a non-protected guest's system register=
s via asynchronous KVM requests (e.g. KVM_REQ_PMU) are silently discarded b=
ecause the dirty flag is cleared on IRQ exits.

Pre-existing issues:
- [Critical] pKVM completely fails to isolate the register state of protect=
ed guests by unconditionally copying the full execution context between the=
 untrusted host and the hypervisor on every world switch.
--

commit 417bef11bf8b55291221bae4776c5695349c903d
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Implement lazy vCPU state sync for non-protected guests

pKVM copies a non-protected guest's register context between the host
and the hypervisor on every world switch, even when the host never
inspects it. Defer the copy: on entry, flush the host context into the
hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
exit, leave it in the hyp vCPU and copy it back only when the host needs
it, via a __pkvm_vcpu_sync_state hypercall or at vcpu put.

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b6..29108e5c0206e 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c

[ ... ]

> @@ -486,9 +486,32 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception=
_index)
>  	}
>  }
> =20
> +static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_=
index)
> +{
> +	int exception_code =3D ARM_EXCEPTION_CODE(exception_index);
> +
> +	if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm))
> +		return;
> +
> +	/*
> +	 * Sync the context back when the host will read (trap) or write
> +	 * (SError) it. Preempt-off here, so the loaded hyp vCPU is stable.
> +	 */
> +	if (exception_code =3D=3D ARM_EXCEPTION_TRAP ||
> +	    exception_code =3D=3D ARM_EXCEPTION_EL1_SERROR ||
> +	    ARM_SERROR_PENDING(exception_index)) {
> +		kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> +		vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +	} else {
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);

[Severity: High]
Does clearing the dirty flag on other exits (like IRQ) blind the lazy sync =
to
subsequent host-side state modifications?

If a non-protected guest exits due to a physical IRQ, the PKVM_HOST_STATE_D=
IRTY
flag is cleared here. If the host IRQ handler then updates guest state (e.g=
. via
PMU overflow) and queues an asynchronous KVM request, the next time the gue=
st is
entered, flush_hyp_vcpu() will skip flush_hyp_vcpu_state() because the dirty
flag is clear.

Will this result in the guest running with stale state, discarding the host=
's
modifications?

> +	}
> +}
> +
>  /* For exit types that need handling before we can be preempted */
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  {
> +	handle_exit_pkvm_state(vcpu, exception_index);
> +
>  	if (ARM_SERROR_PENDING(exception_index)) {
>  		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
>  			u64 disr =3D kvm_vcpu_get_disr(vcpu);

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 2db56146ec493..4a8445b636e60 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -172,7 +214,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp=
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
> +			flush_hyp_vcpu_state(hyp_vcpu);
> +	} else {
> +		hyp_vcpu->vcpu.arch.ctxt =3D host_vcpu->arch.ctxt;

[Severity: Critical]
This is a pre-existing issue, but pKVM seems to completely fail to isolate =
the
register state of protected guests by unconditionally copying the untrusted=
 host
context into the protected hyp vCPU context here on every world switch.

Can this allow the host kernel, which is treated as an adversary against gu=
est
confidentiality and integrity, to arbitrarily inject state into the protect=
ed VM?

> +	}
> =20
>  	/* __hyp_running_vcpu must be NULL in a guest context. */
>  	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;
> @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_=
vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
> =20
> -	host_vcpu->arch.ctxt		=3D hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		=3D hyp_vcpu->vcpu.arch.hcr_el2;
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;

[Severity: Critical]
This is a pre-existing issue, but similar to the copy on entry, uncondition=
ally
copying the protected hyp vCPU context back to the untrusted host context h=
ere
leaks the guest's execution context.

Does this break the core pKVM confidentiality guarantees by allowing the ho=
st
to read all guest registers?

> +	} else {
> +		/* Keep PC (tracepoint) and PSTATE (vcpu_mode_is_bad_32bit) current. */
> +		host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt.regs.pc;
> +		host_vcpu->arch.ctxt.regs.pstate =3D hyp_vcpu->vcpu.arch.ctxt.regs.pst=
ate;
> +	}

[Severity: High]
Does removing the synchronization of hcr_el2 from the hyp vCPU back to the =
host
vCPU break host-injected runtime signals like virtual SErrors?

When a virtual SError is injected via HCR_VSE, the guest hardware clears the
bit upon delivery. Previously, this cleared state was synced back to the ho=
st
here in sync_hyp_vcpu().

Since the sync is now removed, won't the host's hcr_el2 retain the stale HC=
R_VSE
bit forever? On every subsequent guest entry, flush_hyp_vcpu() will OR this
stale bit back into the hyp vCPU's hcr_el2, which seems like it would cause=
 an
infinite loop of spurious virtual SError injections into the guest.

> =20
>  	host_vcpu->arch.fault		=3D hyp_vcpu->vcpu.arch.fault;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706095927.5607=
95-1-fuad.tabba@linux.dev?part=3D8
