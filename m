Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BC7426435
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284094; cv=none; b=Y6EuNRiP/2Z4rGystoOSeGl/mXgtKEvk7MpzbcLcTHRyK9fZ4ROSeJy/99DUZ3CEA2q7A2Q0flXcDl94Whyxd/Cwdx+DqmUeU5Hxg0bolTv0KYjIidortY1HuxtUkC7DD/nzGskk1p5YX7siAX1o1I5V5B77Zu+trQ7DRz5eD/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284094; c=relaxed/simple;
	bh=QUznZwaBnZt0uKmuP+1SfxWvSPdYDkiYmLg8UsFSAWE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h2yycLj/b5euuLVGmylzXgRHVqZQ+liGjGWQOyKPs8aDZ/FfNUzr2oBw/HFHLN8L2Awwf723jvvNJNnFZKDoi7gFdOGUDrPyEaJJC9Wi1GemmQ3FVj7eMpUxIHUPL4X5/XFch65WrwCyE9HK6JJ3oopqTFArNo8oqRpWMOjaqwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHA+04RI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHA+04RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038E01F000E9;
	Tue,  1 Sep 2026 17:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788284093;
	bh=yNPd/PE5kLaxgn0a94IJd3kakZi/MBfzf5JbFFBH/uY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nHA+04RIn0tW+TFSgFHB1z60EgOoskxVcEqmZVMWqmJA0E2eqGKuaMLkB4iABOlS1
	 JeoaxvjXa9zDxlUv40xgCuhEIcNrQu59eWqqeysdYOEEAD39brj1nDyo7JL0ltHU+X
	 rcLoCxgqwrbApscW7uR2yA29QcPBdlVHHo8mrIhmZBfXEGKPiI1jZ6GEMGkIv6wIZP
	 FiTE1LoBpnPxE0hZWX09kXWsXhwlgd6Ci4BfQuMc2Kko/phC7pOxiRfN+1xwoFpWqY
	 cvx3Ia46feyoRAr9VWtLYHuJ95aZ+g4jXwfXxq6MpVOIeuyMZCsQhn+q3FZ0f1JDPv
	 +7EuPYI603+8A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/5] KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260901171558.2674031-3-leo.bras@arm.com>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-3-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 17:34:52 +0000
Message-Id: <20260901173453.038E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Silent data corruption and loss of guest memory due to missing=
 host folio dirty tracking with hardware Dirty Bit Management (HW DBM).
--

commit c5bf76c3d6bf3edf785c54c123328d74e2186585
Author: Leonardo Bras <leo.bras@arm.com>
KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY

This commit introduces KVM_PGTABLE_PROT_DIRTY to distinguish between writab=
le
but not dirty pages and writable and dirty pages in the Stage2 PTE descript=
or.
It evaluates these concepts on a per-case basis across KVM ARM64 page table=
s.

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
[ ... ]
> @@ -731,8 +731,12 @@ static int stage2_set_prot_attr(struct kvm_pgtable *=
pgt, enum kvm_pgtable_prot p
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		attr |=3D KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> =20
> -	if (prot & KVM_PGTABLE_PROT_W)
> -		attr |=3D KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +	if (prot & KVM_PGTABLE_PROT_W) {
> +		attr |=3D KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +
> +		if (prot & KVM_PGTABLE_PROT_DIRTY)
> +			attr |=3D KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +	}

[Severity: Critical]
Could this translation enable hardware DBM bypass for pages not marked
PROT_DIRTY? This translates the software PROT_W without PROT_DIRTY into
the hardware PTE state (DBM=3D1, S2AP_W=3D0), setting up the HW DBM bypass.

[ ... ]
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -1681,10 +1683,10 @@ static int gmem_abort(const struct kvm_s2_fault_d=
esc *s2fd)
>  	}
> =20
>  out_unlock:
> -	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
> +	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_DIRT=
Y);

[Severity: Critical]
Does limiting the dirty tracking here to PROT_DIRTY instead of the mapping
writability (PROT_W) cause host folio dirty tracking to be missed when HAFD=
BS
is enabled?

[ ... ]
> @@ -1984,11 +1986,14 @@ static int kvm_s2_fault_compute_prot(const struct=
 kvm_s2_fault_desc *s2fd,
> =20
>  	*prot =3D KVM_PGTABLE_PROT_R;
> =20
> -	if (s2vi->map_writable && (s2vi->device ||
> -				   !memslot_is_logging(s2fd->memslot) ||
> -				   kvm_is_write_fault(s2fd->vcpu)))
> +	if (s2vi->map_writable) {
>  		*prot |=3D KVM_PGTABLE_PROT_W;
> =20
> +		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
> +		    kvm_is_write_fault(s2fd->vcpu))
> +			*prot |=3D KVM_PGTABLE_PROT_DIRTY;
> +	}

[Severity: Critical]
On a read fault when HAFDBS is enabled, this leaves KVM_PGTABLE_PROT_DIRTY
unset while KVM_PGTABLE_PROT_W is set. Can this allow the hardware to
locklessly dirty the page later without KVM knowing?

[ ... ]
> @@ -2019,7 +2024,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fau=
lt_desc *s2fd,
>  			    void *memcache)
>  {
>  	enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_SHARED;
> -	bool writable =3D prot & KVM_PGTABLE_PROT_W;
> +	bool dirty =3D prot & KVM_PGTABLE_PROT_DIRTY;

[Severity: Critical]
By deriving the dirty status for host folio tracking strictly from PROT_DIR=
TY
instead of PROT_W, are we setting up the host MM to track the folio as clean
on read faults?

[ ... ]
> @@ -2082,7 +2087,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fau=
lt_desc *s2fd,
>  	}
> =20
>  out_unlock:
> -	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
> +	kvm_release_faultin_page(kvm, s2vi->page, !!ret, dirty);

[Severity: Critical]
Releasing the folio to the host MM as clean on read faults could break host
folio dirty tracking.

If a guest later writes to this page and the CPU locklessly sets S2AP_W=3D1
without trapping, KVM won't be aware. Since KVM ARM64 does not harvest this
dirty bit during MMU notifier invalidations, the host Linux MM never learns
the folio was dirtied. When the host reclaims the folio under memory
pressure, does this result in data corruption and loss of guest memory by
discarding the modified data instead of writing it to swap?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901171558.2674=
031-1-leo.bras@arm.com?part=3D2
