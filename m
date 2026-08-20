Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1910844682B
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 12:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787230270; cv=none; b=tX9V89vuZECgw9J0UkJp+Oie2Tq3m4CeiKpCVmVfk96TDdkuDfnrzN1c+QEwmnFcTzbbLAEyle0xyq/5bAZGINLpnVPS9POWIVvDnYQ1KKZx27B0o0D0vb13ZVKChk5N41C6yPodB35SZUwLsregUAIeosT6dRKV+d0vM5lLZ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787230270; c=relaxed/simple;
	bh=+OVYGds3T77EelMLOPm4dGH+mQ9alxNzuYkC0tWP/eU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rYZ2HpI6Sh1fMkf0HOaQX4z0/KybhzimWLAnQSYd5Q6dfsEi34fDwag2x05SxuoBaenbR5YJsqz57eOH5KyKTo54pxwAQS1rffdoC/KxelEPBosXIqKShxhS60OOxwJO+3rFWjyVjYdJXEInDSBIO/+2rfJwC9ssOCYAZsLBRIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PvK+pHJI; arc=none smtp.client-ip=91.218.175.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PvK+pHJI"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+OVYGds3T77EelMLOPm4dGH+mQ9alxNzuYkC0tWP/eU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787230264; v=1; x=1787835064;
 b=PvK+pHJI8clCwWkypiKruyzbDI2xkP/naswqdUzblHXWTHix22MphV6DghqE2UcirHC8023B
 2jZG00d/PPKaPxNfRNGXj8jkkeEeYdRJdozQ2WmSOUF/CxWX7Oz1obH4IRw+QldsDkcq/9dp4uZ
 aSB6SEP+vf2Cn0r6Fuw2hvSs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id f82f72450b457568;
	Thu, 20 Aug 2026 12:51:04 +0000
X-Mizu-Trace-ID: f82f72450b457568
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
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: arm64: vgic: Tear down what vgic_init() created when it fails
Date: Thu, 20 Aug 2026 13:50:53 +0100
Message-Id: <20260820125053.2951078-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260820125053.2951078-1-fuad.tabba@linux.dev>
References: <20260820125053.2951078-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once kvm_vgic_dist_init() has succeeded, every later failure in
vgic_init() returns with the SPI array still allocated. A failure after
vgic_v4_init() has also succeeded, which today means only
kvm_vgic_setup_default_irq_routing(), leaves the vPE array behind as
well.

A failed vgic_init() leaves kvm_arch_vcpu_precreate() admitting new
vCPUs, so a retry of KVM_DEV_ARM_VGIC_CTRL_INIT reaches
vgic_v4_init()'s early return with an array that no longer covers every
vCPU, and vgic_v3_load()'s WARN_ON(vgic_v4_load()) fires on the first
one it misses.

Release both on the two paths that can reach them, so the ioctl is all
or nothing and a retry starts from scratch. dist->nr_spis stays frozen,
since the SPI count cannot change once vgic_init() has supplied it.

Fixes: 74fe55dc9ab7 ("KVM: arm/arm64: GICv4: Add init/teardown of the per-VM vPE irq domain")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260807105558.73D701F000E9@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 4012df6002ea6..7493fded53acc 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -462,7 +462,7 @@ int vgic_init(struct kvm *kvm)
 		if (vgic_supports_direct_irqs(kvm)) {
 			ret = vgic_v4_init(kvm);
 			if (ret)
-				return ret;
+				goto out_teardown;
 		}
 	} else {
 		ret = vgic_v5_init(kvm);
@@ -475,12 +475,19 @@ int vgic_init(struct kvm *kvm)
 
 	ret = kvm_vgic_setup_default_irq_routing(kvm);
 	if (ret)
-		return ret;
+		goto out_teardown;
 
 	vgic_debug_init(kvm);
 	dist->initialized = true;
 
 	return 0;
+
+out_teardown:
+	vgic_v4_teardown(kvm);
+	kfree(dist->spis);
+	dist->spis = NULL;
+
+	return ret;
 }
 
 static void kvm_vgic_dist_destroy(struct kvm *kvm)
-- 
2.39.5

