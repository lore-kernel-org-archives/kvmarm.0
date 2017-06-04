From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v5 10/11] KVM: arm/arm64: PMU: remove request-less vcpu kick
Date: Sun,  4 Jun 2017 14:44:00 +0200
Message-ID: <20170604124401.24902-11-drjones@redhat.com>
References: <20170604124401.24902-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E606440C92
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 08:40:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4jCYucfzSj+j for <kvmarm@lists.cs.columbia.edu>;
 Sun,  4 Jun 2017 08:40:21 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BAAF40C5A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 08:40:21 -0400 (EDT)
In-Reply-To: <20170604124401.24902-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, cdall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Refactor PMU overflow handling in order to remove the request-less
vcpu kick.  Now, since kvm_vgic_inject_irq() uses vcpu requests,
there should be no chance that a kick sent at just the wrong time
(between the VCPU's call to kvm_pmu_flush_hwstate() and before it
enters guest mode) results in a failure for the guest to see updated
GIC state until its next exit some time later for some other reason.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/pmu.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 4b43e7f3b158..2451607dc25e 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -203,6 +203,23 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 	return reg;
 }
 
+static void kvm_pmu_check_overflow(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	bool overflow = !!kvm_pmu_overflow_status(vcpu);
+
+	if (pmu->irq_level == overflow)
+		return;
+
+	pmu->irq_level = overflow;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm))) {
+		int ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+					      pmu->irq_num, overflow);
+		WARN_ON(ret);
+	}
+}
+
 /**
  * kvm_pmu_overflow_set - set PMU overflow interrupt
  * @vcpu: The vcpu pointer
@@ -210,37 +227,18 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
 {
-	u64 reg;
-
 	if (val == 0)
 		return;
 
 	vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= val;
-	reg = kvm_pmu_overflow_status(vcpu);
-	if (reg != 0)
-		kvm_vcpu_kick(vcpu);
+	kvm_pmu_check_overflow(vcpu);
 }
 
 static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-	bool overflow;
-
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return;
-
-	overflow = !!kvm_pmu_overflow_status(vcpu);
-	if (pmu->irq_level == overflow)
-		return;
-
-	pmu->irq_level = overflow;
-
-	if (likely(irqchip_in_kernel(vcpu->kvm))) {
-		int ret;
-		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
-					  pmu->irq_num, overflow);
-		WARN_ON(ret);
-	}
+	kvm_pmu_check_overflow(vcpu);
 }
 
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
-- 
2.9.4
