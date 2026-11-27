Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798936;
	b=eTH8yG1s3MeYJmCOAkpBS4niCg86LZYTJWvrmFMWdrbNEfk0UGr2oD+Q4JfW+M27da2U
	 LHK0zeh/xlVmraUV/VUBle8UVACHY2i96bxQ3Ah1YK2YIR3gL1lX0TZIS+0OX2+vJxzKj
	 S47Ng92v/W5RNkDrvI+PBgjK1SVyYiH2csbBUvM1NyatQ+U1lVrM9vwveMqroTnFsZTO9
	 j+TZ5nV+xTrRrgEF8oauIkApkOt7V1Ew+aybH3LMktOtoajaH1NvXv+4IBLbMVFyTeieW
	 NwIypxNKolIZ9rTEEroHxhALdQ8WsajkA4vvz3rmtazSmMBEQ8OzVNA9Zuwptx97Lyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798936;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xYBJKc8uj9UbnOrbdjNm+NrBYJVInTENicvCRdisVX8=;
	b=EA2+vfJIUzx209f5RvbnZSMedBbWSFWxaJKmQRUMl6xx7SsaQuX9yInNlZeI3G0NVm/8
	 tbCcoiyC/eRys+IxZ2sPTopqYZFKH729fRIlD0OUSWoXLJ8KNaAOToj10X2oQSX4+mE/z
	 RcYIjfZ9hHC4tKJKz7JXMj/Fx/CpzGiXje14cpX8r7C77xElwWAVJT1M3b7eN5OVoG/07
	 UUPYFRnw75b41B+uOgsDIvYoz06uZv6KCvvWdXGPCDdcDJbo/AtNBGNaL1xC53U1+kx4X
	 CR+GLqeOvAIOfviZl0DsnJjouv0I0s+xsyr6EmeEmSpKJ594bFHbAkJjN1swvAwu8Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=azVpwX1H;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BBB6606A32C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BBB6606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=azVpwX1H
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D92D169E;
	Fri, 27 Nov 2026 09:02:13 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D14FB3F632;
	Fri, 27 Nov 2026 09:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798935; bh=KTOtM25gfHZzK97uWsalaknun0VTCTwSlco+esAr2o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azVpwX1HJiGRtbgZam/fq8wSmVSxicgsPF4cWonjU927EHPjbEaDhltQOOwCCTJPN
	 QefEhdTmB4EZCOrsTBZqzidfYq0X2YuTjZXYRrVwMDWkNurH3Rs9XpCDl32lWb7Pkx
	 MiaWvaYyYr9ppo+gK/MEhNCtd4NaPpeDziN+r7tQ=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 06/23] arm64: Configure GIC interrupt bases
Date: Fri, 27 Nov 2026 17:01:28 +0000
Message-Id: <20261127170145.4138182-7-sascha.bischoff@arm.com>
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

