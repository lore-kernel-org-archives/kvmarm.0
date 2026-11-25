Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619721;
	b=bWxvVgTk8ayb1wTcVXwb7x7+P2MqKe+NMmGq6adjiyutJeW5jbPJz3LPsBkHT8Bp3Gc6
	 r6ltEYjAcAP0iQFEGDvl0QqW0YiSUTxPaFwcUwCQP5GmbD7Z556DS6K0Owqf7QrrtjW7T
	 /rCHTGIbphP2l3Yo0yL6JdfY8fNRpJrfFswDzocW4ircVp08n1GN1fhXnm4lPOtdCTiYt
	 bDVcTqYM73O2Sy5wW7jCMz48vvHu9srh1z330aKU0fAVXK0RqdrKVOyWAC5UOocfNvKpt
	 3sV8qP1amdUz3QYECVeRzXRMI6DSy5Yv3/UAZRDRJtiz9fHrDUcad1JSlJnj3D5OiNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619721;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YCWVVCabftB+Yi80xTw17tKxeLx8/T1IKJX3Yhyl0tQ=;
	b=xQuuZSR319sgfC5ilZSasIXlPKZgLQORGhwlP5y4y2fe7T1IA4m1uCInbuz47JdpkB7H
	 6w4oIax0C/R2O3h1IuraXZgfTDZs50XGmUU0toOr1EH14snpqVTtOt4JEWFQT+sEt1y/b
	 ZLmnPdiVTKTZGjVz8+pE6AYAn/9YVmmwDikNSEw3hqkBSn6DNaf63UyRq45ou9qH0OmLl
	 Zxd09ROetsIhyB0ni6Q+BE9JpdM5QhMZP+BcYbqF3bsg1r3URl0EE37ktvHHL6X1v0emY
	 p4sBoLIjl9gCVoREDO+EcnoUh9NRpIPUISJTg9g7Cwd/At7XVuvC3D1ZvKZToY+SJqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LIEVxnTs;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF6B5606A334
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:15:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF6B5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LIEVxnTs
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88DF91BB2;
	Wed, 25 Nov 2026 07:15:17 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D7B63F86F;
	Wed, 25 Nov 2026 07:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619720; bh=BnuncrqkYpUSInIZjQHckFzEvWXEQmQ7j6ZK/Q1Cjj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIEVxnTs0F81+CbHG7J60JDT5BJZfwz6zcWSuBhGje90EOsK/MyQv5VgDSlG44mxl
	 MB2k9YUsA8Lfoik/GUzPLQgsG7EtX3oCBnb7I76ThoDIIlRKGxWXIdAdjs1EqNyGVA
	 rTExwE6RiGSzYIFn/PTefTMvyyoc8R74ylVq7Z5A=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 20/23] arm64: Add GICv5 ITS device support
Date: Wed, 25 Nov 2026 15:13:53 +0000
Message-Id: <20261125151356.2875108-21-sascha.bischoff@arm.com>
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

Allow the GICv5 ITS irqchip to create a separate KVM ITS device and
place its CONFIG and TRANSLATE frames immediately below the IRS.
Reuse the ITS creation helper for GICv3 and GICv5, selecting the
device and address types for each model.

At this stage, --irqchip=gicv5-its is not yet exposed, and automatic
irqchip selection starts with GICv5.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                  | 24 ++++++++++++++++++------
 arm64/include/kvm/gic.h      |  1 +
 arm64/include/kvm/kvm-arch.h |  8 ++++++++
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index c1408502..2a59ca2e 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -51,6 +51,7 @@ int gic__encode_ppi_irq(enum irqchip_type type, int irq)
 {
 	switch (type) {
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		return irq | (GICV5_IRQ_TYPE_PPI << GICV5_IRQ_TYPE_SHIFT);
 	default:
 		return irq;
@@ -136,15 +137,15 @@ static int irq__routing_init(struct kvm *kvm)
 	return 0;
 }
 
-static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
+static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr, const bool v5)
 {
 	struct kvm_create_device its_device = {
-		.type = KVM_DEV_TYPE_ARM_VGIC_ITS,
+		.type = v5 ? KVM_DEV_TYPE_ARM_VGIC_V5_ITS : KVM_DEV_TYPE_ARM_VGIC_ITS,
 		.flags	= 0,
 	};
 	struct kvm_device_attr its_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
-		.attr	= KVM_VGIC_ITS_ADDR_TYPE,
+		.attr	= v5 ? KVM_VGIC_V5_ADDR_TYPE_ITS : KVM_VGIC_ITS_ADDR_TYPE,
 		.addr	= (u64)(unsigned long)&its_frame_addr,
 	};
 	struct kvm_device_attr its_init_attr = {
@@ -155,8 +156,9 @@ static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
 
 	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &its_device);
 	if (err) {
-		pr_err("GICv3 ITS requested, but kernel does not support it.");
-		pr_err("Try --irqchip=gicv3 instead");
+		pr_err("GICv%c ITS requested, but kernel does not support it.",
+			v5 ? '5' : '3');
+		pr_err("Try --irqchip=gicv%c instead", v5 ? '5' : '3');
 		return err;
 	}
 
@@ -185,7 +187,9 @@ static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV2M:
 		return gic__create_gicv2m_frame(kvm, gic_msi_base);
 	case IRQCHIP_GICV3_ITS:
-		return gic__create_its_frame(kvm, gic_msi_base);
+		return gic__create_its_frame(kvm, gic_msi_base, false);
+	case IRQCHIP_GICV5_ITS:
+		return gic__create_its_frame(kvm, gic_msi_base, true);
 	default:	/* No MSI frame needed */
 		return 0;
 	}
@@ -236,6 +240,7 @@ static int gic__set_irs(enum irqchip_type type)
 
 	switch (type) {
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &irs_attr);
 	default:	/* No IRS needed */
 		return 0;
@@ -271,6 +276,7 @@ static int gic__set_spi(enum irqchip_type type)
 
 	switch (type) {
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		spi_base = GICV5_SPI_IRQ_BASE;
 		fdt_type = GICV5_FDT_IRQ_TYPE_SPI;
 		break;
@@ -295,6 +301,7 @@ static int gic__set_ppi(enum irqchip_type type)
 {
 	switch (type) {
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		gic_ppi_base = GICV5_PPI_IRQ_BASE;
 		gic_ppi_fdt_type = GICV5_FDT_IRQ_TYPE_PPI;
 		break;
@@ -323,6 +330,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV3_ITS:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		break;
+	case IRQCHIP_GICV5_ITS:
 	case IRQCHIP_GICV5:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V5;
 		break;
@@ -432,6 +440,10 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
 		gic_msi_base = gic_redists_base - gic_msi_size;
 		break;
+	case IRQCHIP_GICV5_ITS:
+		gic_msi_base = ARM_GICV5_ITS_BASE;
+		gic_msi_size = ARM_GICV5_ITS_SIZE;
+		/* fall through */
 	case IRQCHIP_GICV5:
 		gicv5_irs_base = ARM_GICV5_IRS_BASE;
 		break;
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 9f1a3a25..0a5c70a1 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -38,6 +38,7 @@ enum irqchip_type {
 	IRQCHIP_GICV3,
 	IRQCHIP_GICV3_ITS,
 	IRQCHIP_GICV5,
+	IRQCHIP_GICV5_ITS,
 };
 
 struct kvm;
diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index 94140364..3b0ffead 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -65,6 +65,14 @@
 #define ARM_GICV5_IRS_SETLPI_BASE	(ARM_GICV5_IRS_CONFIG_BASE + ARM_GICV5_IRS_CONFIG_SIZE)
 #define ARM_GICV5_IRS_SETLPI_SIZE	0x10000
 
+/* GICv5 ITS CONFIG and TRANSLATE frames precede the IRS frames. */
+#define ARM_GICV5_ITS_BASE		(ARM_GICV5_IRS_BASE - ARM_GICV5_ITS_SIZE)
+#define ARM_GICV5_ITS_SIZE		(ARM_GICV5_ITS_CONFIG_SIZE + ARM_GICV5_ITS_TRANSL_SIZE)
+#define ARM_GICV5_ITS_CONFIG_BASE	ARM_GICV5_ITS_BASE
+#define ARM_GICV5_ITS_CONFIG_SIZE	0x10000
+#define ARM_GICV5_ITS_TRANSL_BASE	(ARM_GICV5_ITS_CONFIG_BASE + ARM_GICV5_ITS_CONFIG_SIZE)
+#define ARM_GICV5_ITS_TRANSL_SIZE	0x10000
+
 #define KVM_PCI_CFG_AREA	ARM_AXI_AREA
 #define ARM_PCI_CFG_SIZE	(1ULL << 28)
 #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
-- 
2.34.1

