Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC0E522F12
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866201; cv=none; b=YgVA7rgnOTVksw6GMHkpttK8DTbkn9MZ7sdQPv992keO7yRIZ80fwc1gwPe7KdRTSA4/GFuz54xAOcniKb5Ldk6llynZ9zl8Sw7NMTXMpMTuor6LLWP17R8T6xz74pLg/MuiytuQZ4P1nDpzCiFPfy1zTTZBo/mH1eFaEN6O1AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866201; c=relaxed/simple;
	bh=SD71j3foB5LldHybFOmNvM5x2P6Wv5EnuAy52pNcgkE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dl1wCjUmGRFrxln2lehAH9cHax+5hF7dBErY93bcnDq+DR4r9yHj/CnTNnyFbLnFIH8e+t35EMAW0mHcnPBftYuuqk7tsqos3E8nuZ1EZX5scQK9KKsnZ+j9LYhDOq7tGM2xnZJlqPLb3xKc7So8jDl3CkXPaa8Jvl9kWM/XTnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aF5VGKf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aF5VGKf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7931F00899;
	Thu,  1 Oct 2026 14:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790866199;
	bh=bYtwHGNRzHgLky+Y5qOBEgVaiyzRcr81Y4IuCrVMRlI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aF5VGKf6HFWI9vu4869M3aPbyWZf3bWnpyW9PfKOjOsNFIMI1Qg2jhghnY2S1Ie1I
	 zH+iQ4/Y5gC0o3UV6OIPdeaGviulgnNv8rVSJ1Ep9OGRFtvBLGI5V3gLuJr4sYfrzh
	 DckO0lWClWJy1BRxqgPyC2LJS3sD4MlfttLbr3aTbUSqw+GhFMbVV+ngzNyIBVsI4s
	 EhvjOQpZcFGJddcxhwqaLPs0Ocdfd50BmKx8rJ5HtD+GQEMEgp65FWdpFiWTGoaj8s
	 B4waqlIJ4fbbH8eJzJRolJAQop5FnpY0kufV+dW79NZDb7zVsZ2vnOSPgSB/e8nwuO
	 QybEcmsTpBq4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/18] KVM: arm64: Add pkvm_map_private_va_range
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20261001142849.3367614-4-vdonnefort@google.com>
References: <20261001142849.3367614-1-vdonnefort@google.com>
 <20261001142849.3367614-4-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 14:49:58 +0000
Message-Id: <20261001144959.1E7931F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: page table memory leak on error path in pkvm_map_private_va_ra=
nge()
--

commit a41a8ab9fe9c147efcc9aefa4890f827e8b117a6
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add pkvm_map_private_va_range

In preparation for the pKVM heap allocator, introduce
pkvm_map_private_va_range() to map a physical range into the pKVM
private range.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 9ab7f613fa360..4a22fb74182be 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
[ ... ]
> @@ -90,6 +91,41 @@ int pkvm_alloc_private_va_range(size_t size, unsigned =
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
> + * The hypervisor VA @haddr must have been first allocated with
> + * pkvm_alloc_private_va_range(). The created mapping can later be remov=
ed
> + * with pkvm_remove_mappings().
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int pkvm_map_private_va_range(void *haddr, phys_addr_t phys, size_t size)
> +{
> +	unsigned long addr =3D (unsigned long)haddr;
> +	int ret;
> +
> +	if (!PAGE_ALIGNED(addr | phys | size))
> +		return -EINVAL;
> +
> +	guard(hyp_spinlock)(&pkvm_pgd_lock);
> +
> +	if (addr < __io_map_base || addr >=3D __io_map_next)
> +		return -EINVAL;
> +
> +	if (size > __io_map_next - addr)
> +		return -EINVAL;
> +
> +	ret =3D kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, PAGE_HYP);
> +	if (ret)
> +		kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, size);
[Severity: High]
Does this error path leak hypervisor page table memory?

If kvm_pgtable_hyp_map() fails midway (for instance, due to an out-of-memory
condition), pkvm_map_private_va_range() calls kvm_pgtable_hyp_unmap() to ro=
ll
back the partial mapping. The unmap walker will then encounter an invalid P=
TE
in the unmapped portion:

arch/arm64/kvm/hyp/pgtable.c:hyp_unmap_walker() {
    ...
    if (!kvm_pte_valid(ctx->old))
        return -EINVAL;
    ...
}

This causes the walker to abort. When the walk aborts, __kvm_pgtable_visit()
skips the KVM_PGTABLE_WALK_TABLE_POST callbacks for all parent tables:

arch/arm64/kvm/hyp/pgtable.c:__kvm_pgtable_visit() {
    ...
    if (!kvm_pgtable_walk_continue(data->walker, ret))
        goto out;

    if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
        ret =3D kvm_pgtable_visitor_cb(data, &ctx, ...);
    ...
}

Because the post-table callback is skipped, any intermediate page tables
allocated during the failed map are not freed. Since the hypervisor uses a
fixed memory pool, if an untrusted host can push the allocator to its limit
to trigger this error path, this leak could permanently deplete EL2 memory =
and
prevent further VM creation.

> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001142849.3367=
614-1-vdonnefort@google.com?part=3D3
