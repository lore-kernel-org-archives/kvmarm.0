Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCA32D5957
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 07:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769586766; cv=none; b=dOmZYY8LuyXjIUvmQIDsKoeTab+p9YLUsBP+qjWzodYpFswgxsJ6OQm/YQvj9PTWQbY5VT2VENGpqWdAde2pynVDpk0dgj4vYTnJquxS/xSfesn3S/RVGYZ00D52RkzmfXN/ZP52Dat0nSbhiT7g+TkicpTSdpTKMVOENZaDnms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769586766; c=relaxed/simple;
	bh=eOVs4X+ESJ01PqBxNg69Z1WgOUernm2wcipNPo8hv7E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BB3Gw1xPCniVgDfsyAE9Xd/8os97heUMf6n4KoOHtTzkcbsNHKr7WwMo6X2u+erRMjK+UQYuoS4UxZq/IcXynrNR7ncVCSBAE/eEr4lQPySDeySivMxR3Rd2YLMzcc80czRN/f4i+9PGNH6eREZAtc+ehOI4HBmnu+NNhU/QrRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w+hX2TNQ; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w+hX2TNQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769586760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tGVVzEzdKIqtw2jMSkAdxRRepqF4t65vIU1oF5Z4Mr8=;
	b=w+hX2TNQ9d3Jy4XIxg6K+yDvyUk7XbvOH2Y7fm8GzXL4ak06jW0Gte0uu0XbElU5edGYfo
	/EJ8L2HTDspGdrITfl8fkjKB3B16XpWA0PeZ/E/rvY3D9+bYOsIE5yrnesp8joo/KJN+cU
	2IqSx7uSxXdNAj0/M/lGjR1t/6m5zF8=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	zenghui.yu@linux.dev,
	wanghaibin.wang@huawei.com
Subject: [PATCH] KVM: arm64: Fix various comments
Date: Wed, 28 Jan 2026 15:52:08 +0800
Message-Id: <20260128075208.23024-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

Use tab instead of whitespaces, as well as 2 minor typo fixes.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h    | 2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c   | 2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac7f970c7883..96f254f616a0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -201,7 +201,7 @@ struct kvm_s2_mmu {
 	 * host to parse the guest S2.
 	 * This either contains:
 	 * - the virtual VTTBR programmed by the guest hypervisor with
-         *   CnP cleared
+	 *   CnP cleared
 	 * - The value 1 (VMID=0, BADDR=0, CnP=1) if invalid
 	 *
 	 * We also cache the full VTCR which gets used for TLB invalidation,
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index f28c6cf4fe1b..b254d442e54e 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -205,7 +205,7 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 
 	/*
 	 * When running a normal EL1 guest, we only load a new vcpu
-	 * after a context switch, which imvolves a DSB, so all
+	 * after a context switch, which involves a DSB, so all
 	 * speculative EL1&0 walks will have already completed.
 	 * If running NV, the vcpu may transition between vEL1 and
 	 * vEL2 without a context switch, so make sure we complete
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 61b44f3f2bf1..a2ccef116483 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -57,7 +57,7 @@ static int lr_map_idx_to_shadow_idx(struct shadow_if *shadow_if, int idx)
  * as the L1 guest is in charge of provisioning the interrupts via its own
  * view of the ICH_LR*_EL2 registers, which conveniently live in the VNCR
  * page.  This means that the flow described above does work (there is no
- * state to rebuild in the L0 hypervisor), and that most things happed on L2
+ * state to rebuild in the L0 hypervisor), and that most things happen on L2
  * load/put:
  *
  * - on L2 load: move the in-memory L1 vGIC configuration into a shadow,
-- 
2.34.1

