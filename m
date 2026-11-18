Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024712;
	b=qCew1atYobf3NvZwTEV7TOkx8XqrcKjheX+KIXgmyJbYCszTDffFhGwXY0pO95MNHt+e
	 qe0yGJ3OwiVx/arxL4R5EwMWMeeSOfNedkn84zukQk1bzGbclY+oGy0y7YAjzjtZOfHBj
	 xT2RkikB2od+/OltZicacm+tdwf/5WuIQHp1Yx/gO6XBUNdkaDO9pMAzllTVRxaGe/6eW
	 gue6FNXiWXonj2gebWifNZGXHY9S4ESEBAYNXNtsr7bzfOKKGNfylRrtl4BraaTUr5KZN
	 NwGV72A6X9SDVRu/It/Qdlx97Vg0J7jvt/5J5+lulLPHQkfshMVWm4OjxY92O8uOECA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024712;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xYBJKc8uj9UbnOrbdjNm+NrBYJVInTENicvCRdisVX8=;
	b=Wwy/ztY2HLvg5u8nrkMt/YkJ1k4J7Y5UHHt2Qte/upl1Xa/dsfkEz+Wd8pxRBbHcNBoc
	 YZbZyez3d3KJVH2bu061EpJqOOd9+eJNqJrTk4u5XzQ3wGOaEN1lKGBH9rH5+wEtDnR5n
	 DarjPFDtC0ItiMh6mWbwwU4rF3u0mMScfQ5DJO8zzSKIOw80HK+Q5ApTN9g7KROn17Yvf
	 Hx7eKYWIl2Ds6FvRoiS24S7Y6WlfbPUsMz1r9y050vrJfYKB/u4Y083zTPTDRdIaGSnC/
	 fg7pCQlmR0yJPx4sTN8lTba2vq8KRNjDJB0OxeAd36v2DVJ6ciUo0OG//k+1NaZ+Exw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IfP6XB5M;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399E8606A32C
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 399E8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IfP6XB5M
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91AA61477;
	Wed, 18 Nov 2026 09:58:28 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CF083FA7A;
	Wed, 18 Nov 2026 09:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024711; bh=KTOtM25gfHZzK97uWsalaknun0VTCTwSlco+esAr2o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfP6XB5M/qDjqFJBKihP4hyFvz4g1W6BXyvBv5oyJN6o0ZiOUQ+w9VjugzR0QzYYA
	 ycQcQi5DrZ/J/nDpie+ZzOJdgbzfFHlR9Z1f/LS4QlZD0gM90UXmCdsQ2uMAjSpfw1
	 wGICrYN7wk6VwwX5kg1BpQayyIdGwOLUiKM/Kgiw=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 06/23] arm64: Configure GIC interrupt bases
Date: Wed, 18 Nov 2026 17:57:38 +0000
Message-Id: <20261118175755.1946977-7-sascha.bischoff@arm.com>
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

Record the SPI and PPI bases for the selected irqchip and expose getters
to code that does not receive the irqchip type. Configure the bases
after the GIC device and MSI frame have been created.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 48 +++++++++++++++++++++++++++++++++++++++++
 arm64/include/kvm/gic.h |  4 ++++
 2 files changed, 52 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 51a32159..df5689a7 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -21,6 +21,18 @@ static u64 gic_redists_size;
 static u64 gic_msi_base;
 static u64 gic_msi_size = 0;
 static bool vgic_is_init = false;
+static int gic_spi_base = GIC_SPI_IRQ_BASE;
+static int gic_ppi_base = GIC_PPI_IRQ_BASE;
+
+int gic__get_spi_base(void)
+{
+	return gic_spi_base;
+}
+
+int gic__get_ppi_base(void)
+{
+	return gic_ppi_base;
+}
 
 struct kvm_irqfd_line {
 	unsigned int		gsi;
@@ -211,6 +223,34 @@ static int gic__set_dist(enum irqchip_type type)
 	}
 }
 
+static int gic__set_spi(enum irqchip_type type)
+{
+	switch (type) {
+	case IRQCHIP_GICV5:
+		gic_spi_base = GICV5_SPI_IRQ_BASE;
+		break;
+	default:
+		gic_spi_base = GIC_SPI_IRQ_BASE;
+		break;
+	}
+
+	return 0;
+}
+
+static int gic__set_ppi(enum irqchip_type type)
+{
+	switch (type) {
+	case IRQCHIP_GICV5:
+		gic_ppi_base = GICV5_PPI_IRQ_BASE;
+		break;
+	default:
+		gic_ppi_base = GIC_PPI_IRQ_BASE;
+		break;
+	}
+
+	return 0;
+}
+
 static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 {
 	int err;
@@ -256,6 +296,14 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	if (err)
 		goto out_err;
 
+	err = gic__set_spi(type);
+	if (err)
+		goto out_err;
+
+	err = gic__set_ppi(type);
+	if (err)
+		goto out_err;
+
 	return 0;
 
 out_err:
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 630f0bbd..c4f78cde 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -4,6 +4,8 @@
 #define GIC_SGI_IRQ_BASE		0
 #define GIC_PPI_IRQ_BASE		16
 #define GIC_SPI_IRQ_BASE		32
+#define GICV5_PPI_IRQ_BASE		0
+#define GICV5_SPI_IRQ_BASE		0
 
 #define GIC_FDT_IRQ_NUM_CELLS		3
 
@@ -34,6 +36,8 @@ enum irqchip_type {
 
 struct kvm;
 
+int gic__get_spi_base(void);
+int gic__get_ppi_base(void);
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
-- 
2.34.1

