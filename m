From: vijay.kilari@gmail.com
Subject: [RFC PATCH v1 1/4] arm/arm64: vgic-new: Introduce 64-bit reg access
 support
Date: Wed, 20 Jul 2016 18:32:25 +0530
Message-ID: <1469019748-31005-2-git-send-email-vijay.kilari@gmail.com>
References: <1469019748-31005-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6786449B32
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 08:56:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gcyKrcixCS26 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2016 08:56:41 -0400 (EDT)
Received: from mail-pa0-f65.google.com (mail-pa0-f65.google.com
 [209.85.220.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8A95499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 08:56:40 -0400 (EDT)
Received: by mail-pa0-f65.google.com with SMTP id hh10so3344086pac.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2016 06:02:52 -0700 (PDT)
In-Reply-To: <1469019748-31005-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: Prasun.Kapoor@cavium.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

vgic_attr_regs_access() handles only 32-bit register
value. Introduce union ureg to handle both 32 and 64 bit
register size.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index cc843fe..cace996 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -19,6 +19,11 @@
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
+union ureg {
+	u32 reg32;
+	u64 reg64;
+};
+
 /* common helpers */
 
 static int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
@@ -255,7 +260,7 @@ void kvm_register_vgic_device(unsigned long type)
  */
 static int vgic_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
-				 u32 *reg, bool is_write)
+				 union ureg *reg, bool is_write)
 {
 	gpa_t addr;
 	int cpuid, ret, c;
@@ -293,10 +298,10 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
+		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &reg->reg32);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
+		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, &reg->reg32);
 		break;
 	default:
 		ret = -EINVAL;
@@ -328,9 +333,9 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg;
+		union ureg reg;
 
-		if (get_user(reg, uaddr))
+		if (get_user(reg.reg32, uaddr))
 			return -EFAULT;
 
 		return vgic_attr_regs_access(dev, attr, &reg, true);
@@ -353,12 +358,12 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg = 0;
+		union ureg reg;
 
 		ret = vgic_attr_regs_access(dev, attr, &reg, false);
 		if (ret)
 			return ret;
-		return put_user(reg, uaddr);
+		return put_user(reg.reg32, uaddr);
 	}
 	}
 
-- 
1.7.9.5
