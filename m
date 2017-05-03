From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 2/5] KVM: arm: Handle VCPU device attributes in guest.c
Date: Wed,  3 May 2017 20:32:57 +0200
Message-ID: <20170503183300.4618-3-cdall@linaro.org>
References: <20170503183300.4618-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503183300.4618-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to support VCPU attributes to set the timer IRQ numbers
in guest.c, move the static inlines for the VCPU attributes handlers
from the header file to guest.c.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h | 22 +++++++--------------
 arch/arm/kvm/guest.c            | 42 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d488b88..0e8c233 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -292,20 +292,12 @@ static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
-static inline int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
-					     struct kvm_device_attr *attr)
-{
-	return -ENXIO;
-}
-static inline int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
-					     struct kvm_device_attr *attr)
-{
-	return -ENXIO;
-}
-static inline int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
-					     struct kvm_device_attr *attr)
-{
-	return -ENXIO;
-}
+
+int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
+int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
+int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr);
 
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index fa6182a..acea05e 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -301,3 +301,45 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 {
 	return -EINVAL;
 }
+
+int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
+			       struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
-- 
2.9.0
