From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: kvm/arm64: use-after-free in
 kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Wed, 12 Apr 2017 19:43:58 +0100
Message-ID: <1050c9d8-5813-5df9-29e5-3ab6e61b5de6@arm.com>
References: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
 <20f6c994-d83e-7a6f-9f13-f10287211a6c@arm.com>
 <9f473bb9-d0eb-6803-1263-75ffef0301fe@redhat.com>
 <CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, "commit_signer:26/27=96%)"@google.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12/04/17 17:19, Andrey Konovalov wrote:

Hi Andrey,

> Apparently this wasn't fixed, I've got this report again on
> linux-next-c4e7b35a3 (Apr 11), which includes 8b3405e34 "kvm:
> arm/arm64: Fix locking for kvm_free_stage2_pgd".

This looks like a different bug.

> 
> I now have a way to reproduce it, so I can test proposed patches. I
> don't have a simple C reproducer though.
> 
> The bug happens when the following syzkaller program is executed:
> 
> mmap(&(0x7f0000000000/0xc000)=nil, (0xc000), 0x3, 0x32, 0xffffffffffffffff, 0x0)
> unshare(0x400)
> perf_event_open(&(0x7f000002f000-0x78)={0x1, 0x78, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0x6, 0x0, 0x0, 0xd34, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x0, 0xffffffff,
> 0xffffffffffffffff, 0x0)
> r0 = openat$kvm(0xffffffffffffff9c,
> &(0x7f000000c000-0x9)="2f6465762f6b766d00", 0x0, 0x0)
> ioctl$TIOCSBRK(0xffffffffffffffff, 0x5427)
> r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
> syz_kvm_setup_cpu$arm64(r1, 0xffffffffffffffff,
> &(0x7f0000dc6000/0x18000)=nil, &(0x7f000000c000)=[{0x0,
> &(0x7f000000c000)="5ba3c16f533efbed09f8221253c73763327fadce2371813b45dd7f7982f84a873e4ae89a6c2bd1af83a6024c36a1ff518318",
> 0x32}], 0x1, 0x0, &(0x7f000000d000-0x10)=[@featur2={0x1, 0x3}], 0x1)

Is that the only thing the program does? Or is there anything running in
parallel?

> ==================================================================
> BUG: KASAN: use-after-free in arch_spin_is_locked
> include/linux/compiler.h:254 [inline]
> BUG: KASAN: use-after-free in unmap_stage2_range+0x990/0x9a8
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:295
> Read of size 8 at addr ffff800004476730 by task syz-executor/13106
> 
> CPU: 1 PID: 13106 Comm: syz-executor Not tainted
> 4.11.0-rc6-next-20170411-xc2-11025-gc4e7b35a33d4-dirty #5
> Hardware name: Hardkernel ODROID-C2 (DT)
> Call trace:
> [<ffff20000808fd08>] dump_backtrace+0x0/0x440 arch/arm64/kernel/traps.c:505
> [<ffff2000080903c0>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:228
> [<ffff2000088df030>] __dump_stack lib/dump_stack.c:16 [inline]
> [<ffff2000088df030>] dump_stack+0x110/0x168 lib/dump_stack.c:52
> [<ffff200008406db8>] print_address_description+0x60/0x248 mm/kasan/report.c:252
> [<ffff2000084072c8>] kasan_report_error mm/kasan/report.c:351 [inline]
> [<ffff2000084072c8>] kasan_report+0x218/0x300 mm/kasan/report.c:408
> [<ffff200008407428>] __asan_report_load8_noabort+0x18/0x20 mm/kasan/report.c:429
> [<ffff2000080db1b8>] arch_spin_is_locked include/linux/compiler.h:254 [inline]

This is the assert on the spinlock, and the memory is gone.

> [<ffff2000080db1b8>] unmap_stage2_range+0x990/0x9a8
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:295
> [<ffff2000080db248>] kvm_free_stage2_pgd.part.16+0x30/0x98
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:842
> [<ffff2000080ddfb8>] kvm_free_stage2_pgd
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:838 [inline]

But we've taken than lock here. There's only a handful of instructions
in between, and the memory can only go away if there is something
messing with us in parallel.

> [<ffff2000080ddfb8>] kvm_arch_flush_shadow_all+0x40/0x58
> arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1895
> [<ffff2000080c379c>] kvm_mmu_notifier_release+0x154/0x1d0
> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:472
> [<ffff2000083f2b60>] __mmu_notifier_release+0x1c0/0x3e0 mm/mmu_notifier.c:75
> [<ffff2000083a1fb4>] mmu_notifier_release
> include/linux/mmu_notifier.h:235 [inline]
> [<ffff2000083a1fb4>] exit_mmap+0x21c/0x288 mm/mmap.c:2941
> [<ffff20000810ecd4>] __mmput kernel/fork.c:888 [inline]
> [<ffff20000810ecd4>] mmput+0xdc/0x2e0 kernel/fork.c:910
> [<ffff20000811fda8>] exit_mm kernel/exit.c:557 [inline]
> [<ffff20000811fda8>] do_exit+0x648/0x2020 kernel/exit.c:865
> [<ffff2000081218b4>] do_group_exit+0xdc/0x260 kernel/exit.c:982
> [<ffff20000813adf0>] get_signal+0x358/0xf58 kernel/signal.c:2318
> [<ffff20000808de98>] do_signal+0x170/0xc10 arch/arm64/kernel/signal.c:370
> [<ffff20000808edb4>] do_notify_resume+0xe4/0x120 arch/arm64/kernel/signal.c:421
> [<ffff200008083e68>] work_pending+0x8/0x14

So we're being serviced with a signal. Do you know if this signal is
generated by your syzkaller program? We could be racing between do_exit
triggered by a fatal signal (this trace) and the closing of the two file
descriptors (vcpu and vm).

Paolo: does this look possible to you? I can't see what locking we have
that could prevent this race.

Thanks,
	
M.
-- 
Jazz is not dead. It just smells funny...
