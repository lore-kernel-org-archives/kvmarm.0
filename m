From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: kvm/arm64: use-after-free in
 kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Wed, 12 Apr 2017 18:19:36 +0200
Message-ID: <CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com>
References: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
 <20f6c994-d83e-7a6f-9f13-f10287211a6c@arm.com>
 <9f473bb9-d0eb-6803-1263-75ffef0301fe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C937B40C1C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Apr 2017 12:17:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id StQLchYAB4G5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Apr 2017 12:17:13 -0400 (EDT)
Received: from mail-pf0-f181.google.com (mail-pf0-f181.google.com
 [209.85.192.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 221BF40BE4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Apr 2017 12:17:12 -0400 (EDT)
Received: by mail-pf0-f181.google.com with SMTP id c198so16040587pfc.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Apr 2017 09:19:39 -0700 (PDT)
In-Reply-To: <9f473bb9-d0eb-6803-1263-75ffef0301fe@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, "commit_signer:26/27=96%)"@google.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>, linux-arm-kernel@lists.infradead.org, Dmitry Vyukov <dvyukov@google.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 14, 2017 at 5:57 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 14/03/2017 12:07, Suzuki K Poulose wrote:
>> On 10/03/17 13:34, Andrey Konovalov wrote:
>>> Hi,
>>>
>>> I've got the following error report while fuzzing the kernel with
>>> syzkaller.
>>>
>>> On linux-next commit 56b8bad5e066c23e8fa273ef5fba50bd3da2ace8 (Mar 8).
>>>
>>> Unfortunately I can't reproduce it.
>>>
>>> ==================================================================
>>> BUG: KASAN: use-after-free in put_page include/linux/compiler.h:243
>>> [inline]
>>> BUG: KASAN: use-after-free in unmap_stage2_pmds
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:240 [inline]
>>> BUG: KASAN: use-after-free in unmap_stage2_puds
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:269 [inline]
>>> BUG: KASAN: use-after-free in unmap_stage2_range+0x884/0x938
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:299
>>> Read of size 8 at addr ffff80004585c000 by task syz-executor/5176
>>
>>
>>> [<ffff2000080d9664>] put_page include/linux/compiler.h:243 [inline]
>>> [<ffff2000080d9664>] unmap_stage2_pmds
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:240 [inline]
>>> [<ffff2000080d9664>] unmap_stage2_puds
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:269 [inline]
>>> [<ffff2000080d9664>] unmap_stage2_range+0x884/0x938
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:299
>>> [<ffff2000080d9740>] kvm_unmap_hva_handler+0x28/0x38
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1556
>>> [<ffff2000080d7578>] handle_hva_to_gpa+0x140/0x250
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1547
>>> [<ffff2000080db858>] kvm_unmap_hva_range+0x60/0x80
>>> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1579
>>> [<ffff2000080c12dc>]
>>> kvm_mmu_notifier_invalidate_range_start+0x194/0x278
>>> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:357
>>> [<ffff2000083fea58>] __mmu_notifier_invalidate_range_start+0x1d0/0x2a0
>>> mm/mmu_notifier.c:199
>>> [<ffff200008395f44>] mmu_notifier_invalidate_range_start
>>> include/linux/mmu_notifier.h:282 [inline]
>>> [<ffff200008395f44>] unmap_vmas+0x12c/0x198 mm/memory.c:1372
>>> [<ffff2000083a8e00>] unmap_region+0x128/0x230 mm/mmap.c:2460
>>> [<ffff2000083ae6e0>] update_hiwater_vm include/linux/mm.h:1483 [inline]
>>> [<ffff2000083ae6e0>] remove_vma_list mm/mmap.c:2432 [inline]
>>> [<ffff2000083ae6e0>] do_munmap+0x598/0x9b0 mm/mmap.c:2662
>>> [<ffff2000083b14a0>] find_vma_links mm/mmap.c:495 [inline]
>>> [<ffff2000083b14a0>] mmap_region+0x138/0xc78 mm/mmap.c:1610
>>> [<ffff2000083b23ac>] is_file_hugepages include/linux/hugetlb.h:269
>>> [inline]
>>> [<ffff2000083b23ac>] do_mmap+0x3cc/0x848 mm/mmap.c:1446
>>> [<ffff200008369b0c>] do_mmap_pgoff include/linux/mm.h:2039 [inline]
>>> [<ffff200008369b0c>] vm_mmap_pgoff+0xec/0x120 mm/util.c:305
>>> [<ffff2000083ac558>] SYSC_mmap_pgoff mm/mmap.c:1475 [inline]
>>> [<ffff2000083ac558>] SyS_mmap_pgoff+0x220/0x420 mm/mmap.c:1458
>>> [<ffff20000808ecf0>] sys_mmap+0x58/0x80 arch/arm64/kernel/sys.c:37
>>> [<ffff200008083f70>] el0_svc_naked+0x24/0x28
>>>
>>
>> We hold kvm->mmu_lock, while manipulating the stage2 ranges. However, I
>> find that
>> we don't take the lock, when we do it f rom kvm_free_stage2_pgd(), which
>> could
>> potentially have caused a problem with an munmap of a memslot ?
>>
>> Lightly tested...
>>
>>
>> commit fa75684dbf0fe845cf8403517d6e0c2c3344a544
>> Author: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Date:   Tue Mar 14 10:26:54 2017 +0000
>>
>>     kvm: arm: Fix locking for kvm_free_stage2_pgd
>>         In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while
>> calling
>>     unmap_stage2_range() on the entire memory range for the guest. This
>> could
>>     cause problems with other callers (e.g, munmap on a memslot) trying to
>>     unmap a range.
>>         Cc: Marc Zyngier <marc.zyngier@arm.com>
>>     Cc: Christoffer Dall <christoffer.dall@linaro.org>
>>     Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index a07ce3e..7f97063 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -831,7 +831,10 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
>>         if (kvm->arch.pgd == NULL)
>>                 return;
>>
>> +       spin_lock(&kvm->mmu_lock);
>>         unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
>> +       spin_unlock(&kvm->mmu_lock);
>> +
>>         /* Free the HW pgd, one page at a time */
>>         free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
>>         kvm->arch.pgd = NULL;
>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>>
>>
>>> The buggy address belongs to the page:
>>> page:ffff7e0001161700 count:0 mapcount:0 mapping:          (null)
>>> index:0x0
>>> flags: 0xfffc00000000000()
>>> raw: 0fffc00000000000 0000000000000000 0000000000000000 00000000ffffffff
>>> raw: ffff7e00018c9120 ffff7e0000ea8b60 0000000000000000 0000000000000000
>>> page dumped because: kasan: bad access detected
>>>
>>> Memory state around the buggy address:
>>>  ffff80004585bf00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  ffff80004585bf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> ffff80004585c000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>                    ^
>>>  ffff80004585c080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  ffff80004585c100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> ==================================================================
>>>
>>

Hi,

Apparently this wasn't fixed, I've got this report again on
linux-next-c4e7b35a3 (Apr 11), which includes 8b3405e34 "kvm:
arm/arm64: Fix locking for kvm_free_stage2_pgd".

I now have a way to reproduce it, so I can test proposed patches. I
don't have a simple C reproducer though.

The bug happens when the following syzkaller program is executed:

mmap(&(0x7f0000000000/0xc000)=nil, (0xc000), 0x3, 0x32, 0xffffffffffffffff, 0x0)
unshare(0x400)
perf_event_open(&(0x7f000002f000-0x78)={0x1, 0x78, 0x0, 0x0, 0x0, 0x0,
0x0, 0x6, 0x0, 0x0, 0xd34, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x0, 0xffffffff,
0xffffffffffffffff, 0x0)
r0 = openat$kvm(0xffffffffffffff9c,
&(0x7f000000c000-0x9)="2f6465762f6b766d00", 0x0, 0x0)
ioctl$TIOCSBRK(0xffffffffffffffff, 0x5427)
r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
syz_kvm_setup_cpu$arm64(r1, 0xffffffffffffffff,
&(0x7f0000dc6000/0x18000)=nil, &(0x7f000000c000)=[{0x0,
&(0x7f000000c000)="5ba3c16f533efbed09f8221253c73763327fadce2371813b45dd7f7982f84a873e4ae89a6c2bd1af83a6024c36a1ff518318",
0x32}], 0x1, 0x0, &(0x7f000000d000-0x10)=[@featur2={0x1, 0x3}], 0x1)

==================================================================
BUG: KASAN: use-after-free in arch_spin_is_locked
include/linux/compiler.h:254 [inline]
BUG: KASAN: use-after-free in unmap_stage2_range+0x990/0x9a8
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:295
Read of size 8 at addr ffff800004476730 by task syz-executor/13106

CPU: 1 PID: 13106 Comm: syz-executor Not tainted
4.11.0-rc6-next-20170411-xc2-11025-gc4e7b35a33d4-dirty #5
Hardware name: Hardkernel ODROID-C2 (DT)
Call trace:
[<ffff20000808fd08>] dump_backtrace+0x0/0x440 arch/arm64/kernel/traps.c:505
[<ffff2000080903c0>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:228
[<ffff2000088df030>] __dump_stack lib/dump_stack.c:16 [inline]
[<ffff2000088df030>] dump_stack+0x110/0x168 lib/dump_stack.c:52
[<ffff200008406db8>] print_address_description+0x60/0x248 mm/kasan/report.c:252
[<ffff2000084072c8>] kasan_report_error mm/kasan/report.c:351 [inline]
[<ffff2000084072c8>] kasan_report+0x218/0x300 mm/kasan/report.c:408
[<ffff200008407428>] __asan_report_load8_noabort+0x18/0x20 mm/kasan/report.c:429
[<ffff2000080db1b8>] arch_spin_is_locked include/linux/compiler.h:254 [inline]
[<ffff2000080db1b8>] unmap_stage2_range+0x990/0x9a8
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:295
[<ffff2000080db248>] kvm_free_stage2_pgd.part.16+0x30/0x98
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:842
[<ffff2000080ddfb8>] kvm_free_stage2_pgd
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:838 [inline]
[<ffff2000080ddfb8>] kvm_arch_flush_shadow_all+0x40/0x58
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1895
[<ffff2000080c379c>] kvm_mmu_notifier_release+0x154/0x1d0
arch/arm64/kvm/../../../virt/kvm/kvm_main.c:472
[<ffff2000083f2b60>] __mmu_notifier_release+0x1c0/0x3e0 mm/mmu_notifier.c:75
[<ffff2000083a1fb4>] mmu_notifier_release
include/linux/mmu_notifier.h:235 [inline]
[<ffff2000083a1fb4>] exit_mmap+0x21c/0x288 mm/mmap.c:2941
[<ffff20000810ecd4>] __mmput kernel/fork.c:888 [inline]
[<ffff20000810ecd4>] mmput+0xdc/0x2e0 kernel/fork.c:910
[<ffff20000811fda8>] exit_mm kernel/exit.c:557 [inline]
[<ffff20000811fda8>] do_exit+0x648/0x2020 kernel/exit.c:865
[<ffff2000081218b4>] do_group_exit+0xdc/0x260 kernel/exit.c:982
[<ffff20000813adf0>] get_signal+0x358/0xf58 kernel/signal.c:2318
[<ffff20000808de98>] do_signal+0x170/0xc10 arch/arm64/kernel/signal.c:370
[<ffff20000808edb4>] do_notify_resume+0xe4/0x120 arch/arm64/kernel/signal.c:421
[<ffff200008083e68>] work_pending+0x8/0x14

The buggy address belongs to the page:
page:ffff7e0000111d80 count:0 mapcount:-127 mapping:          (null) index:0x0
flags: 0xfffc00000000000()
raw: 0fffc00000000000 0000000000000000 0000000000000000 00000000ffffff80
raw: ffff7e00009698a0 ffff7e00008eefa0 0000000000000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff800004476600: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff800004476680: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff800004476700: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                     ^
 ffff800004476780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff800004476800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
