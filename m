Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87282C3272
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010921; cv=none; b=cksqEuW6PQULJYQa6Vv7zUy1s++7t8ux1n/kHR/G+8/EqaBbhbker0EsnxqKNw8GhFODKKLEJ9i7XemiG98oh9FJkDFdou2pzQQ9I1fGZBwKddBUN4e9htiBeR74XdFr0Lgl5R5VTz8AcEdTUhKvpwFZmuTgzy3lOF6F+6TRkuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010921; c=relaxed/simple;
	bh=9GTAIfRg6pvtDWOiwiuaj5LIoqlZOAebz1fW7H3GarI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aigsFjgaLOiIkYR4B7xj6ICFyL9/t7BW8Yc99PxFxSHHGpRP/bJ3TYoSc23gVIjp8sfaozJq2fCweq2jCarJPhEZxuyY6xriJ3l4sS0oSmn38tBjrWMSFTbrSpZePmUAXFo0L8yWM9Bp1hgk+ORXuU0q6aEUvq1VUFoAD+uXZ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hq8NxXa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hq8NxXa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAE5C4CEF1;
	Mon, 24 Nov 2025 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010921;
	bh=9GTAIfRg6pvtDWOiwiuaj5LIoqlZOAebz1fW7H3GarI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hq8NxXa2/qx6dbhTjt1bF30U5Ha/Iiukwgp7FG8/5nQ3PI753glOyB35ajrsAH2vf
	 Pd9c6qd/RR4F/wBJHJP87TOwfGQyqweZ1JqdlngGY7HRf4VVXAa48Jrz9MEf7ABo/M
	 E7nh4IvcAOYOJVocfCV6mbG3bNMezRBFvJwHyN6mOkOO8GppBmHW19oZtbo54m4dQO
	 DkQvztNNDTO5pViPuOld0lj+pkxzIc6UDnB3e7uBLInUYO14KBTkOrxQsHe65XfQKt
	 YgeTRuFrJaLnQ+ZMTz+BcX1MH9vSRuFHwWNJI6ca3NHa+XxFVt/BjscuQZuqcqaxsa
	 YnY7irQNR0zWA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 09/15] KVM: arm64: nv: Use pgtable definitions in stage-2 walk
Date: Mon, 24 Nov 2025 11:01:51 -0800
Message-ID: <20251124190158.177318-10-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the existing page table definitions instead of magic numbers for the
stage-2 table walk.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 75d26c0ba3e0..a096766c6ec3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -282,14 +282,23 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 			return ret;
 
 		/* Check for valid descriptor at this point */
-		if (!(desc & 1) || ((desc & 3) == 1 && level == 3)) {
+		if (!(desc & KVM_PTE_VALID)) {
 			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
 			out->desc = desc;
 			return 1;
 		}
 
-		/* We're at the final level or block translation level */
-		if ((desc & 3) == 1 || level == 3)
+		if (FIELD_GET(KVM_PTE_TYPE, desc) == KVM_PTE_TYPE_BLOCK) {
+			if (level < 3)
+				break;
+
+			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
+			out->desc = desc;
+			return 1;
+		}
+
+		/* We're at the final level */
+		if (level == 3)
 			break;
 
 		if (check_output_size(wi, desc)) {
@@ -316,7 +325,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 		return 1;
 	}
 
-	if (!(desc & BIT(10))) {
+	if (!(desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
 		out->esr = compute_fsc(level, ESR_ELx_FSC_ACCESS);
 		out->desc = desc;
 		return 1;
@@ -329,8 +338,8 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
 	out->output = paddr;
 	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
-	out->readable = desc & (0b01 << 6);
-	out->writable = desc & (0b10 << 6);
+	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
+	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 	out->level = level;
 	out->desc = desc;
 	return 0;
-- 
2.47.3

