Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E635E236424
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752095676; cv=none; b=IfUzOsnXuhsIV3h829qWooGl/V5cE/77cHKuPYOxZFZGjOgT9kwk8RERuvBg299lCJyOwjZzdwmYzTcTf0Uy495Y190U/tfpj/cFmSCdDeWAFvHRZ087oDdx6DqSZ6ainQdFrbgZ9BAZp/4sGhNsH3SPZDabUdecWhMpd2w9MW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752095676; c=relaxed/simple;
	bh=bboRt+fyNqClj5pC0cYCi5rxeftKh5ut7tnZx8qOo2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n09l02NWd1Q/GLkdtaFzCMZzLHNDWr9trNKXYZbMOk2puzEp8QsyctkuLIyaLQmFMA7Y0nbPGCJGmS6SnzTMW+gQ0Ow0iGKXBdRYTHG3yIFeBBtmZ922Orj4uCVmHk+zpEARCcQn7aMq1azwPh6ynCpsnhu2rk9xLx5NkgqAVKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Uiw2VPnN; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uiw2VPnN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752095672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OvdgNe6c7H49iWUf9eYPvsHZHnkETVk8aY1DzMdNdZY=;
	b=Uiw2VPnNexTU+Z1UydiJlfFqcNG8jP/v5F+5KKdZRRtsH0GfFsiztDmf+sxWPvw/SBRIWz
	0931DgQYvq2lBJi0Y/ZeTHS5dniXkIrqy838r2x2gj+XrJq+CgDAsZ6Ui403EX/b5bAA54
	dJxK4JtwNgAiosTcwo4B4Bqz0J5E1dc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 3/6] KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initialization
Date: Wed,  9 Jul 2025 14:14:14 -0700
Message-Id: <20250709211417.2074487-4-oliver.upton@linux.dev>
In-Reply-To: <20250709211417.2074487-1-oliver.upton@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM allows userspace to write GICD_IIDR for backwards-compatibility with
older kernels, where new implementation revisions have new features.
Unfortunately this is allowed to happen at runtime, and ripping features
out from underneath a running guest is a terrible idea.

While we can't do anything about the ABI, prepare for more ID-like
registers by allowing access to GICD_IIDR prior to VGIC initialization.
Subsequent changes will allow the VMM to further provision the GIC
feature set, e.g. the presence of nASSGIcap.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  9 +--------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 5e0e4559004b..487e902b040c 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -157,6 +157,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
+	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
@@ -409,15 +410,7 @@ int vgic_init(struct kvm *kvm)
 		goto out;
 
 	vgic_debug_init(kvm);
-
-	/*
-	 * If userspace didn't set the GIC implementation revision,
-	 * default to the latest and greatest. You know want it.
-	 */
-	if (!dist->implementation_rev)
-		dist->implementation_rev = KVM_VGIC_IMP_REV_LATEST;
 	dist->initialized = true;
-
 out:
 	return ret;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index e28cf68a49c3..15d9772a53c8 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2015 ARM Ltd.
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
+#include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <linux/uaccess.h>
@@ -503,6 +504,23 @@ int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 	return 0;
 }
 
+/*
+ * Allow access to certain ID-like registers prior to VGIC initialization,
+ * thereby allowing the VMM to provision the features / sizing of the VGIC.
+ */
+static bool reg_allowed_pre_init(struct kvm_device_attr *attr)
+{
+	if (attr->group != KVM_DEV_ARM_VGIC_GRP_DIST_REGS)
+		return false;
+
+	switch (attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK) {
+	case GICD_IIDR:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * vgic_v3_attr_regs_access - allows user space to access VGIC v3 state
  *
@@ -552,7 +570,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
-	if (!vgic_initialized(dev->kvm)) {
+	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
 		ret = -EBUSY;
 		goto out;
 	}
-- 
2.39.5

