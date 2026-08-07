Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444DB44238F;
	Fri,  7 Aug 2026 15:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117253; cv=none; b=IaynoqQUP1/2eHA8xpBrgTc+3yZRh0wLn9kmjO5bwtAbm6RiybxT+1zQJfPU/yhwoxUsFFUUS06dWpgw6rP5L13zO7gVs24Gp1V7RRwtg63oD1au6U0B1wKAefy/0rdpyed2y40jOKgpvv6zZpvtH1egbMNfV7zJfQSaJ/jDjz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117253; c=relaxed/simple;
	bh=7AdcladOUuufGKAW0RBtCmWhmPfSY9HBg6pAPrEhpn0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TNSXjVi1818hHb95QmFA+cJrq/IPrRqYYWZvp2GG+W2rJqM9U4XddKlsftv5QW5RRRR2D6+lZLuAJXiC1v2i966NGi0FXfiqcxUQpwaI7mzsRH0DmXl2ooIAwoWwkyvqSwYYzBzjqtoIRR0gCMDLO5MtBaR1qZYIZHP1k+eTNoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+kuBTlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+kuBTlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F6D1F00A3A;
	Fri,  7 Aug 2026 15:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786117252;
	bh=pRmuZQ9zsRRoghB/wUrhs6870q+CDFz6segbG/VwhwA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k+kuBTlvgAGJ6vkXbEHH3WHdauZOoTyrJBW3Ps93bmVgVY1OI91bBS3BRhvAIle9R
	 bP2JyjGl2GKca6VEAbZYR6Gkm7jo0SVMyXmPKgzRynXaWIPPF2LPPtY/qJzPNdTwBO
	 yqwXsDwebd7sc6h34R1y/pWnuMFliTlTofzwi+5CFzY88mpJrCSKgvl1erm8doZ0qW
	 iBMKFgfJLTX98+dRhucO4zZDhV69KR/wjnP/Ku/HurJXT96q10+MkMI4nhuo0vucvN
	 I1FP1vqzf43upVgrNLzdGsPZwOl50Z/MlMfbh06/D7hLwSOsJjaOL45UVcMBCEh8rV
	 ZvdISNmlv3GQQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 29/49] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260807111159.429128-30-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-30-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 15:40:50 +0000
Message-Id: <20260807154051.77F6D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] GICv5 SPI injection via irqfd breaks KVM_IRQFD_FLAG_RESAMPLE becau=
se KVM never observes the guest's EOI.
--

--- Patch [29]: [PATCH v5 29/49] KVM: arm64: gic-v5: Add GICv5 SPI injectio=
n to irqfd ---
commit a0b6c4d036693f8696b21a848670f40de7bc34b7
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd

This commit updates vgic_irqfd_set_irq() to translate irqchip pins into
GICv5 SPI IntIDs before injection. It also validates the IRQCHIP route pins
against the GIC model, supporting up to 1024 SPI pins when using GICv5.

> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-=
irqfd.c
> index 19a1094536e6a..ee1a1b214f03c 100644
> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
> @@ -19,9 +19,14 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_ro=
uting_entry *e,
>  			struct kvm *kvm, int irq_source_id,
>  			int level, bool line_status)
>  {
> -	unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
> +	unsigned int spi_id;
>  	int ret;
> =20
> +	if (kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
> +		spi_id =3D vgic_v5_make_spi(e->irqchip.pin);

[Severity: High]
Does enabling irqfd injection for GICv5 SPIs here break the
KVM_IRQFD_FLAG_RESAMPLE contract?

If userspace configures an irqfd with KVM_IRQFD_FLAG_RESAMPLE for a
GICv5 SPI, KVM injects the interrupt into the hardware Virtual Domain,
and the guest's EOI is handled directly by the GICv5 hardware.

Since KVM does not track the in-flight state of GICv5 SPIs via List
Registers, does the EOI fail to trap to the hypervisor?

Without KVM observing the guest's EOI, it seems KVM will never call
kvm_notify_acked_irq() and the resampler eventfd will never be signaled.

Could this cause passthrough devices using level-triggered interrupts mapped
to GICv5 SPIs to silently hang after the first interrupt because the
physical interrupt is never unmasked?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D29
