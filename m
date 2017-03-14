From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: kvm/arm64: use-after-free in
 kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Tue, 14 Mar 2017 11:07:37 +0000
Message-ID: <20f6c994-d83e-7a6f-9f13-f10287211a6c@arm.com>
References: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5FE340430
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 07:06:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8VT67fnWb461 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Mar 2017 07:06:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C44D740296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 07:06:08 -0400 (EDT)
In-Reply-To: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Konovalov <andreyknvl@google.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, "commit_signer:26/27=96%)"@google.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>
Cc: Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>, Dmitry Vyukov <dvyukov@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/03/17 13:34, Andrey Konovalov wrote:
> Hi,
>
> I've got the following error report while fuzzing the kernel with syzkaller.
>
> On linux-next commit 56b8bad5e066c23e8fa273ef5fba50bd3da2ace8 (Mar 8).
>
> Unfortunately I can't reproduce it.
>
> ==================================================================
> BUG: KASAN: use-after-free in put_page include/linux/compiler.h:243 [inline]
> BUG: KASAN: use-after-free in unmap_stage2_pmds
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:240 [inline]
> BUG: KASAN: use-after-free in unmap_stage2_puds
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:269 [inline]
> BUG: KASAN: use-after-free in unmap_stage2_range+0x884/0x938
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:299
> Read of size 8 at addr ffff80004585c000 by task syz-executor/5176


> [<ffff2000080d9664>] put_page include/linux/compiler.h:243 [inline]
> [<ffff2000080d9664>] unmap_stage2_pmds
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:240 [inline]
> [<ffff2000080d9664>] unmap_stage2_puds
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:269 [inline]
> [<ffff2000080d9664>] unmap_stage2_range+0x884/0x938
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:299
> [<ffff2000080d9740>] kvm_unmap_hva_handler+0x28/0x38
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1556
> [<ffff2000080d7578>] handle_hva_to_gpa+0x140/0x250
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1547
> [<ffff2000080db858>] kvm_unmap_hva_range+0x60/0x80
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1579
> [<ffff2000080c12dc>]
> kvm_mmu_notifier_invalidate_range_start+0x194/0x278
> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:357
> [<ffff2000083fea58>] __mmu_notifier_invalidate_range_start+0x1d0/0x2a0
> mm/mmu_notifier.c:199
> [<ffff200008395f44>] mmu_notifier_invalidate_range_start
> include/linux/mmu_notifier.h:282 [inline]
> [<ffff200008395f44>] unmap_vmas+0x12c/0x198 mm/memory.c:1372
> [<ffff2000083a8e00>] unmap_region+0x128/0x230 mm/mmap.c:2460
> [<ffff2000083ae6e0>] update_hiwater_vm include/linux/mm.h:1483 [inline]
> [<ffff2000083ae6e0>] remove_vma_list mm/mmap.c:2432 [inline]
> [<ffff2000083ae6e0>] do_munmap+0x598/0x9b0 mm/mmap.c:2662
> [<ffff2000083b14a0>] find_vma_links mm/mmap.c:495 [inline]
> [<ffff2000083b14a0>] mmap_region+0x138/0xc78 mm/mmap.c:1610
> [<ffff2000083b23ac>] is_file_hugepages include/linux/hugetlb.h:269 [inline]
> [<ffff2000083b23ac>] do_mmap+0x3cc/0x848 mm/mmap.c:1446
> [<ffff200008369b0c>] do_mmap_pgoff include/linux/mm.h:2039 [inline]
> [<ffff200008369b0c>] vm_mmap_pgoff+0xec/0x120 mm/util.c:305
> [<ffff2000083ac558>] SYSC_mmap_pgoff mm/mmap.c:1475 [inline]
> [<ffff2000083ac558>] SyS_mmap_pgoff+0x220/0x420 mm/mmap.c:1458
> [<ffff20000808ecf0>] sys_mmap+0x58/0x80 arch/arm64/kernel/sys.c:37
> [<ffff200008083f70>] el0_svc_naked+0x24/0x28
>

We hold kvm->mmu_lock, while manipulating the stage2 ranges. However, I find that
we don't take the lock, when we do it f rom kvm_free_stage2_pgd(), which could
potentially have caused a problem with an munmap of a memslot ?

Lightly tested...


commit fa75684dbf0fe845cf8403517d6e0c2c3344a544
Author: Suzuki K Poulose <suzuki.poulose@arm.com>
Date:   Tue Mar 14 10:26:54 2017 +0000

     kvm: arm: Fix locking for kvm_free_stage2_pgd
     
     In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while calling
     unmap_stage2_range() on the entire memory range for the guest. This could
     cause problems with other callers (e.g, munmap on a memslot) trying to
     unmap a range.
     
     Cc: Marc Zyngier <marc.zyngier@arm.com>
     Cc: Christoffer Dall <christoffer.dall@linaro.org>
     Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index a07ce3e..7f97063 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -831,7 +831,10 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
         if (kvm->arch.pgd == NULL)
                 return;
  
+       spin_lock(&kvm->mmu_lock);
         unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+       spin_unlock(&kvm->mmu_lock);
+
         /* Free the HW pgd, one page at a time */
         free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
         kvm->arch.pgd = NULL;




> The buggy address belongs to the page:
> page:ffff7e0001161700 count:0 mapcount:0 mapping:          (null) index:0x0
> flags: 0xfffc00000000000()
> raw: 0fffc00000000000 0000000000000000 0000000000000000 00000000ffffffff
> raw: ffff7e00018c9120 ffff7e0000ea8b60 0000000000000000 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff80004585bf00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff80004585bf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> ffff80004585c000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                    ^
>  ffff80004585c080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff80004585c100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ==================================================================
>
