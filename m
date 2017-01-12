From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: kvm: deadlock in kvm_vgic_map_resources
Date: Thu, 12 Jan 2017 09:32:43 +0000
Message-ID: <70371c5c-d0c0-b59e-b12c-fd8359392763@arm.com>
References: <CACT4Y+YRg=H0F-_QTtPf0--o85sQCb__j=V25tPchx9ycYtyKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B406140539
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 04:31:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hMkFnriNceiW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 04:31:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10B8F402EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 04:31:01 -0500 (EST)
In-Reply-To: <CACT4Y+YRg=H0F-_QTtPf0--o85sQCb__j=V25tPchx9ycYtyKg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dmitry Vyukov <dvyukov@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, andre.przywara@arm.com, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: syzkaller <syzkaller@googlegroups.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dmitry,

On 11/01/17 19:01, Dmitry Vyukov wrote:
> Hello,
> 
> While running syzkaller fuzzer I've got the following deadlock.
> On commit 9c763584b7c8911106bb77af7e648bef09af9d80.
> 
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 4.9.0-rc6-xc2-00056-g08372dd4b91d-dirty #50 Not tainted
> ---------------------------------------------
> syz-executor/20805 is trying to acquire lock:
> (
> &kvm->lock
> ){+.+.+.}
> , at:
> [< inline >] kvm_vgic_dist_destroy
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:271
> [<ffff2000080ea4bc>] kvm_vgic_destroy+0x34/0x250
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:294
> but task is already holding lock:
> (&kvm->lock){+.+.+.}, at:
> [<ffff2000080ea7e4>] kvm_vgic_map_resources+0x2c/0x108
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:343
> other info that might help us debug this:
> Possible unsafe locking scenario:
> CPU0
> ----
> lock(&kvm->lock);
> lock(&kvm->lock);
> *** DEADLOCK ***
> May be due to missing lock nesting notation
> 2 locks held by syz-executor/20805:
> #0:(&vcpu->mutex){+.+.+.}, at:
> [<ffff2000080bcc30>] vcpu_load+0x28/0x1d0
> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:143
> #1:(&kvm->lock){+.+.+.}, at:
> [<ffff2000080ea7e4>] kvm_vgic_map_resources+0x2c/0x108
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:343
> stack backtrace:
> CPU: 2 PID: 20805 Comm: syz-executor Not tainted
> 4.9.0-rc6-xc2-00056-g08372dd4b91d-dirty #50
> Hardware name: Hardkernel ODROID-C2 (DT)
> Call trace:
> [<ffff200008090560>] dump_backtrace+0x0/0x3c8 arch/arm64/kernel/traps.c:69
> [<ffff200008090948>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:219
> [< inline >] __dump_stack lib/dump_stack.c:15
> [<ffff200008895840>] dump_stack+0x100/0x150 lib/dump_stack.c:51
> [< inline >] print_deadlock_bug kernel/locking/lockdep.c:1728
> [< inline >] check_deadlock kernel/locking/lockdep.c:1772
> [< inline >] validate_chain kernel/locking/lockdep.c:2250
> [<ffff2000081c8718>] __lock_acquire+0x1938/0x3440 kernel/locking/lockdep.c:3335
> [<ffff2000081caa84>] lock_acquire+0xdc/0x1d8 kernel/locking/lockdep.c:3746
> [< inline >] __mutex_lock_common kernel/locking/mutex.c:521
> [<ffff200009700004>] mutex_lock_nested+0xdc/0x7b8 kernel/locking/mutex.c:621
> [< inline >] kvm_vgic_dist_destroy
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:271
> [<ffff2000080ea4bc>] kvm_vgic_destroy+0x34/0x250
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:294
> [<ffff2000080ec290>] vgic_v2_map_resources+0x218/0x430
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-v2.c:295
> [<ffff2000080ea884>] kvm_vgic_map_resources+0xcc/0x108
> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:348
> [< inline >] kvm_vcpu_first_run_init
> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:505
> [<ffff2000080d2768>] kvm_arch_vcpu_ioctl_run+0xab8/0xce0
> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:591
> [<ffff2000080c1fec>] kvm_vcpu_ioctl+0x434/0xc08
> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:2557
> [< inline >] vfs_ioctl fs/ioctl.c:43
> [<ffff200008450c38>] do_vfs_ioctl+0x128/0xfc0 fs/ioctl.c:679
> [< inline >] SYSC_ioctl fs/ioctl.c:694
> [<ffff200008451b78>] SyS_ioctl+0xa8/0xb8 fs/ioctl.c:685
> [<ffff200008083ef0>] el0_svc_naked+0x24/0x28 arch/arm64/kernel/entry.S:755

Nice catch, and many thanks for reporting this.

The bug is fairly obvious. Christoffer, what do you think? I don't think
we need to hold the kvm->lock all the way, but I'd like another pair of
eyes (the coffee machine is out of order again, and tea doesn't cut it).

Thanks,

	M.

>From 93f80b20fb9351a49ee8b74eed3fc59c84651371 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Thu, 12 Jan 2017 09:21:56 +0000
Subject: [PATCH] KVM: arm/arm64: vgic: Fix deadlock on error handling

Dmitry Vyukov reported that the syzkaller fuzzer triggered a
deadlock in the vgic setup code when an error was detected, as
the cleanup code tries to take a lock that is already held by
the setup code.

The fix is pretty obvious: move the cleaup call after having
dropped the lock, since not much can happen at that point.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 4 ++++
 virt/kvm/arm/vgic/vgic-v2.c   | 2 --
 virt/kvm/arm/vgic/vgic-v3.c   | 2 --
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 5114391..0e0c295 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -350,6 +350,10 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 		ret = vgic_v3_map_resources(kvm);
 out:
 	mutex_unlock(&kvm->lock);
+
+	if (ret)
+		kvm_vgic_destroy(kvm);
+
 	return ret;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 9bab867..834137e 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -293,8 +293,6 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	dist->ready = true;
 
 out:
-	if (ret)
-		kvm_vgic_destroy(kvm);
 	return ret;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 7df1b90..a4c7fff 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -308,8 +308,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
 	dist->ready = true;
 
 out:
-	if (ret)
-		kvm_vgic_destroy(kvm);
 	return ret;
 }
 
-- 
2.1.4


-- 
Jazz is not dead. It just smells funny...
