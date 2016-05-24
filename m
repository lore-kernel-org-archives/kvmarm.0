From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 13/59] KVM: arm/arm64: pmu: abstract access to number of SPIs
Date: Tue, 24 May 2016 11:09:07 +0200
Message-ID: <1464080993-10884-14-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47FD749B79
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Rmy06foXAsT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:38 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B99249B8F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:35 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id z87so15341946wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:08 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Currently the PMU uses a member of the struct vgic_dist directly,
which not only breaks abstraction, but will fail with the new VGIC.
Abstract this access in the VGIC header file and refactor the validity
check in the PMU code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h |  2 ++
 virt/kvm/arm/pmu.c     | 25 ++++++++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 67a6637..ade7005 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -348,6 +348,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
 #define vgic_ready(k)		((k)->arch.vgic.ready)
+#define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
+				 ((i) < (k)->arch.vgic.nr_irqs))
 
 int vgic_v2_probe(const struct gic_kvm_info *gic_kvm_info,
 		  const struct vgic_ops **ops,
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 575c7aa..a027569 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -436,7 +436,14 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool irq_is_valid(struct kvm *kvm, int irq, bool is_ppi)
+#define irq_is_ppi(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)
+
+/*
+ * For one VM the interrupt type must be same for each vcpu.
+ * As a PPI, the interrupt number is the same for all vcpus,
+ * while as an SPI it must be a separate number per vcpu.
+ */
+static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
@@ -445,7 +452,7 @@ static bool irq_is_valid(struct kvm *kvm, int irq, bool is_ppi)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
 
-		if (is_ppi) {
+		if (irq_is_ppi(irq)) {
 			if (vcpu->arch.pmu.irq_num != irq)
 				return false;
 		} else {
@@ -457,7 +464,6 @@ static bool irq_is_valid(struct kvm *kvm, int irq, bool is_ppi)
 	return true;
 }
 
-
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	switch (attr->attr) {
@@ -471,14 +477,11 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		if (get_user(irq, uaddr))
 			return -EFAULT;
 
-		/*
-		 * The PMU overflow interrupt could be a PPI or SPI, but for one
-		 * VM the interrupt type must be same for each vcpu. As a PPI,
-		 * the interrupt number is the same for all vcpus, while as an
-		 * SPI it must be a separate number per vcpu.
-		 */
-		if (irq < VGIC_NR_SGIS || irq >= vcpu->kvm->arch.vgic.nr_irqs ||
-		    !irq_is_valid(vcpu->kvm, irq, irq < VGIC_NR_PRIVATE_IRQS))
+		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
+		if (!(irq_is_ppi(irq) || vgic_valid_spi(vcpu->kvm, irq)))
+			return -EINVAL;
+
+		if (!pmu_irq_is_valid(vcpu->kvm, irq))
 			return -EINVAL;
 
 		if (kvm_arm_pmu_irq_initialized(vcpu))
-- 
2.1.2.330.g565301e.dirty
