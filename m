Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1865221DB6
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753338508; cv=none; b=dq6bY6sKxKu/EiOcsgebBj8lgJkipQiMpVHMaYqghSB5esCzFASd0Y/1MjZraOSlhWx9gvDvdN75i1HjNMg+0gsZ1nAinFJcdUhB+5xTw4eI76XLbhcmdwP05UuehZiLtWZze2rsHd4m9L4lBIeWfWkeqqd4mTq6YX/QQLlmQtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753338508; c=relaxed/simple;
	bh=E9kbktuX9VK7yXVhy1Xbw0eSSTb/gPmpg1W7jELAcVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hmI3UDINrQcsaxm0vf/s+IT0OGBas0XzJ8c0tJTKQCvKvQ+m8FzoHbKVkxGjMg8C7Fqj7PNCt0LFnnopbq9HWv5FXPYaMdp4T3+G2vIfV0UGx6Iamj/Z6h+fSBci48VMAqMlWW9qxqNca0Aci1RLFCeDSwuQ6O4rLGZXIKZ+/nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pTNm5jCX; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pTNm5jCX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753338505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yShxlQdIYyvc8TLdqBB61FC5lDymQVlAw+Ub7TUzoJs=;
	b=pTNm5jCXN7xJHp9FpiIkvxv16zCELkxUcTLaQJW3aAXLvSIPorPpsfq7tl5HkmRcAIvhXT
	otcWL7j/Qt54kEM1mqHpIOvKGdH1gltLTny4JFmUV/7MMFsO7F+78VWrn6F++fCwQsP2nM
	zn/CPzIufeEnoC3Iwfdmy0He5OSujU8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eauger@redhat.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 3/6] KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initialization
Date: Wed, 23 Jul 2025 23:28:02 -0700
Message-Id: <20250724062805.2658919-4-oliver.upton@linux.dev>
In-Reply-To: <20250724062805.2658919-1-oliver.upton@linux.dev>
References: <20250724062805.2658919-1-oliver.upton@linux.dev>
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
Hoist initializaiton of the default value to kvm_vgic_create() and
discard the incorrect comment that assumed userspace could access the
register before initialization (until now).

Subsequent changes will allow the VMM to further provision the GIC
feature set, e.g. the presence of nASSGIcap.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  9 +--------
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 0d8bc2ac627a..31462ba093c9 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -157,6 +157,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
+	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
@@ -408,15 +409,7 @@ int vgic_init(struct kvm *kvm)
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
index 00c011cc8627..8e24d550d9d2 100644
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

