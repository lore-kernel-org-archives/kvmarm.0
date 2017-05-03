From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 1/5] KVM: arm64: Allow creating the PMU without the in-kernel GIC
Date: Wed,  3 May 2017 20:32:56 +0200
Message-ID: <20170503183300.4618-2-cdall@linaro.org>
References: <20170503183300.4618-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503183300.4618-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Since we got support for devices in userspace which allows reporting the
PMU overflow output status to userspace, we should actually allow
creating the PMU on systems without an in-kernel irqchip, which in turn
requires us to slightly clarify error codes for the ABI and move things
around for the initialization phase.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 Documentation/virtual/kvm/devices/vcpu.txt | 16 +++++++++-------
 virt/kvm/arm/pmu.c                         | 27 +++++++++++++++++----------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
index 02f5068..352af6e 100644
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
+                 conigured as required prior to calling this attribute
          -EBUSY: PMUv3 already initialized
 
-Request the initialization of the PMUv3.  This must be done after creating the
-in-kernel irqchip.  Creating a PMU with a userspace irqchip is currently not
-supported.
+Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
+virtual GIC implementation, this must be done after initializing the in-kernel
+irqchip.
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 4b43e7f..f046b08 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -456,21 +456,25 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_support_pmu_v3())
 		return -ENODEV;
 
-	/*
-	 * We currently require an in-kernel VGIC to use the PMU emulation,
-	 * because we do not support forwarding PMU overflow interrupts to
-	 * userspace yet.
-	 */
-	if (!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))
-		return -ENODEV;
-
-	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features) ||
-	    !kvm_arm_pmu_irq_initialized(vcpu))
+	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
 		return -ENXIO;
 
 	if (kvm_arm_pmu_v3_ready(vcpu))
 		return -EBUSY;
 
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
+
 	kvm_pmu_vcpu_reset(vcpu);
 	vcpu->arch.pmu.ready = true;
 
@@ -512,6 +516,9 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		int __user *uaddr = (int __user *)(long)attr->addr;
 		int irq;
 
+		if (!irqchip_in_kernel(vcpu->kvm))
+			return -EINVAL;
+
 		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
 			return -ENODEV;
 
-- 
2.9.0
