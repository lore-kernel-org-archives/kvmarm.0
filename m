Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788977;
	b=s6jpjGpHW/pxDU+xhImUq8c19pxYWaJFlWGqEEYhS3Yd9PQH7AFRU8pNt0IK+gF5aJnv
	 6ABTpC9OPIw3o16Jbpo15hHQLoKWKc+kyMI98b0958zHkP5YRi4yHOcAvhzLuAP7vjPBK
	 BgJzsuNT4E7xs2rVNDj5ddTS4YuP2Kt2UwtR8FC3W3XuZhoTZz+OjpDqFzdSV7/2vMMdE
	 R5sAk0R1KJ3oyEru3UdLyQ4yzEoI2nSF7OxvD8BhfiRxTUo3C7/QuY1UaHWF2B9W1oehf
	 Ed9XjyqGe31ioIa78n2HflaH7Xe+zH5aZ+EAvGieJNHLvh/qHoCAd97iAiNkMTmP5/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qlPEHkLFZLP/YacGzx+/7AMuA65R3xBBu2il1baas9k=;
	b=ILP/Qycq5OjX02mlg8xg2ivt92hIUVrY7bbd0SeQQwYJmwaklI11hYD+iy5t9h6j0RW9
	 etbqUw49eXmWeUY2w2qGnOXGA1rpIMl6EpxdZuBNinoM3t2ILt/9FdGdDcHIQkjfcIBSk
	 431O6aKXx2P9Jw/+pQTiZjaM1XpLnYCoqYtiOQbIimgFjS9vytcElxXn9qUQBCNk+u9pY
	 d2uXjRy/udLb6gELomCl/s44/rMLO2c2fxpjRCJJNpE9PlQ6Sntux/vK28Gz6k98BEJfb
	 y3fN1Pr2jKwOxQ1cXsBzV1alL++4JoxN0zA/eq1dfmIwjpkgd8Nr/btGeUgbHRtASpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ir7d0g5u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32521606A320
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ir7d0g5u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B898A1F031E5;
	Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788976;
	bh=qlPEHkLFZLP/YacGzx+/7AMuA65R3xBBu2il1baas9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ir7d0g5uY33n+BmE22jFdxuGDPtaFQfLwsaf28yqJWZgSQrXhfRNHP/Nl063FjSMs
	 oMMti+QlJIfbmcIcA1SEmpU9i1fBtSUrwFEDzmBs5MxOzrg8pnEvmK4o67mbu79yL8
	 RIlx4Emx6HGQ4I0EexAcwKJtiFr2zITZ11rKGi9LsD0RF7/CLCQj+lLjtoE5nK8D8j
	 5NGSUEj/Gdi0iBV/mOyhZa+ofLaUZfgrElEBC/ysSf+7tCvN2US3Glbx5MRY4a1ugd
	 +r/7Y948GGCPjZRYWDqConpJHcJHRvcT9mQ949fgydNtNzVcADTQ4TiWCRQmUpSe/V
	 ptRuQ+pUysh5g==
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
Subject: [PATCH v2 05/28] KVM: arm64: nv: Pass an access descriptor for stage-2 walks
Date: Fri, 23 Oct 2026 13:55:47 -0700
Message-ID: <20261023205610.1044532-6-oupton@kernel.org>
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

Pass sufficient context to the stage-2 PTW such that access-dependent
features like FEAT_HAFDBS can determine the correct behavior of the
walk.

Reinstate the recently deleted kvm_vcpu_dabt_is_cm() to correctly
annotate CMO data aborts.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/include/asm/kvm_nested.h  | 15 ++++++++++++++-
 arch/arm64/kvm/at.c                  | 22 ++++++++++++++++++----
 arch/arm64/kvm/mmu.c                 | 16 +++++++++++++++-
 arch/arm64/kvm/nested.c              | 10 +++++-----
 5 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 85289a4b8d52..0aabe592be16 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -457,6 +457,11 @@ static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
 	return esr_dabt_is_write(kvm_vcpu_get_esr(vcpu));
 }
 
+static __always_inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
+{
+	return esr_dabt_is_cm(kvm_vcpu_get_esr(vcpu));
+}
+
 static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
 {
 	return 1 << ((kvm_vcpu_get_esr(vcpu) & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index e8d5ae7afb9a..89a860b92826 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -111,7 +111,20 @@ static inline bool kvm_has_xnx(struct kvm *kvm)
 		kvm_has_feat(kvm, ID_AA64MMFR1_EL1, XNX, IMP);
 }
 
-extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+struct kvm_walk_access {
+	enum {
+		WALK_ACCESS_IFETCH,
+		WALK_ACCESS_LDST,
+		WALK_ACCESS_CMO,
+		WALK_ACCESS_AT,
+		WALK_ACCESS_S1PTW,
+	} type;
+
+	u64	ia;
+	bool	write;
+};
+
+extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
 			      struct kvm_s2_trans *result);
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 4e505433299b..32d2e57b017c 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -481,7 +481,19 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		ipa = baddr | index;
 
 		if (wi->s2) {
-			ret = kvm_walk_nested_s2(vcpu, ipa, &s2_trans);
+			struct kvm_walk_access s2_access = {
+				.type	= WALK_ACCESS_S1PTW,
+				.ia	= ipa,
+
+				/*
+				 * R_JCXVS, stage-2 dirty state can be updated
+				 * for an S1PTW even if the stage-1 descriptor
+				 * isn't updated.
+				 */
+				.write	= wi->ha,
+			};
+
+			ret = kvm_walk_nested_s2(vcpu, &s2_access, &s2_trans);
 			if (ret == -EAGAIN)
 				return ret;
 
@@ -1595,8 +1607,9 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
+	struct kvm_walk_access access = {};
 	struct kvm_s2_trans out = {};
-	u64 ipa, par;
+	u64 par;
 	bool write;
 	int ret;
 
@@ -1640,10 +1653,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		return 0;
 
 	/* Do the stage-2 translation */
-	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
+	access.type = WALK_ACCESS_AT;
+	access.ia = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
 	scoped_guard(srcu, &vcpu->kvm->srcu)
-		ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+		ret = kvm_walk_nested_s2(vcpu, &access, &out);
 	if (ret < 0)
 		return ret;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 84aa1bb31095..7b29be33a1ea 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2519,9 +2519,23 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	 * canonical translation.
 	 */
 	if (kvm_is_nested_s2_mmu(kvm, mmu) && mmu->nested_stage2_enabled) {
+		struct kvm_walk_access access = {
+			.ia	= fault_ipa,
+		};
 		u32 esr;
 
-		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
+		if (kvm_vcpu_abt_iss1tw(vcpu))
+			access.type = WALK_ACCESS_S1PTW;
+		else if (is_iabt)
+			access.type = WALK_ACCESS_IFETCH;
+		else if (kvm_vcpu_dabt_is_cm(vcpu))
+			access.type = WALK_ACCESS_CMO;
+		else
+			access.type = WALK_ACCESS_LDST;
+
+		access.write = kvm_is_write_fault(vcpu);
+
+		ret = kvm_walk_nested_s2(vcpu, &access, &nested_trans);
 		if (ret == -EAGAIN) {
 			ret = 1;
 			goto out_unlock;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9b2ea83aeccd..a3cbf37dddc9 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -299,7 +299,7 @@ static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *w
  *
  * Must be called with the kvm->srcu read lock held
  */
-static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
+static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
 			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
 {
 	int first_block_level, stride, input_size, base_lower_bound;
@@ -349,7 +349,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 		phys_addr_t index;
 
 		addr_bottom = (3 - ws.level) * stride + wi->pgshift;
-		index = (ipa & GENMASK_ULL(addr_top, addr_bottom))
+		index = (access->ia & GENMASK_ULL(addr_top, addr_bottom))
 			>> (addr_bottom - 3);
 
 		ws.desc_pa = base_addr | index;
@@ -431,7 +431,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 
 	/* Calculate and return the result */
 	out->output = (ws.desc & GENMASK_ULL(47, addr_bottom)) |
-		      (ipa & GENMASK_ULL(addr_bottom - 1, 0));
+		      (access->ia & GENMASK_ULL(addr_bottom - 1, 0));
 	out->block_size = 1UL << ((3 - ws.level) * stride + wi->pgshift);
 	compute_s2_permissions(vcpu, wi, &ws, out);
 	out->level = ws.level;
@@ -534,7 +534,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
 	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
 }
 
-int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
 		       struct kvm_s2_trans *result)
 {
 	struct s2_walk_info wi;
@@ -547,7 +547,7 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 
 	setup_s2_walk(vcpu, &wi);
 
-	ret = walk_nested_s2_pgd(vcpu, gipa, &wi, result);
+	ret = walk_nested_s2_pgd(vcpu, access, &wi, result);
 	if (ret)
 		result->esr |= (kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC);
 
-- 
2.47.3

