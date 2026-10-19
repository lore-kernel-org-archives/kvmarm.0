Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4354F96AA
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 13:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417377; cv=none; b=Y71MSzdn6fQd69Z2GlVVedGrrliWwO5HU83gGeRCRCLsdViUtN0YK+ZuoPmy6/YXqyB67Ri0gzuEJHCAJ8ynBYYMCWmvMcTEF9xo8ZZ8VNajovc7iYQlVuviTUustyH90JcbzZTD1/jVGuFJEtkdnfeJ2hiHE3NJocRS5R1aj9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417377; c=relaxed/simple;
	bh=hTAvATOELyearURoXxiiyWbjy0YEchgXjQGaxCR/qQQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MBK2ON07oSga3qsmoWexnw2aNOBJ3H/P6AeioV7mF38l8Y7+aSLmz2yuRDINVJTywEdj7U+g5glp3w8MXe1zpqm/LjGONFZQJB3FLfq3JP6XnisThFeJBitYPPSXO3xdq/ibt5EsTUUwk1lTnV1pdTKeWVlG8RsmYz+Wq3nPbZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fsKkcfIL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fsKkcfIL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E9A31CC4;
	Mon, 19 Oct 2026 06:42:51 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BA883F7D8;
	Mon, 19 Oct 2026 06:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792417374; bh=hTAvATOELyearURoXxiiyWbjy0YEchgXjQGaxCR/qQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsKkcfILWoI2eZ7mnaoloNpEsX3fzkiwpMo5Sf0GGBVaF7WnyJWPq39J+8jIrCOpp
	 aEEcvUj5J8ZCf1XIYQTsizgf919Z3zgXcPQYArpWP4igtlC/TOXoiAbaGK6LvrgWwy
	 99huJh6AH377cBPIIufKRsJXdkVZuuZSgsqiL/d4=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: [PATCH v2 1/2] KVM: arm64: vgic: Require matching VGIC model for GICv3 ITS
Date: Mon, 19 Oct 2026 14:42:41 +0100
Message-Id: <20261019134242.1289002-2-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019134242.1289002-1-sascha.bischoff@arm.com>
References: <20261019134242.1289002-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a GICv5 host with legacy support, KVM registers both VGICv3 and
VGICv5 devices. Without a model check, a VM can create a GICv3 ITS
alongside an incompatible VGIC, regardless of creation order.

Record the VGIC model required by an ITS. Reject an ITS if the VM
already has an incompatible VGIC, and reject a VGIC if an existing
ITS requires a different model. Allow either creation order when
the models match.

Have vgic_has_its() check that the its_model has been set, and drop
the separate has_its flag.

As part of this change, swap the type of vgic_model from u32 to enum
kvm_device_type. This requires updating the switch cases in
kvm_vgic_vcpu_init() and kvm_vgic_dist_destroy() to include default
cases, which we mark as unreachable().

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    | 17 +++++++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c     | 15 ++++++++++++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  5 +----
 include/kvm/arm_vgic.h             |  5 +++--
 4 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index b5ea1e39c6862..e499cec70e607 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -125,6 +125,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
 
+	if (kvm->arch.vgic.its_model && kvm->arch.vgic.its_model != type) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
 	if (kvm_id_regs_final(kvm))
 		goto out_unlock;
 	ret = 0;
@@ -437,6 +442,8 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		return ret;
 
 	switch (dist->vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		/*
 		 * If we are creating a VCPU with a GICv3 we must also register
@@ -455,6 +462,9 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		 */
 		if (vcpu->vcpu_id >= kvm_vgic_global_state.max_gicv5_vcpus)
 			return -EINVAL;
+		break;
+	default:
+		unreachable();
 	}
 
 	return ret;
@@ -554,6 +564,10 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->nr_spis = 0;
 	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 
+	/* A VM may be destroyed without ever creating a VGIC. */
+	if (!dist->vgic_model)
+		goto out;
+
 	switch (dist->vgic_model) {
 	case KVM_DEV_TYPE_ARM_VGIC_V2:
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
@@ -571,8 +585,11 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		kfree(dist->vgic_v5_irs_data);
 		dist->vgic_v5_irs_data = NULL;
 		break;
+	default:
+		unreachable();
 	}
 
+out:
 	xa_destroy(&dist->lpi_xa);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e5657cb603567..7df5869cff990 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1875,6 +1875,19 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
+	/*
+	 * Reject creation of a GICv3 ITS if:
+	 * - The VM already has a VGIC other than GICv3.
+	 * - An existing ITS requires a VGIC model other than GICv3.
+	 */
+	if ((irqchip_in_kernel(dev->kvm) && !vgic_is_v3(dev->kvm)) ||
+	    (dev->kvm->arch.vgic.its_model &&
+	     dev->kvm->arch.vgic.its_model != KVM_DEV_TYPE_ARM_VGIC_V3)) {
+		mutex_unlock(&dev->kvm->arch.config_lock);
+		kfree(its);
+		return -ENODEV;
+	}
+
 	if (vgic_initialized(dev->kvm)) {
 		ret = vgic_v4_init(dev->kvm);
 		if (ret < 0) {
@@ -1902,7 +1915,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	xa_init(&its->translation_cache);
 
 	dev->kvm->arch.vgic.msis_require_devid = true;
-	dev->kvm->arch.vgic.has_its = true;
+	dev->kvm->arch.vgic.its_model = KVM_DEV_TYPE_ARM_VGIC_V3;
 	its->enabled = false;
 	its->dev = dev;
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5ab789accc9d4..5f0a5b12e338f 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -42,10 +42,7 @@ bool vgic_has_its(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
-		return false;
-
-	return dist->has_its;
+	return !!dist->its_model;
 }
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7be81b936bf10..cad74eaff0a7e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -502,7 +502,9 @@ struct vgic_dist {
 	bool			initialized;
 
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
-	u32			vgic_model;
+	enum kvm_device_type	vgic_model;
+	/* VGIC model required by the VM's ITS devices. */
+	enum kvm_device_type	its_model;
 
 	/* Implementation revision as reported in the GICD_IIDR */
 	u32			implementation_rev;
@@ -547,7 +549,6 @@ struct vgic_dist {
 	struct vgic_io_device	dist_iodev;
 	struct vgic_io_device	cpuif_iodev;
 
-	bool			has_its;
 	bool			table_write_in_progress;
 
 	/*
-- 
2.34.1

