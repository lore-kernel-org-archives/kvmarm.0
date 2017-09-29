From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 4/5] KVM: arm/arm64: improve kvm_arch_vcpu_runnable
Date: Fri, 29 Sep 2017 13:30:40 +0200
Message-ID: <20170929113041.24371-5-drjones@redhat.com>
References: <20170929113041.24371-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE1949C4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Sep 2017 07:30:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dKX8mr33gE06 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Sep 2017 07:30:39 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AE7849C47
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Sep 2017 07:30:39 -0400 (EDT)
In-Reply-To: <20170929113041.24371-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Conceptually, kvm_arch_vcpu_runnable() should be "not waiting,
or waiting for interrupts and interrupts are pending",

  !waiting-uninterruptable &&
  (!waiting-for-interrupts || interrupts-pending)

but the implementation was only

  !waiting-uninterruptable && interrupts-pending

Thanks to the context of the two callers there wasn't an issue,
however, to future-proof the function, this patch implements the
conceptual condition by applying mp_state to track waiting-
uninterruptable vs. waiting-for-interrupts.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virtual/kvm/api.txt | 10 ++++++----
 virt/kvm/arm/arm.c                | 13 +++++++++----
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index e63a35fafef0..7c0bb1ae10a2 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1071,7 +1071,7 @@ Possible values are:
  - KVM_MP_STATE_INIT_RECEIVED:   the vcpu has received an INIT signal, and is
                                  now ready for a SIPI [x86]
  - KVM_MP_STATE_HALTED:          the vcpu has executed a HLT instruction and
-                                 is waiting for an interrupt [x86]
+                                 is waiting for an interrupt [x86,arm/arm64]
  - KVM_MP_STATE_SIPI_RECEIVED:   the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
  - KVM_MP_STATE_STOPPED:         the vcpu is stopped [s390,arm/arm64]
@@ -1087,8 +1087,9 @@ these architectures.
 
 For arm/arm64:
 
-The only states that are valid are KVM_MP_STATE_STOPPED and
-KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
+The only states that are valid are KVM_MP_STATE_STOPPED, KVM_MP_STATE_HALTED,
+and KVM_MP_STATE_RUNNABLE which reflect if the vcpu is powered-off, waiting
+for interrupts, or powered-on and not waiting for interrupts.
 
 4.39 KVM_SET_MP_STATE
 
@@ -1108,7 +1109,8 @@ these architectures.
 For arm/arm64:
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
-KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
+KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be
+powered-off or not.
 
 4.40 KVM_SET_IDENTITY_MAP_ADDR
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 220a3dbda76c..5bc9b0d2fd0f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -414,13 +414,16 @@ static bool vcpu_should_sleep(struct kvm_vcpu *vcpu)
  * kvm_arch_vcpu_runnable - determine if the vcpu can be scheduled
  * @vcpu:	The VCPU pointer
  *
- * If the guest CPU is not waiting for interrupts or an interrupt line is
- * asserted, the CPU is by definition runnable.
+ * If the VCPU is not waiting at all (including sleeping, which is waiting
+ * uninterruptably), or it's waiting for interrupts but interrupts are
+ * pending, then it is by definition runnable.
  */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return (!!vcpu->arch.irq_lines || kvm_vgic_vcpu_pending_irq(vcpu))
-		&& !vcpu_should_sleep(vcpu);
+	return !vcpu_should_sleep(vcpu) &&
+	       (vcpu->arch.mp_state != KVM_MP_STATE_HALTED ||
+		(!!vcpu->arch.irq_lines ||
+		 kvm_vgic_vcpu_pending_irq(vcpu)));
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -582,7 +585,9 @@ void kvm_arm_emulate_wfe(struct kvm_vcpu *vcpu)
 void kvm_arm_emulate_wfi(struct kvm_vcpu *vcpu)
 {
 	vcpu->stat.wfi_exit_stat++;
+	vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
 	kvm_vcpu_block(vcpu);
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 }
 
-- 
2.13.5
