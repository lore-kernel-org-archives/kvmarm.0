From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 06/22] KVM: arm64: ITS: Implement vgic_its_has_attr_regs
 and attr_regs_access
Date: Mon, 27 Mar 2017 11:30:56 +0200
Message-ID: <1490607072-21610-7-git-send-email-eric.auger@redhat.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56A9540AE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:29:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LNwaU7Kb853A for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 05:29:55 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7403740A95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 05:29:55 -0400 (EDT)
In-Reply-To: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch implements vgic_its_has_attr_regs and vgic_its_attr_regs_access
upon the MMIO framework. VGIC ITS KVM device KVM_DEV_ARM_VGIC_GRP_ITS_REGS
group becomes functional.

At least GITS_CREADR requires to differentiate a guest write action from a
user access. As such let's introduce a new uaccess_its_write
vgic_register_region callback.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- remove changes to the REGISTER_ITS_DESC macro. This will be handled in
  subsequent patch with the introduction of a new REGISTER_ITS_DESC_UACCESS
  macro
- fix IIDR access and add a comment wrt full length access
- handle endianness
- add kvm lock and vcpus lock
---
 virt/kvm/arm/vgic/vgic-its.c  | 78 +++++++++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio.h |  9 +++--
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f687e91..9b9ea86 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1469,14 +1469,88 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 int vgic_its_has_attr_regs(struct kvm_device *dev,
 			   struct kvm_device_attr *attr)
 {
-	return -ENXIO;
+	const struct vgic_register_region *region;
+	struct vgic_io_device iodev = {
+		.regions = its_registers,
+		.nr_regions = ARRAY_SIZE(its_registers),
+	};
+	gpa_t offset = attr->attr;
+
+	region = vgic_find_mmio_region(iodev.regions,
+				       iodev.nr_regions,
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
+	struct vgic_io_device iodev = {
+		.regions = its_registers,
+		.nr_regions = ARRAY_SIZE(its_registers),
+	};
+	struct vgic_its *its = dev->private;
+	gpa_t addr, offset = attr->attr;
+	unsigned int len;
+	unsigned long data = 0;
+	int ret = 0;
+
+	/*
+	 * Among supported registers, only GITS_CTLR (0x0) and GITS_IIDR (0x4)
+	 * are 32 bits. Others are 64 bits.
+	 */
+	if ((offset < 0x8 && offset & 0x3) || (offset >= 0x8 && offset & 0x7))
+		return -EINVAL;
+
+	mutex_lock(&dev->kvm->lock);
+
+	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base)) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	region = vgic_find_mmio_region(iodev.regions,
+				       iodev.nr_regions,
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
+	/*
+	 * Only full length register accesses are supported although
+	 * the architecture spec theoretically allows upper/lower 32
+	 * bits to be accessed independently
+	 */
+	len = region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (is_write) {
+		data = vgic_data_mmio_bus_to_host(reg, len);
+		if (region->uaccess_its_write)
+			region->uaccess_its_write(dev->kvm, its, addr,
+						  len, data);
+		else
+			region->its_write(dev->kvm, its, addr, len, data);
+	} else {
+		data = region->its_read(dev->kvm, its, addr, len);
+		vgic_data_host_to_mmio_bus(reg, len, data);
+	}
+	unlock_all_vcpus(dev->kvm);
+out:
+	mutex_unlock(&dev->kvm->lock);
+	return ret;
 }
 
 static int vgic_its_has_attr(struct kvm_device *dev,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 6eec91b..becc473 100644
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
+		void (*uaccess_its_write)(struct kvm *kvm, struct vgic_its *its,
+					  gpa_t addr, unsigned int len,
+					  unsigned long val);
+	};
 };
 
 extern struct kvm_io_device_ops kvm_io_gic_ops;
-- 
2.5.5
