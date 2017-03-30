From: Mark Rutland <mark.rutland@arm.com>
Subject: KVM/ARM: sleeping function called from invalid context
Date: Thu, 30 Mar 2017 15:31:12 +0100
Message-ID: <20170330143112.GI16211@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: suzuki.poulose@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I'm seeing the splat below when running KVM on an arm64 host with
CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_LOCKDEP enabled.

I saw this on v4.11-rc1, and I can reproduce the problem on the current
kvmarm master branch (563e2f5daa66fbc1).

I've hacked noinlines into arch/arm/kvm/mmu.c in an attempt to get a
better backtrace; without this, the report says the call is at
arch/arm/kvm/mmu.c:299, which is somewhat confusing.

Splat:

[  135.549391] BUG: sleeping function called from invalid context at arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:302
[  135.559712] in_atomic(): 1, irqs_disabled(): 0, pid: 2311, name: kvm-vcpu-0
[  135.566709] 8 locks held by kvm-vcpu-0/2311:
[  135.571010]  #0:  (&vcpu->mutex){+.+.+.}, at: [<ffff2000080d7c70>] vcpu_load+0x28/0x2b0
[  135.579075]  #1:  (&kvm->srcu){......}, at: [<ffff2000080ff358>] kvm_handle_guest_abort+0x208/0x7d0
[  135.588177]  #2:  (&mm->mmap_sem){++++++}, at: [<ffff2000084d57f4>] get_user_pages_unlocked+0xbc/0x370
[  135.597540]  #3:  (&anon_vma->rwsem){++++..}, at: [<ffff20000851b064>] page_lock_anon_vma_read+0x164/0x588
[  135.607244]  #4:  (&(ptlock_ptr(page))->rlock){+.+.-.}, at: [<ffff20000850e2c0>] page_vma_mapped_walk+0x8b0/0x14f0
[  135.617647]  #5:  (&srcu){......}, at: [<ffff200008571c9c>] __mmu_notifier_invalidate_page+0x10c/0x3c0
[  135.627012]  #6:  (&kvm->srcu){......}, at: [<ffff2000080dafd4>] kvm_mmu_notifier_invalidate_page+0x10c/0x320
[  135.636980]  #7:  (&(&kvm->mmu_lock)->rlock){+.+.-.}, at: [<ffff2000080db00c>] kvm_mmu_notifier_invalidate_page+0x144/0x320
[  135.648180] CPU: 1 PID: 2311 Comm: kvm-vcpu-0 Not tainted 4.11.0-rc1-00006-gf9bc6f5-dirty #2
[  135.656616] Hardware name: AMD Seattle (Rev.B0) Development Board (Overdrive) (DT)
[  135.664183] Call trace:
[  135.666636] [<ffff200008094ee0>] dump_backtrace+0x0/0x588
[  135.672039] [<ffff200008095488>] show_stack+0x20/0x30
[  135.677095] [<ffff200008c34a44>] dump_stack+0x16c/0x1e0
[  135.682325] [<ffff2000081cb0fc>] ___might_sleep+0x2e4/0x508
[  135.687902] [<ffff2000080faee4>] unmap_stage2_range+0x114/0x200
[  135.693825] [<ffff2000080faff8>] kvm_unmap_hva_handler+0x28/0x38
[  135.699836] [<ffff2000080fb908>] handle_hva_to_gpa+0x178/0x2a0
[  135.705672] [<ffff2000080ff984>] kvm_unmap_hva+0x64/0xa0
[  135.710989] [<ffff2000080db048>] kvm_mmu_notifier_invalidate_page+0x180/0x320
[  135.718128] [<ffff200008571d6c>] __mmu_notifier_invalidate_page+0x1dc/0x3c0
[  135.725094] [<ffff200008517cb8>] try_to_unmap_one+0x4a0/0x1360
[  135.730931] [<ffff2000085121c0>] rmap_walk_anon+0x2d0/0xa68
[  135.736507] [<ffff20000851b58c>] rmap_walk+0x104/0x1e0
[  135.741649] [<ffff20000851c1b8>] try_to_unmap+0x1b8/0x500
[  135.747053] [<ffff20000859bbcc>] __unmap_and_move+0x364/0x938
[  135.752802] [<ffff20000859c31c>] unmap_and_move.isra.3+0x17c/0xd40
[  135.758987] [<ffff20000859e0f0>] migrate_pages+0x228/0x960
[  135.764477] [<ffff2000084c232c>] compact_zone+0xeec/0x1d10
[  135.769967] [<ffff2000084c3264>] compact_zone_order+0x114/0x198
[  135.775891] [<ffff2000084c5260>] try_to_compact_pages+0x338/0x758
[  135.781992] [<ffff2000084439a0>] __alloc_pages_direct_compact+0x80/0x858
[  135.788698] [<ffff2000084451d4>] __alloc_pages_nodemask+0x7bc/0x1b18
[  135.795055] [<ffff20000856af2c>] alloc_pages_vma+0x48c/0x848
[  135.800719] [<ffff2000085a9680>] do_huge_pmd_anonymous_page+0x2e0/0x1b48
[  135.807423] [<ffff2000084f153c>] __handle_mm_fault+0xe64/0x1de8
[  135.813346] [<ffff2000084f28cc>] handle_mm_fault+0x40c/0xbc0
[  135.819009] [<ffff2000084d48f8>] __get_user_pages+0x210/0x888
[  135.824760] [<ffff2000084d5920>] get_user_pages_unlocked+0x1e8/0x370
[  135.831119] [<ffff2000080e265c>] __gfn_to_pfn_memslot+0x634/0xae0
[  135.837220] [<ffff2000080e2b50>] gfn_to_pfn_prot+0x48/0x58
[  135.842711] [<ffff2000080fdc78>] user_mem_abort+0x380/0x7c8
[  135.848288] [<ffff2000080ff43c>] kvm_handle_guest_abort+0x2ec/0x7d0
[  135.854559] [<ffff200008104184>] handle_exit+0x244/0x508
[  135.859874] [<ffff2000080f39c8>] kvm_arch_vcpu_ioctl_run+0x890/0x1330
[  135.866318] [<ffff2000080d9ffc>] kvm_vcpu_ioctl+0x6bc/0xe30
[  135.871894] [<ffff20000863d1ac>] do_vfs_ioctl+0x194/0x14a0
[  135.877383] [<ffff20000863e560>] SyS_ioctl+0xa8/0xb8
[  135.882351] [<ffff200008084770>] el0_svc_naked+0x24/0x28

I'm able to trigger this fairly reliably by having a guest touch a large
amount of memory. I'm doing this by running two instances of the below,
each with GUESTRAM set to half of the host physical memory, as I found
that one instance was more likely to trigger the OoM killer.

	lkvm sandbox --console virtio -m ${GUESTRAM} --kernel Image \
	-p "memtest=1" -- true

(note: lkvm sandbox assumes a dir called 'guests' exists in cwd. You may need
to create it first if you do not already have one).

Thanks,
Mark.
