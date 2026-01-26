Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6F0337100;
	Mon, 26 Jan 2026 12:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429855; cv=none; b=CiOB3BgRFN2euGFyRuurkBTfwthJP8sluupaH6R/lQfadtOwDRjtKNt3kjvTyWdJJLbjqEoWFWFUw2IgcnSt4mDunVs/R6b1Cnzpm8+JJYGqsKweRCNnjpD5jb4/MUPZY8oJMbv+eLTGhbcfzUY9GLoZaeowmzh01livlEQ+dQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429855; c=relaxed/simple;
	bh=PTm8YLSVe/WgrlU0lr7yyZgygsqs+ZiX1K/HFlMRjgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXApxb/hlCQeE2MecqmbzNnt9mZrXrAPSc0//XA3CUSQc2Bm9GBuG3fey8GinmqAa6zCNj0uS0MPSyOnsqL5UnCzzjr9Rcpwdfezv0qnBDOeQybFijON8cc92BiHPKcYovV9uAwTY6eCn3bYIqZ4jKpeXbU98mzpEV57IqIl9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKeI1YGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKeI1YGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8112DC2BC86;
	Mon, 26 Jan 2026 12:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429855;
	bh=PTm8YLSVe/WgrlU0lr7yyZgygsqs+ZiX1K/HFlMRjgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKeI1YGiUCHg53hwDL6qa8q11IrKaaJ7wzrHvlohWybi5vEbJr9A6Z1cCwBgWDq7O
	 mdFZ14MXOuF+q0nJibyQEMnAI2nxJ/R/Cu32SwT41fy6uw3hQRPEbqELiqZmpNNLrz
	 YwyQabzcoRux1N7Iand2Eejq1J1pdeoEcly3YDxZ3Ow0wsALWTn/1a12Ho3WfAZnKm
	 RHSidpZf06RP03dHJQTfimSXD4wWdrp2cWfWpY78W5ORLVikTkxtoJxz6+GwsSrkxi
	 lo+TDCRhRWaFrIHKvPq7gY6HdVWdqDA7KRpxaliYIA+2SfePkjn3UmP1v4INhNOBHP
	 nH8x3CREQZYqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXB-00000005hx6-37fT;
	Mon, 26 Jan 2026 12:17:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 09/20] KVM: arm64: Convert HCR_EL2.RW to AS_RES1
Date: Mon, 26 Jan 2026 12:16:43 +0000
Message-ID: <20260126121655.1641736-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126121655.1641736-1-maz@kernel.org>
References: <20260126121655.1641736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have the AS_RES1 constraint, it becomes trivial to express
the HCR_EL2.RW behaviour.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 68ed5af2b4d53..39487182057a3 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -389,19 +389,6 @@ static bool feat_vmid16(struct kvm *kvm)
 	return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
 }
 
-static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
-{
-	/* This is purely academic: AArch32 and NV are mutually exclusive */
-	if (bits) {
-		if (kvm_has_feat(kvm, FEAT_AA32EL1))
-			*bits &= ~HCR_EL2_RW;
-		else
-			*bits |= HCR_EL2_RW;
-	}
-
-	return true;
-}
-
 static bool compute_hcr_e2h(struct kvm *kvm, u64 *bits)
 {
 	if (bits) {
@@ -967,7 +954,7 @@ static const DECLARE_FEAT_MAP(hcrx_desc, __HCRX_EL2,
 
 static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 	NEEDS_FEAT(HCR_EL2_TID0, FEAT_AA32EL0),
-	NEEDS_FEAT_FIXED(HCR_EL2_RW, compute_hcr_rw),
+	NEEDS_FEAT_FLAG(HCR_EL2_RW, AS_RES1, FEAT_AA32EL1),
 	NEEDS_FEAT(HCR_EL2_HCD, not_feat_aa64el3),
 	NEEDS_FEAT(HCR_EL2_AMO		|
 		   HCR_EL2_BSU		|
-- 
2.47.3

