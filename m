Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2443FC5A5
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975825; cv=none; b=BkI5V2ts+wO5PEuW3T12YhKePuH9kSZKLdSUSafS0J4bHJ3SmaAs9xMorRMjwSXMfrPLduJVPuD7Isa3DMsqY1HqNDT87rbhhoLMV85/UsCFVdDLbUlq0GYlELi4l/dh1DyVXjno+qi8NIFims8YzcEumCs81z6Su02VdO3uopI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975825; c=relaxed/simple;
	bh=y65DU0zqn/mUcvtSk0T3Mz/Mz/7Zq8kcpJPr4FrcEdE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PnPQaJJWzd/DjldLt9q8ewfmmCBX3ntsjH4KEpCbPn8y7Y2+7IsBD2VjGOHlMPZ/2DwZrxA1Q33CRmuoVhpBehGWv13lz5zMPrfMUb2qPVaJlksbuBLSUTe9CGPfwfw4gEBWPfC9fJl54nd3qvaTCLoa+9PMLyfqZi3QOXjo6Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bgRIeKeS; arc=none smtp.client-ip=91.218.175.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bgRIeKeS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=y65DU0zqn/mUcvtSk0T3Mz/Mz/7Zq8kcpJPr4FrcEdE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789975819; v=1; x=1790580619;
 b=bgRIeKeS4n1ul2c9W0BP3vcQyVxJKHMzCN+OBdnOQI1gmBFQTCueEqh9RNISFP9pFzCnPNeD
 S3zigjAXYZZrZQdR0Vrohlx/NT1KnndvO7iiN/8KDP/ddLGfivPjtxWLt3bViTJoKEi1mNbXmdi
 J3PFU6GR6TkiT2hhl/ECJRQQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id be837298a217f5ce;
	Mon, 21 Sep 2026 07:30:11 +0000
X-Mizu-Trace-ID: be837298a217f5ce
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] KVM: arm64: vgic: Tear down what vgic_init() created when it fails
Date: Mon, 21 Sep 2026 08:29:57 +0100
Message-Id: <20260921072958.2918477-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921072958.2918477-1-fuad.tabba@linux.dev>
References: <20260921072958.2918477-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once kvm_vgic_dist_init() has succeeded, every later failure in
vgic_init() returns with the SPI array still allocated. A failure after
vgic_v4_init() has also succeeded, which means only
kvm_vgic_setup_default_irq_routing(), leaves the vPE array behind as
well.

A failed vgic_init() leaves kvm_arch_vcpu_precreate() admitting new
vCPUs, so a retry of KVM_DEV_ARM_VGIC_CTRL_INIT reaches
vgic_v4_init()'s early return with an array that no longer covers every
vCPU, and vgic_v3_load()'s WARN_ON(vgic_v4_load()) fires on the first
one it misses.

Release each on the paths that can reach it, so the ioctl is all or
nothing and a retry starts from scratch. vgic_v4_init() unwinds its own
state on every error return, so its failure leaves only the SPI array
to free. dist->nr_spis stays frozen, since the SPI count cannot change
once vgic_init() has supplied it.

Fixes: 180ae7b11823 ("KVM: arm/arm64: Enable irqchip routing")
Fixes: 74fe55dc9ab7 ("KVM: arm/arm64: GICv4: Add init/teardown of the per-VM vPE irq domain")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260807105558.73D701F000E9@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1537f4d20318e..67d1e8ce2aa2f 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -513,7 +513,7 @@ int vgic_init(struct kvm *kvm)
 		if (vgic_supports_direct_irqs(kvm)) {
 			ret = vgic_v4_init(kvm);
 			if (ret)
-				return ret;
+				goto out_free_spis;
 		}
 	} else {
 		if (!dist->nr_spis)
@@ -528,17 +528,24 @@ int vgic_init(struct kvm *kvm)
 		kvm_vgic_vcpu_reset(vcpu);
 
 	ret = kvm_vgic_setup_default_irq_routing(kvm);
-	if (ret) {
-		if (vgic_is_v5(kvm))
-			vgic_v5_teardown(kvm);
-
-		return ret;
-	}
+	if (ret)
+		goto out_teardown;
 
 	vgic_debug_init(kvm);
 	dist->initialized = true;
 
 	return 0;
+
+out_teardown:
+	if (vgic_is_v5(kvm))
+		vgic_v5_teardown(kvm);
+	else
+		vgic_v4_teardown(kvm);
+out_free_spis:
+	kfree(dist->spis);
+	dist->spis = NULL;
+
+	return ret;
 }
 
 static void kvm_vgic_dist_destroy(struct kvm *kvm)
-- 
2.39.5

