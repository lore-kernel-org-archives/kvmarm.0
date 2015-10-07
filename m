From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 13/15] arm64: kvm: Rewrite fake pgd handling
Date: Wed, 07 Oct 2015 12:13:41 +0100
Message-ID: <5614FE65.4030800@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
 <1442331684-28818-14-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC15241457
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 07:11:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b7+7J6u6ADvi for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 07:11:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54B17412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 07:11:49 -0400 (EDT)
In-Reply-To: <1442331684-28818-14-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Suzuki K. Poulose" <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Catalin.Marinas@arm.com, Will.Deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/09/15 16:41, Suzuki K. Poulose wrote:
> From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> 
> The existing fake pgd handling code assumes that the stage-2 entry
> level can only be one level down that of the host, which may not be
> true always(e.g, with the introduction of 16k pagesize).
> 
> e.g.
> With 16k page size and 48bit VA and 40bit IPA we have the following
> split for page table levels:
> 
> level:  0       1         2         3
> bits : [47] [46 - 36] [35 - 25] [24 - 14] [13 - 0]
>          ^       ^     ^
>          |       |     |
>    host entry    |     x---- stage-2 entry
>                  |
>         IPA -----x
> 
> The stage-2 entry level is 2, due to the concatenation of 16tables
> at level 2(mandated by the hardware). So, we need to fake two levels
> to actually reach the hyp page table. This case cannot be handled

Nit: this is the stage-2 PT, not HYP.

> with the existing code, as, all we know about is KVM_PREALLOC_LEVEL
> which kind of stands for two different pieces of information.
> 
> 1) Whether we have fake page table entry levels.
> 2) The entry level of stage-2 translation.
> 
> We loose the information about the number of fake levels that
> we may have to use. Also, KVM_PREALLOC_LEVEL computation itself
> is wrong, as we assume the hw entry level is always 1 level down
> from the host.
> 
> This patch introduces two seperate indicators :

Nit: "separate".

> 1) Accurate entry level for stage-2 translation - HYP_PGTABLE_ENTRY_LEVEL -
>    using the new helpers.

Same confusion here. HYP has its own set of page tables, and this
definitely is S2, not HYP. Please update this symbol (and all the
similar ones) so that it is not confusing.

> 2) Number of levels of fake pagetable entries. (KVM_FAKE_PGTABLE_LEVELS)
> 
> The following conditions hold true for all cases(with 40bit IPA)
> 1) The stage-2 entry level <= 2
> 2) Number of fake page-table entries is in the inclusive range [0, 2].
> 
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: christoffer.dall@linaro.org
> Cc: Marc.Zyngier@arm.com
> Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  114 ++++++++++++++++++++------------------
>  1 file changed, 61 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 2567fe8..72cfd9e 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -41,18 +41,6 @@
>   */
>  #define TRAMPOLINE_VA		(HYP_PAGE_OFFSET_MASK & PAGE_MASK)
>  
> -/*
> - * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation
> - * levels in addition to the PGD and potentially the PUD which are
> - * pre-allocated (we pre-allocate the fake PGD and the PUD when the Stage-2
> - * tables use one level of tables less than the kernel.
> - */
> -#ifdef CONFIG_ARM64_64K_PAGES
> -#define KVM_MMU_CACHE_MIN_PAGES	1
> -#else
> -#define KVM_MMU_CACHE_MIN_PAGES	2
> -#endif
> -
>  #ifdef __ASSEMBLY__
>  
>  /*
> @@ -80,6 +68,26 @@
>  #define KVM_PHYS_SIZE	(1UL << KVM_PHYS_SHIFT)
>  #define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1UL)
>  
> +/*
> + * At stage-2 entry level, upto 16 tables can be concatenated and
> + * the hardware expects us to use concatenation, whenever possible.
> + * So, number of page table levels for KVM_PHYS_SHIFT is always
> + * the number of normal page table levels for (KVM_PHYS_SHIFT - 4).
> + */
> +#define HYP_PGTABLE_LEVELS	ARM64_HW_PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)
> +/* Number of bits normally addressed by HYP_PGTABLE_LEVELS */
> +#define HYP_PGTABLE_SHIFT	ARM64_HW_PGTABLE_LEVEL_SHIFT(HYP_PGTABLE_LEVELS + 1)

Why +1? I don't understand where that is coming from... which makes the
rest of the patch fairly opaque to me...

	M.
-- 
Jazz is not dead. It just smells funny...
