Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AC63C76AD
	for <kvmarm@lists.linux.dev>; Sun, 11 Oct 2026 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729422; cv=none; b=kGJbfe7b00tFUiqALY/KieJYaeNyG7r9E7Y3rn3GA7OedDU5Z73l/8Xq8uXp2HmIyjWaKT2q720KtPSgdju8PeLJophDLbQ74ubR3I8kBme3CTazlJE3lYzeVSRIzgq3IFYBaiY+Wr7XZdcwlaa1D4VGHgPiZcIPQbldFBmf1Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729422; c=relaxed/simple;
	bh=W/CBcZgzrCyfWkw/en5F1F87whMpeCt6l2XK9zwdnwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VcvDdQeQtJHHY8KeYt+NMGN6KjT5/uOqN6f0HFOj39ih35cmRVSLwi/GE/fzMnbj9fD7fQ5gYlnbeUBnKMjup401WQdcgAa2+2GygN6KnTDyj3GYfyYpEvdnbpI50Xw7KVAaE1JTt9DTKTDvvBDxqMY9xzy5MflMN9cJ9kO99z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u9WvkEiJ; arc=none smtp.client-ip=91.218.175.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u9WvkEiJ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=W/CBcZgzrCyfWkw/en5F1F87whMpeCt6l2XK9zwdnwA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791729416; v=1; x=1792334216;
 b=u9WvkEiJYfVKNfKXd/Kz8sjtH/nxhG6NTWk+/gObY2YPMB9muWhzrnnQ087g/ov4il8fdUoh
 e8qv+nva89gGEnY27NsciUFWaQpqkPCdBW1B9mCIv6DWDnxatsggwBphqpnKwXTfj+nCKivfiyn
 LPfQKs+Zw1GcfEiYsNmB5cXU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d34b3f25e440f7c0;
	Sun, 11 Oct 2026 14:36:56 +0000
X-Mizu-Trace-ID: d34b3f25e440f7c0
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH v2 4/5] KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
Date: Sun, 11 Oct 2026 15:36:47 +0100
Message-Id: <20261011143648.211337-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261011143648.211337-1-fuad.tabba@linux.dev>
References: <20261011143648.211337-1-fuad.tabba@linux.dev>
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
UNDEFINED, so running a vCPU oopses the host. The nVHE world switch
already does that work at EL2.

Require VHE for GICv5 as for GICv3.

Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index b25303d9919fd..da72779d3b3ee 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1045,11 +1045,15 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
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
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) ||
+	    kvm_vgic_global_state.type == VGIC_V5)
+		return has_vhe();
+
+	return true;
 }
 
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
-- 
2.39.5

