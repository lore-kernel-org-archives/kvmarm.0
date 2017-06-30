From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/58] KVM: arm64: Allow creating the PMU without the
 in-kernel GIC
Date: Fri, 30 Jun 2017 09:44:34 +0100
Message-ID: <20170630084514.6779-19-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F34A40427
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lmAx4EwFtSWl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:22 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9CE540D38
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:19 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

Since we got support for devices in userspace which allows reporting the
PMU overflow output status to userspace, we should actually allow
creating the PMU on systems without an in-kernel irqchip, which in turn
requires us to slightly clarify error codes for the ABI and move things
around for the initialization phase.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/devices/vcpu.txt | 16 ++++++----
 include/kvm/arm_pmu.h                      |  6 ++++
 virt/kvm/arm/arm.c                         |  4 +++
 virt/kvm/arm/pmu.c                         | 51 +++++++++++++++++++++++-------
 4 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
index 02f50686c418..d7236a3e01dc 100644
--- a/Documentation/virtual/kvm/devices/vcpu.txt
+++ b/Documentation/virtual/kvm/devices/vcpu.txt
@@ -16,7 +16,9 @@ Parameters: in kvm_device_attr.addr the address for PMU overflow interrupt is a
 Returns: -EBUSY: The PMU overflow interrupt is already set
          -ENXIO: The overflow interrupt not set when attempting to get it
          -ENODEV: PMUv3 not supported
-         -EINVAL: Invalid PMU overflow interrupt number supplied
+         -EINVAL: Invalid PMU overflow interrupt number supplied or
+                  trying to set the IRQ number without using an in-kernel
+                  irqchip.
 
 A value describing the PMUv3 (Performance Monitor Unit v3) overflow interrupt
 number for this vcpu. This interrupt could be a PPI or SPI, but the interrupt
@@ -25,11 +27,11 @@ all vcpus, while as an SPI it must be a separate number per vcpu.
 
 1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
 Parameters: no additional parameter in kvm_device_attr.addr
-Returns: -ENODEV: PMUv3 not supported
-         -ENXIO: PMUv3 not properly configured as required prior to calling this
-                 attribute
+Returns: -ENODEV: PMUv3 not supported or GIC not initialized
+         -ENXIO: PMUv3 not properly configured or in-kernel irqchip not
+                 configured as required prior to calling this attribute
          -EBUSY: PMUv3 already initialized
 
-Request the initialization of the PMUv3.  This must be done after creating the
-in-kernel irqchip.  Creating a PMU with a userspace irqchip is currently not
-supported.
+Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
+virtual GIC implementation, this must be done after initializing the in-kernel
+irqchip.
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1ab4633adf4f..f6e030617467 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -35,6 +35,7 @@ struct kvm_pmu {
 	int irq_num;
 	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
 	bool ready;
+	bool created;
 	bool irq_level;
 };
 
@@ -63,6 +64,7 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
+int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
@@ -112,6 +114,10 @@ static inline int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
 {
 	return -ENXIO;
 }
+static inline int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index cac5c2f2ddba..72816d3f23a7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -527,6 +527,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	}
 
 	ret = kvm_timer_enable(vcpu);
+	if (ret)
+		return ret;
+
+	ret = kvm_arm_pmu_v3_enable(vcpu);
 
 	return ret;
 }
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 2451607dc25e..96a9cab39982 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -449,29 +449,50 @@ bool kvm_arm_support_pmu_v3(void)
 	return (perf_num_counters() > 0);
 }
 
-static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
+int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_arm_support_pmu_v3())
-		return -ENODEV;
+	if (!vcpu->arch.pmu.created)
+		return 0;
 
 	/*
-	 * We currently require an in-kernel VGIC to use the PMU emulation,
-	 * because we do not support forwarding PMU overflow interrupts to
-	 * userspace yet.
+	 * A valid interrupt configuration for the PMU is either to have a
+	 * properly configured interrupt number and using an in-kernel
+	 * irqchip, or to neither set an IRQ nor create an in-kernel irqchip.
 	 */
-	if (!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))
+	if (kvm_arm_pmu_irq_initialized(vcpu) != irqchip_in_kernel(vcpu->kvm))
+		return -EINVAL;
+
+	kvm_pmu_vcpu_reset(vcpu);
+	vcpu->arch.pmu.ready = true;
+
+	return 0;
+}
+
+static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_arm_support_pmu_v3())
 		return -ENODEV;
 
-	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features) ||
-	    !kvm_arm_pmu_irq_initialized(vcpu))
+	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
 		return -ENXIO;
 
-	if (kvm_arm_pmu_v3_ready(vcpu))
+	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	kvm_pmu_vcpu_reset(vcpu);
-	vcpu->arch.pmu.ready = true;
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		/*
+		 * If using the PMU with an in-kernel virtual GIC
+		 * implementation, we require the GIC to be already
+		 * initialized when initializing the PMU.
+		 */
+		if (!vgic_initialized(vcpu->kvm))
+			return -ENODEV;
+
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			return -ENXIO;
+	}
 
+	vcpu->arch.pmu.created = true;
 	return 0;
 }
 
@@ -510,6 +531,9 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		int __user *uaddr = (int __user *)(long)attr->addr;
 		int irq;
 
+		if (!irqchip_in_kernel(vcpu->kvm))
+			return -EINVAL;
+
 		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
 			return -ENODEV;
 
@@ -544,6 +568,9 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		int __user *uaddr = (int __user *)(long)attr->addr;
 		int irq;
 
+		if (!irqchip_in_kernel(vcpu->kvm))
+			return -EINVAL;
+
 		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
 			return -ENODEV;
 
-- 
2.11.0
