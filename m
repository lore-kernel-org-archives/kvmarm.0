From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] kvm: arm64: Enable hardware updates of the Access Flag
 for Stage 2 page tables
Date: Mon, 9 May 2016 22:21:16 +0200
Message-ID: <20160509202116.GB27623@cbox>
References: <1460566657-30221-1-git-send-email-catalin.marinas@arm.com>
 <20160509153310.GA27623@cbox>
 <20160509165056.GC20598@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A0CD49B9C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2016 16:17:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tOaBllC3Ulso for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2016 16:17:51 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC5A349B54
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2016 16:17:50 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id n129so152682497wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2016 13:20:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160509165056.GC20598@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 09, 2016 at 05:50:56PM +0100, Catalin Marinas wrote:
> On Mon, May 09, 2016 at 05:33:10PM +0200, Christoffer Dall wrote:
> > On Wed, Apr 13, 2016 at 05:57:37PM +0100, Catalin Marinas wrote:
> > > The ARMv8.1 architecture extensions introduce support for hardware
> > > updates of the access and dirty information in page table entries. With
> > > VTCR_EL2.HA enabled (bit 21), when the CPU accesses an IPA with the
> > > PTE_AF bit cleared in the stage 2 page table, instead of raising an
> > > Access Flag fault to EL2 the CPU sets the actual page table entry bit
> > > (10). To ensure that kernel modifications to the page table do not
> > > inadvertently revert a bit set by hardware updates, certain Stage 2
> > > software pte/pmd operations must be performed atomically.
> > > 
> > > The main user of the AF bit is the kvm_age_hva() mechanism. The
> > > kvm_age_hva_handler() function performs a "test and clear young" action
> > > on the pte/pmd. This needs to be atomic in respect of automatic hardware
> > > updates of the AF bit. Since the AF bit is in the same position for both
> > > Stage 1 and Stage 2, the patch reuses the existing
> > > ptep_test_and_clear_young() functionality if
> > > __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG is defined. Otherwise, the
> > > existing pte_young/pte_mkold mechanism is preserved.
> > > 
> > > The kvm_set_s2pte_readonly() (and the corresponding pmd equivalent) have
> > > to perform atomic modifications in order to avoid a race with updates of
> > > the AF bit. The arm64 implementation has been re-written using
> > > exclusives.
> > > 
> > > Currently, kvm_set_s2pte_writable() (and pmd equivalent) take a pointer
> > > argument and modify the pte/pmd in place. However, these functions are
> > > only used on local variables rather than actual page table entries, so
> > > it makes more sense to follow the pte_mkwrite() approach for stage 1
> > > attributes. The change to kvm_s2pte_mkwrite() makes it clear that these
> > > functions do not modify the actual page table entries.
> > 
> > so if one CPU takes a permission fault and is in the process of updating
> > the page table, what prevents another CPU from setting the access flag
> > (on a read, done by HW) on that entry between us reading the old pte and
> > replacing it with the new pte?
> 
> There isn't anything that would prevent this. However, as in the stage 1
> scenarios, explicitly writing a PTE as a result of a permission fault
> should also mark the entry as accessed (young, either as the default
> protection in PROT_DEFAULT or explicitly via pte_mkyoung).
> 
> > Don't we loose the AF information in that case too?
> 
> Since the hardware never clears the AF bit automatically, there is no
> information to lose in this race as long as the kvm_set_s2pte_writable()
> sets the AF bit. AFAICT, the PAGE_S2 and PAGE_S2_DEVICE definitions
> already use PROT_DEFAULT which has the AF bit set.

duh, yeah, I didn't consider the overall use case we're targeting.
Thanks for reminding me.

> 
> > >  static inline void kvm_set_s2pte_readonly(pte_t *pte)
> > >  {
> > > -	pte_val(*pte) = (pte_val(*pte) & ~PTE_S2_RDWR) | PTE_S2_RDONLY;
> > > +	pteval_t pteval;
> > > +	unsigned long tmp;
> > > +
> > > +	asm volatile("//	kvm_set_s2pte_readonly\n"
> > > +	"	prfm	pstl1strm, %2\n"
> > > +	"1:	ldxr	%0, %2\n"
> > > +	"	and	%0, %0, %3		// clear PTE_S2_RDWR\n"
> > > +	"	orr	%0, %0, %4		// set PTE_S2_RDONLY\n"
> > > +	"	stxr	%w1, %0, %2\n"
> > > +	"	cbnz	%w1, 1b\n"
> > > +	: "=&r" (pteval), "=&r" (tmp), "+Q" (pte_val(*pte))
> > 
> > so the +Q means "pass the memory address of the value and by the way the
> > content, not the address itself, can be updated by the assembly code" ?
> 
> Yes. I think "info gcc" isn't clear enough on this constraint (at least
> to me) but that's something we learnt from the tools guys in the early
> days of the aarch64 kernel port.
> 
Just finding anything about the meaning of this turned out to be its own
challenge.

In any case:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

And I have applied it to kvmarm/next.

-Christoffer
