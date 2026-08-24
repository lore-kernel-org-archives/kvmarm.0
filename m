Received: from mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F382239A7F4
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 07:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557395; cv=none; b=cSInMb9rWc8HvCzWtPIrTTzcjXPOGV4hfPPCZ51q8PndAgtuORr0Hbkr5jl2Yrhxy/xfWg2WZmoBlTYfHB31mKGo5k88d6zeYMPWOg+qDMV6VLi7PNt7FtylhghbKA3LU8Dpa4QJmMkSjyaEe+M+xkEzIv575t5ZmrFmjEIXncQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557395; c=relaxed/simple;
	bh=9SM9EZpFWctk2TqtGWCIMwkbHqGpteu/BtNVjcuXB8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KN6pcnInd2xNbQuiS1Afd0O52h5bw1HOEUygCuDJaMUCh3glYJaEFDxediSBxEJSIpuLoa2fEniMZSt5pSV2D74djgfh6m9RYlZ4LqyyWwwdmpsYL1dfylnW56m7O9Fuv5OvApeOx6sDQ+LQq5EhoNFrcOyHFQy+lK2Sk9pL2KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s9lkoVgk; arc=none smtp.client-ip=95.215.58.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s9lkoVgk"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9SM9EZpFWctk2TqtGWCIMwkbHqGpteu/BtNVjcuXB8k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787557383; v=1; x=1788162183;
 b=s9lkoVgkFU6+Qqh/hFriV7xAMs3X8vr0BWnf3BIAe6V7aZhHG5upLzhFvg2t75hPwD8WsXd1
 ZEpwuFEg1k1x31g8t7KEgC3JVYDgaIhMhbgTSbH0I1I5Zz7VdVxf+RwHFv7Z9lFS9CGgb8MVf9Z
 77lEs0lC5JJ4dADsiLUhnREk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id ff7716c927965831;
	Mon, 24 Aug 2026 07:43:03 +0000
X-Mizu-Trace-ID: ff7716c927965831
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
Subject: [PATCH v2 3/4] KVM: arm64: vgic: Tear down what vgic_init() created when it fails
Date: Mon, 24 Aug 2026 08:42:44 +0100
Message-Id: <20260824074245.710955-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260824074245.710955-1-fuad.tabba@linux.dev>
References: <20260824074245.710955-1-fuad.tabba@linux.dev>
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

Fixes: 180ae7b11823 ("KVM: arm/arm64: Enable irqchip routing")
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

