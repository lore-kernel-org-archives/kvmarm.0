From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 31/45] KVM: arm/arm64: vgic-new: vgic_kvm_device:
 KVM_DEV_ARM_VGIC_GRP_CTRL
Date: Fri, 15 Apr 2016 18:11:42 +0100
Message-ID: <1460740316-8755-32-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16DA849C71
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cwox7pnNePTV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B4A49C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:47 -0400 (EDT)
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
