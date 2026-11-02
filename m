Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655299;
	b=MTQPOJzyVhApGFrjb3UJrEB2z2Gc8fFEC4gb+FKB3UfRuqxiRwBLJkrOMQN/fTjto1eb
	 rJbVfMZJgdn2dkKyAQjmpSo15RwNjmiEJiP6BioYSp6bQGjtuZoCr/gHGi7AyMuY6zNWp
	 Ym84gHQa/6oejOJD23W3CQUActi7Y8Q2IYlDC6UL+5mQLUjzJI1TDWfst6A5z4lwLoXhM
	 f9MQnpUoxjTMx0V4EE6y9PMTjoYHwcsEgrVSoe7/NIZhV7IXKLeIsH1hjqRGTO7nrK8hi
	 nKmoBW+LDKTXYdJEsZxAbCpCHseRKIlSHH19jR9qkrECT0QkccS3/GgJLFHhdKPtu0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655299;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jWFZfIGDRf0fKWtuCdaud4FlpvouwceRqY1TJ9QB6Cg=;
	b=gpmBrOM0idTOlCVzyEa4DwiY6HO8IshxQar6OKfxHW2cQL6RpzuRU/dpvqnXpPno0Raq
	 Cq6/SuE5I645rPlBMPme+ts4ta/cfoZEpME5TGtN2Ekkwe6fk8GkcdZwakNus03+N4zYi
	 NwrXOxJMfjvZJbOFg8uNOfrwUtIgDLNWAsSd8/4pLcdDElZWwACOoPKLGjYM8Tt4onTjD
	 dJyfDe0sWbzdAb9k8t2YKOgsJfQ6cWggG/+fPMPBk7pyq24SCXWZjuaDznaGV/NIatD/U
	 95Tgmj+yJuckyyZF94PwXCVZoED0a8molSSC0zGAU3gW7BUdPbl6Tjd6TqSDD9RUIDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=STR8W285;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231A5606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 231A5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=STR8W285
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90B5F1595;
	Mon,  2 Nov 2026 13:34:55 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D9DC3F673;
	Mon,  2 Nov 2026 13:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655298; bh=DGkRce01zRxaXhojypT4+ym7BcUg9v6PPZ177l6P5Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STR8W285fRnga1nQ/vVLxwJQb+E9RJFqvV7AownN6wZcYdbSk31QV1ECuhRxh3F/n
	 hF1HN8PQkC+T++QvuseWzLrpiC8tJJInXw5dB1JFl9L8fWTUXPbzJ8aTmOGp5CUmJJ
	 07pBVOBy+LZE7sRd6JOURvcSEFuDHXWGbOcVaKHc=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 09/23] arm64: Configure the GICv5 IRS
Date: Mon,  2 Nov 2026 21:33:59 +0000
Message-Id: <20261102213413.4136118-10-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102213413.4136118-1-sascha.bischoff@arm.com>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
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
 arm64/gic.c                  | 31 ++++++++++++++++++++++++++++---
 arm64/include/kvm/kvm-arch.h |  8 ++++++++
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 58644036..613813f6 100644
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
@@ -191,7 +192,6 @@ static int gic__set_redist(enum irqchip_type type)
 		.attr	= KVM_VGIC_V3_ADDR_TYPE_REDIST,
 		.addr	= (u64)(unsigned long)&gic_redists_base,
 	};
-
 	switch (type) {
 	case IRQCHIP_GICV3:
 	case IRQCHIP_GICV3_ITS:
@@ -201,6 +201,22 @@ static int gic__set_redist(enum irqchip_type type)
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
@@ -291,6 +307,10 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	if (err)
 		goto out_err;
 
+	err = gic__set_irs(type);
+	if (err)
+		goto out_err;
+
 	err = gic__set_dist(type);
 	if (err)
 		goto out_err;
@@ -376,6 +396,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 		gic_msi_base = gic_redists_base - gic_msi_size;
 		break;
 	case IRQCHIP_GICV5:
+		gicv5_irs_base = ARM_GICV5_IRS_BASE;
 		break;
 	default:
 		return -ENODEV;
@@ -397,8 +418,9 @@ static int gic__init_gic(struct kvm *kvm)
 	int ret;
 
 	int lines = irq__get_nr_allocated_lines();
-	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
 	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
+	u32 nr_irqs = max(ALIGN(lines, 32), 32);
+
 	struct kvm_device_attr nr_irqs_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 		.addr	= (u64)(unsigned long)&nr_irqs,
@@ -412,6 +434,8 @@ static int gic__init_gic(struct kvm *kvm)
 		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
 	};
 
+	nr_irqs += gic__get_spi_base();
+
 	/*
 	 * If we didn't use the KVM_CREATE_DEVICE method, KVM will
 	 * give us some default number of interrupts. The GIC initialization
@@ -540,12 +564,13 @@ u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
 {
+	int spi_base = gic__get_spi_base();
 	struct kvm_irq_level irq_level = {
 		.irq	= KVM_IRQCHIP_IRQ(irq),
 		.level	= !!level,
 	};
 
-	if (irq < GIC_SPI_IRQ_BASE || irq > GIC_MAX_IRQ)
+	if (spi_base && (irq < spi_base || irq > GIC_MAX_IRQ))
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

