Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0FF1BDABE
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648104; cv=none; b=C/LTjivZqKkQ42aa1MlbR3TnefW49PJXKYntdXLy6C0ZZ0+jG9+tptz/w2fHPq0qMty/T6be+he2WzTxfyVpLuGOkHXRn0eV6sxWgqZz7jo0kBiFZu0WRA8xonqW+PV+i38MSD3V5E3fpNWnH8v7cbYolhB1XjOz85ZVzNuXMRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648104; c=relaxed/simple;
	bh=CHrITe3NLVxLXTk1/jhKyLUSymm1xdjlC2I+VvK4OyA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S6U33gYKxdRrxwdw84g/I+yo9K+LK3rn6f2SgMq2HX8joNh/ARSLtPITU29VdEAGrv0s4mWBKoNIse5mIjRkxJ72HXcCgJCFxR0BYiJHXLE+Z/ad06kZL+qanzNEYj/mTAhUTv/yTpVmoj+lGIoFhssziyfA7lhtqFHQ03eTnNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tce7Vqnx; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tce7Vqnx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a/vmkMJA+CCrEUZxcpcNeRHpuvrzIAZ7cUnrUc8+zKg=;
	b=Tce7VqnxDIhQXgZUuxtYsDKKPW2ilFJzCncXHKcV30nggqsXD7Dcy+VtlflupLygudURgg
	nKuN350ny5B/vsTwoLnkkbQ4JV9OaPuFWHrNJabtrBH0C2pLzN/Jxhpe1TeF3HkVJmkhuu
	Kh9PRSCO36YRg4HA9+neUDqzj0Umrdk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 05/19] KVM: arm64: Write MDCR_EL2 directly from kvm_arm_setup_mdcr_el2()
Date: Thu, 19 Dec 2024 14:41:02 -0800
Message-Id: <20241219224116.3941496-6-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Expecting the callee to know when MDCR_EL2 needs to be written to
hardware asking for trouble. Do the deed from kvm_arm_setup_mdcr_el2()
instead.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/debug.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 1ee2fd765b62..f01597f89067 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -73,6 +73,8 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
  */
 static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
+	preempt_disable();
+
 	/*
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
@@ -103,6 +105,12 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	    kvm_vcpu_os_lock_enabled(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 
+	/* Write MDCR_EL2 directly if we're already at EL2 */
+	if (has_vhe())
+		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+
+	preempt_enable();
+
 	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 }
 
@@ -250,10 +258,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
-	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
-	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
-		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
-
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
-- 
2.39.5

