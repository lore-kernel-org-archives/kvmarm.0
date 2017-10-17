From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 10/10] arm: KVM: Use common implementation for all
 flushes to PoC
Date: Tue, 17 Oct 2017 07:48:16 -0700
Message-ID: <20171017144816.GK5886@lvm>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-11-marc.zyngier@arm.com>
 <20171016200647.GD1845@lvm>
 <afc3cde3-da2d-de83-40bb-d419370607f2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 144F940D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 10:47:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVrNRBkF53Jw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 10:47:21 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFF6A40638
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 10:47:20 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id t69so4426047wmt.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 07:48:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <afc3cde3-da2d-de83-40bb-d419370607f2@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 01:40:00PM +0100, Marc Zyngier wrote:
> On 16/10/17 21:06, Christoffer Dall wrote:
> > On Mon, Oct 09, 2017 at 04:20:32PM +0100, Marc Zyngier wrote:
> >> We currently have no less than three implementations for the
> >> "flush to PoC" code. Let standardize on a single one. This
> >> requires a bit of unpleasant moving around, and relies on
> >> __kvm_flush_dcache_pte and co being #defines so that they can
> >> call into coherent_dcache_guest_page...
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm/include/asm/kvm_mmu.h | 28 ++++------------------------
> >>  virt/kvm/arm/mmu.c             | 20 ++++++++++----------
> >>  2 files changed, 14 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> >> index 5f1ac88a5951..011b0db85c02 100644
> >> --- a/arch/arm/include/asm/kvm_mmu.h
> >> +++ b/arch/arm/include/asm/kvm_mmu.h
> >> @@ -235,31 +235,11 @@ static inline void __coherent_icache_guest_page(kvm_pfn_t pfn,
> >>  	}
> >>  }
> >>  
> >> -static inline void __kvm_flush_dcache_pte(pte_t pte)
> >> -{
> >> -	void *va = kmap_atomic(pte_page(pte));
> >> -
> >> -	kvm_flush_dcache_to_poc(va, PAGE_SIZE);
> >> -
> >> -	kunmap_atomic(va);
> >> -}
> >> -
> >> -static inline void __kvm_flush_dcache_pmd(pmd_t pmd)
> >> -{
> >> -	unsigned long size = PMD_SIZE;
> >> -	kvm_pfn_t pfn = pmd_pfn(pmd);
> >> -
> >> -	while (size) {
> >> -		void *va = kmap_atomic_pfn(pfn);
> >> +#define __kvm_flush_dcache_pte(p)				\
> >> +	coherent_dcache_guest_page(pte_pfn((p)), PAGE_SIZE)
> >>  
> >> -		kvm_flush_dcache_to_poc(va, PAGE_SIZE);
> >> -
> >> -		pfn++;
> >> -		size -= PAGE_SIZE;
> >> -
> >> -		kunmap_atomic(va);
> >> -	}
> >> -}
> >> +#define __kvm_flush_dcache_pmd(p)				\
> >> +	coherent_dcache_guest_page(pmd_pfn((p)), PMD_SIZE)
> > 
> > Why can't these just be static inlines which call
> > __coherent_dcache_guest_page already in the header file directly?
> 
> Because if we do that, we get a significant code expansion in the
> resulting binary (all the call sites end up having a copy of that function.
> 
> > I'm really not too crazy about these #defines.
> 
> Neither am I. But actually, this patch is completely wrong. Using the
> same functions as the guest cleaning doesn't provide the guarantees
> documented next to unmap_stage2_ptes, as we need a clean+invalidate, not
> just a clean.
> 
> I'll rework this patch (or just drop it).
> 
> > In fact, why do we need the coherent_Xcache_guest_page static
> > indirection functions in mmu.c in the first place?
> 
> Code expansion. That's the only reason.
> 
Then maybe a reworked patch needs a function defined in some
arch-specific object file that we can just call.  The functions don't
look that complicated to me, but I suppose if they inline the things
they call, it could become a bit hairy.

Thanks,
-Christoffer
