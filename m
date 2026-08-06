Received: from out-182.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405F443B48C
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010640; cv=none; b=rWPj8HRZJrmakyiKxgnkJFasmpZiKrfcy485FydF2WlGzwHLila6IrVayfr1x6OhjXJcB0gRVmDcWCTxbWI3/xy2DoARF7MdGIVIFSwqKdVPp5oauSsT2OQo+du8roq5jfT7SIXOysTT8oXtsfQzbiGa+tuRC26El+xuQERhxN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010640; c=relaxed/simple;
	bh=RFD5bOuln32DX5D4JT85/kl3zYtfDNNovIGxgEyER/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pWid0fkReWrCwC/69L1XqH+VPjdpWq50/g4Vc+ZofiagkbnshZUq1INu1vRD/2OB8uVKMoGyHunbWkg8CeRKiPSY8BY1QRumVlaxZuQMU1goIxezYzi37bz1gFf/TDULbyrom1WgZ4UrBw5JQxwX4JwuZC96yab7QsYKrcasmbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZMt2h/+p; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZMt2h/+p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786010634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R+kHrAsh4mnRSRJem4byDKdYAMKiGZXK6sT/FXhxkzw=;
	b=ZMt2h/+pfp8Ur+idXzkBA7DuC1qVvESpBvu2ETQx/8i935rt0B1ES0lMsMOEdMSjqPmIg4
	8+TVn642unYxUgWy7Orzom0bMdP9XZFf9/jLQ3rJPIlT9YoeV/SAuqvVR2HL5XrXxRpzom
	cCWg3woZz+t7plSts5W9g7e8snzUP7A=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v1 3/4] KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
Date: Thu,  6 Aug 2026 11:02:55 +0100
Message-Id: <20260806100256.371164-4-fuad.tabba@linux.dev>
In-Reply-To: <20260806100256.371164-1-fuad.tabba@linux.dev>
References: <20260806100256.371164-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

can_access_vgic_from_kernel() excludes only the GICv3 system register
interface, so on a native GICv5 system without FEAT_GCIE_LEGACY it
returns true under nVHE. The kernel then saves and restores the CPU
interface from EL1, where ICH_VMCR_EL2 and the ICH_PPI_* registers are
UNDEFINED, and the nVHE world switch already does that work at EL2.

Require VHE for GICv5 as for GICv3.

Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
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

