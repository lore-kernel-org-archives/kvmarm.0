Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E0D3538BF
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972452; cv=none; b=iWTH4dj37RrQGMS4P0DAvGc7MBXya9P0eUsMemM1qsueBm/0RrL1UmIUgl6gEFCIXBy94UwSw2+8rpb+VfLshlsCCpa64rVw95AMltVuo/nJK5+ah5l+sJseSGVjE3VT1zUvq/i4/6z5Ji/BicqI7J72w9TP+H8qtzJfWp7T6Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972452; c=relaxed/simple;
	bh=CSE8A7F3zMmKjKAXf1+OUSIvj96U3UYGylznehbkl8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW6utIDDzkHBgI7DTtcxw2ZWJgILqt5pNyIhZdz5CS1Jv7Y6QAXV8O9RD77+ROcmYDbDdLZmzFUQ4WFfWQ3seExfyvWWfvKO5LWLu9Te4WJyx4i/IyMUsw4OaKVzzZXUfkHLKjW9MXa+LKNCeZXw9FikyzJsyV04LntunZSmKDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBXfYccg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBXfYccg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11983C4AF0C;
	Wed, 12 Nov 2025 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972452;
	bh=CSE8A7F3zMmKjKAXf1+OUSIvj96U3UYGylznehbkl8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBXfYccgmmSQHJUVexeuJDgwV8gdbOmMghRFjN0bHGCjsNihit9bvPaC0YK106HUR
	 ApamPH/rkJQ3kKcnUS5krgWVsxQfuJrhqNXozcVk04Ruite9+4vEvn39VrM++NGk8m
	 +yLLQHG+H1jsmjohwCYRMRGC0A2decII8tgmxKwqLHC8UAL6Zl1XZExEdobXFR4yoA
	 TeR2wPAmZS2ae81L7tcX8h9WGSC8xro0EJACOqnBezHGouzKGKX15nFlsArX6Mk3Ku
	 JQODgfyo4qRmwSNiK55y4adXv1X3cC8WHd1C74+pDD87pEZZr9ixGfMfOpJI2pl5i2
	 AwlN1qLjj+g7g==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 08/12] KVM: arm64: nv: Use pgtable definitions in stage-2 walk
Date: Wed, 12 Nov 2025 10:34:02 -0800
Message-ID: <20251112183406.2118981-9-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112183406.2118981-1-oupton@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
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

