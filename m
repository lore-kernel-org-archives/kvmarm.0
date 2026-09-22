Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC50559CA3
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083757; cv=none; b=sv2exIHDeWqp3edR0hgj2E3vQpau/At2KiNbYH+GhEgEErmcunUfsU7ndam2SxBcAxTEDs2hKKtYJI5xdak0C4XYaeracVXJmljr3cHfPjW4vp2TnY2YZSkQY5r2YxZag8RKjkJtlW82HPBHvJZIx4w6eH4MfIZNt3gTtkh5G1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083757; c=relaxed/simple;
	bh=U+f9DyRXcXBl4zPW4kU9oUB7jWA3uqxFRVkjhW7LfAU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SLeY+1jZ6VFky/tw4c2IjFLJVNjKRcaRj5+x2xppzu8MnDPUL/qtrCb5ZThozrlQZLSd/xgNSQVoiu9utp9i46qQW43Fm5HerpY5l7i6zXhp//HH6ThxvEKMdzB1SVmf2dntqbxfTx6T2XfWNZ3f7Nbd4moWZq1c2ztsb8bmcnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msuI1gD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msuI1gD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911161F000FF;
	Tue, 22 Sep 2026 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083755;
	bh=lc/ZeGw+gj/lvCfF539hkE+Ua7Q8DBSh+HA8B+ZkoDg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=msuI1gD+lXCSZgGj8NTUsz1A/7rEmzOdc4KyG0PKRdJRE8sR0sxfA2Akia5WqPgBA
	 6s+Dceg0OK4GJUuy0yCyd+Yxdyyb1vZSWYOCmZHWxO1e5LbHkg9VwNtqDq48CvSoEa
	 Nj9pQs0FlTWXiCQwe8Rq8qJ9yA8aTQlgOpR5jgbxfLpkBKSqiJdwNQitPQ4fstpts5
	 68EolAVvPHwvqx5NVMHQUCZRcbOTdxtvV8y2wn4Et4JIUYWVBBUobPVjC43m9U2sSl
	 2w5fsjbXNW0bO8UpqnBoOfqBaqbpwGI0FjhfQiK8XFfwf1Q9sqtGENtTZvWaY/Zo8S
	 OukRV5XqeNI+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 01/25] KVM: arm64: Donate MMIO to the hypervisor
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260922131259.2975334-2-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-2-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:29:15 +0000
Message-Id: <20260922132915.911161F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: arm64: resource leak and memory attribute mismatch on MMIO =
donation error path
--

commit 96c49002ec46fcffdec0cb75c633309cd148cad6
Author: Mostafa Saleh <smostafa@google.com>

KVM: arm64: Donate MMIO to the hypervisor

This commit introduces functions to donate MMIO memory between the host and
hypervisor. It enables IOMMU hypervisor drivers to protect and access the
MMIO of IOMMUs by mapping the MMIO range in the hypervisor's private range
and unmapping it from the host stage-2.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c

[ ... ]

> +int __pkvm_host_donate_hyp_mmio(u64 pfn, u64 nr_pages, unsigned long *ha=
ddr)
> +{
> +	u64 phys =3D hyp_pfn_to_phys(pfn);
> +	u64 size =3D PAGE_SIZE * nr_pages;
> +	kvm_pte_t pte;
> +	u64 offset;
> +	int ret;
> +
> +	/* Only before de-privilege. */
> +	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> +		return -EPERM;
> +
> +	if (!pfn_range_is_valid(pfn, nr_pages))
> +		return -EINVAL;
> +
> +	ret =3D __pkvm_create_private_mapping(phys, size, PAGE_HYP_DEVICE, hadd=
r);
> +	if (ret)
> +		return ret;
> +
> +	host_lock_component();
> +	for (offset =3D 0; offset < size; offset +=3D PAGE_SIZE) {
> +		if (addr_is_memory(phys + offset)) {
> +			ret =3D -EINVAL;
> +			goto unlock;
> +		}
> +		ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, phys + offset, &pte, NULL);
> +		if (ret)
> +			goto unlock;
> +		if (pte && !kvm_pte_valid(pte)) {
> +			ret =3D -EPERM;
> +			goto unlock;
> +		}
> +	}

[Severity: Medium]
Does this leak the hypervisor private mapping and leave a mismatched memory
attribute if validation fails?

In __pkvm_host_donate_hyp_mmio(), the PAGE_HYP_DEVICE mapping is created
before the physical address is validated against addr_is_memory() or the
page tables. If the validation fails, the function exits via the unlock
label and returns an error without rolling back the private mapping.

If the host firmware provides an invalid physical address (like a RAM
address) for MMIO donation, this leaves the virtual address space leaked
in EL2. Additionally, keeping RAM mapped as PAGE_HYP_DEVICE creates a
mismatched memory attribute (Device vs Normal) for RAM in the hypervisor
translation regime, which can cause unpredictable behavior.

> +	/*
> +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non=
 zero PTEs.
> +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would c=
all
> +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid p=
tes (counted).
> +	 * - other MMIO donation: Would fail as we check that the PTE is valid =
or empty.
> +	 */
> +	ret =3D host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> +			      phys, size, &host_s2_pool,
> +			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
> +			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
> +unlock:
> +	host_unlock_component();
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D1
