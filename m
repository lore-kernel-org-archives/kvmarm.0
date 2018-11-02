From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: Clarify explanation of STAGE2_PGTABLE_LEVELS
Date: Fri, 2 Nov 2018 15:25:43 +0100
Message-ID: <20181102142543.GY12057@e113682-lin.lund.arm.com>
References: <20181102075352.20636-1-christoffer.dall@arm.com>
 <404f2d39-5dc5-602f-0594-0997b409ff84@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5584A2E5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Nov 2018 10:25:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wXXyIuUqU8ID for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Nov 2018 10:25:46 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDAFF4A1F2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Nov 2018 10:25:46 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <404f2d39-5dc5-602f-0594-0997b409ff84@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 02, 2018 at 11:02:38AM +0000, Suzuki K Poulose wrote:
> Hi
> 
> On 02/11/18 07:53, Christoffer Dall wrote:
> >In attempting to re-construct the logic for our stage 2 page table
> >layout I found the reaoning in the comment explaining how we calculate
> >the number of levels used for stage 2 page tables a bit backwards.
> >
> >This commit attempts to clarify the comment, to make it slightly easier
> >to read without having the Arm ARM open on the right page.
> >
> >While we're at it, fixup a typo in a comment that was recently changed.
> >
> >Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> >---
> >  arch/arm64/include/asm/stage2_pgtable.h | 17 ++++++++++-------
> >  virt/kvm/arm/mmu.c                      |  2 +-
> >  2 files changed, 11 insertions(+), 8 deletions(-)
> >
> >diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> >index d352f6df8d2c..9c387320b28c 100644
> >--- a/arch/arm64/include/asm/stage2_pgtable.h
> >+++ b/arch/arm64/include/asm/stage2_pgtable.h
> >@@ -31,15 +31,18 @@
> >  /*
> >   * The hardware supports concatenation of up to 16 tables at stage2 entry level
> >- * and we use the feature whenever possible.
> >+ * and we use the feature whenever possible, which means we resolve 4 bits of
> 
> s/we resolve 4 bits/we resolve 4 additional bits/ ?
> 

yes

> >+ * address at the entry level.
> >   *
> >- * Now, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3).
> >+ * This implies, the total number of page table levels required for
> >+ * IPA_SHIFT at stage2 expected by the hardware can be calculated using
> >+ * the same logic used for the (non-collapsable) stage1 page tables but for
> >+ * (IPA_SHIFT - 4).
> >+ *
> >+ * Note, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3).
> 
> May be we could improve it further by :
> 
> s/resolved at any level/resolved at any *non-entry* level/
> 
> as, we could resolve as small as 1 bit at the entry level.
> 
> 

yes

> >   * On arm64, the smallest PAGE_SIZE supported is 4k, which means
> >- *             (PAGE_SHIFT - 3) > 4 holds for all page sizes.
> >- * This implies, the total number of page table levels at stage2 expected
> >- * by the hardware is actually the number of levels required for (IPA_SHIFT - 4)
> >- * in normal translations(e.g, stage1), since we cannot have another level in
> >- * the range (IPA_SHIFT, IPA_SHIFT - 4).
> >+ *             (PAGE_SHIFT - 3) > 4 holds for all page sizes
> >+ * and therefore we will need a minimum of two levels for stage2 in all cases.
> 
> I think the above statement is misleading. The minimum number of
> levels has nothing to do with the concatenation.

Architecturally surely it does?  (The point of concatenation is to
reduce the minimal number of levels required.)

Maybe you mean the minimum number of levels imposed by KVM here?

> For e.g, we could
> still create a stage2 with 1 level (32bit IPA on 64K, 29bit + 3bit
> concatenated), going by the same rules above. The only reason why
> we limit the number of levels to 2, is to prevent splitting stage1 PMD
> huge mappings (which are quite common) at stage2.
> 

So I wasn't entirely clear what the comment was trying to say with the
"(PAGE_SHIFT - 3) > 4 holds for all page size" statement, so I though
that was there to show that we'll need a minimum of two levels, but
maybe that was written under the assumption of the limitations of
IPA_SHIFT (was KVM_PHYS_SIZE).

Since you wrote the original comment, and I couldn't correctly parse
that, and I apparently still didn't fully understand, can you suggest an
alternative wording?

> >   */
> >  #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
> >  #define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
> >diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> >index 4e7572656b5c..78d8020df4a4 100644
> >--- a/virt/kvm/arm/mmu.c
> >+++ b/virt/kvm/arm/mmu.c
> >@@ -1234,7 +1234,7 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
> >  	struct page *page = pfn_to_page(pfn);
> >  	/*
> >-	 * PageTransCompoungMap() returns true for THP and
> >+	 * PageTransCompoundMap() returns true for THP and
> >  	 * hugetlbfs. Make sure the adjustment is done only for THP
> >  	 * pages.
> >  	 */
> >
> 

Thanks!

    Christoffer
