Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523CC4FC32F
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165246; cv=none; b=p4A343yjA3EQgZhw2VYQIPTpaqwS8ktlmghmx4sr0je8BSVwTgMJk9zMKSE0r4eCHKIHlCZsBVlyzMTsGqK6rukpTlP+nk+B+Ec/aP5zL4qturTgRDJBIVjhkYR0Ghyus1CVbPIpIlHGLkYk5aw2v7wO3IKbzMFaMaj+GlMkaTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165246; c=relaxed/simple;
	bh=wzlUUy/hzNkfwlGEXbJ0cX5MwZYxV71cDzYyNU2X1pc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mmse+46/pTIWZ0g7e6QmD7/PApO2wuJH0JScQQ4fQQ3SCKHAmG9fbly6aHjUS1vDSFpgxGuArXthG5Q8RRUMm0ND7BdoKFU/W5VUDc93PHe+LJQL0OF/td/5sjK9JlVkt6UL5/OfKYK36NiFnjH/8hM0okhuQHROUO5B8hWUE8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=opQhxnqA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="opQhxnqA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63F04143D;
	Fri, 16 Oct 2026 08:40:41 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D9733F673;
	Fri, 16 Oct 2026 08:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165244; bh=wzlUUy/hzNkfwlGEXbJ0cX5MwZYxV71cDzYyNU2X1pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opQhxnqAffoZ/exhhnGfOjLryItATn49IntmNZbgYaNcV1+BajRDQ2UJGnDzyYEVW
	 xqvrC+I/uYX5D12pzrk1ghlA7J8HqVY5rnm3emHfUlsu9OS2vOiFFuoUhCi6micshk
	 AW+Zg6MVx8uBCOpXqdQFDI8wD2gFJa8xbLqvp+4M=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 07/21] arm64: Configure the GICv5 IRS
Date: Fri, 16 Oct 2026 16:39:25 +0100
Message-Id: <20261016153939.913764-8-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Place the IRS CONFIG and SETLPI frames in two 64 KiB regions below the
guest AXI area, and pass the IRS base to KVM through
KVM_VGIC_V5_ADDR_TYPE_IRS.

The GICv5 NR_IRQS attribute counts SPIs without the 32 SGI/PPI lines
included for earlier GICs. Use that count for GICv5 while retaining
the existing count for GICv2/v3. Allow zero-based GICv5 IRQ numbers
when setting the level through KVM_IRQ_LINE.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                  | 16 ++++++++++++++--
 arm64/include/kvm/kvm-arch.h |  8 ++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 23c68862..5be71ba1 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -18,6 +18,7 @@
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
+static u64 gicv5_irs_base;
 static u64 gic_msi_base;
 static u64 gic_msi_size = 0;
 static bool vgic_is_init = false;
@@ -183,6 +184,11 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		.attr	= KVM_VGIC_V3_ADDR_TYPE_REDIST,
 		.addr	= (u64)(unsigned long)&gic_redists_base,
 	};
+	struct kvm_device_attr gicv5_irs_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.attr	= KVM_VGIC_V5_ADDR_TYPE_IRS,
+		.addr	= (u64)(unsigned long)&gicv5_irs_base,
+	};
 
 	switch (type) {
 	case IRQCHIP_GICV2M:
@@ -218,6 +224,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
 	case IRQCHIP_GICV5:
+		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &gicv5_irs_attr);
 		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
@@ -312,6 +319,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 		gic_msi_base = gic_redists_base - gic_msi_size;
 		break;
 	case IRQCHIP_GICV5:
+		gicv5_irs_base = ARM_GICV5_IRS_BASE;
 		break;
 	default:
 		return -ENODEV;
@@ -333,8 +341,9 @@ static int gic__init_gic(struct kvm *kvm)
 	int ret;
 
 	int lines = irq__get_nr_allocated_lines();
-	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
 	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
+	u32 nr_irqs = max(ALIGN(lines, 32), 32);
+
 	struct kvm_device_attr nr_irqs_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 		.addr	= (u64)(unsigned long)&nr_irqs,
@@ -348,6 +357,9 @@ static int gic__init_gic(struct kvm *kvm)
 		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
 	};
 
+	if (!gic__is_v5())
+		nr_irqs += GIC_SPI_IRQ_BASE;
+
 	/*
 	 * If we didn't use the KVM_CREATE_DEVICE method, KVM will
 	 * give us some default number of interrupts. The GIC initialization
@@ -483,7 +495,7 @@ void kvm__irq_line(struct kvm *kvm, int irq, int level)
 		.level	= !!level,
 	};
 
-	if (irq < GIC_SPI_IRQ_BASE || irq > GIC_MAX_IRQ)
+	if (!gic__is_v5() && (irq < GIC_SPI_IRQ_BASE || irq > GIC_MAX_IRQ))
 		pr_warning("Ignoring invalid GIC IRQ %d", irq);
 	else if (ioctl(kvm->vm_fd, KVM_IRQ_LINE, &irq_level) < 0)
 		pr_warning("Could not KVM_IRQ_LINE for irq %d", irq);
diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index e7dd5269..94140364 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -57,6 +57,14 @@
 #define ARM_GIC_CPUI_SIZE	0x20000
 
 
+/* GICv5 IRS CONFIG and SETLPI frames occupy the end of the MMIO area. */
+#define ARM_GICV5_IRS_BASE		(ARM_AXI_AREA - ARM_GICV5_IRS_SIZE)
+#define ARM_GICV5_IRS_SIZE		(ARM_GICV5_IRS_CONFIG_SIZE + ARM_GICV5_IRS_SETLPI_SIZE)
+#define ARM_GICV5_IRS_CONFIG_BASE	ARM_GICV5_IRS_BASE
+#define ARM_GICV5_IRS_CONFIG_SIZE	0x10000
+#define ARM_GICV5_IRS_SETLPI_BASE	(ARM_GICV5_IRS_CONFIG_BASE + ARM_GICV5_IRS_CONFIG_SIZE)
+#define ARM_GICV5_IRS_SETLPI_SIZE	0x10000
+
 #define KVM_PCI_CFG_AREA	ARM_AXI_AREA
 #define ARM_PCI_CFG_SIZE	(1ULL << 28)
 #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
-- 
2.34.1

