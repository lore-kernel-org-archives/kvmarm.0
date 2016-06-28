From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 02/15] arm64: KVM: Kill HYP_PAGE_OFFSET
Date: Tue, 28 Jun 2016 14:03:42 +0200
Message-ID: <20160628120342.GN26498@cbox>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-3-git-send-email-marc.zyngier@arm.com>
 <20160627134717.GJ26498@cbox> <57713627.1010800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 909C849B51
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 07:57:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HhcqgwUqrzdo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 07:57:44 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58B8049B4C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 07:57:44 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id f126so136997710wma.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 05:02:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57713627.1010800@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 27, 2016 at 03:20:23PM +0100, Marc Zyngier wrote:
> On 27/06/16 14:47, Christoffer Dall wrote:
> > On Tue, Jun 07, 2016 at 11:58:22AM +0100, Marc Zyngier wrote:
> >> HYP_PAGE_OFFSET is not massively useful. And the way we use it
> >> in KERN_HYP_VA is inconsistent with the equivalent operation in
> >> EL2, where we use a mask instead.
> >>
> >> Let's replace the uses of HYP_PAGE_OFFSET with HYP_PAGE_OFFSET_MASK,
> >> and get rid of the pointless macro.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_hyp.h | 5 ++---
> >>  arch/arm64/include/asm/kvm_mmu.h | 3 +--
> >>  2 files changed, 3 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> >> index 44eaff7..61d01a9 100644
> >> --- a/arch/arm64/include/asm/kvm_hyp.h
> >> +++ b/arch/arm64/include/asm/kvm_hyp.h
> >> @@ -38,11 +38,10 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
> >>  
> >>  static inline unsigned long __hyp_kern_va(unsigned long v)
> >>  {
> >> -	u64 offset = PAGE_OFFSET - HYP_PAGE_OFFSET;
> >> -	asm volatile(ALTERNATIVE("add %0, %0, %1",
> >> +	asm volatile(ALTERNATIVE("orr %0, %0, %1",
> >>  				 "nop",
> >>  				 ARM64_HAS_VIRT_HOST_EXTN)
> >> -		     : "+r" (v) : "r" (offset));
> >> +		     : "+r" (v) : "i" (~HYP_PAGE_OFFSET_MASK));
> > 
> > for some reason this is hurting my brain.  I can't easily see that the
> > two implementations are equivalent.
> > 
> > I can see that the kernel-to-hyp masking is trivially correct, but are
> > we always sure that the upper bits that we mask off are always set?
> 
> A kernel address always has the top bits set. That's a given, and a
> property of the architecture (bits [63:VA_BITS] are set to one. See
> D4.2.1 and the definition of a Virtual Address (top VA subrange).
> 

This part I understood, but I somehow had the impression that
HYP_PAGE_OFFSET_MASK could mask off more than (63 - VA_BITS + 1) bits,
but looking at the definition of HYP_PAGE_OFFSET_MASK it clearly cannot.

What can I say, I probably shouldn't have looked at code yesterday.

> > 
> >>  	return v;
> >>  }
> >>  
> >> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> >> index 00bc277..d162372 100644
> >> --- a/arch/arm64/include/asm/kvm_mmu.h
> >> +++ b/arch/arm64/include/asm/kvm_mmu.h
> >> @@ -75,7 +75,6 @@
> >>   */
> >>  #define HYP_PAGE_OFFSET_SHIFT	VA_BITS
> >>  #define HYP_PAGE_OFFSET_MASK	((UL(1) << HYP_PAGE_OFFSET_SHIFT) - 1)
> >> -#define HYP_PAGE_OFFSET		(PAGE_OFFSET & HYP_PAGE_OFFSET_MASK)
> >>  
> >>  /*
> >>   * Our virtual mapping for the idmap-ed MMU-enable code. Must be
> >> @@ -109,7 +108,7 @@ alternative_endif
> >>  #include <asm/mmu_context.h>
> >>  #include <asm/pgtable.h>
> >>  
> >> -#define KERN_TO_HYP(kva)	((unsigned long)kva - PAGE_OFFSET + HYP_PAGE_OFFSET)
> >> +#define KERN_TO_HYP(kva)	((unsigned long)kva & HYP_PAGE_OFFSET_MASK)
> >>  
> > 
> > Why do we have both kern_hyp_va() and KERN_TO_HYP and how are they
> > related again?
> 
> That's because kern_hyp_va used to be reserved to the assembly code, and
> KERN_TO_HYP used in C code. We could (and probably should) unify them.
> 
If we can, that would be good.


Thanks,
-Christoffer
