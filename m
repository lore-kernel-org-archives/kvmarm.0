Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7304D271443;
	Thu, 19 Mar 2026 17:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940652; cv=none; b=oiFR0Q8GPNPXqK8bEZD9XMh7eeVrR8RLvyFcE8AYjJJR4aPbE2aQsyBFeFVK9NeauQ5xCIkAlntDKksynTycGqwZkfobxz0zClv3tXOKWAg09Z4vOHtmty3sY6TivQPERc2eyOhOvfbk4er/29EyIQapGBxNWHDNFpXXiaxhKkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940652; c=relaxed/simple;
	bh=Jqs9AWTrx3FXSpL1SJ7C6JupKuzJ3o0VOx9jv7F8Ex8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXzCLRFsrjo7KV0kUKxMH7hcLYP8HMe2CGl0XF3JnmBxCj1KXqUyPjYLFK26HX9NSpsZJC/b3px2Ez3qUe79BzbU6lR2pr+CHzp39xLTNqcHRdBLbe7gYUJfQntB9iiIb+sFN0VHoaQVCC4l2TLtdA18i01x8SgmmPr61KNP3NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBC4C2247;
	Thu, 19 Mar 2026 10:17:22 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 869733F778;
	Thu, 19 Mar 2026 10:17:23 -0700 (PDT)
Date: Thu, 19 Mar 2026 17:17:16 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v13 12/48] arm64: RMI: Basic infrastructure for creating
 a realm.
Message-ID: <izfo7i46qpfdhakm6hcr4klig5kt3kokwh5onxkxl2a6imsvvu@2k6kfovd66kk>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-13-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318155413.793430-13-steven.price@arm.com>

On Wed, Mar 18, 2026 at 03:53:36PM +0000, Steven Price wrote:
> Introduce the skeleton functions for creating and destroying a realm.
> The IPA size requested is checked against what the RMM supports.
> 
> The actual work of constructing the realm will be added in future
> patches.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v12:
>  * Drop the RMM_PAGE_{SHIFT,SIZE} defines - the RMM is now configured to
>    be the same as the host's page size.
>  * Rework delegate/undelegate functions to use the new RMI range based
>    operations.
> Changes since v11:
>  * Major rework to drop the realm configuration and make the
>    construction of realms implicit rather than driven by the VMM
>    directly.
>  * The code to create RDs, handle VMIDs etc is moved to later patches.
> Changes since v10:
>  * Rename from RME to RMI.
>  * Move the stage2 cleanup to a later patch.
> Changes since v9:
>  * Avoid walking the stage 2 page tables when destroying the realm -
>    the real ones are not accessible to the non-secure world, and the RMM
>    may leave junk in the physical pages when returning them.
>  * Fix an error path in realm_create_rd() to actually return an error value.
> Changes since v8:
>  * Fix free_delegated_granule() to not call kvm_account_pgtable_pages();
>    a separate wrapper will be introduced in a later patch to deal with
>    RTTs.
>  * Minor code cleanups following review.
> Changes since v7:
>  * Minor code cleanup following Gavin's review.
> Changes since v6:
>  * Separate RMM RTT calculations from host PAGE_SIZE. This allows the
>    host page size to be larger than 4k while still communicating with an
>    RMM which uses 4k granules.
> Changes since v5:
>  * Introduce free_delegated_granule() to replace many
>    undelegate/free_page() instances and centralise the comment on
>    leaking when the undelegate fails.
>  * Several other minor improvements suggested by reviews - thanks for
>    the feedback!
> Changes since v2:
>  * Improved commit description.
>  * Improved return failures for rmi_check_version().
>  * Clear contents of PGD after it has been undelegated in case the RMM
>    left stale data.
>  * Minor changes to reflect changes in previous patches.
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  5 ++
>  arch/arm64/include/asm/kvm_rmi.h     | 16 +++++
>  arch/arm64/kvm/arm.c                 | 12 ++++
>  arch/arm64/kvm/mmu.c                 | 11 +++-
>  arch/arm64/kvm/rmi.c                 | 88 ++++++++++++++++++++++++++++
>  5 files changed, 129 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f38b50151ce8..39310d9b4e16 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -701,6 +701,11 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>  	return READ_ONCE(kvm->arch.realm.state);
>  }
>  
> +static inline bool kvm_realm_is_created(struct kvm *kvm)
> +{
> +	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
> +}
> +
>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>  {
>  	return false;
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 3506f50b05cd..0ada525af18f 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -6,6 +6,8 @@
>  #ifndef __ASM_KVM_RMI_H
>  #define __ASM_KVM_RMI_H
>  
> +#include <asm/rmi_smc.h>
> +
>  /**
>   * enum realm_state - State of a Realm
>   */
> @@ -46,11 +48,25 @@ enum realm_state {
>   * struct realm - Additional per VM data for a Realm
>   *
>   * @state: The lifetime state machine for the realm
> + * @rd: Kernel mapping of the Realm Descriptor (RD)
> + * @params: Parameters for the RMI_REALM_CREATE command
> + * @num_aux: The number of auxiliary pages required by the RMM
> + * @ia_bits: Number of valid Input Address bits in the IPA
>   */
>  struct realm {
>  	enum realm_state state;
> +
> +	void *rd;
> +	struct realm_params *params;
> +
> +	unsigned long num_aux;
> +	unsigned int ia_bits;
>  };
>  
>  void kvm_init_rmi(void);
> +u32 kvm_realm_ipa_limit(void);
> +
> +int kvm_init_realm_vm(struct kvm *kvm);
> +void kvm_destroy_realm(struct kvm *kvm);

Hi,

Sorry I missed one nit: perhaps call this kvm_init_realm()? So these two
look like a pair. There are also no realm_vm in other function names.

Thanks,
Wei-Lin Chang

>  
>  #endif /* __ASM_KVM_RMI_H */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 274d7866efdc..9b17bdfaf0c2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -253,6 +253,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>  
> +	/* Initialise the realm bits after the generic bits are enabled */
> +	if (kvm_is_realm(kvm)) {
> +		ret = kvm_init_realm_vm(kvm);
> +		if (ret)
> +			goto err_free_cpumask;
> +	}
> +
>  	return 0;
>  
>  err_free_cpumask:
> @@ -312,6 +319,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_unshare_hyp(kvm, kvm + 1);
>  
>  	kvm_arm_teardown_hypercalls(kvm);
> +	if (kvm_is_realm(kvm))
> +		kvm_destroy_realm(kvm);
>  }
>  
>  static bool kvm_has_full_ptr_auth(void)
> @@ -473,6 +482,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		else
>  			r = kvm_supports_cacheable_pfnmap();
>  		break;
> +	case KVM_CAP_ARM_RMI:
> +		r = static_key_enabled(&kvm_rmi_is_available);
> +		break;
>  
>  	default:
>  		r = 0;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 070a01e53fcb..d6094b60c4ce 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -872,12 +872,16 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.icache_inval_pou	= invalidate_icache_guest_page,
>  };
>  
> -static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
> +static int kvm_init_ipa_range(struct kvm *kvm,
> +			      struct kvm_s2_mmu *mmu, unsigned long type)
>  {
>  	u32 kvm_ipa_limit = get_kvm_ipa_limit();
>  	u64 mmfr0, mmfr1;
>  	u32 phys_shift;
>  
> +	if (kvm_is_realm(kvm))
> +		kvm_ipa_limit = kvm_realm_ipa_limit();
> +
>  	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>  		return -EINVAL;
>  
> @@ -974,7 +978,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  		return -EINVAL;
>  	}
>  
> -	err = kvm_init_ipa_range(mmu, type);
> +	err = kvm_init_ipa_range(kvm, mmu, type);
>  	if (err)
>  		return err;
>  
> @@ -1113,7 +1117,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	write_unlock(&kvm->mmu_lock);
>  
>  	if (pgt) {
> -		kvm_stage2_destroy(pgt);
> +		if (!kvm_is_realm(kvm))
> +			kvm_stage2_destroy(pgt);
>  		kfree(pgt);
>  	}
>  }
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 80aedc85e94a..700b8c935d29 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -6,6 +6,8 @@
>  #include <linux/kvm_host.h>
>  #include <linux/memblock.h>
>  
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
>  #include <asm/rmi_cmds.h>
>  #include <asm/virt.h>
> @@ -182,6 +184,92 @@ static int rmi_init_metadata(void)
>  	return 0;
>  }
>  
> +u32 kvm_realm_ipa_limit(void)
> +{
> +	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> +}
> +
> +static int undelegate_range(phys_addr_t phys, unsigned long size)
> +{
> +	unsigned long ret;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_undelegate(phys, top, &out_top);
> +		if (ret == RMI_SUCCESS)
> +			phys = out_top;
> +		else if (ret != RMI_BUSY && ret != RMI_BLOCKED)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int undelegate_page(phys_addr_t phys)
> +{
> +	return undelegate_range(phys, PAGE_SIZE);
> +}
> +
> +static int free_delegated_page(phys_addr_t phys)
> +{
> +	if (WARN_ON(undelegate_page(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return -EBUSY;
> +	}
> +
> +	free_page((unsigned long)phys_to_virt(phys));
> +
> +	return 0;
> +}
> +
> +void kvm_destroy_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> +
> +	write_lock(&kvm->mmu_lock);
> +	kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
> +			       BIT(realm->ia_bits - 1), true);
> +	write_unlock(&kvm->mmu_lock);
> +
> +	if (realm->params) {
> +		free_page((unsigned long)realm->params);
> +		realm->params = NULL;
> +	}
> +
> +	if (!kvm_realm_is_created(kvm))
> +		return;
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DYING);
> +
> +	if (realm->rd) {
> +		phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +
> +		if (WARN_ON(rmi_realm_destroy(rd_phys)))
> +			return;
> +		free_delegated_page(rd_phys);
> +		realm->rd = NULL;
> +	}
> +
> +	if (WARN_ON(undelegate_range(kvm->arch.mmu.pgd_phys, pgd_size)))
> +		return;
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
> +
> +	/* Now that the Realm is destroyed, free the entry level RTTs */
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
> +int kvm_init_realm_vm(struct kvm *kvm)
> +{
> +	kvm->arch.realm.params = (void *)get_zeroed_page(GFP_KERNEL);
> +
> +	if (!kvm->arch.realm.params)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
>  static int rmm_check_features(void)
>  {
>  	if (kvm_lpa2_is_enabled() && !rmi_has_feature(RMI_FEATURE_REGISTER_0_LPA2)) {
> -- 
> 2.43.0
> 
