From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: Force a PTE mapping when logging is
 enabled
Date: Mon, 4 Mar 2019 17:13:21 +0000
Message-ID: <20190304171320.GA3984@en101>
References: <1551497728-12576-1-git-send-email-yuzenghui@huawei.com>
 <CAKcZhuWa4UcsoFPRkZg=M3WeUJibX8T0_R+JHS3=cyd51N9cgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E994A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Mar 2019 12:13:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CsOxVg+mIIE2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Mar 2019 12:13:30 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 299A049F94
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Mar 2019 12:13:30 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAKcZhuWa4UcsoFPRkZg=M3WeUJibX8T0_R+JHS3=cyd51N9cgQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Zenghui Yu <zenghuiyu96@gmail.com>
Cc: marc.zyngier@arm.com, Punit Agrawal <punit.agrawal@arm.com>, LKML <linux-kernel@vger.kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Zenghui,

On Sun, Mar 03, 2019 at 11:14:38PM +0800, Zenghui Yu wrote:
> I think there're still some problems in this patch... Details below.
> 
> On Sat, Mar 2, 2019 at 11:39 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
> >
> > The idea behind this is: we don't want to keep tracking of huge pages when
> > logging_active is true, which will result in performance degradation.  We
> > still need to set vma_pagesize to PAGE_SIZE, so that we can make use of it
> > to force a PTE mapping.

Yes, you're right. We are indeed ignoring the force_pte flag.

> >
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Punit Agrawal <punit.agrawal@arm.com>
> > Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> >
> > ---
> > Atfer looking into https://patchwork.codeaurora.org/patch/647985/ , the
> > "vma_pagesize = PAGE_SIZE" logic was not intended to be deleted. As far
> > as I can tell, we used to have "hugetlb" to force the PTE mapping, but
> > we have "vma_pagesize" currently instead. We should set it properly for
> > performance reasons (e.g, in VM migration). Did I miss something important?
> >
> > ---
> >  virt/kvm/arm/mmu.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> > index 30251e2..7d41b16 100644
> > --- a/virt/kvm/arm/mmu.c
> > +++ b/virt/kvm/arm/mmu.c
> > @@ -1705,6 +1705,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >              (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
> >             !force_pte) {
> >                 gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> > +       } else {
> > +               /*
> > +                * Fallback to PTE if it's not one of the stage2
> > +                * supported hugepage sizes or the corresponding level
> > +                * doesn't exist, or logging is enabled.
> 
> First, Instead of "logging is enabled", it should be "force_pte is true",
> since "force_pte" will be true when:
> 
>         1) fault_supports_stage2_pmd_mappings() return false; or
>         2) "logging is enabled" (e.g, in VM migration).
> 
> Second, fallback some unsupported hugepage sizes (e.g, 64K hugepage with
> 4K pages) to PTE is somewhat strange. And it will then _unexpectedly_
> reach transparent_hugepage_adjust(), though no real adjustment will happen
> since commit fd2ef358282c ("KVM: arm/arm64: Ensure only THP is candidate
> for adjustment"). Keeping "vma_pagesize" there as it is will be better,
> right?
> 
> So I'd just simplify the logic like:

We could fix this right in the beginning. See patch below:

> 
>         } else if (force_pte) {
>                 vma_pagesize = PAGE_SIZE;
>         }
> 
> 
> Will send a V2 later and waiting for your comments :)


diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 30251e2..529331e 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1693,7 +1693,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	vma_pagesize = vma_kernel_pagesize(vma);
+	/* If we are forced to map at page granularity, force the pagesize here */
+	vma_pagesize = force_pte ? PAGE_SIZE : vma_kernel_pagesize(vma);
+
 	/*
 	 * The stage2 has a minimum of 2 level table (For arm64 see
 	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
@@ -1701,11 +1703,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * As for PUD huge maps, we must make sure that we have at least
 	 * 3 levels, i.e, PMD is not folded.
 	 */
-	if ((vma_pagesize == PMD_SIZE ||
-	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
-	    !force_pte) {
+	if (vma_pagesize == PMD_SIZE ||
+	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
-	}
+
 	up_read(&current->mm->mmap_sem);
 
 	/* We need minimum second+third level pages */

---

Suzuki
