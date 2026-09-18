Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107BA3ACA54;
	Fri, 18 Sep 2026 02:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789700344; cv=none; b=kzNWDcV6oRi70CmCs1ntHwymb9JY3C/1dde+G7QwH99DKgJIFkQxSjUrktbx6s0aKooXDKNECLEnaA+WdpvM5j4kGH6ZZd5aDov/GAcOGUFoixPyclJcOniy7Ypq8Wd6vUSSDHrM0tJ5WajJAVB/kZ0UtxR1L1B2qswOvE9TEe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789700344; c=relaxed/simple;
	bh=a4xBLZvb3Y5RBxXFjHzvxMH2WtxkKkeoikM+56DqjhA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jSsaRw5i9PRvyec+Ssv04SwJBnlGN5NqfJyb91rThHhxhZMlk5elN/FceY7U3bKj9cFfOEv2t4hz87SMpZIMNmBrctLH5xNFHLPkNc1zWpQLJONKdoUFy8PKTUzUxewfttXHXdWJKT2N8a5M8MVKZU/fjhYO+7KFZ4CNmVn7yaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9DCoG95; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9DCoG95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5372F1F000FF;
	Fri, 18 Sep 2026 02:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789700335;
	bh=gqNGZcBqOBVAqtBfA62qvr0CM+qdlHYzpOSgLRIGlIs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R9DCoG95fvBiiGzCS5kJsv38eRavZCqpmZ3JoMzDXdtPUUjNcOF951kA9gJ0kqvi8
	 pX30Lp5I5+E4bz9XychlWLZcszBJCBbaBEaUUDh7KYEOPdKEmttIkGpREzXOOmcOdn
	 V6qCjqnUEYOtwSF1Z8jP3mCqGKULeP0Q4Nr5kx9Um83Q82i7BHuVA+wtK9zBtN9nwI
	 Xnq634d4KlDDp2rSBpdzEfBHptSKsQzGDWV7j3cRLvXgJMPK8neHiOHHqGJrkpBAu7
	 J/dt0q5pZijPyY+tWtu0AyPmPEekgWh4pYZaUxJlxTrvf+f5XORTppnbS2gzS2Pp+w
	 xir/VGDQwr3Wg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] KVM: arm64: vgic: Do not remove in-flight LPIs from
 AP list on disable
Reply-To: sashiko-reviews@lists.linux.dev
To: zjamg <ndaugoing@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260918024620.83869-2-ndaugoing@gmail.com>
References: <20260918024620.83869-1-ndaugoing@gmail.com>
 <20260918024620.83869-2-ndaugoing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 02:58:54 +0000
Message-Id: <20260918025855.5372F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: vgic: LR folding resurrects flushed LPIs due to hardwa=
re pending state
--

commit b351a9acf6c1fda665727c19bb864d488c3f7d75
Author: Yuchao Zhang <ndaugoing@gmail.com>

KVM: arm64: vgic: Do not remove in-flight LPIs from AP list on disable

This commit fixes a use-after-free crash by preventing the removal of
in-flight LPIs from the AP list during a remote flush. It leaves LPIs
that are currently in a list register on the list, relying on the target
vCPU to naturally prune them after folding.

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -205,10 +205,12 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
>  		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
>  			raw_spin_lock(&irq->irq_lock);
>  			irq->pending_latch =3D false;
> -			list_del(&irq->ap_list);
> -			irq->vcpu =3D NULL;
> +			if (!irq->on_lr) {
> +				list_del(&irq->ap_list);
> +				irq->vcpu =3D NULL;
> +				deleted |=3D vgic_put_irq_norelease(vcpu->kvm, irq);
> +			}
>  			raw_spin_unlock(&irq->irq_lock);
> -			deleted |=3D vgic_put_irq_norelease(vcpu->kvm, irq);
>  		}
>  	}

[Severity: High]
Does skipping the unlink for LR-resident LPIs here prevent them from being
naturally pruned later?

When a guest clears GICR_CTLR.EnableLPIs, all pending LPIs should be
discarded. By leaving in-flight LPIs on the AP list, we rely on the target
vCPU's fold logic to handle them. However, when the vCPU exits,
vgic_v3_fold_lr() reads the hardware List Register and resurrects the
pending state:

arch/arm64/kvm/vgic/vgic-v3.c:vgic_v3_fold_lr() {
        ...
        /* Edge is the only case where we preserve the pending bit */
        if (irq->config =3D=3D VGIC_CONFIG_EDGE &&
            (val & ICH_LR_PENDING_BIT))
                irq->pending_latch =3D true;
        ...
}

Because vgic_v3_fold_lr() unconditionally sets irq->pending_latch to true
if the hardware LR has the pending bit set, the flushed LPI's pending state
is restored.

Can this cause the target oracle to evaluate the LPI as still pending,
bypassing the intended flush and keeping the LPI alive for re-injection?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918024620.8386=
9-1-ndaugoing@gmail.com?part=3D1
