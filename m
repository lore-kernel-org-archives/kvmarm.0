Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08F33AB291
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 11:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783077531; cv=none; b=B8n9e7Nym4lGZNqSg28Nxf4pKQwk0+csx8d1dDf3UBBcxLhBsfS1KDbJu5363wlbGxW0AGBJ2xnJ0x6cdY527RkoNBxCmFwlPqAX2sbWHVBL9Hm5xVPN3/51GozkBsyRqa90sn7ICUaKE9A5yELVWaI2JKp1FYt1HrxDFM8OEk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783077531; c=relaxed/simple;
	bh=106TCBySQeDjx5uZY+J50uPUxl87VJgzFLeIh+aPVkE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PmcBYX3C1BFlIAQHu+VnGy9l+hD51ebjXfWYT1xG9ARKqLD2/9ATCSWIHXlfTFJby2/7PWqjq2j1olTPMpsQ7+KrP0zYuk4CN7Fn0lWgfuIKIZR07NSkovu4uj+SZaZIcZpSaXt5Yzr+q3KyGrVEjzAYQC6B2hUQvz6CX6YmZNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nq4qvpc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nq4qvpc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CA41F000E9;
	Fri,  3 Jul 2026 11:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783077530;
	bh=amsEra5/qKz3CtAFuQuYeetEpPf+dkWs9W/Akza6JsE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nq4qvpc60XKeQghPEUwtDicAExr8CzSw0Wyg+Q34d/UXa+H1kZsoNkKQwjSN7Kdzo
	 jbWIbnRzSSiLs38n5gfnWMRyi1B+Xc7t/hKs8wLBXWhpyodV3rQFc9EHtup+pCStzu
	 +kVABeLqTGU+xtjICLwd2Wf/ipoXsWyv4PQLsjN/xdqvEoFm0dq1Tlia89GyBbDGPq
	 zP8PG13CoWrxnC8eRWxtT8W/dm4bT1ZRrPnsFQH7zNI+mzr5iGWa5Kg5O/OsJ+AvHn
	 KS4PIBWTVEeqmEW/tk3RFnQyZyczEOkWg6ssGcKzwgNqk7rCz+y0B3djiRJAx4zxgo
	 fmBouw0P2CLXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: vgic: Mitigate potential LPI
 registration failure
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2FybG9zIEzDs3Bleg==?= <clopez@suse.de>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260703110130.2609872-4-clopez@suse.de>
References: <20260703110130.2609872-2-clopez@suse.de>
 <20260703110130.2609872-4-clopez@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:18:49 +0000
Message-Id: <20260703111850.20CA41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Fallback XArray node allocation bypasses memcg accounting
--

commit bdc0b53cd314d49c8e7e70017bf5fb300a832c2b
Author: Carlos L=C3=B3pez <clopez@suse.de>
KVM: arm64: vgic: Mitigate potential LPI registration failure

This commit mitigates a race condition in vgic_add_lpi() where an LPI might
be discarded and re-mapped concurrently. It allows __xa_store() to allocate
a new node under the lock if the previously reserved entry was freed.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index 577286069368d..ace3e59fff971 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
[ ... ]
> @@ -121,7 +121,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm,=
 u32 intid,
>  		 * from the deferred release path, pending cleanup by
>  		 * vgic_release_deleted_lpis(). Evict and free it if present.
>  		 */
> -		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq, 0);
> +		oldirq =3D __xa_store(&dist->lpi_xa, intid, irq, GFP_NOWAIT);

[Severity: Low]
Does this __xa_store() fallback allocation bypass memcg accounting?

The initial allocation in vgic_add_lpi() via xa_reserve_irq() correctly uses
GFP_KERNEL_ACCOUNT. However, the GFP_NOWAIT flag here does not include
__GFP_ACCOUNT.

If a guest races a DISCARD and MAPTI command such that the LPI is released
after xa_reserve_irq() but before xa_lock_irqsave(), this __xa_store()
will allocate a new node. Should this use GFP_NOWAIT | __GFP_ACCOUNT to
ensure this allocation is still charged to the guest's memory cgroup?

>  		ret =3D xa_err(oldirq);
>  		if (!ret && oldirq)
>  			kfree_rcu(oldirq, rcu);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703110130.2609=
872-2-clopez@suse.de?part=3D2
