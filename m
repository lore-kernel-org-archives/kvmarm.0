Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B789329ACC2
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 07:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756970913; cv=none; b=DMyavCGqxh+0RqH0Cx2RjRXRS1z9407Lx4wMJF8ITe9WJqSIH1hZU9u99BWvmqIkFxeqJio19PGX1uTAUAJUFuB189/50Wmut4jaKwLkanvSQJh3jEc7cFOvjY4VPlFAtMEM1AeLUcaZEWdziSEz4TXJ3tyI0Z8ct0MzA/qlD5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756970913; c=relaxed/simple;
	bh=1mtItK1q5z1ZOOjr7DGwGFg8hEet6clF+TrYURmB4NA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r1OY6RJsC42VZdxx0t6cgRM/JV5tVMo51UWqLeP1NcI0Cf3UfohvIgWcZppgesQQPueqA0lonMpH483ghtuSzJ1grdaYUO2Q3Qcupc1uzKHPleUxzJwKD/3YyanBEHfWHrjSCjwQZ3BSflrPXdtrOKyj0YXQCdqox95+YYPRtok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wJXruJEd; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wJXruJEd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756970909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q+umNuvugKwWdEO0Iv/J11uGJiTC4q1qPeKnbmoB+dQ=;
	b=wJXruJEdVtX0yaUF2YOxQNHqksOqRJdZ7YNlj1Ctztp3g14HpxvBanJ5DduzIkMjg2inrk
	QiWru9GWAFHZfdZ9Vere83eeBLfY6smi6MtCt32JAYUybyeW0h1PYnaXQoL8x/Y+FDYaEt
	yr+QUlkUUKJlNQozjvjkygmw5WT2Kuc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	syzbot+cef594105ac7e60c6d93@syzkaller.appspotmail.com
Subject: [PATCH 3/5] KVM: arm64: vgic-v3: Erase LPIs from xarray outside of raw spinlocks
Date: Wed,  3 Sep 2025 23:23:46 -0700
Message-Id: <20250904062348.223976-4-oliver.upton@linux.dev>
In-Reply-To: <20250904062348.223976-1-oliver.upton@linux.dev>
References: <20250904062348.223976-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

syzkaller has caught us red-handed once more, this time nesting regular
spinlocks behind raw spinlocks:

  =============================
  [ BUG: Invalid wait context ]
  6.16.0-rc3-syzkaller-g7b8346bd9fce #0 Not tainted
  -----------------------------
  syz.0.29/3743 is trying to lock:
  a3ff80008e2e9e18 (&xa->xa_lock#20){....}-{3:3}, at: vgic_put_irq+0xb4/0x190 arch/arm64/kvm/vgic/vgic.c:137
  other info that might help us debug this:
  context-{5:5}
  3 locks held by syz.0.29/3743:
   #0: a3ff80008e2e90a8 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vgic_destroy+0x50/0x624 arch/arm64/kvm/vgic/vgic-init.c:499
   #1: a3ff80008e2e9fa0 (&kvm->arch.config_lock){+.+.}-{4:4}, at: kvm_vgic_destroy+0x5c/0x624 arch/arm64/kvm/vgic/vgic-init.c:500
   #2: 58f0000021be1428 (&vgic_cpu->ap_list_lock){....}-{2:2}, at: vgic_flush_pending_lpis+0x3c/0x31c arch/arm64/kvm/vgic/vgic.c:150
  stack backtrace:
  CPU: 0 UID: 0 PID: 3743 Comm: syz.0.29 Not tainted 6.16.0-rc3-syzkaller-g7b8346bd9fce #0 PREEMPT
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
   __dump_stack+0x30/0x40 lib/dump_stack.c:94
   dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
   dump_stack+0x1c/0x28 lib/dump_stack.c:129
   print_lock_invalid_wait_context kernel/locking/lockdep.c:4833 [inline]
   check_wait_context kernel/locking/lockdep.c:4905 [inline]
   __lock_acquire+0x978/0x299c kernel/locking/lockdep.c:5190
   lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5871
   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
   _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
   vgic_put_irq+0xb4/0x190 arch/arm64/kvm/vgic/vgic.c:137
   vgic_flush_pending_lpis+0x24c/0x31c arch/arm64/kvm/vgic/vgic.c:158
   __kvm_vgic_vcpu_destroy+0x44/0x500 arch/arm64/kvm/vgic/vgic-init.c:455
   kvm_vgic_destroy+0x100/0x624 arch/arm64/kvm/vgic/vgic-init.c:505
   kvm_arch_destroy_vm+0x80/0x138 arch/arm64/kvm/arm.c:244
   kvm_destroy_vm virt/kvm/kvm_main.c:1308 [inline]
   kvm_put_kvm+0x800/0xff8 virt/kvm/kvm_main.c:1344
   kvm_vm_release+0x58/0x78 virt/kvm/kvm_main.c:1367
   __fput+0x4ac/0x980 fs/file_table.c:465
   ____fput+0x20/0x58 fs/file_table.c:493
   task_work_run+0x1bc/0x254 kernel/task_work.c:227
   resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
   do_notify_resume+0x1b4/0x270 arch/arm64/kernel/entry-common.c:151
   exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
   exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
   el0_svc+0xb4/0x160 arch/arm64/kernel/entry-common.c:768
   el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
   el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

This is of course no good, but is at odds with how LPI refcounts are
managed. Solve the locking mess by deferring the release of unreferenced
LPIs after the ap_list_lock is released. Mark these to-be-released LPIs
specially to avoid racing with vgic_put_irq() and causing a double-free.

Since references can only be taken on LPIs with a nonzero refcount,
extending the lifetime of freed LPIs is still safe.

Reported-by: syzbot+cef594105ac7e60c6d93@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/kvmarm/68acd0d9.a00a0220.33401d.048b.GAE@google.com/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 41 ++++++++++++++++++++++++++++++++++----
 include/kvm/arm_vgic.h     |  6 +++++-
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index ec4d70936a5b..480391a0dcad 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -28,8 +28,8 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  *     kvm->arch.config_lock (mutex)
  *       its->cmd_lock (mutex)
  *         its->its_lock (mutex)
- *           vgic_cpu->ap_list_lock		must be taken with IRQs disabled
- *             vgic_dist->lpi_xa.xa_lock	must be taken with IRQs disabled
+ *           vgic_dist->lpi_xa.xa_lock		must be taken with IRQs disabled
+ *             vgic_cpu->ap_list_lock		must be taken with IRQs disabled
  *               vgic_irq->irq_lock		must be taken with IRQs disabled
  *
  * As the ap_list_lock might be taken from the timer interrupt handler,
@@ -129,6 +129,15 @@ static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	return refcount_dec_and_test(&irq->refcount);
 }
 
+static __must_check bool vgic_put_irq_norelease(struct kvm *kvm, struct vgic_irq *irq)
+{
+	if (!__vgic_put_irq(kvm, irq))
+		return false;
+
+	irq->pending_release = true;
+	return true;
+}
+
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -142,10 +151,27 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	xa_unlock_irqrestore(&dist->lpi_xa, flags);
 }
 
+static void vgic_release_deleted_lpis(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	unsigned long flags, intid;
+	struct vgic_irq *irq;
+
+	xa_lock_irqsave(&dist->lpi_xa, flags);
+
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		if (irq->pending_release)
+			vgic_release_lpi_locked(dist, irq);
+	}
+
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+}
+
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq, *tmp;
+	bool deleted = false;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
@@ -156,11 +182,14 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
 			raw_spin_unlock(&irq->irq_lock);
-			vgic_put_irq(vcpu->kvm, irq);
+			deleted |= vgic_put_irq_norelease(vcpu->kvm, irq);
 		}
 	}
 
 	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
+
+	if (deleted)
+		vgic_release_deleted_lpis(vcpu->kvm);
 }
 
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending)
@@ -631,6 +660,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq, *tmp;
+	bool deleted_lpis = false;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
@@ -663,7 +693,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			 * we remove the irq from the list, we drop
 			 * also drop the refcount.
 			 */
-			vgic_put_irq(vcpu->kvm, irq);
+			deleted_lpis |= vgic_put_irq_norelease(vcpu->kvm, irq);
 			continue;
 		}
 
@@ -726,6 +756,9 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 	}
 
 	raw_spin_unlock(&vgic_cpu->ap_list_lock);
+
+	if (unlikely(deleted_lpis))
+		vgic_release_deleted_lpis(vcpu->kvm);
 }
 
 static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ed0e96031a65..af224db3cf72 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -139,7 +139,11 @@ struct vgic_irq {
 	bool pending_latch;		/* The pending latch state used to calculate
 					 * the pending state for both level
 					 * and edge triggered IRQs. */
-	bool active;			/* not used for LPIs */
+	union {
+		bool active;		/* not used for LPIs */
+		bool pending_release;	/* LPI pending a release */
+	};
+
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
 	refcount_t refcount;		/* Used for LPIs */
-- 
2.39.5

