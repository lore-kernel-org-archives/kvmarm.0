Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2249433F589
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083441; cv=none; b=ccfFgzvTNQmwSHesRRy9PfqRgUQxLmXT4C7MhbZup+90IAsZwytlp45p4pw3PQwu6bKL/h69Sp/DIE9O7friLB/frO+88hpRaMHDuJxH5eufmdqBQgaofY+v1oTZZWwh2/+YqbeNv56Z9UQhwsEkQfviYo0ZGpVCEKZcnoa1Uf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083441; c=relaxed/simple;
	bh=1qMhNDsnsFoKP9Hmc3ZGN1uETxAX5ykpF7Ye4fc+1hM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iQ8xrnXsw9OPlNncoBNuuHGywCzfH1WETKeGtFNZB0uZpUJ0nNcG4bBwVnfsYXVmmE6ok5te29owaINnE3DMrKLvajVMywOtWENc49a0Je4TUuL6UGQUfqdqtFJs5uJ+V2OLlALt97baQgMcK3JUqmja/EvI+4ULSHWSLC2I0HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kH7NXPbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kH7NXPbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0381F000FF;
	Tue, 22 Sep 2026 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083440;
	bh=2dvAX2nPj76IIFwGlRHUpDP1fDVgaJr6Pip866xCXAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kH7NXPbwM9ZX/mz0FzJNTVaaA0MX96fxfu+Yfsz0RHWF2WVcNNWHOigF6DjEgdtSv
	 scN7J//zW0Bzs9OddD7Uu3ZHm/N4xzr0vD5biYZgQJtC7Jy3YCuxXg6dHU93tkUbHo
	 YCT3vjRpSP5tmgSZPIOKKIYbhXFF2DA5zuOgP+7An/LVsZd9QAKj6AxN3qmHrKeCnV
	 Ii/Hz8Cv13NS1cMDmhVEO/YBeg0bFqfYWjDl5FGdJFoKuwSO2kf3YP51wnEGEtL5Ba
	 ObkQywH6lBHdEG3NpQXS8m/66ClHVxpM2wSmjba5spQgiLrxLRhLG1cONZiLaRW0Pt
	 N1SenOp6H0wEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 07/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260922131259.2975334-8-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-8-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:23:59 +0000
Message-Id: <20260922132359.BB0381F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: pkvm: guest-triggerable hyp panic due to WARN_ON misuse
--

commit 68e26689446b14f6e5c91a79e4493c62586f9fb4
Author: Mostafa Saleh <smostafa@google.com>
Subject: KVM: arm64: iommu: Shadow host stage-2 page table

This commit creates a page-table for the IOMMU that shadows the host CPU
stage-2 to establish DMA isolation. An initial snapshot is created after
the driver init, and on permission changes, a callback updates the IOMMU
page table.

> diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/io=
mmu.c
> index ef456eff42d29..3637b0327d9e8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/iommu.c
> +++ b/arch/arm64/kvm/hyp/nvhe/iommu.c

[ ... ]

> @@ -4,16 +4,138 @@
>  int pkvm_iommu_init(void)
>  {
> +	int ret;
> +
>  	/* Keep DMA isolation optional. */
> -	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init)
> +	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init ||
> +	    !pkvm_iommu_ops->host_stage2_idmap)
>  		return 0;
> =20
> -	return pkvm_iommu_ops->init();
> +	ret =3D pkvm_iommu_ops->init();
> +	if (ret)
> +		return ret;
> +
> +	return WARN_ON(pkvm_iommu_snapshot_host_stage2());

[Severity: High]
Does this unintentionally cause a hypervisor panic if the snapshot fails?

At EL2 (nVHE/pKVM), WARN_ON expands to a fatal BRK instruction rather than
a warn-and-continue. Wrapping a fallible operation like this triggers a
panic during initialization instead of returning the error.

> +}

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index c1a8fd811c0fa..da5014e4e96b6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c

[ ... ]

> @@ -603,16 +604,15 @@ static int host_stage2_set_owner_metadata_locked(ph=
ys_addr_t addr, u64 size,
>  	ret =3D host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
>  			      addr, size, &host_s2_pool,
>  			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> -	if (!ret) {
> -		/*
> -		 * After stage2 maintenance has happened, but before the page
> -		 * owner has changed.
> -		 */
> -		pkvm_sme_dvmsync_fw_call();
> -		__host_update_page_state(addr, size, PKVM_NOPAGE);
> -	}
> -
> -	return ret;
> +	if (ret)
> +		return ret;
> +	/*
> +	 * After stage2 maintenance has happened, but before the page
> +	 * owner has changed.
> +	 */
> +	pkvm_sme_dvmsync_fw_call();
> +	__host_update_page_state(addr, size, PKVM_NOPAGE);
> +	return WARN_ON(pkvm_iommu_host_stage2_idmap(addr, addr + size, 0));

[Severity: High]
Does this create a dead-branch trap that skips rolling back the page state?

Since WARN_ON acts as a panic at EL2, any failure in the IOMMU mapping call
will immediately crash the hypervisor. It also leaves the earlier mutation
from __host_update_page_state without a rollback path on failure.

>  }
> =20
>  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> @@ -625,8 +625,10 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u=
64 size, u8 owner_id)
>  			return -EPERM;
> =20
>  		ret =3D host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
> -		if (!ret)
> -			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> +		if (ret)
> +			break;
> +		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> +		ret =3D WARN_ON(pkvm_iommu_host_stage2_idmap(addr, addr + size, PKVM_H=
OST_MEM_PROT));

[Severity: High]
Is it intentional that a failure here panics instead of returning the error?

Assigning WARN_ON to a variable suggests an expectation that it returns,
but at EL2 it triggers a fatal BRK instruction. This also leaves the prior
page state update without a rollback.

>  		break;

[ ... ]

> @@ -1029,6 +1031,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *v=
cpu, u64 gfn)
>  				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
>  				       &vcpu->vcpu.arch.pkvm_memcache, 0));
>  	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_B=
ORROWED));
> +	WARN_ON(pkvm_iommu_host_stage2_idmap(phys, phys + PAGE_SIZE, PKVM_HOST_=
MEM_PROT));

[Severity: High]
Can an untrusted guest intentionally trigger a host denial of service here?

By triggering memory sharing hypercalls, a guest might exhaust the IOMMU
page pool, forcing an allocation failure in pkvm_iommu_host_stage2_idmap.
Wrapping this fallible outcome in WARN_ON will trigger a hypervisor panic.

>  unlock:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D7
