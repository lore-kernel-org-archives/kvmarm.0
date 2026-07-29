Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB40486BA1
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332381; cv=none; b=GvYbkXyejvs0TstMLNdUuBLrsJkjSyf/y8nsPETQBx8NOgJHXXs6bp/OT56aHSxXohMwfPnbgqJW4wcj6uQZVvztuNY8/CRFtMZDC6vrLi/nGfHcVK6rlcPQnluat0/ekcV6oI+Q1AKZIiEzVhsIHWvL2Gz3kUD6OP3+iRMS+f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332381; c=relaxed/simple;
	bh=hVpPCMsaYiS8IoYJYWmjCkwNXUCwe6U4JmEcmKfE00s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IXOqAum/oypAI/InOwgh+gD7JH6V/Tubq9tUWad9q43VAPgx8QSibS79pxObcDg+g13KrTjBvo19CtPnvq6WpJLGR56KRRKvWjDORhA/T14MWceISt36Gg8WhwEANfi9o++TCzGEyPOjv5I38i0JXd/tvxUWryfoclR9BmlzdHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGfx7tuH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGfx7tuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE191F00A3D;
	Wed, 29 Jul 2026 13:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785332370;
	bh=fNGAHGmlswiubTWjfGDKmzrpqmQ/dcSLjG4Leh99WfE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DGfx7tuHba/Wkw1EU47Qw/ptWIz2Gg2tWTCocw++DCA1RRkevt0rUIdRJGOvKYOMe
	 uo5Y5efd0r95TF52mt3RIz6+v+UWTqnbuOTpZGumMN+ElxL2WAS2rNPSbHakwqlw8D
	 3gN2zHNDGC5nEUHycb/8jOaDP0rP4GNKtclYVytHFIwFim1aUJg4dwRFQhD8kZCIJe
	 eXZSZvOo+AtILipsL4mdmSlzGIamjRFIiiafbtIOGivD0bNa1HZZ8oOwzOmbbwCz2c
	 WGkykKC8a36CRPM/enzXlGkI192E64ATp+5e5PEOtIMazk6AvslTC89bxRGktwSQja
	 LrNN+DwMtyvfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260729131823.2021516-7-fuad.tabba@linux.dev>
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-7-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 13:39:29 +0000
Message-Id: <20260729133929.CFE191F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch fixes an arbitrary host pointer dereference in GICv3=
 hypercalls but completely misses the identical vulnerabilities in GICv5 hy=
percalls (`handle___vgic_v5_save_apr` and `handle___vgic_v5_restore_vmcr_ap=
r`).
- [Critical] Unvalidated host pointer dereference in `handle___kvm_adjust_p=
c` allows arbitrary memory modification in EL2.
--

--- Patch [6]: [PATCH v7 6/8] KVM: arm64: Minimise EL2's exposure of host V=
GIC state during world switch ---
commit def324be61872b6056efce4e3eb9ff57eb9a9e10
Author: Marc Zyngier <maz@kernel.org>
Subject: KVM: arm64: Minimise EL2's exposure of host VGIC state during worl=
d switch

This commit restricts EL2's exposure to host VGIC state by recovering the
host vCPU securely rather than directly dereferencing the host-provided
vgic_v3_cpu_if pointer in __vgic_v3_save_aprs and
__vgic_v3_restore_vmcr_aprs. It introduces a helper to fetch the host
vCPU using container_of() and copies only the necessary state.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 45d717889f6ea..f3233ee343a39 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -508,16 +520,63 @@ static void handle___vgic_v3_save_aprs(struct kvm_c=
pu_context *host_ctxt)
>  {
> -	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
> =20
> -	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> +	host_vcpu =3D get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1,
> +							   &hyp_vcpu);

[ ... ]

[Severity: Critical]
This is a pre-existing issue, but does the same regression exist for the
GICv5 hypercalls?

The patch replaces the direct kern_hyp_va() dereference with a secure lookup
for GICv3. However, it appears the same pattern remains in
handle___vgic_v5_save_apr() and handle___vgic_v5_restore_vmcr_apr():

handle___vgic_v5_save_apr()
    __vgic_v5_save_apr(kern_hyp_va(cpu_if));

Can a compromised host pass an arbitrary physical address here, causing
__vgic_v5_save_apr() to write the hardware value of SYS_ICH_APR_EL2 to that
chosen address, breaking EL2 isolation?

[Severity: Critical]
This is also a pre-existing issue, but does handle___kvm_adjust_pc() have a
similar unvalidated host pointer dereference?

In arch/arm64/kvm/hyp/nvhe/hyp-main.c:

static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
{
	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);

	__kvm_adjust_pc(kern_hyp_va(vcpu));
}

If the host kernel passes a crafted vcpu pointer, could it point to an
arbitrary memory region where the iflags offset has the INCREMENT_PC bit se=
t?

This would cause the hypervisor to execute:

arch/arm64/kvm/hyp/exception.c:__kvm_adjust_pc() {
    ...
    } else if (vcpu_get_flag(vcpu, INCREMENT_PC)) {
        kvm_skip_instr(vcpu);
        ...
}

Could this allow an attacker to increment arbitrary EL2 memory by adding 4 =
to
the value at the regs.pc offset?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729131823.2021=
516-1-fuad.tabba@linux.dev?part=3D6
