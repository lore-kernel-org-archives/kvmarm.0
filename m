Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C87379974
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785754453; cv=none; b=d8TZF3JuSN4qX6Z65Jj8+sbAB5vnsOqLVBh5Pccee3VFs5+khYIKe1yGVOVqrEkRx4bREtXDvaRM+WjhR3pbayG7awawkaxVDRR+9TMVm1jaoArMpZ+MTxWuO8YkeMcvOX34x9JEnRyJ1sJUAMlEl7Pem/wg35wxBCHlRyFaH5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785754453; c=relaxed/simple;
	bh=xMq2WOEN+zd77HTmxVmSeQHoLDN52GWaAU287ZTlEhA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qeBi6GZfWZabT5getTdpCfTr0uHt55q7Jnvsqpgkw4FyWpTdtkilz0xr41yE3cXPEly7ZrIYTl3gh8FT2MnItgsebd+es7gfpt4GBkQz56lNMKKiYpQLdCFi6ivhKK9dgo6vtVbRJI1wttOZOk5N3CQiXj25/np/VL8IHbY/7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yj21qfMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yj21qfMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ACE1F000E9;
	Mon,  3 Aug 2026 10:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785754452;
	bh=vyEZFStJ8EMM6La9BF89UCGPyOj4lkogcDlrCekIs88=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yj21qfMfe7ghCbchKoKoZMLam6ck9mkLqB2ABNXymUp3mR5u5nnoSYGCqHJFRydoP
	 qKDQBWfdxryHtGs+mpS14Yo/UoEKPLo1UeLoSJB4WLCLFOWUtby7Rfz2RYV+xfyC8e
	 FhMnQW5prdEK8eFbkYjgzTIFbRKHGH4/ZxJtgicjAxeGDs2Fcj6XICL1yCrp9BCWRx
	 CEl0b5sCuC3P5YRtFWrCmazVU0zGAnuXzufEPr2qaQ9o2mc4aUZ5GUBs9Ze/fF+2cd
	 ij2PHldc9i0XEp+k5pGsMk+t+1hgK58VxpzGLPgVikV1B7b5l2NMtIEYubuLrhev8x
	 MpL2HYYVObcuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/20] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260803100904.3563942-19-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-19-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:54:11 +0000
Message-Id: <20260803105411.B6ACE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] Time-of-Check to Time-of-Use (TOCTOU) race in `__pkvm_pgtable_=
stage2_split` due to missing MMU notifier retry protocol.
- [Critical] Using `pin_user_pages()` introduces a `FOLL_PIN` counting bias=
 that causes massive memory leaks during KVM teardown.
- [High] Memory cgroup accounting bypass when allocating spare `pkvm_mappin=
g` structures.
- [Medium] Splitting read-only guest mappings is incorrectly forbidden by r=
equiring write access.
- [Low] `__pkvm_pgtable_stage2_split()` mixes `goto`-based error handling w=
ith scope-based `__free(kfree)` cleanup.
--

--- Patch [18]: [PATCH 18/20] KVM: arm64: Add PKVM_HYP_REQ_SPLIT ---
commit eb20478193ba08806cd19923ba4b65163db37c40
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add PKVM_HYP_REQ_SPLIT

This commit introduces a new pKVM hypervisor request, PKVM_HYP_REQ_SPLIT,
enabling the hypervisor to request the host to split stage-2 huge mappings.
This ensures synchronous splitting of both the guest stage-2 page tables
and the host's pkvm_mappings red-black tree, preventing concurrent
teardowns from observing inconsistent page sizes.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 379bdc2b258a6..089b77cf2f6a9 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c

[ ... ]

> +static int pkvm_mapping_alloc_spares(struct list_head *head, u64 nr_spar=
es)
> +{
> +	struct pkvm_mapping *m;
> +
> +	while (nr_spares--) {
> +		m =3D kzalloc_obj(*m);

[Severity: High]
Does this bypass memory cgroup limits?

This allocation uses kzalloc_obj() which defaults to GFP_KERNEL without
the __GFP_ACCOUNT flag.

Because each PMD split allocates 511 structures, a guest could repeatedly
trigger splits across its memory footprint.

Can this allow the guest to consume large amounts of uncharged host memory,
potentially leading to host memory exhaustion?

> +		if (!m) {
> +			pkvm_mapping_free_spares(head);
> +			return -ENOMEM;
> +		}
> +
> +		list_add(&m->list, head);
> +	}
> +
> +	return 0;
> +}

[ ... ]

> +static int __pkvm_pgtable_stage2_split(struct kvm_vcpu *vcpu, phys_addr_=
t ipa, u64 size)
> +{
> +	struct kvm_hyp_memcache *mc =3D &vcpu->arch.pkvm_memcache;
> +	struct kvm_pgtable *pgt =3D vcpu->arch.hw_mmu->pgt;
> +	struct page **pages __free(kfree) =3D NULL;

[Severity: Low]
Is it safe to mix scope-based cleanup with goto error handling in this
function?

The pages array is declared with __free(kfree), but the function uses goto
labels like goto unlock_srcu and goto unlock_mmu for unwinding locks and
freeing the spares list.

The kernel cleanup guidelines note that functions should use either
scope-based cleanup for all resources or goto labels for all resources,
but not mix them, as it creates confusing ownership semantics.

> +	struct mm_struct *mm =3D current->mm;
> +	struct kvm_memory_slot *memslot;

[ ... ]

> +	idx =3D srcu_read_lock(&kvm->srcu);
> +	memslot =3D gfn_to_memslot(kvm, gfn);
> +	hva =3D gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> +	if (kvm_is_error_hva(hva) || !writable) {

[Severity: Medium]
Should read-only mappings be allowed to split?

This explicitly checks that the memslot is writable and fails with -EFAULT
otherwise. It also passes FOLL_WRITE to pin_user_pages() later on.

However, splitting a huge page block into smaller PTEs changes the mapping
granularity without modifying the underlying memory contents.

Does requiring write access prevent the hypervisor from splitting read-only
stage-2 block mappings, such as guest ROMs?

> +		ret =3D -EFAULT;
> +		goto unlock_srcu;
> +	}
> +
> +	mmap_read_lock(mm);
> +	ret =3D pin_user_pages(hva, nr_pages, FOLL_HWPOISON | FOLL_LONGTERM | F=
OLL_WRITE, pages);

[Severity: Critical]
Does using pin_user_pages() here cause a permanent memory leak during KVM
teardown?

Calling pin_user_pages() adds a GUP_PIN_COUNTING_BIAS to the page refcount.
However, normal KVM stage-2 teardown drops references using standard
put_page() semantics which only subtracts one from the refcount.

When the VM is destroyed, will these tail pages retain phantom references
and be permanently leaked?

> +	mmap_read_unlock(mm);
> +	if (ret !=3D nr_pages) {
> +		if (ret > 0)
> +			unpin_user_pages(pages, ret);
> +		ret =3D -EFAULT;
> +		goto unlock_srcu;
> +	}
> +
> +	write_lock(&kvm->mmu_lock);
> +	mapping =3D pkvm_mapping_iter_first(&pgt->pkvm_mappings, ipa, ipa + siz=
e - 1);

[Severity: Critical]
Is there a Time-of-Check to Time-of-Use race here since the MMU
notifier retry protocol is missing?

The resolution of the HVA to PFNs via pin_user_pages() happens outside
kvm->mmu_lock. A concurrent host MMU invalidation could unmap the region
and remove the pkvm_mapping, and a subsequent guest fault could establish
a new huge page mapping at the same IPA.

When this thread acquires kvm->mmu_lock, it finds the new mapping in the
tree and proceeds to split it using the PFNs derived from the old mapping.

Without capturing kvm->mmu_invalidate_seq before GUP and checking
mmu_invalidate_retry() under the lock, can this lead to a refcount
underflow on the new huge page and a permanent leak of the old pages?

> +	if (!pkvm_mapping_can_split(mapping)) {
> +		ret =3D -EINVAL;
> +		goto unlock_mmu;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D18
