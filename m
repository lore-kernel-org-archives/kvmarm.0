Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC3B69D35
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647548; cv=none; b=cZYynSnFBEDpZ2TMktEyP7RhilzZfeL74O3PSZ9vYm2cm42VmQaBPaQLOj2zJbpnzDgN2os6053C/VkPDpCIfFYxoE5MmRqZXKq8Vb1TILdKKDkwA0LK9waDGdWXmwlzwZ29aLnPRlERJBp9PgogrUuHqCp7709TRQE7bftOTgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647548; c=relaxed/simple;
	bh=oheFs4+mGfJCXwIIaUZOBBGakXa8+TX2q4FgHBvfaTE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mgPjM9tg1xlJm/xf8Pg+H+8MvtO6Np/K10tYFM3aCk4m86icT+wLV5lMsGKv5TH1GXZnQKeH2XKu7iS7d0E96ceJDPWyX8sqNvdfuOwt6i6nM3WFLQjAg8uwFWWoRpoSVnpFLBuM6Q0TXb08ddqb8lXSfjX8mnvTawdRxa2qof0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9foK/aM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9foK/aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2CDC433B1;
	Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647548;
	bh=oheFs4+mGfJCXwIIaUZOBBGakXa8+TX2q4FgHBvfaTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9foK/aMgefE2b3s2XvLSGvN6Kc6pu7odZHlmDQnYO7r1JlQM6TyJKQxWlucMxasJ
	 4++bhq3YNoO3CPITySCM1XJqV2WvCRFsvrkj2sgLfyY79jTc16+mhxbjJMRzQgaEST
	 5s0RAUzkMlWIbFPwHJ2+yrgUhJYDQWIR044Kj6tUsz9bakKrmhTitaKdldLsNhj9J1
	 JaHLSvV/QJ96bo7/YiJc8BFDAQlINMoaXszaqKaIhd4ItJ5sExMiM0GI2KgNysnUbd
	 5s0z6R3nKD6/DdB9iMMbmeRupPH8rZTYDgP9/sMcv5fqXGBb5/71HyI/XsdlQFrOxR
	 /TMcoNh5NZqug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzK-00GNsE-6Z;
	Tue, 30 Jan 2024 20:45:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 07/25] KVM: arm64: nv: Drop sanitised_sys_reg() helper
Date: Tue, 30 Jan 2024 20:45:14 +0000
Message-Id: <20240130204533.693853-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240130204533.693853-1-maz@kernel.org>
References: <20240130204533.693853-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have the infrastructure to enforce a sanitised register
value depending on the VM configuration, drop the helper that only
used the architectural RES0 value.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 431fd429932d..7a4a886adb9d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1897,14 +1897,6 @@ static bool check_fgt_bit(u64 val, const union trap_config tc)
 	return ((val >> tc.bit) & 1) == tc.pol;
 }
 
-#define sanitised_sys_reg(vcpu, reg)			\
-	({						\
-		u64 __val;				\
-		__val = __vcpu_sys_reg(vcpu, reg);	\
-		__val &= ~__ ## reg ## _RES0;		\
-		(__val);				\
-	})
-
 bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 {
 	union trap_config tc;
@@ -1940,25 +1932,25 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 
 	case HFGxTR_GROUP:
 		if (is_read)
-			val = sanitised_sys_reg(vcpu, HFGRTR_EL2);
+			val = __vcpu_sys_reg(vcpu, HFGRTR_EL2);
 		else
-			val = sanitised_sys_reg(vcpu, HFGWTR_EL2);
+			val = __vcpu_sys_reg(vcpu, HFGWTR_EL2);
 		break;
 
 	case HDFGRTR_GROUP:
 	case HDFGWTR_GROUP:
 		if (is_read)
-			val = sanitised_sys_reg(vcpu, HDFGRTR_EL2);
+			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
 		else
-			val = sanitised_sys_reg(vcpu, HDFGWTR_EL2);
+			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
 		break;
 
 	case HAFGRTR_GROUP:
-		val = sanitised_sys_reg(vcpu, HAFGRTR_EL2);
+		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
 		break;
 
 	case HFGITR_GROUP:
-		val = sanitised_sys_reg(vcpu, HFGITR_EL2);
+		val = __vcpu_sys_reg(vcpu, HFGITR_EL2);
 		switch (tc.fgf) {
 			u64 tmp;
 
@@ -1966,7 +1958,7 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 			break;
 
 		case HCRX_FGTnXS:
-			tmp = sanitised_sys_reg(vcpu, HCRX_EL2);
+			tmp = __vcpu_sys_reg(vcpu, HCRX_EL2);
 			if (tmp & HCRX_EL2_FGTnXS)
 				tc.fgt = __NO_FGT_GROUP__;
 		}
-- 
2.39.2

