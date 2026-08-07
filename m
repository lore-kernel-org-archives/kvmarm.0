Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB003557F3;
	Fri,  7 Aug 2026 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115669; cv=none; b=KX2HjvYsZjXA/hJCRgdFmYtdpuJPCa286sBokFur+u4IE56Z83U1+YLJLYEBZTwginXobVzI+YukfDFYK9uFPpWXwS4O+ILZuNfH2cPj2+JgD8SteIYQ6JxhKXYQ/nOwCg+Dk5V5mi9LQMCL7t7BMjmNfrftY7yvI9XVWuvacvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115669; c=relaxed/simple;
	bh=+vnGxtmoF7qLmmVTa9ODjXD2tzJTTcoQQOAL41LuGmU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JoyQSbnkpJaOC6N4Gk8ItrzYjsle4p4LGCiY3cuGbPx2qu9TuVWHUoS9Ur040Kfn+6nJM/HLfMkttSXY7rTOYGPllsZGasezGdB7XPYde0cAdZAm4H2ZqisX0EIFK2WQ/HyNqzf+I23O/Evp4kjekMHT81e4ml3XgtHfCvCgRKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AA0q6FC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AA0q6FC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DD11F00A3A;
	Fri,  7 Aug 2026 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786115668;
	bh=mr5rq3yZAQ33jrJMWBF0XO42e4fjRn8Yxdvtk9DK2FM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AA0q6FC+ODneoBW4Chom5Spj5htTALlZQj9YYN2KdtiHEN6dttF6E3J7w4VTe9Liq
	 hoZ0xR2zQe+F6O15WWK2q2yZkFwk74EcSHHAeQIyvRXNyD2akguKyAQwSBZwc9Jf7C
	 2D2MBFgfFDv0bqj6pU9hM4EWsnisxMfvZVGZczNb1xU2VMyPnV0s016gjPRu/VtRze
	 mEy3O9BzGOJ+6V0nRJ3I3cZu59ttR85tyXnVCYRXxLRHc+gIM47LoNdIAsJrNz3eqr
	 Z89zrnwqBIdVCpy8O6CJirFFyOpxk/JPW6JRZ3+B1hLCFaD45Nl98WBP4wCSeEPo/r
	 LuqIFjBslj8yw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 26/49] KVM: arm64: gic: Introduce set_pending_state()
 to irq_ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-27-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-27-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 15:14:27 +0000
Message-Id: <20260807151428.28DD11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The `set_pending_state` callback is only invoked in `kvm_vgic_inje=
ct_irq()`, leaving hardware state out of sync when VGIC shadow state is mod=
ified by other paths.
--

--- Patch [26]: [PATCH v5 26/49] KVM: arm64: gic: Introduce set_pending_sta=
te() to irq_ops ---
commit 706acf491d97981f9dd498ec21c341cba46f1f47
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic: Introduce set_pending_state() to irq_ops

This commit introduces a set_pending_state() function pointer to irq_ops.
This allows hardware-managed interrupts to mirror KVM's VGIC shadow pending
state into the hardware when the state changes.

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 169a8664322d0..023792c28fc5c 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -563,6 +563,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
>  	else
>  		irq->pending_latch =3D true;
> =20
> +	if (irq->ops && irq->ops->set_pending_state)
> +		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
> +

[Severity: High]
Since the set_pending_state callback is only invoked here in
kvm_vgic_inject_irq(), will the hardware state become out of sync when the
VGIC shadow state is modified by other paths?

For example, if a guest accesses the GICD_ICPENDR register, KVM updates
irq->pending_latch in __clear_pending(), but does not appear to invoke the
hardware sync callback:

arch/arm64/kvm/vgic/vgic-mmio.c:__clear_pending() {
		if (irq->hw && !is_user)
			vgic_hw_irq_cpending(vcpu, irq);
		else
			irq->pending_latch =3D false;
}

A similar desync seems possible in __set_pending() when handling
GICD_ISPENDR writes, as well as in vgic_write_irq_line_level_info() and
kvm_vgic_reset_mapped_irq().

Could this lead to stuck interrupts or spurious injections for
hardware-managed interrupts if the hardware remains pending after the shadow
state is cleared?

>  	vgic_queue_irq_unlock(kvm, irq, flags);
>  	vgic_put_irq(kvm, irq);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D26
