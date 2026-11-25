Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619667;
	b=c2WX/6EhWWLyYL0EDBkEof10anapEHTn0DIGcq0texILzKV0tcv6jkGLjlcYy1QFJG+O
	 0V5zMvh550N+Mwzp1KojXAZ8rbEPr3v7/VtpBCjoQARQG8ZEu3iuUAH8iKYW0Roj6z5VS
	 nZFRkQjmtnFMxygAEj222SmVKFz9vDFoVeOn+BrZb+RyymFKuPvFBXBN5TShYIoC7q1zo
	 8GWP0MInexVCcT/D47RA4GQewQi4fhZt7ZR9CJAKhO/sqEHsTwhEAujM+jDP+awny8pmJ
	 LeAyXe1HGQYwGLL7rArH+AoR/hW1hw66A/R1kd4+7mlw8rBq9psQjKJ1CVlwS1ykQgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619667;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xYBJKc8uj9UbnOrbdjNm+NrBYJVInTENicvCRdisVX8=;
	b=Dt6vTQiXbWfs05eS6/kbHfeFNsYXExCsdYMpTAe81ELq6gxIY8l/SnV/aTGABiQPzG2D
	 lQG442piKbHyTv7OVTmU0B9ld53DOUcp2q1LV7hOoGV0tAiagGnl/LDA4jh5jZy2psRaQ
	 mHSCpOt3J8nRfMVtSf399iTh90cG6WgmETHMCFQZjVEABZ8EUHIR3QKzE0rwnnvMMrpNx
	 xv+w70J5UPvthmkkdNKUwR5jP1rHC+0c/BVbk4SqpNTQrNYOJ8+WLGNPMld6oZtPYQA1c
	 KvRJhxb9OsA0mJmDBoAVJdgqBJ8dt1VxfqeE8m6emQEjbuUQlYubIXVb626OOG5xdHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Veqm+YQB;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19AC606A683
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:14:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A19AC606A683
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Veqm+YQB
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C1711596;
	Wed, 25 Nov 2026 07:14:23 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 166293F86F;
	Wed, 25 Nov 2026 07:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619666; bh=KTOtM25gfHZzK97uWsalaknun0VTCTwSlco+esAr2o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Veqm+YQBSeodl+pK73ZlzVaGxIqjNmG+mEg5M8l1nuo0MOHnuhFD07GfpfvHnHiBG
	 uWnSSADEy3YHH8iqCcWnqONeg3Vvx1byhBqGe4M5Zo/QKPE+pFE0iN0PhlKU3R7Y/R
	 Bt7Mfq3w2y5SVEyZ5NS52iYMwBFFkpiEMXm+YmC4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 06/23] arm64: Configure GIC interrupt bases
Date: Wed, 25 Nov 2026 15:13:39 +0000
Message-Id: <20261125151356.2875108-7-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
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

