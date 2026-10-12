Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1AC4ACC69
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821747; cv=none; b=j2aoR7flxy3zbq0b0PwXFYB5jPpXZYV+t15hB+/Most+YFCf6oUpDNBJWH5g66voavpmt81o59g1DOB5f6DsNoXCk5Z5bbnzqLZTPrqgCl4V3zwg6O+9ETxvWZvBJg5pK/TfCA/dytQWtAGq1rnmY+/xhOnO8RWPiUqoGwKnPsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821747; c=relaxed/simple;
	bh=o7DFXgB7gt6JJSGpUWCP61Fwkd7G9jFVrpvO58x0yzY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NMe3/M8QQrmNYbe8WTLYU5YV6ifUTt2xeXYMGEnXWBK/F+6RIykbSt82QL8PIckpq/V4XrzFixtKVPgDzhrP3oawkGi+Y4e//OotnCSJdIAipc91/vF465NhDOwFpmQUyF56FSQY8MXSXOyB8QR2Yo85++nWVdZeuO/eI7D4nSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1I7JqKv; arc=none smtp.client-ip=91.218.175.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1I7JqKv"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=o7DFXgB7gt6JJSGpUWCP61Fwkd7G9jFVrpvO58x0yzY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791821743; v=1; x=1792426543;
 b=v1I7JqKv0A4pu4KQCydGJ/aRNeXNNUp6kEFfLJPQSyfRH3tLXG+SDPpHrVL0S7MQQrz0Zaj8
 tr25OBH8mVLd1F6fXR599w28M1QgmNHtQM7aOkr3hbC2WV/R/fYqJzunL12paHdpsWpv4oNhBpj
 t/W3m+mnwZQ/9WFEKyAw4Lfo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 14a0d496e56a0a12;
	Mon, 12 Oct 2026 16:15:43 +0000
X-Mizu-Trace-ID: 14a0d496e56a0a12
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
Subject: [PATCH v3 4/5] KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
Date: Mon, 12 Oct 2026 17:15:23 +0100
Message-Id: <20261012161524.4016464-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261012161524.4016464-1-fuad.tabba@linux.dev>
References: <20261012161524.4016464-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

can_access_vgic_from_kernel() requires VHE only for the GICv3 system
register interface, so on a native GICv5 system without
FEAT_GCIE_LEGACY it returns true under nVHE. The kernel then saves and
restores the CPU interface from EL1, where ICH_VMCR_EL2 and the
ICH_PPI_* registers are UNDEFINED, and running a vCPU oopses the host.
The nVHE world switch already does that work at EL2.

Anything that requires EL2 system registers or instructions is out of
reach of a kernel running at EL1, which leaves GICv2, the one
memory-mapped CPU interface. Allow GICv2 from EL1 and require VHE for
everything else.

Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
Suggested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index b25303d9919fd..fe5b14a8b1214 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1045,11 +1045,10 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 static inline bool can_access_vgic_from_kernel(void)
 {
 	/*
-	 * GICv2 can always be accessed from the kernel because it is
-	 * memory-mapped, and VHE systems can access GICv3 EL2 system
-	 * registers.
+	 * GICv2 is memory-mapped. Every other CPU interface uses EL2 system
+	 * registers, which only VHE can access from the kernel.
 	 */
-	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
+	return has_vhe() || kvm_vgic_global_state.type == VGIC_V2;
 }
 
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
-- 
2.39.5

