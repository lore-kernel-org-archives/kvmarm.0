Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DEA1DA3F
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6300143D;
	Fri, 20 Oct 2023 08:12:38 -0700 (PDT)
Received: from [10.1.30.154] (XHFQ2J9959.cambridge.arm.com [10.1.30.154])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50F823F762;
	Fri, 20 Oct 2023 08:11:56 -0700 (PDT)
Message-ID: <0ac903d9-7e97-4292-beeb-f204840daad8@arm.com>
Date: Fri, 20 Oct 2023 16:11:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/12] KVM: arm64: Convert translation level parameter
 to s8
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
 <20231009185008.3803879-9-ryan.roberts@arm.com>
 <868r7xmv7f.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <868r7xmv7f.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2023 11:42, Marc Zyngier wrote:
> On Mon, 09 Oct 2023 19:50:04 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> With the introduction of FEAT_LPA2, the Arm ARM adds a new level of
>> translation, level -1, so levels can now be in the range [-1;3]. 3 is
>> always the last level and the first level is determined based on the
>> number of VA bits in use.
>>
>> Convert level variables to use a signed type in preparation for
>> supporting this new level -1.
>>
>> Since the last level is always anchored at 3, and the first level varies
>> to suit the number of VA/IPA bits, take the opportunity to replace
>> KVM_PGTABLE_MAX_LEVELS with the 2 macros KVM_PGTABLE_FIRST_LEVEL and
>> KVM_PGTABLE_LAST_LEVEL. This removes the assumption from the code that
>> levels run from 0 to KVM_PGTABLE_MAX_LEVELS - 1, which will soon no
>> longer be true.
>>
>> No behavioral changes intended.
> 
> Shrug. Unless you have compared the binaries before and after and
> proven that they are strictly identical, there will be behaviour
> changes, intended or otherwise.
> 
> I know what you're trying to convey, but I've seen so many patches
> carrying a sentence of this sort and yet turning the kernel on its
> head that I've become allergic to it. Sorry.

I picked this habit up from other KVM patches, so assumed it was preferred
practice. I'll remove, and avoid in future.

> 
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h  |  2 +-
>>  arch/arm64/include/asm/kvm_pgtable.h  | 31 ++++++-------
>>  arch/arm64/include/asm/kvm_pkvm.h     |  5 ++-
>>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +--
>>  arch/arm64/kvm/hyp/nvhe/mm.c          |  4 +-
>>  arch/arm64/kvm/hyp/nvhe/setup.c       |  2 +-
>>  arch/arm64/kvm/hyp/pgtable.c          | 64 ++++++++++++++-------------
>>  arch/arm64/kvm/mmu.c                  | 16 ++++---
>>  8 files changed, 69 insertions(+), 61 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 3d6725ff0bf6..bf3ef66eb51f 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -404,7 +404,7 @@ static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vc
>>  	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
>>  }
>>  
>> -static __always_inline u8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
>> +static __always_inline s8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
>>  {
>>  	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_LEVEL;
>>  }
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index b240158e1218..c61bb9709201 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -11,7 +11,8 @@
>>  #include <linux/kvm_host.h>
>>  #include <linux/types.h>
>>  
>> -#define KVM_PGTABLE_MAX_LEVELS		4U
>> +#define KVM_PGTABLE_FIRST_LEVEL		0
>> +#define KVM_PGTABLE_LAST_LEVEL		3
>>  
>>  /*
>>   * The largest supported block sizes for KVM (no 52-bit PA support):
>> @@ -20,9 +21,9 @@
>>   *  - 64K (level 2):	512MB
>>   */
>>  #ifdef CONFIG_ARM64_4K_PAGES
>> -#define KVM_PGTABLE_MIN_BLOCK_LEVEL	1U
>> +#define KVM_PGTABLE_MIN_BLOCK_LEVEL	1
>>  #else
>> -#define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
>> +#define KVM_PGTABLE_MIN_BLOCK_LEVEL	2
>>  #endif
>>  
>>  static inline u64 kvm_get_parange_max(void)
>> @@ -101,28 +102,28 @@ static inline kvm_pfn_t kvm_pte_to_pfn(kvm_pte_t pte)
>>  	return __phys_to_pfn(kvm_pte_to_phys(pte));
>>  }
>>  
>> -static inline u64 kvm_granule_shift(u32 level)
>> +static inline u64 kvm_granule_shift(s8 level)
>>  {
>> -	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
>> +	/* Assumes KVM_PGTABLE_LAST_LEVEL is 3 */
>>  	return ARM64_HW_PGTABLE_LEVEL_SHIFT(level);
> 
> I'm amazed that the macro tolerates a negative level, but it really
> does.

Yep. I remember I spent quite a while convincing myself of this, because I also
initially assumed that it would not.

> 
>>  }
>>  
>> -static inline u64 kvm_granule_size(u32 level)
>> +static inline u64 kvm_granule_size(s8 level)
>>  {
>>  	return BIT(kvm_granule_shift(level));
>>  }
>>  
>> -static inline bool kvm_level_supports_block_mapping(u32 level)
>> +static inline bool kvm_level_supports_block_mapping(s8 level)
>>  {
>>  	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
>>  }
>>  
>>  static inline u32 kvm_supported_block_sizes(void)
>>  {
>> -	u32 level = KVM_PGTABLE_MIN_BLOCK_LEVEL;
>> +	s8 level = KVM_PGTABLE_MIN_BLOCK_LEVEL;
>>  	u32 r = 0;
>>  
>> -	for (; level < KVM_PGTABLE_MAX_LEVELS; level++)
>> +	for (; level <= KVM_PGTABLE_LAST_LEVEL; level++)
>>  		r |= BIT(kvm_granule_shift(level));
>>  
>>  	return r;
>> @@ -167,7 +168,7 @@ struct kvm_pgtable_mm_ops {
>>  	void*		(*zalloc_page)(void *arg);
>>  	void*		(*zalloc_pages_exact)(size_t size);
>>  	void		(*free_pages_exact)(void *addr, size_t size);
>> -	void		(*free_unlinked_table)(void *addr, u32 level);
>> +	void		(*free_unlinked_table)(void *addr, s8 level);
>>  	void		(*get_page)(void *addr);
>>  	void		(*put_page)(void *addr);
>>  	int		(*page_count)(void *addr);
>> @@ -263,7 +264,7 @@ struct kvm_pgtable_visit_ctx {
>>  	u64					start;
>>  	u64					addr;
>>  	u64					end;
>> -	u32					level;
>> +	s8					level;
>>  	enum kvm_pgtable_walk_flags		flags;
>>  };
>>  
>> @@ -366,7 +367,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
>>   */
>>  struct kvm_pgtable {
>>  	u32					ia_bits;
>> -	u32					start_level;
>> +	s8					start_level;
>>  	kvm_pteref_t				pgd;
>>  	struct kvm_pgtable_mm_ops		*mm_ops;
>>  
>> @@ -500,7 +501,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>>   * The page-table is assumed to be unreachable by any hardware walkers prior to
>>   * freeing and therefore no TLB invalidation is performed.
>>   */
>> -void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>> +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level);
>>  
>>  /**
>>   * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
>> @@ -524,7 +525,7 @@ void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *p
>>   * an ERR_PTR(error) on failure.
>>   */
>>  kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>> -					      u64 phys, u32 level,
>> +					      u64 phys, s8 level,
>>  					      enum kvm_pgtable_prot prot,
>>  					      void *mc, bool force_pte);
>>  
>> @@ -750,7 +751,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>   * Return: 0 on success, negative error code on failure.
>>   */
>>  int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
>> -			 kvm_pte_t *ptep, u32 *level);
>> +			 kvm_pte_t *ptep, s8 *level);
>>  
>>  /**
>>   * kvm_pgtable_stage2_pte_prot() - Retrieve the protection attributes of a
>> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
>> index e46250a02017..ad9cfb5c1ff4 100644
>> --- a/arch/arm64/include/asm/kvm_pkvm.h
>> +++ b/arch/arm64/include/asm/kvm_pkvm.h
>> @@ -56,10 +56,11 @@ static inline unsigned long hyp_vm_table_pages(void)
>>  
>>  static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
>>  {
>> -	unsigned long total = 0, i;
>> +	unsigned long total = 0;
>> +	int i;
>>  
>>  	/* Provision the worst case scenario */
>> -	for (i = 0; i < KVM_PGTABLE_MAX_LEVELS; i++) {
>> +	for (i = KVM_PGTABLE_FIRST_LEVEL; i <= KVM_PGTABLE_LAST_LEVEL; i++) {
>>  		nr_pages = DIV_ROUND_UP(nr_pages, PTRS_PER_PTE);
>>  		total += nr_pages;
>>  	}
>> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
>> index 9d703441278b..2cfb6352a8ea 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
>> @@ -91,7 +91,7 @@ static void host_s2_put_page(void *addr)
>>  	hyp_put_page(&host_s2_pool, addr);
>>  }
>>  
>> -static void host_s2_free_unlinked_table(void *addr, u32 level)
>> +static void host_s2_free_unlinked_table(void *addr, s8 level)
>>  {
>>  	kvm_pgtable_stage2_free_unlinked(&host_mmu.mm_ops, addr, level);
>>  }
>> @@ -443,7 +443,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
>>  {
>>  	struct kvm_mem_range cur;
>>  	kvm_pte_t pte;
>> -	u32 level;
>> +	s8 level;
>>  	int ret;
>>  
>>  	hyp_assert_lock_held(&host_mmu.lock);
>> @@ -462,7 +462,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
>>  		cur.start = ALIGN_DOWN(addr, granule);
>>  		cur.end = cur.start + granule;
>>  		level++;
>> -	} while ((level < KVM_PGTABLE_MAX_LEVELS) &&
>> +	} while ((level <= KVM_PGTABLE_LAST_LEVEL) &&
>>  			!(kvm_level_supports_block_mapping(level) &&
>>  			  range_included(&cur, range)));
>>  
>> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
>> index 65a7a186d7b2..b01a3d1078a8 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
>> @@ -260,7 +260,7 @@ static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
>>  	 * https://lore.kernel.org/kvm/20221017115209.2099-1-will@kernel.org/T/#mf10dfbaf1eaef9274c581b81c53758918c1d0f03
>>  	 */
>>  	dsb(ishst);
>> -	__tlbi_level(vale2is, __TLBI_VADDR(addr, 0), (KVM_PGTABLE_MAX_LEVELS - 1));
>> +	__tlbi_level(vale2is, __TLBI_VADDR(addr, 0), KVM_PGTABLE_LAST_LEVEL);
>>  	dsb(ish);
>>  	isb();
>>  }
>> @@ -275,7 +275,7 @@ static int __create_fixmap_slot_cb(const struct kvm_pgtable_visit_ctx *ctx,
>>  {
>>  	struct hyp_fixmap_slot *slot = per_cpu_ptr(&fixmap_slots, (u64)ctx->arg);
>>  
>> -	if (!kvm_pte_valid(ctx->old) || ctx->level != KVM_PGTABLE_MAX_LEVELS - 1)
>> +	if (!kvm_pte_valid(ctx->old) || ctx->level != KVM_PGTABLE_LAST_LEVEL)
>>  		return -EINVAL;
>>  
>>  	slot->addr = ctx->addr;
>> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
>> index 0d5e0a89ddce..bc58d1b515af 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
>> @@ -181,7 +181,7 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>  	if (!kvm_pte_valid(ctx->old))
>>  		return 0;
>>  
>> -	if (ctx->level != (KVM_PGTABLE_MAX_LEVELS - 1))
>> +	if (ctx->level != KVM_PGTABLE_LAST_LEVEL)
>>  		return -EINVAL;
>>  
>>  	phys = kvm_pte_to_phys(ctx->old);
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index 062eb7bcdb8a..8e79ff6972ce 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -101,7 +101,7 @@ static bool kvm_block_mapping_supported(const struct kvm_pgtable_visit_ctx *ctx,
>>  	return IS_ALIGNED(ctx->addr, granule);
>>  }
>>  
>> -static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
>> +static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, s8 level)
>>  {
>>  	u64 shift = kvm_granule_shift(level);
>>  	u64 mask = BIT(PAGE_SHIFT - 3) - 1;
>> @@ -117,7 +117,7 @@ static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>>  	return (addr & mask) >> shift;
>>  }
>>  
>> -static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>> +static u32 kvm_pgd_pages(u32 ia_bits, s8 start_level)
>>  {
>>  	struct kvm_pgtable pgt = {
>>  		.ia_bits	= ia_bits,
>> @@ -127,9 +127,9 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>>  	return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>>  }
>>  
>> -static bool kvm_pte_table(kvm_pte_t pte, u32 level)
>> +static bool kvm_pte_table(kvm_pte_t pte, s8 level)
>>  {
>> -	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
>> +	if (level == KVM_PGTABLE_LAST_LEVEL)
>>  		return false;
>>  
>>  	if (!kvm_pte_valid(pte))
>> @@ -157,11 +157,11 @@ static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops
>>  	return pte;
>>  }
>>  
>> -static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
>> +static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, s8 level)
>>  {
>>  	kvm_pte_t pte = kvm_phys_to_pte(pa);
>> -	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
>> -							   KVM_PTE_TYPE_BLOCK;
>> +	u64 type = (level == KVM_PGTABLE_LAST_LEVEL) ? KVM_PTE_TYPE_PAGE :
>> +						       KVM_PTE_TYPE_BLOCK;
>>  
>>  	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI);
>>  	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
>> @@ -206,11 +206,11 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
>>  }
>>  
>>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>> -			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
>> +			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, s8 level);
>>  
>>  static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>>  				      struct kvm_pgtable_mm_ops *mm_ops,
>> -				      kvm_pteref_t pteref, u32 level)
>> +				      kvm_pteref_t pteref, s8 level)
>>  {
>>  	enum kvm_pgtable_walk_flags flags = data->walker->flags;
>>  	kvm_pte_t *ptep = kvm_dereference_pteref(data->walker, pteref);
>> @@ -275,12 +275,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>>  }
>>  
>>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>> -			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level)
>> +			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, s8 level)
>>  {
>>  	u32 idx;
>>  	int ret = 0;
>>  
>> -	if (WARN_ON_ONCE(level >= KVM_PGTABLE_MAX_LEVELS))
>> +	if (WARN_ON_ONCE(level > KVM_PGTABLE_LAST_LEVEL))
>>  		return -EINVAL;
> 
> Now that level can be negative, you may want to check it against
> KVM_PGTABLE_FIRST_LEVEL as well.

ACK.

> 
>>  
>>  	for (idx = kvm_pgtable_idx(data, level); idx < PTRS_PER_PTE; ++idx) {
>> @@ -343,7 +343,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>  
>>  struct leaf_walk_data {
>>  	kvm_pte_t	pte;
>> -	u32		level;
>> +	s8		level;
>>  };
>>  
>>  static int leaf_walker(const struct kvm_pgtable_visit_ctx *ctx,
>> @@ -358,7 +358,7 @@ static int leaf_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>  }
>>  
>>  int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
>> -			 kvm_pte_t *ptep, u32 *level)
>> +			 kvm_pte_t *ptep, s8 *level)
>>  {
>>  	struct leaf_walk_data data;
>>  	struct kvm_pgtable_walker walker = {
>> @@ -471,7 +471,7 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>  	if (hyp_map_walker_try_leaf(ctx, data))
>>  		return 0;
>>  
>> -	if (WARN_ON(ctx->level == KVM_PGTABLE_MAX_LEVELS - 1))
>> +	if (WARN_ON(ctx->level == KVM_PGTABLE_LAST_LEVEL))
>>  		return -EINVAL;
> 
> Same thing.

ACK.

> 
>>  
>>  	childp = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
>> @@ -567,14 +567,18 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>>  int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
>>  			 struct kvm_pgtable_mm_ops *mm_ops)
>>  {
>> -	u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
>> +	s8 start_level = KVM_PGTABLE_LAST_LEVEL + 1 -
>> +			 ARM64_HW_PGTABLE_LEVELS(va_bits);
>> +	if (start_level < KVM_PGTABLE_FIRST_LEVEL ||
>> +	    start_level > KVM_PGTABLE_LAST_LEVEL)
>> +		return -EINVAL;
> 
> Please add a new line between the variable definition and the if ()
> statement.

Hmm, I'm surprised that check_patch.pl didn't flag this. Or more likely I
somehow didn't run it for this patch...

> 
>>  
>>  	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_page(NULL);
>>  	if (!pgt->pgd)
>>  		return -ENOMEM;
>>  
>>  	pgt->ia_bits		= va_bits;
>> -	pgt->start_level	= KVM_PGTABLE_MAX_LEVELS - levels;
>> +	pgt->start_level	= start_level;
>>  	pgt->mm_ops		= mm_ops;
>>  	pgt->mmu		= NULL;
>>  	pgt->force_pte_cb	= NULL;
>> @@ -628,7 +632,7 @@ struct stage2_map_data {
>>  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>>  {
>>  	u64 vtcr = VTCR_EL2_FLAGS;
>> -	u8 lvls;
>> +	s8 lvls;
>>  
>>  	vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
>>  	vtcr |= VTCR_EL2_T0SZ(phys_shift);
>> @@ -911,7 +915,7 @@ static bool stage2_leaf_mapping_allowed(const struct kvm_pgtable_visit_ctx *ctx,
>>  {
>>  	u64 phys = stage2_map_walker_phys_addr(ctx, data);
>>  
>> -	if (data->force_pte && (ctx->level < (KVM_PGTABLE_MAX_LEVELS - 1)))
>> +	if (data->force_pte && ctx->level < KVM_PGTABLE_LAST_LEVEL)
>>  		return false;
>>  
>>  	return kvm_block_mapping_supported(ctx, phys);
>> @@ -990,7 +994,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>>  	if (ret != -E2BIG)
>>  		return ret;
>>  
>> -	if (WARN_ON(ctx->level == KVM_PGTABLE_MAX_LEVELS - 1))
>> +	if (WARN_ON(ctx->level == KVM_PGTABLE_LAST_LEVEL))
>>  		return -EINVAL;
>>  
>>  	if (!data->memcache)
>> @@ -1160,7 +1164,7 @@ struct stage2_attr_data {
>>  	kvm_pte_t			attr_set;
>>  	kvm_pte_t			attr_clr;
>>  	kvm_pte_t			pte;
>> -	u32				level;
>> +	s8				level;
>>  };
>>  
>>  static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>> @@ -1203,7 +1207,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>  static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>>  				    u64 size, kvm_pte_t attr_set,
>>  				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
>> -				    u32 *level, enum kvm_pgtable_walk_flags flags)
>> +				    s8 *level, enum kvm_pgtable_walk_flags flags)
>>  {
>>  	int ret;
>>  	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
>> @@ -1305,7 +1309,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>>  				   enum kvm_pgtable_prot prot)
>>  {
>>  	int ret;
>> -	u32 level;
>> +	s8 level;
>>  	kvm_pte_t set = 0, clr = 0;
>>  
>>  	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
>> @@ -1358,7 +1362,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>>  }
>>  
>>  kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>> -					      u64 phys, u32 level,
>> +					      u64 phys, s8 level,
>>  					      enum kvm_pgtable_prot prot,
>>  					      void *mc, bool force_pte)
>>  {
>> @@ -1416,7 +1420,7 @@ kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
>>   * fully populated tree up to the PTE entries. Note that @level is
>>   * interpreted as in "level @level entry".
>>   */
>> -static int stage2_block_get_nr_page_tables(u32 level)
>> +static int stage2_block_get_nr_page_tables(s8 level)
>>  {
>>  	switch (level) {
>>  	case 1:
>> @@ -1427,7 +1431,7 @@ static int stage2_block_get_nr_page_tables(u32 level)
>>  		return 0;
>>  	default:
>>  		WARN_ON_ONCE(level < KVM_PGTABLE_MIN_BLOCK_LEVEL ||
>> -			     level >= KVM_PGTABLE_MAX_LEVELS);
>> +			     level > KVM_PGTABLE_LAST_LEVEL);
>>  		return -EINVAL;
>>  	};
>>  }
>> @@ -1440,13 +1444,13 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
>>  	struct kvm_s2_mmu *mmu;
>>  	kvm_pte_t pte = ctx->old, new, *childp;
>>  	enum kvm_pgtable_prot prot;
>> -	u32 level = ctx->level;
>> +	s8 level = ctx->level;
>>  	bool force_pte;
>>  	int nr_pages;
>>  	u64 phys;
>>  
>>  	/* No huge-pages exist at the last level */
>> -	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
>> +	if (level == KVM_PGTABLE_LAST_LEVEL)
>>  		return 0;
>>  
>>  	/* We only split valid block mappings */
>> @@ -1523,7 +1527,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>>  	u64 vtcr = mmu->arch->vtcr;
>>  	u32 ia_bits = VTCR_EL2_IPA(vtcr);
>>  	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
>> -	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>> +	s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>>  
>>  	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
>>  	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
>> @@ -1546,7 +1550,7 @@ size_t kvm_pgtable_stage2_pgd_size(u64 vtcr)
>>  {
>>  	u32 ia_bits = VTCR_EL2_IPA(vtcr);
>>  	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
>> -	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>> +	s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>>  
>>  	return kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
>>  }
>> @@ -1582,7 +1586,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>>  	pgt->pgd = NULL;
>>  }
>>  
>> -void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
>> +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level)
>>  {
>>  	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
>>  	struct kvm_pgtable_walker walker = {
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 482280fe22d7..73110ba3624c 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -223,12 +223,12 @@ static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
>>  {
>>  	struct page *page = container_of(head, struct page, rcu_head);
>>  	void *pgtable = page_to_virt(page);
>> -	u32 level = page_private(page);
>> +	s8 level = page_private(page);
>>  
>>  	kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
>>  }
>>  
>> -static void stage2_free_unlinked_table(void *addr, u32 level)
>> +static void stage2_free_unlinked_table(void *addr, s8 level)
>>  {
>>  	struct page *page = virt_to_page(addr);
>>  
>> @@ -804,13 +804,13 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
>>  	struct kvm_pgtable pgt = {
>>  		.pgd		= (kvm_pteref_t)kvm->mm->pgd,
>>  		.ia_bits	= vabits_actual,
>> -		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
>> -				   CONFIG_PGTABLE_LEVELS),
>> +		.start_level	= (KVM_PGTABLE_LAST_LEVEL -
>> +				   CONFIG_PGTABLE_LEVELS + 1),
>>  		.mm_ops		= &kvm_user_mm_ops,
>>  	};
>>  	unsigned long flags;
>>  	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
>> -	u32 level = ~0;
>> +	s8 level = ~0;
> 
> Well, that's a semantic difference. ~0 == -1, which is a valid level,
> while the original code was trying to initialise level to something
> invalid. On the bright side, this function is going away in 6.7...

ACK.

> 
>>  	int ret;
>>  
>>  	/*
>> @@ -829,7 +829,9 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
>>  	 * Not seeing an error, but not updating level? Something went
>>  	 * deeply wrong...
>>  	 */
>> -	if (WARN_ON(level >= KVM_PGTABLE_MAX_LEVELS))
>> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +		return -EFAULT;
>> +	if (WARN_ON(level < KVM_PGTABLE_FIRST_LEVEL))
>>  		return -EFAULT;
>>  
>>  	/* Oops, the userspace PTs are gone... Replay the fault */
>> @@ -1407,7 +1409,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	gfn_t gfn;
>>  	kvm_pfn_t pfn;
>>  	bool logging_active = memslot_is_logging(memslot);
>> -	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
>> +	s8 fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
>>  	long vma_pagesize, fault_granule;
>>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>  	struct kvm_pgtable *pgt;
> 
> Thanks,
> 
> 	M.
> 

