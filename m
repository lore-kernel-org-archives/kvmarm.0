From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: kvm/arm64: use-after-free in kvm_vm_ioctl/vmacache_update
Date: Mon, 13 Mar 2017 09:58:29 +0000
Message-ID: <0fc0380f-f108-7d20-ee8a-1b044fa1f115@arm.com>
References: <CAAeHK+wha3wr=HraKtGMqeEnZUU6-jboowG5PWRMHtqwTQC7FQ@mail.gmail.com>
 <CAAeHK+wLjS5ZGdNb4W3UkWO8HsFB=s1+a-1boN_F0boM1-bxUg@mail.gmail.com>
 <3a57c408-8aa5-d339-4176-add4924e817d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87B0C40BC4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Mar 2017 05:57:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JHqyXN3kuXdZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Mar 2017 05:57:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E27EF40296
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Mar 2017 05:57:03 -0400 (EDT)
In-Reply-To: <3a57c408-8aa5-d339-4176-add4924e817d@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Suraj Jitindar Singh <sjitindarsingh@gmail.com>, Markus Elfring <elfring@users.sourceforge.net>, Lorenzo Stoakes <lstoakes@gmail.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>
Cc: Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>, Dmitry Vyukov <dvyukov@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/03/17 18:37, Suzuki K Poulose wrote:
> On 10/03/17 15:50, Andrey Konovalov wrote:
>> On Fri, Mar 10, 2017 at 2:38 PM, Andrey Konovalov <andreyknvl@google.com> wrote:
>>> Hi,
>>>
>>> I've got the following error report while fuzzing the kernel with syzkaller.
>>>
>>> On linux-next commit 56b8bad5e066c23e8fa273ef5fba50bd3da2ace8 (Mar 8).
>>>
>>> Unfortunately I can't reproduce it.
>>>
>>> ==================================================================
>>> BUG: KASAN: use-after-free in vmacache_update+0x114/0x118 mm/vmacache.c:63
>>> Read of size 8 at addr ffff80003b9a2040 by task syz-executor/26615
>>>
>>> CPU: 1 PID: 26615 Comm: syz-executor Not tainted
>>> 4.11.0-rc1-next-20170308-xc2-dirty #3
>>> Hardware name: Hardkernel ODROID-C2 (DT)
>>> Call trace:
>>> [<ffff20000808fbb0>] dump_backtrace+0x0/0x440 arch/arm64/kernel/traps.c:505
>>> [<ffff200008090010>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:228
>>> [<ffff2000088e9578>] __dump_stack lib/dump_stack.c:16 [inline]
>>> [<ffff2000088e9578>] dump_stack+0x110/0x168 lib/dump_stack.c:52
>>> [<ffff200008414018>] print_address_description+0x60/0x248 mm/kasan/report.c:250
>>> [<ffff2000084142e8>] kasan_report_error+0xe8/0x250 mm/kasan/report.c:349
>>> [<ffff200008414564>] kasan_report mm/kasan/report.c:372 [inline]
>>> [<ffff200008414564>] __asan_report_load8_noabort+0x3c/0x48 mm/kasan/report.c:393
>>> [<ffff200008383f64>] vmacache_update+0x114/0x118 mm/vmacache.c:63
>>> [<ffff2000083a9000>] find_vma+0xf8/0x150 mm/mmap.c:2124
>>> [<ffff2000080dc19c>] kvm_arch_prepare_memory_region+0x2ac/0x488
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1817
>>> [<ffff2000080c2920>] __kvm_set_memory_region+0x3d8/0x12b8
>>> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1026
>>> [<ffff2000080c3838>] kvm_set_memory_region+0x38/0x58
>>> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1075
>>> [<ffff2000080c747c>] kvm_vm_ioctl_set_memory_region
>>> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1087 [inline]
>>> [<ffff2000080c747c>] kvm_vm_ioctl+0xb94/0x1308
>>> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:2960
>>> [<ffff20000848f928>] vfs_ioctl fs/ioctl.c:45 [inline]
>>> [<ffff20000848f928>] do_vfs_ioctl+0x128/0xfc0 fs/ioctl.c:685
>>> [<ffff200008490868>] SYSC_ioctl fs/ioctl.c:700 [inline]
>>> [<ffff200008490868>] SyS_ioctl+0xa8/0xb8 fs/ioctl.c:691
>>> [<ffff200008083f70>] el0_svc_naked+0x24/0x28
>>>
>>> Allocated by task 26657:
>>>  save_stack_trace_tsk+0x0/0x330 arch/arm64/kernel/stacktrace.c:133
>>>  save_stack_trace+0x20/0x30 arch/arm64/kernel/stacktrace.c:216
>>>  save_stack mm/kasan/kasan.c:515 [inline]
>>>  set_track mm/kasan/kasan.c:527 [inline]
>>>  kasan_kmalloc+0xd4/0x180 mm/kasan/kasan.c:619
>>>  kasan_slab_alloc+0x14/0x20 mm/kasan/kasan.c:557
>>>  slab_post_alloc_hook mm/slab.h:456 [inline]
>>>  slab_alloc_node mm/slub.c:2718 [inline]
>>>  slab_alloc mm/slub.c:2726 [inline]
>>>  kmem_cache_alloc+0x144/0x230 mm/slub.c:2731
>>>  __split_vma+0x118/0x608 mm/mmap.c:2515
>>>  do_munmap+0x194/0x9b0 mm/mmap.c:2636
>>> Freed by task 26657:
>>>  save_stack_trace_tsk+0x0/0x330 arch/arm64/kernel/stacktrace.c:133
>>>  save_stack_trace+0x20/0x30 arch/arm64/kernel/stacktrace.c:216
>>>  save_stack mm/kasan/kasan.c:515 [inline]
>>>  set_track mm/kasan/kasan.c:527 [inline]
>>>  kasan_slab_free+0x84/0x198 mm/kasan/kasan.c:592
>>>  slab_free_hook mm/slub.c:1357 [inline]
>>>  slab_free_freelist_hook mm/slub.c:1379 [inline]
>>>  slab_free mm/slub.c:2961 [inline]
>>>  kmem_cache_free+0x80/0x258 mm/slub.c:2983
>>>  __vma_adjust+0x6b0/0xf mm/mmap.c:890]  el0_svc_naked+0x24/0x28
>>>
>>> The buggy address belongs to the object at ffff80003b9a2000
>>>  which belongs to the cache vm_area_struct(647:session-6.scope) of size 184
>>> The buggy address is located 64 bytes inside of
>>>  184-byte region [ffff80003b9a2000, ffff80003b9a20b8)
>>> The buggy address belongs to the page:
>>> page:ffff7e0000ee6880 count:1 mapcount:0 mapping:          (null) index:0x0
>>> flags: 0xfffc00000000100(slab)
>>> raw: 0fffc00000000100 0000000000000000 0000000000000000 0000000180100010
>>> raw: 0000000000000000 0000000c00000001 ffff80005a5cc600 ffff80005ac99980
>>> page dumped because: kasan: bad access detected
>>> page->mem_cgroup:ffff80005ac99980
>>>
>>> Memory state around the buggy address:
>>>  ffff80003b9a1f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  ffff80003b9a1f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> ffff80003b9a2000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>                                            ^
>>>  ffff80003b9a2080: fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc fb
>>>  ffff80003b9a2100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>> ==================================================================
>>
>> Another one that looks related and doesn't have parts of stack traces missing:
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in find_vma+0x140/0x150 mm/mmap.c:2114
>> Read of size 8 at addr ffff800031a03e90 by task syz-executor/4360
>>
>> CPU: 2 PID: 4360 Comm: syz-executor Not tainted
>> 4.11.0-rc1-next-20170308-xc2-dirty #3
>> Hardware name: Hardkernel ODROID-C2 (DT)
>> Call trace:
>> [<ffff20000808fbb0>] dump_backtrace+0x0/0x440 arch/arm64/kernel/traps.c:505
>> [<ffff200008090010>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:228
>> [<ffff2000088e9578>] __dump_stack lib/dump_stack.c:16 [inline]
>> [<ffff2000088e9578>] dump_stack+0x110/0x168 lib/dump_stack.c:52
>> [<ffff200008414018>] print_address_description+0x60/0x248 mm/kasan/report.c:250
>> [<ffff2000084142e8>] kasan_report_error+0xe8/0x250 mm/kasan/report.c:349
>> [<ffff200008414564>] kasan_report mm/kasan/report.c:372 [inline]
>> [<ffff200008414564>] __asan_report_load8_noabort+0x3c/0x48 mm/kasan/report.c:393
>> [<ffff2000083a9048>] find_vma+0x140/0x150 mm/mmap.c:2114
>> [<ffff2000080dc19c>] kvm_arch_prepare_memory_region+0x2ac/0x488
>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1817
> 
> It looks like we don't take the mmap_sem before calling find_vma() in
> stage2_unmap_memslot() and in kvm_arch_prepare_memory_region(), which is causing
> the race, with probably the test trying to unmap ranges in between.

That indeed seems like a possible failure mode. The annoying thing is 
that we're not exactly in a position to take mmap_sem in 
stage2_unmap_memslot, since we hold the kvm->mmu_lock spinlock. We may 
have to hold mmap_sem while iterating over all the memslots.

How about the following (very lightly tested):

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 962616fd4ddd..2006a79d5912 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -803,6 +803,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
+	down_read(&current->mm->mmap_sem);
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
@@ -810,6 +811,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 		stage2_unmap_memslot(kvm, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
+	up_read(&current->mm->mmap_sem);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -1813,6 +1815,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 *     |               memory region                |
 	 *     +--------------------------------------------+
 	 */
+	down_read(&current->mm->mmap_sem);
 	do {
 		struct vm_area_struct *vma = find_vma(current->mm, hva);
 		hva_t vm_start, vm_end;
@@ -1857,7 +1860,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	} while (hva < reg_end);
 
 	if (change == KVM_MR_FLAGS_ONLY)
-		return ret;
+		goto out;
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
@@ -1865,6 +1868,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	else
 		stage2_flush_memslot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
+
+out:
+	up_read(&current->mm->mmap_sem);
 	return ret;
 }
 

I'm much more worried about the other report, as I don't really see yet 
how it happens. Coffee required.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
