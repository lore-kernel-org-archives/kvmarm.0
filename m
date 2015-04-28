From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH/RFC 1/2] KVM: Push down irq_save to architectures before kvm_guest_enter
Date: Tue, 28 Apr 2015 12:32:47 +0200
Message-ID: <1430217168-25504-2-git-send-email-borntraeger@de.ibm.com>
References: <1430217168-25504-1-git-send-email-borntraeger@de.ibm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1430217168-25504-1-git-send-email-borntraeger@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>
List-Id: kvmarm@lists.cs.columbia.edu

local_irq_disable can be cheaper than local_irq_save, especially
when done only once instead of twice. We can push down the
local_irq_save (and replace it with local_irq_disable) to
save some cycles.
x86, mips and arm already disable the interrupts before calling
kvm_guest_enter. Here we save one local_irq_save/restore pair.
power and s390 are reworked to disable the interrupts before calling
kvm_guest_enter. s390 saves a preempt_disable/enable pair but also
saves some cycles as local_irq_disable/enable can be cheaper than
local_irq_save/restore on some machines.

power should be almost a no-op change (interrupts are disabled
slighty longer).

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c |  2 ++
 arch/s390/kvm/kvm-s390.c     |  4 ++--
 include/linux/kvm_host.h     | 14 ++++++++------
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index de74756..a5f392d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1779,7 +1779,9 @@ static void kvmppc_run_core(struct kvmppc_vcore *vc)
 
 	spin_unlock(&vc->lock);
 
+	local_irq_disable();
 	kvm_guest_enter();
+	local_irq_enable();
 
 	srcu_idx = srcu_read_lock(&vc->kvm->srcu);
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 46f37df..9f4c954 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2010,9 +2010,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		 * As PF_VCPU will be used in fault handler, between
 		 * guest_enter and guest_exit should be no uaccess.
 		 */
-		preempt_disable();
+		local_irq_disable();
 		kvm_guest_enter();
-		preempt_enable();
+		local_irq_enable();
 		exit_reason = sie64a(vcpu->arch.sie_block,
 				     vcpu->run->s.regs.gprs);
 		kvm_guest_exit();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d12b210..a34bf6ed 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -751,13 +751,15 @@ static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
 
 static inline void kvm_guest_enter(void)
 {
-	unsigned long flags;
-
-	BUG_ON(preemptible());
-
-	local_irq_save(flags);
+	/*
+	 * guest_enter needs disabled irqs and rcu_virt_note_context_switch
+	 * wants disabled preemption. Ensure that the caller has disabled
+	 * irqs for kvm_guest_enter. Please note: Some architectures (e.g.
+	 * s390) will reenable irqs before entering the guest, but this is
+	 * ok. We just need a stable CPU for the accounting itself.
+	 */
+	WARN_ON(!irqs_disabled());
 	guest_enter();
-	local_irq_restore(flags);
 
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
-- 
2.3.0

