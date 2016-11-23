From: vijay.kilari@gmail.com
Subject: [PATCH v9 01/11] arm/arm64: vgic: Implement support for userspace
 access
Date: Wed, 23 Nov 2016 18:31:48 +0530
Message-ID: <1479906118-15832-2-git-send-email-vijay.kilari@gmail.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E46A640A6A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:01:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nkLdP+e83FyR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 08:01:35 -0500 (EST)
Received: from mail-pg0-f65.google.com (mail-pg0-f65.google.com [74.125.83.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5690840A42
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 08:01:33 -0500 (EST)
Received: by mail-pg0-f65.google.com with SMTP id x23so1085582pgx.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 05:02:14 -0800 (PST)
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

Read and write of some registers like ISPENDR and ICPENDR
from userspace requires special handling when compared to
guest access for these registers.

Refer to Documentation/virtual/kvm/devices/arm-vgic-v3.txt
for handling of ISPENDR, ICPENDR registers handling.

Add infrastructure to support guest and userspace read
and write for the required registers
Also moved vgic_uaccess from vgic-mmio-v2.c to vgic-mmio.c

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  25 ----------
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 102 ++++++++++++++++++++++++++++++++-------
 virt/kvm/arm/vgic/vgic-mmio.c    |  78 +++++++++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-mmio.h    |  19 ++++++++
 4 files changed, 175 insertions(+), 49 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index b44b359..0b32f40 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -406,31 +406,6 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 	return -ENXIO;
 }
 
-/*
- * When userland tries to access the VGIC register handlers, we need to
- * create a usable struct vgic_io_device to be passed to the handlers and we
- * have to set up a buffer similar to what would have happened if a guest MMIO
- * access occurred, including doing endian conversions on BE systems.
- */
-static int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
-			bool is_write, int offset, u32 *val)
-{
-	unsigned int len = 4;
-	u8 buf[4];
-	int ret;
-
-	if (is_write) {
-		vgic_data_host_to_mmio_bus(buf, len, *val);
-		ret = kvm_io_gic_ops.write(vcpu, &dev->dev, offset, len, buf);
-	} else {
-		ret = kvm_io_gic_ops.read(vcpu, &dev->dev, offset, len, buf);
-		if (!ret)
-			*val = vgic_data_mmio_bus_to_host(buf, len);
-	}
-
-	return ret;
-}
-
 int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, u32 *val)
 {
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 50f42f0..8e76d04 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -207,6 +207,66 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
+						  gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	u32 value = 0;
+	int i;
+
+	/*
+	 * A level triggerred interrupt pending state is latched in both
+	 * "soft_pending" and "line_level" variables. Userspace will save
+	 * and restore soft_pending and line_level separately.
+	 * Refer to Documentation/virtual/kvm/devices/arm-vgic-v3.txt
+	 * handling of ISPENDR and ICPENDR.
+	 */
+	for (i = 0; i < len * 8; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->config == VGIC_CONFIG_LEVEL && irq->soft_pending)
+			value |= (1U << i);
+		if (irq->config == VGIC_CONFIG_EDGE && irq->pending)
+			value |= (1U << i);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return value;
+}
+
+static void vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
+					  gpa_t addr, unsigned int len,
+					  unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+
+	for (i = 0; i < len * 8; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		if (test_bit(i, &val)) {
+			/* soft_pending is set irrespective of irq type
+			 * (level or edge) to avoid dependency that VM should
+			 * restore irq config before pending info.
+			 */
+			irq->pending = true;
+			irq->soft_pending = true;
+			vgic_queue_irq_unlock(vcpu->kvm, irq);
+		} else {
+			irq->soft_pending = false;
+			if (irq->config == VGIC_CONFIG_EDGE ||
+			    (irq->config == VGIC_CONFIG_LEVEL &&
+			    !irq->line_level))
+				irq->pending = false;
+			spin_unlock(&irq->irq_lock);
+		}
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
 /* We want to avoid outer shareable. */
 u64 vgic_sanitise_shareability(u64 field)
 {
@@ -356,7 +416,7 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
  * We take some special care here to fix the calculation of the register
  * offset.
  */
-#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(off, rd, wr, bpi, acc)	\
+#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(off, rd, wr, ur, uw, bpi, acc) \
 	{								\
 		.reg_offset = off,					\
 		.bits_per_irq = bpi,					\
@@ -371,6 +431,8 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 		.access_flags = acc,					\
 		.read = rd,						\
 		.write = wr,						\
+		.uaccess_read = ur,					\
+		.uaccess_write = uw,					\
 	}
 
 static const struct vgic_register_region vgic_v3_dist_registers[] = {
@@ -378,40 +440,42 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
-		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
-		vgic_mmio_read_enable, vgic_mmio_write_senable, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
-		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
-		vgic_mmio_read_pending, vgic_mmio_write_spending, 1,
+		vgic_mmio_read_pending, vgic_mmio_write_spending,
+		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
-		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
-		vgic_mmio_read_active, vgic_mmio_write_sactive, 1,
+		vgic_mmio_read_active, vgic_mmio_write_sactive, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
-		vgic_mmio_read_active, vgic_mmio_write_cactive, 1,
+		vgic_mmio_read_active, vgic_mmio_write_cactive, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
-		vgic_mmio_read_priority, vgic_mmio_write_priority, 8,
-		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
+		8, VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ITARGETSR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICFGR,
-		vgic_mmio_read_config, vgic_mmio_write_config, 2,
+		vgic_mmio_read_config, vgic_mmio_write_config, NULL, NULL, 2,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
-		vgic_mmio_read_irouter, vgic_mmio_write_irouter, 64,
+		vgic_mmio_read_irouter, vgic_mmio_write_irouter, NULL, NULL, 64,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
@@ -449,11 +513,13 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0,
 		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ISPENDR0,
-		vgic_mmio_read_pending, vgic_mmio_write_spending, 4,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ISPENDR0,
+		vgic_mmio_read_pending, vgic_mmio_write_spending,
+		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ICPENDR0,
-		vgic_mmio_read_pending, vgic_mmio_write_cpending, 4,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ICPENDR0,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0,
 		vgic_mmio_read_active, vgic_mmio_write_sactive, 4,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ebe1b9f..d5f3ee2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -484,6 +484,74 @@ static bool check_region(const struct kvm *kvm,
 	return false;
 }
 
+static const struct vgic_register_region *
+vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
+		     gpa_t addr, int len)
+{
+	const struct vgic_register_region *region;
+
+	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
+				       addr - iodev->base_addr);
+	if (!region || !check_region(vcpu->kvm, region, addr, len))
+		return NULL;
+
+	return region;
+}
+
+static int vgic_uaccess_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			     gpa_t addr, u32 *val)
+{
+	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
+	const struct vgic_register_region *region;
+	struct kvm_vcpu *r_vcpu;
+
+	region = vgic_get_mmio_region(vcpu, iodev, addr, sizeof(u32));
+	if (!region) {
+		*val = 0;
+		return 0;
+	}
+
+	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
+	if (region->uaccess_read)
+		*val = region->uaccess_read(r_vcpu, addr, sizeof(u32));
+	else
+		*val = region->read(r_vcpu, addr, sizeof(u32));
+
+	return 0;
+}
+
+static int vgic_uaccess_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			      gpa_t addr, const u32 *val)
+{
+	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
+	const struct vgic_register_region *region;
+	struct kvm_vcpu *r_vcpu;
+
+	region = vgic_get_mmio_region(vcpu, iodev, addr, sizeof(u32));
+	if (!region)
+		return 0;
+
+	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
+	if (region->uaccess_write)
+		region->uaccess_write(r_vcpu, addr, sizeof(u32), *val);
+	else
+		region->write(r_vcpu, addr, sizeof(u32), *val);
+
+	return 0;
+}
+
+/*
+ * Userland access to VGIC registers.
+ */
+int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
+		 bool is_write, int offset, u32 *val)
+{
+	if (is_write)
+		return vgic_uaccess_write(vcpu, &dev->dev, offset, val);
+	else
+		return vgic_uaccess_read(vcpu, &dev->dev, offset, val);
+}
+
 static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			      gpa_t addr, int len, void *val)
 {
@@ -491,9 +559,8 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	const struct vgic_register_region *region;
 	unsigned long data = 0;
 
-	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
-				       addr - iodev->base_addr);
-	if (!region || !check_region(vcpu->kvm, region, addr, len)) {
+	region = vgic_get_mmio_region(vcpu, iodev, addr, len);
+	if (!region) {
 		memset(val, 0, len);
 		return 0;
 	}
@@ -524,9 +591,8 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	const struct vgic_register_region *region;
 	unsigned long data = vgic_data_mmio_bus_to_host(val, len);
 
-	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
-				       addr - iodev->base_addr);
-	if (!region || !check_region(vcpu->kvm, region, addr, len))
+	region = vgic_get_mmio_region(vcpu, iodev, addr, len);
+	if (!region)
 		return 0;
 
 	switch (iodev->iodev_type) {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 84961b4..7b30296 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -34,6 +34,10 @@ struct vgic_register_region {
 				  gpa_t addr, unsigned int len,
 				  unsigned long val);
 	};
+	unsigned long (*uaccess_read)(struct kvm_vcpu *vcpu, gpa_t addr,
+				      unsigned int len);
+	void (*uaccess_write)(struct kvm_vcpu *vcpu, gpa_t addr,
+			      unsigned int len, unsigned long val);
 };
 
 extern struct kvm_io_device_ops kvm_io_gic_ops;
@@ -86,6 +90,18 @@ struct vgic_register_region {
 		.write = wr,						\
 	}
 
+#define REGISTER_DESC_WITH_LENGTH_UACCESS(off, rd, wr, urd, uwr, length, acc) \
+	{								\
+		.reg_offset = off,					\
+		.bits_per_irq = 0,					\
+		.len = length,						\
+		.access_flags = acc,					\
+		.read = rd,						\
+		.write = wr,						\
+		.uaccess_read = urd,					\
+		.uaccess_write = uwr,					\
+	}
+
 int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				  struct vgic_register_region *reg_desc,
 				  struct vgic_io_device *region,
@@ -158,6 +174,9 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 			    gpa_t addr, unsigned int len,
 			    unsigned long val);
 
+int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
+		 bool is_write, int offset, u32 *val);
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
-- 
1.9.1
