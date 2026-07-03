Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4170286AC
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 02:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783045971; cv=none; b=nRwGw9EDPX0/1WZp1AMTlI/j7p8i917mScOR+uaIuo3MDNIe/rjpnzh2EvbPKVITXtEImmMO+yT4YT/Xxd8DgmUdkcH+Tg7fy3VSwwtP69WJ/9gwtmjoYKZTic9f/651ocuIitJstAQYgtJAFBh0h3yaMb+c1s3HKuDXcpJxI8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783045971; c=relaxed/simple;
	bh=x4+IZluu0U7Ao8X5reH8CQty2vjuKfOHR25rMrR07EA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oqT8UFW9rw5T1ozpo4Y6h+/TG6SA+m4ZDS6SCSF72gWMsPxmT7VY2wkK/mGflkoPhAII+rTwGZ6mncZkaV+hH5H2lyXMQHRq5CzvIplXez3el4JwaFS6XBsS+zBbr6c1IeyDcFnizuJcGSxQ2ieGg0ePFa0SwQPN+D5PkDQvUiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m9oqHGIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m9oqHGIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B4A1F00A3A;
	Fri,  3 Jul 2026 02:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783045969;
	bh=tD9D1UPYH3LZCgt8z3/uLhYtT/TBTfVVf1Du70335D0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m9oqHGIClEwYzn3l+FeEVhLYnMzUUIfOxJ859f4R+EBdMKC7kj2SLk9BTaUYURWBv
	 r6MIOiM+bS8kRIFQ2pRsOy01Df9fUUy6POiQWPmtXIU8BDxqw8aZPusfoeqv28x/dN
	 v1qTCD2zZh7FHOabj6tdFRuqiN4l+BKk3Phz1LOU+HZ4lRtE8MhSncBMIRK+Ewz1FV
	 fxwUBUKMCizvnqiQ00WbuORRAymCtwtex2uMgwhvgYICwovYKS7WebBxPMZM3zWOyF
	 j4ZLPtwjoF42BCIakARkXHkGFCEAPUj8dB/3QnXVCEQNJGYPUvlzSpvmgfQHk6pRY0
	 n+TTsO++UgkzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: vgic: Fix race between LPI release and
 re-registration
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2FybG9zIEzDs3Bleg==?= <clopez@suse.de>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260703021508.2593100-2-clopez@suse.de>
References: <20260703021508.2593100-2-clopez@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 02:32:48 +0000
Message-Id: <20260703023249.73B4A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Massive lock contention due to unconditional acquisition of the gl=
obal lpi_xa lock in the hot path.
- [High] Spurious -ENOMEM failures in vgic_add_lpi() due to a TOCTOU race w=
ith xarray node freeing.
--

commit ab3411f56aa5d7fb40c5a79e25df87d1b602fdeb
Author: Carlos L=C3=B3pez <clopez@suse.de>

KVM: arm64: vgic: Fix race between LPI release and re-registration

This commit attempts to fix a race condition between LPI release and
re-registration by moving the reference count decrement inside the xarray
lock in vgic_put_irq(), and by evicting dead LPIs from the xarray during
vgic_add_lpi().

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 67d107e9a77d1..577286069368d 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
[ ... ]
> @@ -116,7 +116,15 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm=
, u32 intid,
>  		kfree(irq);
>  		irq =3D oldirq;
>  	} else {
> -		ret =3D xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
> +		/*
> +		 * The entry is either empty or contains a dead LPI (refcount=3D0)
> +		 * from the deferred release path, pending cleanup by
> +		 * vgic_release_deleted_lpis(). Evict and free it if present.
> +		 */
> +		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq, 0);

[Severity: High]
Can this __xa_store() fail with -ENOMEM due to a TOCTOU race with xarray no=
de
freeing?

Earlier in vgic_add_lpi(), xa_reserve_irq() is called to pre-allocate memor=
y.
If the slot is already occupied by a dead LPI with refcount=3D0,
xa_reserve_irq() returns 0 without actually allocating a new node.

If a concurrent thread (e.g. vgic_put_irq()) removes this dead LPI and frees
the underlying xarray node before vgic_add_lpi() acquires the xa_lock_irqsa=
ve,
the slot becomes completely empty.

When vgic_add_lpi() resumes, xa_load() returns NULL, causing
vgic_try_get_irq_ref() to return false. The code then falls into this else
branch and calls __xa_store(..., 0) with a gfp mask of 0. Since the node was
concurrently freed and gfp=3D0 prevents memory allocations, __xa_store() wi=
ll
fail and return -ENOMEM, potentially breaking guest device initialization.

> +		ret =3D xa_err(oldirq);
> +		if (!ret && oldirq)
> +			kfree_rcu(oldirq, rcu);
>  	}
> =20
>  	xa_unlock_irqrestore(&dist->lpi_xa, flags);
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 5a4768d8cd4f3..c32e6c9777e56 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
[ ... ]
> @@ -167,11 +167,12 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq =
*irq)
>  		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
>  	}
> =20
> -	if (!__vgic_put_irq(kvm, irq))
> +	if (!irq_is_lpi(kvm, irq->intid))
>  		return;
> =20
>  	xa_lock_irqsave(&dist->lpi_xa, flags);
> -	vgic_release_lpi_locked(dist, irq);
> +	if (refcount_dec_and_test(&irq->refcount))
> +		vgic_release_lpi_locked(dist, irq);

[Severity: High]
Does this cause massive lock contention on the global lpi_xa lock in the hot
path?

Previously, the refcount was decremented locklessly and the global xarray l=
ock
(&dist->lpi_xa.xa_lock) was only taken if the refcount dropped to zero.

By replacing this with an unconditional xa_lock_irqsave() for all LPIs befo=
re
checking the refcount, every LPI delivery (e.g. via
vgic_its_inject_cached_translation) that acquires and drops an IRQ reference
will now serialize on this single global spinlock across all vCPUs.

This unconditional lock acquisition also renders the preceding
guard(spinlock_irqsave) block completely redundant.

>  	xa_unlock_irqrestore(&dist->lpi_xa, flags);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703021508.2593=
100-2-clopez@suse.de?part=3D1
