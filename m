From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: [PATCH tip/core/rcu 7/7] KVM: arm/arm64: vgic: Replace
 spin_is_locked() with lockdep
Date: Sun, 11 Nov 2018 12:04:43 -0800
Message-ID: <20181111200443.10772-7-paulmck@linux.ibm.com>
References: <20181111200421.GA10551@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B7A4A315
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Nov 2018 15:04:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KLqqMEnSoP6u for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Nov 2018 15:04:54 -0500 (EST)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A8F34A310
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Nov 2018 15:04:53 -0500 (EST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 wABJwv8O031072
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Nov 2018 15:04:53 -0500
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2npdbgj4h9-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Nov 2018 15:04:52 -0500
Received: from localhost
 by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <kvmarm@lists.cs.columbia.edu> from <paulmck@linux.vnet.ibm.com>;
 Sun, 11 Nov 2018 20:04:51 -0000
In-Reply-To: <20181111200421.GA10551@linux.ibm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, "Paul E . McKenney" <paulmck@linux.ibm.com>, tglx@linutronix.de, peterz@infradead.org, fweisbec@gmail.com, jiangshanlai@gmail.com, josh@joshtriplett.org, rostedt@goodmis.org, oleg@redhat.com, dhowells@redhat.com, Marc Zyngier <marc.zyngier@arm.com>, edumazet@google.com, mathieu.desnoyers@efficios.com, dipankar@in.ibm.com, joel@joelfernandes.org, akpm@linux-foundation.org, Lance Roy <ldr709@gmail.com>, mingo@kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Lance Roy <ldr709@gmail.com>

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
-- 
2.17.1
