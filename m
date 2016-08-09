From: vijay.kilari@gmail.com
Subject: [RFC PATCH v2 1/4] arm/arm64: vgic-new: Introduce 64-bit reg access
 support
Date: Tue,  9 Aug 2016 16:28:43 +0530
Message-ID: <1470740326-27751-2-git-send-email-vijay.kilari@gmail.com>
References: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE77F49B55
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 06:52:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t1iHg0yTA6cx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 06:52:15 -0400 (EDT)
Received: from mail-pf0-f193.google.com (mail-pf0-f193.google.com
 [209.85.192.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 550CA49B49
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 06:52:13 -0400 (EDT)
Received: by mail-pf0-f193.google.com with SMTP id g202so720924pfb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2016 03:59:20 -0700 (PDT)
In-Reply-To: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
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
value. Pass u64 as parameter and locally handle 32-bit
reads and writes depending on attribute group.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 0130c4b..06de322 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -236,12 +236,13 @@ void kvm_register_vgic_device(unsigned long type)
  */
 static int vgic_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
-				 u32 *reg, bool is_write)
+				 u64 *reg, bool is_write)
 {
 	gpa_t addr;
 	int cpuid, ret, c;
 	struct kvm_vcpu *vcpu, *tmp_vcpu;
 	int vcpu_lock_idx = -1;
+	u32 tmp32;
 
 	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
 		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
@@ -272,12 +273,19 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 		vcpu_lock_idx = c;
 	}
 
+	if (is_write)
+		tmp32 = *reg;
+
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
+		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &tmp32);
+		if (!is_write)
+			*reg = tmp32;
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
+		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, &tmp32);
+		if (!is_write)
+			*reg = tmp32;
 		break;
 	default:
 		ret = -EINVAL;
@@ -309,11 +317,13 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg;
+		u32 tmp32;
+		u64 reg;
 
-		if (get_user(reg, uaddr))
+		if (get_user(tmp32, uaddr))
 			return -EFAULT;
 
+		reg = tmp32;
 		return vgic_attr_regs_access(dev, attr, &reg, true);
 	}
 	}
@@ -334,12 +344,14 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg = 0;
+		u32 tmp32;
+		u64 reg;
 
 		ret = vgic_attr_regs_access(dev, attr, &reg, false);
 		if (ret)
 			return ret;
-		return put_user(reg, uaddr);
+		tmp32 = reg;
+		return put_user(tmp32, uaddr);
 	}
 	}
 
-- 
1.9.1
