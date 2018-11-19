From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH 3/4] KVM: arm/arm64: vgic: Make vgic_dist->lpi_list_lock a
 raw_spinlock
Date: Mon, 19 Nov 2018 17:07:58 +0000
Message-ID: <1542647279-46609-4-git-send-email-julien.thierry@arm.com>
References: <1542647279-46609-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E09884A326
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 12:08:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W7KBKUHxhKIF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Nov 2018 12:08:16 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97EF24A32D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 12:08:16 -0500 (EST)
In-Reply-To: <1542647279-46609-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: linux-rt-users@vger.kernel.org, marc.zyngier@arm.com, bigeasy@linutronix.de, rostedt@goodmis.org, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

vgic_dist->lpi_list_lock must always be taken with interrupts disabled as
it is used in interrupt context.

For configurations such as PREEMPT_RT_FULL, this means that it should
be a raw_spinlock since RT spinlocks are interruptible.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h        |  2 +-
 virt/kvm/arm/vgic/vgic-init.c |  2 +-
 virt/kvm/arm/vgic/vgic-its.c  |  8 ++++----
 virt/kvm/arm/vgic/vgic.c      | 10 +++++-----
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b542605..32954e1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -256,7 +256,7 @@ struct vgic_dist {
 	u64			propbaser;

 	/* Protects the lpi_list and the count value below. */
-	spinlock_t		lpi_list_lock;
+	raw_spinlock_t		lpi_list_lock;
 	struct list_head	lpi_list_head;
 	int			lpi_list_count;

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 1128e97..330c1ad 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -64,7 +64,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
 	struct vgic_dist *dist = &kvm->arch.vgic;

 	INIT_LIST_HEAD(&dist->lpi_list_head);
-	spin_lock_init(&dist->lpi_list_lock);
+	raw_spin_lock_init(&dist->lpi_list_lock);
 }

 /* CREATION */
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 911ba61..ab3f477 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -73,7 +73,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	irq->target_vcpu = vcpu;
 	irq->group = 1;

-	spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);

 	/*
 	 * There could be a race with another vgic_add_lpi(), so we need to
@@ -101,7 +101,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	dist->lpi_list_count++;

 out_unlock:
-	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);

 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
@@ -332,7 +332,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	if (!intids)
 		return -ENOMEM;

-	spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
 		if (i == irq_count)
 			break;
@@ -341,7 +341,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 			continue;
 		intids[i++] = irq->intid;
 	}
-	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);

 	*intid_ptr = intids;
 	return i;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index aab8dba..01bd18c 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -72,7 +72,7 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 	struct vgic_irq *irq = NULL;
 	unsigned long flags;

-	spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);

 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
 		if (irq->intid != intid)
@@ -88,7 +88,7 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 	irq = NULL;

 out_unlock:
-	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);

 	return irq;
 }
@@ -138,15 +138,15 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	if (irq->intid < VGIC_MIN_LPI)
 		return;

-	spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 	if (!kref_put(&irq->refcount, vgic_irq_release)) {
-		spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+		raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 		return;
 	};

 	list_del(&irq->lpi_list);
 	dist->lpi_list_count--;
-	spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);

 	kfree(irq);
 }
--
1.9.1
