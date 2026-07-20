Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20675446049
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568576; cv=none; b=jVasOz6PZAdpZV3rRnWvQugum6B+dry6pZZVO28ostAgw0bRyQRmqUMT1b4mJ5jf2e5vuXd7UIjJNAn69Km5J79pTDdtTnjLs/vMFxxlKw+O8IGon7E74BCwjXJeOUhUeNAlVLHmhQZ6nclNKFb5cdoN9CHs1zCP4IF63eG62o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568576; c=relaxed/simple;
	bh=QH2OqkDdoMh1f0V6QtJoVxuIEuMhmyuhAjUqJmH0FnE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oyC24do7aWY+YIAwui/fgEHFSb5b8AfXAhc7I5dke+q9dDRASO2gb9wElWbt0QsF7699kS4NV1mi72JSIkKiz2aekHaFn7SWBARLQBdnPJn7Vd+ZVQlC9ljrj+jEfISky2EyD8EIDfn7TAR6nKBFDGk0sUXGkJNbc2Kj/1dawGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUaD11Fa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUaD11Fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E481F00A3A;
	Mon, 20 Jul 2026 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568565;
	bh=1yX/mPuCzziFNlU3OWvd/HxON/FIH3pTocG55rzn8C0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hUaD11Fa0c5Vrz5haMkuIomKOgDsQU+W9v1j9WUTiPFzf1w97rJ81OcSnyrfIqzkU
	 WHJwobzRsk/iyCjGkIr7pRC8G5oJIirPWjpCAFSHe9Pun4nkxLFY71B7m1ro93Sgm5
	 Bnq29pk0nUb+ql+8WZi61dYSTfZ9CUPbrpRYLMvOOgNQC+LRYc5JJpzLC0LbJi0fc/
	 N4//eUhMljuwifQio1yLVloEr+K6ZGaYaeCWUU46TJxtnGIZUkpGakFEscIrn4G5kf
	 +CmFZ4+Y8iwrICpb2qrJuE+KpeuncRDjfq2X95CPSsVA7if5RyWjuNIBNiTVnSr3k9
	 3C+cBHf2p9azA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/17] KVM: arm64: Add pkvm_map_private_va_range
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260720171513.1415357-4-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-4-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:29:24 +0000
Message-Id: <20260720172925.A9E481F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] `pkvm_map_private_va_range` does not roll back partially created m=
appings if `kvm_pgtable_hyp_map` fails, causing Use-After-Free and isolatio=
n breaches.
- [Medium] Integer overflow in the bounds check of `pkvm_map_private_va_ran=
ge` allows out-of-bounds requests to silently bypass validation.
--

--- Patch [3]: [PATCH v3 03/17] KVM: arm64: Add pkvm_map_private_va_range -=
--
commit c11c23d0f630b7a7c96e01ffbcb3dd1f881985c2
Author: Vincent Donnefort <vdonnefort@google.com>
Subject: KVM: arm64: Add pkvm_map_private_va_range

This commit introduces pkvm_map_private_va_range() to map a physical range
into the pKVM private VA range. This is in preparation for the upcoming pKVM
heap allocator.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 5cd2f1fe51e4c..20e4445dd57b7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c

[ ... ]

> @@ -90,6 +91,31 @@ int pkvm_alloc_private_va_range(size_t size, unsigned =
long *haddr)
>  	return ret;
>  }
> =20
> +/**
> + * pkvm_map_private_va_range() - Map a physical range into the private V=
A range
> + * @haddr:	The virtual address in the private range.
> + * @phys:	The physical address to map.
> + * @size:	The size of the range to map.
> + *
> + * The hypervisor VA @haddr must have been first allocated with pkvm_all=
oc_private_va_range()
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int pkvm_map_private_va_range(void *haddr, phys_addr_t phys, size_t size)
> +{
> +	unsigned long addr =3D (unsigned long)haddr;
> +
> +	if (!PAGE_ALIGNED(addr | phys | size))
> +		return -EINVAL;
> +
> +	guard(hyp_spinlock)(&pkvm_pgd_lock);
> +
> +	if (addr < __hyp_private_va_start || addr + size > __io_map_base)
> +		return -EINVAL;

[Severity: Medium]
Could a very large size cause an integer overflow here? If size is large
enough, addr + size could wrap around to a small positive value. Since
__io_map_base is in the upper half of the address space, the wrapped sum
might be less than __io_map_base, bypassing this validation.

The subsequent kvm_pgtable_hyp_map() might then calculate a wrapped end
boundary, resulting in a zero-iteration loop that returns 0 (success)
without actually mapping anything. This could lead to a hypervisor panic
when the caller attempts to access the unmapped memory.

> +
> +	return kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, PAGE_HYP);

[Severity: High]
Does this error path need to roll back partially created mappings?

If kvm_pgtable_hyp_map() fails midway, such as returning -ENOMEM when it
cannot allocate an intermediate page table, it appears to abort without
unmapping the leaf PTEs it has already installed.

Because this error is returned directly to the caller without a rollback,
the underlying physical pages might be freed back to the pool while
remaining mapped and writable in the EL2 page table.

Could this lead to use-after-free and isolation breaches when these physical
pages are reallocated?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D3
