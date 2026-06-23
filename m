Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC30338D6A9
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240128; cv=none; b=gjj/A9iQLgKQmd9XAcC7bciP1+GJkhf7duYxUeTZlatxCqCPVznEtWWxwuiIre3wqkLbSDZD04+LqGEpy8XysSaovo/pyTbDMqC2P6pXg1Cqxmmdi9XxDbEzHWycgAxeiPK35xn/EwWePa2rcF3tZtUJbYEMQPxSbgrkQaG7AlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240128; c=relaxed/simple;
	bh=FoPk5rmAPLcutr5cyGrXopmwTaLOM6yrDX6wa57+jzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO1A54x5IEqAWK4pYokCsErQY3RufMcQoq+BMD1xNkU/zwNY1s/Cl+v4TiUvI+4Rzk271TuPpdIpM9jARLbeH3q2mBNRXQ/LeeucaNsQEnTDLGN3pNQm9WxH7YauYVAM51cQwKShQc69E8s71gAPeE2jkgdm2p4BwJxdZsrMtKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TB+f6FeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TB+f6FeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECC41F00ACA;
	Tue, 23 Jun 2026 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240127;
	bh=BHpXPRuZwICIX8myBS8iAKPrgK0ACV10LPOzJICXEhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TB+f6FeRItAyL/Hng7DgACOv7uMu5HP7JfIkE2bAG9WCQKnDF6cvJ8aFkSa+2IG60
	 XOgPXTjnCdVZmtcS03yWwT2cSlTzqHSTdD1b0t5CwJ3G3LIZIKmMD4yUAq3412+fe6
	 FUHGUi0Uoi+MWF9Svlu7f63KGduhghNSdtXUAxpaDN5wzQAZ+L7DwbAhqH4asC6Kjx
	 V/y4gf/dtROPFNidoMaQdvey1UW4lrvwStwnFt9fWbo0bqpYajO8CePiAXBJdTxFDI
	 k04BkLsyKebiWFXe4AhV1U156FYz68wdyyceYJlStFqG5CfFF/pxSQcOi5xN+7oIlp
	 4kzVLj+8LKatQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 12/22] KVM: arm64: Create helper for stage-1 descriptor updates
Date: Tue, 23 Jun 2026 11:41:51 -0700
Message-ID: <20260623184201.1518871-13-oupton@kernel.org>
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

Prepare for FEAT_HAFT support by creating a helper for descriptor
updates to be used for both leaf and table descriptors.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 52 ++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 816d23e7752d..0218176107b5 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -455,9 +455,28 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
 	return 0;
 }
 
-static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
-			    struct s1_walk_info *wi)
+static int handle_desc_update(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
+			      struct s1_walk_step *ws, struct s1_walk_result *wr,
+			      struct kvm_walk_access *access)
 {
+	u64 old, new;
+	int ret;
+
+	old = new = ws->desc;
+
+	if (wi->ha)
+		new |= PTE_AF;
+
+	if (new == old)
+		return 0;
+
+	if (wi->s2 && !ws->s2_trans.writable) {
+		fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(ws->level), true);
+		return -EPERM;
+	}
+
+	ws->desc = new;
+
 	if (wi->be) {
 		old = (__force u64)cpu_to_be64(old);
 		new = (__force u64)cpu_to_be64(new);
@@ -466,7 +485,12 @@ static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
 		new = (__force u64)cpu_to_le64(new);
 	}
 
-	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
+	ret = __kvm_at_swap_desc(vcpu->kvm, ws->desc_pa, old, new);
+	if (!ret || ret == -EAGAIN)
+		return ret;
+
+	fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws->level), false);
+	return ret;
 }
 
 static void compute_s1_permissions(struct kvm_vcpu *vcpu,
@@ -617,25 +641,9 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 	compute_s1_permissions(vcpu, wi, wr);
 
-	if (wi->ha)
-		new_desc |= PTE_AF;
-
-	if (new_desc != ws.desc) {
-		if (wi->s2 && !ws.s2_trans.writable) {
-			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(ws.level), true);
-			return -EPERM;
-		}
-
-		ret = kvm_swap_s1_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
-		if (ret == -EAGAIN)
-			return ret;
-		if (ret) {
-			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(ws.level), false);
-			return ret;
-		}
-
-		ws.desc = new_desc;
-	}
+	ret = handle_desc_update(vcpu, wi, &ws, wr, access);
+	if (ret)
+		return ret;
 
 	if (!(ws.desc & PTE_AF)) {
 		fail_s1_walk(wr, ESR_ELx_FSC_ACCESS_L(ws.level), false);
-- 
2.47.3

