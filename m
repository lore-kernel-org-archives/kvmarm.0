From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 31/45] KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_CTRL
Date: Fri, 25 Mar 2016 02:04:54 +0000
Message-ID: <1458871508-17279-32-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch implements the KVM_DEV_ARM_VGIC_GRP_CTRL group API
featuring KVM_DEV_ARM_VGIC_CTRL_INIT attribute. The vgic_init
function is not yet implemented though.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic_kvm_device.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic_kvm_device.c b/virt/kvm/arm/vgic/vgic_kvm_device.c
index c96549b..18cccac 100644
--- a/virt/kvm/arm/vgic/vgic_kvm_device.c
+++ b/virt/kvm/arm/vgic/vgic_kvm_device.c
@@ -23,6 +23,8 @@
 static int vgic_set_common_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
+	int r;
+
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
@@ -55,6 +57,16 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 
 		return ret;
 	}
+	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			mutex_lock(&dev->kvm->lock);
+			r = vgic_init(dev->kvm);
+			mutex_unlock(&dev->kvm->lock);
+			return r;
+		}
+		break;
+	}
 	}
 
 	return -ENXIO;
@@ -131,6 +143,11 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		}
 	}
 	return -ENXIO;
 }
@@ -166,6 +183,11 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		}
 	}
 	return -ENXIO;
 }
-- 
2.7.3

