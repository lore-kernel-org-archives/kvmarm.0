Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8886438D6BD
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240127; cv=none; b=TqXFX659QmRYSeNkhdwCXO8+L7GwRxAmbDgRkmGFdUL7Hn9V7H8Z8aonx76TOCZUMTueW7fPr1QvYuaemt/TsptKfUJRlFrqfjkWvX0xeZ641g5I1Qs1+LxA3RwVjgQGCc85bpe1It4x0Jxt+THLVqlA5PAv1nspfhO4cRCez5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240127; c=relaxed/simple;
	bh=Nskm2fz3M70aPzq9UmSZ1HwmWU6Ol9RUjb3R7YfL6FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR5Y7jvxVNiQfaYmhFGvUynVQGcrVMI04zcodafMQms20/5kqbPEbQMBgrnti6RHFpydkMOTyGuo9SXTy7o7uF3OWH0RsbFLhj+0rDOSpmOg+tG6qaJi4cpW5BTmClPOTwhxPofpUnagMTo5Rq8nzveYbh7GcAz3z43OOwFRFFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8wCYrLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8wCYrLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557701F00ACF;
	Tue, 23 Jun 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240126;
	bh=jdvglPtXveGFdY7L1L3/DQC1mSjBZ9+mdOlIfehpNyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8wCYrLjnim+c/ggPobxu9+tT+M5DvXULj5ReD0DJQK5xMaQTNA6q23/+dNkk1A/F
	 XOxX3+ISGrtwGC5dvJ5iB2ugvKPLPgBgGdaW3dM3If4J+OKe7bRl3KX688KNzUBrpX
	 afL+xX6Qg6XSwxu6XK59O5Hadv6cDj642Asg1IcY8jWbLy515tBer9ztSUZmMPnK/Z
	 bLj6Qwa1eJ0TXd8BMOJOEcf8UTbNqeLGsDRTneHFE6NnCN+t0Lkca/CjsidSfz6HUa
	 t2B0vl2Omkrcb/7C3wkTtgQ1B3MWq2A6a/zfpskrlR2QY0iL9AniIWKmSSOPCjHnnf
	 /QXSWkcu0MTXA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 06/22] KVM: arm64: nv: Use a helper for stage-2 descriptor updates
Date: Tue, 23 Jun 2026 11:41:45 -0700
Message-ID: <20260623184201.1518871-7-oupton@kernel.org>
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

Use a helper for handling stage-2 descriptor updates so the
implementation can be shared with updates to table descriptors.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 47 +++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c2fb7290f0c8..a70af3b3f05d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -227,9 +227,23 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
 	return 0;
 }
 
-static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u64 new,
-			      struct s2_walk_info *wi)
+static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
+			      struct s2_walk_step *ws, struct kvm_s2_trans *out,
+			      struct kvm_walk_access *access)
 {
+	u64 old, new;
+	int ret;
+
+	old = new = ws->desc;
+
+	if (wi->ha)
+		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+
+	if (old == new)
+		return 0;
+
+	ws->desc = new;
+
 	if (wi->be) {
 		old = (__force u64)cpu_to_be64(old);
 		new = (__force u64)cpu_to_be64(new);
@@ -238,7 +252,13 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
 		new = (__force u64)cpu_to_le64(new);
 	}
 
-	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
+	ret = __kvm_at_swap_desc(vcpu->kvm, ws->desc_pa, old, new);
+	if (!ret || ret == -EAGAIN)
+		return ret;
+
+	out->esr = ESR_ELx_FSC_SEA_TTW(ws->level);
+	out->desc = ws->desc;
+	return 1;
 }
 
 static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
@@ -287,7 +307,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 	struct s2_walk_step ws = {};
 	phys_addr_t base_addr;
 	unsigned int addr_top, addr_bottom;
-	u64 new_desc;  /* page table entry */
 	int ret;
 
 	switch (BIT(wi->pgshift)) {
@@ -340,8 +359,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 			return ret;
 		}
 
-		new_desc = ws.desc;
-
 		/* Check for valid descriptor at this point */
 		if (!(ws.desc & KVM_PTE_VALID)) {
 			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
@@ -386,21 +403,9 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 		return 1;
 	}
 
-	if (wi->ha)
-		new_desc |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
-
-	if (new_desc != ws.desc) {
-		ret = swap_guest_s2_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
-		if (ret == -EAGAIN)
-			return ret;
-		if (ret) {
-			out->esr = ESR_ELx_FSC_SEA_TTW(ws.level);
-			out->desc = ws.desc;
-			return 1;
-		}
-
-		ws.desc = new_desc;
-	}
+	ret = handle_desc_update(vcpu, wi, &ws, out, access);
+	if (ret)
+		return ret;
 
 	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
 		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ACCESS);
-- 
2.47.3

