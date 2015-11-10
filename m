From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] ARM/arm64: KVM: test properly for a PTE's uncachedness
Date: Tue, 10 Nov 2015 14:40:48 +0100
Message-ID: <20151110134048.GE12968@cbox>
References: <CAKv+Gu_agkv7aDqj7fgdoWU+9k=eJ-0YU7WrDKm1_wtr_xYQ6g@mail.gmail.com>
 <1447148737-15363-1-git-send-email-ard.biesheuvel@linaro.org>
 <20151110122203.GD12968@cbox>
 <CAKv+Gu_q0inrFoMNeQdF-f_msLEsyb_Fux0d4tQYmMb6Fgttrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_q0inrFoMNeQdF-f_msLEsyb_Fux0d4tQYmMb6Fgttrw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, p.fedin@samsung.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 10, 2015 at 02:15:45PM +0100, Ard Biesheuvel wrote:
> On 10 November 2015 at 13:22, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Tue, Nov 10, 2015 at 10:45:37AM +0100, Ard Biesheuvel wrote:
> >> Hi all,
> >>
> >> I wonder if this is a better way to address the problem. It looks at
> >> the nature of the memory rather than the nature of the mapping, which
> >> is probably a more reliable indicator of whether cache maintenance is
> >> required when performing the unmap.
> >>
> >>
> >> -----------8<----------------
> >> The open coded tests for checking whether a PTE maps a page as
> >> uncached use a flawed 'pte_val(xxx) & CONST != CONST' pattern,
> >> which is not guaranteed to work since the type of a mapping is
> >> not a set of mutually exclusive bits
> >>
> >> For HYP mappings, the type is an index into the MAIR table (i.e, the
> >> index itself does not contain any information whatsoever about the
> >> type of the mapping), and for stage-2 mappings it is a bit field where
> >> normal memory and device types are defined as follows:
> >>
> >>     #define MT_S2_NORMAL            0xf
> >>     #define MT_S2_DEVICE_nGnRE      0x1
> >>
> >> I.e., masking *and* comparing with the latter matches on the former,
> >> and we have been getting lucky merely because the S2 device mappings
> >> also have the PTE_UXN bit set, or we would misidentify memory mappings
> >> as device mappings.
> >>
> >> Since the unmap_range() code path (which contains one instance of the
> >> flawed test) is used both for HYP mappings and stage-2 mappings, and
> >> considering the difference between the two, it is non-trivial to fix
> >> this by rewriting the tests in place, as it would involve passing
> >> down the type of mapping through all the functions.
> >>
> >> However, since HYP mappings and stage-2 mappings both deal with host
> >> physical addresses, we can simply check whether the mapping is backed
> >> by memory that is managed by the host kernel, and only perform the
> >> D-cache maintenance if this is the case.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> ---
> >>  arch/arm/kvm/mmu.c | 15 +++++++--------
> >>  1 file changed, 7 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> >> index 6984342da13d..7dace909d5cf 100644
> >> --- a/arch/arm/kvm/mmu.c
> >> +++ b/arch/arm/kvm/mmu.c
> >> @@ -98,6 +98,11 @@ static void kvm_flush_dcache_pud(pud_t pud)
> >>       __kvm_flush_dcache_pud(pud);
> >>  }
> >>
> >> +static bool kvm_is_device_pfn(unsigned long pfn)
> >> +{
> >> +     return !pfn_valid(pfn);
> >> +}
> >> +
> >>  /**
> >>   * stage2_dissolve_pmd() - clear and flush huge PMD entry
> >>   * @kvm:     pointer to kvm structure.
> >> @@ -213,7 +218,7 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
> >>                       kvm_tlb_flush_vmid_ipa(kvm, addr);
> >>
> >>                       /* No need to invalidate the cache for device mappings */
> >> -                     if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> >> +                     if (!kvm_is_device_pfn(__phys_to_pfn(addr)))
> >>                               kvm_flush_dcache_pte(old_pte);
> >>
> >>                       put_page(virt_to_page(pte));
> >> @@ -305,8 +310,7 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
> >>
> >>       pte = pte_offset_kernel(pmd, addr);
> >>       do {
> >> -             if (!pte_none(*pte) &&
> >> -                 (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> >> +             if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
> >>                       kvm_flush_dcache_pte(*pte);
> >>       } while (pte++, addr += PAGE_SIZE, addr != end);
> >>  }
> >> @@ -1037,11 +1041,6 @@ static bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
> >>       return kvm_vcpu_dabt_iswrite(vcpu);
> >>  }
> >>
> >> -static bool kvm_is_device_pfn(unsigned long pfn)
> >> -{
> >> -     return !pfn_valid(pfn);
> >> -}
> >> -
> >>  /**
> >>   * stage2_wp_ptes - write protect PMD range
> >>   * @pmd:     pointer to pmd entry
> >> --
> >> 1.9.1
> >>
> >
> > So PAGE_HYP_DEVICE is used only to map the vgic-v2 regions and
> > PAGE_S2_DEVICE is used to map the vgic VCPU interface and for all memory
> > regions where the vma has (vm_flags & VM_PFNMAP).
> >
> > Will these, and only these, cases be covered by the pfn_valid check?
> >
> 
> The pfn_valid() check will ensure that cache maintenance is only
> performed on regions that are known to the host as memory, are managed
> by the host (i.e., there is a struct page associated with them) and
> will be accessed by the host via cacheable mappings (they are covered
> by the linear mapping, or [on ARM] will be kmap'ed cacheable if they
> are highmem). If you look at the commit that introduced these tests
> (363ef89f8e9b arm/arm64: KVM: Invalidate data cache on unmap), the
> concern it addresses is that the guest may perform uncached accesses
> to regions that the host has mapped cacheable, meaning guest writes
> may be shadowed by clean cachelines, making them invisble to cache
> coherent I/O. So afaict, pfn_valid() is an appropriate check here.

right, this I agree with.

> 
> pfn_valid() will not misidentify device regions as memory (unless the
> host is really broken) so this should fix Pavel's case. The converse
> case (a memory region misidentified as a device) could only happen for
> a carve-out (i.e., via the /reserved-memory node) that is mapped
> inside the guest via a pass-through (VM_PFNMAP) mapping. That case is
> already dodgy, since the guest accesses would be forced
> uncached/ordered due to the fact that those mappings are forced
> PAGE_S2_DEVICE at stage 2 (as you mention), and would also be
> misidentified by the current code (due to the PAGE_S2_DEVICE
> attributes)
> 

ok, but such pages should never be swapped out by the host, so I think
we're still ok here.

Will you send an updated proper patch to the list?  You can add my
RB if you want.

-Christoffer
