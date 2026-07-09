Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B98377010
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609202; cv=none; b=U8gvR20IEiPLGh8e8pSiBIE8/KUOWwfz8rWKRCEiEcXfJinleUvVKxDjvJqNhqepv8Yn5iMkXsKoMcFDW8ejz8m0+oL57zc4aiec+5QINghdsjKmR1n0yEvSjDhCLk9PEqPUJovl5elb+mhOq4iMaSAfn0WUBUWECs5/YuTGS/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609202; c=relaxed/simple;
	bh=6ccK9yG11aWzzp59O7L0sGOqiyECrS/WWp4Qnmy72S0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dVqf01D57VXBKFMUal1rmfW+Ar9PVc3AANOrDPikd95gRail/TJTs/zHS0GrYCRKNyM25ZChWhWo3+0Y6ihq92woMmZnfdgb4JtLs0UPONinBGWFQuKpX5LdkueTH/0ejNBVTt7yp0zXdq9lyoSCnCFwkwgmQHYWfAmEVHAd/ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AitiFu7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AitiFu7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7F31F000E9;
	Thu,  9 Jul 2026 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783609199;
	bh=/BMRolkXuTsfjOkiBzSIlCckEW7F8VurS3qYJtVx3b8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AitiFu7uC+p4RzD7ieDCN3Yl0P1a5Hkd4D08DqFzl6zbOGPJcSfTYYNS1K3i1vIAd
	 bZY+rQUhnPYMVgaV0mRRDfsBiy1esnMGy9A2V9+vBiKJOXM6sg6IGVhKilDoIgR5B5
	 jcW9638zBUy5ykwMMFIAEorCK2XYtb1GEkekFnhT4zgiuC4qYBUoy6LALVZ9633GGT
	 7ys18e4TG3qk7JiJNuGJmELJHeiICxArCgN+xkxZBiky8mndt6g6Nsalh0/6n1Y1i6
	 VBWKEbzuw6JvgEa0qRsYUb3fH1ZuRIL3BJK5gFe/xyTAC5UJu2x1y7WDP3D7rz6Z8g
	 yXPSXIUyIFrxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/2] KVM: arm64: vgic: Fix race between LPI release
 and re-registration
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2FybG9zIEzDs3Bleg==?= <clopez@suse.de>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260709144225.3433646-3-clopez@suse.de>
References: <20260709144225.3433646-2-clopez@suse.de>
 <20260709144225.3433646-3-clopez@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 14:59:57 +0000
Message-Id: <20260709145958.3D7F31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Race condition between deferred LPI release and concurrent LPI reg=
istration leaks memory and triggers a host warning.
--

--- Patch [1]: [PATCH v5 1/2] KVM: arm64: vgic: Fix race between LPI releas=
e and re-registration ---
commit 0e3a1226f09c3d09f5b82c5882f2fe2063ffdca4
Author: Carlos L=C3=B3pez <clopez@suse.de>
Subject: KVM: arm64: vgic: Fix race between LPI release and re-registration

This commit addresses a race condition where an LPI can be deleted or
leaked during concurrent release and re-registration. It moves the refcount
decrement inside the xarray lock for direct releases, and makes
vgic_add_lpi() responsible for freeing 0-refcount LPIs evicted from the
xarray.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 67d107e9a77d1..4685332457270 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c

[ ... ]

> @@ -116,7 +116,20 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm=
, u32 intid,
>  		kfree(irq);
>  		irq =3D oldirq;
>  	} else {
> -		ret =3D xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
> +		/*
> +		 * The entry is either empty or contains a dead LPI (refcount=3D0)
> +		 * from the deferred release path, pending cleanup by
> +		 * vgic_release_deleted_lpis(). Evict and free it if present.
> +		 * Make sure that the assumption that the IRQ is pending release
> +		 * holds before freeing it, as otherwise someone else could still
> +		 * hold a pointer to the evicted struct.
> +		 */
> +		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq, 0);
> +		ret =3D xa_err(oldirq);
> +		if (!ret && oldirq &&
> +		    !WARN_ON_ONCE(refcount_read(&oldirq->refcount) ||
> +				  !oldirq->pending_release))

[Severity: High]
Can this race with vgic_put_irq_norelease() and leak the oldirq structure
while incorrectly triggering the WARN_ON_ONCE()?

Looking at vgic_put_irq_norelease(), the refcount is decremented to 0 before
pending_release is set to true:

vgic_put_irq_norelease()
    if (!__vgic_put_irq(kvm, irq))
        return false;
       =20
    // At this point refcount is 0, but pending_release is still false
   =20
    irq->pending_release =3D true;

If CPU1 executes vgic_add_lpi() during this window, wouldn't it see
oldirq->pending_release as false, trigger the WARN_ON_ONCE, and then skip
kfree_rcu(oldirq, rcu)?

When CPU0 later resumes and sets pending_release to true, the LPI is
already evicted from the xarray. Because it is no longer in the xarray,
vgic_release_deleted_lpis() would not find it, resulting in a permanent
leak of the old LPI.

> +			kfree_rcu(oldirq, rcu);
>  	}
> =20
>  	xa_unlock_irqrestore(&dist->lpi_xa, flags);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709144225.3433=
646-2-clopez@suse.de?part=3D1
