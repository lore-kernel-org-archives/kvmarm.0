From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 38/55] KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM
 device ops registration
Date: Fri,  6 May 2016 11:45:51 +0100
Message-ID: <1462531568-9799-39-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E14949C96
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pjLWVj+79pER for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:43:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60E7549C89
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:57 -0400 (EDT)
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
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

This patch introduces the skeleton for the KVM device operations
associated to KVM_DEV_TYPE_ARM_VGIC_V2 and KVM_DEV_TYPE_ARM_VGIC_V3.

At that stage kvm_vgic_create is stubbed.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v1 .. v2:
- rename vgic_kvm_device.c to vgic-kvm-device.c

Changelog v2 .. v3:
- replace inclusion of vgic/vgic.h with arm_vgic.h
- add kvm_register_vgic_device() prototype to this patch

 virt/kvm/arm/vgic/vgic-kvm-device.c | 108 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |   2 +
 2 files changed, 110 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-kvm-device.c

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
new file mode 100644
index 0000000..ff332f3
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -0,0 +1,108 @@
+/*
+ * VGIC: KVM DEVICE API
+ *
+ * Copyright (C) 2015 ARM Ltd.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/kvm_host.h>
+#include <kvm/arm_vgic.h>
+
+/* common helpers */
+
+static int vgic_create(struct kvm_device *dev, u32 type)
+{
+	return kvm_vgic_create(dev->kvm, type);
+}
+
+static void vgic_destroy(struct kvm_device *dev)
+{
+	kfree(dev);
+}
+
+void kvm_register_vgic_device(unsigned long type)
+{
+	switch (type) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
+					KVM_DEV_TYPE_ARM_VGIC_V2);
+		break;
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
+					KVM_DEV_TYPE_ARM_VGIC_V3);
+		break;
+#endif
+	}
+}
+
+/* V2 ops */
+
+static int vgic_v2_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int vgic_v2_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int vgic_v2_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+struct kvm_device_ops kvm_arm_vgic_v2_ops = {
+	.name = "kvm-arm-vgic-v2",
+	.create = vgic_create,
+	.destroy = vgic_destroy,
+	.set_attr = vgic_v2_set_attr,
+	.get_attr = vgic_v2_get_attr,
+	.has_attr = vgic_v2_has_attr,
+};
+
+/* V3 ops */
+
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+
+static int vgic_v3_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int vgic_v3_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int vgic_v3_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+struct kvm_device_ops kvm_arm_vgic_v3_ops = {
+	.name = "kvm-arm-vgic-v3",
+	.create = vgic_create,
+	.destroy = vgic_destroy,
+	.set_attr = vgic_v3_set_attr,
+	.get_attr = vgic_v3_get_attr,
+	.has_attr = vgic_v3_has_attr,
+};
+
+#endif /* CONFIG_KVM_ARM_VGIC_V3 */
+
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 635e2e2..e7c66a5 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -72,4 +72,6 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 }
 #endif
 
+void kvm_register_vgic_device(unsigned long type);
+
 #endif
-- 
2.7.3
