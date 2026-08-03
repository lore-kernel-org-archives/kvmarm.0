Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEC73C819C
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 11:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785755061; cv=none; b=PQbaBkD53+KYRJQzF7r2xC63Pkjo1eqLeViOUG2HL+xhZAuzJsj4QOQ0G6Y8ugSQbHUkcUxk9wSUCM5Rs1pLIdVT1zBRSz5P5w5ysKwMqIv6Cxb6UaT88quu81EyQbu9yZLXxPruzHJIXaKdhZYzk2j9ps6fEdtOELNqgrUil7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785755061; c=relaxed/simple;
	bh=uiWmVUSzzmitCmc+Uwp6g6q2qq1PgazLAT2RqtGc2II=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LruJgdHzgufElx4jUVZkCP8V/EdLp9SvMbab2rRoMBejfhVAza85MY2FNebPmPVx/6xiuwuMjr9zjvfm73ovgD4wDVXRmNDIJf8zcTfYoAjHhQzG0vMHAq/Pa4DsAU+QpUHggscKnaa5xDnarNQbZMxJi1mwMicB5h7R7tg+8Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=md9UL9As; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="md9UL9As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCC81F000E9;
	Mon,  3 Aug 2026 11:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755051;
	bh=WvVyPW1iXZK1nEkukCQqK6V5bva5AlnkCi3n6vrq6G8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=md9UL9As3CS10JP2GKQLjlirsFZfZiHOcyt+Kh4pmfG3WJu4lNRvnbmo6MJZjXQoS
	 EuPeqWrMhkVMIXywbXwnczTYhXnP4/xw/EgH8W5qerfmE8bg3m/wUYvAjWr6Dr8R5j
	 L2KDyrefP4gShr2vjcAPIjcyzVA2j6FpLYJBTL+BxxsoDbH2G5/KFqd3d+83gTOamv
	 pKJZ8IRL/vk4syoxSmKuLTSf9NH8jPoPn4Y19WwHGJo/gc86c1OgTJVyOsvnBV5KIO
	 jLYL5cyGwILjt2aM/KXZcTrrIW4JVyMAT4zhAtof3EbYg7/llBNyt1Nw5JLozLsehn
	 aD0c9HfcPNrfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 20/20] KVM: arm64: Stage-2 huge mappings for protected
 VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260803100904.3563942-21-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-21-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 11:04:11 +0000
Message-Id: <20260803110411.9FCC81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] A TOCTOU race and insufficient `folio_test_large()` validation=
 in `pkvm_mem_abort()` allows malicious host userspace to trigger a DoS or =
map up to 2MB of arbitrary unowned physical memory into the guest.
- [High] Missing verification of pinned PFNs in `__pkvm_pgtable_stage2_spli=
t()` causes a THP refcount underflow (kernel panic) and a memory leak when =
raced with host userspace unmapping.
- [High] Unconditional suppression of `-EAGAIN` in `pkvm_mem_abort()` cause=
s a deterministic livelock (infinite fault loop) when a PMD-sized mapping o=
verlaps with a pre-existing 4K mapping.
- [High] Missing validation of the stage-2 block granule against the guest'=
s requested fault size in `pkvm_mem_abort()` silently breaks pKVM isolation.
--

--- Patch [20]: [PATCH 20/20] KVM: arm64: Stage-2 huge mappings for protect=
ed VMs ---
commit 66c372ae561bfc5bac1a23e79526b597c8fa02fd
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Stage-2 huge mappings for protected VMs

Enable PMD-sized stage-2 block mappings for protected VMs. This is
possible whenever the stage-1 mapping allows it, that is if it itself
backed by THPs.

When a THP is found, an entire PMD_SIZE mapping is donated to the guest.
This mapping can only be broken down via the HVC
__pkvm_host_split_guest() which the hypervisor can request with
PKVM_HYP_REQ_SPLIT.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c63..46820240d2337 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -1755,25 +1737,59 @@ static int pkvm_mem_abort(const struct kvm_s2_fau=
lt_desc *s2fd)
>  		goto unpin;
>  	}
> =20
> +	pfn =3D page_to_pfn(page);
> +	gfn =3D gpa_to_gfn(s2fd->fault_ipa);
> +
> +	page_size =3D transparent_hugepage_adjust(kvm, s2fd->memslot, s2fd->hva=
, &pfn, &gfn);

[Severity: High]
Does this skip validating the stage-2 block granule against the guest's
requested fault size?

Deriving the block size solely from the host's THP state via
transparent_hugepage_adjust() without validating it against the fault
granule can install a larger block mapping than the guest requested. Is
there a missing check here to ensure the resulting page_size matches the
expected fault granule before donating host memory?

> +	if (page_size < 0) {
> +		ret =3D page_size;
> +		goto unpin;
> +	} else if (page_size =3D=3D PMD_SIZE) {
> +		if (WARN_ON(!folio_test_large(page_folio(page)))) {
> +			ret =3D -EINVAL;
> +			goto unpin;
> +		}
> +	}

[Severity: Critical]
Is this folio_test_large() check sufficient to prevent a TOCTOU race
and unintended memory donation?

Since mmap_read_lock() is dropped before this check, a malicious host
userspace could unmap the faulting page and remap it as a PMD-mapped THP.
If the initially pinned page was a smaller mTHP (like a 64KB folio),
folio_test_large() will return true, bypassing the WARN_ON.

transparent_hugepage_adjust() aligns the 64KB folio's PFN down to a PMD
boundary, which is then passed to pkvm_pgtable_stage2_map(), granting
the guest RWX access to 2MB of unrelated physical memory. Could this
be prevented by stricter validation of the page size rather than just
checking if it is large?

> +
> +	ret =3D account_locked_vm(mm, page_size / PAGE_SIZE, true);
> +	if (ret)
> +		goto unpin;
> +
>  	write_lock(&kvm->mmu_lock);
> -	ret =3D pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
> -				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
> +	ret =3D pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), page_size,
> +				      __pfn_to_phys(pfn), KVM_PGTABLE_PROT_RWX,
>  				      hyp_memcache, 0);
>  	write_unlock(&kvm->mmu_lock);
>  	if (ret) {
>  		if (ret =3D=3D -EAGAIN)
>  			ret =3D 0;
> -		goto unpin;
> +		goto dec_account;
>  	}

[Severity: High]
Will masking -EAGAIN here cause a deterministic livelock?

If a PMD-sized mapping overlaps with a pre-existing 4K mapping,
pkvm_pgtable_stage2_map() returns -EAGAIN. Masking this error and returning
success without installing a mapping causes the guest to re-execute the
instruction and hit the exact same fault path indefinitely. Should this
fall back to a PAGE_SIZE mapping instead of suppressing the error?

[ ... ]
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 089b77cf2f6a9..0b591c44998d0 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -541,10 +539,8 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt,=
 u64 addr, u64 size,
>  			return ret ? -EFAULT : -EAGAIN;
>  		}
> =20
> -		ret =3D kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn, 1);
> +		ret =3D kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn, size / P=
AGE_SIZE);
>  	} else {

[Severity: High]
Does __pkvm_pgtable_stage2_split() properly verify pinned PFNs when splitti=
ng
a THP?

When the hypervisor requests a split, __pkvm_pgtable_stage2_split() calls
pin_user_pages() to pin the remaining pages. However, pkvm_mapping_split()
ignores the returned array and populates the tracking mappings by
sequentially incrementing the old THP's base PFN.

If the host userspace evicts the original THP before the split,
pin_user_pages() pins new anonymous pages that are never recorded and will
leak. Later, __pkvm_pgtable_stage2_reclaim() will call
unpin_user_pages_dirty_lock() on the old THP's subpages 512 times,
causing a refcount underflow.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D20
