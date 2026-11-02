Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654033;
	b=boTBKbvcy+fphtZbJVvj4hhIpUSqwZya2bzq1YSC6ASVmwxRy4Z/ktflTyN6MVf5QYaE
	 CCOyYusqimPGn24ItwPqWOHFSBhywy78dPhcNVTYO7u8yAInecBATMnLPIeRC/7RhoZxy
	 2v3Ymcw5kFPy0FpT/z6ZaAdyl1ZU81ZwrAzUDDe8c7GOxg45tVoCU6TDQpeZW6nZvECUR
	 cSl/pNQ164OdBDf6mG8+208bVxrLxWk4f+FWrOkntt5CnHNaymxbmVVaGysZ1K1CrRP6Q
	 aqUFeR3ceES1mDBICk/uyZHMeVh5K26Gd9L5kEMQCrde1Fni7utE4NaFyrRdnZ9nNug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654033;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CsMyiZH2K+p/Wo2C7JC4euPw6GtYfu1kt2BHGZFE0tc=;
	b=pjli3Dc/65f135uniwKgO50FBJ1OeidKrfq1sfEosp2BZpuru42GkjOWvOpQwnNGavJP
	 d84uuI3lLjSy5DmeIyJb8SvzmAQUA4AaWGhNXEZuIAgM0485OTNIvTe8i1jVgtS4cBwbR
	 BKZXhklf43ZNHiYzlnWMZgol8emlKcEz5yZqVSPAV+niTgxCqK75IQC7Xzers3BheNcvP
	 XU5vLCNK5zjkmwRnuLlnin3qJfFu1epR7qUG+M5Y0hsReqBtgmmQMB9b7QoWS1RXhtpI4
	 HpCS4nCA5m3XCEPG0q3plo8x9yR4UwX33s0I8WK0dahFX8+K+helJMWE+whgXmQpkWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W0o4G8Lr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB214606A32C
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W0o4G8Lr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD881F00A16;
	Mon,  2 Nov 2026 21:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654032;
	bh=CsMyiZH2K+p/Wo2C7JC4euPw6GtYfu1kt2BHGZFE0tc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W0o4G8Lri8fayI70hus3GHu61wrH0xvlSzAJJ869cm+FoWmPuyaMbdXgeXFFoBz0G
	 nUiNnNgJ+OF+F9BBpeO1BXkGUv+rGQFbhpS53lFLbjJXqyNy5XUJQnQQ2Zxjx2mks5
	 hVr3RO2QRVqcD2BUDcGrNp9rvkxlPQXURcMd7NvCaIfVeh1BO9zkaVsUMj25X9Trtb
	 vzSWiCgbSwuWaiOw4ZgfXHQ9fd06EAaW8Eqw+UL6auhC7QhrzXqUvLYjX9lgjGHO95
	 8SCPJ6hY8a+HV9uqos14hi8/rIclQDhw9hVzxpjb5jhdmlfwuRCFBtFvpZOZ1zz1EX
	 w2i/3ppxeZtdw==
Message-ID: <sashiko-outbox-194185@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 19/23] KVM: arm64: Add __pkvm_host_split_guest HVC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102204628.401871-20-vdonnefort@google.com>
References: <20261102204628.401871-1-vdonnefort@google.com>
 <20261102204628.401871-20-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 21:13:51 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: arm64: Missing host_stage2_try() when splitting host stage-=
2 GFN metadata
--

commit 1780446e119343d8ac04e9e17e8d107c87019c8d
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add __pkvm_host_split_guest HVC

This commit introduces the __pkvm_host_split_guest hypercall so the host can
split a PMD block mapping in a protected VM's stage-2 page table and update
the corresponding host stage-2 GFN metadata annotations to page granularity.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 88af0aec1ea92..7ecf4c98d7b5e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c

[ ... ]

> @@ -690,17 +693,59 @@ static int host_stage2_decode_gfn_meta(kvm_pte_t pt=
e, struct pkvm_hyp_vm **vm,
>  		return -EPERM;
> =20
>  	meta =3D FIELD_GET(KVM_HOST_DONATION_PTE_EXTRA_MASK, pte);
> -	handle =3D FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
> -	*vm =3D get_vm_by_handle(handle);
> -	if (!*vm) {
> -		/* We probably raced with teardown; try again */
> -		return -EAGAIN;
> -	}
> -
> +	*handle =3D FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
>  	*gfn =3D FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
>  	return 0;
>  }
> =20
> +static int host_stage2_split_gfn_meta(phys_addr_t phys, u64 ipa, u64 siz=
e, struct pkvm_hyp_vm *vm)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops =3D &host_mmu.mm_ops;
> +	struct kvm_pgtable *pgt =3D &host_mmu.pgt;
> +	kvm_pte_t pte, *table, *ptep;
> +	pkvm_handle_t handle;
> +	s8 level;
> +	u64 gfn;
> +	int ret;
> +
> +	ret =3D kvm_pgtable_get_leaf(pgt, phys, &pte, &level, 0);
> +	if (ret)
> +		return ret;
> +
> +	if (kvm_granule_size(level) !=3D size)
> +		return -EINVAL;
> +
> +	ret =3D host_stage2_decode_gfn_meta(pte, &handle, &gfn);
> +	if (ret)
> +		return ret;
> +
> +	if (handle !=3D vm->kvm.arch.pkvm.handle || gfn !=3D (ipa >> PAGE_SHIFT=
))
> +		return -EINVAL;
> +
> +	table =3D mm_ops->zalloc_page(&host_s2_pool);
> +	if (!table)
> +		return -ENOMEM;

[ ... ]

> @@ -1778,6 +1830,55 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm=
_hyp_vcpu *vcpu)
>  	return 0;
>  }
> =20
> +int __pkvm_host_split_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu =
*vcpu)
> +{
> +	struct kvm_hyp_memcache *mc =3D &vcpu->vcpu.arch.stage2_mc;
> +	struct pkvm_hyp_vm *vm =3D pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> +	u64 size =3D nr_pages << PAGE_SHIFT;
> +	u64 ipa =3D hyp_pfn_to_phys(gfn);
> +	kvm_pte_t pte, *table;
> +	phys_addr_t phys;
> +	s8 level;
> +	int ret;
> +
> +	if (!mc->nr_pages)
> +		return -ENOMEM;
> +
> +	if (size !=3D PMD_SIZE || !IS_ALIGNED(ipa, PMD_SIZE))
> +		return -EINVAL;
> +
> +	level =3D KVM_PGTABLE_LAST_LEVEL - 1;
> +
> +	host_lock_component();
> +	guest_lock_component(vm);
> +
> +	ret =3D get_valid_guest_pte(vm, ipa, size, &pte, &phys);
> +	if (ret)
> +		goto unlock;
> +
> +	table =3D kvm_pgtable_stage2_create_unlinked(&vm->pgt, kvm_pte_to_phys(=
pte), level,
> +						   kvm_pgtable_stage2_pte_prot(pte),
> +						   mc, true);
> +	if (IS_ERR(table)) {
> +		ret =3D PTR_ERR(table);
> +		goto unlock;
> +	}
> +
> +	ret =3D host_stage2_split_gfn_meta(phys, ipa, size, vm);

[Severity: Medium]
Should the call to host_stage2_split_gfn_meta() be wrapped with
host_stage2_try()?

In host_stage2_split_gfn_meta(), mm_ops->zalloc_page(&host_s2_pool)
allocates a page-table page from the fixed-size host_s2_pool. When system
RAM is mapped or donated at PMD block granularity in host_mmu.pgt, the
unused PTE-level page-table pages in host_s2_pool can be consumed by host
MMIO mappings faulted in via handle_host_mem_abort() -> host_stage2_idmap().

Other callers that allocate from host_s2_pool (such as
host_stage2_idmap_locked() and host_stage2_set_owner_metadata_locked()) wrap
their page-table operations in host_stage2_try(), which handles -ENOMEM by
calling host_stage2_unmap_dev_all() to reclaim MMIO page-table pages and
retrying.

Because pkvm_refill_memcache() only refills the guest stage2_mc, can
__pkvm_host_split_guest() fail with -ENOMEM if host MMIO mappings have
exhausted host_s2_pool?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102204628.4018=
71-1-vdonnefort@google.com?part=3D19
