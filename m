Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBCE2D47E8
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010920; cv=none; b=lK+asXTtBGg2X4vS/s394bbSY4VwtGKg1c8FWLd4+6KwG0Gf7loVL/oRbBD8X67vJDafcAatDID6Ke4SbOyLLWAoOkH2Kjjimg+3pE4EL+kjdMgRtin2GidxfnytDiYA/05tmrBbhgriUPqOECyMbKoNBeZIJNq5WQJA1kwgv7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010920; c=relaxed/simple;
	bh=knW1PUsbyJ6Yx+zrY5Ax4H+LAVQSSI+Qh6CyS1LpRe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTF0b6ODTLt+P0skAOgz4mGtp5Joamo2XDgY1ZY3z67Bzcd9rpxCmWfAY0MQh0AqiRF7G8TrHyd0OFaaSR44CeSjSm3eMOGh4jZHuqdcV4sJJND2hwA4VcwmrmOrV3OftgqKHBiEiaKi5AzPkQZDnCRJ0X0aILzb5m8iIW/FUJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QnKw6MHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnKw6MHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F952C19421;
	Mon, 24 Nov 2025 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010920;
	bh=knW1PUsbyJ6Yx+zrY5Ax4H+LAVQSSI+Qh6CyS1LpRe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnKw6MHCnkmqusn72STdVRXtXiS24L3f3rDFGQjV1OwxFv23M1mzu7QWIM+6PY0ot
	 4EC41MsJOL+b5YbTz3vYZIGwt1q5zQDXh34mBrQL9k69+Ceq5hvi+q1xjoW5LU1qDW
	 e0cupxEIKDNKLWbet4+Gkds4GfK/MF8QZCjpbPlVg2rOm9BriGJ7SXo4RzsmX3GJXe
	 dq7sOhLiE8SZTtahTghqi5oNMOY2+YmI5A3R3uFkf1G+OBBL0K5PKfBGy/KLF2NHxn
	 BjVZIk6DUr3Oep8CyKsDoESmLHq3NwdtcpBcXUis7yD2RPfEop0FRMuaYVSsDBXpOb
	 HbnJfyLp6QfcA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 04/15] KVM: arm64: Teach ptdump about FEAT_XNX permissions
Date: Mon, 24 Nov 2025 11:01:46 -0800
Message-ID: <20251124190158.177318-5-oupton@kernel.org>
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

