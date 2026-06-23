Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396B838D6A9
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240130; cv=none; b=KpujkglsY3oa3x2CA2Ko6Z29mTzG5M1P0IRJAHvJ7f88s3VtWIa6VGbsChKfYZYeRXXICBCcnly2Iks+eARVtc/+34QTSjlFNL0Jlw84r/oaDAeOMNRQpFRDxJfAabFO13wk5ARp6o4rmZOjeew5wPNZllcYHjEd3xcmovjcylo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240130; c=relaxed/simple;
	bh=DVZ70FxGp+I1jNiKZPPorrHSCIPHJ5cjZu+sC3UhdVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AW4EAVV/P2LstI6rt5S4Gcx5oYPQ6uP7NedD0GLh7IUcGiyX5+Q/sR+Qr9hibMHgdmhxpgsyI+TQ48LkaaQfBi4vmnE/PG5V4QpT6XzoQ2yLH+N3UeBgwtC9o3kZSIw3XhiPIiE5bl9gb8nicCkMX/GLke7A2ySPU1TN0HBC5Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBDGBcPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBDGBcPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B80B1F00A3E;
	Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240129;
	bh=SgfWPY810Ic/5m2xddnEW4wkDjnd1fNtlRb164PWdHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBDGBcPU2//DkfMjUgV/u7y99f6NSM1NwHMdV9BQE2xwNqfgKDbL1+jWot9jPbgiH
	 8h6PVsSsZwuCL3iDjVo6Q/kx8TWqMvzErn+iOHG2L1L+U5gJ1APafPsCL7lfOHoT6S
	 kh7QhGYTmkSxr7naSpgLIPKnvP6OR7hYSrrZ6VQlMu2rfQB/dc1PxpVB4TmMzvy75w
	 J/j4N4EOxoWCxBOMcIHGfoYXSaR5iEG/1/YzjcopwRVn0q/Ob56TTWhEmIaXWmkMSF
	 XhKtxDztfaQEDiV23uaJE3uz9KSOOE2aZJ88lj9rqNrUl5wZMMPtbFSCJ0aZprQwL+
	 CQhxDBkgnBhHw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 18/22] KVM: arm64: nv: Set access flag on table descriptors at stage-2
Date: Tue, 23 Jun 2026 11:41:57 -0700
Message-ID: <20260623184201.1518871-19-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement access flag updates on table descriptors as required by
FEAT_HAFT.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2408d604a1e1..6f540d3481d5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -133,6 +133,7 @@ struct s2_walk_info {
 	bool		be;
 	bool		ha;
 	bool		hd;
+	bool		haft;
 };
 
 struct s2_walk_step {
@@ -234,12 +235,15 @@ static bool should_set_access_flag(struct s2_walk_info *wi, struct s2_walk_step
 	if (access->type == WALK_ACCESS_NONARCH)
 		return false;
 
-	return wi->ha;
+	return kvm_pte_table(ws->desc, ws->level) ? wi->haft : wi->ha;
 }
 
 static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
 				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
 {
+	if (kvm_pte_table(ws->desc, ws->level))
+		return false;
+
 	switch (access->type) {
 	/* R_RKMHW */
 	case WALK_ACCESS_CMO:
@@ -424,6 +428,10 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 			return 1;
 		}
 
+		ret = handle_desc_update(vcpu, wi, &ws, out, access);
+		if (ret)
+			return ret;
+
 		base_addr = ws.desc & GENMASK_ULL(47, wi->pgshift);
 
 		ws.level += 1;
@@ -562,6 +570,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
 	wi->ha = vtcr & VTCR_EL2_HA;
 	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
 	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);
+	wi->haft = wi->ha && (vtcr & VTCR_EL2_HAFT);
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
-- 
2.47.3

