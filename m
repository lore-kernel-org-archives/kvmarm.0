From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 15/17] kvm: arm64: Get rid of fake page table levels
Date: Tue, 12 Apr 2016 14:14:14 +0200
Message-ID: <20160412121414.GA3039@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-16-git-send-email-suzuki.poulose@arm.com>
 <20160408150523.GX8961@cbox> <570BB5C9.8040509@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A60940402
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:12:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dL-d2RNFBS49 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2016 08:12:20 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32090400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:12:19 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id n3so25463714wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 05:13:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570BB5C9.8040509@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 11, 2016 at 03:33:45PM +0100, Suzuki K Poulose wrote:
> On 08/04/16 16:05, Christoffer Dall wrote:
> >On Mon, Apr 04, 2016 at 05:26:15PM +0100, Suzuki K Poulose wrote:
> 
> >>diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> >>index 751227d..139b4db 100644
> >>--- a/arch/arm64/include/asm/stage2_pgtable.h
> >>+++ b/arch/arm64/include/asm/stage2_pgtable.h
> >>@@ -22,32 +22,55 @@
> >>  #include <asm/pgtable.h>
> >>
> >>  /*
> >>- * In the case where PGDIR_SHIFT is larger than KVM_PHYS_SHIFT, we can address
> >>- * the entire IPA input range with a single pgd entry, and we would only need
> >>- * one pgd entry.  Note that in this case, the pgd is actually not used by
> >>- * the MMU for Stage-2 translations, but is merely a fake pgd used as a data
> >>- * structure for the kernel pgtable macros to work.
> >>+ * The hardware mandates concatenation of upto 16 tables at stage2 entry level.
> >
> >s/upto/up to/
> >
> >>+ * Now, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3),
> >>+ * or in other words log2(PTRS_PER_PTE). On arm64, the smallest PAGE_SIZE
> >
> >not sure the log2 comment helps here.
> 
> OK, will address both the above comments.
> 
> >
> >>+ * supported is 4k, which means (PAGE_SHIFT - 3) > 4 holds for all page sizes.
> >>+ * This implies, the total number of page table levels at stage2 expected
> >>+ * by the hardware is actually the number of levels required for (KVM_PHYS_SHIFT - 4)
> >>+ * in normal translations(e.g, stage-1), since we cannot have another level in
> >>+ * the range (KVM_PHYS_SHIFT, KVM_PHYS_SHIFT - 4).
> >
> >Is it not a design decision to always choose the maximum number of
> >concatinated initial-level stage2 tables (with the constraint that
> >there's a minimum number required)?
> 
> You are right. It is a design decision.
> 
> >
> >I agree with the design decision, if my math is correct that on 64K
> >systems you end up requiring a 1MB physically contiguous 1MB aligned
> >allocation for each VM?  This seems reasonable enough if you configure
> >your kernel with 64K pages and expect to run VMs on top of that.
> 
> Right, and it is "up to 1MB" and not always, depending on the IPA size.
> And for 16K it would be up to 256K (e.g, with 40bit IPA).
> 
> >
> >>   */
> >>-#if PGDIR_SHIFT > KVM_PHYS_SHIFT
> >>-#define PTRS_PER_S2_PGD_SHIFT	0
> >>-#else
> >>-#define PTRS_PER_S2_PGD_SHIFT	(KVM_PHYS_SHIFT - PGDIR_SHIFT)
> >>-#endif
> >>-#define PTRS_PER_S2_PGD		(1 << PTRS_PER_S2_PGD_SHIFT)
> >>+#define STAGE2_PGTABLE_LEVELS		ARM64_HW_PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)
> >>
> >>  /*
> >>- * If we are concatenating first level stage-2 page tables, we would have less
> >>- * than or equal to 16 pointers in the fake PGD, because that's what the
> >>- * architecture allows.  In this case, (4 - CONFIG_PGTABLE_LEVELS)
> >>- * represents the first level for the host, and we add 1 to go to the next
> >>- * level (which uses contatenation) for the stage-2 tables.

just noticed: s/contatenation/concatenation/

> >>+ * At the moment, we do not support a combination of guest IPA and host VA_BITS
> >>+ * where
> >>+ *       STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
> >
> >can you change this comment to reverse the statement to avoid someone
> >seeing this as a constraint, when in fact it's a negative invariant?
> >
> >So the case we don't support is a sufficiently larger IPA space compared
> >to the host VA space such that the above happens?  (Since at the same
> >IPA space size as host VA space size, the stage-2 levels will always be
> >less than or equal to the host levels.)
> 
> Correct.
> 
> >
> >I don't see how that would ever work with userspace either so I think
> >this is a safe assumption and not something that ever needs fixing.  In
> 
> For e.g, we can perfectly run a guest with 40bit IPA under a host with 16K+36bit
> VA. The moment we go above 40bit IPA, we could trigger the conditions above.
> I think it is perfectly fine for the guest to choose higher IPA width, and place
> its memory well above as long as the qemu/lkvm doesn't exhaust its VA. I just
> tried booting a VM with memory at 0x70_0000_0000 on a 16K+36bitVA host and it
> boots perfectly fine.
> 

Right, I was thinking about it as providing more than 36bits of *memory*
not address space in this case, so you're right, it is at least a
theoretically possible case.

> 
> >which case this should be reworded to just state the assumptions and why
> >this is a good assumption.
> >
> >(If my assumptions are wrong here, then there are also weird cases where
> >the host does huge pages at the PMD level and we don't.  Not sure I can
> >see the full ramifications of that.)
> 
> I am sorry, I didn't get your point about the PMD level.
> 

Right, I expressed that terribly, and I may have gotten myself confused
when writing that.

My concern is this: if the number of levels between the host and stage-2
are different, and the host uses huge pmd mappings (either THP or huge
tlb fs), then do we always do the right thing for stage-2 tables, even
if we support the case with more levels in Stage-2 than on the host?




> >
> >>+ *
> >>+ * We base our stage-2 page table walker helpers based on this assumption and
> >>+ * fallback to using the host version of the helper wherever possible.
> >>+ * i.e, if a particular level is not folded (e.g, PUD) at stage2, we fall back
> >>+ * to using the host version, since it is guaranteed it is not folded at host.
> >
> >I don't really understand why it's desirable to fall back to the host
> >version of the helpers; in fact I would probably prefer to just have it
> >disjoint, but maybe I'll see the reason when going through the patch
> >more.  But I doubt the value of this particular piece of commentary...
> 
> OK
> 
> >
> >>+ *
> >>+ * TODO: We could lift this limitation easily by rearranging the host level
> >>+ * definitions to a more reusable version.
> >>   */
> >
> >So is this really a TODO: based on the above?
> >
> >>-#if PTRS_PER_S2_PGD <= 16
> >>-#define KVM_PREALLOC_LEVEL	(4 - CONFIG_PGTABLE_LEVELS + 1)
> >>-#else
> >>-#define KVM_PREALLOC_LEVEL	(0)
> >>+#if STAGE2_PGTABLE_LEVELS > CONFIG_PGTABLE_LEVELS
> >>+#error "Unsupported combination of guest IPA and host VA_BITS."
> >>  #endif
> >>
> >>+
> 
> 
> >
> >Can we add a comment as to what this defines exactly?  Something like:
> >/*
> >  * PGDIR_SHIFT determines the size a top-level stage2 page table entry can map
> >  */
> 
> Done.
> 
> >>+#define S2_PGDIR_SHIFT			ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - STAGE2_PGTABLE_LEVELS)
> >>+#define S2_PGDIR_SIZE			(_AC(1, UL) << S2_PGDIR_SHIFT)
> >>+#define S2_PGDIR_MASK			(~(S2_PGDIR_SIZE - 1))
> >>+
> >>+/* We can have concatenated tables at stage2 entry. */
> >
> >I'm not sure if the comment is helpful.  How about:
> >
> >/*
> >  * The number of PTRS across all concatenated stage2 tables given by the
> >  * number of bits resolved at the initial level.
> >  */
> >
> 
> OK
> 

Thanks for trying to parse my crytptic and potentially nonsensical
questions.

-Christoffer
