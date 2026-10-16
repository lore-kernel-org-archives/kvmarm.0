Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13B84E9C29
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165335; cv=none; b=Ff8JJQKhkg4rG1CrstT3/oq0iPGNTDq2sLlF/1WjnI8oeqdIQDYyoB0MKWgAXFIGnCKwxlKuNFP6AMpVyDe/K7qKezFT1+LmUGyYwf5yV+bt0cayPMEHiCYs5SI5HAPuzgeZZN8H6ju/GqF0A4tcBQd2uStB3G0qKIBbya//VXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165335; c=relaxed/simple;
	bh=MGOd9GIGMTyQMfUu27VlrDv5f9L+Z74Rh0adhXN6lCo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hsfrm8udrSJWt/RuFi1F4mGSayhyRPRgsBr7dLSRhWtAENmEynqORj3FmMpOsYnMzr/xn9lKgd4JlNf6tBtAJ8MHKjo0sJ3NbOmgTRYuOFOfV8f+Wd9kOXCjHH2KtFvHKK2eYlh/pXNT3Kf5+JiFQ8lKF6mGNmCHjOkd7vRy9QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OobCEPUZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OobCEPUZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07D6E143D;
	Fri, 16 Oct 2026 08:42:09 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DBF13F673;
	Fri, 16 Oct 2026 08:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165332; bh=MGOd9GIGMTyQMfUu27VlrDv5f9L+Z74Rh0adhXN6lCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OobCEPUZw4Q5Atk81+Bhc5nnPKRA+DPZN5lB0u/rV8fnz8MoCVO0BqQmSRidZzT37
	 UVAgQwnqusk5xdDnCahFajWA+f+Nseqdzb+1X8IFq825n9plAe4RvCV0T1PZ6Fh5fU
	 TVpsEQX2D5CxjBH3fupqtkv2SCYtc/RJ5ddNgZi4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 18/21] arm64: Add GICv5 ITS device support
Date: Fri, 16 Oct 2026 16:39:36 +0100
Message-Id: <20261016153939.913764-19-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
 arm64/gic.c                  | 31 +++++++++++++++++++++----------
 arm64/include/kvm/gic.h      |  1 +
 arm64/include/kvm/kvm-arch.h |  8 ++++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 02e55cd5..f09b3f5d 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -108,15 +108,15 @@ static int irq__routing_init(struct kvm *kvm)
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
@@ -127,8 +127,9 @@ static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
 
 	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &its_device);
 	if (err) {
-		pr_err("GICv3 ITS requested, but kernel does not support it.");
-		pr_err("Try --irqchip=gicv3 instead");
+		pr_err("GICv%c ITS requested, but kernel does not support it.",
+			v5 ? '5' : '3');
+		pr_err("Try --irqchip=gicv%c instead", v5 ? '5' : '3');
 		return err;
 	}
 
@@ -158,7 +159,9 @@ static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type,
 	case IRQCHIP_GICV2M:
 		return gic__create_gicv2m_frame(kvm, msi_frame_addr);
 	case IRQCHIP_GICV3_ITS:
-		return gic__create_its_frame(kvm, msi_frame_addr);
+		return gic__create_its_frame(kvm, msi_frame_addr, false);
+	case IRQCHIP_GICV5_ITS:
+		return gic__create_its_frame(kvm, msi_frame_addr, true);
 	default:	/* No MSI frame needed */
 		return 0;
 	}
@@ -203,6 +206,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
+	case IRQCHIP_GICV5_ITS:
 	case IRQCHIP_GICV5:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V5;
 		break;
@@ -226,6 +230,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
 	case IRQCHIP_GICV5:
+	case IRQCHIP_GICV5_ITS:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &gicv5_irs_attr);
 		break;
 	case IRQCHIP_AUTO:
@@ -235,7 +240,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		goto out_err;
 
 	/* Only set the dist_attr for non-GICv5 */
-	if (type != IRQCHIP_GICV5) {
+	if (type != IRQCHIP_GICV5 && type != IRQCHIP_GICV5_ITS) {
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
 		if (err)
 			goto out_err;
@@ -246,12 +251,12 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		goto out_err;
 
 	/* GICv5 SPIs start at zero. Set this before allocating IRQs. */
-	if (type == IRQCHIP_GICV5) {
+	if (type == IRQCHIP_GICV5 || type == IRQCHIP_GICV5_ITS) {
 		err = irq__init_irq_offset(0);
 		if (err)
 			goto out_err;
 	}
-	vgic_is_v5 = type == IRQCHIP_GICV5;
+	vgic_is_v5 = type == IRQCHIP_GICV5 || type == IRQCHIP_GICV5_ITS;
 	return 0;
 
 out_err:
@@ -320,6 +325,11 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
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
@@ -533,7 +543,8 @@ u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 	/* Only for GICv2 */
 	if (kvm->cfg.arch.irqchip == IRQCHIP_GICV3 ||
 	    kvm->cfg.arch.irqchip == IRQCHIP_GICV3_ITS ||
-	    kvm->cfg.arch.irqchip == IRQCHIP_GICV5)
+	    kvm->cfg.arch.irqchip == IRQCHIP_GICV5 ||
+	    kvm->cfg.arch.irqchip == IRQCHIP_GICV5_ITS)
 		return 0;
 
 	if (kvm->nrcpus > 8)
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index bef871be..36ca39ea 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -34,6 +34,7 @@ enum irqchip_type {
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

