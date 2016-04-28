From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 39/54] KVM: arm/arm64: vgic-new: vgic_kvm_device:
 KVM_DEV_ARM_VGIC_GRP_NR_IRQS
Date: Thu, 28 Apr 2016 17:45:58 +0100
Message-ID: <1461861973-26464-40-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7660F49BFE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:44:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R+niSvIMfLOu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2016 12:44:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC18249BE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:44:33 -0400 (EDT)
In-Reply-To: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch implements the KVM_DEV_ARM_VGIC_GRP_NR_IRQS group. This
modality is supported by both VGIC V2 and V3 KVM device as will be
other groups, hence the introduction of common helpers.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 83 +++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 7c665f9..c96549b 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -15,9 +15,69 @@
  */
 #include <linux/kvm_host.h>
 #include <kvm/vgic/vgic.h>
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
2.7.3
