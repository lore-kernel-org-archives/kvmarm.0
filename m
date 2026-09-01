Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9951C27EC7C
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251658; cv=none; b=FonD2fqUNrFgB5BpRvkj/aK8x+LaTcgXVFwcBXW8IYzFF5ZiNYH3oDXh3H2g5pdh+cqFo1yPsyERNUvfriRGZ8JjGq5EP7+u7rTM5DHoM/xjf4Mv9rtDgJJIea8tZPQ3Q2mEwpoolr5DFO2FUlovZz57H+NOSWruOg4M00zrqUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251658; c=relaxed/simple;
	bh=TvXusDrDrbiD6WVizuF+lyOFut4t/ltHc34c/DPgQgM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IY9E81r7yY3/8wsrTxKd/mzitCWefQa+1BthoannhQYxSulqBJzAM3r9wr4rE8hnpMQY/HG6+tDr2Z1RihEcOyLO2bKFRUNfcXW/2qQy/WjU3kerq+vqbBQAmAvBGwYeEJJevFaDXwY7ZU7FjXb/SXPiHdWrwyweckNgtZLB6GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6P7BCSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6P7BCSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B891F000E9;
	Tue,  1 Sep 2026 08:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788251657;
	bh=igwudY8DKn2kNqgYCKSulGw07AKU2c2ykPXY3mLz6m8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c6P7BCSgtPIQDQpQI9rCUXToTghpQlP/aUUddEXd7edKEnEc3ZatvO2LCLxkpvqTk
	 mT2sKf9Up18guBMfCxpt1uSWJhlVrhiHeZqjJotRiiK4Lo3bhf0I/rF7eOOK/olwew
	 5cOMoatxauCeO2mcFL6s1EnaMZdFr38/lgq+x9t8X+AtTira23pQAJs3QcvxOxvXql
	 s1m/zNh8Wp7m7rWHNib1xZrInnt87h820/iV1JBn4w46UA0zSbhJ4937PzYYDSHquK
	 0PsudsqJrjRhZqDT4BiXrqzOdwOigGdzTcf6svNh3pbeRY8GI7tuiQnqT2mlLhhSWJ
	 1+fept3MxH9lQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 13/18] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260901080941.997769-14-vdonnefort@google.com>
References: <20260901080941.997769-1-vdonnefort@google.com>
 <20260901080941.997769-14-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 08:34:16 +0000
Message-Id: <20260901083416.F0B891F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Memcg charge bypass and potential charge leak due to `pkvm_hyp_vm`=
 allocation transitioning to the global EL2 heap without proper host return=
 or memcg accounting.
--

commit 9d9a73aa6d8fa15436c6b53dd36960b9dade0e30
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator

Transition the allocation of the hypervisor VM state structure (pkvm_hyp_vm)
from the host to the hypervisor using the new pKVM heap allocator. The host
now uses pkvm_call_hyp_req() to invoke __pkvm_init_vm, which automatically
handles any top-up requests if the hypervisor runs out of heap memory.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index 0a041d41b9ea4..cabcfb59a89d2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
[ ... ]
> @@ -847,15 +846,15 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned l=
ong vm_hva,
>  	vm_size =3D pkvm_get_hyp_vm_size(nr_vcpus);
>  	pgd_size =3D kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
> =20
> -	ret =3D -ENOMEM;
> -
> -	hyp_vm =3D map_donated_memory(vm_hva, vm_size);
> -	if (!hyp_vm)
> -		goto err_remove_mappings;
> +	hyp_vm =3D hyp_alloc(vm_size);

[Severity: High]
Is it safe to allocate the VM struct from the global EL2 allocator here?

This draws from top-up pages that lack memcg constraints, whereas the
previous implementation donated memory that was explicitly allocated with
GFP_KERNEL_ACCOUNT by the host.

> +	if (!hyp_vm) {
> +		ret =3D hyp_alloc_errno();
> +		goto err_unpin_kvm;
> +	}
[ ... ]
> @@ -1053,8 +1052,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handl=
e)
>  		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
>  	}
> =20
> -	vm_size =3D pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
> -	teardown_donated_memory(mc, hyp_vm, vm_size);
> +	hyp_free(hyp_vm);

[Severity: High]
Does freeing the VM struct back into the global EL2 allocator rather than
returning it directly to the host create a charge stranding issue if memcg
accounting is re-enabled?

If accounting is restored at the top-up layer, any memcg charges applied
during top-up would be stranded indefinitely in the EL2 global pool until
reclaimed by the host shrinker. This would permanently leave the charge in
the original memcg even when those pages are subsequently reused by a
different VM.

>  	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
>  	return 0;
> =20
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index ea96744f41fb0..8505965dbfb21 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -230,28 +230,15 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
>  	if (!pgd)
>  		return -ENOMEM;
> =20
> -	/* Allocate memory to donate to hyp for vm and vcpu pointers. */
> -	hyp_vm_sz =3D PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
> -					size_mul(sizeof(void *),
> -						 kvm->created_vcpus)));
> -	hyp_vm =3D alloc_pages_exact(hyp_vm_sz, GFP_KERNEL_ACCOUNT);
> -	if (!hyp_vm) {
> -		ret =3D -ENOMEM;
> -		goto free_pgd;
> -	}
> -
> -	/* Donate the VM memory to hyp and let hyp initialize it. */
> -	ret =3D kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
> +	ret =3D pkvm_call_hyp_req(__pkvm_init_vm, kvm, pgd);

[Severity: High]
Does this change bypass memcg accounting for the pkvm_hyp_vm allocation?

Previously, this memory was allocated with GFP_KERNEL_ACCOUNT. By delegating
this allocation to the EL2 allocator via pkvm_call_hyp_req(), the memory is
provisioned through un-accounted top-ups.

When pkvm_call_hyp_req() triggers a PKVM_HYP_REQ_HYP_ALLOC to the host, it
is serviced by pkvm_hyp_topup(). The top-up memcache is initialized with
zeroed flags (omitting HYP_MEMCACHE_ACCOUNT_KMEMCG), which causes
hyp_mc_alloc_fn() to use raw GFP_KERNEL.=20

Because pkvm_hyp_vm scales with nr_vcpus and is no longer charged to the
creating task's memcg, can this allow an unprivileged container to bypass
its memory limits and exhaust host memory, potentially leading to a host
OOM?

>  	if (ret)
> -		goto free_vm;
> +		goto free_pgd;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901080941.9977=
69-1-vdonnefort@google.com?part=3D13
