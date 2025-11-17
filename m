Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7814E320CD3
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419412; cv=none; b=nkPq617/yfg1fRfwGwm0KnojERrOl6h3yYLhwIiY2GYpkTM7wO4c7JUU4SAuFsm6HKqWeNaJ69PfPkDN05e1kpX03RgjrgOgUriMhpXMUY5boPnRY/cKrD0byEsz9A+h4/4cP1gtsgb/4qAjWC2HarvzJzar4qjL4ITZqk8yMNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419412; c=relaxed/simple;
	bh=CSE8A7F3zMmKjKAXf1+OUSIvj96U3UYGylznehbkl8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMBDbOiSMNL2gUixKfGS8Yc60hK36M/IVwW3TpsjYL/niODJEJhOS8w2w9OrRsgQ1ifQ2Bb2JhY7tk9IUwmjqT87KHRZs8aUPgGkK3U4X/YTXy6oM54a40B4P/oXh5BjfLGG768aClkFfnitEjD3XexJ8zR0Ju781MR0XpGvw2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5V1gGY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5V1gGY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89205C2BC87;
	Mon, 17 Nov 2025 22:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419411;
	bh=CSE8A7F3zMmKjKAXf1+OUSIvj96U3UYGylznehbkl8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5V1gGY9i5mj6Dk3SV1KyrCSKpepZmPPVEGlysmMQ+w/CimgRUJASOul9HigIKvf5
	 e5uOCGF/JSTYhB9FciOdaBdYpSAWp7Kr5W3gh6uR/es6FEcYloMBQiXlBh+HJJA1u+
	 HNgynUY1B3gx80kJcvuzhH2DO7j/rSeASatei0VzctUOsslNlMBp9zKXLdkIDXjErR
	 3Ms307raPeFh93zaCsaBOIuTPnIKfPhhtWgq9FTPt63xLxtqgt+rKbOiTQvnHb0q42
	 ie6RgcoK7Fnol98ZbUQMJP4vvFSP3fFe1Qx4VycJFru1L0/6Ly4xHtDflCTv47zNNy
	 8Pl8DNITXnqWA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 08/14] KVM: arm64: nv: Use pgtable definitions in stage-2 walk
Date: Mon, 17 Nov 2025 14:43:19 -0800
Message-ID: <20251117224325.2431848-9-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
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
index 10e68aab3d2a..b2fb3d7c9c19 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -283,14 +283,23 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
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
@@ -317,7 +326,7 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
 		return 1;
 	}
 
-	if (!(desc & BIT(10))) {
+	if (!(desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
 		out->esr = compute_fsc(level, ESR_ELx_FSC_ACCESS);
 		out->desc = desc;
 		return 1;
@@ -330,8 +339,8 @@ static int walk_nested_s2_pgd(phys_addr_t ipa,
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

