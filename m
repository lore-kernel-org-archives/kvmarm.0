Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798925;
	b=BjSd0a/kfm4CPQZLTQ9OBf8Ym1iwjbnEDieCGQBf2rF4lbbAi9jOQCYr2YhzYoPlzPCh
	 GQH9DWlbT62tF+SlutrastX3PBTVO/RfXDYEBpIKi90iRPVZcgRAaTD4YAdvOjr9dFjPT
	 4GRq/dn1cohO0SH8uAqAaPzibdQQb/fZZMfsLpfLkZNz6BFOKwZi+vSQwLl4wv18Y3bAP
	 E5wQPH+HVrBMWv3NsxECfHqLAmR9bN2tZ8rcKxzveEBM5MaF4rzzc6muWtsvbccP2YpNx
	 63Q94h4AAy/ytXE/cjY5SKjNY62AcLKr25WKQyHIq2OVkCKbs2LSVEoOeYXvuuW+pQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798925;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WtaFrv8PSZX39CqiTLLDCf+5RiYRLHF4YcowUaq983I=;
	b=16DajKrGat16HlVp9EZnMFJZj7xfhul4ss3udF2ndEgIUG4aD2614sSocDePGXKyWXhz
	 Fy6eBs4OF7gUcOrUaqrTGznejZvrka8uRosMJgeXhvjulWi6KsN7xwcRrdNdAXTkrJsBh
	 771PhNwQ729MB7Wm4IIJbI+iFcArzL5Ig12aWygsHH0pWvY3A1fu9kwwW2dV599eLllnd
	 DGmDOeGFKKFE7J8SLgp8NDM35J7/i23CLRNYWwT3JBriHLMmuJeo73arhyeWsx2zZEWlL
	 NfDcSTR5l4vQPXoqMsxdzkvM3zyLSDDPm7TUkIV4pWunVlJryAR+6MNmwnfglJqoFEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="g/xzVD2C";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4874606A327
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4874606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=g/xzVD2C
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B2711D70;
	Fri, 27 Nov 2026 09:02:01 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E00083F632;
	Fri, 27 Nov 2026 09:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798924; bh=p/U5tQIycTvuu13q2oqzYuw0WeSLjZ+OrZCPmWGuZEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/xzVD2CbDe/B5jeqpdY8aaf1+HV7IrWn8bbOyaaSU/8WvIJus2m/lQDuwFaA1oN3
	 +0umPFnQ/eg0qWDdIxX93Ll7usiugr5EodKfot8TOF/m1iu7ppb2qhR0hlR5xuO/Om
	 F18KPl3OlMFyrtUH9e5N+ieBlF/NHu3GbgYtcsqc=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 03/23] arm64: Split GIC device setup
Date: Fri, 27 Nov 2026 17:01:25 +0000
Message-Id: <20261127170145.4138182-4-sascha.bischoff@arm.com>
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

Separate the CPU interface, redistributor and distributor address setup
from GIC device creation. Keep the per-GIC address handling in small
helpers.

Have the existing MSI frame helper use the global MSI base instead of
passing it as an argument.

Use the irqchip enum order to omit the GICv2 PPI CPU mask for GICv3
and later generations.

Suggested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 94 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 62 insertions(+), 32 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index f8371f50..57f3fa02 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -142,52 +142,90 @@ out_close:
 	return err;
 }
 
-static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type,
-				 u64 msi_frame_addr)
+static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type)
 {
 	switch (type) {
 	case IRQCHIP_GICV2M:
-		return gic__create_gicv2m_frame(kvm, msi_frame_addr);
+		return gic__create_gicv2m_frame(kvm, gic_msi_base);
 	case IRQCHIP_GICV3_ITS:
-		return gic__create_its_frame(kvm, msi_frame_addr);
+		return gic__create_its_frame(kvm, gic_msi_base);
 	default:	/* No MSI frame needed */
 		return 0;
 	}
 }
 
-static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
+static int gic__set_cpu_if(enum irqchip_type type)
 {
-	int err;
 	u64 cpu_if_addr = ARM_GIC_CPUI_BASE;
-	u64 dist_addr = ARM_GIC_DIST_BASE;
-	struct kvm_create_device gic_device = {
-		.flags	= 0,
-	};
 	struct kvm_device_attr cpu_if_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
 		.attr	= KVM_VGIC_V2_ADDR_TYPE_CPU,
 		.addr	= (u64)(unsigned long)&cpu_if_addr,
 	};
-	struct kvm_device_attr dist_attr = {
-		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
-		.addr	= (u64)(unsigned long)&dist_addr,
-	};
+
+	switch (type) {
+	case IRQCHIP_GICV2M:
+	case IRQCHIP_GICV2:
+		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
+	default:	/* No CPU interface needed */
+		return 0;
+	}
+}
+
+static int gic__set_redist(enum irqchip_type type)
+{
 	struct kvm_device_attr redist_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
 		.attr	= KVM_VGIC_V3_ADDR_TYPE_REDIST,
 		.addr	= (u64)(unsigned long)&gic_redists_base,
 	};
 
+	switch (type) {
+	case IRQCHIP_GICV3:
+	case IRQCHIP_GICV3_ITS:
+		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
+	default:	/* No redistributor needed */
+		return 0;
+	}
+}
+
+static int gic__set_dist(enum irqchip_type type)
+{
+	u64 dist_addr = ARM_GIC_DIST_BASE;
+	struct kvm_device_attr dist_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.addr	= (u64)(unsigned long)&dist_addr,
+	};
+
+	switch (type) {
+	case IRQCHIP_GICV2M:
+	case IRQCHIP_GICV2:
+		dist_attr.attr = KVM_VGIC_V2_ADDR_TYPE_DIST;
+		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
+	case IRQCHIP_GICV3:
+	case IRQCHIP_GICV3_ITS:
+		dist_attr.attr = KVM_VGIC_V3_ADDR_TYPE_DIST;
+		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
+	default:	/* No distributor needed */
+		return 0;
+	}
+}
+
+static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
+{
+	int err;
+	struct kvm_create_device gic_device = {
+		.flags	= 0,
+	};
+
 	switch (type) {
 	case IRQCHIP_GICV2M:
 	case IRQCHIP_GICV2:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V2;
-		dist_attr.attr  = KVM_VGIC_V2_ADDR_TYPE_DIST;
 		break;
 	case IRQCHIP_GICV3:
 	case IRQCHIP_GICV3_ITS:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
-		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
@@ -199,26 +237,19 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 
 	gic_fd = gic_device.fd;
 
-	switch (type) {
-	case IRQCHIP_GICV2M:
-	case IRQCHIP_GICV2:
-		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
-		break;
-	case IRQCHIP_GICV3_ITS:
-	case IRQCHIP_GICV3:
-		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
-		break;
-	case IRQCHIP_AUTO:
-		return -ENODEV;
-	}
+	err = gic__set_cpu_if(type);
+	if (err)
+		goto out_err;
+
+	err = gic__set_redist(type);
 	if (err)
 		goto out_err;
 
-	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
+	err = gic__set_dist(type);
 	if (err)
 		goto out_err;
 
-	err = gic__create_msi_frame(kvm, type, gic_msi_base);
+	err = gic__create_msi_frame(kvm, type);
 	if (err)
 		goto out_err;
 
@@ -439,8 +470,7 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 {
 	/* Only for GICv2 */
-	if (kvm->cfg.arch.irqchip == IRQCHIP_GICV3 ||
-	    kvm->cfg.arch.irqchip == IRQCHIP_GICV3_ITS)
+	if (kvm->cfg.arch.irqchip >= IRQCHIP_GICV3)
 		return 0;
 
 	if (kvm->nrcpus > 8)
-- 
2.34.1

