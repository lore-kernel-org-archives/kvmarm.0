Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793639569;
	b=eyAYR/sJ3+QNmTi4+sz75aE3c+4ZNsEOJVyMsVxrS4CClrNT3VelvY+/WWizQGMYS8eV
	 UDRyQXREC/8SZOGhNZIu8y689DoRKpzERIzsu+UraCatNpf26UBYfBAH0+iLhH15z3sDD
	 v+VSOGy4Ke+1yQwPQ97Ce/l2J4T3ogz8wrF8VXQCU0VbbITUwNrktSRIT6t7wUNKr7sG5
	 t1Hlr+/BvkeaCFBNs9ASkp8zImKbTlxXJnqn7zhwWHZDr8FBvnDvpf+m5B3VgH8uOpc1D
	 zgQuev4jMfYto/i5ao5HELP5ve+JJhrQw5/7dWhlioZWKa0AXC1ZeSIi3wRXL9Kqp+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793639569;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3HCATC6tsmgasiX43fdFxfhgoRxcjnWVVAbrbFiSeQc=;
	b=Xd9zGSHeG9/RI+ubRpdT1kintAv3DSXkRRJhXc/6rFuDCG93hMbs8cKQs/EpnSgO13Ag
	 67z8W7h6/img2SbshE3QqPJ3+R5bnmQBox8xHIZ5KidoAvoCZVjCABZSyRW+LHNlkDYIo
	 uOnCldIarkGZXfbG2cZm6qXaSX0s6/RUW9OMs5MxPTjCPiUqujxH2DVZT0l4kiXXGg1OV
	 6b1MzxIpf6IYAZEWp6NtIyyXKAgzpfSzPdmfrfq+SvKO7jDCrWcA7R32tH3UiibVEPqs9
	 ExjIUDZahJW4CZgs6eRFxxkO4GXxq6CB/Hl9R7SoB2LpKAjSbBPl6S18fCLXhrDyBHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZufwQC5O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E8C606A33A;
	Mon,  2 Nov 2026 17:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZufwQC5O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F2F1F00A16;
	Mon,  2 Nov 2026 17:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793639568;
	bh=3HCATC6tsmgasiX43fdFxfhgoRxcjnWVVAbrbFiSeQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZufwQC5O44ArUD6iYgb2/NhRwTjPnoV5be+/zqD2cmZjhpfFh/phR7l0MlsqtlhA4
	 rMjIIOh8eWk7OpJPRHObnCIB8KIelpX0a1Ys9c5sGJGNqOVi3kWWeNJKkX59AIKv4s
	 u+PFSQA947JZIfrALVBzpSfHuMfb8DMWhmnoeVNtMSMFia47pmvzmCjsKbAzYmmhxQ
	 mbpKJ5G/snsXkJCvC4AOl8E+DTs0r5ZxHckA2CgNKTXPR8KH/CFaZt+G+QaI4gRDLF
	 pYunSLkeLVP6AmEl+mdEGfluUTlXHoEEX7p3k4epwkkgBHPJ8d0vNkbDIUUXcweF4u
	 bnfmZeuviEm7w==
Message-ID: <sashiko-outbox-193812@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/11] KVM: arm64: CCA: Add Realm stage-2 MMU operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102141304.126883-12-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-12-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 17:12:48 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] KVM: arm64: read_lock() used instead of write_lock() in kvm_fa=
ult_lock()
- [Critical] KVM: arm64: unaligned PFN and empty memcache on Realm permissi=
on faults
- [High] KVM: arm64: uninitialized next_addr in realm_unmap_private_range()
- [High] KVM: arm64: page accounting after page free in free_rtt()
- [High] KVM: arm64: stage-2 PGD leak in kvm_uninit_stage2_mmu() for Realms
- [High] KVM: arm64: leaked delegated pages on error in realm_map_protected=
()
- [High] KVM: arm64: uninitialized out_top and positive error in realm_map_=
non_secure()
--

commit c7041c45fed830c50c8f37ff21d6036da29c1302
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: CCA: Add Realm stage-2 MMU operations

This commit defines and registers realm_vm_s2_ops for VM_REALM, routing
stage-2 unmapping through kvm_realm_unmap_range_filter() and stage-2 memory
aborts through kvm_vm_mem_abort(). It also provides no-op TLB flush and GFN
aging callbacks since the RMM manages stage-2 TLB invalidation and does not
support stage-2 access flags.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 20aedbe6ec072..bb33c07569e3b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c

[ ... ]

> @@ -353,6 +366,15 @@ static void no_stage2_unmap_range(struct kvm_s2_mmu =
*mmu,
>  {
>  }
> =20
> +static void realm_stage2_unmap_range(struct kvm_s2_mmu *mmu,
> +				     phys_addr_t start, u64 size, bool may_block,
> +				     enum kvm_gfn_range_filter filter)
> +{
> +	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
> +
> +	kvm_realm_unmap_range_filter(kvm, start, size, may_block, filter);
> +}

[Severity: High]
When realm_stage2_unmap_range() calls
kvm_realm_unmap_range_filter()->realm_unmap_private_range(), can next_addr =
be
read uninitialized or left stale when rmi_rtt_data_unmap() returns a non-ze=
ro
status?

In arch/arm64/kvm/rmi.c, realm_unmap_private_range() loops with next_addr:

	unsigned long next_addr, addr;
	long ret;

	for (addr =3D start; addr < end; addr =3D next_addr) {
		...
retry:
		ret =3D rmi_rtt_data_unmap(rd, addr, end, flags, 0,
					 &next_addr, &out_range, NULL);
		if (WARN_ON(ret < 0))
			return;

		if (RMI_RESULT_STATUS(ret) =3D=3D RMI_ERROR_RTT) {
			phys_addr_t rtt;

			if (next_addr > addr)
				continue; /* UNASSIGNED */
			...
		} else if (WARN_ON(ret)) {
			continue;
		}

However, in include/linux/arm-rmi-cmds.h, rmi_rtt_data_unmap() returns early
before writing *out_top when ret !=3D RMI_SUCCESS:

	ret =3D rmi_sro_execute(&regs);

	if (ret !=3D RMI_SUCCESS)
		return ret;

	if (out_top)
		*out_top =3D regs.a1;

If rmi_rtt_data_unmap() returns RMI_ERROR_RTT on an unpopulated private IPA
range, next_addr is either uninitialized on the first iteration or equal to
addr from the previous iteration. As a result, next_addr > addr is not
reliably true for unassigned entries, causing realm_unmap_private_range() to
allocate and create RTT levels down to KVM_PGTABLE_LAST_LEVEL + 1 where
realm_rtt_create() triggers WARN_ON(ret) and aborts the unmap early (or jum=
ps
to a garbage address if stack contents happen to be greater than addr).

[Severity: High]
In the same unmap path, when realm_unmap_shared_range() or
realm_unmap_private_range() folds RTT levels via
realm_fold_rtt_level()->free_rtt(), does free_rtt() access the page after it
has already been freed?

In arch/arm64/kvm/rmi.c:

static void free_rtt(phys_addr_t phys)
{
	if (rmi_free_delegated_page(phys))
		return;

	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
}

And in drivers/firmware/arm_rmm/rmi.c:

int rmi_free_delegated_page(phys_addr_t phys)
{
	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
		/* Undelegate failed: leak the page */
		return -EBUSY;
	}

	free_page((unsigned long)phys_to_virt(phys));

	return 0;
}

Because rmi_free_delegated_page() calls free_page() first (which uncharges =
the
folio and clears its memcg association before returning the page to the
allocator), calling kvm_account_pgtable_pages() afterwards touches a freed
page and fails to decrement NR_SECONDARY_PAGETABLE on the original memcg.
Should kvm_account_pgtable_pages(phys_to_virt(phys), -1) be called before
free_page() (or before rmi_free_delegated_page())?

[ ... ]

> @@ -3291,6 +3313,15 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s=
2_ops =3D {
>  	.vm_mem_abort			=3D kvm_vm_mem_abort,
>  };
> =20
> +static const struct kvm_vm_s2_ops realm_vm_s2_ops =3D {
> +	.vm_flush_remote_tlbs		=3D realm_flush_remote_tlbs,
> +	.vm_flush_remote_tlbs_range	=3D realm_flush_remote_tlbs_range,
> +	.vm_age_gfn			=3D no_age_gfn,
> +	.vm_test_age_gfn		=3D no_age_gfn,
> +	.vm_stage2_unmap_range		=3D realm_stage2_unmap_range,
> +	.vm_mem_abort			=3D kvm_vm_mem_abort,

[Severity: Critical]
When kvm_vm_mem_abort() handles stage-2 faults for a Realm VM via
gmem_abort() or user_mem_abort()->kvm_s2_fault_map(), it acquires
kvm->mmu_lock using kvm_fault_lock(kvm). Does kvm_fault_lock() take a read
lock instead of a write lock for Realm VMs?

In arch/arm64/include/asm/kvm_mmu.h:

static inline void kvm_fault_lock(struct kvm *kvm)
{
	if (is_protected_kvm_enabled())
		write_lock(&kvm->mmu_lock);
	else
		read_lock(&kvm->mmu_lock);
}

is_protected_kvm_enabled() checks ARM64_KVM_PROTECTED_MODE, which is false =
in
KVM_MODE_RMM. However, struct realm in arch/arm64/include/asm/kvm_rmi.h not=
es
that RTT map/unmap SRO commands require kvm->mmu_lock to be held for write
during fault handling:

	 * Reused by RTT map/unmap SRO commands. Those commands are only
	 * issued from Realm stage-2 map/unmap paths while kvm->mmu_lock is
	 * held for write, including Realm fault handling where
	 * kvm_fault_lock() takes the write side, so concurrent use is
	 * serialized.

Furthermore, during fault handling, realm_map_non_secure() calls
realm_unmap_shared_range(kvm, ipa, ipa_top, true) and realm_map_protected()
calls realm_unmap_private_range(kvm, base_ipa, ipa, true) on error. Both pa=
ss
may_block =3D true and execute cond_resched_rwlock_write(&kvm->mmu_lock) wh=
ile
only a read lock is held, which triggers lockdep_assert_held_write() and ca=
lls
write_unlock() followed by write_lock() on a read-locked rwlock, corrupting
the lock state and self-deadlocking on the caller's own reader count.

In addition, calling realm_unmap_shared_range() with may_block =3D true ins=
ide
realm_map_non_secure() can drop kvm->mmu_lock after mmu_invalidate_retry() =
has
already been checked in gmem_abort() or kvm_s2_fault_map(), allowing a
concurrent mmu_notifier invalidation to unmap and free the page before
rmi_rtt_unprot_map() installs the mapping. Should kvm_fault_lock() and
kvm_fault_unlock() also take the write lock when kvm_vm_is_realm(kvm) is tr=
ue,
and should realm_map_non_secure() pass may_block =3D false to
realm_unmap_shared_range()?

[Severity: Critical]
In kvm_vm_mem_abort()->user_mem_abort()->kvm_s2_fault_map(), how are stage-2
permission faults on shared IPAs handled for Realm VMs?

First, in user_mem_abort():

	memcache =3D get_mmu_memcache(s2fd->vcpu);
	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
	    is_protected_kvm_enabled()) {
		ret =3D topup_mmu_memcache(s2fd->mmu, memcache);
		if (ret)
			return ret;
	}

Because is_protected_kvm_enabled() is false for Realm VMs, memcache is not
topped up on permission faults, even though realm_map_non_secure() unmaps a=
nd
folds the existing RTT entry via realm_unmap_shared_range() and then alloca=
tes
RTTs from memcache via realm_create_rtt_levels().

Second, in kvm_s2_fault_map():

	if (mapping_size =3D=3D PAGE_SIZE && s2vi->max_map_size !=3D PAGE_SIZE) {
		if (perm_fault_granule > PAGE_SIZE) {
			mapping_size =3D perm_fault_granule;
		} else {
			mapping_size =3D transparent_hugepage_adjust(s2fd, &pfn, &gfn);
			if (mapping_size < 0) {
				ret =3D mapping_size;
				goto out_unlock;
			}
		}
		canonical_ipa =3D ALIGN_DOWN(canonical_ipa, mapping_size);
	}

	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
		sanitise_mte_tags(kvm, pfn, mapping_size);

	if (kvm_vm_is_realm(kvm)) {
		ret =3D realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
				    prot, memcache);

When perm_fault_granule > PAGE_SIZE on a THP VMA (where s2vi->vma_pagesize =
is
PAGE_SIZE), kvm_s2_fault_map() sets mapping_size =3D perm_fault_granule wit=
hout
calling transparent_hugepage_adjust() to verify that the host VMA is still
backed by a huge page (for example, if a write fault split the THP via CoW)=
 or
to align pfn down to mapping_size. For normal VMs this is safe because
kvm_pgtable_stage2_relax_perms() does not use pfn, but for a Realm VM
realm_map_ipa() aligns fault_ipa down to mapping_size while mapping from the
unaligned 4KB pfn for mapping_size bytes. Can this map adjacent host physic=
al
pages beyond the end of the folio (or from a split THP) into the Realm gues=
t?

[Severity: High]
When kvm_vm_mem_abort() calls realm_map_ipa()->realm_map_protected(), can t=
he
err_undelegate path fail to undelegate the remaining unmapped pages if an
error occurs after part of the range was already mapped?

In arch/arm64/kvm/rmi.c:

err_undelegate:
	realm_unmap_private_range(kvm, base_ipa, ipa, true);
	/* A range which cannot be undelegated remains owned by the RMM. */
	WARN_ON(rmi_undelegate_range(base_phys, map_size));
	return ret < 0 ? ret : -ENXIO;

If the loop mapped [base_ipa, ipa) before failing, realm_unmap_private_rang=
e()
unmaps [base_ipa, ipa) and undelegates [base_phys, phys). Calling
rmi_undelegate_range(base_phys, map_size) then starts at base_phys, which is
already undelegated, so rmi_granule_range_undelegate() fails on the first p=
age
and aborts the loop, triggering the WARN_ON and leaving [phys,
base_phys + map_size) permanently delegated. Should this call
rmi_undelegate_range(phys, ipa_top - ipa) instead?

[Severity: High]
In kvm_vm_mem_abort()->...->realm_map_ipa()->realm_map_non_secure(), what
happens if rmi_rtt_unprot_map() returns a positive RMI error code?

In arch/arm64/kvm/rmi.c:

		if (RMI_RESULT_STATUS(ret) =3D=3D RMI_ERROR_RTT) {
			...
			ret =3D realm_create_rtt_levels(realm, ipa, level,
						      req_level,
						      memcache);
			if (ret)
				return ret;

			ret =3D rmi_rtt_unprot_map(rd, ipa, ipa_top, flags,
						 range_desc, &out_top);
			if (ret < 0)
				return ret;
		}

		if (ret && RMI_RESULT_STATUS(ret) !=3D RMI_ERROR_RTT)
			return ret;

		phys +=3D out_top - ipa;
		ipa =3D out_top;

If the retry of rmi_rtt_unprot_map() after realm_create_rtt_levels() returns
RMI_ERROR_RTT, out_top is never written by rmi_rtt_unprot_map(), and execut=
ion
falls through to phys +=3D out_top - ipa; ipa =3D out_top; using an uniniti=
alized
out_top. And if rmi_rtt_unprot_map() returns any other positive RMI status
code, realm_map_non_secure() returns that positive value up through
kvm_vm_mem_abort() to kvm_handle_guest_abort(), which treats positive return
values as a successfully handled fault and re-enters the guest.

> +};
> +
>  #define KVM_VM_S2_OPS(flavor, ops)		\
>  		[flavor] =3D &(ops)
> =20
> @@ -3299,7 +3330,7 @@ static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[=
] =3D {
>  	KVM_VM_S2_OPS(VM_NVHE, kvm_default_vm_s2_ops),
>  	KVM_VM_S2_OPS(VM_PKVM, pkvm_vm_s2_ops),
>  	KVM_VM_S2_OPS(VM_PROTECTED_PKVM, protected_pkvm_vm_s2_ops),
> -	[VM_REALM] =3D NULL,
> +	KVM_VM_S2_OPS(VM_REALM, realm_vm_s2_ops),

[Severity: High]
Now that arm64_vm_s2_ops[VM_REALM] is populated, kvm_init_stage2_mmu()
succeeds for Realm VMs and allocates mmu->pgt, its PGD pages, and
mmu->last_vcpu_ran. Does kvm_uninit_stage2_mmu() leak those allocations if
kvm_arch_init_vm() fails at err_uninit_mmu or if the VM is destroyed before
the Realm is created?

In arch/arm64/kvm/mmu.c:

void kvm_uninit_stage2_mmu(struct kvm *kvm)
{
	if (kvm_vm_is_realm(kvm))
		kvm_realm_uninit_stage2(&kvm->arch.mmu);
	else
		kvm_free_stage2_pgd(&kvm->arch.mmu);
	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
}

And in arch/arm64/kvm/rmi.c:

void kvm_destroy_realm(struct kvm *kvm)
{
	struct realm *realm =3D &kvm->arch.realm;
	int i;

	if (!kvm_realm_is_created(kvm)) {
		kfree(realm->sro);
		realm->sro =3D NULL;
		return;
	}
	...
	kvm_free_stage2_pgd(&kvm->arch.mmu);
}

When realm->state is REALM_STATE_NONE, kvm_realm_uninit_stage2() is a no-op
and kvm_destroy_realm() returns early before calling
kvm_free_stage2_pgd(&kvm->arch.mmu) (or is not called at all on the
err_uninit_mmu failure path of kvm_arch_init_vm()), leaving mmu->pgt, the
stage-2 PGD pages, and mmu->last_vcpu_ran allocated.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102141304.1268=
83-1-steven.price@arm.com?part=3D11
