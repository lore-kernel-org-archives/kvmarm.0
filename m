Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ED924E4B4
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781545637; cv=none; b=JqouDCJP74gDIBWV2isGv1kOwNzKSUbDRTFJzg6GE7DWq2oE+iJc3spjST6a9suBi20MIt9Jzpvna9xPuBgdvzYNch1w1VlCn1ag5kD4ydl1j+Ia4nSz2gtv6KZIvBNQkuon5T/UnqMzZPoEQ8iXG8mzWvIcETrmRaF0mgxgWH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781545637; c=relaxed/simple;
	bh=2wv4DrmR9rVmtjiewqbUMk/LFbbWJqr8zKExRv8iTCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Arh0s1m2qZCo8J5Ut6qc2p1RdA1TCyk1eyFt2U40fy8ZjtaEQzJDJGRnFojRszqKGWtBTamPUV4FD5uwFhexTGEa6Hpc+naAOOIeES6MflCJebx0kZ2rEinYl5EwrMN4ubKvHkJlCByGg06Od7yEGx/nkF1Jo1mMbI3/058jN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jUgGCBXY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jUgGCBXY"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c85a2c305d0so1870990a12.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 10:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781545635; x=1782150435; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VDX/a34KwI6qjOxB+SOsUTAEqmtLSVOgiOVOtsI+2Y=;
        b=jUgGCBXY6Tnvdy7pk1kYh7Y3jO2RKseTv8dJswiHdN49tdw3Lp2N91iJS88YLstXBr
         0axsu4xyS3r8Z82mmkUTGT6g2JmdBnpK2AqaYwkWvNW3NR9cnFRsoupd4LRHsgK2DvWc
         K9BmD3UNGOwpMZfcoOgpbsPRalZwhnXv+DhlHLA/GWHpOshYIBIt6NVi8ONWJOg4Q00p
         ZbAYaZeh5otAMrvldEBoqrY/YXYiCHzLiWBaKtNFSH6a96vKsUq6znGYMZRKTYSrpqlQ
         RYQxXEqDGHcmo8tOmkQYc68u4VDR3abjj/u8vzfFqjyjjxGRTWqh+DgsxMMyYx/OXVxQ
         0h1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781545635; x=1782150435;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+VDX/a34KwI6qjOxB+SOsUTAEqmtLSVOgiOVOtsI+2Y=;
        b=SSh8VDq8XCUZHuUSnfSKc/xMblnYjSGTmLbdzmu7Cv+At1PRV3YgC80LhYealcwuBK
         O6sNgn0V+pA/90rxuRnMgCFfBiu9wU+n590UCK7geIpBBfweDwF8U3ZCwuaKdMVhhS03
         Cv1PQ/+lNOIaLTLDw1FscrW5b5ANe1VzWdtpdcWfq/EMzGeWibPeTqgney06mdwzNN0B
         Z7eSnMqXgVht4lpRRMah4RTxhFGoo8a0yq50aA27hLW9R4ADKTynhZ6e6qPTGf/vh4hP
         KyKnQAWtRJK+MNvU9bTMuvwtlgZcr5h/Tmog4sSHJ8cgCnkdUU0eR5gdTDGnSekmm2Yk
         aVyg==
X-Forwarded-Encrypted: i=1; AFNElJ918giFPWNtgaZTVJOuIvT4yCsD8RwLgNl2sUUamDmVLjq1bzHUrUOXn6WN3JIFsrj3iDNMxag=@lists.linux.dev
X-Gm-Message-State: AOJu0Yycv0e3qDfSgzM+Mtm31naX0gb5m2Q4RjgvzYCOiMbIofOfPjF3
	bDxfC3zm91d5MfzYuTIYshcEMkrsPnQ4FZr4Bukgr0rtY5RhwPueeQCWdfft+tGFWMMnELH87u3
	Ni9DS6g==
X-Received: from pgaf19.prod.google.com ([2002:a63:3813:0:b0:c80:2656:4e70])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3c89:b0:3b3:241f:66c6
 with SMTP id adf61e73a8af0-3b7e4cf86b3mr95295637.26.1781545635135; Mon, 15
 Jun 2026 10:47:15 -0700 (PDT)
Date: Mon, 15 Jun 2026 10:47:14 -0700
In-Reply-To: <20260615160901.9A1A61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260615155244.183044-1-alexandru.elisei@arm.com> <20260615160901.9A1A61F000E9@smtp.kernel.org>
Message-ID: <ajA6ogaNiI3KDv5i@google.com>
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026, sashiko-bot@kernel.org wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> [ ... ]
> > @@ -592,6 +592,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva=
_range(struct kvm *kvm,
> >  			unsigned long hva_start, hva_end;
> > =20
> >  			slot =3D container_of(node, struct kvm_memory_slot, hva_node[slots-=
>node_idx]);
> > +
> > +			if (kvm_slot_has_gmem(slot) && kvm_memslot_is_gmem_only(slot))
> > +				continue;
> > +
>=20
> [Severity: Critical]
> Does this change inadvertently introduce a regression in the pfncache ret=
ry
> protocol?
>=20
> Looking at the pfncache framework, it maps guest memory into kernel space=
 and
> explicitly drops the page reference after mapping it:
>=20
> virt/kvm/pfncache.c:hva_to_pfn_retry() {
>     ...
>     kvm_release_page_clean(page);
>     ...
> }
>=20
> It appears to rely entirely on KVM's MMU notifiers (kvm->mmu_invalidate_s=
eq)
> to invalidate the cache when the page is unmapped by the host.
>=20
> If a VMM defines a guest_memfd-backed memslot with KVM_MEMSLOT_GMEM_ONLY
> but still provides a valid anonymous user mapping as its userspace_addr,
> could this regression lead to a use-after-free?

Sadly, yes.  To land this, we would need to first teach the gfn_to_pfn_cach=
e code
to be able to pull directly from guest_memfd.  I forget if anyone is workin=
g on
that.

> By unmapping the anonymous memory, the host would trigger MMU notifiers, =
but
> this new check skips the memslot. As a result, kvm->mmu_invalidate_seq
> wouldn't increment, and KVM might retain a kernel mapping to a freed phys=
ical
> page.
>=20
> Could this allow the guest to read or write arbitrary host physical memor=
y?
>=20
> >  			hva_start =3D max_t(unsigned long, range->start, slot->userspace_ad=
dr);
> >  			hva_end =3D min_t(unsigned long, range->end,
> >  					slot->userspace_addr + (slot->npages << PAGE_SHIFT));
>=20
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260615155244.18=
3044-1-alexandru.elisei@arm.com?part=3D1
