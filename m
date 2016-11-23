From: vijay.kilari@gmail.com
Subject: [PATCH v9 07/11] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Wed, 23 Nov 2016 18:31:54 +0530
Message-ID: <1479906118-15832-8-git-send-email-vijay.kilari@gmail.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C75440B40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:01:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l6NdoVp+x4uf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 08:01:50 -0500 (EST)
Received: from mail-pg0-f67.google.com (mail-pg0-f67.google.com [74.125.83.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4525B40B58
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:01:50 -0500 (EST)
Received: by mail-pg0-f67.google.com with SMTP id p66so1091443pga.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 05:02:30 -0800 (PST)
In-Reply-To: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

Userspace requires to store and restore of line_level for
level triggered interrupts using ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO.

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 arch/arm/include/uapi/asm/kvm.h     |  7 ++++++
 arch/arm64/include/uapi/asm/kvm.h   |  6 +++++
 virt/kvm/arm/vgic/vgic-kvm-device.c | 49 ++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 11 +++++++++
 virt/kvm/arm/vgic/vgic-mmio.c       | 38 ++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h       |  5 ++++
 virt/kvm/arm/vgic/vgic.h            |  2 ++
 7 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 98658d9d..f347779 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -191,6 +191,13 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
+#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
+			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
+#define VGIC_LEVEL_INFO_LINE_LEVEL	0
+
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
 
 /* KVM_IRQ_LINE irq field index values */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 91c7137..4100f8c 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -211,6 +211,12 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
+#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
+			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
+#define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index b6266fe..52ed00b 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -510,6 +510,25 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 						  regid, reg);
 		break;
 	}
+	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
+		unsigned int info, intid;
+
+		info = (attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
+			KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT;
+		if (info == VGIC_LEVEL_INFO_LINE_LEVEL) {
+			if (is_write)
+				tmp32 = *reg;
+			intid = attr->attr &
+				KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK;
+			ret = vgic_v3_line_level_info_uaccess(vcpu, is_write,
+							      intid, &tmp32);
+			if (!is_write)
+				*reg = tmp32;
+		} else {
+			ret = -EINVAL;
+		}
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
@@ -552,6 +571,17 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 
 		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
 	}
+	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+		u64 reg;
+		u32 tmp32;
+
+		if (get_user(tmp32, uaddr))
+			return -EFAULT;
+
+		reg = tmp32;
+		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
+	}
 	}
 	return -ENXIO;
 }
@@ -587,8 +617,18 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 			return ret;
 		return put_user(reg, uaddr);
 	}
-	}
+	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+		u64 reg;
+		u32 tmp32;
 
+		ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
+		if (ret)
+			return ret;
+		tmp32 = reg;
+		return put_user(tmp32, uaddr);
+	}
+	}
 	return -ENXIO;
 }
 
@@ -609,6 +649,13 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		return vgic_v3_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
+	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
+		if (((attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
+		      KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT) ==
+		      VGIC_LEVEL_INFO_LINE_LEVEL)
+			return 0;
+		break;
+	}
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 2f7b4ed..4d7d93d 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -808,3 +808,14 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 		return vgic_uaccess(vcpu, &rd_dev, is_write,
 				    offset, val);
 }
+
+int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+				    u32 intid, u32 *val)
+{
+	if (is_write)
+		vgic_write_irq_line_level_info(vcpu, intid, *val);
+	else
+		*val = vgic_read_irq_line_level_info(vcpu, intid);
+
+	return 0;
+}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index f81e0e5..d602081 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -371,6 +371,44 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 	}
 }
 
+unsigned long vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid)
+{
+	int i;
+	unsigned long val = 0;
+
+	for (i = 0; i < 32; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->line_level)
+			val |= (1U << i);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return val;
+}
+
+void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
+				    const unsigned long val)
+{
+	int i;
+
+	for (i = 0; i < 32; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		if (val & (1U << i)) {
+			irq->line_level = true;
+			vgic_queue_irq_unlock(vcpu->kvm, irq);
+		} else {
+			irq->line_level = false;
+			spin_unlock(&irq->irq_lock);
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
 static int match_region(const void *key, const void *elt)
 {
 	const unsigned int offset = (unsigned long)key;
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 1cc7faf..f16d510 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -181,6 +181,11 @@ int vgic_validate_mmio_region_addr(struct kvm_device *dev,
 				   const struct vgic_register_region *regions,
 				   int nr_regions, gpa_t addr);
 
+unsigned long vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid);
+
+void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
+				    const unsigned long val);
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index af23399..a6de38f 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -144,6 +144,8 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 u64 id, u64 *val);
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
 				u64 *reg);
+int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+				    u32 intid, u32 *val);
 bool access_gic_ctlr_reg(struct kvm_vcpu *vcpu, bool is_write,
 			 unsigned long *reg);
 bool access_gic_pmr_reg(struct kvm_vcpu *vcpu, bool is_write,
-- 
1.9.1
