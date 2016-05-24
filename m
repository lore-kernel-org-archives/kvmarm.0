From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 42/59] KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_NR_IRQS
Date: Tue, 24 May 2016 11:09:36 +0200
Message-ID: <1464080993-10884-43-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch implements the KVM_DEV_ARM_VGIC_GRP_NR_IRQS group. This
modality is supported by both VGIC V2 and V3 KVM device as will be
other groups, hence the introduction of common helpers.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 83 +++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index ff332f3..05ff925 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -15,9 +15,69 @@
  */
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
+#include <linux/uaccess.h>
+#include "vgic.h"
 
 /* common helpers */
 
+static int vgic_set_common_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+		u32 val;
+		int ret = 0;
+
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
+		/*
+		 * We require:
+		 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
+		 * - at most 1024 interrupts
+		 * - a multiple of 32 interrupts
+		 */
+		if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
+		    val > VGIC_MAX_RESERVED ||
+		    (val & 31))
+			return -EINVAL;
+
+		mutex_lock(&dev->kvm->lock);
+
+		if (vgic_ready(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
+			ret = -EBUSY;
+		else
+			dev->kvm->arch.vgic.nr_spis =
+				val - VGIC_NR_PRIVATE_IRQS;
+
+		mutex_unlock(&dev->kvm->lock);
+
+		return ret;
+	}
+	}
+
+	return -ENXIO;
+}
+
+static int vgic_get_common_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	int r = -ENXIO;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+
+		r = put_user(dev->kvm->arch.vgic.nr_spis +
+			     VGIC_NR_PRIVATE_IRQS, uaddr);
+		break;
+	}
+	}
+
+	return r;
+}
+
 static int vgic_create(struct kvm_device *dev, u32 type)
 {
 	return kvm_vgic_create(dev->kvm, type);
@@ -49,18 +109,29 @@ void kvm_register_vgic_device(unsigned long type)
 static int vgic_v2_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	int ret;
+
+	ret = vgic_set_common_attr(dev, attr);
+	return ret;
+
 }
 
 static int vgic_v2_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	int ret;
+
+	ret = vgic_get_common_attr(dev, attr);
+	return ret;
 }
 
 static int vgic_v2_has_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return 0;
+	}
 	return -ENXIO;
 }
 
@@ -80,18 +151,22 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	return vgic_set_common_attr(dev, attr);
 }
 
 static int vgic_v3_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	return vgic_get_common_attr(dev, attr);
 }
 
 static int vgic_v3_has_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return 0;
+	}
 	return -ENXIO;
 }
 
-- 
2.1.2.330.g565301e.dirty

