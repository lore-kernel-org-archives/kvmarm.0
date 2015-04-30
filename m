From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 1/2] KVM: provide irq_unsafe kvm_guest_{enter|exit}
Date: Thu, 30 Apr 2015 13:43:30 +0200
Message-ID: <1430394211-25209-2-git-send-email-borntraeger@de.ibm.com>
References: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com>
Return-path: <kvm-ppc-owner@vger.kernel.org>
In-Reply-To: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Several kvm architectures disable interrupts before kvm_guest_enter.
kvm_guest_enter then uses local_irq_save/restore to disable interrupts
again or for the first time. Lets provide underscore versions of
kvm_guest_{enter|exit} that assume being called locked.
kvm_guest_enter now disables interrupts for the full function and
thus we can remove the check for preemptible.

This patch then adopts s390/kvm to use local_irq_disable/enable calls
which are slighty cheaper that local_irq_save/restore and call these
new functions.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 10 ++++++----
 include/linux/kvm_host.h | 27 ++++++++++++++++++---------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 46f37df..c25d4e5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2010,12 +2010,14 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		 * As PF_VCPU will be used in fault handler, between
 		 * guest_enter and guest_exit should be no uaccess.
 		 */
-		preempt_disable();
-		kvm_guest_enter();
-		preempt_enable();
+		local_irq_disable();
+		__kvm_guest_enter();
+		local_irq_enable();
 		exit_reason = sie64a(vcpu->arch.sie_block,
 				     vcpu->run->s.regs.gprs);
-		kvm_guest_exit();
+		local_irq_disable();
+		__kvm_guest_exit();
+		local_irq_enable();
 		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 		rc = vcpu_post_run(vcpu, exit_reason);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d12b210..2d3b3ce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -749,16 +749,10 @@ static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
 }
 #endif
 
-static inline void kvm_guest_enter(void)
+/* must be called with irqs disabled */
+static inline void __kvm_guest_enter(void)
 {
-	unsigned long flags;
-
-	BUG_ON(preemptible());
-
-	local_irq_save(flags);
 	guest_enter();
-	local_irq_restore(flags);
-
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
 	 * is very similar to exiting to userspace from rcu point of view. In
@@ -769,12 +763,27 @@ static inline void kvm_guest_enter(void)
 	rcu_virt_note_context_switch(smp_processor_id());
 }
 
+/* must be called with irqs disabled */
+static inline void __kvm_guest_exit(void)
+{
+	guest_exit();
+}
+
+static inline void kvm_guest_enter(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__kvm_guest_enter();
+	local_irq_restore(flags);
+}
+
 static inline void kvm_guest_exit(void)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	guest_exit();
+	__kvm_guest_exit();
 	local_irq_restore(flags);
 }
 
-- 
2.3.0
