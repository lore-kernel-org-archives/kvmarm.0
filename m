Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798949;
	b=VUzfOhPFelGQpkLWYstcAZgseTX22czuQJT0KFd34fQJjo7ewUeYM+6rq/Jvds/N8TyZ
	 4tZsCzw3XocyT+8y6xgMgpbBg70KzUfdgDFNdzZz8VBN9+fXBk4FwbtBCeYmuvt6qbjnp
	 AvEc62KMF4jMxYiai9EmivW9k0qWukkSDl/oNI/11nGHJ98ZZmliBtElVwX+0FE2f407u
	 d2ZLTqJm32KrJKuL4pQGDtVUGBPqL3CBD50rv5RqFVqL44wMlY4MmywDDdyZM+aT/4V8b
	 M0bu+UHXZKQ7mwZlVrHLRnqEVjHRKKY5nq0uP3+0+RzGEJO2+RdAWwSil02cL6UOPFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798949;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sC0vZ3vIg99CRo72x4DCjhI+43k5ZjUu074ixaFlVY4=;
	b=KgQkb7r2E5whCgrb2R4jfl4NAtFDx9gPXHlCipOB20t1V+2Pg7uBqcobimuYzEetY7Ze
	 Aq/RwKflK196/m8cpj2SOmRqM5jBkQJayh9BNYavBV0sNwSS/a7sTzGgGWzsILFAbVBDj
	 pH7GcnSSryGxhGhFs0nLm/wT7AY+0//kduHB8Lsa3k/Jju0Dr+HIGioiVOiQapDPqfOTU
	 AKN4Y1SDlIclVoUcHrib8NMZ/ULkNC/ndMegvPblDmQOiSp13dR8slaOmDC1+RIr/zt+N
	 rCH3/WxkBmUrMZvIRO2zhdUQb4xesvuCpRHkWMsnL4q+kAYpvotaGtp5LDBu6rCDc9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KdM6WM8p;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2761606A32C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2761606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KdM6WM8p
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 899601575;
	Fri, 27 Nov 2026 09:02:25 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 203AA3F632;
	Fri, 27 Nov 2026 09:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798948; bh=wBm8lCZfr5+Ejw6BMDeWptncDljhvRq8wuGdN/WW4qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdM6WM8pzcWXCYoNa9cz4/68ERLqcEV8yaQSWtxk/JMGvGR8JbGP5CeT5YitxaYWc
	 yyFg2fXpEQyP3pc1RzdgZBEaFoM1qiyfQsrMFOLJ2BCUrUVjXg+R+vaeLcJUSJlI/5
	 EBGXhuPDbsqd44FWusyhXRHjZ4uA1BtOL4a+IGzM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 09/23] arm64: Configure the GICv5 IRS
Date: Fri, 27 Nov 2026 17:01:31 +0000
Message-Id: <20261127170145.4138182-10-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127170145.4138182-1-sascha.bischoff@arm.com>
References: <20261127170145.4138182-1-sascha.bischoff@arm.com>
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

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
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
index 83e4cd29..d40dce35 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -59,6 +59,14 @@
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

