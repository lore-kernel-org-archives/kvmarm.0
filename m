From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 03/50] KVM: arm/arm64: Rename vgic_attr_regs_access to
 vgic_attr_regs_access_v2
Date: Tue, 27 Sep 2016 20:05:11 +0200
Message-ID: <20160927180558.14699-4-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C90CA49B43
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E2fyAJntPP8K for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:26 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E11A4998D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:26 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id b130so27048053wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:05:49 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Just a rename so we can implement a v3-specific function later.

We take the chance to get rid of the V2/V3 ops comments as well.

No functional change.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 19fa331..163b057 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -294,17 +294,17 @@ static bool lock_all_vcpus(struct kvm *kvm)
 	return true;
 }
 
-/** vgic_attr_regs_access: allows user space to read/write VGIC registers
- *
- * @dev: kvm device handle
- * @attr: kvm device attribute
- * @reg: address the value is read or written
- * @is_write: write flag
+/**
+ * vgic_attr_regs_access_v2 - allows user space to access VGIC v2 state
  *
+ * @dev:      kvm device handle
+ * @attr:     kvm device attribute
+ * @reg:      address the value is read or written
+ * @is_write: true if userspace is writing a register
  */
-static int vgic_attr_regs_access(struct kvm_device *dev,
-				 struct kvm_device_attr *attr,
-				 u32 *reg, bool is_write)
+static int vgic_attr_regs_access_v2(struct kvm_device *dev,
+				    struct kvm_device_attr *attr,
+				    u32 *reg, bool is_write)
 {
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
@@ -347,8 +347,6 @@ out:
 	return ret;
 }
 
-/* V2 ops */
-
 static int vgic_v2_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -367,7 +365,7 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 		if (get_user(reg, uaddr))
 			return -EFAULT;
 
-		return vgic_attr_regs_access(dev, attr, &reg, true);
+		return vgic_attr_regs_access_v2(dev, attr, &reg, true);
 	}
 	}
 
@@ -389,7 +387,7 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 		u32 reg = 0;
 
-		ret = vgic_attr_regs_access(dev, attr, &reg, false);
+		ret = vgic_attr_regs_access_v2(dev, attr, &reg, false);
 		if (ret)
 			return ret;
 		return put_user(reg, uaddr);
@@ -433,8 +431,6 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 	.has_attr = vgic_v2_has_attr,
 };
 
-/* V3 ops */
-
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 
 static int vgic_v3_set_attr(struct kvm_device *dev,
-- 
2.9.0
