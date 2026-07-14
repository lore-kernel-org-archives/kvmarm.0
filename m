Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0FB391E73
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030013; cv=none; b=JTk86KzlCbjAZ4OEPNOD7bbxNTy79hxkw3RhBg0YxpDqUQAbM53WkJZn0yhsEsnqgECwpEmdrMhD/cwVl/lPwHVZkoGmCbGMcfW8WRcZQjht0oXlgCZCV1DyyxY6InWSls4iP3fk9KENGsXOJ/UH0dhQLPmIExMKti9Cr1XF+jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030013; c=relaxed/simple;
	bh=7lJ+glw/N1tKV81QfdyBeDME1EJMLKMt4tSo3ODDOBc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NRYDj+5VqiBhfTHGQhmDhr60cT+Pkml+FYzdWdVSu43BJHj49uXRCRoS6EX1KbTNhiQMqVI7N8oVZ+7V50u+6u5+OndvjBXrDM63HlV2aE0UXxDUboXW+EchSdynNtPm/p+Lrg+4j0qKLEbvoF32CYv9z5uXMhLaIlYjHdIaYyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZUh1SON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZUh1SON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2161F000E9;
	Tue, 14 Jul 2026 11:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784030012;
	bh=kOdFA5TvqZ7fA3XLGTPIx6VaS2vqHOKZ1KcaoK3TknI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cZUh1SON31Mr735e/WB7nNvDXTFeFpM7pyW2+E+RkSXfi7mdVPuZf6Ok/Ix44Czyx
	 gifB9i73p8fbjHKQR9xXZRZltotgJMrjY80Q4PryNa5Ne/SDR3TonffOP819VggyW2
	 9USAMwvU+NrAN6FxBVpg0EEWggr93Nyp1Dbublpqf95tdPuxc1QG3E6768uw9xqnoR
	 7rVrzDCjZkO12xa9YlrXwrP1UaIvE0n4sN74fYN6wQ3+0h6CNs9DAuyG6tmNe5NnFY
	 MI3dj3j74TSN/frbpj1yq8bFhDGxygablM8nKFot3BW/H8dQkW/WEwF0+lz2HpceMo
	 s2ppYyQ6LbrAg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260714101601.4142645-7-fuad.tabba@linux.dev>
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-7-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 11:53:31 +0000
Message-Id: <20260714115332.1B2161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] handle___vgic_v3_save_aprs erroneously overwrites the host's vgic_=
vmcr with a stale EL2 value.

Pre-existing issues:
- [Critical] Incomplete fix leaves identical hypervisor memory corruption v=
ulnerability in GICv5 hypercalls.
- [Critical] The `handle___kvm_adjust_pc` hypercall blindly dereferences a =
host-provided `vcpu` pointer via `kern_hyp_va()` without validation.
--

--- Patch [6]: [PATCH v5 6/8] KVM: arm64: Minimise EL2's exposure of host V=
GIC state during world switch ---
commit bad346f74febb306b17aa647c2da5c6747345fe8
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Minimise EL2's exposure of host VGIC state during world switch

The host passes a vgic_v3_cpu_if pointer to the __vgic_v3_save_aprs and
__vgic_v3_restore_vmcr_aprs hypercalls, which EL2 dereferences wholesale.
This patch copies only vgic_vmcr and the active priority registers between
EL2's hyp-side state and the host vCPU to minimise exposure.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 45d717889f6ea..f3233ee343a39 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -508,16 +520,63 @@ static void handle___vgic_v3_init_lrs(struct kvm_cp=
u_context *host_ctxt)
> =20
>  static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
>  {
> -	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
> =20
> -	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> +	host_vcpu =3D get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1,
> +							   &hyp_vcpu);
> +	if (!host_vcpu)
> +		return;
> +
> +	if (unlikely(hyp_vcpu)) {
> +		struct vgic_v3_cpu_if *hyp_cpu_if, *host_cpu_if;
> +		int i;
> +
> +		hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> +		__vgic_v3_save_aprs(hyp_cpu_if);
> +
> +		host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> +		host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;

[Severity: High]
Does this overwrite the host's vgic_vmcr with a stale EL2 value?

When the guest performs an MMIO write to the GICv2 VMCR (emulated on a GICv3
host), the trap is handled at EL1, updating
host_vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr.

Later, if the vCPU is preempted or userspace schedules out,
__vgic_v3_save_aprs is invoked. Because __vgic_v3_save_aprs() does not read
VMCR from hardware, hyp_cpu_if->vgic_vmcr contains the stale value from the
previous guest exit.

This would silently clobber and destroy the EL1's MMIO emulation updates.

[ ... ]

This is a pre-existing issue, but I noticed a similar pattern in
handle___kvm_adjust_pc() in the same file:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___kvm_adjust_pc() {
        ...
        __kvm_adjust_pc(kern_hyp_va(vcpu));
}

[Severity: Critical]
Could this allow an EL1 host to corrupt hypervisor memory?

An EL1 host can call the __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc hypercall
and provide an arbitrary TTBR1 pointer. EL2's handle___kvm_adjust_pc()
applies kern_hyp_va() without bounds-checking or validation.

When __kvm_adjust_pc() is executed:

arch/arm64/kvm/hyp/exception.c:__kvm_adjust_pc() {
        if (vcpu_get_flag(vcpu, PENDING_EXCEPTION)) {
        ...

This dereferences the unvalidated pointer to read flags and modify memory,
giving EL1 the ability to increment 64-bit values in EL2 memory.


This is also a pre-existing issue, but a similar pattern remains in the
GICv5 counterparts:

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_save_apr() {
        ...
        __vgic_v5_save_apr(kern_hyp_va(cpu_if));
}

arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_restore_vmcr_apr() {
        ...
        __vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
}

[Severity: Critical]
Does this leave an identical memory corruption regression?

An EL1 host can call these hypercalls with an arbitrary TTBR1 pointer,
which is directly dereferenced without validation, leading to arbitrary
memory read/write against EL2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.4142=
645-1-fuad.tabba@linux.dev?part=3D6
