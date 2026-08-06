Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DA53F4139
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786012328; cv=none; b=UKwQAp7w18ba+rDqnWBy1IYdXAihZ+susTUrnEjQrLvxqm8xgantbHrAZcZ/aGLvRBJEy/4wGEVVafqkcFy7WvORNpV325/gaqLggbUDILVXxgYi+vy+mJieRAXfS9vprZCn6G4udAX5OFRq0eZnj+Z+GMCGSYJTauBzNax0bfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786012328; c=relaxed/simple;
	bh=cEsg2KSmXtnyelnsYMrUcwmCa80vRyPCVA5KDMgTZfU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kjfBLm5o9fLbySpBUeSj5eWc9AV/b005TF1qpgjnzIu7lToKs1dUHLPVQhZ2zRyBDKkLQxHs2vuHKjLvXe1CRJmXnUkRpd7GGE+Bk1M2NHhif06oV+6/EW2jkYQjAIaHgiVkFMh0vZL1xeI4XLZkP7BFk/wl3H8ycWMH4Vy97Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SC010j50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SC010j50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013201F000E9;
	Thu,  6 Aug 2026 10:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786012327;
	bh=v041pEC1nukermPHCDXdx9n3FWEOp5+GwfbD2vqRsPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SC010j50hXtok4x/loNA/IT/EXm/cWzSBz517Jw4Mzpn24Mx+TlhOs7nbcTi10u06
	 M4vRgpl5fYWYGnDYZGftVv/XhnyjrhJCGiFRIg977G9eTdd27S3EivjX3Cm8Ikomp2
	 NgShQkPeWISDa+3WOhYXVEmGSCTALqIUIy4g/CorpDqx16TubP0N40dvGD1pAD5grq
	 /yP6S1WJ2SMZmd7SZs7erF8vrrL771mPWjL2v770eYTRAHWN+jP3dE299S7NgyeO4q
	 de0TtF+j3rjFlC+9aJJMYGJ7/ngXOAG7DtYv63wrr/JDpPcPaHFSWqHkLqL8UyRKMh
	 yFGLeYJxpkJeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 1/4] KVM: arm64: Validate the host-provided vgic
 model in pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260806100256.371164-2-fuad.tabba@linux.dev>
References: <20260806100256.371164-1-fuad.tabba@linux.dev>
 <20260806100256.371164-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 10:32:06 +0000
Message-Id: <20260806103207.013201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Unconditional copy of the host's mdcr_el2 to the protected VM'=
s mdcr_el2 allows the host to reconfigure the guest's secure trap environme=
nt.
- [Medium] The patch fails to sanitize the explicit `__vgic_v5_save_apr` an=
d `__vgic_v5_restore_vmcr_apr` hypercalls, allowing a malicious host to sti=
ll panic the hypervisor on GICv3 machines.
--

--- Patch [1]: [PATCH v1 1/4] KVM: arm64: Validate the host-provided vgic m=
odel in pKVM ---
commit 3364f007874647c1650c3fc747633d9c5c9b87de
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Validate the host-provided vgic model in pKVM

This commit validates the host-provided vgic_model during initialization
of a protected VM, ensuring only GICv2 and GICv3 models are permitted.
This prevents a malicious host from causing a hypervisor panic by setting
the model to GICv5 on a GICv3 machine.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index 24d6f164129ac..59bb15efdca42 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -340,13 +340,25 @@ static void pkvm_init_features_from_host(struct pkv=
m_hyp_vm *hyp_vm, const struc
>  {

[ ... ]

> -	/* Preserve the vgic model so that GICv3 emulation works */
> -	hyp_vm->kvm.arch.vgic.vgic_model =3D host_kvm->arch.vgic.vgic_model;
> +	/*
> +	 * Preserve the vgic model for GICv3 emulation, but only what pKVM can
> +	 * run: the GICv5 world switch touches registers UNDEFINED at EL2
> +	 * without FEAT_GCIE. 0 is not a valid kvm_device_type: "no vgic".
> +	 */
> +	switch (vgic_model) {
> +	case KVM_DEV_TYPE_ARM_VGIC_V2:
> +	case KVM_DEV_TYPE_ARM_VGIC_V3:
> +		break;
> +	default:
> +		vgic_model =3D 0;
> +	}
> +	hyp_vm->kvm.arch.vgic.vgic_model =3D vgic_model;

[Severity: Medium]
This is a pre-existing issue, but does this validation fully prevent a
malicious host from triggering a GICv5 panic?

Even with the model restricted here, the explicit GICv5 hypercalls
remain unconditionally exposed in the always-on band:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:
static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
{
	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);

	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
}

static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host_=
ctxt)
{
	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);

	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
}

Can a compromised host still bypass this vgic_model sanitization by
directly executing the HVC instruction for
__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr or __vgic_v5_restore_vmcr_apr?

If these directly access GICv5 registers, wouldn't this still trigger an
UNDEFINED exception on machines without FEAT_GCIE?

>  	/* No restrictions for non-protected VMs. */
>  	if (!kvm_vm_is_protected(kvm)) {

[ ... ]

Additionally, while reviewing the protected guest state handling, I noticed
another potential issue in the hypervisor main loop:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:flush_hyp_vcpu() {
	...
	/* __hyp_running_vcpu must be NULL in a guest context. */
	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;

	hyp_vcpu->vcpu.arch.mdcr_el2	=3D host_vcpu->arch.mdcr_el2;
	/*
	 * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
	...
}

[Severity: Critical]
This isn't a bug introduced by this patch, but does this unconditional
assignment allow the untrusted host to clobber the securely initialized
MDCR_EL2 configuration of protected guests on every VCPU entry?

Since flush_hyp_vcpu() overwrites the hyp vCPU's mdcr_el2 with the
host-controlled host_vcpu->arch.mdcr_el2, could a compromised host use
this to reconfigure the performance monitor (TPM) and debug (TDA/TDE)
trap environment of a protected guest?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806100256.3711=
64-1-fuad.tabba@linux.dev?part=3D1
