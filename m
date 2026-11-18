Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024724;
	b=krw/O5cNWPoCE0XNBBY1oEL3PNN6cCHVPpLTK/PeqdyBsI4WHpo3EUqv/FodZkUxOtKr
	 3WazRHulspkh5cPqugUy2/OD3T9HpXnZPkSpq+LVBOxoUuKAlJk6CsrgKePgm/65Obg9o
	 BNVnUHc1Wtsj9ODg+q6G71SIcPmWQiQRf322XLwd4DXRUoG5Qzd5TVR541rcne6FDCjxC
	 8KgdM7M9rDEpmGgPqJOxWd/Wq60APGmqQGf3TiC5zgyiX3i7RyE4jga/WLmQ7MB3aDkXo
	 f7QJI7B7Ap8RWlcVwS46EA3XijEbDBkA7+j10HjJWw1fLKQ2eeMG6sSNtG3j79ig9Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024724;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=N9xNDO0PhBWdXvHdOUZTLAjMWunNvxp66t9vTchSEB4=;
	b=toerbVUyoL/+XO2iBe1C7ROi99W9eHJCpG7T2dhTw1G/Vmc/7sUXFt1IxijKF5IeQk83
	 mnMViJrGQgRClzTq2QUcNaz2URiHOjr6kjQ+zDDv6FtSzeyFGFOM9RIiV9hWd8aEWkOK9
	 CZv2SRV/LBSpOlkS1adgJ3l64mxXQ06NU4GfADrN9lnRhiUqRJ6XZj4Q6HTuKy1wGN8QH
	 MBNqX9dbsXGGH4mZoy7E7z/0pRfolsG1MHpbej6Y3gGr4bZZQ5biGZXI/5EcatKH5n+lM
	 lqJk9zxcK9sJXRjr7KCOnR3ZyAZYFFlA4Qqfdhd7vQvPn9exMBe4cojw/lIHsCbxLgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cKtm1ArH;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27195606A325
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27195606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cKtm1ArH
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0C041477;
	Wed, 18 Nov 2026 09:58:40 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EF433F632;
	Wed, 18 Nov 2026 09:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024723; bh=wegM1+7bEU0wpnoqRyJRHKUz5llYxvyvAfQO040SjVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKtm1ArHiCyG825F1m55LUX8ZvFKOe7LVdQx9wQNjncjNybZrcyl3dkEEVi0gMMhO
	 E4sbddSDhw142MIUH8PvHz06gURAiGumzKZjUbtJQssrj4y2SBogteKKs5uRSbR3wI
	 Mq0DalXJuxwp02Td+KHFyF5qO8uykJSHqCncU2Vk=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 09/23] arm64: Configure the GICv5 IRS
Date: Wed, 18 Nov 2026 17:57:41 +0000
Message-Id: <20261118175755.1946977-10-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Place the IRS CONFIG and SETLPI frames in two 64 KiB regions below the
guest AXI area, and pass the IRS base to KVM through
KVM_VGIC_V5_ADDR_TYPE_IRS.

The GICv5 NR_IRQS attribute counts SPIs without the 32 SGI/PPI lines
included for earlier GICs. Use that count for GICv5 while retaining
the existing count for GICv2/v3. Allow zero-based GICv5 IRQ numbers
when setting the level through KVM_IRQ_LINE.

Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                  | 30 ++++++++++++++++++++++++++++--
 arm64/include/kvm/kvm-arch.h |  8 ++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 58644036..5034b034 100644
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
@@ -201,6 +202,22 @@ static int gic__set_redist(enum irqchip_type type)
 	}
 }
 
+static int gic__set_irs(enum irqchip_type type)
+{
+	struct kvm_device_attr irs_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.attr	= KVM_VGIC_V5_ADDR_TYPE_IRS,
+		.addr	= (u64)(unsigned long)&gicv5_irs_base,
+	};
+
+	switch (type) {
+	case IRQCHIP_GICV5:
+		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &irs_attr);
+	default:	/* No IRS needed */
+		return 0;
+	}
+}
+
 static int gic__set_dist(enum irqchip_type type)
 {
 	u64 dist_addr = ARM_GIC_DIST_BASE;
@@ -291,6 +308,10 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	if (err)
 		goto out_err;
 
+	err = gic__set_irs(type);
+	if (err)
+		goto out_err;
+
 	err = gic__set_dist(type);
 	if (err)
 		goto out_err;
@@ -376,6 +397,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 		gic_msi_base = gic_redists_base - gic_msi_size;
 		break;
 	case IRQCHIP_GICV5:
+		gicv5_irs_base = ARM_GICV5_IRS_BASE;
 		break;
 	default:
 		return -ENODEV;
@@ -397,8 +419,9 @@ static int gic__init_gic(struct kvm *kvm)
 	int ret;
 
 	int lines = irq__get_nr_allocated_lines();
-	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
 	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
+	u32 nr_irqs = max(ALIGN(lines, 32), 32);
+
 	struct kvm_device_attr nr_irqs_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 		.addr	= (u64)(unsigned long)&nr_irqs,
@@ -412,6 +435,8 @@ static int gic__init_gic(struct kvm *kvm)
 		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
 	};
 
+	nr_irqs += gic__get_spi_base();
+
 	/*
 	 * If we didn't use the KVM_CREATE_DEVICE method, KVM will
 	 * give us some default number of interrupts. The GIC initialization
@@ -540,12 +565,13 @@ u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
 {
+	int spi_base = gic__get_spi_base();
 	struct kvm_irq_level irq_level = {
 		.irq	= KVM_IRQCHIP_IRQ(irq),
 		.level	= !!level,
 	};
 
-	if (irq < GIC_SPI_IRQ_BASE || irq > GIC_MAX_IRQ)
+	if (irq < spi_base || irq > GIC_MAX_IRQ)
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

