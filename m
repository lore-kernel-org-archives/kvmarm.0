Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655344;
	b=VxsROVW8kWwky6PdLT4apR69DnvjFXkHm6BM6iKw8epEUu5VL6/SawSVm/8sSTNcNfC2
	 TsJdEQ+V3WD69ePeYmzpSw74/dtkMUq35+ygrWb0/ojt+w8+y9qlguSBZvUxNuln6PxhL
	 7AWmhdkHjSu6WKq55MfOE4/G3hQe60BtiUpMbO3QnF0ZtNHKnJx/skKtrXQTCwA5vhL8r
	 jRPsRr0tMr7sly3T7doLroyvofUL8Q6YUYfqAKJ90v1a2hC+Sjnk0TMSLo9WETDUAk5Xp
	 rr+ldKvv9X+8ZkTsE4HxLrICoq2y0VcnouK1629gdzJLgRgCV6hSOfsKAgNmzbxqaLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655344;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fBKTx76XsJWghc/lxn4A1KpUifShPDWEJMzn6+Odoy4=;
	b=eKJeAR6/ZCiSxXIwGGAwaGGY+3tXKUC0NbzgXYxonJz4U3mRO/Sr+vPqBXegFGo+x6Vd
	 UQti0+Io2CEzTVrU8t1rayBKpu3k58aF4wTV62lUcY5raPKgWm5obNfO7QZEzwuA1ZYR4
	 A3tWzESROiZwS+1QHVRbF5cZ4PWwRC3EIAkS0uErmS0Md/Caj7q8qPgktl5Ou2NxKbwR1
	 0FTtcLeBUEl7QLdzGp4z64w1kwTtVg1pKqjG7Cao1hOu3vNUzWsJgIhDIHvCiNgTArQJG
	 4dP2hm7MWDRxcxaL/qQVg6qi/5qJ8YhSbyq+2z2ltJlwkFqMeM+PRdhg8yoFDtxuZLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Gbc5D1BH;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5A4606EEB4
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:35:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D5A4606EEB4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Gbc5D1BH
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E776E1595;
	Mon,  2 Nov 2026 13:35:39 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E18483F673;
	Mon,  2 Nov 2026 13:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655343; bh=23JZayZSeBAAajhbVdAp2CYQfCnJcliaGnu3C7QQJYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gbc5D1BH8njLVt3RxXc1p/Bf/GcN/ZHnU5Dj3Ngvg9SGUgt5KcVdngnKnQtZ9VylM
	 L2JUeTpaMb2Q8oDyf1QeKbcxnXw3tEKUt7hmJ98DmX4KIUCX0ek0xLa+h9OVFFo8pI
	 56bjypeM8Pbt61yUDIhjZ5SQ2tsyibn0+bPvIFX4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 20/23] arm64: Add GICv5 ITS device support
Date: Mon,  2 Nov 2026 21:34:10 +0000
Message-Id: <20261102213413.4136118-21-sascha.bischoff@arm.com>
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

Allow the GICv5 ITS irqchip to create a separate KVM ITS device and
place its CONFIG and TRANSLATE frames immediately below the IRS.
Reuse the ITS creation helper for GICv3 and GICv5, selecting the
device and address types for each model.

At this stage, --irqchip=gicv5-its is not yet exposed, and automatic
irqchip selection starts with GICv5.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                  | 25 +++++++++++++++++++------
 arm64/include/kvm/gic.h      |  1 +
 arm64/include/kvm/kvm-arch.h |  8 ++++++++
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 6abd7d44..fca99aef 100644
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
@@ -235,6 +239,7 @@ static int gic__set_irs(enum irqchip_type type)
 
 	switch (type) {
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &irs_attr);
 	default:	/* No IRS needed */
 		return 0;
@@ -270,6 +275,7 @@ static int gic__set_spi(enum irqchip_type type)
 
 	switch (type) {
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		spi_base = GICV5_SPI_IRQ_BASE;
 		fdt_type = GICV5_FDT_IRQ_TYPE_SPI;
 		break;
@@ -294,6 +300,7 @@ static int gic__set_ppi(enum irqchip_type type)
 {
 	switch (type) {
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		gic_ppi_base = GICV5_PPI_IRQ_BASE;
 		gic_ppi_fdt_type = GICV5_FDT_IRQ_TYPE_PPI;
 		break;
@@ -322,6 +329,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV3_ITS:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		break;
+	case IRQCHIP_GICV5_ITS:
 	case IRQCHIP_GICV5:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V5;
 		break;
@@ -431,6 +439,11 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
 		gic_msi_base = gic_redists_base - gic_msi_size;
 		break;
+	case IRQCHIP_GICV5_ITS:
+		gic_msi_base = ARM_GICV5_ITS_BASE;
+		gic_msi_size = ARM_GICV5_ITS_SIZE;
+		gicv5_irs_base = ARM_GICV5_IRS_BASE;
+		break;
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

