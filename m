Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93F83538B5
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972451; cv=none; b=V6GSVfD8h6Y9UqsEHnoDoFFq/pX0RdL/RY6hcCVBqHV9vCVZMsN1fQdl972g5u+sDhoqqcShaBq208eHuO9hGpjfuFChvR6NBBqILSmc1uKSNvq/BvTxq72vYp/JBgilVzN8CJQHyiQWFxAkV6Kv3MQ5VFOTTNK0KO/0XZibabU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972451; c=relaxed/simple;
	bh=knW1PUsbyJ6Yx+zrY5Ax4H+LAVQSSI+Qh6CyS1LpRe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8rUyEg7L7vScGkYtb+FCwicK5CXrFHCfZxHO3oygeOl1IDjZs59lhugJHqLt4OSEbey2Z4l8JgLn97H82K3kdzcAG2G89j1FXOohPOtutUgJl9jXfOPBns0h3w2Z7MxVJCkkIHbUzWXVrvnymzO8xtJ6Npkuz/n2t3zAXueIPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mrf/BMSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mrf/BMSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E6EC2BC86;
	Wed, 12 Nov 2025 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972451;
	bh=knW1PUsbyJ6Yx+zrY5Ax4H+LAVQSSI+Qh6CyS1LpRe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mrf/BMSah7VG3B5xMHEhh6/GHLdc8sCqwNsOOFRO8/0zHJBxh+f9KZaPlJadg/xal
	 Kd2NQL6rISYS6TP/uRTZ9l8E+0qGjCEq7brIanh0BNmE1ZchRS9VfdAVfNFGEUo4gw
	 c6divW1nzzy+2I24DI4W19uT4FyvTpeOK+NKaVYNAuNAZi0FIljwpJ6oy2gv+PLRZU
	 gBE5axzYCpWY75vgt7mW5KczJYU+bZ5WhV/0Gbm1rJE6YK2ujWiT+p45wbpeK2tJBk
	 ZIvLQdc1N076kH0yjBzakB6oAzqQcXz0cHwitXrwj79uCy98ETiHfvTRP/d1jwSZNV
	 bRA6vHcDOOptA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 04/12] KVM: arm64: Teach ptdump about FEAT_XNX permissions
Date: Wed, 12 Nov 2025 10:33:58 -0800
Message-ID: <20251112183406.2118981-5-oupton@kernel.org>
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

