Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A235304A4
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165221; cv=none; b=dIBkSoNI3lOXEts5jsAYxA0z34IP9bRlAX/znRck1Wwa3jKe/gxplRD71NyWlFPQZ7WjPK34m+K0lXZtsfeMPimJe2IjVMXmC1glTsKdNGvIjJDZmys/4MLDOaZPPHmVhous4fLTtwBkm7YvUefSNluCHLvIBZw+jpEure61cJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165221; c=relaxed/simple;
	bh=JC1gEHTkqnsTys7cYvGvdA0vsgwJdhYJ2VWgh94C0TE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o5r1zuV4WkRor3X2bf9o07imxMF1dCIxlooWx4G/vp3dcwVtl4A7qRZ46TxTbNwZrdnFm0WApd7SD2NMgUKxuu1dQNy3sWQOUgTB5HkD9iUanGG5+kDnkkvtVxJ6v0ljn+zTkqg13HAc1ZjBUdxtNTGpTBwu/j/gvuCVBlq21Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ju63iGO3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ju63iGO3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B20241516;
	Fri, 16 Oct 2026 08:40:16 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6DC63FC81;
	Fri, 16 Oct 2026 08:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165220; bh=JC1gEHTkqnsTys7cYvGvdA0vsgwJdhYJ2VWgh94C0TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ju63iGO3dmnrirW77BObR8ImeGeY7pTazaeIORZnwfEEokq2NNildLU9ASpfEg59S
	 50/Zkk9kO0hYMVqjlN1BQ48Ejd9t+CtNshkW5SozadWHvuR1Y/neFRli2yHLz/mjP9
	 GfXXAiVkLofd7RkPyq0embx72lyE0n4dA2oCn3lc=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 04/21] arm64: Add GICv5 irqchip device support
Date: Fri, 16 Oct 2026 16:39:22 +0100
Message-Id: <20261016153939.913764-5-sascha.bischoff@arm.com>
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

Add IRQCHIP_GICV5 and create KVM_DEV_TYPE_ARM_VGIC_V5 for it. GICv5
has no distributor or redistributor MMIO frame, so omit those address
attributes. Also omit the GICv2 PPI CPU mask from GICv5 interrupt
specifiers.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 19 +++++++++++++++----
 arm64/include/kvm/gic.h |  1 +
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index f8371f50..5c8a33b5 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -189,6 +189,9 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
+	case IRQCHIP_GICV5:
+		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V5;
+		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
 	}
@@ -208,15 +211,20 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV3:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
+	case IRQCHIP_GICV5:
+		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
 	}
 	if (err)
 		goto out_err;
 
-	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
-	if (err)
-		goto out_err;
+	/* Only set the dist_attr for non-GICv5 */
+	if (type != IRQCHIP_GICV5) {
+		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
+		if (err)
+			goto out_err;
+	}
 
 	err = gic__create_msi_frame(kvm, type, gic_msi_base);
 	if (err)
@@ -290,6 +298,8 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
 		gic_msi_base = gic_redists_base - gic_msi_size;
 		break;
+	case IRQCHIP_GICV5:
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -440,7 +450,8 @@ u32 gic__get_fdt_irq_cpumask(struct kvm *kvm)
 {
 	/* Only for GICv2 */
 	if (kvm->cfg.arch.irqchip == IRQCHIP_GICV3 ||
-	    kvm->cfg.arch.irqchip == IRQCHIP_GICV3_ITS)
+	    kvm->cfg.arch.irqchip == IRQCHIP_GICV3_ITS ||
+	    kvm->cfg.arch.irqchip == IRQCHIP_GICV5)
 		return 0;
 
 	if (kvm->nrcpus > 8)
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 8490cca6..630f0bbd 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -29,6 +29,7 @@ enum irqchip_type {
 	IRQCHIP_GICV2M,
 	IRQCHIP_GICV3,
 	IRQCHIP_GICV3_ITS,
+	IRQCHIP_GICV5,
 };
 
 struct kvm;
-- 
2.34.1

