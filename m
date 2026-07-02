Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69152D46B3;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008181; cv=none; b=M/V4+0ExHgAQ/5yCcd4+fcwMi0vJyEtHI+7gc/rGvVAnxPDlyXgGzcmXBIX7/eWM/szaIBe/02fXTdqMVuVuHvS+zCQh9eD9/jYzYZpkaDNQqsH0AyV1eogY6jBVWFGVw58q5DQunH8w+B3aOhoV3nfuuX9kWU1F4EOgPFmb/as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008181; c=relaxed/simple;
	bh=T97855on3JpLo5DYrb50t2QkZLViiwHJtj3FFM85drk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T41kR3pwabsZC4p5LGow6IihtsfHLa8rV2BYUlivPtI5ZFneyc69/nQgSpYe4RVUYJfL8OlGVpw5w2ssopboB3z9ynyhtD4ZTENY2gkbclOb7WFQvLrTP3yBc2sap9DFmdYODJdI0VBx3M59OIfNkzlArB2XiLbuvITGgAk5sng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PHlVQbx8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PHlVQbx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4081F00A3F;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008180;
	bh=dr1npthRS596q766VwCo3BxGKb+h7Go/35hKziPbN5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHlVQbx8j1oOdDz0wziFeWEyXvNFrmVY4tD3GrEHEQHGsIdEx3iXsT5+IGXnfk6Ol
	 kxMRw8nyO7G3y7+KxaivPvAOaEbbJ2oxthBVHaF0o9TsvnHZDXi9v3GeAYVQC7dMeN
	 wFLxw03OjMQzja/6TlWymb9XEqnp1OoC+J+RIvTM51GM4NrooTPh3XMlz5bcKQi3W4
	 ty8EcRW8gpwckfy2dcBd0dWQ0ZMum5uisW9XjqL61u2AHKIURWa0rb3KsFq3XAD1d+
	 +UeLo6hIX3iowRCGLknIQdcIMMAQ4UpOprWX4stFWJkKvnclf9fvPTIr8uys5Hwt0f
	 w5O36dZgBq9bQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsQ-00000000ojd-3trS;
	Thu, 02 Jul 2026 16:02:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 04/28] KVM: arm64: Drop __HCRX_EL2_* masks
Date: Thu,  2 Jul 2026 17:02:24 +0100
Message-ID: <20260702160248.1377250-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The __HCRX_EL2_* masks are a leftover from a time where we didn't
have much sanitisation for the system registers. Since we are now
in a better place, rely on the existing checks to detect unhandled
bits in HCRX_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 15 ---------------
 arch/arm64/kvm/config.c          |  3 +--
 arch/arm64/kvm/emulate-nested.c  |  5 -----
 3 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3f9233b5a1308..f6cd851047947 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -287,21 +287,6 @@
 				 GENMASK(19, 18) |	\
 				 GENMASK(15, 0))
 
-/*
- * Polarity masks for HCRX_EL2, limited to the bits that we know about
- * at this point in time. It doesn't mean that we actually *handle*
- * them, but that at least those that are not advertised to a guest
- * will be RES0 for that guest.
- */
-#define __HCRX_EL2_MASK		(BIT_ULL(6))
-#define __HCRX_EL2_nMASK	(GENMASK_ULL(24, 14) | \
-				 GENMASK_ULL(11, 7)  | \
-				 GENMASK_ULL(5, 0))
-#define __HCRX_EL2_RES0		~(__HCRX_EL2_nMASK | __HCRX_EL2_MASK)
-#define __HCRX_EL2_RES1		~(__HCRX_EL2_nMASK | \
-				  __HCRX_EL2_MASK  | \
-				  __HCRX_EL2_RES0)
-
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
 /*
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 0622162b089e5..16d8148dc3f12 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -933,7 +933,7 @@ static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
 };
 
 
-static const DECLARE_FEAT_MAP(hcrx_desc, __HCRX_EL2,
+static const DECLARE_FEAT_MAP(hcrx_desc, HCRX_EL2,
 			      hcrx_feat_map, FEAT_HCX);
 
 static const struct reg_bits_to_feat_map hcr_feat_map[] = {
@@ -1579,7 +1579,6 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 		break;
 	case HCRX_EL2:
 		resx = compute_reg_resx_bits(kvm, &hcrx_desc, 0, 0);
-		resx.res1 |= __HCRX_EL2_RES1;
 		break;
 	case HCR_EL2:
 		resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3c82f392845d1..b7f3d86a94031 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2320,7 +2320,6 @@ int __init populate_nv_trap_config(void)
 	BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
 	BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
 	BUILD_BUG_ON(__NR_FG_FILTER_IDS__ > BIT(TC_FGF_BITS));
-	BUILD_BUG_ON(__HCRX_EL2_MASK & __HCRX_EL2_nMASK);
 
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
 		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
@@ -2346,10 +2345,6 @@ int __init populate_nv_trap_config(void)
 		}
 	}
 
-	if (__HCRX_EL2_RES0 != HCRX_EL2_RES0)
-		kvm_info("Sanitised HCR_EL2_RES0 = %016llx, expecting %016llx\n",
-			 __HCRX_EL2_RES0, HCRX_EL2_RES0);
-
 	kvm_info("nv: %ld coarse grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_cgt));
 
-- 
2.47.3

