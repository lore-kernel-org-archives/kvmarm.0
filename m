From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 41/54] KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_ADDR
Date: Thu, 28 Apr 2016 17:46:00 +0100
Message-ID: <1461861973-26464-42-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch implements the KVM_DEV_ARM_VGIC_GRP_ADDR group which
enables to set the base address of GIC regions as seen by the guest.

The kvm_vgic_addr function whci eventually assigns the chosen address
to the internal structure still is stubbed.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 18cccac..d6fb2d6 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -26,6 +26,17 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 	int r;
 
 	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 addr;
+		unsigned long type = (unsigned long)attr->attr;
+
+		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+			return -EFAULT;
+
+		r = kvm_vgic_addr(dev->kvm, type, &addr, true);
+		return (r == -ENODEV) ? -ENXIO : r;
+	}
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 		u32 val;
@@ -78,6 +89,19 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 	int r = -ENXIO;
 
 	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 addr;
+		unsigned long type = (unsigned long)attr->attr;
+
+		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
+		if (r)
+			return (r == -ENODEV) ? -ENXIO : r;
+
+		if (copy_to_user(uaddr, &addr, sizeof(addr)))
+			return -EFAULT;
+		break;
+	}
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 
@@ -141,6 +165,13 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V2_ADDR_TYPE_DIST:
+		case KVM_VGIC_V2_ADDR_TYPE_CPU:
+			return 0;
+		}
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
@@ -181,6 +212,13 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V3_ADDR_TYPE_DIST:
+		case KVM_VGIC_V3_ADDR_TYPE_REDIST:
+			return 0;
+		}
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
-- 
2.7.3

