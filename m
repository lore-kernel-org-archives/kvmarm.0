Received: from mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B89A3B2FFC
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 10:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786962771; cv=none; b=k29hwFKIDek6hmy+zOkb5GsH03U4zuDV+d3by8xk/ELZvOhre1u2VlmD5gShhDQjAUMoh1gKBuWbo3Y2FoMrEFr59OyevZhP+iFPhKaDrBOSXqira51qztt2NzeDqBWL7eGEwu9bdCjB7ex2C0AyDonmtApE/wUy1sLNJ6IVRB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786962771; c=relaxed/simple;
	bh=+Voqs9fAmTLL/s31z+dkjB9bPNGxddhWAjF+IcSVPVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UGtzB6pdouAPtHFfbqYAGI4MDRaKugNo/6ZZRo+Tant07EeEBUpiPYjCMkHG2d+V6K+y/fHfVcturIrp/K3LRSzt+TXZWX6xMYz08fa8Ql1QFxalRmrB6AaXi9c7YEEBzDHRQZ9pDCCXm+N/m9exk/7c1Rnrw8JYalECn20XEBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FoF1b/Hs; arc=none smtp.client-ip=95.215.58.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FoF1b/Hs"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+Voqs9fAmTLL/s31z+dkjB9bPNGxddhWAjF+IcSVPVE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786962766; v=1; x=1787567566;
 b=FoF1b/Hsy2TRdJ2C0KsApUN5kPhnPO+RebhnRmetmjNMvDjUwHZ4pVfkT9fQ8gKdgM+t4d9k
 jzkHI2AhmWMhQNXbimV5I7JBUmHFuvJ2PBE8JI3yDNS/gsEUNzW5IBoqISst0gFqe+CYTGyJY1D
 aaIzfTmUIkocvZx9VmUzBoDA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id dd3bab2071ab8f95;
	Mon, 17 Aug 2026 10:32:46 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v2 3/4] KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
Date: Mon, 17 Aug 2026 11:32:27 +0100
Message-Id: <20260817103228.1203140-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260817103228.1203140-1-fuad.tabba@linux.dev>
References: <20260817103228.1203140-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

can_access_vgic_from_kernel() excludes only the GICv3 system register
interface, so on a native GICv5 system without FEAT_GCIE_LEGACY it
returns true under nVHE. The kernel then saves and restores the CPU
interface from EL1, where ICH_VMCR_EL2 and the ICH_PPI_* registers are
UNDEFINED, and the nVHE world switch already does that work at EL2.

Require VHE for GICv5 as for GICv3.

Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 74bace10a22ed..df58c0042ed63 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1042,11 +1042,15 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 static inline bool can_access_vgic_from_kernel(void)
 {
 	/*
-	 * GICv2 can always be accessed from the kernel because it is
-	 * memory-mapped, and VHE systems can access GICv3 EL2 system
-	 * registers.
+	 * GICv3 and GICv5 drive the CPU interface through EL2 system
+	 * registers, so only VHE reaches them from the kernel. GICv2 is
+	 * memory-mapped and always reachable.
 	 */
-	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
+	if (kvm_vgic_global_state.type == VGIC_V5 ||
+	    static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		return has_vhe();
+
+	return true;
 }
 
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
-- 
2.39.5

