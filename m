Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5921C68F
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770916739; cv=none; b=XLLdxeRx/jOVJfiTQWRQxcqRERuBKnTTiX7k7xEJf/rr+GxLn+bYQR/NAJZzsV38iQr1iS581HekSiwfenbgpbmNNJ+c+lV/Li9KrbQZPNnemrQ5/Jewd+bI5hd8uF8BQZ5IK+ugIo+TyOHJSCE8D+xA5dnC2b6mi86AeXpJ8bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770916739; c=relaxed/simple;
	bh=6NFz5MJLpn+E0ga7z4VuziT4KbfjF1VQUXoBWlhwGnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agBPE9Xjn9HTehYmGGyP+R3ymW22WGBy2HM+KlDxO9wm/yIRydU8xZd5NuYKevIQ5CDdnhtHodvuaGgtn8ERxX03QCp6LxDAMB3tL1AW6e7wtTC5l6iEugz4ZiJAkTGqfx9c3Y4Gy9aWIz2jxt67Modb22XUsWlEZ5r0M4ROkuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0D71339;
	Thu, 12 Feb 2026 09:18:45 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 484063F632;
	Thu, 12 Feb 2026 09:18:47 -0800 (PST)
Date: Thu, 12 Feb 2026 17:18:42 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 24/35] KVM: arm64: Introduce hypercall to force
 reclaim of a protected page
Message-ID: <aY4LchRsyTvjIBVb@raptor>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-25-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119124629.2563-25-will@kernel.org>

Hi Will,

On Mon, Jan 19, 2026 at 12:46:17PM +0000, Will Deacon wrote:
> Introduce a new hypercall, __pkvm_force_reclaim_guest_page(), to allow
> the host to forcefully reclaim a physical page that was previous donated
> to a protected guest. This results in the page being zeroed and the
> previous guest mapping being poisoned so that new pages cannot be
> subsequently donated at the same IPA.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |   1 +
>  arch/arm64/include/asm/kvm_pgtable.h          |   6 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      |   6 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   8 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 127 +++++++++++++++++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |   4 +-
>  8 files changed, 152 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 2e7e8e7771f6..39e4e588ca4f 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -90,6 +90,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_force_reclaim_guest_page,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_reclaim_dying_guest_page,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index eb2a6258d83d..4c069f875a85 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -114,6 +114,12 @@ enum kvm_invalid_pte_type {
>  	 * ownership.
>  	 */
>  	KVM_HOST_INVALID_PTE_TYPE_DONATION,
> +
> +	/*
> +	 * The page has been forcefully reclaimed from the guest by the
> +	 * host.
> +	 */
> +	KVM_GUEST_INVALID_PTE_TYPE_POISONED,
>  };
>  
>  static inline bool kvm_pte_valid(kvm_pte_t pte)
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index cde38a556049..f27b037abaf3 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -41,6 +41,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
> +int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys);
>  int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
>  			    enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index dee1a406b0c2..4cedb720c75d 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -30,6 +30,12 @@ enum pkvm_page_state {
>  	 * struct hyp_page.
>  	 */
>  	PKVM_NOPAGE			= BIT(0) | BIT(1),
> +
> +	/*
> +	 * 'Meta-states' which aren't encoded directly in the PTE's SW bits (or
> +	 * the hyp_vmemmap entry for the host)
> +	 */
> +	PKVM_POISON			= BIT(2),
>  };
>  #define PKVM_PAGE_STATE_MASK		(BIT(0) | BIT(1))

Looks a bit awkward to me, having the page state encoded using 3 bits, but the
mask only 2 bits.

Thanks,
Alex

>  
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 506831804f64..a5a7bb453f3e 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -78,6 +78,7 @@ int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
>  int __pkvm_start_teardown_vm(pkvm_handle_t handle);
>  int __pkvm_finalize_teardown_vm(pkvm_handle_t handle);
>  
> +struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle);
>  struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
>  					 unsigned int vcpu_idx);
>  void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index f43c50ae2d81..e68b5d24bdad 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -570,6 +570,13 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
>  	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
>  }
>  
> +static void handle___pkvm_force_reclaim_guest_page(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
> +
> +	cpu_reg(host_ctxt, 1) = __pkvm_host_force_reclaim_page_guest(phys);
> +}
> +
>  static void handle___pkvm_reclaim_dying_guest_page(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> @@ -631,6 +638,7 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__pkvm_unreserve_vm),
>  	HANDLE_FUNC(__pkvm_init_vm),
>  	HANDLE_FUNC(__pkvm_init_vcpu),
> +	HANDLE_FUNC(__pkvm_force_reclaim_guest_page),
>  	HANDLE_FUNC(__pkvm_reclaim_dying_guest_page),
>  	HANDLE_FUNC(__pkvm_start_teardown_vm),
>  	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index f4638fe9d77a..49b309b8d7d2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -613,6 +613,35 @@ static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
>  	       FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn);
>  }
>  
> +static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
> +				       u64 *gfn)
> +{
> +	pkvm_handle_t handle;
> +	u64 meta;
> +
> +	if (WARN_ON(kvm_pte_valid(pte)))
> +		return -EINVAL;
> +
> +	if (FIELD_GET(KVM_INVALID_PTE_TYPE_MASK, pte) !=
> +	    KVM_HOST_INVALID_PTE_TYPE_DONATION) {
> +		return -EINVAL;
> +	}
> +
> +	if (FIELD_GET(KVM_HOST_DONATION_PTE_OWNER_MASK, pte) != PKVM_ID_GUEST)
> +		return -EPERM;
> +
> +	meta = FIELD_GET(KVM_HOST_DONATION_PTE_EXTRA_MASK, pte);
> +	handle = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
> +	*vm = get_vm_by_handle(handle);
> +	if (!*vm) {
> +		/* We probably raced with teardown; try again */
> +		return -EAGAIN;
> +	}
> +
> +	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
> +	return 0;
> +}
> +
>  static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
>  {
>  	/*
> @@ -809,8 +838,20 @@ static int __hyp_check_page_state_range(phys_addr_t phys, u64 size, enum pkvm_pa
>  	return 0;
>  }
>  
> +static bool guest_pte_is_poisoned(kvm_pte_t pte)
> +{
> +	if (kvm_pte_valid(pte))
> +		return false;
> +
> +	return FIELD_GET(KVM_INVALID_PTE_TYPE_MASK, pte) ==
> +	       KVM_GUEST_INVALID_PTE_TYPE_POISONED;
> +}
> +
>  static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
>  {
> +	if (guest_pte_is_poisoned(pte))
> +		return PKVM_POISON;
> +
>  	if (!kvm_pte_valid(pte))
>  		return PKVM_NOPAGE;
>  
> @@ -839,6 +880,8 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
>  	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
>  	if (ret)
>  		return ret;
> +	if (guest_pte_is_poisoned(pte))
> +		return -EHWPOISON;
>  	if (!kvm_pte_valid(pte))
>  		return -ENOENT;
>  	if (level != KVM_PGTABLE_LAST_LEVEL)
> @@ -1104,6 +1147,84 @@ static void hyp_poison_page(phys_addr_t phys)
>  	hyp_fixmap_unmap();
>  }
>  
> +static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
> +				      u64 *gfn)
> +{
> +	enum pkvm_page_state state;
> +	kvm_pte_t pte;
> +	s8 level;
> +	int ret;
> +
> +	if (!addr_is_memory(phys))
> +		return -EFAULT;
> +
> +	state = get_host_state(hyp_phys_to_page(phys));
> +	switch (state) {
> +	case PKVM_PAGE_OWNED:
> +	case PKVM_PAGE_SHARED_OWNED:
> +	case PKVM_PAGE_SHARED_BORROWED:
> +		/* The access should no longer fault; try again. */
> +		return -EAGAIN;
> +	case PKVM_NOPAGE:
> +		break;
> +	default:
> +		return -EPERM;
> +	}
> +
> +	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
> +	if (ret)
> +		return ret;
> +
> +	if (WARN_ON(level != KVM_PGTABLE_LAST_LEVEL))
> +		return -EINVAL;
> +
> +	return host_stage2_decode_gfn_meta(pte, vm, gfn);
> +}
> +
> +int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
> +{
> +	struct pkvm_hyp_vm *vm;
> +	u64 gfn, ipa, pa;
> +	kvm_pte_t pte;
> +	int ret;
> +
> +	hyp_spin_lock(&vm_table_lock);
> +	host_lock_component();
> +
> +	ret = host_stage2_get_guest_info(phys, &vm, &gfn);
> +	if (ret)
> +		goto unlock_host;
> +
> +	ipa = hyp_pfn_to_phys(gfn);
> +	guest_lock_component(vm);
> +	ret = get_valid_guest_pte(vm, ipa, &pte, &pa);
> +	if (ret)
> +		goto unlock_guest;
> +
> +	WARN_ON(pa != phys);
> +	if (guest_get_page_state(pte, ipa) != PKVM_PAGE_OWNED) {
> +		ret = -EPERM;
> +		goto unlock_guest;
> +	}
> +
> +	/* We really shouldn't be allocating, so don't pass a memcache */
> +	ret = kvm_pgtable_stage2_annotate(&vm->pgt, ipa, PAGE_SIZE, NULL,
> +					  KVM_GUEST_INVALID_PTE_TYPE_POISONED,
> +					  0);
> +	if (ret)
> +		goto unlock_guest;
> +
> +	hyp_poison_page(phys);
> +	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
> +unlock_guest:
> +	guest_unlock_component(vm);
> +unlock_host:
> +	host_unlock_component();
> +	hyp_spin_unlock(&vm_table_lock);
> +
> +	return ret;
> +}
> +
>  int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
>  {
>  	u64 ipa = hyp_pfn_to_phys(gfn);
> @@ -1138,7 +1259,11 @@ int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
>  	guest_unlock_component(vm);
>  	host_unlock_component();
>  
> -	return ret;
> +	/*
> +	 * -EHWPOISON implies that the page was forcefully reclaimed already
> +	 * so return success for the GUP pin to be dropped.
> +	 */
> +	return ret && ret != -EHWPOISON ? ret : 0;
>  }
>  
>  int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index c5772417372d..2836c68c1ea5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -231,10 +231,12 @@ void pkvm_hyp_vm_table_init(void *tbl)
>  /*
>   * Return the hyp vm structure corresponding to the handle.
>   */
> -static struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle)
> +struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle)
>  {
>  	unsigned int idx = vm_handle_to_idx(handle);
>  
> +	hyp_assert_lock_held(&vm_table_lock);
> +
>  	if (unlikely(idx >= KVM_MAX_PVMS))
>  		return NULL;
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 
> 
