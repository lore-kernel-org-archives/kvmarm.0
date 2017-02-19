From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 13/20] ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall
Date: Sun, 19 Feb 2017 11:19:50 +0000
Message-ID: <20170219111950.234a29b8@why.wild-wind.fr.eu.org>
References: <20170217154429.5000-1-marc.zyngier@arm.com>
 <20170217154429.5000-14-marc.zyngier@arm.com>
 <CAKv+Gu8CeuC5MKdEsuTRU4otAO2psotkoFwkTNNFoyRNap00hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C31340F8A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Feb 2017 06:19:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7jNC8HSHSmnV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Feb 2017 06:19:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD6940DDA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Feb 2017 06:19:03 -0500 (EST)
In-Reply-To: <CAKv+Gu8CeuC5MKdEsuTRU4otAO2psotkoFwkTNNFoyRNap00hw@mail.gmail.com>
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
Cc: Russell King <linux@arm.linux.org.uk>, KVM devel mailing list <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, 19 Feb 2017 08:07:22 +0000
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On 17 February 2017 at 15:44, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > In order to restore HYP mode to its original condition, KVM currently
> > implements __kvm_hyp_reset(). As we're moving towards a hyp-stub
> > defined API, it becomes necessary to implement HVC_RESET_VECTORS.
> >
> > This patch adds the HVC_RESET_VECTORS hypercall to the KVM init
> > code, which so far lacked any form of hypercall support.
> >
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm/kernel/hyp-stub.S |  1 +
> >  arch/arm/kvm/init.S        | 37 +++++++++++++++++++++++++++++++------
> >  2 files changed, 32 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
> > index cf6d801f89e8..171a09cdf6b3 100644
> > --- a/arch/arm/kernel/hyp-stub.S
> > +++ b/arch/arm/kernel/hyp-stub.S
> > @@ -280,6 +280,7 @@ ENDPROC(__hyp_reset_vectors)
> >
> >  .align 5
> >  __hyp_stub_vectors:
> > +.global __hyp_stub_vectors
> >  __hyp_stub_reset:      W(b)    .
> >  __hyp_stub_und:                W(b)    .
> >  __hyp_stub_svc:                W(b)    .
> > diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
> > index bf89c919efc1..b0138118fac4 100644
> > --- a/arch/arm/kvm/init.S
> > +++ b/arch/arm/kvm/init.S
> > @@ -23,6 +23,7 @@
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_arm.h>
> >  #include <asm/kvm_mmu.h>
> > +#include <asm/virt.h>
> >
> >  /********************************************************************
> >   * Hypervisor initialization
> > @@ -39,6 +40,10 @@
> >   * - Setup the page tables
> >   * - Enable the MMU
> >   * - Profit! (or eret, if you only care about the code).
> > + *
> > + * Another possibility is to get a HYP stub hypercall.
> > + * We discriminate between the two by checking if r0 contains a value
> > + * that is less than HVC_STUB_HCALL_NR.
> >   */
> >
> >         .text
> > @@ -58,6 +63,10 @@ __kvm_hyp_init:
> >         W(b)    .
> >
> >  __do_hyp_init:
> > +       @ Check for a stub hypercall
> > +       cmp     r0, #HVC_STUB_HCALL_NR
> > +       blo     __kvm_handle_stub_hvc
> > +
> >         @ Set stack pointer
> >         mov     sp, r0
> >
> > @@ -112,22 +121,38 @@ __do_hyp_init:
> >
> >         eret
> >
> > -       @ r0 : stub vectors address
> > +ENTRY(__kvm_handle_stub_hvc)
> > +       cmp     r0, #HVC_RESET_VECTORS
> > +       bne     1f
> >  ENTRY(__kvm_hyp_reset)
> >         /* We're now in idmap, disable MMU */
> >         mrc     p15, 4, r1, c1, c0, 0   @ HSCTLR
> > -       ldr     r2, =(HSCTLR_M | HSCTLR_A | HSCTLR_C | HSCTLR_I)
> > -       bic     r1, r1, r2
> > +       ldr     r0, =(HSCTLR_M | HSCTLR_A | HSCTLR_C | HSCTLR_I)
> > +       bic     r1, r1, r0
> >         mcr     p15, 4, r1, c1, c0, 0   @ HSCTLR
> >
> > -       /* Install stub vectors */
> > -       mcr     p15, 4, r0, c12, c0, 0  @ HVBAR
> > -       isb
> > +       /*
> > +        * Install stub vectors. We cannot use 'adr' to get to the
> > +        * stub vectors, hence having to play the VA->PA game.
> > +        */
> > +       adr     r0, .L__va2pa   @ PA
> > +       ldr     r1, [r0]        @ VA
> > +       sub     r0, r0, r1      @ PA - VA
> > +       ldr     r1, =__hyp_stub_vectors  
> 
> Since we're guaranteed to be on v7, how about something like
> 0:adr r0, 0b
>   movw r1, #:lower16:__hyp_stub_vectors - 0b
>   movt r1, #:upper16:__hyp_stub_vectors - 0b

Ah, very nice! It hurts my brain, but it is very nice indeed! I'll
borrow that for v2.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
