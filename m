Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8CA2E719B;
	Fri, 16 Oct 2026 16:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167275; cv=none; b=DNdaSF8KxisrO3BdHfjJkQcQMH/bDVekRGHAmFAlD4BjqA9Q6jJ8y3QIYeLXEodimLbt5sBAaFgKSoVm/yO0rTy5qA3PzR3v4dypeNmsQldyAKQNS1z2DM69airEo6WvihtRlbMNAohWPeL8YPGMNjsHRFBNGrCRTqczObgXW0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167275; c=relaxed/simple;
	bh=JhkCgFscqO3e6fUnU47gcbiEWlBj3ckG+hjHSdWnDp8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=V28thF2CvwQOGZsrYFrDvhqeRpxx9pnjSjjKjRc9o9+IRAg2P7gGi1bym+QD2slHQrb0cF5HvytIcP8WJGpwqVdvLTOdHHxLpDPLqW1Qioz/gBaV9G69Mfq5z9SiMOGuLDeEinLJpIevn739/90t+UvSrxjNgCAe9Cc2WlU7x+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVqBEtDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVqBEtDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03941F000C4;
	Fri, 16 Oct 2026 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167271;
	bh=Hp9KSkBZtWOuV1uhBzzxFWf14kBrI4Ky2VPKDSawEn4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dVqBEtDhIe7nRA+KoL5fvzNeWNTZnijVMyWaklxPJkmr853Vx8/WfQPOj3xcg/oh1
	 AXrGyToQULab+eACQXVflGgvMTIqmZEuKh9w98jey+Dl7U+79q+XP+6gla7UVNG0os
	 zCMWzfhUrCeRYiI1SMrJu4tqRX3cuoKj2w7NUwMbG2cQtlnCS+9rJyCI0aPRdcK3gw
	 90IPaJiufEl4mvo8SfO9Q9p9RYM0HMhTCQK7VTFwQxpSyyEdadRUjMCUVUe1ElsfMj
	 CC7NbMP32AeKXNm8JPeyjS4PwqN/tLeRO0ABx3YiYNyaRuLQDn1NAlu2s378k6W7qy
	 v1QoDcgIx7CZg==
Message-ID: <sashiko-outbox-174615@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/16] KVM: arm64: vgic: Split out common LPI allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-2-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-2-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:14:30 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: data race on irq->group due to unlocked assignment after publ=
ication
--

commit 0cabb3a5e012e80ff468a8654506c83304b15486
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: vgic: Split out common LPI allocation

The GICv3 ITS code currently owns vgic_add_lpi(), even though the
first half of the helper is not ITS specific. It allocates or finds
the VM-wide vgic_irq object in lpi_xa and initializes the common LPI
state before the GICv3 ITS code reads the property table and pending
state.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index e5657cb603567..8e7bee1bae95d 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -66,77 +66,22 @@ static int update_lpi_config(struct kvm *kvm, struct =
vgic_irq *irq,
[ ... ]
> -	irq =3D kzalloc_obj(struct vgic_irq, GFP_KERNEL_ACCOUNT);
> -	if (!irq)
> -		return ERR_PTR(-ENOMEM);
[ ... ]
> +	irq =3D vgic_add_lpi(kvm, intid, vcpu);
> +	if (IS_ERR(irq))
> +		return irq;
> =20
> -	irq->config =3D VGIC_CONFIG_EDGE;
> -	refcount_set(&irq->refcount, 1);
> -	irq->intid =3D intid;
> -	irq->target_vcpu =3D vcpu;
>  	irq->group =3D 1;

[Severity: High]
Does this code introduce a data race on irq->group in vgic_its_add_lpi()?

Since vgic_add_lpi() now publishes the object to the globally visible
lpi_xa xarray and drops the locks, a concurrent thread (e.g., another vCPU
writing to GICR_INVLPIR or mapping the same LPI on another ITS) can
retrieve the LPI and access irq->group under irq_lock before we set it here.

This can misroute or drop the LPI if it is evaluated by vgic_irq_cmp()
as Group 0 instead of Group 1. Should we set the group before publishing,
or hold irq->irq_lock when assigning it?

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index c2726d4c06e6e..bc0171c479a95 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -79,6 +79,78 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, =
u32 intid)
[ ... ]
> +/*
> + * Creates a new (reference to a) struct vgic_irq for a given LPI.
> + * If this LPI already exists, we increase its refcount and return it.
> + * If this is a "new" LPI, we allocate and initialize a new struct vgic_=
irq.
> + * This function returns a pointer to the _unlocked_ structure.
> + */
> +struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
> +			      struct kvm_vcpu *vcpu)
> +{
[ ... ]
> +		/*
> +		 * The entry is either empty or contains a dead LPI (refcount=3D0)
> +		 * from the deferred release path, pending cleanup by
> +		 * vgic_release_deleted_lpis(). Evict and free it if present.
> +		 */
> +		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq,
> +				    GFP_NOWAIT | __GFP_ACCOUNT);

[Severity: High]
Is it safe to publish the new LPI here while its group field is still
uninitialized (0)?

As mentioned above, doing this in vgic_add_lpi() makes the LPI accessible to
concurrent lookups in vgic_get_irq() before vgic_its_add_lpi() has finished
setting up the group field.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D1
