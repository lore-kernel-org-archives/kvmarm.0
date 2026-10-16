Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331C02877DE
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164163; cv=none; b=Z/hauoi5zc0Npyg1yotM3J6QIk97JGJwL2YTQpT3Y+0T5avhBQ4olbfuwnRl7N+mkUPcyJ9k109Z+ggt6qT2QtJ1xtrfETDwpmK7v0WsXvmpiSehgMJuGL6KiJ1XYJFSGHjbFxRENyCAYlu6BW8WlOwMQryYA+5Qd2q1c2vcyZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164163; c=relaxed/simple;
	bh=1ByMCRr6p8I+R8yMKLoV7ZxxkuBb8xs4yGUkzdxHkiI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JNlOh61Dke1+WB+YTQbBhBArfW9cNUiSEuil53b2ywSx3bdvPLpw2IVczn+7PrmV144jb2T04ZzPVP6BPJ9r60L3fAWLyJ+LKJfH5PkI74oA+Hkh4iO9rnrf34mmeU/ZJL+k4E8iSsZH9AAyGoF8PLD0YoziyfX3fNjgtNa8bDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JGa1KPA0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JGa1KPA0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 501AF1516;
	Fri, 16 Oct 2026 08:22:38 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 421193F673;
	Fri, 16 Oct 2026 08:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792164161; bh=1ByMCRr6p8I+R8yMKLoV7ZxxkuBb8xs4yGUkzdxHkiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGa1KPA01QlxEP2masHqvNUjqiBSF++TSYs3I7/haQcB4mPuQ/L1Tg9xyHohYRg0z
	 o2IZSOeGLKpYmzpHxAnM4BiKuqKzkSnlzRnIZt7HoTHKK8Yu8sxasNagYlYjnZMpL9
	 dbeSPR6VGV6PgMjWOGrp4N5XjMD6Q8tvs1lzgs9M=
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
Subject: [PATCH 1/2] KVM: arm64: vgic: Require matching VGIC model for GICv3 ITS
Date: Fri, 16 Oct 2026 16:22:23 +0100
Message-Id: <20261016152225.898761-2-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016152225.898761-1-sascha.bischoff@arm.com>
References: <20261016152225.898761-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a GICv5 host with legacy support, KVM registers both VGICv3 and
VGICv5 devices. A VM can create a GICv3 ITS with another VGIC model,
setting has_its even though that model cannot use the GICv3 ITS.

Reject GICv3 ITS creation when the VM already has an incompatible VGIC.
KVM also permits creating an ITS before its VGIC, so record the model
required by the ITS and reject a later incompatible VGIC. Preserve
either creation order when the models match.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 5 +++++
 arch/arm64/kvm/vgic/vgic-its.c  | 9 +++++++++
 include/kvm/arm_vgic.h          | 2 ++
 3 files changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index b5ea1e39c6862..48a92555fa6ab 100644
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
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e5657cb603567..bf901626ea6df 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1875,6 +1875,14 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
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
@@ -1903,6 +1911,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	dev->kvm->arch.vgic.msis_require_devid = true;
 	dev->kvm->arch.vgic.has_its = true;
+	dev->kvm->arch.vgic.its_model = KVM_DEV_TYPE_ARM_VGIC_V3;
 	its->enabled = false;
 	its->dev = dev;
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7be81b936bf10..a2b6b328808ba 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -548,6 +548,8 @@ struct vgic_dist {
 	struct vgic_io_device	cpuif_iodev;
 
 	bool			has_its;
+	/* VGIC model required by the VM's ITS devices. */
+	u32			its_model;
 	bool			table_write_in_progress;
 
 	/*
-- 
2.34.1

