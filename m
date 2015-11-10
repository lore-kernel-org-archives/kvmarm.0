From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2] ARM/arm64: KVM: test properly for a PTE's uncachedness
Date: Tue, 10 Nov 2015 13:27:26 +0300
Message-ID: <00af01d11ba2$65c116a0$314343e0$@samsung.com>
References: <CAKv+Gu_agkv7aDqj7fgdoWU+9k=eJ-0YU7WrDKm1_wtr_xYQ6g@mail.gmail.com>
 <1447148737-15363-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu_q9tMP+myhR8jXxxrgQpBBTEHrZ0UrU2L9oi6a2jHoVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <CAKv+Gu_q9tMP+myhR8jXxxrgQpBBTEHrZ0UrU2L9oi6a2jHoVw@mail.gmail.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Ard Biesheuvel' <ard.biesheuvel@linaro.org>, 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'KVM devel mailing list' <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 Tested-by: Pavel Fedin <p.fedin@samsung.com>

 Personally i have a small concern about this way of testing. I know many ports of the kernel to proprietary systems, and they tend to have drivers which just deal with hardcoded physical memory regions on their own, without even registering them in the kernel.
 OTOH:
 1. KVM is not meant to be hacked this way as far as i can understand.
 2. Maintainers, i believe, would say: "Then all problems are problems of authors of those ports".
 3. Actually, this does not invent anything new, but reuses the approach being already used in other parts of the code. And this part is what personally i like.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

> -----Original Message-----
> From: Ard Biesheuvel [mailto:ard.biesheuvel@linaro.org]
> Sent: Tuesday, November 10, 2015 12:48 PM
> To: Christoffer Dall; Marc Zyngier; KVM devel mailing list; kvmarm@lists.cs.columbia.edu
> Cc: p.fedin@samsung.com; Ard Biesheuvel
> Subject: Re: [PATCH v2] ARM/arm64: KVM: test properly for a PTE's uncachedness
> 
> (adding lists)
> 
> On 10 November 2015 at 10:45, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > Hi all,
> >
> > I wonder if this is a better way to address the problem. It looks at
> > the nature of the memory rather than the nature of the mapping, which
> > is probably a more reliable indicator of whether cache maintenance is
> > required when performing the unmap.
> >
> >
> > -----------8<----------------
> > The open coded tests for checking whether a PTE maps a page as
> > uncached use a flawed 'pte_val(xxx) & CONST != CONST' pattern,
> > which is not guaranteed to work since the type of a mapping is
> > not a set of mutually exclusive bits
> >
> > For HYP mappings, the type is an index into the MAIR table (i.e, the
> > index itself does not contain any information whatsoever about the
> > type of the mapping), and for stage-2 mappings it is a bit field where
> > normal memory and device types are defined as follows:
> >
> >     #define MT_S2_NORMAL            0xf
> >     #define MT_S2_DEVICE_nGnRE      0x1
> >
> > I.e., masking *and* comparing with the latter matches on the former,
> > and we have been getting lucky merely because the S2 device mappings
> > also have the PTE_UXN bit set, or we would misidentify memory mappings
> > as device mappings.
> >
> > Since the unmap_range() code path (which contains one instance of the
> > flawed test) is used both for HYP mappings and stage-2 mappings, and
> > considering the difference between the two, it is non-trivial to fix
> > this by rewriting the tests in place, as it would involve passing
> > down the type of mapping through all the functions.
> >
> > However, since HYP mappings and stage-2 mappings both deal with host
> > physical addresses, we can simply check whether the mapping is backed
> > by memory that is managed by the host kernel, and only perform the
> > D-cache maintenance if this is the case.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/arm/kvm/mmu.c | 15 +++++++--------
> >  1 file changed, 7 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > index 6984342da13d..7dace909d5cf 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -98,6 +98,11 @@ static void kvm_flush_dcache_pud(pud_t pud)
> >         __kvm_flush_dcache_pud(pud);
> >  }
> >
> > +static bool kvm_is_device_pfn(unsigned long pfn)
> > +{
> > +       return !pfn_valid(pfn);
> > +}
> > +
> >  /**
> >   * stage2_dissolve_pmd() - clear and flush huge PMD entry
> >   * @kvm:       pointer to kvm structure.
> > @@ -213,7 +218,7 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
> >                         kvm_tlb_flush_vmid_ipa(kvm, addr);
> >
> >                         /* No need to invalidate the cache for device mappings */
> > -                       if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> > +                       if (!kvm_is_device_pfn(__phys_to_pfn(addr)))
> >                                 kvm_flush_dcache_pte(old_pte);
> >
> >                         put_page(virt_to_page(pte));
> > @@ -305,8 +310,7 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
> >
> >         pte = pte_offset_kernel(pmd, addr);
> >         do {
> > -               if (!pte_none(*pte) &&
> > -                   (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> > +               if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
> >                         kvm_flush_dcache_pte(*pte);
> >         } while (pte++, addr += PAGE_SIZE, addr != end);
> >  }
> > @@ -1037,11 +1041,6 @@ static bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> >         return kvm_vcpu_dabt_iswrite(vcpu);
> >  }
> >
> > -static bool kvm_is_device_pfn(unsigned long pfn)
> > -{
> > -       return !pfn_valid(pfn);
> > -}
> > -
> >  /**
> >   * stage2_wp_ptes - write protect PMD range
> >   * @pmd:       pointer to pmd entry
> > --
> > 1.9.1
> >

