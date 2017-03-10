From: Andrey Konovalov <andreyknvl@google.com>
Subject: kvm/arm64: use-after-free in kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Fri, 10 Mar 2017 14:34:25 +0100
Message-ID: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, "commit_signer:26/27=96%)"@google.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I've got the following error report while fuzzing the kernel with syzkaller.

On linux-next commit 56b8bad5e066c23e8fa273ef5fba50bd3da2ace8 (Mar 8).

Unfortunately I can't reproduce it.

==================================================================
BUG: KASAN: use-after-free in put_page include/linux/compiler.h:243 [inline]
BUG: KASAN: use-after-free in unmap_stage2_pmds
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:240 [inline]
BUG: KASAN: use-after-free in unmap_stage2_puds
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:269 [inline]
BUG: KASAN: use-after-free in unmap_stage2_range+0x884/0x938
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:299
Read of size 8 at addr ffff80004585c000 by task syz-executor/5176

CPU: 1 PID: 5176 Comm: syz-executor Not tainted
4.11.0-rc1-next-20170308-xc2-dirty #3
Hardware name: Hardkernel ODROID-C2 (DT)
Call trace:
[<ffff20000808fbb0>] dump_backtrace+0x0/0x440 arch/arm64/kernel/traps.c:69
[<ffff200008090010>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:219
[<ffff2000088e9578>] __write_once_size include/linux/compiler.h:271 [inline]
[<ffff2000088e9578>] dump_stack+0x110/0x168 lib/dump_stack.c:54
[<ffff200008414018>] print_address_description+0x60/0x248
[<ffff2000084142e8>] print_error_description mm/kasan/report.c:98 [inline]
[<ffff2000084142e8>] kasan_report_error+0xe8/0x250 mm/kasan/report.c:287
[<ffff200008414564>] kasan_report mm/kasan/report.c:308 [inline]
[<ffff200008414564>] __asan_report_load8_noabort+0x3c/0x48 mm/kasan/report.c:329
[<ffff2000080d9664>] put_page include/linux/compiler.h:243 [inline]
[<ffff2000080d9664>] unmap_stage2_pmds
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:240 [inline]
[<ffff2000080d9664>] unmap_stage2_puds
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:269 [inline]
[<ffff2000080d9664>] unmap_stage2_range+0x884/0x938
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:299
[<ffff2000080d9740>] kvm_unmap_hva_handler+0x28/0x38
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1556
[<ffff2000080d7578>] handle_hva_to_gpa+0x140/0x250
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1547
[<ffff2000080db858>] kvm_unmap_hva_range+0x60/0x80
arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1579
[<ffff2000080c12dc>]
kvm_mmu_notifier_invalidate_range_start+0x194/0x278
arch/arm64/kvm/../../../virt/kvm/kvm_main.c:357
[<ffff2000083fea58>] __mmu_notifier_invalidate_range_start+0x1d0/0x2a0
mm/mmu_notifier.c:199
[<ffff200008395f44>] mmu_notifier_invalidate_range_start
include/linux/mmu_notifier.h:282 [inline]
[<ffff200008395f44>] unmap_vmas+0x12c/0x198 mm/memory.c:1372
[<ffff2000083a8e00>] unmap_region+0x128/0x230 mm/mmap.c:2460
[<ffff2000083ae6e0>] update_hiwater_vm include/linux/mm.h:1483 [inline]
[<ffff2000083ae6e0>] remove_vma_list mm/mmap.c:2432 [inline]
[<ffff2000083ae6e0>] do_munmap+0x598/0x9b0 mm/mmap.c:2662
[<ffff2000083b14a0>] find_vma_links mm/mmap.c:495 [inline]
[<ffff2000083b14a0>] mmap_region+0x138/0xc78 mm/mmap.c:1610
[<ffff2000083b23ac>] is_file_hugepages include/linux/hugetlb.h:269 [inline]
[<ffff2000083b23ac>] do_mmap+0x3cc/0x848 mm/mmap.c:1446
[<ffff200008369b0c>] do_mmap_pgoff include/linux/mm.h:2039 [inline]
[<ffff200008369b0c>] vm_mmap_pgoff+0xec/0x120 mm/util.c:305
[<ffff2000083ac558>] SYSC_mmap_pgoff mm/mmap.c:1475 [inline]
[<ffff2000083ac558>] SyS_mmap_pgoff+0x220/0x420 mm/mmap.c:1458
[<ffff20000808ecf0>] sys_mmap+0x58/0x80 arch/arm64/kernel/sys.c:37
[<ffff200008083f70>] el0_svc_naked+0x24/0x28

The buggy address belongs to the page:
page:ffff7e0001161700 count:0 mapcount:0 mapping:          (null) index:0x0
flags: 0xfffc00000000000()
raw: 0fffc00000000000 0000000000000000 0000000000000000 00000000ffffffff
raw: ffff7e00018c9120 ffff7e0000ea8b60 0000000000000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff80004585bf00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff80004585bf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff80004585c000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff80004585c080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff80004585c100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
