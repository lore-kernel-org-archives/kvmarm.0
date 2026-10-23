Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788977;
	b=tvCMr87D0RAqKbdVSPlFbOyM5mZnGnWIQA2Y++hZxD5ePA1SiFYkaXqlTh84Uw20vuTN
	 U9xuSEsP0v+e/tL28Uo+rjR92jtNWBg3d7rUpWxRbrxbfZHjvPMU7msIeeuGD7s5bDUFv
	 XXA+fRWMZdImkIHNKPRbbs5Bak43Pl6588Q/gbSZ7DCja+6n2bIuERDMypQ3V5ucjNQsC
	 kgGbLn3GCnb6bvS2bz6WFp9VGY0W184nLyV3IbHb87Rdcy7r1fvzk7M62ayqfPpmMTVyr
	 rfESgsbBazIulaxaxsBt981KfHbnn1SqYFwcj+r5KEr1GDmJTwxKjcvRO/rSi0wRn7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=m7QFKdFEwomwpXn1vlKr0DWJa49AevbNDo3W/iY6ERc=;
	b=uSPc/ZBkkpjgg7Wt5Rh3mGMl0xUFCQCOl58/VhzD6EJvpft16K1laZ9XQUZb6VjJXt9I
	 FfFH+bd9FvTaBjfN2X/74aS/WT+6hifrPv8oUPhE9H6AtX9PN+0BqBOteuSFQVjuZViPy
	 IDbBw9EznSCU5M3xHluwIRh/jji+EnCj52f5cartJhbaSklzZ1NtMD58SY/ZPilhWdYSU
	 UNxAdEnTWrlg5KqsYavhJsQEs91tK0isIce8CajXuvCM7y45jxE5TUTOweYDnQVD0CKkD
	 NkCIieltT1mAntFpfi4fhmpzpT0aPSqbGMkIIuYUsezTlB83l6MEClCktqMovYHP05g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvSwp0dx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EC8606A321
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvSwp0dx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BEA1F031E6;
	Fri, 23 Oct 2026 20:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788977;
	bh=m7QFKdFEwomwpXn1vlKr0DWJa49AevbNDo3W/iY6ERc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvSwp0dxFd1KcBV4JhLPJ7RiR1Q/lzF1QxX0GY869L8cwirE61MF1V+Wh5/ogli4f
	 3kiy0BGAoxmqJ/hBk54YjkwgDskjkr1cQM4dSoZIqUg/M6oZ/GAAKrMmNqbbPZ43ep
	 uUWWwhz1kmBBLtGKi81pIA7CGsP7pG4ATjE+VXPIxr9UnymiUnpb0RDM3KDB7yZ009
	 cDGQFucl55UKDy+bFvCjZu4jb6jtJy8sKeTYPK/vU3oHYOY6rHwTLi3dZ+wE8rEhjp
	 AuraHxLezXlLMDKCFBNx44IxWhKpsLxU9MK4+vuY0dUDrilopumomiUp8bjoBQ5Bn2
	 QbT6A6i3cVVVw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 07/28] KVM: arm64: nv: Set dirty state at stage-2
Date: Fri, 23 Oct 2026 13:55:49 -0700
Message-ID: <20261023205610.1044532-8-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the dirty state on descriptors at stage-2 for write accesses when
DBM is set.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 51 +++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dea5c31f10df..1d581d3bd557 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -151,6 +151,7 @@ struct s2_walk_info {
 	unsigned int	t0sz;
 	bool		be;
 	bool		ha;
+	bool		hd;
 };
 
 struct s2_walk_step {
@@ -246,6 +247,20 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
 	return 0;
 }
 
+static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
+				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
+{
+	switch (access->type) {
+	/* R_ZYGHJ */
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
@@ -258,6 +273,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 	if (wi->ha)
 		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 
+	if (should_set_dirty_state(wi, ws, out, access))
+		new |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+
 	if (old == new)
 		return 0;
 
@@ -272,11 +290,15 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
 	}
 
 	ret = __kvm_at_swap_desc(vcpu->kvm, ws->desc_pa, old, new);
-	if (!ret || ret == -EAGAIN)
+	if (ret == -EAGAIN)
 		return ret;
+	if (!ret) {
+		out->desc = ws->desc;
+		out->dirty = out->desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+		return 0;
+	}
 
 	out->esr = ESR_ELx_FSC_SEA_TTW(ws->level);
-	out->desc = ws->desc;
 	return 1;
 }
 
@@ -422,16 +444,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
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
@@ -441,6 +453,20 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
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
 
@@ -537,6 +563,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
 			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
 	wi->ha = vtcr & VTCR_EL2_HA;
 	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
+	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);
 }
 
 int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
-- 
2.47.3

