From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Handle hva aging while destroying the
 vm
Date: Thu, 6 Jul 2017 09:45:13 +0200
Message-ID: <20170706074513.GC18106@cbox>
References: <1499235631-141725-1-git-send-email-agraf@suse.de>
 <20170705085700.GA16881@e107814-lin.cambridge.arm.com>
 <f8794311-ddec-fdb4-9ef2-2e2c05ca7467@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f8794311-ddec-fdb4-9ef2-2e2c05ca7467@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 06, 2017 at 09:07:49AM +0200, Alexander Graf wrote:
> 
> 
> On 05.07.17 10:57, Suzuki K Poulose wrote:
> >Hi Alex,
> >
> >On Wed, Jul 05, 2017 at 08:20:31AM +0200, Alexander Graf wrote:
> >>The kvm_age_hva callback may be called all the way concurrently while
> >>kvm_mmu_notifier_release() is running.
> >>
> >>The release function sets kvm->arch.pgd = NULL which the aging function
> >>however implicitly relies on in stage2_get_pud(). That means they can
> >>race and the aging function may dereference a NULL pgd pointer.
> >>
> >>This patch adds a check for that case, so that we leave the aging
> >>function silently.
> >>
> >>Cc: stable@vger.kernel.org
> >>Fixes: 293f29363 ("kvm-arm: Unmap shadow pagetables properly")
> >>Signed-off-by: Alexander Graf <agraf@suse.de>
> >>
> >>---
> >>
> >>v1 -> v2:
> >>
> >>   - Fix commit message
> >>   - Add Fixes and stable tags
> >>---
> >>  virt/kvm/arm/mmu.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >>diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> >>index f2d5b6c..227931f 100644
> >>--- a/virt/kvm/arm/mmu.c
> >>+++ b/virt/kvm/arm/mmu.c
> >>@@ -861,6 +861,10 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
> >>  	pgd_t *pgd;
> >>  	pud_t *pud;
> >>+	/* Do we clash with kvm_free_stage2_pgd()? */
> >>+	if (!kvm->arch.pgd)
> >>+		return NULL;
> >>+
> >
> >I think this check should be moved up in the chain. We call kvm_age_hva(), with
> >the kvm->mmu_lock held and we don't release it till we reach here. So, ideally,
> >if we find the PGD is null when we reach kvm_age_hva(), we could simply return
> >there, like we do for other call backs from the KVM mmu_notifier.
> 
> That probably works too - I'm not sure which version is more
> consistent as well as more maintainable in the long run. I'll leave
> the call here to Christoffer.
> 

Let's look at the callers to stage2_get_pmd, which is the only caller of
stage2_get_pud, where the problem was observed:

  user_mem_abort
   -> stage2_set_pmd_huge
      -> stage2_get_pmd
  
  user_mem_abort
   -> stage2_set_pte
      -> stage2_get_pmd

  handle_access_fault
   -> stage2_get_pmd

For the above three functions, pgd cannot ever be NULL, because this is
running in the context of a VCPU thread, which means the reference on
the VM fd must not reach zero, so no need to call that here.

  kvm_set_spte_handler
   -> stage2_set_pte
      -> stage2_get_pmd
 
This is called from kvm_set_spte_hva, which is one of the MMU notifiers,
so it can race similarly kvm_age_hva and kvm_test_age_hva, but it
already checks for !kvm->arch.pgd.

  kvm_phys_addr_ioremap
   -> stage2_set_pte
      -> stage2_get_pmd

This is called from two places: (1) The VGIC code (as part of
vgic_v2_map_resources) and can only be called in the context of running
a VCPU, so the pgd cannot be null by virtue of the same argument as for
user_mem_abort. (2) kvm_arch_prepare_memory_region calls
kvm_phys_addr_ioremap, which is a VM ioctl so similarly, I cannot see
how the VM can be in the middle of being freed while handling ioctls on
the fd.  Therefore, following the same argument, this should be safe as
well.

  kvm_age_hva_handler and kvm_test_age_hva_handler
   -> stage2_get_pmd

Handled by the patch proposed by Suzuki.

What does all that tell us?  First, it should give us some comfort that we
don't have more races of this kind.  Second, it teels us that there are
a number of different and not-obvious call paths to stage2_pet_pud,
which could be an argument to simply check the pgd whenever it's called,
despite the minor runtime overhead.  On the other hand, the check itself
is only valid knowing that we synchronize against kvm_free_stage2_pgd
using the kvm->mmu_lock() and understanding that this only happens when
mmu notifiers call into the KVM MMU code outside the context of the VM.

The last consideration is the winning argument for me to put the check
in kvm_age_hva_handler and kvm_test_age_hva_handler, but I think it's
important that we document why it's only these three high-level callers
(incl. kvm_set_spte_handler) that need the check, either in the code or
in the commit message.

Marc, thoughts?

Thanks,
-Christoffer
