Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4302C320CAD
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 15:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609776; cv=none; b=OjDEaCoV4lgImimux8gmMJqEjBssraTe4SryrIdwR27iPmfECecz2xT5t5NY/4Wrwx9gApjJRQp7647k6sJJNMbGG/xR9agSccd0LK+Peh036JhdfH34nPlrMC5c+F/3ZiuIr2rb+/BwPjbPg8y41vHt6SkISMypaWjaQCp0n9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609776; c=relaxed/simple;
	bh=S2vtE9rkBUYeI5k2OTxB4fbkTZ6Aqh2mkat66Ey0n+g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jBp1GPyT8QB0KFxpG9AsagVyfcetiK1A9nhUBpNDc5LYONGIeT7zsaOsd9cItlNiNjdUDc6kXHqbP4sJGmmo0diylCf9WG8Lgc2UiW+CXG000hyJ/oTHvseqs9y9wHUML79ZYD3sSNgS852i4GlI/2CbhJpdTFQG9lJu3w9tBcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+aziALF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+aziALF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626561F000E9;
	Thu,  9 Jul 2026 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783609774;
	bh=Zgdf+dcffsMWG8bEiHPavaEBk/vGYABjWVpoWtrWtmo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e+aziALFigUOhMwCYW+GhBAwL6S6Tj7JovH10M8AxV6d1ZBNYv/qbQHXmqFdorcQm
	 zrItGzIccdbCPnwa+43ic3N4wR9wEoUveAmjtCJ92pT+HUgeQKeQxZdTe2EWnJFfrz
	 xja5ESR2EWVxpeanJJQMN/egqEHerfH83ub6lFBpOYH7Oqaiw21fduCMaPRDk5Qx80
	 l8L2J1BbC+/YW2q5rAwtwxTDfVQcT8Pw9xyy1fu/1Xq6ku/hOTLz6j1U8pyNwNI+yj
	 d2/erIOlhInXF9yGpQ78bYUOkfTma+h05g1f2nWj3D+peb+fKdReixw3YajEkJ74f1
	 +hDtoUahOFVow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] KVM: arm64: vgic: Mitigate potential LPI
 registration failure
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2FybG9zIEzDs3Bleg==?= <clopez@suse.de>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260709144225.3433646-4-clopez@suse.de>
References: <20260709144225.3433646-2-clopez@suse.de>
 <20260709144225.3433646-4-clopez@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 15:09:33 +0000
Message-Id: <20260709150934.626561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The error path in `vgic_add_lpi()` calls `xa_release()`, which acq=
uires the `lpi_xa` lock without disabling interrupts, leading to a potentia=
l deadlock.
--

--- Patch [2]: [PATCH v5 2/2] KVM: arm64: vgic: Mitigate potential LPI regi=
stration failure ---
commit c5f231166837f986fca0d6f0a35dc7e8c46a61d1
Author: Carlos L=C3=B3pez <clopez@suse.de>
Subject: KVM: arm64: vgic: Mitigate potential LPI registration failure

This commit mitigates a potential allocation failure when inserting a new L=
PI=20
into the VGIC LPI xarray. It updates vgic_add_lpi() to pass GFP_NOWAIT and=
=20
__GFP_ACCOUNT to __xa_store(), allowing allocation to occur under the lock =
if=20
the reserved entry was removed concurrently.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -124,7 +124,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm,=
 u32 intid,
>  		 * holds before freeing it, as otherwise someone else could still
>  		 * hold a pointer to the evicted struct.
>  		 */
> -		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq, 0);
> +		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq,
> +				    GFP_NOWAIT | __GFP_ACCOUNT);
>  		ret =3D xa_err(oldirq);
>  		if (!ret && oldirq &&
>  		    !WARN_ON_ONCE(refcount_read(&oldirq->refcount) ||
>  				  !oldirq->pending_release))
>  			kfree_rcu(oldirq, rcu);
>  	}
> =20
>  	xa_unlock_irqrestore(&dist->lpi_xa, flags);
> =20
>  	if (ret) {
>  		xa_release(&dist->lpi_xa, intid);

[Severity: High]
This is a pre-existing issue, but does calling xa_release() here introduce a
potential lock inversion deadlock with hardirqs?

The xa_release() function internally uses xa_cmpxchg(), which acquires the=
=20
lpi_xa.xa_lock using spin_lock() without disabling local interrupts.

If a hardware interrupt fires on this CPU while the lock is held (for examp=
le,
an eventfd signal triggering irqfd_wakeup() in hardirq context for fast-pat=
h=20
MSIs), it can inject an LPI and eventually call vgic_put_irq().

Because vgic_put_irq() acquires lpi_xa.xa_lock using spin_lock_irqsave(), t=
he=20
interrupt handler would spin forever waiting for the lock held by the preem=
pted
vgic_add_lpi() thread.

Since this patch makes it more likely for the error path to be hit (if the=
=20
GFP_NOWAIT allocation fails), should this path be updated to manually erase=
=20
the entry while holding the xarray lock with interrupts disabled?

>  		kfree(irq);
> =20
>  		return ERR_PTR(ret);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709144225.3433=
646-2-clopez@suse.de?part=3D2
