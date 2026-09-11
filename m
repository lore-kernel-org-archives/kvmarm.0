Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9634B19F
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789136440; cv=none; b=GZU8YwasyWJJbGJ4eDDUT0CPV92zYtZAtwv0bby2JEjOhudaq3pVX4bFsvLOOrVq4BmUPQEAWXymtwXTEd/zG0WZpu5yy9smXVvSZU0Pv2sGJvsk7LFVTt6oEqDFDmZvYjmvhyjfvAeEov5IFS60sx8R6hVNnYRYx9MFTphnDAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789136440; c=relaxed/simple;
	bh=2K1fPocGHWHp5vtFrlxnEctWcMxM2+a3F67aLZjp6C8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n3V1rVPcHg6Y1gCjEP+6KNFCv4ewEuNcG6lR+NXgEFvd+EQqy7fzz6auw0muRN9M76mfHbxRxm4T4CiYN9xiVfr5viqmy1AeiPmzginC7Jp5gD1JIMdAVN5NCIAi74ucF2+BMn10hhzSPR9pdfUkIR6APxYqkBgZhMB3D5IYYAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dAG5jyIP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAG5jyIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F1C1F000FF;
	Fri, 11 Sep 2026 14:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789136438;
	bh=arD/Mle/6Y+6E60MfF7mUA8FjfzP9w2D9joks5WQe6A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dAG5jyIPAPqDB7ToYnRa2GETr7o8uwNwZisaErWrDakUaUyn43/JmboT21pBPnNxm
	 dZ093OfTn6XuWgIWsSWSZIO+difdfvHTDxaLp08oz3QUVxTTWC4md9ZCU6YW7OzLhB
	 X7gmpSxkOgBosaH8JJ2XPGvD18MyKK/4HYvHmcIfUM4iH5aojNeQS+EjYOLf+uXLyl
	 c3t5Pt6oh+KZiTzBqsTUcmWUP2LJfrM0REectYu0hmJdRPoRUi4lyCVeOOCx714v6L
	 Mba03HUWmbuc/B1SinIMWl28jU2L2ftsf2umn7ZBtPI3CtJz9Hw3tWAQ8iv1ePlFQP
	 twISL+Cb+6hLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/22] KVM: arm64: Stage-2 huge mappings for
 protected VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260911135053.146435-23-vdonnefort@google.com>
References: <20260911135053.146435-1-vdonnefort@google.com>
 <20260911135053.146435-23-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 14:20:37 +0000
Message-Id: <20260911142038.56F1C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] pkvm_pin_user_pages() returns 0 on -EHWPOISON without initiali=
zing output parameters, leading to undefined behavior and potential system =
compromise in pkvm_mem_abort().
- [Medium] Unprivileged host userspace can trigger a WARN_ON_ONCE in pkvm_p=
in_user_pages() via TOCTOU, leading to a host-side denial of service.
--

commit 3d6ed4192aebc28eca33a0d8ed20d5a587ffa2cd
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Stage-2 huge mappings for protected VMs

This commit enables PMD-sized stage-2 block mappings for protected VMs when
the stage-1 mapping is backed by THPs. An entire PMD_SIZE mapping is donated
to the guest upon finding a THP.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4af..218df096c72ed 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> +static int pkvm_pin_user_pages(const struct kvm_s2_fault_desc *s2fd, str=
uct page **__page,
> +			       unsigned long *__size, kvm_pfn_t *__pfn, gfn_t *__gfn)
>  {
>  	unsigned int flags =3D FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
>  	struct kvm_vcpu *vcpu =3D s2fd->vcpu;
>  	struct mm_struct *mm =3D current->mm;
>  	struct kvm *kvm =3D vcpu->kvm;
>  	struct page *page;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +	long ret;
> =20
> -	mmap_read_lock(mm);
> +	guard(mmap_read_lock)(mm);
> =20
>  	ret =3D pin_user_pages(s2fd->hva, 1, flags, &page);
> -	mmap_read_unlock(mm);
> -
>  	if (ret =3D=3D -EHWPOISON) {
>  		kvm_send_hwpoison_signal(s2fd->hva, PAGE_SHIFT);
> -		ret =3D 0;
> -		goto dec_account;
> +		return 0;

[Severity: Critical]
If pin_user_pages() returns -EHWPOISON, does this return 0 without
initializing the output parameters (__page, __size, __pfn, __gfn)?

>  	} else if (ret !=3D 1) {
> -		ret =3D -EFAULT;
> -		goto dec_account;
> +		return -EFAULT;
>  	} else if (!folio_test_swapbacked(page_folio(page))) {
[ ... ]
> -		ret =3D -EIO;
> -		goto unpin;
> +		unpin_user_page(page);
> +		return -EIO;
> +	}
> +
> +	pfn =3D page_to_pfn(page);
> +	gfn =3D gpa_to_gfn(s2fd->fault_ipa);
> +
> +	ret =3D transparent_hugepage_adjust(kvm, s2fd->memslot, s2fd->hva, &pfn=
, &gfn);
> +	if (ret < 0) {
> +		unpin_user_page(page);
> +		return ret;
> +	} else if (ret =3D=3D PMD_SIZE && WARN_ON_ONCE(folio_size(page_folio(pa=
ge)) < PMD_SIZE)) {
> +		unpin_user_page(page);
> +		return -EINVAL;
>  	}

[Severity: Medium]
Could a concurrent page table modification trigger this warning? Since
mmap_read_lock() is held here, if a concurrent thread holding the per-VMA
lock (like madvise MADV_DONTNEED) zaps the page table and faults in a
PMD-mapped THP at the same address, transparent_hugepage_adjust() might
observe the new PMD mapping while the initially pinned page remains 4K.

As this warning is reachable from unprivileged host userspace, could this
be used for a host-side denial of service?

> +
> +	*__page =3D page;
> +	*__size =3D ret;
> +	*__pfn =3D pfn;
> +	*__gfn =3D gfn;
> +
> +	return 0;
> +}
> +
> +static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> +{
> +	struct kvm_vcpu *vcpu =3D s2fd->vcpu;
> +	struct kvm_pgtable *pgt =3D vcpu->arch.hw_mmu->pgt;
> +	struct mm_struct *mm =3D current->mm;
> +	struct kvm *kvm =3D vcpu->kvm;
> +	unsigned long size;
> +	void *hyp_memcache;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +	int ret;
> +
> +	hyp_memcache =3D get_mmu_memcache(vcpu);
> +	ret =3D topup_mmu_memcache(vcpu, hyp_memcache);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	ret =3D pkvm_pin_user_pages(s2fd, &page, &size, &pfn, &gfn);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D account_locked_vm(mm, size / PAGE_SIZE, true);

[Severity: Critical]
When pkvm_pin_user_pages() encounters a poisoned page, it returns 0. Will
this caller then proceed to use the uninitialized size, page, pfn, and gfn
variables?

It looks like this could result in mapping arbitrary, uninitialized
physical memory frames into the guest's stage-2 page tables. Furthermore,
if the mapping fails, the error path appears to call unpin_user_page()
with a garbage page pointer, which might cause a host kernel panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911135053.1464=
35-1-vdonnefort@google.com?part=3D22
