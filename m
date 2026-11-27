Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798953;
	b=evDTB/5NJhApdzmVbb9fvodg3VHjXyDyIjatCB4mewFOd1xCEXYf3XHZ7LINYZvHjMnf
	 j+wSobRfEWHzBQphH6PUjDWtk9y+AbTBVI16BeZF8P9p51tXB8/sE2ozMrgH2VZVyFI3f
	 spkpuX0BgQxmliXBv0zivrXyRTsNO3J6w/4vsg3O+I4VZgHeGKx21iFzHkltOZgfJ4k7a
	 FxXQ5/yGRZ4Ld+5952lvAuNFmZQCHJ/T/hRvq2t7tKD5tfIDKV8TN7eG+oePG/elf3ng6
	 q28BYoPwqTaeW+Rz0puC3y6RYXLdnrpgmFK5tFsQTqk0zJuEEg/dG713aCjmiJ1XJTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798953;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ixRQatk0cnDrDxprXqJ6lkU0b/6YAnZFD6FR96rHhNg=;
	b=V+cfZ4y0oE+OxNttxjaz9n0golbvx0j7sw++7/4AzOr5XxKp+KSeBvVsOWp7Mnk5pr5d
	 crwSUalzbA2zgpfBrQPUbl8uyz2WvFw3b1pMQN/Ro/VHcMHebsao5ZdsWsUtFJMp+fA4f
	 aOSXXYIMgvq0QGIzTaZUhlrTjvwOppx7gap8NxAlggwGEfDhMa+enDDJDdgMHiBLVRyyc
	 LACvVkp2xTOiJM+mv7tA4kkJchBL73CYi/F4kdAXlsEGTAVHDYfcUBDDoIJv6/eVMNmL/
	 HhuDNW6BtsfNd8gkxf2J8VHgP3jHty8+ke68bxwVFs2TQJ9Mn5IQnAAd/m8XTsm4xrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qVXjizsd;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50BF8606A688
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50BF8606A688
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qVXjizsd
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAB81169E;
	Fri, 27 Nov 2026 09:02:29 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B5F53F632;
	Fri, 27 Nov 2026 09:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798952; bh=OnVas4WDYKAVnROEy3UJlkCK4HQnWjf0mNLKZZt4yGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVXjizsdNO+Kwd0ripvJvSBXsenSOHD+1KBaUW+POgpdjEwAiYsRaUetOg9a39Rso
	 zt5nut2xYAP3zxaUacUIzB8ulVdhNIbWedFDl0yN1GccmvjrO7O/Ulnd7n3vCpPTPP
	 9DlXeoM9sCaei2G/RwcHXtO8cNHyCh7YWHuPMPEQ=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 10/23] arm64: Define GICv5 interrupt types
Date: Fri, 27 Nov 2026 17:01:32 +0000
Message-Id: <20261127170145.4138182-11-sascha.bischoff@arm.com>
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

Define the PPI and SPI type values used by GICv5 interrupt specifiers,
and the type-field shift used to construct a full GICv5 INTID for
KVM's PMU IRQ attribute. Give the FDT type values distinct names while
retaining the same numeric values.

Suggested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 42 +++++++++++++++++++++++++++++++++++++----
 arm64/include/kvm/gic.h |  9 +++++++++
 2 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 5034b034..83b034e3 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -24,6 +24,8 @@ static u64 gic_msi_size = 0;
 static bool vgic_is_init = false;
 static int gic_spi_base = GIC_SPI_IRQ_BASE;
 static int gic_ppi_base = GIC_PPI_IRQ_BASE;
+static int gic_spi_fdt_type = GIC_FDT_IRQ_TYPE_SPI;
+static int gic_ppi_fdt_type = GIC_FDT_IRQ_TYPE_PPI;
 
 int gic__get_spi_base(void)
 {
@@ -35,6 +37,26 @@ int gic__get_ppi_base(void)
 	return gic_ppi_base;
 }
 
+int gic__get_spi_fdt_type(void)
+{
+	return gic_spi_fdt_type;
+}
+
+int gic__get_ppi_fdt_type(void)
+{
+	return gic_ppi_fdt_type;
+}
+
+int gic__encode_ppi_irq(enum irqchip_type type, int irq)
+{
+	switch (type) {
+	case IRQCHIP_GICV5:
+		return irq | (GICV5_IRQ_TYPE_PPI << GICV5_IRQ_TYPE_SHIFT);
+	default:
+		return irq;
+	}
+}
+
 struct kvm_irqfd_line {
 	unsigned int		gsi;
 	int			trigger_fd;
@@ -242,18 +264,28 @@ static int gic__set_dist(enum irqchip_type type)
 
 static int gic__set_spi(enum irqchip_type type)
 {
+	int spi_base, fdt_type;
+	int err;
+
 	switch (type) {
 	case IRQCHIP_GICV5:
-		gic_spi_base = GICV5_SPI_IRQ_BASE;
+		spi_base = GICV5_SPI_IRQ_BASE;
+		fdt_type = GICV5_FDT_IRQ_TYPE_SPI;
 		break;
 	default:
-		gic_spi_base = GIC_SPI_IRQ_BASE;
+		spi_base = GIC_SPI_IRQ_BASE;
+		fdt_type = GIC_FDT_IRQ_TYPE_SPI;
 		break;
 	}
 
-	if (gic_spi_base == GICV5_SPI_IRQ_BASE)
-		return irq__init_irq_offset(gic_spi_base);
+	if (spi_base == GICV5_SPI_IRQ_BASE) {
+		err = irq__init_irq_offset(spi_base);
+		if (err)
+			return err;
+	}
 
+	gic_spi_base = spi_base;
+	gic_spi_fdt_type = fdt_type;
 	return 0;
 }
 
@@ -262,9 +294,11 @@ static int gic__set_ppi(enum irqchip_type type)
 	switch (type) {
 	case IRQCHIP_GICV5:
 		gic_ppi_base = GICV5_PPI_IRQ_BASE;
+		gic_ppi_fdt_type = GICV5_FDT_IRQ_TYPE_PPI;
 		break;
 	default:
 		gic_ppi_base = GIC_PPI_IRQ_BASE;
+		gic_ppi_fdt_type = GIC_FDT_IRQ_TYPE_PPI;
 		break;
 	}
 
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index c4f78cde..9f1a3a25 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -12,6 +12,12 @@
 #define GIC_FDT_IRQ_TYPE_SPI		0
 #define GIC_FDT_IRQ_TYPE_PPI		1
 
+#define GICV5_IRQ_TYPE_PPI		1
+#define GICV5_IRQ_TYPE_SPI		3
+#define GICV5_IRQ_TYPE_SHIFT		29
+#define GICV5_FDT_IRQ_TYPE_PPI		GICV5_IRQ_TYPE_PPI
+#define GICV5_FDT_IRQ_TYPE_SPI		GICV5_IRQ_TYPE_SPI
+
 #define GIC_FDT_IRQ_PPI_CPU_SHIFT	8
 #define GIC_FDT_IRQ_PPI_CPU_MASK	(0xff << GIC_FDT_IRQ_PPI_CPU_SHIFT)
 
@@ -38,6 +44,9 @@ struct kvm;
 
 int gic__get_spi_base(void);
 int gic__get_ppi_base(void);
+int gic__get_spi_fdt_type(void);
+int gic__get_ppi_fdt_type(void);
+int gic__encode_ppi_irq(enum irqchip_type type, int irq);
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
-- 
2.34.1

