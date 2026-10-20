Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514378;
	b=HcnhscPUhVMiCyq7clBHPVlXo4CsMGdA8+CMwp2EURYnKfGpTATASjjiDtsf+hHYu4zM
	 NBzlOLVlEsKxD7W/Y8zvalOsbvNJxQVKTCOfr3uHtN7/qafZy1uhp8y7qkRxqR2C6LA7r
	 pfGfBSZssm1mcAo/XfhlQEzi72XTFU9h9mPoEsehv6VyXpodqkUkIBWvK6bWOKX68I71Z
	 wqhGglDQOlTQqk6IcRLwfk19eVkshorvRC7u6q3gHstYvXvFzYP8NBkZmESKPWwo3VZpn
	 BMV2h9tFgFuchuEmbBMLL4qVlE2C9iku4wFdT6pAElfOWsst6rbtG3PHwyb2Fm4Zrzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514378;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wi8oSibcZwtyoLuWKyzPA4tpvz247HUgC+oOA7GlrD4=;
	b=kXhhHHvC+LqDJwXu06rONCsfx4p1N45RyumvPH8d9h9/IQVnBUUujkxkaH33DGjS81eg
	 AEFYNXvRDDxQtl6++I/9oOHHQfD3YSESZzuoFp+wfb82c7PC7TeY4Tg2PQjPsqObuBi4Q
	 lrs6M8u6oBeJ7QMDWHMuzVqIaV7P7bvL7N/8xha2yqBBtuf7kmp+IWwzZKU8yw7XAejg4
	 Hg64CgIxl9QDA5A9+SGpUb2QSspe320z2CAWLH2DNdnCt4Rn55Xf9uq8jWzWjBWJbkazZ
	 PxFWR0lHqQxhO/tPV7O4lYtrCCFPmjfRBlkNNfFKrh64JZTyTEJedBLH9OZ/kLZGR9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vzFWNsmG;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6149C606A326
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 16:39:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6149C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vzFWNsmG
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 225CC2103;
	Tue, 20 Oct 2026 09:39:33 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0FAD3F7D8;
	Tue, 20 Oct 2026 09:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792514376; bh=FMTfj2vF1JMjc7DiD/wvEGGwmJATcyNhrtDtTJY35Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzFWNsmGyfqlqYZgBHNykBmswcdj5BNC/SheX2YGkd6385/hb21gKmlvZmWIk+k1w
	 XJXFIx1R5OBJHW7F5BLopTQUe3hERi4bwVnLghR6DCISgjah6peOlmCp/dCXyf87g9
	 Y8BtnUJFp9gjYqmTUFU/lLkMYDJRUdw25qXjfJX8=
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
Subject: [PATCH v3 1/2] KVM: arm64: vgic: Require matching VGIC and ITS models
Date: Tue, 20 Oct 2026 17:39:22 +0100
Message-Id: <20261020163923.1407856-2-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020163923.1407856-1-sascha.bischoff@arm.com>
References: <20261020163923.1407856-1-sascha.bischoff@arm.com>
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

On a GICv5 host with legacy support, KVM registers both VGICv3 and
VGICv5 devices. Without a model check, a VM can create a GICv3 ITS
alongside an incompatible VGIC, regardless of creation order.

The same problem exists for GICv2 on hosts that support a GICv3 ITS.
KVM used to allow userspace to create both devices in either order,
then ignored the ITS.

Record the VGIC model required by an ITS. Reject an ITS if the VM
already has an incompatible VGIC, and reject a VGIC if an existing
ITS requires a different model. These checks apply on every host:
a GICv2 VGIC and a GICv3 ITS now fail with -ENODEV in either order.
Allow either creation order when the models match.

Have vgic_has_its() require matching VGIC and ITS models, and drop
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
index 5ab789accc9d4..08f867ebc0df4 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -42,10 +42,7 @@ bool vgic_has_its(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
-		return false;
-
-	return dist->has_its;
+	return dist->its_model && dist->its_model == dist->vgic_model;
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

