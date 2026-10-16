Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1B62877DE
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166370; cv=none; b=RlIrROxh2BzJCWkJbzQdZ+x/KbEYS8CBJAr5ufey2/qpiPbCA4ekR0CwkVuzQQY7OutNvVimIipf1wj4Q03Jt9fuSglhOb+PFQmVZqFS85gIwp72gnX2yAbyx9VgrWdMGPvcw0jnUH1m4dzQ+b3X2F3zgQUJlEKT8i38HuWp9js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166370; c=relaxed/simple;
	bh=229T4WvQv+J4HvFCHxTgwEuQJWOD41+IXoI/1uceY9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pnv8+BU5qnviJy4zVxXb1l+o0X3AyoqXK6nhdt80WJsmofBM13ux/cy7emcBkWx54Brg1m6Cb+ZYCQ/iGh+wxH0P+qrVYaatgQHsIcSjh/JzWYhLE2T5RjE8ZtNDnnZ4EsWWQeo4xG6qbu+H6t5QMEBVcLpTo9dTzSak+8hkat4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nYOcHzgM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nYOcHzgM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E82D1516;
	Fri, 16 Oct 2026 08:59:25 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9F533F673;
	Fri, 16 Oct 2026 08:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166368; bh=229T4WvQv+J4HvFCHxTgwEuQJWOD41+IXoI/1uceY9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYOcHzgMmAbpZh7TQa4TvXa/lfjIb5p1vDOQ2Fgtdqid9r+2khewUycLctLW/DcY/
	 qwCNk4O+s/CMrLq7KuQ12DzgNKg1g5ydEE8tdYCv1UsVKwRN4vCMGP0QnctiQsoEg5
	 vHYun3T0j47SVp6Rb+eixtma97FI1MQRKQ+3x8Sw=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH 10/16] KVM: arm64: gic-v5: Add ITS userspace register access
Date: Fri, 16 Oct 2026 16:57:35 +0100
Message-Id: <20261016155741.979985-11-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016155741.979985-1-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace needs access to the emulated GICv5 ITS MMIO state in order
to inspect and restore the device state around VM reset and migration.
Expose the GICv5 ITS register frame through KVM_DEV_ARM_VGIC_GRP_ITS_REGS.

Reuse the same MMIO register descriptors used by the guest-facing
IODEV, but apply the usual userspace access constraints: the ITS base
address must have been configured, the register offset must map to an
emulated ITS register, and userspace accesses must use the natural
32-bit or 64-bit register alignment.

Add control handling for KVM_DEV_ARM_ITS_CTRL_RESET. The reset is
performed while all vCPUs are stopped and while holding the ITS lock,
so it cannot race with guest MMIO updates or translation lookups. The
reset clears guest-programmed state and cached translations while
preserving the advertised ITS capability defaults.

Do not expose GICv5 ITS SAVE_TABLES or RESTORE_TABLES controls. For
GICv5, the guest-owned DT and ITTs are the authoritative translation
state, and the KVM translation cache is disposable state that can be
rebuilt from guest memory.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-its-v5.c | 270 +++++++++++++++++++++++++-----
 1 file changed, 229 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
index 5920fa1bcb2cf..62c1ca8004007 100644
--- a/arch/arm64/kvm/vgic/vgic-its-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
@@ -851,6 +851,19 @@ static u64 vgic_v5_read_its_dt_baser(struct vgic_v5_its *its)
 			  its->dt_baser.addr >> GICV5_ITS_DT_BASER_ADDR_SHIFT);
 }
 
+static int vgic_v5_uaccess_write_its_dt_itt(struct kvm *kvm, void *dev,
+					    gpa_t addr, unsigned int len,
+					    unsigned long val)
+{
+	struct vgic_v5_its *its = dev;
+	size_t offset = addr & (SZ_64K - 1);
+
+	guard(mutex)(&its->its_lock);
+
+	vgic_v5_write_its_dt_reg(its, offset, val);
+	return 0;
+}
+
 static unsigned long vgic_v5_mmio_read_its_dt_itt(struct kvm *kvm, void *dev,
 						  gpa_t addr, unsigned int len)
 {
@@ -1018,6 +1031,13 @@ static void vgic_v5_mmio_write_its_wi(struct kvm *kvm, void *dev, gpa_t addr,
 		.its_read = rd, .its_write = wr,                       \
 	}
 
+#define REGISTER_ITS_V5_DESC_UACCESS(off, rd, wr, uwr, length, acc)    \
+	{                                                              \
+		.reg_offset = off, .len = length, .access_flags = acc, \
+		.its_read = rd, .its_write = wr,                       \
+		.uaccess_its_write = uwr,                              \
+	}
+
 static const struct vgic_register_region vgic_v5_its_registers[] = {
 	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR0, vgic_v5_mmio_read_its_misc,
 			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),
@@ -1033,14 +1053,16 @@ static const struct vgic_register_region vgic_v5_its_registers[] = {
 			     vgic_v5_mmio_write_its_misc, 4, VGIC_ACCESS_32bit),
 	REGISTER_ITS_V5_DESC(GICV5_ITS_CR1, vgic_v5_mmio_read_its_misc,
 			     vgic_v5_mmio_write_its_misc, 4, VGIC_ACCESS_32bit),
-	REGISTER_ITS_V5_DESC(GICV5_ITS_DT_BASER,
-			     vgic_v5_mmio_read_its_dt_itt,
-			     vgic_v5_mmio_write_its_dt_itt, 8,
-			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
-	REGISTER_ITS_V5_DESC(GICV5_ITS_DT_CFGR,
-			     vgic_v5_mmio_read_its_dt_itt,
-			     vgic_v5_mmio_write_its_dt_itt, 4,
-			     VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC_UACCESS(GICV5_ITS_DT_BASER,
+				     vgic_v5_mmio_read_its_dt_itt,
+				     vgic_v5_mmio_write_its_dt_itt,
+				     vgic_v5_uaccess_write_its_dt_itt, 8,
+				     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_V5_DESC_UACCESS(GICV5_ITS_DT_CFGR,
+				     vgic_v5_mmio_read_its_dt_itt,
+				     vgic_v5_mmio_write_its_dt_itt,
+				     vgic_v5_uaccess_write_its_dt_itt, 4,
+				     VGIC_ACCESS_32bit),
 	REGISTER_ITS_V5_DESC(GICV5_ITS_DIDR, vgic_v5_mmio_read_its_dt_itt,
 			     vgic_v5_mmio_write_its_dt_itt, 8,
 			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
@@ -1243,64 +1265,230 @@ static int vgic_v5_register_its_iodev(struct kvm *kvm, struct vgic_v5_its *its,
 	return ret;
 }
 
+static int vgic_v5_its_has_attr_regs(struct kvm_device *dev,
+				     struct kvm_device_attr *attr)
+{
+	struct vgic_v5_its *its = dev->private;
+	const struct vgic_register_region *region;
+	gpa_t offset = attr->attr;
+	int align;
+
+	if (IS_VGIC_ADDR_UNDEF(its->vgic_v5_its_base))
+		return -ENXIO;
+
+	region = vgic_find_mmio_region(vgic_v5_its_registers,
+				       ARRAY_SIZE(vgic_v5_its_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	align = region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	if (offset & align)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vgic_v5_its_attr_regs_access(struct kvm_device *dev,
+					struct kvm_device_attr *attr,
+					u64 *reg, bool is_write)
+{
+	const struct vgic_register_region *region;
+	struct vgic_v5_its *its = dev->private;
+	gpa_t offset = attr->attr;
+	unsigned int len;
+	gpa_t addr;
+	int align;
+	int ret = 0;
+
+	mutex_lock(&dev->kvm->lock);
+
+	if (kvm_trylock_all_vcpus(dev->kvm)) {
+		mutex_unlock(&dev->kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&dev->kvm->arch.config_lock);
+
+	if (IS_VGIC_ADDR_UNDEF(its->vgic_v5_its_base)) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	region = vgic_find_mmio_region(vgic_v5_its_registers,
+				       ARRAY_SIZE(vgic_v5_its_registers),
+				       offset);
+	if (!region) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	/*
+	 * Although the spec supports upper/lower 32-bit accesses to
+	 * 64-bit ITS registers, the userspace ABI requires 64-bit
+	 * accesses to all 64-bit wide registers.
+	 */
+	align = region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	len = region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (offset & align) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	addr = its->vgic_v5_its_base + offset;
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
+out:
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(dev->kvm);
+	mutex_unlock(&dev->kvm->lock);
+
+	return ret;
+}
+
+static int vgic_v5_its_ctrl(struct kvm *kvm, struct vgic_v5_its *its, u64 attr)
+{
+	int ret = 0;
+
+	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT)
+		return 0;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&kvm->arch.config_lock);
+	mutex_lock(&its->its_lock);
+
+	switch (attr) {
+	case KVM_DEV_ARM_ITS_CTRL_RESET:
+		vgic_v5_its_reset(its);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	mutex_unlock(&its->its_lock);
+	mutex_unlock(&kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
 static int vgic_v5_its_set_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
 	struct vgic_v5_its *its = dev->private;
-	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
-	unsigned long type = (unsigned long)attr->attr;
-	u64 addr;
 	int ret;
 
-	if (attr->group != KVM_DEV_ARM_VGIC_GRP_ADDR)
-		return -ENXIO;
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		unsigned long type = (unsigned long)attr->attr;
+		u64 addr;
 
-	if (type != KVM_VGIC_V5_ADDR_TYPE_ITS)
-		return -ENODEV;
+		if (type != KVM_VGIC_V5_ADDR_TYPE_ITS)
+			return -ENODEV;
 
-	if (copy_from_user(&addr, uaddr, sizeof(addr)))
-		return -EFAULT;
+		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+			return -EFAULT;
 
-	ret = vgic_check_iorange(dev->kvm, its->vgic_v5_its_base, addr,
-				 SZ_64K, KVM_VGIC_V5_ITS_SIZE);
-	if (ret)
-		return ret;
+		ret = vgic_check_iorange(dev->kvm, its->vgic_v5_its_base,
+					 addr, SZ_64K, KVM_VGIC_V5_ITS_SIZE);
+		if (ret)
+			return ret;
+
+		return vgic_v5_register_its_iodev(dev->kvm, its, addr);
+	}
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		return vgic_v5_its_ctrl(dev->kvm, its, attr->attr);
+	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 reg;
+
+		if (get_user(reg, uaddr))
+			return -EFAULT;
+
+		return vgic_v5_its_attr_regs_access(dev, attr, &reg, true);
+	}
+	}
 
-	return vgic_v5_register_its_iodev(dev->kvm, its, addr);
+	return -ENXIO;
 }
 
 static int vgic_v5_its_get_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	struct vgic_v5_its *its = dev->private;
-	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
-	unsigned long type = (unsigned long)attr->attr;
-	u64 addr = its->vgic_v5_its_base;
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
+		struct vgic_v5_its *its = dev->private;
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		unsigned long type = (unsigned long)attr->attr;
+		u64 addr = its->vgic_v5_its_base;
 
-	if (attr->group != KVM_DEV_ARM_VGIC_GRP_ADDR)
-		return -ENXIO;
+		if (type != KVM_VGIC_V5_ADDR_TYPE_ITS)
+			return -ENODEV;
 
-	if (type != KVM_VGIC_V5_ADDR_TYPE_ITS)
-		return -ENODEV;
+		if (copy_to_user(uaddr, &addr, sizeof(addr)))
+			return -EFAULT;
 
-	if (copy_to_user(uaddr, &addr, sizeof(addr)))
-		return -EFAULT;
+		return 0;
+	}
+	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		u64 reg;
+		int ret;
 
-	return 0;
+		ret = vgic_v5_its_attr_regs_access(dev, attr, &reg, false);
+		if (ret)
+			return ret;
+
+		if (put_user(reg, uaddr))
+			return -EFAULT;
+
+		return 0;
+	}
+	}
+
+	return -ENXIO;
 }
 
 static int vgic_v5_its_has_attr(struct kvm_device *dev,
 				struct kvm_device_attr *attr)
 {
-	if (attr->group != KVM_DEV_ARM_VGIC_GRP_ADDR)
-		return -ENXIO;
-
-	switch (attr->attr) {
-	case KVM_VGIC_V5_ADDR_TYPE_ITS:
-		return 0;
-	default:
-		return -ENXIO;
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V5_ADDR_TYPE_ITS:
+			return 0;
+		}
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+		case KVM_DEV_ARM_ITS_CTRL_RESET:
+			return 0;
+		}
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS:
+		return vgic_v5_its_has_attr_regs(dev, attr);
 	}
+
+	return -ENXIO;
 }
 
 static struct kvm_device_ops kvm_arm_vgic_v5_its_ops = {
-- 
2.34.1

