From: tip-bot for Lance Roy <tipbot@zytor.com>
Subject: [tip:core/rcu] KVM: arm/arm64: vgic: Replace spin_is_locked() with
 lockdep
Date: Tue, 4 Dec 2018 14:36:37 -0800
Message-ID: <tip-d4d592a6eeda1e381f38f398e7a0474a599c11ed@git.kernel.org>
Reply-To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
 marc.zyngier@arm.com, hpa@zytor.com, mingo@kernel.org, eric.auger@redhat.com,
 kvmarm@lists.cs.columbia.edu, paulmck@linux.ibm.com, christoffer.dall@arm.com,
 ldr709@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 448EC4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 17:36:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T3t91gmnC8CW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 17:36:48 -0500 (EST)
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8CCE49F87
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 17:36:47 -0500 (EST)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-tip-commits@vger.kernel.org
Cc: mingo@kernel.org, marc.zyngier@arm.com, ldr709@gmail.com, hpa@zytor.com, tglx@linutronix.de, paulmck@linux.ibm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Commit-ID:  d4d592a6eeda1e381f38f398e7a0474a599c11ed
Gitweb:     https://git.kernel.org/tip/d4d592a6eeda1e381f38f398e7a0474a599c11ed
Author:     Lance Roy <ldr709@gmail.com>
AuthorDate: Thu, 4 Oct 2018 23:45:50 -0700
Committer:  Paul E. McKenney <paulmck@linux.ibm.com>
CommitDate: Mon, 12 Nov 2018 09:06:22 -0800

KVM: arm/arm64: vgic: Replace spin_is_locked() with lockdep

lockdep_assert_held() is better suited to checking locking requirements,
since it only checks if the current thread holds the lock regardless of
whether someone else does. This is also a step towards possibly removing
spin_is_locked().

Signed-off-by: Lance Roy <ldr709@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: <kvmarm@lists.cs.columbia.edu>
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 7cfdfbc910e0..50e25438fb3c 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -196,7 +196,7 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
  */
 static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 {
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
+	lockdep_assert_held(&irq->irq_lock);
 
 	/* If the interrupt is active, it must stay on the current vcpu */
 	if (irq->active)
@@ -273,7 +273,7 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
+	lockdep_assert_held(&vgic_cpu->ap_list_lock);
 
 	list_sort(NULL, &vgic_cpu->ap_list_head, vgic_irq_cmp);
 }
@@ -311,7 +311,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 {
 	struct kvm_vcpu *vcpu;
 
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
+	lockdep_assert_held(&irq->irq_lock);
 
 retry:
 	vcpu = vgic_target_oracle(irq);
@@ -702,7 +702,7 @@ static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
 static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
 				    struct vgic_irq *irq, int lr)
 {
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
+	lockdep_assert_held(&irq->irq_lock);
 
 	if (kvm_vgic_global_state.type == VGIC_V2)
 		vgic_v2_populate_lr(vcpu, irq, lr);
@@ -736,7 +736,7 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
 
 	*multi_sgi = false;
 
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
+	lockdep_assert_held(&vgic_cpu->ap_list_lock);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		int w;
@@ -761,7 +761,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 	bool multi_sgi;
 	u8 prio = 0xff;
 
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
+	lockdep_assert_held(&vgic_cpu->ap_list_lock);
 
 	count = compute_ap_list_depth(vcpu, &multi_sgi);
 	if (count > kvm_vgic_global_state.nr_lr || multi_sgi)
