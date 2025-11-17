Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB4C28504F
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419409; cv=none; b=N7nJqwBB12nE84fUKK7qVwQ6pkqZb67cotlNecaOKDodRBjNCcu4Y5OmNPJyh0RkKsKJo6HJdrqreLkp2lKd12JWn1B0aRt0gpZIAXwnMRQB/30KOUFNav237X5L+frLrfUkEcM1vHs2lsq331swHk2qARN+xNAXm0yO3QTRSEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419409; c=relaxed/simple;
	bh=knW1PUsbyJ6Yx+zrY5Ax4H+LAVQSSI+Qh6CyS1LpRe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2rJwyeBdyIgSKJLWsPXV7pG5kC370MaNZPXZ8+0X19EpFrfSEwPVhbJYa30Kp1x1GaYoBKQT9qkGD/ETMLGylrFj3VfJ/v+ZRSqQOx3GwR6GFWMgKQ+y4a5wFiGnmbLCjhnUKWV9nvq6aec0W0YCWobsWJ2juYd4+PP9TrGKIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGH95pQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGH95pQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29163C2BCB1;
	Mon, 17 Nov 2025 22:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419409;
	bh=knW1PUsbyJ6Yx+zrY5Ax4H+LAVQSSI+Qh6CyS1LpRe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGH95pQKWX1ejKbND09XgiHnJGttzeqD02/ld7K4Gn88iCoQi6isIVRfS28ieB45v
	 jIljyxNtNwTe1/lUo9+7Bh0OWV6esE47D3xvJMWii6jiRVsLGQjvAeD20gfy/mvC9X
	 lzqW2uZUpa7HV6XNi4DCLFeYTxZIpOVXV7saRIdYZULY0al5Fhf+yYAcRedBSVlSDM
	 EFljS6kI5hUSVcZbkpwYLNEvcOFG+bfTKJEHVQM5oUu05XvkrBeIQW2Fk/lIT6KqLn
	 cJckDszNRIdUZaISbOoEVaYpw14cBh8lBIgIkMxpbaY7ANbNXtschOKclrWwpJ3NA/
	 xbrOlYZKZB/4w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 04/14] KVM: arm64: Teach ptdump about FEAT_XNX permissions
Date: Mon, 17 Nov 2025 14:43:15 -0800
Message-ID: <20251117224325.2431848-5-oupton@kernel.org>
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

Although KVM doesn't make direct use of the feature, guest hypervisors
can use FEAT_XNX which influences the permissions of the shadow stage-2.
Update ptdump to separately print the privileged and unprivileged
execute permissions.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/ptdump.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index dc5acfb00af9..bd722383d0e3 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -31,27 +31,46 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
 		.val	= PTE_VALID,
 		.set	= " ",
 		.clear	= "F",
-	}, {
+	},
+	{
 		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
 		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
 		.set	= "R",
 		.clear	= " ",
-	}, {
+	},
+	{
 		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
 		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
 		.set	= "W",
 		.clear	= " ",
-	}, {
+	},
+	{
 		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
-		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
-		.set	= "NX",
-		.clear	= "x ",
-	}, {
+		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b00),
+		.set	= "px ux ",
+	},
+	{
+		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
+		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b01),
+		.set	= "PXNux ",
+	},
+	{
+		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
+		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10),
+		.set	= "PXNUXN",
+	},
+	{
+		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
+		.val	= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b11),
+		.set	= "px UXN",
+	},
+	{
 		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
 		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
 		.set	= "AF",
 		.clear	= "  ",
-	}, {
+	},
+	{
 		.mask	= PMD_TYPE_MASK,
 		.val	= PMD_TYPE_SECT,
 		.set	= "BLK",
-- 
2.47.3

