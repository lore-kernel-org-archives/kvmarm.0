Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BBF2E8E09;
	Fri,  3 Jul 2026 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096352; cv=none; b=gb8iuSc44Yh63gQFL/s54qrwF2kP+2AUJP9sXFF1ddFQY9FhVFbs0SBco20tfIfr6tK6g4V8RshB0W6lfiz+eNmzgLV2CRa0mQTu82jFk34yK0a/hFGuS8CNzWx7w+XvEkIhHCeHl2kw8X263IG3z+AttdGUq41f85s50LDisCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096352; c=relaxed/simple;
	bh=vPNaW4ZjgBH0UydRP5uACLrpJFosAYjsrkD8KT6JnTc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VV8rjOPuGWu3koU0kSaTUJaCCCbPQAyIDcH6l7AzGZsqubJWUCbk6wLvDNidUZCSBFZGU9Z97vPEz+2IHHYPiqnkOazDnlz4US2NJENjp2FUrQY1PFHuX0NMxErevzMiJAQ2e8CjwKh9gdy/LW8AA/JP1fLpUzkOAFcNCQVO71w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BP5YEPGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BP5YEPGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750BE1F000E9;
	Fri,  3 Jul 2026 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096350;
	bh=6w4iFi7awEeoI6TFm3jP7AXWigyNZ/bymjmhaMqlMbU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BP5YEPGEjWCqKPbmW5M8TNGKwXe/JFNZnf8L1/3PkZg8ruUWgbcUffVNEP9TpHhGe
	 A17/Tt43TOPtlA+gZQVjwpmSVt/c365oA3qjiP8hQZm5djUz96NeelxpjlFN68Bm57
	 s+1jgS1UOktfsC6Mju9CkQNjfHvbtBIJlL0SUtmcMvdZe/CLvK3kfsyXxD/KpKuy7r
	 h4yEWCDY/v+Z3c3TX5gYk1I9KAtbrF5p8hzF4UwuZR3VPUQgamutEDj2vgbmbvwmgM
	 JT27QVQ/miXBoOccAnrl1AxLoZrNux3hxoZfc+KpEQrCEmaC9M9eZkR9GKshuH5AGP
	 WUsYviGqlB0rQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 28/40] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-29-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-29-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:32:30 +0000
Message-Id: <20260703163230.750BE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Hardware pending state desynchronization for GICv5 SPIs and LPIs d=
ue to omitted `set_pending_state` / `VDPEND` invocation in guest MMIO and M=
SI paths.
--

commit ee2f2b77547da18f2f1da7d79905b67a8cbca929
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic: Introduce set_pending_state() to irq_op

This commit introduces a new set_pending_state() function pointer to
irq_ops for the ARM64 KVM VGIC. It calls this function in
kvm_vgic_inject_irq() to allow the backend to mirror the updated VGIC
shadow pending state into hardware for cases where hardware manages the
lifecycle, such as GICv5 SPIs and LPIs.

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 8b15938464ab9..ee7fc0c7104e6 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
[ ... ]
> @@ -563,6 +563,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
>  	else
>  		irq->pending_latch =3D true;
> =20
> +	if (irq->ops && irq->ops->set_pending_state)
> +		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
> +

[Severity: High]
Since set_pending_state() is needed to mirror the shadow pending state to
hardware for GICv5 SPIs and LPIs, does it also need to be called in other
paths that update irq->pending_latch?

For example, when a guest writes to ISPENDR/ICPENDR to manually pend or
clear an SPI, the shadow state is updated but the hardware update appears
to be bypassed:

arch/arm64/kvm/vgic/vgic-mmio.c:__set_pending() {
    ...
    irq->pending_latch =3D true;
    if (irq->hw && !is_user)
        vgic_irq_set_phys_active(irq, true);
   =20
    vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
    ...
}

Similarly, for LPIs injected via the ITS, the hardware update seems to be
omitted:

arch/arm64/kvm/vgic/vgic-its.c:vgic_its_trigger_msi() {
    ...
    raw_spin_lock_irqsave(&irq->irq_lock, flags);
    irq->pending_latch =3D true;
    vgic_queue_irq_unlock(kvm, irq, flags);
    ...
}

Could this lead to lost interrupts and potential system hangs if the
hardware remains unaware of the pending state in these paths?

Additionally, do GICv5 LPIs get assigned an irq_ops struct? If not, they
might lack a mechanism to issue the required VDPEND command when triggered
via vgic_its_trigger_msi().

>  	vgic_queue_irq_unlock(kvm, irq, flags);
>  	vgic_put_irq(kvm, irq);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D28
