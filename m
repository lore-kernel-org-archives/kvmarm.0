From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 01/10] KVM: arm/arm64: Split dcache/icache flushing
Date: Tue, 17 Oct 2017 08:44:48 +0200
Message-ID: <20171017064448.GR1845@lvm>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-2-marc.zyngier@arm.com>
 <CAK-u0QmHubcdxzBqncMd5fkO5O-wHQiyvrB7aY+6d-1b5j_cJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK-u0QmHubcdxzBqncMd5fkO5O-wHQiyvrB7aY+6d-1b5j_cJA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: roy.franz@cavium.com
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 16, 2017 at 02:35:47PM -0700, Roy Franz (Cavium) wrote:
> On Mon, Oct 9, 2017 at 8:20 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > As we're about to introduce opportunistic invalidation of the icache,
> > let's split dcache and icache flushing.
> >
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_mmu.h   | 60 ++++++++++++++++++++++++++++------------
> >  arch/arm64/include/asm/kvm_mmu.h | 13 +++++++--
> >  virt/kvm/arm/mmu.c               | 20 ++++++++++----
> >  3 files changed, 67 insertions(+), 26 deletions(-)
> >
> > diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> > index fa6f2174276b..f553aa62d0c3 100644
> > --- a/arch/arm/include/asm/kvm_mmu.h
> > +++ b/arch/arm/include/asm/kvm_mmu.h
> > @@ -126,21 +126,12 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
> >         return (vcpu_cp15(vcpu, c1_SCTLR) & 0b101) == 0b101;
> >  }
> >
> > -static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
> > -                                              kvm_pfn_t pfn,
> > -                                              unsigned long size)
> > +static inline void __coherent_dcache_guest_page(struct kvm_vcpu *vcpu,
> > +                                               kvm_pfn_t pfn,
> > +                                               unsigned long size)
> >  {
> >         /*
> > -        * If we are going to insert an instruction page and the icache is
> > -        * either VIPT or PIPT, there is a potential problem where the host
> > -        * (or another VM) may have used the same page as this guest, and we
> > -        * read incorrect data from the icache.  If we're using a PIPT cache,
> > -        * we can invalidate just that page, but if we are using a VIPT cache
> > -        * we need to invalidate the entire icache - damn shame - as written
> > -        * in the ARM ARM (DDI 0406C.b - Page B3-1393).
> > -        *
> > -        * VIVT caches are tagged using both the ASID and the VMID and doesn't
> > -        * need any kind of flushing (DDI 0406C.b - Page B3-1392).
> > +        * Clean the dcache to the Point of Coherency.
> >          *
> >          * We need to do this through a kernel mapping (using the
> >          * user-space mapping has proved to be the wrong
> > @@ -155,19 +146,52 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
> >
> >                 kvm_flush_dcache_to_poc(va, PAGE_SIZE);
> >
> > -               if (icache_is_pipt())
> > -                       __cpuc_coherent_user_range((unsigned long)va,
> > -                                                  (unsigned long)va + PAGE_SIZE);
> > -
> >                 size -= PAGE_SIZE;
> >                 pfn++;
> >
> >                 kunmap_atomic(va);
> >         }
> > +}
> >
> > -       if (!icache_is_pipt() && !icache_is_vivt_asid_tagged()) {
> > +static inline void __coherent_icache_guest_page(struct kvm_vcpu *vcpu,
> > +                                               kvm_pfn_t pfn,
> > +                                               unsigned long size)
> > +{
> > +       /*
> > +        * If we are going to insert an instruction page and the icache is
> > +        * either VIPT or PIPT, there is a potential problem where the host
> > +        * (or another VM) may have used the same page as this guest, and we
> > +        * read incorrect data from the icache.  If we're using a PIPT cache,
> > +        * we can invalidate just that page, but if we are using a VIPT cache
> > +        * we need to invalidate the entire icache - damn shame - as written
> > +        * in the ARM ARM (DDI 0406C.b - Page B3-1393).
> > +        *
> > +        * VIVT caches are tagged using both the ASID and the VMID and doesn't
> > +        * need any kind of flushing (DDI 0406C.b - Page B3-1392).
> > +        */
> > +
> > +       VM_BUG_ON(size & ~PAGE_MASK);
> > +
> > +       if (icache_is_vivt_asid_tagged())
> > +               return;
> > +
> > +       if (!icache_is_pipt()) {
> >                 /* any kind of VIPT cache */
> >                 __flush_icache_all();
> > +               return;
> > +       }
> How does cache_is_vivt() fit into these checks?   From my digging it looks like
> that is ARMv5 and earlier only, so am I right in thinking those don't support
> virtualization?  It looks like this code properly handles all the cache types
> described in the ARM ARM that you referenced, and that the 'extra' cache
> types in Linux are for older spec chips.
> 
> 
That's certainly my understanding.  From the ARMv7 ARM the only types of
instruction caches we should worry about are:

 - PIPT instruction caches
 - Virtually-indexed, physically-tagged (VIPT) instruction caches
 - ASID and VMID tagged Virtually-indexed, virtually-tagged (VIVT)
   instruction caches.

And I think that's covered here.

Thanks,
-Christoffer
