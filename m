Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789009;
	b=UQxLojs1FGFYyl7XqDYLusKtcaU3qbWOKe/SOzD+fgerVoEt75AEDfrqr4mGmKsz91jc
	 h95d82CmG/RY+LEfggyTUp27ZeCAARHGbPQ15BY3Ye1vBDq3p+Op61MT8cZqcIs4akJES
	 MgaOeS6yX3J90FcM0pzHkahXyKCUZFvf/ICnLeZHnty0RDnMEAH7h1lGrreLHJCQBYs72
	 J/ojTTqee+VV9AK9gxY5HRdDyutGi9HrgJ+tMqNDHqh5tojzRiEZw++ieX970Mm76Qmu8
	 MyTBwtFW7qU6rdBk9mQzEx4CmfrRJfaWNU7YrUhZM547QVFObCfGrddRrjN4WV4m8Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=W57vn9a1xCDDS45D5jixNm9hXVYTDKQG77bDgNDSTWA=;
	b=n6DcIQx7phLBMXb4IUl7WTLG6NQuiNSTrJBMd7whtwXN+TxqbrGfJpNHrUZZTb4U+Sz6
	 MYhica/0GHHTmQTo/ZSv7JHPRCPJyf+CTTk/AA8YuEf02+dhkoGqDi98RB0EabI32Ozm3
	 fEQLDjnRbwbUQXzrzXWIcMhTy35S558qQjSVpyy+kNzSvqaEh7YD3pK3oCq5awP4zlthB
	 /02cmqSeAYu0qR9h//KLqC3hKQrKvkahytF9H4CGsiniEABNoZCsO0FVYTjwIZxi2mQ4w
	 e2BQyOf08WmM5f1PiBavjXhkS1TvkoSrz3/knO3Fhe+Kz3imhOh9Aq5XyjnQd74gz0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F4hz0C4d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37A2606A31E
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F4hz0C4d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFC31F031E2;
	Fri, 23 Oct 2026 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789008;
	bh=W57vn9a1xCDDS45D5jixNm9hXVYTDKQG77bDgNDSTWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4hz0C4direucFm2FKhx6ForOyPbWpJj6wJ5Zc1gnwzEQB1TGH8vf3+GYuB/oJDjt
	 0F/LjofEvpvcGLbMPlWH5+6AnVqNOOcgzOguqQsxc8r5dxMGZ0RCgI+dVmXv1/Vriq
	 wxY+kM6DuFL7xvsCitdnWNYF2OIY3KEZsdZ/iMUqVrOTwaDfab6eFykmdtQbR9lAIq
	 Op0vYrJnHlkuu0fuxOLS1VsYuiuz5t2wL9oRPejSgDzgjAi4SvrVH1i3SQvhdoCq7c
	 z8HdR3mDNkdO8x8Nx8/Iv+c+YQXuXFFukjcYGlUQiuCq+mDPPxB2GGwuNV4w3sWk7u
	 3AepjtJFtcs1Q==
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
Subject: [PATCH v2 12/28] KVM: arm64: Create helper for stage-1 descriptor updates
Date: Fri, 23 Oct 2026 13:55:54 -0700
Message-ID: <20261023205610.1044532-13-oupton@kernel.org>
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

Prepare for FEAT_HAFT support by creating a helper for descriptor
updates to be used for both leaf and table descriptors.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/at.c | 56 +++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index dcbe5563baa2..eba51c6e01af 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -453,9 +453,28 @@ static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
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
@@ -464,7 +483,12 @@ static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
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
@@ -474,7 +498,7 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
 static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		   struct s1_walk_result *wr, struct kvm_walk_access *access)
 {
-	u64 va_top, va_bottom, baddr, new_desc, va;
+	u64 va_top, va_bottom, baddr, va;
 	struct s1_walk_step ws = {};
 	int stride, ret;
 
@@ -544,8 +568,6 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			return ret;
 		}
 
-		new_desc = ws.desc;
-
 		/* Invalid descriptor */
 		if (!(ws.desc & BIT(0)))
 			goto transfault;
@@ -615,25 +637,9 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
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

