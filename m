From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 05/24] KVM: arm64: vgic-its: KVM_DEV_ARM_VGIC_GRP_ITS_REGS group
Date: Thu,  4 May 2017 13:44:25 +0200
Message-ID: <1493898284-29504-6-git-send-email-eric.auger@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

The ITS KVM device exposes a new KVM_DEV_ARM_VGIC_GRP_ITS_REGS
group which allows the userspace to save/restore ITS registers.

At this stage the get/set/has operations are not yet implemented.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

---
v5 -> v6:
- Add Christoffer's R-b

v4 -> v5:
- Add Marc's A-b

v3 -> v4:
- added Andre's R-b
---
 arch/arm/include/uapi/asm/kvm.h   |  1 +
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 virt/kvm/arm/vgic/vgic-its.c      | 36 +++++++++++++++++++++++++++++++++++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 6ebd3e6..4beb83b 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -192,6 +192,7 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
+#define KVM_DEV_ARM_VGIC_GRP_ITS_REGS	8
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index c286035..7e8dd69 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -212,6 +212,7 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
+#define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 3ffcbbe..f687e91 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1466,6 +1466,19 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 	kfree(its);
 }
 
+int vgic_its_has_attr_regs(struct kvm_device *dev,
+			   struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+int vgic_its_attr_regs_access(struct kvm_device *dev,
+			      struct kvm_device_attr *attr,
+			      u64 *reg, bool is_write)
+{
+	return -ENXIO;
+}
+
 static int vgic_its_has_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
@@ -1482,6 +1495,8 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS:
+		return vgic_its_has_attr_regs(dev, attr);
 	}
 	return -ENXIO;
 }
@@ -1521,6 +1536,15 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 reg;
+
+		if (get_user(reg, uaddr))
+			return -EFAULT;
+
+		return vgic_its_attr_regs_access(dev, attr, &reg, true);
+	}
 	}
 	return -ENXIO;
 }
@@ -1541,10 +1565,20 @@ static int vgic_its_get_attr(struct kvm_device *dev,
 		if (copy_to_user(uaddr, &addr, sizeof(addr)))
 			return -EFAULT;
 		break;
+	}
+	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 reg;
+		int ret;
+
+		ret = vgic_its_attr_regs_access(dev, attr, &reg, false);
+		if (ret)
+			return ret;
+		return put_user(reg, uaddr);
+	}
 	default:
 		return -ENXIO;
 	}
-	}
 
 	return 0;
 }
-- 
2.5.5
