From: Dmitry Vyukov <dvyukov@google.com>
Subject: kvm: deadlock in kvm_vgic_map_resources
Date: Wed, 11 Jan 2017 20:01:46 +0100
Message-ID: <CACT4Y+YRg=H0F-_QTtPf0--o85sQCb__j=V25tPchx9ycYtyKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, marc.zyngier@arm.com, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, andre.przywara@arm.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: syzkaller <syzkaller@googlegroups.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

While running syzkaller fuzzer I've got the following deadlock.
On commit 9c763584b7c8911106bb77af7e648bef09af9d80.


=============================================
[ INFO: possible recursive locking detected ]
4.9.0-rc6-xc2-00056-g08372dd4b91d-dirty #50 Not tainted
---------------------------------------------
syz-executor/20805 is trying to acquire lock:
(
&kvm->lock
){+.+.+.}
, at:
[< inline >] kvm_vgic_dist_destroy
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:271
[<ffff2000080ea4bc>] kvm_vgic_destroy+0x34/0x250
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:294
but task is already holding lock:
(&kvm->lock){+.+.+.}, at:
[<ffff2000080ea7e4>] kvm_vgic_map_resources+0x2c/0x108
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:343
other info that might help us debug this:
Possible unsafe locking scenario:
CPU0
----
lock(&kvm->lock);
lock(&kvm->lock);
*** DEADLOCK ***
May be due to missing lock nesting notation
2 locks held by syz-executor/20805:
#0:(&vcpu->mutex){+.+.+.}, at:
[<ffff2000080bcc30>] vcpu_load+0x28/0x1d0
arch/arm64/kvm/../../../virt/kvm/kvm_main.c:143
#1:(&kvm->lock){+.+.+.}, at:
[<ffff2000080ea7e4>] kvm_vgic_map_resources+0x2c/0x108
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:343
stack backtrace:
CPU: 2 PID: 20805 Comm: syz-executor Not tainted
4.9.0-rc6-xc2-00056-g08372dd4b91d-dirty #50
Hardware name: Hardkernel ODROID-C2 (DT)
Call trace:
[<ffff200008090560>] dump_backtrace+0x0/0x3c8 arch/arm64/kernel/traps.c:69
[<ffff200008090948>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:219
[< inline >] __dump_stack lib/dump_stack.c:15
[<ffff200008895840>] dump_stack+0x100/0x150 lib/dump_stack.c:51
[< inline >] print_deadlock_bug kernel/locking/lockdep.c:1728
[< inline >] check_deadlock kernel/locking/lockdep.c:1772
[< inline >] validate_chain kernel/locking/lockdep.c:2250
[<ffff2000081c8718>] __lock_acquire+0x1938/0x3440 kernel/locking/lockdep.c:3335
[<ffff2000081caa84>] lock_acquire+0xdc/0x1d8 kernel/locking/lockdep.c:3746
[< inline >] __mutex_lock_common kernel/locking/mutex.c:521
[<ffff200009700004>] mutex_lock_nested+0xdc/0x7b8 kernel/locking/mutex.c:621
[< inline >] kvm_vgic_dist_destroy
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:271
[<ffff2000080ea4bc>] kvm_vgic_destroy+0x34/0x250
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:294
[<ffff2000080ec290>] vgic_v2_map_resources+0x218/0x430
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-v2.c:295
[<ffff2000080ea884>] kvm_vgic_map_resources+0xcc/0x108
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:348
[< inline >] kvm_vcpu_first_run_init
arch/arm64/kvm/../../../arch/arm/kvm/arm.c:505
[<ffff2000080d2768>] kvm_arch_vcpu_ioctl_run+0xab8/0xce0
arch/arm64/kvm/../../../arch/arm/kvm/arm.c:591
[<ffff2000080c1fec>] kvm_vcpu_ioctl+0x434/0xc08
arch/arm64/kvm/../../../virt/kvm/kvm_main.c:2557
[< inline >] vfs_ioctl fs/ioctl.c:43
[<ffff200008450c38>] do_vfs_ioctl+0x128/0xfc0 fs/ioctl.c:679
[< inline >] SYSC_ioctl fs/ioctl.c:694
[<ffff200008451b78>] SyS_ioctl+0xa8/0xb8 fs/ioctl.c:685
[<ffff200008083ef0>] el0_svc_naked+0x24/0x28 arch/arm64/kernel/entry.S:755


INFO: task syz-executor:20805 blocked for more than 120 seconds.
Not tainted 4.9.0-rc6-xc2-00056-g08372dd4b91d-dirty #50
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor D 0 20805 1 0x00000001
Call trace:
[<ffff2000080894f4>] __switch_to+0x184/0x258 arch/arm64/kernel/process.c:345
[< inline >] context_switch kernel/sched/core.c:2899
[<ffff2000096fcc64>] __schedule+0x42c/0x1298 kernel/sched/core.c:3402
[<ffff2000096fdb98>] schedule+0xc8/0x260 kernel/sched/core.c:3457
[<ffff2000096fe654>] schedule_preempt_disabled+0x74/0x110
kernel/sched/core.c:3490
[< inline >] __mutex_lock_common kernel/locking/mutex.c:582
[<ffff200009700240>] mutex_lock_nested+0x318/0x7b8 kernel/locking/mutex.c:621
[< inline >] kvm_vgic_dist_destroy
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:271
[<ffff2000080ea4bc>] kvm_vgic_destroy+0x34/0x250
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:294
[<ffff2000080ec290>] vgic_v2_map_resources+0x218/0x430
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-v2.c:295
[<ffff2000080ea884>] kvm_vgic_map_resources+0xcc/0x108
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:348
[< inline >] kvm_vcpu_first_run_init
arch/arm64/kvm/../../../arch/arm/kvm/arm.c:505
[<ffff2000080d2768>] kvm_arch_vcpu_ioctl_run+0xab8/0xce0
arch/arm64/kvm/../../../arch/arm/kvm/arm.c:591
[<ffff2000080c1fec>] kvm_vcpu_ioctl+0x434/0xc08
arch/arm64/kvm/../../../virt/kvm/kvm_main.c:2557
[< inline >] vfs_ioctl fs/ioctl.c:43
[<ffff200008450c38>] do_vfs_ioctl+0x128/0xfc0 fs/ioctl.c:679
[< inline >] SYSC_ioctl fs/ioctl.c:694
[<ffff200008451b78>] SyS_ioctl+0xa8/0xb8 fs/ioctl.c:685
[<ffff200008083ef0>] el0_svc_naked+0x24/0x28 arch/arm64/kernel/entry.S:755
