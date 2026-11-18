Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024728;
	b=CYAnvWNgJbR2Nrvmzbgx8QZ+To6dB1Yd6T1hjxgVG5X6yYvAk2F3AGzghlsqxGikztQC
	 4NFzfEIAt2yB9xEcpvwc2kjYxalRrxNMUZ0iJ7o2tHkzFdUh621c5O4Okgo3bb95YcW87
	 tgicP809NOOZbbMUHhaWfsEOfJXw4UmhkKuQlhtTFlRPN3+OyL2S4svhglyY1GF9f2kX4
	 9mbbPm2+iRa+gqoPQThRr2Eym4WZKPH0LvMtGtH/8e5tgtYKit5Z1+ec9Lrza2ZP2oMFE
	 P0oZi/D7M5ivkp+czJOByu2QKw5bITu1Qn38vNRMPZkxHefS5w/qQewy14t8h4NHcbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024728;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ixRQatk0cnDrDxprXqJ6lkU0b/6YAnZFD6FR96rHhNg=;
	b=x5VQTh69jKM8UMwHJukCkeBbLbYUnBVbz1IF+0DNTrHajnQUSTcb92zT9eIvGHCsmAzb
	 Tqf/O7pngt4jhZ4BDvsghj2LjfoI7zmtjyYzJue7hx3L0FPbsgs+GVkHEUvnHaMNt25K6
	 M5XT+g+f0OrfVX1DhcmHlZm5R1z2CQyKOMttdbVjuh8MQ7mw64M1Q9rWAwz8AsrpdgItU
	 Id5PNpqX70/wu94abjTq9mbEGQNtZXbaKrA1yI7LtepKrwrwYB38OR4QXH96mLf9Qs5WX
	 xhmUcMyA7GICK5YMmMbL8TpjRa/WEiaeL33DSZsOlZ1U63KF+VNVtIfRFS8hKCtcYLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WKbRsg8R;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15989606A325
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15989606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WKbRsg8R
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 708641477;
	Wed, 18 Nov 2026 09:58:44 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BF5B3F632;
	Wed, 18 Nov 2026 09:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024727; bh=OnVas4WDYKAVnROEy3UJlkCK4HQnWjf0mNLKZZt4yGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKbRsg8R7w66WorqC/mgrGqZcyirpxG38bwwN2yOnpTvO41Q9a9JHvo3ROLbiWtUU
	 1C7Nb3zSZGw6WsKVwyRcPMyBtD3Gw8W2z+N+VLOcn0L4x+4DMc6kQaeCnou+i926xq
	 wsK5jf98q1X1S4L9Bes7CqyjR7N1BqD66uAavbWE=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 10/23] arm64: Define GICv5 interrupt types
Date: Wed, 18 Nov 2026 17:57:42 +0000
Message-Id: <20261118175755.1946977-11-sascha.bischoff@arm.com>
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

