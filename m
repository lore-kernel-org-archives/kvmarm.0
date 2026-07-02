Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E7266EE9
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 23:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036346; cv=none; b=Xo08BG+X4UHpeNMX1t9yTFYcOBrwQShvbZFlpeTIN8aNVgzJqczsDiWbNPABTRKDZuoIMJ6TIOVtaOFCxV9SBlYrkY5x+xqEx6/jbjqmnO3UyX0HPIePX8jxqAi9P6WkBCxF9HucxorxGY1+Z2RPFNfDkuS7uUWhTHRIFCMW20o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036346; c=relaxed/simple;
	bh=D+2omp0STr6cdHSa5QfzxX/qeQV5S+ZgQ/bEkjFHqgg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TpVqtkQbZSN2W/uFa3iDkR9fvYuL19NJ3ebsRRBU/rs60iaOxj+IeqSprTxjzgPyUTeB9RdjoqwqYZ1V5F8jPEgqTpz0FDKwPg+4Vq2MJXbqJHlC2BmR94HWv5NYMweiJ/GMPsU8V4km3CrjOcJIdlMrm6zjjKlph8MQx+RWFb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTn0maQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTn0maQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB21C1F000E9;
	Thu,  2 Jul 2026 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783036345;
	bh=ykkx/INeI20xYMwV+a6KndIn06+TG228AUSrhCfnYqM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CTn0maQ2IOvbfdifTXhZLi9eZAHpRe+yL6HUSR+CssACG1des38Zex/DODXSq9P64
	 AsazbbLm0UhJugliPLwC3GTpHTVlA8AKYxF+oi7xc+4nNn8Y4jhgsXQ0HG3ZGK+xu4
	 TEWkpm3p4xCXKLEvxpHEXT64EIQ9leVv/q4zjkinP3EHvTwe1RIz7L0kwG/OdqY4Qi
	 33cnZRV8+nvaflu6d+L7lRGYidSQVoCWCO82Bj8Ry41oL+oJYAhoyVc0Cp0nke1DF+
	 fjkN9t5viMiKJUCDlvQ6iY2NJmRDBg3ncvyP2zclopS1Vhp+jIrzpCv5zl+qgjVask
	 d00CGrgEowT4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic: Fix race between LPI release and
 re-registration
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2FybG9zIEzDs3Bleg==?= <clopez@suse.de>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260702233514.2581921-1-clopez@suse.de>
References: <20260702233514.2581921-1-clopez@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 23:52:24 +0000
Message-Id: <20260702235224.EB21C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] The patch introduces a Use-After-Free (UAF) and ABA vulnerabil=
ity by allowing `vgic_add_lpi()` to free an LPI via `kfree_rcu()` while a c=
oncurrent `vgic_put_irq()` could still be processing the same LPI's release=
 without RCU protection.

Pre-existing issues:
- [High] `vgic_add_lpi()` can spuriously fail with `-ENOMEM` when racing wi=
th an LPI release due to a lost XArray node reservation.
--

commit 3cbf900c0e9154b2814ac964d591008312ad60be
Author: Carlos L=C3=B3pez <clopez@suse.de>

KVM: arm64: vgic: Fix race between LPI release and re-registration

Fix a potential race between decrementing an LPI's reference count and
evicting that structure from the LPI xarray.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -116,7 +116,15 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm=
, u32 intid,
>  		kfree(irq);
>  		irq =3D oldirq;
>  	} else {
> -		ret =3D xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
> +		/*
> +		 * The entry is either empty or contains an IRQ whose refcount is 0
> +		 * but has not yet been freed by vgic_release_lpi_locked(). Evict the
> +		 * IRQ and free it, if there is one.
> +		 */
> +		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq, 0);

[Severity: High]
This is a pre-existing issue, but can this __xa_store() fail with -ENOMEM
when racing with an LPI release?

Looking earlier in vgic_add_lpi(), xa_reserve_irq() allocates an XArray
node, but the lock is released immediately after. If a concurrent
vgic_release_lpi_locked() replaces the entry with NULL (or erases it before
this patch), the underlying XArray node might be freed.

When this thread resumes and calls __xa_store() here with gfp=3D0, could it
fail due to the missing node and cause the guest ITS command to be dropped?

> +		ret =3D xa_err(oldirq);
> +		if (!ret && oldirq)
> +			kfree_rcu(oldirq, rcu);
>  	}
> =20
>  	xa_unlock_irqrestore(&dist->lpi_xa, flags);

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -131,9 +131,19 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *=
vcpu, u32 intid)
> =20
>  static void vgic_release_lpi_locked(struct vgic_dist *dist, struct vgic_=
irq *irq)
>  {
> +	struct vgic_irq *old;
> =20
>  	lockdep_assert_held(&dist->lpi_xa.xa_lock);
> -	__xa_erase(&dist->lpi_xa, irq->intid);
> -	kfree_rcu(irq, rcu);
> +
> +	/*
> +	 * Free the IRQ if it is still present in the xarray, as its entry coul=
d have
> +	 * been overwritten after the refcount was dropped, but before the xarr=
ay lock
> +	 * was acquired. If the cmpxchg fails, vgic_add_lpi() grabbed the lock =
first
> +	 * and freed the old IRQ along the way.
> +	 */
> +	old =3D __xa_cmpxchg(&dist->lpi_xa, irq->intid, irq, NULL, 0);

[Severity: Critical]
Does this introduce a use-after-free and ABA issue if the RCU grace period
completes before this thread acquires the xarray lock?

When vgic_put_irq() drops the refcount to 0, the thread does not hold an RCU
read lock while waiting to acquire the xarray lock. A concurrent
vgic_add_lpi() could replace the old LPI and call kfree_rcu(oldirq, rcu).

Because the releasing thread isn't in an RCU critical section, the grace
period can elapse. The memory backing this irq can then be freed and
reallocated to a new LPI with the same intid.

When this thread eventually resumes and calls __xa_cmpxchg(), wouldn't it
dereference the freed irq pointer to read irq->intid, and then incorrectly
match the reallocated LPI, causing a double-free?

> +	if (old =3D=3D irq)
> +		kfree_rcu(irq, rcu);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702233514.2581=
921-1-clopez@suse.de?part=3D1
