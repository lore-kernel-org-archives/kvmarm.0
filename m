From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 09/37] KVM: arm64: vgic-its: Implement vgic_its_has_attr_regs
 and attr_regs_access
Date: Tue,  9 May 2017 12:44:38 +0200
Message-ID: <20170509104506.30929-10-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 713F640C35
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gpS123aRkOWK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:10 -0400 (EDT)
Received: from mail-qk0-f179.google.com (mail-qk0-f179.google.com
 [209.85.220.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFDC240C28
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:06 -0400 (EDT)
Received: by mail-qk0-f179.google.com with SMTP id u75so75010765qka.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:21 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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

From: Eric Auger <eric.auger@redhat.com>

This patch implements vgic_its_has_attr_regs and vgic_its_attr_regs_access
upon the MMIO framework. VGIC ITS KVM device KVM_DEV_ARM_VGIC_GRP_ITS_REGS
group becomes functional.

At least GITS_CREADR and GITS_IIDR require to differentiate a guest write
action from a user access. As such let's introduce a new uaccess_its_write
vgic_register_region callback.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c  | 79 +++++++++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.h |  9 +++--
 2 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f687e91..fd2660d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1469,14 +1469,89 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 int vgic_its_has_attr_regs(struct kvm_device *dev,
 			   struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	const struct vgic_register_region *region;
+	gpa_t offset = attr->attr;
+	int align;
+
+	align = (offset < GITS_TYPER) || (offset >= GITS_PIDR4) ? 0x3 : 0x7;
+
+	if (offset & align)
+		return -EINVAL;
+
+	region = vgic_find_mmio_region(its_registers,
+				       ARRAY_SIZE(its_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	return 0;
 }
 
 int vgic_its_attr_regs_access(struct kvm_device *dev,
 			      struct kvm_device_attr *attr,
 			      u64 *reg, bool is_write)
 {
-	return -ENXIO;
+	const struct vgic_register_region *region;
+	struct vgic_its *its;
+	gpa_t addr, offset;
+	unsigned int len;
+	int align, ret = 0;
+
+	its = dev->private;
+	offset = attr->attr;
+
+	/*
+	 * Although the spec supports upper/lower 32-bit accesses to
+	 * 64-bit ITS registers, the userspace ABI requires 64-bit
+	 * accesses to all 64-bit wide registers. We therefore only
+	 * support 32-bit accesses to GITS_CTLR, GITS_IIDR and GITS ID
+	 * registers
+	 */
+	if ((offset < GITS_TYPER) || (offset >= GITS_PIDR4))
+		align = 0x3;
+	else
+		align = 0x7;
+
+	if (offset & align)
+		return -EINVAL;
+
+	mutex_lock(&dev->kvm->lock);
+
+	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base)) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	region = vgic_find_mmio_region(its_registers,
+				       ARRAY_SIZE(its_registers),
+				       offset);
+	if (!region) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	if (!lock_all_vcpus(dev->kvm)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	addr = its->vgic_its_base + offset;
+
+	len = region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (is_write) {
+		if (region->uaccess_its_write)
+			ret = region->uaccess_its_write(dev->kvm, its, addr,
+							len, *reg);
+		else
+			region->its_write(dev->kvm, its, addr, len, *reg);
+	} else {
+		*reg = region->its_read(dev->kvm, its, addr, len);
+	}
+	unlock_all_vcpus(dev->kvm);
+out:
+	mutex_unlock(&dev->kvm->lock);
+	return ret;
 }
 
 static int vgic_its_has_attr(struct kvm_device *dev,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 6eec91b..ea4171a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -36,8 +36,13 @@ struct vgic_register_region {
 	};
 	unsigned long (*uaccess_read)(struct kvm_vcpu *vcpu, gpa_t addr,
 				      unsigned int len);
-	void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
-			      unsigned int len, unsigned long val);
+	union {
+		void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
+				      unsigned int len, unsigned long val);
+		int (*uaccess_its_write)(struct kvm *kvm, struct vgic_its *its,
+					 gpa_t addr, unsigned int len,
+					 unsigned long val);
+	};
 };
 
 extern struct kvm_io_device_ops kvm_io_gic_ops;
-- 
2.9.0
