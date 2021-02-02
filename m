Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B501C43381
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 17:13:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F84164F4B
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 17:13:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F84164F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D123A4B148;
	Tue,  2 Feb 2021 12:13:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kE1KNczbrSJZ; Tue,  2 Feb 2021 12:13:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 370224B13D;
	Tue,  2 Feb 2021 12:13:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DB534B0EF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 12:12:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eO8Zcui4R2ci for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 12:12:57 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D06864B0EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 12:12:56 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AD5B864F87;
 Tue,  2 Feb 2021 17:12:55 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l6zET-00BYvb-E7; Tue, 02 Feb 2021 17:12:53 +0000
MIME-Version: 1.0
Date: Tue, 02 Feb 2021 17:12:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v7 2/3] arm64: kvm: Introduce MTE VCPU feature
In-Reply-To: <20210115152811.8398-3-steven.price@arm.com>
References: <20210115152811.8398-1-steven.price@arm.com>
 <20210115152811.8398-3-steven.price@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <0c0adbcd250690f703ac4a28faf99263@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Dave.Martin@arm.com, mark.rutland@arm.com, tglx@linutronix.de,
 qemu-devel@nongnu.org, quintela@redhat.com, dgilbert@redhat.com,
 richard.henderson@linaro.org, peter.maydell@linaro.org, Haibo.Xu@arm.com,
 drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-01-15 15:28, Steven Price wrote:
> Add a new VM feature 'KVM_ARM_CAP_MTE' which enables memory tagging
> for a VM. This exposes the feature to the guest and automatically tags
> memory pages touched by the VM as PG_mte_tagged (and clears the tags
> storage) to ensure that the guest cannot see stale tags, and so that 
> the
> tags are correctly saved/restored across swap.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  3 +++
>  arch/arm64/include/asm/kvm_host.h    |  3 +++
>  arch/arm64/include/asm/pgtable.h     |  2 +-
>  arch/arm64/kernel/mte.c              | 36 +++++++++++++++++-----------
>  arch/arm64/kvm/arm.c                 |  9 +++++++
>  arch/arm64/kvm/hyp/exception.c       |  3 ++-
>  arch/arm64/kvm/mmu.c                 | 16 +++++++++++++
>  arch/arm64/kvm/sys_regs.c            |  6 ++++-
>  include/uapi/linux/kvm.h             |  1 +
>  9 files changed, 62 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h
> b/arch/arm64/include/asm/kvm_emulate.h
> index f612c090f2e4..6bf776c2399c 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -84,6 +84,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu 
> *vcpu)
>  	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
>  	    vcpu_el1_is_32bit(vcpu))
>  		vcpu->arch.hcr_el2 |= HCR_TID2;
> +
> +	if (kvm_has_mte(vcpu->kvm))
> +		vcpu->arch.hcr_el2 |= HCR_ATA;
>  }
> 
>  static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index 51590a397e4b..1ca5785fb0e9 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -132,6 +132,8 @@ struct kvm_arch {
> 
>  	u8 pfr0_csv2;
>  	u8 pfr0_csv3;
> +	/* Memory Tagging Extension enabled for the guest */
> +	bool mte_enabled;
>  };
> 
>  struct kvm_vcpu_fault_info {
> @@ -749,6 +751,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu 
> *vcpu);
>  #define kvm_arm_vcpu_sve_finalized(vcpu) \
>  	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
> 
> +#define kvm_has_mte(kvm) (system_supports_mte() && 
> (kvm)->arch.mte_enabled)
>  #define kvm_vcpu_has_pmu(vcpu)					\
>  	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
> 
> diff --git a/arch/arm64/include/asm/pgtable.h 
> b/arch/arm64/include/asm/pgtable.h
> index 501562793ce2..27416d52f6a9 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -312,7 +312,7 @@ static inline void set_pte_at(struct mm_struct
> *mm, unsigned long addr,
>  		__sync_icache_dcache(pte);
> 
>  	if (system_supports_mte() &&
> -	    pte_present(pte) && pte_tagged(pte) && !pte_special(pte))
> +	    pte_present(pte) && pte_valid_user(pte) && !pte_special(pte))
>  		mte_sync_tags(ptep, pte);

Care to elaborate on this change?

> 
>  	__check_racy_pte_update(mm, ptep, pte);
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index dc9ada64feed..f9e089be1603 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -25,27 +25,33 @@
> 
>  u64 gcr_kernel_excl __ro_after_init;
> 
> -static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool 
> check_swap)
> +static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool 
> check_swap,
> +			       bool pte_is_tagged)
>  {
>  	pte_t old_pte = READ_ONCE(*ptep);
> 
>  	if (check_swap && is_swap_pte(old_pte)) {
>  		swp_entry_t entry = pte_to_swp_entry(old_pte);
> 
> -		if (!non_swap_entry(entry) && mte_restore_tags(entry, page))
> +		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
> +			set_bit(PG_mte_tagged, &page->flags);
>  			return;
> +		}
>  	}
> 
> -	page_kasan_tag_reset(page);
> -	/*
> -	 * We need smp_wmb() in between setting the flags and clearing the
> -	 * tags because if another thread reads page->flags and builds a
> -	 * tagged address out of it, there is an actual dependency to the
> -	 * memory access, but on the current thread we do not guarantee that
> -	 * the new page->flags are visible before the tags were updated.
> -	 */
> -	smp_wmb();
> -	mte_clear_page_tags(page_address(page));
> +	if (pte_is_tagged) {
> +		set_bit(PG_mte_tagged, &page->flags);
> +		page_kasan_tag_reset(page);
> +		/*
> +		 * We need smp_wmb() in between setting the flags and clearing the
> +		 * tags because if another thread reads page->flags and builds a
> +		 * tagged address out of it, there is an actual dependency to the
> +		 * memory access, but on the current thread we do not guarantee that
> +		 * the new page->flags are visible before the tags were updated.
> +		 */
> +		smp_wmb();
> +		mte_clear_page_tags(page_address(page));
> +	}
>  }
> 
>  void mte_sync_tags(pte_t *ptep, pte_t pte)
> @@ -53,11 +59,13 @@ void mte_sync_tags(pte_t *ptep, pte_t pte)
>  	struct page *page = pte_page(pte);
>  	long i, nr_pages = compound_nr(page);
>  	bool check_swap = nr_pages == 1;
> +	bool pte_is_tagged = pte_tagged(pte);
> 
>  	/* if PG_mte_tagged is set, tags have already been initialised */
>  	for (i = 0; i < nr_pages; i++, page++) {
> -		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> -			mte_sync_page_tags(page, ptep, check_swap);
> +		if (!test_bit(PG_mte_tagged, &page->flags))
> +			mte_sync_page_tags(page, ptep, check_swap,
> +					   pte_is_tagged);
>  	}
>  }

This part really wants to have its own patch and be documented,
explaining why it is still valid not to atomically test and set
the PG_mte_tagged bit.

> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6e637d2b4cfb..f4c2fd2e7c49 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -97,6 +97,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		kvm->arch.return_nisv_io_abort_to_user = true;
>  		break;
> +	case KVM_CAP_ARM_MTE:
> +		if (!system_supports_mte() || kvm->created_vcpus)
> +			return -EINVAL;
> +		r = 0;
> +		kvm->arch.mte_enabled = true;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -238,6 +244,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
> long ext)
>  		 */
>  		r = 1;
>  		break;
> +	case KVM_CAP_ARM_MTE:
> +		r = system_supports_mte();
> +		break;
>  	case KVM_CAP_STEAL_TIME:
>  		r = kvm_arm_pvtime_supported();
>  		break;
> diff --git a/arch/arm64/kvm/hyp/exception.c 
> b/arch/arm64/kvm/hyp/exception.c
> index 73629094f903..56426565600c 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -112,7 +112,8 @@ static void enter_exception64(struct kvm_vcpu
> *vcpu, unsigned long target_mode,
>  	new |= (old & PSR_C_BIT);
>  	new |= (old & PSR_V_BIT);
> 
> -	// TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
> +	if (kvm_has_mte(vcpu->kvm))
> +		new |= PSR_TCO_BIT;
> 
>  	new |= (old & PSR_DIT_BIT);
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7d2257cc5438..b9f9fb462de6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -879,6 +879,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu,
> phys_addr_t fault_ipa,
>  	if (vma_pagesize == PAGE_SIZE && !force_pte)
>  		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>  							   &pfn, &fault_ipa);
> +
> +	if (kvm_has_mte(kvm) && pfn_valid(pfn)) {
> +		/*
> +		 * VM will be able to see the page's tags, so we must ensure
> +		 * they have been initialised.
> +		 */
> +		struct page *page = pfn_to_page(pfn);
> +		long i, nr_pages = compound_nr(page);

"unsigned long" to match the return type of compound_nr().

Also, shouldn't you cap nr_pages to vma_pagesize? It could well
be that what we end-up mapping at S2 has nothing to do with
the view the kernel has of that page.

> +
> +		/* if PG_mte_tagged is set, tags have already been initialised */
> +		for (i = 0; i < nr_pages; i++, page++) {
> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> +				mte_clear_page_tags(page_address(page));
> +		}
> +	}
> +
>  	if (writable) {
>  		prot |= KVM_PGTABLE_PROT_W;
>  		kvm_set_pfn_dirty(pfn);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 88d4f360949e..57e5be14f1cc 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1029,7 +1029,8 @@ static u64 read_id_reg(const struct kvm_vcpu 
> *vcpu,
>  		val &= ~(0xfUL << ID_AA64PFR0_CSV3_SHIFT);
>  		val |= ((u64)vcpu->kvm->arch.pfr0_csv3 << ID_AA64PFR0_CSV3_SHIFT);
>  	} else if (id == SYS_ID_AA64PFR1_EL1) {
> -		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
> +		if (!kvm_has_mte(vcpu->kvm))
> +			val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
>  	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
>  		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
>  			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> @@ -1284,6 +1285,9 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu,
> struct sys_reg_params *p,
>  static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>  				   const struct sys_reg_desc *rd)
>  {
> +	if (kvm_has_mte(vcpu->kvm))
> +		return 0;
> +
>  	return REG_HIDDEN;
>  }
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 886802b8ffba..de737d5102ca 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1056,6 +1056,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
>  #define KVM_CAP_SYS_HYPERV_CPUID 191
>  #define KVM_CAP_DIRTY_LOG_RING 192
> +#define KVM_CAP_ARM_MTE 193
> 
>  #ifdef KVM_CAP_IRQ_ROUTING

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
