From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] ARM/arm64: KVM: test properly for a PTE's uncachedness
Date: Mon, 9 Nov 2015 17:35:19 +0100
Message-ID: <20151109163519.GB12968@cbox>
References: <1446810188-13727-1-git-send-email-ard.biesheuvel@linaro.org>
 <20151109162159.GA12968@cbox>
 <CAKv+Gu9RkX1A4rLvTbgkhTQxcVnLjc1tHRaMAOq0cgcpGvkpRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA1741294
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2015 11:35:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IltP54BGwtyk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2015 11:35:18 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5795D41278
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2015 11:35:17 -0500 (EST)
Received: by wmec201 with SMTP id c201so78061327wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Nov 2015 08:35:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9RkX1A4rLvTbgkhTQxcVnLjc1tHRaMAOq0cgcpGvkpRg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 09, 2015 at 05:27:40PM +0100, Ard Biesheuvel wrote:
> On 9 November 2015 at 17:21, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Fri, Nov 06, 2015 at 12:43:08PM +0100, Ard Biesheuvel wrote:
> >> The open coded tests for checking whether a PTE maps a page as
> >> uncached use a flawed 'pte_val(xxx) & CONST != CONST' pattern,
> >> which is not guaranteed to work since the type of a mapping is an
> >> index into the MAIR table, not a set of mutually exclusive bits.
> >>
> >> Considering that, on arm64, the S2 type definitions use the following
> >> MAIR indexes
> >>
> >>     #define MT_S2_NORMAL            0xf
> >>     #define MT_S2_DEVICE_nGnRE      0x1
> >>
> >> we have been getting lucky merely because the S2 device mappings also
> >> have the PTE_UXN bit set, which means that a device PTE still does not
> >> equal a normal PTE after masking with the former type.
> >>
> >> Instead, implement proper checking against the MAIR indexes that are
> >> known to define uncached memory attributes.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> ---
> >>  arch/arm/include/asm/kvm_mmu.h   | 11 +++++++++++
> >>  arch/arm/kvm/mmu.c               |  5 ++---
> >>  arch/arm64/include/asm/kvm_mmu.h | 12 ++++++++++++
> >>  3 files changed, 25 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> >> index 405aa1883307..422973835d41 100644
> >> --- a/arch/arm/include/asm/kvm_mmu.h
> >> +++ b/arch/arm/include/asm/kvm_mmu.h
> >> @@ -279,6 +279,17 @@ static inline void __kvm_extend_hypmap(pgd_t *boot_hyp_pgd,
> >>                                      pgd_t *merged_hyp_pgd,
> >>                                      unsigned long hyp_idmap_start) { }
> >>
> >> +static inline bool __kvm_pte_is_uncached(pte_t pte)
> >> +{
> >> +     switch (pte_val(pte) & L_PTE_MT_MASK) {
> >> +     case L_PTE_MT_UNCACHED:
> >> +     case L_PTE_MT_BUFFERABLE:
> >> +     case L_PTE_MT_DEV_SHARED:
> >> +             return true;
> >> +     }
> >
> > so PTEs created by setting PAGE_S2_DEVICE will end up hitting in one of
> > these because L_PTE_S2_MT_DEV_SHARED is the same as L_PTE_MT_BUFFERABLE
> > for stage-2 mappings and PAGE_HYP_DEVICE end up using
> > L_PTE_MT_DEV_SHARED.
> >
> > Totally obvious.
> >
> 
> Hmm, perhaps not. Would you prefer all aliases of the L_PTE_MT_xx
> constants that map to device permissions to be listed here?
> 

Meh, there's no great solution and this code is all the kind of code
that you just need to take the time to understand.  We could add a
comment I suppose, if I got the above correct, I can throw something in?

-Christoffer
