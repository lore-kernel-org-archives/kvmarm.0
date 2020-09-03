Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C104C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 06:03:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 642692071B
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 06:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPkYZ047"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 642692071B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C50A4B3B3;
	Thu,  3 Sep 2020 02:02:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q8ijMlXvDPLq; Thu,  3 Sep 2020 02:02:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFF314B3A6;
	Thu,  3 Sep 2020 02:02:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 664904B3A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 02:02:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iyQafiKW7Vrx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 02:02:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C09E4B379
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 02:02:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599112972;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X4ATHyuxkS/3ymRrhCc6AXlsHISwTiYu0MkDxmZ41MI=;
 b=jPkYZ047xyQSkQKxKmE4LXhycBE6U2ucvFnCjtWKTYclZQd647oTUIH0fe8i/XdUWj2O4v
 S28KA3GoGCy8XeHu/yA9v2S2cY/Ve1xL6cegCY6/VRc6413fjjNYaZNuNKAYmWVg9fQ+vV
 29CNBIIZ3Ia7xv5xDzNX1DjMhEMCHrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-CFZors48Oh-MRcTaoj3c6Q-1; Thu, 03 Sep 2020 02:02:48 -0400
X-MC-Unique: CFZors48Oh-MRcTaoj3c6Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AED78030BD;
 Thu,  3 Sep 2020 06:02:47 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 026D71C4;
 Thu,  3 Sep 2020 06:02:43 +0000 (UTC)
Subject: Re: [PATCH v3 19/21] KVM: arm64: Remove unused page-table code
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-20-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <1ae284c9-52e1-a6e1-be5c-cedacf461b0f@redhat.com>
Date: Thu, 3 Sep 2020 16:02:41 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-20-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Will,

On 8/25/20 7:39 PM, Will Deacon wrote:
> Now that KVM is using the generic page-table code to manage the guest
> stage-2 page-tables, we can remove a bunch of unused macros, #defines
> and static inline functions from the old implementation.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_mmu.h        | 141 -----
>   arch/arm64/include/asm/pgtable-hwdef.h  |  17 -
>   arch/arm64/include/asm/pgtable-prot.h   |  13 -
>   arch/arm64/include/asm/stage2_pgtable.h | 215 -------
>   arch/arm64/kvm/mmu.c                    | 755 ------------------------
>   5 files changed, 1141 deletions(-)
> 

With the following questions resolved:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 42fb50cfe0d8..13ff00d9f16d 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -135,123 +135,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
>   phys_addr_t kvm_mmu_get_httbr(void);
>   phys_addr_t kvm_get_idmap_vector(void);
>   int kvm_mmu_init(void);
> -#define kvm_mk_pmd(ptep)					\
> -	__pmd(__phys_to_pmd_val(__pa(ptep)) | PMD_TYPE_TABLE)
> -#define kvm_mk_pud(pmdp)					\
> -	__pud(__phys_to_pud_val(__pa(pmdp)) | PMD_TYPE_TABLE)
> -#define kvm_mk_p4d(pmdp)					\
> -	__p4d(__phys_to_p4d_val(__pa(pmdp)) | PUD_TYPE_TABLE)
> -
> -#define kvm_set_pud(pudp, pud)		set_pud(pudp, pud)
> -
> -#define kvm_pfn_pte(pfn, prot)		pfn_pte(pfn, prot)
> -#define kvm_pfn_pmd(pfn, prot)		pfn_pmd(pfn, prot)
> -#define kvm_pfn_pud(pfn, prot)		pfn_pud(pfn, prot)
> -
> -#define kvm_pud_pfn(pud)		pud_pfn(pud)
> -
> -#define kvm_pmd_mkhuge(pmd)		pmd_mkhuge(pmd)
> -#define kvm_pud_mkhuge(pud)		pud_mkhuge(pud)
> -
> -static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
> -{
> -	pte_val(pte) |= PTE_S2_RDWR;
> -	return pte;
> -}
> -
> -static inline pmd_t kvm_s2pmd_mkwrite(pmd_t pmd)
> -{
> -	pmd_val(pmd) |= PMD_S2_RDWR;
> -	return pmd;
> -}
> -
> -static inline pud_t kvm_s2pud_mkwrite(pud_t pud)
> -{
> -	pud_val(pud) |= PUD_S2_RDWR;
> -	return pud;
> -}
> -
> -static inline pte_t kvm_s2pte_mkexec(pte_t pte)
> -{
> -	pte_val(pte) &= ~PTE_S2_XN;
> -	return pte;
> -}
> -
> -static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
> -{
> -	pmd_val(pmd) &= ~PMD_S2_XN;
> -	return pmd;
> -}
> -
> -static inline pud_t kvm_s2pud_mkexec(pud_t pud)
> -{
> -	pud_val(pud) &= ~PUD_S2_XN;
> -	return pud;
> -}
> -
> -static inline void kvm_set_s2pte_readonly(pte_t *ptep)
> -{
> -	pteval_t old_pteval, pteval;
> -
> -	pteval = READ_ONCE(pte_val(*ptep));
> -	do {
> -		old_pteval = pteval;
> -		pteval &= ~PTE_S2_RDWR;
> -		pteval |= PTE_S2_RDONLY;
> -		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
> -	} while (pteval != old_pteval);
> -}
> -
> -static inline bool kvm_s2pte_readonly(pte_t *ptep)
> -{
> -	return (READ_ONCE(pte_val(*ptep)) & PTE_S2_RDWR) == PTE_S2_RDONLY;
> -}
> -
> -static inline bool kvm_s2pte_exec(pte_t *ptep)
> -{
> -	return !(READ_ONCE(pte_val(*ptep)) & PTE_S2_XN);
> -}
> -
> -static inline void kvm_set_s2pmd_readonly(pmd_t *pmdp)
> -{
> -	kvm_set_s2pte_readonly((pte_t *)pmdp);
> -}
> -
> -static inline bool kvm_s2pmd_readonly(pmd_t *pmdp)
> -{
> -	return kvm_s2pte_readonly((pte_t *)pmdp);
> -}
> -
> -static inline bool kvm_s2pmd_exec(pmd_t *pmdp)
> -{
> -	return !(READ_ONCE(pmd_val(*pmdp)) & PMD_S2_XN);
> -}
> -
> -static inline void kvm_set_s2pud_readonly(pud_t *pudp)
> -{
> -	kvm_set_s2pte_readonly((pte_t *)pudp);
> -}
> -
> -static inline bool kvm_s2pud_readonly(pud_t *pudp)
> -{
> -	return kvm_s2pte_readonly((pte_t *)pudp);
> -}
> -
> -static inline bool kvm_s2pud_exec(pud_t *pudp)
> -{
> -	return !(READ_ONCE(pud_val(*pudp)) & PUD_S2_XN);
> -}
> -
> -static inline pud_t kvm_s2pud_mkyoung(pud_t pud)
> -{
> -	return pud_mkyoung(pud);
> -}
> -
> -static inline bool kvm_s2pud_young(pud_t pud)
> -{
> -	return pud_young(pud);
> -}
> -
>   
>   struct kvm;
>   
> @@ -293,30 +176,6 @@ static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
>   	}
>   }
>   
> -static inline void __kvm_flush_dcache_pte(pte_t pte)
> -{
> -	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
> -		struct page *page = pte_page(pte);
> -		kvm_flush_dcache_to_poc(page_address(page), PAGE_SIZE);
> -	}
> -}
> -
> -static inline void __kvm_flush_dcache_pmd(pmd_t pmd)
> -{
> -	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
> -		struct page *page = pmd_page(pmd);
> -		kvm_flush_dcache_to_poc(page_address(page), PMD_SIZE);
> -	}
> -}
> -
> -static inline void __kvm_flush_dcache_pud(pud_t pud)
> -{
> -	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
> -		struct page *page = pud_page(pud);
> -		kvm_flush_dcache_to_poc(page_address(page), PUD_SIZE);
> -	}
> -}
> -
>   void kvm_set_way_flush(struct kvm_vcpu *vcpu);
>   void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
>   

There are more stuff in arch/arm64/include/asm/kvm_mmu.h to be dropped:

static inline bool kvm_page_empty(void *ptr)
static inline int arm64_vttbr_x(u32 ipa_shift, u32 levels)
static inline u64 vttbr_baddr_mask(u32 ipa_shift, u32 levels)
static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)


> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 1a989353144e..bb97d464f42b 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -172,23 +172,6 @@
>   #define PTE_ATTRINDX(t)		(_AT(pteval_t, (t)) << 2)
>   #define PTE_ATTRINDX_MASK	(_AT(pteval_t, 7) << 2)
>   
> -/*
> - * 2nd stage PTE definitions
> - */
> -#define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
> -#define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
> -#define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
> -#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for SW */
> -
> -#define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
> -#define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
> -#define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
> -#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for SW */
> -
> -#define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
> -#define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
> -#define PUD_S2_XN		(_AT(pudval_t, 2) << 53)  /* XN[1:0] */
> -
>   /*
>    * Memory Attribute override for Stage-2 (MemAttr[3:0])
>    */
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 88acd7e1cd05..8f094c43072a 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -73,19 +73,6 @@ extern bool arm64_use_ng_mappings;
>   		__val;							\
>   	 })
>   
> -#define PAGE_S2_XN							\
> -	({								\
> -		u64 __val;						\
> -		if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))		\
> -			__val = 0;					\
> -		else							\
> -			__val = PTE_S2_XN;				\
> -		__val;							\
> -	})
> -
> -#define PAGE_S2			__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN)
> -#define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
> -
>   #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
>   /* shared+writable pages are clean by default, hence PTE_RDONLY|PTE_WRITE */
>   #define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> index 996bf98f0cab..fe341a6578c3 100644
> --- a/arch/arm64/include/asm/stage2_pgtable.h
> +++ b/arch/arm64/include/asm/stage2_pgtable.h
> @@ -8,7 +8,6 @@
>   #ifndef __ARM64_S2_PGTABLE_H_
>   #define __ARM64_S2_PGTABLE_H_
>   
> -#include <linux/hugetlb.h>
>   #include <linux/pgtable.h>
>   
>   /*
> @@ -36,21 +35,6 @@
>   #define stage2_pgdir_size(kvm)		(1ULL << stage2_pgdir_shift(kvm))
>   #define stage2_pgdir_mask(kvm)		~(stage2_pgdir_size(kvm) - 1)
>   
> -/*
> - * The number of PTRS across all concatenated stage2 tables given by the
> - * number of bits resolved at the initial level.
> - * If we force more levels than necessary, we may have (stage2_pgdir_shift > IPA),
> - * in which case, stage2_pgd_ptrs will have one entry.
> - */
> -#define pgd_ptrs_shift(ipa, pgdir_shift)	\
> -	((ipa) > (pgdir_shift) ? ((ipa) - (pgdir_shift)) : 0)
> -#define __s2_pgd_ptrs(ipa, lvls)		\
> -	(1 << (pgd_ptrs_shift((ipa), pt_levels_pgdir_shift(lvls))))
> -#define __s2_pgd_size(ipa, lvls)	(__s2_pgd_ptrs((ipa), (lvls)) * sizeof(pgd_t))
> -
> -#define stage2_pgd_ptrs(kvm)		__s2_pgd_ptrs(kvm_phys_shift(kvm), kvm_stage2_levels(kvm))
> -#define stage2_pgd_size(kvm)		__s2_pgd_size(kvm_phys_shift(kvm), kvm_stage2_levels(kvm))
> -
>   /*
>    * kvm_mmmu_cache_min_pages() is the number of pages required to install
>    * a stage-2 translation. We pre-allocate the entry level page table at
> @@ -58,196 +42,6 @@
>    */
>   #define kvm_mmu_cache_min_pages(kvm)	(kvm_stage2_levels(kvm) - 1)
>   
> -/* Stage2 PUD definitions when the level is present */
> -static inline bool kvm_stage2_has_pud(struct kvm *kvm)
> -{
> -	return (CONFIG_PGTABLE_LEVELS > 3) && (kvm_stage2_levels(kvm) > 3);
> -}
> -
> -#define S2_PUD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(1)
> -#define S2_PUD_SIZE			(1UL << S2_PUD_SHIFT)
> -#define S2_PUD_MASK			(~(S2_PUD_SIZE - 1))
> -
> -#define stage2_pgd_none(kvm, pgd)		pgd_none(pgd)
> -#define stage2_pgd_clear(kvm, pgd)		pgd_clear(pgd)
> -#define stage2_pgd_present(kvm, pgd)		pgd_present(pgd)
> -#define stage2_pgd_populate(kvm, pgd, p4d)	pgd_populate(NULL, pgd, p4d)
> -
> -static inline p4d_t *stage2_p4d_offset(struct kvm *kvm,
> -				       pgd_t *pgd, unsigned long address)
> -{
> -	return p4d_offset(pgd, address);
> -}
> -
> -static inline void stage2_p4d_free(struct kvm *kvm, p4d_t *p4d)
> -{
> -}
> -
> -static inline bool stage2_p4d_table_empty(struct kvm *kvm, p4d_t *p4dp)
> -{
> -	return false;
> -}
> -
> -static inline phys_addr_t stage2_p4d_addr_end(struct kvm *kvm,
> -					      phys_addr_t addr, phys_addr_t end)
> -{
> -	return end;
> -}
> -
> -static inline bool stage2_p4d_none(struct kvm *kvm, p4d_t p4d)
> -{
> -	if (kvm_stage2_has_pud(kvm))
> -		return p4d_none(p4d);
> -	else
> -		return 0;
> -}
> -
> -static inline void stage2_p4d_clear(struct kvm *kvm, p4d_t *p4dp)
> -{
> -	if (kvm_stage2_has_pud(kvm))
> -		p4d_clear(p4dp);
> -}
> -
> -static inline bool stage2_p4d_present(struct kvm *kvm, p4d_t p4d)
> -{
> -	if (kvm_stage2_has_pud(kvm))
> -		return p4d_present(p4d);
> -	else
> -		return 1;
> -}
> -
> -static inline void stage2_p4d_populate(struct kvm *kvm, p4d_t *p4d, pud_t *pud)
> -{
> -	if (kvm_stage2_has_pud(kvm))
> -		p4d_populate(NULL, p4d, pud);
> -}
> -
> -static inline pud_t *stage2_pud_offset(struct kvm *kvm,
> -				       p4d_t *p4d, unsigned long address)
> -{
> -	if (kvm_stage2_has_pud(kvm))
> -		return pud_offset(p4d, address);
> -	else
> -		return (pud_t *)p4d;
> -}
> -
> -static inline void stage2_pud_free(struct kvm *kvm, pud_t *pud)
> -{
> -	if (kvm_stage2_has_pud(kvm))
> -		free_page((unsigned long)pud);
> -}
> -
> -static inline bool stage2_pud_table_empty(struct kvm *kvm, pud_t *pudp)
> -{
> -	if (kvm_stage2_has_pud(kvm))
> -		return kvm_page_empty(pudp);
> -	else
> -		return false;
> -}
> -
> -static inline phys_addr_t
> -stage2_pud_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> -{
> -	if (kvm_stage2_has_pud(kvm)) {
> -		phys_addr_t boundary = (addr + S2_PUD_SIZE) & S2_PUD_MASK;
> -
> -		return (boundary - 1 < end - 1) ? boundary : end;
> -	} else {
> -		return end;
> -	}
> -}
> -
> -/* Stage2 PMD definitions when the level is present */
> -static inline bool kvm_stage2_has_pmd(struct kvm *kvm)
> -{
> -	return (CONFIG_PGTABLE_LEVELS > 2) && (kvm_stage2_levels(kvm) > 2);
> -}
> -
> -#define S2_PMD_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(2)
> -#define S2_PMD_SIZE			(1UL << S2_PMD_SHIFT)
> -#define S2_PMD_MASK			(~(S2_PMD_SIZE - 1))
> -
> -static inline bool stage2_pud_none(struct kvm *kvm, pud_t pud)
> -{
> -	if (kvm_stage2_has_pmd(kvm))
> -		return pud_none(pud);
> -	else
> -		return 0;
> -}
> -
> -static inline void stage2_pud_clear(struct kvm *kvm, pud_t *pud)
> -{
> -	if (kvm_stage2_has_pmd(kvm))
> -		pud_clear(pud);
> -}
> -
> -static inline bool stage2_pud_present(struct kvm *kvm, pud_t pud)
> -{
> -	if (kvm_stage2_has_pmd(kvm))
> -		return pud_present(pud);
> -	else
> -		return 1;
> -}
> -
> -static inline void stage2_pud_populate(struct kvm *kvm, pud_t *pud, pmd_t *pmd)
> -{
> -	if (kvm_stage2_has_pmd(kvm))
> -		pud_populate(NULL, pud, pmd);
> -}
> -
> -static inline pmd_t *stage2_pmd_offset(struct kvm *kvm,
> -				       pud_t *pud, unsigned long address)
> -{
> -	if (kvm_stage2_has_pmd(kvm))
> -		return pmd_offset(pud, address);
> -	else
> -		return (pmd_t *)pud;
> -}
> -
> -static inline void stage2_pmd_free(struct kvm *kvm, pmd_t *pmd)
> -{
> -	if (kvm_stage2_has_pmd(kvm))
> -		free_page((unsigned long)pmd);
> -}
> -
> -static inline bool stage2_pud_huge(struct kvm *kvm, pud_t pud)
> -{
> -	if (kvm_stage2_has_pmd(kvm))
> -		return pud_huge(pud);
> -	else
> -		return 0;
> -}
> -
> -static inline bool stage2_pmd_table_empty(struct kvm *kvm, pmd_t *pmdp)
> -{
> -	if (kvm_stage2_has_pmd(kvm))
> -		return kvm_page_empty(pmdp);
> -	else
> -		return 0;
> -}
> -
> -static inline phys_addr_t
> -stage2_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> -{
> -	if (kvm_stage2_has_pmd(kvm)) {
> -		phys_addr_t boundary = (addr + S2_PMD_SIZE) & S2_PMD_MASK;
> -
> -		return (boundary - 1 < end - 1) ? boundary : end;
> -	} else {
> -		return end;
> -	}
> -}
> -
> -static inline bool stage2_pte_table_empty(struct kvm *kvm, pte_t *ptep)
> -{
> -	return kvm_page_empty(ptep);
> -}
> -
> -static inline unsigned long stage2_pgd_index(struct kvm *kvm, phys_addr_t addr)
> -{
> -	return (((addr) >> stage2_pgdir_shift(kvm)) & (stage2_pgd_ptrs(kvm) - 1));
> -}
> -
>   static inline phys_addr_t
>   stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>   {
> @@ -256,13 +50,4 @@ stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>   	return (boundary - 1 < end - 1) ? boundary : end;
>   }
>   
> -/*
> - * Level values for the ARMv8.4-TTL extension, mapping PUD/PMD/PTE and
> - * the architectural page-table level.
> - */
> -#define S2_NO_LEVEL_HINT	0
> -#define S2_PUD_LEVEL		1
> -#define S2_PMD_LEVEL		2
> -#define S2_PTE_LEVEL		3
> -
>   #endif	/* __ARM64_S2_PGTABLE_H_ */

In arch/arm64/include/stage2_pgtable.h, there are several
macros are only used by stage2_pgd_addr_end(), which is defined
in same header file. I guess they might be moved to the function
and make them function scoped:

/* stage2_pgdir_shift() is the size mapped by top-level stage2 entry for the VM */
#define stage2_pgdir_shift(kvm)         pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
#define stage2_pgdir_size(kvm)          (1ULL << stage2_pgdir_shift(kvm))
#define stage2_pgdir_mask(kvm)          ~(stage2_pgdir_size(kvm) - 1)


> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 050eab71de31..ddeec0b03666 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -31,13 +31,6 @@ static phys_addr_t hyp_idmap_vector;
>   
>   static unsigned long io_map_base;
>   
> -#define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
> -#define KVM_S2_FLAG_LOGGING_ACTIVE	(1UL << 1)
> -
> -static bool is_iomap(unsigned long flags)
> -{
> -	return flags & KVM_S2PTE_FLAG_IS_IOMAP;
> -}
>   
>   /*
>    * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
> @@ -85,154 +78,11 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
>   }
>   
> -static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
> -				   int level)
> -{
> -	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa, level);
> -}
> -
> -/*
> - * D-Cache management functions. They take the page table entries by
> - * value, as they are flushing the cache using the kernel mapping (or
> - * kmap on 32bit).
> - */
> -static void kvm_flush_dcache_pte(pte_t pte)
> -{
> -	__kvm_flush_dcache_pte(pte);
> -}
> -
> -static void kvm_flush_dcache_pmd(pmd_t pmd)
> -{
> -	__kvm_flush_dcache_pmd(pmd);
> -}
> -
> -static void kvm_flush_dcache_pud(pud_t pud)
> -{
> -	__kvm_flush_dcache_pud(pud);
> -}
> -
>   static bool kvm_is_device_pfn(unsigned long pfn)
>   {
>   	return !pfn_valid(pfn);
>   }
>   
> -/**
> - * stage2_dissolve_pmd() - clear and flush huge PMD entry
> - * @mmu:	pointer to mmu structure to operate on
> - * @addr:	IPA
> - * @pmd:	pmd pointer for IPA
> - *
> - * Function clears a PMD entry, flushes addr 1st and 2nd stage TLBs.
> - */
> -static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr, pmd_t *pmd)
> -{
> -	if (!pmd_thp_or_huge(*pmd))
> -		return;
> -
> -	pmd_clear(pmd);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
> -	put_page(virt_to_page(pmd));
> -}
> -
> -/**
> - * stage2_dissolve_pud() - clear and flush huge PUD entry
> - * @mmu:	pointer to mmu structure to operate on
> - * @addr:	IPA
> - * @pud:	pud pointer for IPA
> - *
> - * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs.
> - */
> -static void stage2_dissolve_pud(struct kvm_s2_mmu *mmu, phys_addr_t addr, pud_t *pudp)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -
> -	if (!stage2_pud_huge(kvm, *pudp))
> -		return;
> -
> -	stage2_pud_clear(kvm, pudp);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
> -	put_page(virt_to_page(pudp));
> -}
> -
> -static void clear_stage2_pgd_entry(struct kvm_s2_mmu *mmu, pgd_t *pgd, phys_addr_t addr)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	p4d_t *p4d_table __maybe_unused = stage2_p4d_offset(kvm, pgd, 0UL);
> -	stage2_pgd_clear(kvm, pgd);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
> -	stage2_p4d_free(kvm, p4d_table);
> -	put_page(virt_to_page(pgd));
> -}
> -
> -static void clear_stage2_p4d_entry(struct kvm_s2_mmu *mmu, p4d_t *p4d, phys_addr_t addr)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, p4d, 0);
> -	stage2_p4d_clear(kvm, p4d);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
> -	stage2_pud_free(kvm, pud_table);
> -	put_page(virt_to_page(p4d));
> -}
> -
> -static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr_t addr)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
> -
> -	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
> -	stage2_pud_clear(kvm, pud);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
> -	stage2_pmd_free(kvm, pmd_table);
> -	put_page(virt_to_page(pud));
> -}
> -
> -static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr_t addr)
> -{
> -	pte_t *pte_table = pte_offset_kernel(pmd, 0);
> -	VM_BUG_ON(pmd_thp_or_huge(*pmd));
> -	pmd_clear(pmd);
> -	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
> -	free_page((unsigned long)pte_table);
> -	put_page(virt_to_page(pmd));
> -}
> -
> -static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
> -{
> -	WRITE_ONCE(*ptep, new_pte);
> -	dsb(ishst);
> -}
> -
> -static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
> -{
> -	WRITE_ONCE(*pmdp, new_pmd);
> -	dsb(ishst);
> -}
> -
> -static inline void kvm_pmd_populate(pmd_t *pmdp, pte_t *ptep)
> -{
> -	kvm_set_pmd(pmdp, kvm_mk_pmd(ptep));
> -}
> -
> -static inline void kvm_pud_populate(pud_t *pudp, pmd_t *pmdp)
> -{
> -	WRITE_ONCE(*pudp, kvm_mk_pud(pmdp));
> -	dsb(ishst);
> -}
> -
> -static inline void kvm_p4d_populate(p4d_t *p4dp, pud_t *pudp)
> -{
> -	WRITE_ONCE(*p4dp, kvm_mk_p4d(pudp));
> -	dsb(ishst);
> -}
> -
> -static inline void kvm_pgd_populate(pgd_t *pgdp, p4d_t *p4dp)
> -{
> -#ifndef __PAGETABLE_P4D_FOLDED
> -	WRITE_ONCE(*pgdp, kvm_mk_pgd(p4dp));
> -	dsb(ishst);
> -#endif
> -}
> -
>   /*
>    * Unmapping vs dcache management:
>    *
> @@ -257,108 +107,6 @@ static inline void kvm_pgd_populate(pgd_t *pgdp, p4d_t *p4dp)
>    * we then fully enforce cacheability of RAM, no matter what the guest
>    * does.
>    */
> -static void unmap_stage2_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
> -		       phys_addr_t addr, phys_addr_t end)
> -{
> -	phys_addr_t start_addr = addr;
> -	pte_t *pte, *start_pte;
> -
> -	start_pte = pte = pte_offset_kernel(pmd, addr);
> -	do {
> -		if (!pte_none(*pte)) {
> -			pte_t old_pte = *pte;
> -
> -			kvm_set_pte(pte, __pte(0));
> -			kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PTE_LEVEL);
> -
> -			/* No need to invalidate the cache for device mappings */
> -			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
> -				kvm_flush_dcache_pte(old_pte);
> -
> -			put_page(virt_to_page(pte));
> -		}
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> -
> -	if (stage2_pte_table_empty(mmu->kvm, start_pte))
> -		clear_stage2_pmd_entry(mmu, pmd, start_addr);
> -}
> -
> -static void unmap_stage2_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
> -		       phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	phys_addr_t next, start_addr = addr;
> -	pmd_t *pmd, *start_pmd;
> -
> -	start_pmd = pmd = stage2_pmd_offset(kvm, pud, addr);
> -	do {
> -		next = stage2_pmd_addr_end(kvm, addr, end);
> -		if (!pmd_none(*pmd)) {
> -			if (pmd_thp_or_huge(*pmd)) {
> -				pmd_t old_pmd = *pmd;
> -
> -				pmd_clear(pmd);
> -				kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
> -
> -				kvm_flush_dcache_pmd(old_pmd);
> -
> -				put_page(virt_to_page(pmd));
> -			} else {
> -				unmap_stage2_ptes(mmu, pmd, addr, next);
> -			}
> -		}
> -	} while (pmd++, addr = next, addr != end);
> -
> -	if (stage2_pmd_table_empty(kvm, start_pmd))
> -		clear_stage2_pud_entry(mmu, pud, start_addr);
> -}
> -
> -static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, p4d_t *p4d,
> -		       phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	phys_addr_t next, start_addr = addr;
> -	pud_t *pud, *start_pud;
> -
> -	start_pud = pud = stage2_pud_offset(kvm, p4d, addr);
> -	do {
> -		next = stage2_pud_addr_end(kvm, addr, end);
> -		if (!stage2_pud_none(kvm, *pud)) {
> -			if (stage2_pud_huge(kvm, *pud)) {
> -				pud_t old_pud = *pud;
> -
> -				stage2_pud_clear(kvm, pud);
> -				kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
> -				kvm_flush_dcache_pud(old_pud);
> -				put_page(virt_to_page(pud));
> -			} else {
> -				unmap_stage2_pmds(mmu, pud, addr, next);
> -			}
> -		}
> -	} while (pud++, addr = next, addr != end);
> -
> -	if (stage2_pud_table_empty(kvm, start_pud))
> -		clear_stage2_p4d_entry(mmu, p4d, start_addr);
> -}
> -
> -static void unmap_stage2_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
> -		       phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	phys_addr_t next, start_addr = addr;
> -	p4d_t *p4d, *start_p4d;
> -
> -	start_p4d = p4d = stage2_p4d_offset(kvm, pgd, addr);
> -	do {
> -		next = stage2_p4d_addr_end(kvm, addr, end);
> -		if (!stage2_p4d_none(kvm, *p4d))
> -			unmap_stage2_puds(mmu, p4d, addr, next);
> -	} while (p4d++, addr = next, addr != end);
> -
> -	if (stage2_p4d_table_empty(kvm, start_p4d))
> -		clear_stage2_pgd_entry(mmu, pgd, start_addr);
> -}
> -
>   /**
>    * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
>    * @kvm:   The VM pointer
> @@ -387,71 +135,6 @@ static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 si
>   	__unmap_stage2_range(mmu, start, size, true);
>   }
>   
> -static void stage2_flush_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
> -			      phys_addr_t addr, phys_addr_t end)
> -{
> -	pte_t *pte;
> -
> -	pte = pte_offset_kernel(pmd, addr);
> -	do {
> -		if (!pte_none(*pte) && !kvm_is_device_pfn(pte_pfn(*pte)))
> -			kvm_flush_dcache_pte(*pte);
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> -}
> -
> -static void stage2_flush_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
> -			      phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pmd_t *pmd;
> -	phys_addr_t next;
> -
> -	pmd = stage2_pmd_offset(kvm, pud, addr);
> -	do {
> -		next = stage2_pmd_addr_end(kvm, addr, end);
> -		if (!pmd_none(*pmd)) {
> -			if (pmd_thp_or_huge(*pmd))
> -				kvm_flush_dcache_pmd(*pmd);
> -			else
> -				stage2_flush_ptes(mmu, pmd, addr, next);
> -		}
> -	} while (pmd++, addr = next, addr != end);
> -}
> -
> -static void stage2_flush_puds(struct kvm_s2_mmu *mmu, p4d_t *p4d,
> -			      phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pud_t *pud;
> -	phys_addr_t next;
> -
> -	pud = stage2_pud_offset(kvm, p4d, addr);
> -	do {
> -		next = stage2_pud_addr_end(kvm, addr, end);
> -		if (!stage2_pud_none(kvm, *pud)) {
> -			if (stage2_pud_huge(kvm, *pud))
> -				kvm_flush_dcache_pud(*pud);
> -			else
> -				stage2_flush_pmds(mmu, pud, addr, next);
> -		}
> -	} while (pud++, addr = next, addr != end);
> -}
> -
> -static void stage2_flush_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
> -			      phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	p4d_t *p4d;
> -	phys_addr_t next;
> -
> -	p4d = stage2_p4d_offset(kvm, pgd, addr);
> -	do {
> -		next = stage2_p4d_addr_end(kvm, addr, end);
> -		if (!stage2_p4d_none(kvm, *p4d))
> -			stage2_flush_puds(mmu, p4d, addr, next);
> -	} while (p4d++, addr = next, addr != end);
> -}
> -
>   static void stage2_flush_memslot(struct kvm *kvm,
>   				 struct kvm_memory_slot *memslot)
>   {
> @@ -800,348 +483,6 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	}
>   }
>   
> -static p4d_t *stage2_get_p4d(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
> -			     phys_addr_t addr)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pgd_t *pgd;
> -	p4d_t *p4d;
> -
> -	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
> -	if (stage2_pgd_none(kvm, *pgd)) {
> -		if (!cache)
> -			return NULL;
> -		p4d = kvm_mmu_memory_cache_alloc(cache);
> -		stage2_pgd_populate(kvm, pgd, p4d);
> -		get_page(virt_to_page(pgd));
> -	}
> -
> -	return stage2_p4d_offset(kvm, pgd, addr);
> -}
> -
> -static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
> -			     phys_addr_t addr)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	p4d_t *p4d;
> -	pud_t *pud;
> -
> -	p4d = stage2_get_p4d(mmu, cache, addr);
> -	if (stage2_p4d_none(kvm, *p4d)) {
> -		if (!cache)
> -			return NULL;
> -		pud = kvm_mmu_memory_cache_alloc(cache);
> -		stage2_p4d_populate(kvm, p4d, pud);
> -		get_page(virt_to_page(p4d));
> -	}
> -
> -	return stage2_pud_offset(kvm, p4d, addr);
> -}
> -
> -static pmd_t *stage2_get_pmd(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
> -			     phys_addr_t addr)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pud_t *pud;
> -	pmd_t *pmd;
> -
> -	pud = stage2_get_pud(mmu, cache, addr);
> -	if (!pud || stage2_pud_huge(kvm, *pud))
> -		return NULL;
> -
> -	if (stage2_pud_none(kvm, *pud)) {
> -		if (!cache)
> -			return NULL;
> -		pmd = kvm_mmu_memory_cache_alloc(cache);
> -		stage2_pud_populate(kvm, pud, pmd);
> -		get_page(virt_to_page(pud));
> -	}
> -
> -	return stage2_pmd_offset(kvm, pud, addr);
> -}
> -
> -static int stage2_set_pmd_huge(struct kvm_s2_mmu *mmu,
> -			       struct kvm_mmu_memory_cache *cache,
> -			       phys_addr_t addr, const pmd_t *new_pmd)
> -{
> -	pmd_t *pmd, old_pmd;
> -
> -retry:
> -	pmd = stage2_get_pmd(mmu, cache, addr);
> -	VM_BUG_ON(!pmd);
> -
> -	old_pmd = *pmd;
> -	/*
> -	 * Multiple vcpus faulting on the same PMD entry, can
> -	 * lead to them sequentially updating the PMD with the
> -	 * same value. Following the break-before-make
> -	 * (pmd_clear() followed by tlb_flush()) process can
> -	 * hinder forward progress due to refaults generated
> -	 * on missing translations.
> -	 *
> -	 * Skip updating the page table if the entry is
> -	 * unchanged.
> -	 */
> -	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
> -		return 0;
> -
> -	if (pmd_present(old_pmd)) {
> -		/*
> -		 * If we already have PTE level mapping for this block,
> -		 * we must unmap it to avoid inconsistent TLB state and
> -		 * leaking the table page. We could end up in this situation
> -		 * if the memory slot was marked for dirty logging and was
> -		 * reverted, leaving PTE level mappings for the pages accessed
> -		 * during the period. So, unmap the PTE level mapping for this
> -		 * block and retry, as we could have released the upper level
> -		 * table in the process.
> -		 *
> -		 * Normal THP split/merge follows mmu_notifier callbacks and do
> -		 * get handled accordingly.
> -		 */
> -		if (!pmd_thp_or_huge(old_pmd)) {
> -			unmap_stage2_range(mmu, addr & S2_PMD_MASK, S2_PMD_SIZE);
> -			goto retry;
> -		}
> -		/*
> -		 * Mapping in huge pages should only happen through a
> -		 * fault.  If a page is merged into a transparent huge
> -		 * page, the individual subpages of that huge page
> -		 * should be unmapped through MMU notifiers before we
> -		 * get here.
> -		 *
> -		 * Merging of CompoundPages is not supported; they
> -		 * should become splitting first, unmapped, merged,
> -		 * and mapped back in on-demand.
> -		 */
> -		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
> -		pmd_clear(pmd);
> -		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
> -	} else {
> -		get_page(virt_to_page(pmd));
> -	}
> -
> -	kvm_set_pmd(pmd, *new_pmd);
> -	return 0;
> -}
> -
> -static int stage2_set_pud_huge(struct kvm_s2_mmu *mmu,
> -			       struct kvm_mmu_memory_cache *cache,
> -			       phys_addr_t addr, const pud_t *new_pudp)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pud_t *pudp, old_pud;
> -
> -retry:
> -	pudp = stage2_get_pud(mmu, cache, addr);
> -	VM_BUG_ON(!pudp);
> -
> -	old_pud = *pudp;
> -
> -	/*
> -	 * A large number of vcpus faulting on the same stage 2 entry,
> -	 * can lead to a refault due to the stage2_pud_clear()/tlb_flush().
> -	 * Skip updating the page tables if there is no change.
> -	 */
> -	if (pud_val(old_pud) == pud_val(*new_pudp))
> -		return 0;
> -
> -	if (stage2_pud_present(kvm, old_pud)) {
> -		/*
> -		 * If we already have table level mapping for this block, unmap
> -		 * the range for this block and retry.
> -		 */
> -		if (!stage2_pud_huge(kvm, old_pud)) {
> -			unmap_stage2_range(mmu, addr & S2_PUD_MASK, S2_PUD_SIZE);
> -			goto retry;
> -		}
> -
> -		WARN_ON_ONCE(kvm_pud_pfn(old_pud) != kvm_pud_pfn(*new_pudp));
> -		stage2_pud_clear(kvm, pudp);
> -		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
> -	} else {
> -		get_page(virt_to_page(pudp));
> -	}
> -
> -	kvm_set_pud(pudp, *new_pudp);
> -	return 0;
> -}
> -
> -/*
> - * stage2_get_leaf_entry - walk the stage2 VM page tables and return
> - * true if a valid and present leaf-entry is found. A pointer to the
> - * leaf-entry is returned in the appropriate level variable - pudpp,
> - * pmdpp, ptepp.
> - */
> -static bool stage2_get_leaf_entry(struct kvm_s2_mmu *mmu, phys_addr_t addr,
> -				  pud_t **pudpp, pmd_t **pmdpp, pte_t **ptepp)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pud_t *pudp;
> -	pmd_t *pmdp;
> -	pte_t *ptep;
> -
> -	*pudpp = NULL;
> -	*pmdpp = NULL;
> -	*ptepp = NULL;
> -
> -	pudp = stage2_get_pud(mmu, NULL, addr);
> -	if (!pudp || stage2_pud_none(kvm, *pudp) || !stage2_pud_present(kvm, *pudp))
> -		return false;
> -
> -	if (stage2_pud_huge(kvm, *pudp)) {
> -		*pudpp = pudp;
> -		return true;
> -	}
> -
> -	pmdp = stage2_pmd_offset(kvm, pudp, addr);
> -	if (!pmdp || pmd_none(*pmdp) || !pmd_present(*pmdp))
> -		return false;
> -
> -	if (pmd_thp_or_huge(*pmdp)) {
> -		*pmdpp = pmdp;
> -		return true;
> -	}
> -
> -	ptep = pte_offset_kernel(pmdp, addr);
> -	if (!ptep || pte_none(*ptep) || !pte_present(*ptep))
> -		return false;
> -
> -	*ptepp = ptep;
> -	return true;
> -}
> -
> -static bool stage2_is_exec(struct kvm_s2_mmu *mmu, phys_addr_t addr, unsigned long sz)
> -{
> -	pud_t *pudp;
> -	pmd_t *pmdp;
> -	pte_t *ptep;
> -	bool found;
> -
> -	found = stage2_get_leaf_entry(mmu, addr, &pudp, &pmdp, &ptep);
> -	if (!found)
> -		return false;
> -
> -	if (pudp)
> -		return sz <= PUD_SIZE && kvm_s2pud_exec(pudp);
> -	else if (pmdp)
> -		return sz <= PMD_SIZE && kvm_s2pmd_exec(pmdp);
> -	else
> -		return sz == PAGE_SIZE && kvm_s2pte_exec(ptep);
> -}
> -
> -static int stage2_set_pte(struct kvm_s2_mmu *mmu,
> -			  struct kvm_mmu_memory_cache *cache,
> -			  phys_addr_t addr, const pte_t *new_pte,
> -			  unsigned long flags)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte, old_pte;
> -	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
> -	bool logging_active = flags & KVM_S2_FLAG_LOGGING_ACTIVE;
> -
> -	VM_BUG_ON(logging_active && !cache);
> -
> -	/* Create stage-2 page table mapping - Levels 0 and 1 */
> -	pud = stage2_get_pud(mmu, cache, addr);
> -	if (!pud) {
> -		/*
> -		 * Ignore calls from kvm_set_spte_hva for unallocated
> -		 * address ranges.
> -		 */
> -		return 0;
> -	}
> -
> -	/*
> -	 * While dirty page logging - dissolve huge PUD, then continue
> -	 * on to allocate page.
> -	 */
> -	if (logging_active)
> -		stage2_dissolve_pud(mmu, addr, pud);
> -
> -	if (stage2_pud_none(kvm, *pud)) {
> -		if (!cache)
> -			return 0; /* ignore calls from kvm_set_spte_hva */
> -		pmd = kvm_mmu_memory_cache_alloc(cache);
> -		stage2_pud_populate(kvm, pud, pmd);
> -		get_page(virt_to_page(pud));
> -	}
> -
> -	pmd = stage2_pmd_offset(kvm, pud, addr);
> -	if (!pmd) {
> -		/*
> -		 * Ignore calls from kvm_set_spte_hva for unallocated
> -		 * address ranges.
> -		 */
> -		return 0;
> -	}
> -
> -	/*
> -	 * While dirty page logging - dissolve huge PMD, then continue on to
> -	 * allocate page.
> -	 */
> -	if (logging_active)
> -		stage2_dissolve_pmd(mmu, addr, pmd);
> -
> -	/* Create stage-2 page mappings - Level 2 */
> -	if (pmd_none(*pmd)) {
> -		if (!cache)
> -			return 0; /* ignore calls from kvm_set_spte_hva */
> -		pte = kvm_mmu_memory_cache_alloc(cache);
> -		kvm_pmd_populate(pmd, pte);
> -		get_page(virt_to_page(pmd));
> -	}
> -
> -	pte = pte_offset_kernel(pmd, addr);
> -
> -	if (iomap && pte_present(*pte))
> -		return -EFAULT;
> -
> -	/* Create 2nd stage page table mapping - Level 3 */
> -	old_pte = *pte;
> -	if (pte_present(old_pte)) {
> -		/* Skip page table update if there is no change */
> -		if (pte_val(old_pte) == pte_val(*new_pte))
> -			return 0;
> -
> -		kvm_set_pte(pte, __pte(0));
> -		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PTE_LEVEL);
> -	} else {
> -		get_page(virt_to_page(pte));
> -	}
> -
> -	kvm_set_pte(pte, *new_pte);
> -	return 0;
> -}
> -
> -#ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
> -static int stage2_ptep_test_and_clear_young(pte_t *pte)
> -{
> -	if (pte_young(*pte)) {
> -		*pte = pte_mkold(*pte);
> -		return 1;
> -	}
> -	return 0;
> -}
> -#else
> -static int stage2_ptep_test_and_clear_young(pte_t *pte)
> -{
> -	return __ptep_test_and_clear_young(pte);
> -}
> -#endif
> -
> -static int stage2_pmdp_test_and_clear_young(pmd_t *pmd)
> -{
> -	return stage2_ptep_test_and_clear_young((pte_t *)pmd);
> -}
> -
> -static int stage2_pudp_test_and_clear_young(pud_t *pud)
> -{
> -	return stage2_ptep_test_and_clear_young((pte_t *)pud);
> -}
> -
>   /**
>    * kvm_phys_addr_ioremap - map a device range to guest IPA
>    *
> @@ -1181,102 +522,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   	return ret;
>   }
>   
> -/**
> - * stage2_wp_ptes - write protect PMD range
> - * @pmd:	pointer to pmd entry
> - * @addr:	range start address
> - * @end:	range end address
> - */
> -static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
> -{
> -	pte_t *pte;
> -
> -	pte = pte_offset_kernel(pmd, addr);
> -	do {
> -		if (!pte_none(*pte)) {
> -			if (!kvm_s2pte_readonly(pte))
> -				kvm_set_s2pte_readonly(pte);
> -		}
> -	} while (pte++, addr += PAGE_SIZE, addr != end);
> -}
> -
> -/**
> - * stage2_wp_pmds - write protect PUD range
> - * kvm:		kvm instance for the VM
> - * @pud:	pointer to pud entry
> - * @addr:	range start address
> - * @end:	range end address
> - */
> -static void stage2_wp_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
> -			   phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pmd_t *pmd;
> -	phys_addr_t next;
> -
> -	pmd = stage2_pmd_offset(kvm, pud, addr);
> -
> -	do {
> -		next = stage2_pmd_addr_end(kvm, addr, end);
> -		if (!pmd_none(*pmd)) {
> -			if (pmd_thp_or_huge(*pmd)) {
> -				if (!kvm_s2pmd_readonly(pmd))
> -					kvm_set_s2pmd_readonly(pmd);
> -			} else {
> -				stage2_wp_ptes(pmd, addr, next);
> -			}
> -		}
> -	} while (pmd++, addr = next, addr != end);
> -}
> -
> -/**
> - * stage2_wp_puds - write protect P4D range
> - * @p4d:	pointer to p4d entry
> - * @addr:	range start address
> - * @end:	range end address
> - */
> -static void  stage2_wp_puds(struct kvm_s2_mmu *mmu, p4d_t *p4d,
> -			    phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	pud_t *pud;
> -	phys_addr_t next;
> -
> -	pud = stage2_pud_offset(kvm, p4d, addr);
> -	do {
> -		next = stage2_pud_addr_end(kvm, addr, end);
> -		if (!stage2_pud_none(kvm, *pud)) {
> -			if (stage2_pud_huge(kvm, *pud)) {
> -				if (!kvm_s2pud_readonly(pud))
> -					kvm_set_s2pud_readonly(pud);
> -			} else {
> -				stage2_wp_pmds(mmu, pud, addr, next);
> -			}
> -		}
> -	} while (pud++, addr = next, addr != end);
> -}
> -
> -/**
> - * stage2_wp_p4ds - write protect PGD range
> - * @pgd:	pointer to pgd entry
> - * @addr:	range start address
> - * @end:	range end address
> - */
> -static void  stage2_wp_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
> -			    phys_addr_t addr, phys_addr_t end)
> -{
> -	struct kvm *kvm = mmu->kvm;
> -	p4d_t *p4d;
> -	phys_addr_t next;
> -
> -	p4d = stage2_p4d_offset(kvm, pgd, addr);
> -	do {
> -		next = stage2_p4d_addr_end(kvm, addr, end);
> -		if (!stage2_p4d_none(kvm, *p4d))
> -			stage2_wp_puds(mmu, p4d, addr, next);
> -	} while (p4d++, addr = next, addr != end);
> -}
> -
>   /**
>    * stage2_wp_range() - write protect stage2 memory region range
>    * @kvm:	The KVM pointer
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
