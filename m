Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9686C3B9DA2;
	Thu, 30 Jul 2026 07:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395470; cv=none; b=l5OPCMToBhgV4lN6At3kxwMVHad3UrRclRD8G7isyWdMj4ICrWOwWfjFPuWTHIEnbvBjPNjSMRp1/yGUSMAY5WdnM3pBgjg14RpsjYakWL80OO40kOqrHHD13NLRdm3Jl8v3djK145QqqvSOZdPzNP8ljp0PegKJZpPRMDBWYOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395470; c=relaxed/simple;
	bh=Xxdwzxaitfilz/BhB5M2rCuMC4wDGPUcx3zUTket/bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxuQKv+PBiTwbNRmkIfoFuR89Pgwy5KP4jZptzg6oJzzcUp6pVlN7IsSO9bgR5qvXlpzbnloWF7vwXUN3GkFEDwP91PoK3oUIaBUvT9bo+6BGdIg/uc1cHDRIs14y9D61zwKWk4UQFu5nJoP9HM+M4f22RnFul+DhqBcNI4UQP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6L0Sf17; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6L0Sf17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4F11F01576;
	Thu, 30 Jul 2026 07:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395456;
	bh=FByzWifFnU/f8PPlfimQB06kGfpqX85cK4oJFIEZ8EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6L0Sf177CVGtoX2u7ln/g/Q9HkMKSjaK1od6ndTCGyzrri57pEdPsjJgdBoGB4lb
	 8y5weJ7eHnYPfaeGKwxR3TIQzmXazdBGP9NlksBcE48biv8BfwHRnDjecjSVXexcVj
	 NVA4FE/YGX1VrfuFAPKwFlDUjJQx8cSJRR0Rz3XgFSI9kpFxAxXobMTVV1xXgtcTCe
	 GILlxbp1LfpYHJcn8WOGzJWMants6sA4v/s0KBY07kQ4B4qgofR55DDHVinQrrMEu2
	 wo1KOYF6CabxzFhuRUqWvoCzS8lqgejk6RbK2G883XlrGActis3M+d6HGhSjNJaZlt
	 SbqiuizX0wLmQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKus-0000000AOpW-1yfB;
	Thu, 30 Jul 2026 07:10:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 28/29] KVM: arm64: selftest: Add NVHCR_EL2 to get-reg-list
Date: Thu, 30 Jul 2026 08:10:21 +0100
Message-ID: <20260730071022.296811-29-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since we now expose a new system register on NV3-capable HW when
the guest is exposed to it, add it to the existing checker.  FWIW.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/get-reg-list.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index 0a3a94c4cca16..3cecc6d5dbd51 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -67,6 +67,7 @@ static struct feature_id_reg feat_id_regs[] = {
 	REG_FEAT(VDISR_EL2,	ID_AA64PFR0_EL1, RAS, IMP),
 	REG_FEAT(VSESR_EL2,	ID_AA64PFR0_EL1, RAS, IMP),
 	REG_FEAT(VNCR_EL2,	ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY),
+	REG_FEAT(NVHCR_EL2,	ID_AA64MMFR4_EL1, NV_frac, NV3),
 	REG_FEAT(CNTHV_CTL_EL2, ID_AA64MMFR1_EL1, VH, IMP),
 	REG_FEAT(CNTHV_CVAL_EL2,ID_AA64MMFR1_EL1, VH, IMP),
 	REG_FEAT(ZCR_EL2,	ID_AA64PFR0_EL1, SVE, IMP),
@@ -770,6 +771,7 @@ static __u64 el2_regs[] = {
 	SYS_REG(SP_EL2),
 	SYS_REG(VDISR_EL2),
 	SYS_REG(VSESR_EL2),
+	SYS_REG(NVHCR_EL2),
 };
 
 static __u64 el2_e2h0_regs[] = {
-- 
2.47.3

