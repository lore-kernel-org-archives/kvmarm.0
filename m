Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788978;
	b=fZ5HYZpWguLPqsFT6S0D0/mm9jO52ddNqceWm6bv5vWTIW6LigMI591HldRUOGUcERjB
	 2k3czDTfoXZz7kZafIvQzlwoobsS4H6R55OS/NSWIYjB3BqmL5CtykwfLubaJK4UZr7XJ
	 lCLhdceOvx8lQjULxU16E5u2YAUCt2mWytHLuiTjFEeY26SJYctZsCOqcJY2VPhjyOaID
	 EEBMCHRaeliyITQudoAFk8WWo3a4JVds+FiIy+CPZh4r7uyt4+ExTrEY5P+CsR/c6EruI
	 r92Zm7+TB77xDJgarzAYGUd7hKbX1LDHfHdd61GufaC9dAtC0UgrO/gVtFRx5oH3exg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LcjXc2xhl8d785yS3fcsKwxoYMNOUdGdhht2hE9FD+w=;
	b=31Eo5dGQ5Hs75WnBt+ty1+lXSQLiOzr3NlFQ3WERcNLFlrCqchGL4XAo/igDoRW2r+ht
	 73o/OX0AQgV//a3fqKUBhFKG9xNMS9QGb0m7r3y6fKsM3DH+aPx1/NWNOE69Reyk2B2rH
	 8HlWMLhp4+1vwRBrTEKRR8O7FSyFAvVO72I4tfMK42BW17wW84nkY4AHlZDaYR80gtzwH
	 MN9iF+LTFvLdpib3ihEUvbA23iw1eDpbPByUlpYg19hzrJXAcVeKeI8nG5sputXNXYw+9
	 IBqK4+9EnaGbMtB2N3VrF9sf5uEIc5IkOPzMWxdo5MQZOcGPc3QXv3cPox9TbPB+Jmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqXmWFW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97CD606A326
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqXmWFW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76171F031E7;
	Fri, 23 Oct 2026 20:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788977;
	bh=LcjXc2xhl8d785yS3fcsKwxoYMNOUdGdhht2hE9FD+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqXmWFW8E14FuZSF7erzgx9/UR+EP4zDDMUPO04vIvxMhp10YeTNMcvC1++dPaYtt
	 ifmaOX8VNKKL7GmtCqpDV9Muzz+/s3Ok/6nfU8XvGTDjyHlOSBrrQQOpZM2W2PO5Oh
	 8R19KGGXk+ZXpW3vMqoM3TNBMydq9iyjw60EQoGMqWJMm7Osp6+Dmqywq+lvHpWQS2
	 wkWJBGaBvhqiEry7DZrGafHw/vWZcYVLm1Pyf91hntk3/Ez3+aD0+1+ccDTmcKmaAW
	 aeFjecjliAdx+LpxTt0zow/PC4MFC0Q0VEzajs3eUp8qTDqKPgFB8Yf4+NIuoAWsF5
	 kZpzakondpQ/Q==
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
Subject: [PATCH v2 09/28] KVM: arm64: Compute S1 permissions as part of s1_walk()
Date: Fri, 23 Oct 2026 13:55:51 -0700
Message-ID: <20261023205610.1044532-10-oupton@kernel.org>
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

Implementing support for hardware dirty state means that the table
walker needs to have visibility into the permissions on the final
translation.

Compute the S1 permissions as part of s1_walk() and initialize
s1_walk_result before checking all fault conditions. The appropriate
fields will be reinitialized if the walk happens to fail at a later
point.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 32d2e57b017c..3031f5855316 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -459,6 +459,10 @@ static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
 	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
 }
 
+static void compute_s1_permissions(struct kvm_vcpu *vcpu,
+				   struct s1_walk_info *wi,
+				   struct s1_walk_result *wr);
+
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		   struct s1_walk_result *wr, u64 va)
 {
@@ -588,6 +592,20 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
 		goto addrsz;
 
+	va_bottom += contiguous_bit_shift(desc, wi, level);
+
+	wr->failed = false;
+	wr->level = level;
+	wr->desc = desc;
+	wr->pa = baddr & GENMASK(52, va_bottom);
+	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
+
+	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
+	if (wr->nG)
+		wr->asid = get_asid_by_regime(vcpu, wi->regime);
+
+	compute_s1_permissions(vcpu, wi, wr);
+
 	if (wi->ha)
 		new_desc |= PTE_AF;
 
@@ -613,18 +631,6 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		return -EACCES;
 	}
 
-	va_bottom += contiguous_bit_shift(desc, wi, level);
-
-	wr->failed = false;
-	wr->level = level;
-	wr->desc = desc;
-	wr->pa = baddr & GENMASK(52, va_bottom);
-	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
-
-	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
-	if (wr->nG)
-		wr->asid = get_asid_by_regime(vcpu, wi->regime);
-
 	return 0;
 
 addrsz:
@@ -1363,8 +1369,6 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 	if (ret)
 		goto compute_par;
 
-	compute_s1_permissions(vcpu, &wi, &wr);
-
 	switch (op) {
 	case OP_AT_S1E1RP:
 	case OP_AT_S1E1R:
@@ -1689,15 +1693,10 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		wr->ur = wr->uw = wr->ux = true;
 		wr->pr = wr->pw = wr->px = true;
 		wr->dirty = true;
-	} else {
-		ret = walk_s1(vcpu, wi, wr, va);
-		if (ret)
-			return ret;
-
-		compute_s1_permissions(vcpu, wi, wr);
+		return 0;
 	}
 
-	return 0;
+	return walk_s1(vcpu, wi, wr, va);
 }
 
 struct desc_match {
-- 
2.47.3

