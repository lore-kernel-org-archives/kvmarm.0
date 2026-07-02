Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC6937A83A;
	Thu,  2 Jul 2026 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783003682; cv=none; b=YQlVwU+Y45Y+fGH8hXF1MNDooRghrp1DXkRijJEh4yv5jD3pm2J+MfiINTJ9iNclRb6qXZ6+27SFIusygZJJlv/jzqMO5VJ5w6OcfmMMgfRdft76zJHMF/+72RxcF2amiDjNm3sPE1xH24JT5jGAtP7pCC3xgjQ9P4pjY0rNEL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783003682; c=relaxed/simple;
	bh=xX8rOaNNkPQaC5aTJHsIjlCUYARQVvi3p4TYyCvsG7k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kZec1PtkrYuYavSEna0IijypzBcBWj048Cq24XxsMm0iKJ3kIMaO2vebnPm1+gjRU3mvdUDG5Z/UyoP3ZXKuZ/NdmbNmjcjqwrfLHkjIcTm5+N9ZRDFc02rimPBKZ5I12VbE/5eDn0Z+oScbOKmwkWGC7AMpBJLlnAEyFMGCIP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqKYI1Wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqKYI1Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5821F00ADF;
	Thu,  2 Jul 2026 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783003679;
	bh=it5yP2Vyx2kme8r83sKSfOusL/ik9sWCmpsffykBpVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HqKYI1WvVL0H8+HqaySP1n6Iou6H8xdfq7kwP3PiqCA069op76g0OH1ZvuJdEJxav
	 NHF6HN+0sukrU9GcVRXSo74R60HD7kUsxw7YgRkqh8PdbL0umXWEXPIYALFCXMyYNS
	 LfheWz0/aPlBtTqer32HeVvrQxKGCThO7OgKo9RjYRv45nGISwYMOdLi+zUJPdhdua
	 mI/75GX2FgfMI7Qm3SSfUo7Y8Ar3BqFckH08tWv7PBi7r+9r1GM7oS+33CZ2Cfwg+7
	 lGnJOk3gCdllDvaZ8ze1Evo5WfHsQCUxUNejeNkyQ4SP18N8QziA9PzTz724pmrArB
	 N3A/O3lj3eqtA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track
 of associated memslots
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260702142912.6395-2-alexandru.elisei@arm.com>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 14:47:57 +0000
Message-Id: <20260702144758.9D5821F00ADF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Stale SPTEs are left mapped during concurrent memslot deletion=
, causing a Use-After-Free when backing folios are freed.
- [Low] Silent suppression of kernel warnings for memslot 0 mismatches.
--

commit ca8b0f095e48299dd0d910de62ee16780d361eec
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: guest_memfd: Use memslot id to keep track of associated memslots
   =20
To enable memslot operations, KVM maintains two arrays of memslots, and an
RCU pointer to the active (in use) array. Changes are made first to the
inactive array, and the RCU pointer is updated to point to the inactive
array, which becomes active.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab60..43ef8e908aaf6 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -165,9 +189,15 @@ static void __kvm_gmem_invalidate_start(struct gmem_=
file *f, pgoff_t start,
>  	struct kvm_memory_slot *slot;
>  	struct kvm *kvm =3D f->kvm;
>  	unsigned long index;
> +	void *entry;
> +
> +	xa_for_each_range(&f->bindings, index, entry, start, end - 1) {
> +		pgoff_t pgoff;
> =20
> -	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
> -		pgoff_t pgoff =3D slot->gmem.pgoff;
> +		slot =3D xa_value_to_memslot(kvm, entry);
> +		if (!slot)
> +			continue;
> +		pgoff =3D slot->gmem.pgoff;

[Severity: Critical]
Could this leave stale SPTEs mapped during concurrent memslot deletion,
leading to a Use-After-Free?

If a guest_memfd hole punch executes concurrently while a KVM_MR_DELETE
operation is waiting in synchronize_srcu(), xa_value_to_memslot() will retu=
rn
the invalid_slot. Because kvm_copy_memslot() does not copy the conditionally
compiled gmem struct, invalid_slot->gmem.pgoff is 0.

When __kvm_gmem_invalidate_start() calculates the gfn_range using a 0 pgoff,
it can result in start >=3D end, causing kvm_mmu_unmap_gfn_range() to skip
zapping the SPTEs. When the backing folios are then freed by
truncate_inode_pages_range(), the guest could access freed host memory.

[ ... ]

> @@ -765,8 +830,8 @@ static struct folio *__kvm_gmem_get_pfn(struct file *=
file,
>  		return ERR_PTR(-EFAULT);
>  	}
> =20
> -	if (xa_load(&f->bindings, index) !=3D slot) {
> -		WARN_ON_ONCE(xa_load(&f->bindings, index));
> +	if (xa_load(&f->bindings, index) !=3D memslot_to_xa_value(slot)) {
> +		WARN_ON_ONCE(xa_to_value(xa_load(&f->bindings, index)));

[Severity: Low]
Will this suppress the intended warning when the corruption involves memslo=
t 0?

If the xarray state erroneously points to memslot 0 (as_id=3D0, id=3D0),
xa_load() returns xa_mk_value(0). xa_to_value() unwraps this to 0, causing
WARN_ON_ONCE(0) to evaluate to false and fail to warn.

(This logic would also similarly suppress the warning in kvm_gmem_change_fl=
ags()
when there is a structural state inconsistency involving memslot 0).

>  		return ERR_PTR(-EIO);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702142912.6395=
-1-alexandru.elisei@arm.com?part=3D1
