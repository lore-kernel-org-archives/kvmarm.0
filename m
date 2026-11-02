Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632735;
	b=2wg7Z4g22ZTsgiGowEiKRNtXCbrM5dNLvkgz5AXeGH19rbYt6BRfFHGP+fwyR4jItit7
	 3pnfxwTLgoPwkc0O1y+HoAXTkNaCaHg++i4gmi0TgEqfbdbCBvDgZUXYQCrt/hMEx1d0C
	 VbIUKDgUGigC2l4LCqsrZ4rSCGh1JQA+JYhx2M7FZDrN+yLd6Z2F0Ckt4lHIrfaK9rLDk
	 GX6Qh2psWX4bbPDUYlEz/sbU8WLOLU0ewMoObSgY5uF5MxzdEutSnZoAo8+HSIdIDzRdL
	 E2+w1/37P54WLSillgKgjEnUHLzHoDaXwo2ItUJOsGE8dhDPU1c7oAuaTHwSp7+sbAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632735;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=alrYeRmTgtP3SWpzeLr6Dn4UHEUt5FUQSbIusnNGtoI=;
	b=Jko3RfvKClZd8ODpl4DZCIthq6+T0qbWAO7xDWSs8jvVUYncbQxUBdaQzqz1Z/6qnK27
	 kZtkZeChqAyioIh61CdRsDrUjObzpPlo+lD6lRgps5CGLM7oIfWRHRBKPCcYiEN5z9S4Y
	 S+gpHrHXQZnzcQvbtIrNpuO2dga2A1f5EiaN52kjcAGK1ybvWtwQC1yu5kCMhzmyGHh5j
	 eC1L9yM89s2uwzEXSc1wquZOF6FO6iYRHNLqG6H7dppo6Zj74UzFD6k3TK4kE/LfJA7r5
	 Gw12csFf5AG3Wz7+A0YezGoCk0Clw/mmCgnUH5pKVdWt0B1LqldcSX2v87v3+Db8/bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCuBtHPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BEB606A5BC;
	Mon,  2 Nov 2026 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCuBtHPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DC71F00A16;
	Mon,  2 Nov 2026 15:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632735;
	bh=alrYeRmTgtP3SWpzeLr6Dn4UHEUt5FUQSbIusnNGtoI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aCuBtHPzcTfjgWDR4Xq0j97TIFZmFrIje8GDHbZQcKN9+vq/Uo58LyWgGnqUGr4Jj
	 MfIwAH/RrlrWIgP8azc5dxHmi+hghWLPewaO2dANYioWjCaTz6Zz/oaxeY0TuW79dZ
	 mJ+hnV1V0a8kFfbFwIWZw5S2O37nbVl1ov233za+3Q+npXe71kKkpklPOEnSA9ZmzT
	 SV9mCjXHHqvaPX+zOYlKCoVCFCJQB863B9+7KTSLRJhjQGwxAEfEpa22l4ghCqzMlc
	 9j6SAlQlDzzx+SU2lUtvN9ouLD0kOLN3Ke6t5QUTuHg0M4OJBQiEtB2+w83lW/UXgJ
	 mZy4PTsndifXQ==
Message-ID: <sashiko-outbox-193650@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/11] KVM: arm64: CCA: Tear down RTTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102141304.126883-8-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-8-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 15:18:54 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] KVM: arm64: stage-2 PGD leak for uncreated Realms in kvm_destroy_r=
ealm()
- [High] KVM: arm64: unclamped stage-2 levels in get_start_level() breaks 6=
4K RTT teardown
- [High] KVM: arm64: free_rtt() accounts page table pages after freeing the=
 page
- [Medium] KVM: arm64: kvm_realm_uninit_stage2() ignores REALM_STATE_NEW
--

commit 5954ac2ccf8825a659e2f39dc0db05d96c40be84
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Tear down RTTs

This commit adds stage-2 page table and Realm Translation Table (RTT)
teardown for arm64 CCA realms. It unmaps the Realm IPA space during stage-2
teardown and walks non-root RTTs during final Realm destruction to destroy
and undelegate them before destroying the Realm Descriptor.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b049ea67d9af3..51fda7b2ff7f3 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1145,9 +1145,24 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kv=
m_s2_mmu *mmu, unsigned long t
>  	return err;
>  }
> =20
> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
> +{
> +	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +	if (kvm_realm_state(kvm) =3D=3D REALM_STATE_ACTIVE) {
> +		kvm_set_realm_state(kvm, REALM_STATE_DYING);
> +		WARN_ON(kvm_realm_teardown_stage2(kvm));
> +	}
> +	mutex_unlock(&kvm->arch.config_lock);
> +}

[Severity: Medium]
What happens if kvm_uninit_stage2_mmu() is called via
kvm_mmu_notifier_release() -> kvm_flush_shadow_all() ->
kvm_arch_flush_shadow_all() while the Realm is in REALM_STATE_NEW?

According to enum realm_state in arch/arm64/include/asm/kvm_rmi.h, the Realm
Descriptor has already been created and stage-2 memory may already be
populated in REALM_STATE_NEW. Unlike kvm_destroy_realm(), which checks
kvm_realm_is_created(kvm), sets REALM_STATE_DYING, and unmaps stage-2 for
both REALM_STATE_NEW and REALM_STATE_ACTIVE, kvm_realm_uninit_stage2() only
checks for REALM_STATE_ACTIVE.

Should kvm_realm_uninit_stage2() also handle REALM_STATE_NEW (for example by
checking kvm_realm_is_created(kvm)) so that stage-2 mappings are unmapped
before exit_mmap() finishes and the Realm transitions to REALM_STATE_DYING?

>  void kvm_uninit_stage2_mmu(struct kvm *kvm)
>  {
> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +	if (kvm_vm_is_realm(kvm))
> +		kvm_realm_uninit_stage2(&kvm->arch.mmu);
> +	else
> +		kvm_free_stage2_pgd(&kvm->arch.mmu);
>  	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>  }

[Severity: High]
Does skipping kvm_free_stage2_pgd() here leak mmu->pgt, the root stage-2 PGD
pages (mmu->pgt->pgd), and the per-CPU mmu->last_vcpu_ran allocation when a
Realm VM is destroyed before the Realm is created in the RMM?

During VM creation, kvm_arch_init_vm() calls kvm_init_stage2_mmu() while the
Realm state is still REALM_STATE_NONE. If userspace closes the VM file
descriptor without creating the Realm in the RMM, kvm_destroy_realm() takes
its early return before reaching kvm_free_stage2_pgd(&kvm->arch.mmu):

arch/arm64/kvm/rmi.c:kvm_destroy_realm() {
	...
	if (!kvm_realm_is_created(kvm)) {
		kfree(realm->sro);
		realm->sro =3D NULL;
		return;
	}
	...
	kvm_free_stage2_pgd(&kvm->arch.mmu);
}

Similarly, if kvm_init_nested() or kvm_init_realm() fails in
kvm_arch_init_vm() after kvm_init_stage2_mmu() succeeds:

arch/arm64/kvm/arm.c:kvm_arch_init_vm() {
	...
	ret =3D kvm_init_nested(kvm);
	if (ret)
		goto err_uninit_mmu;

	if (kvm_vm_is_realm(kvm)) {
		ret =3D kvm_init_realm(kvm);
		if (ret)
			goto err_uninit_mmu;
	}

	return 0;

err_uninit_mmu:
	kvm_uninit_stage2_mmu(kvm);
	return ret;
}

the error path only calls kvm_uninit_stage2_mmu(kvm) and never calls
kvm_destroy_realm(), leaking the stage-2 PGD allocations there as well.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 45ecbaa467d1d..f190143b33ba5 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c

[ ... ]

> @@ -21,11 +29,180 @@ u32 kvm_rmm_ipa_limit(void)
>  	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>  }
> =20
> +static int get_start_level(struct realm *realm)
> +{
> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
> +}

[Severity: High]
Can get_start_level() return a level that mismatches the stage-2 page table
configuration on 64KB page kernels and cause realm_destroy_rtts() to fail?

When kvm_init_ipa_range() configures mmu->vtcr via kvm_get_vtcr(), the
number of stage-2 levels is clamped to at least 2:

arch/arm64/kvm/hyp/pgtable.c:kvm_get_vtcr() {
	...
	lvls =3D stage2_pgtable_levels(phys_shift);
	if (lvls < 2)
		lvls =3D 2;
	...
}

Under CONFIG_ARM64_64K_PAGES with a 32-bit or 33-bit IPA,
stage2_pgtable_levels(realm->ia_bits) evaluates to 1, so get_start_level()
returns 3 (KVM_PGTABLE_LAST_LEVEL) instead of 2.

When kvm_destroy_realm() -> realm_destroy_rtts() ->
realm_tear_down_rtt_range() then calls:

	realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
				  start, end);

it passes level 4 into realm_tear_down_rtt_level(), hitting
WARN_ON(level > KVM_PGTABLE_LAST_LEVEL) and returning -EINVAL. That in turn
causes kvm_destroy_realm() to warn and return early, leaking the delegated
RD, RTT granules, root stage-2 PGD pages, and realm->sro.

> +
> +static void free_rtt(phys_addr_t phys)
> +{
> +	if (rmi_free_delegated_page(phys))
> +		return;
> +
> +	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
> +}

[Severity: High]
Does calling kvm_account_pgtable_pages() after rmi_free_delegated_page()
access the page after it has already been freed and uncharged from its
memcg?

In drivers/firmware/arm_rmm/rmi.c, rmi_free_delegated_page() undelegates the
granule and immediately frees the page back to the page allocator:

drivers/firmware/arm_rmm/rmi.c:rmi_free_delegated_page() {
	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
		/* Undelegate failed: leak the page */
		return -EBUSY;
	}

	free_page((unsigned long)phys_to_virt(phys));

	return 0;
}

Because free_page() clears page->memcg_data in __free_pages_prepare() and
releases the page for reallocation, the subsequent call to
kvm_account_pgtable_pages(phys_to_virt(phys), -1) ->
mod_lruvec_page_state() operates on a freed struct page and sees a NULL
folio_memcg(), failing to decrement the memory cgroup's
NR_SECONDARY_PAGETABLE counter (or racing with a concurrent reallocation of
that page).

Should kvm_account_pgtable_pages(phys_to_virt(phys), -1) be called before
freeing the page, matching kvm_s2_free_pages_exact() and kvm_s2_put_page()
in arch/arm64/kvm/mmu.c?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102141304.1268=
83-1-steven.price@arm.com?part=3D7
