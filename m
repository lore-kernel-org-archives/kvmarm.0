Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF0E3815CA
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240127; cv=none; b=WwVmrAt6Ht0p7J8Xy27OwDRYQ7cK58AUo/UoQeRHJSwDOEg7gDgciENkF6Yv1uFyeONyyFaVNfsAknhc0L7YNHSyeX1k+20hE1kVfiZrSxXCVjCRlSDHiQrn5ZQqruUmkw2s+HnqZtVbEQjBaBy07qa0IRku72eZ/POF0r0FbJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240127; c=relaxed/simple;
	bh=Cr9JNkRfkq0dI0di4ByX3o5AFx8SaFq23nwJMLKYq2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH58AZBz3/djwwxg5lrOlWtnUQwHsZEcPsmgMvhgi1HsUHnQYvxyo3K2ZjB1jlPCAXBjaWDfzKrq9xjAsL5FgUg3BjtHz7RAVvwKLTnZpw1l9VJDRdfLhG40JuBg+EyB4FhrSBl0ikFhUOaZsUGyff8fc7V3TYfCib2WuWE6oWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ef9lE6JJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ef9lE6JJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA111F000E9;
	Tue, 23 Jun 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240126;
	bh=PokYzO4TzwO5144nEq+b6QnOHw/7DoZlUG0yRlhDa44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ef9lE6JJOE5PubnM7rmBGB1hzNWZDs92R70r1Fe/K1mRlP3/MyS6Ex+E+6MqhkXLE
	 kJyD2IQPAvdreCsd+buqOzZI9Um4WGofCTrIacv8HEK70L8ElLY9rbu7z+3tFFBVIY
	 2Vka9K4ITQpgzXrSbM0/2osj91hM0YnKx3vFZIyjCA/NTBCk1+S46EATwlTA3phzwP
	 M9Y5rw9EROn0BQsguEMJto7KLvOaYb0ZgSpuIFNymdXCfrE0EgH4LruW94RR9/Qc8p
	 97QEogRD2PNDlgS1mVI2G/ASYdzSTsPTaTS8lms8fJZOFHZKpuFcFHdFBtOey+agim
	 2nfFNRFh053Eg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 07/22] KVM: arm64: nv: Set dirty state at stage-2
Date: Tue, 23 Jun 2026 11:41:46 -0700
Message-ID: <20260623184201.1518871-8-oupton@kernel.org>
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

Set the dirty state on descriptors at stage-2 for write accesses when
DBM is set.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 43 +++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index a70af3b3f05d..e5a407fc0880 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -132,6 +132,7 @@ struct s2_walk_info {
 	unsigned int	t0sz;
 	bool		be;
 	bool		ha;
+	bool		hd;
 };
 
 struct s2_walk_step {
@@ -227,6 +228,20 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
 	return 0;
 }
 
+static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
+				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
+{
+	switch (access->type) {
+	/* R_RKMHW */
+	case WALK_ACCESS_CMO:
+	case WALK_ACCESS_AT:
+		return false;
+	default:
+		/* R_NSXRD */
+		return access->write && wi->hd && out->writable;
+	}
+}
+
 static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 			      struct s2_walk_step *ws, struct kvm_s2_trans *out,
 			      struct kvm_walk_access *access)
@@ -239,6 +254,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 	if (wi->ha)
 		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 
+	if (should_set_dirty_state(wi, ws, out, access))
+		new |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+
 	if (old == new)
 		return 0;
 
@@ -403,16 +421,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 		return 1;
 	}
 
-	ret = handle_desc_update(vcpu, wi, &ws, out, access);
-	if (ret)
-		return ret;
-
-	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
-		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ACCESS);
-		out->desc = ws.desc;
-		return 1;
-	}
-
 	addr_bottom += contiguous_bit_shift(ws.desc, wi, ws.level);
 
 	/* Calculate and return the result */
@@ -422,6 +430,20 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 	compute_s2_permissions(vcpu, wi, &ws, out);
 	out->level = ws.level;
 	out->desc = ws.desc;
+
+	ret = handle_desc_update(vcpu, wi, &ws, out, access);
+	if (ret)
+		return ret;
+
+	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
+		*out = (struct kvm_s2_trans) {
+			.esr	= compute_fsc(ws.level, ESR_ELx_FSC_ACCESS),
+			.desc	= ws.desc,
+		};
+
+		return 1;
+	}
+
 	return 0;
 }
 
@@ -518,6 +540,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
 			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
 	wi->ha = vtcr & VTCR_EL2_HA;
 	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
+	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
-- 
2.47.3

