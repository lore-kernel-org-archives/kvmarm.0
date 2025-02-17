Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6378D21771E
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739791459; cv=none; b=CLGc0rqVytcol0SR8Zap10OCOMgZ3wKw/6OjyQ1N6Ak0Zm1J36HhpT8hFHLLE3o//667NgKUmWtxHEAGhdVjOPXGciq3aNtHlLAhrXxHUI0DKfiv+G/8jRzxUnTiizKEJTY5+9whkzbN2l43KzszZnIo+hF8dEH+G3QpbNaE2js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739791459; c=relaxed/simple;
	bh=dYz+hTJxMRqs58+wHRFEMd3G0Mri3nv5zfDY/9xb8X0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VN9/4ecoeRGEs4Sb5RJbzVkYawcMLDLI+pScuuV4vzvQpHl+cIAd6/coX6B77rLdjn2kwKQizbXIGwAYVFCNrs3Bc28Qc+wlPL1IJQIwLGa+1Wt3ctNPuHNKUmptdBW9VZJfyaQU24cki/dnCD396KqnssJ0+hdU/SZ8heWa+sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GqQHP/CS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GqQHP/CS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C3DC4AF09;
	Mon, 17 Feb 2025 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739791459;
	bh=dYz+hTJxMRqs58+wHRFEMd3G0Mri3nv5zfDY/9xb8X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqQHP/CSer1zhF69pvmREx/y72TUZZFJ8cdBebmkEpqYCebvcVuiPcC/CudaH9T6i
	 B2hkkOe96Hzt21HsN8NPIylVz40fqwFDyJcpoqXeAEE2k92qkzVlL53T64DxcLFUkr
	 iYkdGVuuBgd6wJgZLUvY5Bfj5CFyVpp6aj1b/GRaF3rS3DIesYoCDGRTqSGmblzceD
	 tPeS5JWFLq1bgmRbDurWiJJ1BL1d3FHeugOuC4US2LwWI4+yqBRZdflF5epSMISNKj
	 nD1BPlznFwdADf4ybPxEk5iLiWD9UEwv+thXziRtCEUuj8cK1ikYFSiK8mb4JJQcBh
	 jAXaQX98VCwlg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjzEX-0052DP-06;
	Mon, 17 Feb 2025 11:24:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] KVM: arm64: Fix MDCR_EL2.HPMN reset value
Date: Mon, 17 Feb 2025 11:24:11 +0000
Message-Id: <20250217112412.3963324-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250217112412.3963324-1-maz@kernel.org>
References: <20250217112412.3963324-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The MDCR_EL2 documentation indicates that the HPMN field has
the following behaviour:

"On a Warm reset, this field resets to the expression NUM_PMU_COUNTERS."

However, it appears we reset it to zero, which is not very useful.

Add a reset helper for MDCR_EL2, and handle the case where userspace
changes the target PMU, which may force us to change HPMN again.

Reported-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 13 +++++++++++++
 arch/arm64/kvm/sys_regs.c |  7 ++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6c5950b9ceac8..5a71c3744c4d7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1007,6 +1007,19 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 
 	kvm->arch.arm_pmu = arm_pmu;
 	kvm->arch.pmcr_n = kvm_arm_pmu_get_max_counters(kvm);
+
+	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
+	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
+		struct kvm_vcpu *vcpu;
+		unsigned long i;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
+			val &= ~MDCR_EL2_HPMN;
+			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.pmcr_n);
+			__vcpu_sys_reg(vcpu, MDCR_EL2) = val;
+		}
+	}
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd02..380f22f19cb42 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2493,6 +2493,11 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	__vcpu_sys_reg(vcpu, r->reg) = vcpu->kvm->arch.pmcr_n;
+	return vcpu->kvm->arch.pmcr_n;
+}
 
 /*
  * Architected system registers.
@@ -3034,7 +3039,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
 	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
-	EL2_REG(MDCR_EL2, access_mdcr, reset_val, 0),
+	EL2_REG(MDCR_EL2, access_mdcr, reset_mdcr, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG_VNCR(HSTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HFGRTR_EL2, reset_val, 0),
-- 
2.39.2

