Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788977;
	b=tJKFJRR5nbuChrnzEe/0O/49hnJHBsjsNadwBcdn6M8O24ex2YHUnWLupKjWOzXBr0AB
	 a4ODv86vrKF1Dr64G8IzFhO5uRVS7sQXDQjMUkxoPZguCOG/YYy+5HTtBbxwThzcwPZ+B
	 DVyzk7spml/2NkbuIZfktfFfWSLNQR2h1Zj7TrMPwfYejjaxe5WOA9l6Zz7yPppyJmxLm
	 qHf8c5BQHUEx5RnLV0L8Rr51+or/yW82K/jH4W2LWEgwkIYS64w7KGouuCwMV/8ZXrhio
	 yDMSe7/PnBB8n5K1nv7raR7ndwjcoOVdDeUUBbjlIOjA3mH4FBKvG9KYRfS81fOxAvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=9HCWtLQ40Y4aEgYkZ+glLBgmoxAgo2915MhNv1fAqhI=;
	b=Twl2n7NEXshjtJ/V9DmCdNsAcBKWDGQkY2a9Exo5XwhVwjZqXlKYKCVrPHHwpZDEgY95
	 wak0p1GRQKU4WvJEw7mMVJJ8Zg4h6ga+3tSec/i3vpp79JhqWub8XBdQTitmq1zYfKuL5
	 9ggkejYH6476YmgxkITHkoZdrLjKDL+pWP8aukRBjIPKkI5GOYLEgCgN1lKFIH1aeKV58
	 Z0Hxvg5fDPjUzWawfjVHQIj8tbRRgs3FLWqvRjZZ3yzpE9mzdVfJhiqgmXI6oe+BcoBLA
	 nUyC4yD8rZ/B6RoPvJiNO1vLWsM7gOzvO8KRozoGuczs7MJRX2qtCltZ3BBJVUY4NXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLSoN1ZW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31630606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLSoN1ZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F286E1F031E8;
	Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788977;
	bh=9HCWtLQ40Y4aEgYkZ+glLBgmoxAgo2915MhNv1fAqhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLSoN1ZWgPEEOm0PSEDrop7AvYRYs/231F5cmRXlPTASLBCeHpCzAUBqhNuAGywAh
	 pXtw5pGpR1VX0WgbtqeUkGPbUOfEAtnt0+XnmiBcUw/GW84JoNJpvu4jyZAJC68HjL
	 2abHsrL7zKzBAbC6gRtQkl+lp5sbxuJjI3b4VLYFR7h77+uBVJAIXi/7pSzHhHwo0/
	 HmvSY2KkX/z0TleVcmM0zYsbcY8YIu62ckeW9khaOJeUf9ey3CdBe/xI/FQCyLRzTj
	 uEFRO/Aa/IlE6WNvXn0kn6ZxMgMHzz17k14F3q9mx16cSTK5cpNkFryjdCJNCt6D8o
	 rIcKAXHTD1PHQ==
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
Subject: [PATCH v2 06/28] KVM: arm64: nv: Use a helper for stage-2 descriptor updates
Date: Fri, 23 Oct 2026 13:55:48 -0700
Message-ID: <20261023205610.1044532-7-oupton@kernel.org>
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

Use a helper for handling stage-2 descriptor updates so the
implementation can be shared with updates to table descriptors.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 47 +++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index a3cbf37dddc9..dea5c31f10df 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -246,9 +246,23 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
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
@@ -257,7 +271,13 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
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
@@ -306,7 +326,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 	struct s2_walk_step ws = {};
 	phys_addr_t base_addr;
 	unsigned int addr_top, addr_bottom;
-	u64 new_desc;  /* page table entry */
 	int ret;
 
 	switch (BIT(wi->pgshift)) {
@@ -359,8 +378,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
 			return ret;
 		}
 
-		new_desc = ws.desc;
-
 		/* Check for valid descriptor at this point */
 		if (!(ws.desc & KVM_PTE_VALID)) {
 			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
@@ -405,21 +422,9 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
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

