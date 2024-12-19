Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3911C4A12
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648133; cv=none; b=VGqq00iS8PDQX6xLW5y6UGMbtSUH88TawE9KhiL/WgysSUQ8RxfaCGDFhvT1A0oKwBTEIccJU+vnTa4q1YgLzwS8I8HexQPsFK5II34n0X4AnS0mBPPPyoOpo7ahLlwIY9k71lHj8c0MQOBznDlimqhGBGQ83iAEtWMbe0nC4xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648133; c=relaxed/simple;
	bh=704kRvMD3ezrGkCR1doEKeRI9B/BkiRsrU3+wvkThg4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f2Tx0iSFmtkyUzfRkUwoc6eGBf/hyYki5L+wxJzYQ5Q8v15hfg881ToV45vwr/ZS/b4DUWEXBfwoUdjSmoLUG5YMZJPZvec1LWzGyfimwQOrqsYoMLrkeHOktnE1KkEPAJZFGkPUbA409/nRz4jZOCqrdk0LejPhtozXWkL8eO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IgBNAS9M; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IgBNAS9M"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MvD1c26tddUHW2pdNX5TiKWxS+wfvLjBr8Hdq2XPJ9Q=;
	b=IgBNAS9MbUG21GMeDmZMxE93gTyEBvZiI3/pnKTr9KUCn8nuE/zzHHitRi9TipBcFFIYZg
	Legw1ef7ie1OC+a5/uYga9WkZCgmqxLogl1EfwhBQMzDlQJcsqbiL1Mk0zIsSzPB3b76WK
	KDqLgg3YxZxe95w1xxqT0cYRwJvF7vc=
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
Subject: [PATCH v4 18/19] KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set
Date: Thu, 19 Dec 2024 14:41:15 -0800
Message-Id: <20241219224116.3941496-19-oliver.upton@linux.dev>
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

There is a nauseating amount of boilerplate for accessing the
breakpoint and watchpoint registers. Fold everything together into a
single set of accessors and select the right storage based on the sysreg
encoding.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 197 +++++++++++++-------------------------
 1 file changed, 69 insertions(+), 128 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ed4adbf5a25e..d9c7911ec58a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -658,143 +658,78 @@ static void dbg_to_reg(struct kvm_vcpu *vcpu,
 	p->regval = (*dbg_reg & mask) >> shift;
 }
 
-static bool trap_bvr(struct kvm_vcpu *vcpu,
-		     struct sys_reg_params *p,
-		     const struct sys_reg_desc *rd)
-{
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
-
-	if (p->is_write)
-		reg_to_dbg(vcpu, p, rd, dbg_reg);
-	else
-		dbg_to_reg(vcpu, p, rd, dbg_reg);
-
-	return true;
-}
-
-static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		   u64 val)
-{
-	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = val;
-	return 0;
-}
-
-static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		   u64 *val)
-{
-	*val = vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
-	return 0;
+static u64 *demux_wb_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	struct kvm_guest_debug_arch *dbg = &vcpu->arch.vcpu_debug_state;
+
+	switch (rd->Op2) {
+	case 0b100:
+		return &dbg->dbg_bvr[rd->CRm];
+	case 0b101:
+		return &dbg->dbg_bcr[rd->CRm];
+	case 0b110:
+		return &dbg->dbg_wvr[rd->CRm];
+	case 0b111:
+		return &dbg->dbg_wcr[rd->CRm];
+	default:
+		KVM_BUG_ON(1, vcpu->kvm);
+		return NULL;
+	}
 }
 
-static u64 reset_bvr(struct kvm_vcpu *vcpu,
-		      const struct sys_reg_desc *rd)
+static bool trap_dbg_wb_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = rd->val;
-	return rd->val;
-}
+	u64 *reg = demux_wb_reg(vcpu, rd);
 
-static bool trap_bcr(struct kvm_vcpu *vcpu,
-		     struct sys_reg_params *p,
-		     const struct sys_reg_desc *rd)
-{
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
+	if (!reg)
+		return false;
 
 	if (p->is_write)
-		reg_to_dbg(vcpu, p, rd, dbg_reg);
+		reg_to_dbg(vcpu, p, rd, reg);
 	else
-		dbg_to_reg(vcpu, p, rd, dbg_reg);
+		dbg_to_reg(vcpu, p, rd, reg);
 
 	return true;
 }
 
-static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		   u64 val)
-{
-	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = val;
-	return 0;
-}
-
-static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		   u64 *val)
-{
-	*val = vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
-	return 0;
-}
-
-static u64 reset_bcr(struct kvm_vcpu *vcpu,
-		      const struct sys_reg_desc *rd)
+static int set_dbg_wb_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			  u64 val)
 {
-	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = rd->val;
-	return rd->val;
-}
+	u64 *reg = demux_wb_reg(vcpu, rd);
 
-static bool trap_wvr(struct kvm_vcpu *vcpu,
-		     struct sys_reg_params *p,
-		     const struct sys_reg_desc *rd)
-{
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
-
-	if (p->is_write)
-		reg_to_dbg(vcpu, p, rd, dbg_reg);
-	else
-		dbg_to_reg(vcpu, p, rd, dbg_reg);
-
-	return true;
-}
-
-static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		   u64 val)
-{
-	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = val;
-	return 0;
-}
+	if (!reg)
+		return -EINVAL;
 
-static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		   u64 *val)
-{
-	*val = vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
+	*reg = val;
 	return 0;
 }
 
-static u64 reset_wvr(struct kvm_vcpu *vcpu,
-		      const struct sys_reg_desc *rd)
-{
-	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = rd->val;
-	return rd->val;
-}
-
-static bool trap_wcr(struct kvm_vcpu *vcpu,
-		     struct sys_reg_params *p,
-		     const struct sys_reg_desc *rd)
+static int get_dbg_wb_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			  u64 *val)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
-
-	if (p->is_write)
-		reg_to_dbg(vcpu, p, rd, dbg_reg);
-	else
-		dbg_to_reg(vcpu, p, rd, dbg_reg);
+	u64 *reg = demux_wb_reg(vcpu, rd);
 
-	return true;
-}
+	if (!reg)
+		return -EINVAL;
 
-static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		   u64 val)
-{
-	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = val;
+	*val = *reg;
 	return 0;
 }
 
-static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-		   u64 *val)
+static u64 reset_dbg_wb_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
 {
-	*val = vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
-	return 0;
-}
+	u64 *reg = demux_wb_reg(vcpu, rd);
 
-static u64 reset_wcr(struct kvm_vcpu *vcpu,
-		      const struct sys_reg_desc *rd)
-{
-	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
+	/*
+	 * Bail early if we couldn't find storage for the register, the
+	 * KVM_BUG_ON() in demux_wb_reg() will prevent this VM from ever
+	 * being run.
+	 */
+	if (!reg)
+		return 0;
+
+	*reg = rd->val;
 	return rd->val;
 }
 
@@ -1303,13 +1238,17 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
-	  trap_bvr, reset_bvr, 0, 0, get_bvr, set_bvr },		\
+	  trap_dbg_wb_reg, reset_dbg_wb_reg, 0, 0,			\
+	  get_dbg_wb_reg, set_dbg_wb_reg },				\
 	{ SYS_DESC(SYS_DBGBCRn_EL1(n)),					\
-	  trap_bcr, reset_bcr, 0, 0, get_bcr, set_bcr },		\
+	  trap_dbg_wb_reg, reset_dbg_wb_reg, 0, 0,			\
+	  get_dbg_wb_reg, set_dbg_wb_reg },				\
 	{ SYS_DESC(SYS_DBGWVRn_EL1(n)),					\
-	  trap_wvr, reset_wvr, 0, 0,  get_wvr, set_wvr },		\
+	  trap_dbg_wb_reg, reset_dbg_wb_reg, 0, 0,			\
+	  get_dbg_wb_reg, set_dbg_wb_reg },				\
 	{ SYS_DESC(SYS_DBGWCRn_EL1(n)),					\
-	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
+	  trap_dbg_wb_reg, reset_dbg_wb_reg, 0, 0,			\
+	  get_dbg_wb_reg, set_dbg_wb_reg }
 
 #define PMU_SYS_REG(name)						\
 	SYS_DESC(SYS_##name), .reset = reset_pmu_reg,			\
@@ -3523,18 +3462,20 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
  * None of the other registers share their location, so treat them as
  * if they were 64bit.
  */
-#define DBG_BCR_BVR_WCR_WVR(n)						      \
-	/* DBGBVRn */							      \
-	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_bvr, NULL, n }, \
-	/* DBGBCRn */							      \
-	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_bcr, NULL, n },	      \
-	/* DBGWVRn */							      \
-	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_wvr, NULL, n },	      \
-	/* DBGWCRn */							      \
-	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_wcr, NULL, n }
-
-#define DBGBXVR(n)							      \
-	{ AA32(HI), Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_bvr, NULL, n }
+#define DBG_BCR_BVR_WCR_WVR(n)							\
+	/* DBGBVRn */								\
+	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 4),			\
+	  trap_dbg_wb_reg, NULL, n },						\
+	/* DBGBCRn */								\
+	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_dbg_wb_reg, NULL, n },	\
+	/* DBGWVRn */								\
+	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_dbg_wb_reg, NULL, n },	\
+	/* DBGWCRn */								\
+	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_dbg_wb_reg, NULL, n }
+
+#define DBGBXVR(n)								\
+	{ AA32(HI), Op1( 0), CRn( 1), CRm((n)), Op2( 1),			\
+	  trap_dbg_wb_reg, NULL, n }
 
 /*
  * Trapped cp14 registers. We generally ignore most of the external
-- 
2.39.5

