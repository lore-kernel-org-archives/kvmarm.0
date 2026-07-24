Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0263E717A;
	Fri, 24 Jul 2026 11:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892902; cv=none; b=TwnR7gcPsaAaCH/zbUHSzKsFFwtI/Xlq4HsORTcc+hBweW7wLKwVtQtSHBudmaqhHAViDW5mNexhzTm2QRrcRsghMBxcAEjby9ZUt0efRgwxlwMwxYV2D0Ek2kgKVFkduDMhz84wYEGWtsBZe9Ty4IKFJmVjIQosVTz7HrrlwAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892902; c=relaxed/simple;
	bh=zqQpL++2F2iy6oLhENzhIP28gtp01uVVdI93XCzndls=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XCll6zTHiacNrwygtlqr0XBQg8P8RKYA85HylRhlATtZ7I4vgjNttR2ccwMV+28SVSGGQqBvZBMrRRfItc5skMxMzLk2P/EtPCkjna/FTJRAq4WP1gfV9ZGre4E9tFHl3msQK8qKVLyFf7vUbV+/sJThnobeusxqPPlV2z7jIpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikJdYR/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikJdYR/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DD31F00A3A;
	Fri, 24 Jul 2026 11:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892901;
	bh=AlPG/peD2TIrVmbNjhCnkkKnpRaY1Xp54tQcNOKzhHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ikJdYR/ZYpJ0cKrCmdR8nlkzz41ydubpgkPhWTE8LupZiBlWTElzoO5jz0hOztrJR
	 I124VZRnkavTZpbj56/PCcNgkVAngUY/NFu59T1Gnsbx1KqpL68OyYaAHuAjmzdS+d
	 nZ8mtVlcumM/oz/v/iBWlNa+K8/ZGuhiER2UYyxRX6hIUifvoTgr3Ah1xUajHtmiBL
	 MGE97Gz4p6LVaeRYVvBBqrwogdalJC3ioTUkvZwUSDE/elHBLCeBC2IyfIU0KQBloJ
	 vDZ2pa1qRTSHQorJOfgICabWuCuZOj1GPDdYPWK3SlurUOKVwbAVv7e1AydUtczYwp
	 O4myH59C8yPig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 25/48] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-26-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-26-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:34:59 +0000
Message-Id: <20260724113500.A5DD31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Missing validation of the host-provided VMID allows the untrus=
ted host to arbitrarily inject interrupts into protected VMs.
--

--- Patch [25]: [PATCH v4 25/48] KVM: arm64: gic-v5: Add GIC VDPEND hyp cal=
l ---
commit c4db8b94f24a778070a5db75c24059095bae959b
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GIC VDPEND hyp call

This commit adds a hypercall to wrap the GIC VDPEND system instruction, all=
owing
the hypervisor to manage SPI and LPI pending states for VMs. This instructi=
on is
executable only from EL2 and provides a way to inject interrupts into guest=
s.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 09756f71df08e..8f9cc3cd422aa 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -719,6 +719,15 @@ static void handle___vgic_v5_restore_vmcr_apr(struct=
 kvm_cpu_context *host_ctxt)
>  	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
>  }
> =20
> +static void handle___vgic_v5_vdpend(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(u32, intid, host_ctxt, 1);
> +	DECLARE_REG(bool, pending, host_ctxt, 2);
> +	DECLARE_REG(u16, vm, host_ctxt, 3);
> +
> +	__vgic_v5_vdpend(intid, pending, vm);

[Severity: Critical]
Does this code introduce a regression by allowing an untrusted host to
arbitrarily inject interrupts into protected VMs?

The hypercall handler extracts the vm argument from the untrusted host cont=
ext
and acts on it without any validation against protected VM ownership.

Since this hypercall is directly reachable from the untrusted host under pK=
VM,
the host could supply the VMID of a protected guest in the vm parameter.

> +}
> +
>  typedef void (*hcall_t)(struct kvm_cpu_context *);
> =20
>  #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_#=
#x

> diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5=
-sr.c
> index 46992a6c2cacb..94746317ca79f 100644
> --- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
[ ... ]
> @@ -149,3 +149,13 @@ void __vgic_v5_restore_state(struct vgic_v5_cpu_if *=
cpu_if)
>  {
>  	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
>  }
> +
> +void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm)
> +{
> +	u64 value;
> +
> +	value =3D intid & (GICV5_GIC_VDPEND_ID_MASK | GICV5_GIC_VDPEND_TYPE_MAS=
K);
> +	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_PENDING_MASK, pending);
> +	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_VM_MASK, vm);
> +	gic_insn(value, VDPEND);

[Severity: Critical]
Could the unvalidated vm parameter cause a regression by violating guest
integrity and isolation here?

The unvalidated vm parameter is packaged directly into the VDPEND system
instruction, modifying the interrupt state of the targeted VM.

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D25
