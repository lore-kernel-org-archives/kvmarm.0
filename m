Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DC9535D1
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916714; cv=none; b=AL+C4ohGZTzT+vpVxf8JSkEdU8CaiMJduzgExZOT8pv1k9vPAdI+nt13nchSOnPpJ+0/4UrivofJztJxm6Xwr01NsdTbQCW+QFNlVzzltnRsEvJPGVP17XQo25pfykwwYAVyuwlmr2a4YOCbulrbJf80t6eROKftkjoy4UOLNAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916714; c=relaxed/simple;
	bh=MttomDqmA23Uf70MMw7L7aO4xenBgq4ySM5NbfTOOr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FEVgdJDiGVo/vmL1VjKuSTk4mSmGbBfFUUKxlC0T4ltQr9FZKZRRBv7/0VbC6z9iNaneJ9hoqd+wBsy5/WN7qhKKTF8YjhaoL0HDShDFhzJI8ESOBZtdHHDCzpwX/2pPbnniJNV/Ciec6AxIYQf7E9yAIZbd2qW4lPYi+bYn0t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfy+9JRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfy+9JRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E93C43399;
	Wed, 14 Feb 2024 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916713;
	bh=MttomDqmA23Uf70MMw7L7aO4xenBgq4ySM5NbfTOOr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfy+9JRCN+cPHzeAxTowFWOGnJ/v21ideda/366sMw+cbSdruaWhos8oYAZHk2HLz
	 5ra/foZdhoQpKKaMLXWncOI7dqatQdCifk74D5GFKeZs7qHiRVuLcEYnYbDuP8tYtX
	 P7sSiuLazf+BMjBoPAEi7S78ulM1c1yz0xYH/dcxe0kQmm1Tt6l76xA9PD9TdT5ZaA
	 UvQRcl1isy4oZx9u5aBbSCVTNW23VAwrxH+Dl0NtsdG19/m1W8zqb9OFMWKUfIwwsd
	 dmpTz12a7csVH1M8a5qhawsP5y+MMTr7Abkt65BWqYMwtacw+EJgfTgLFnucTqwrKO
	 QgSQqj98f12eg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9j-00394l-P0;
	Wed, 14 Feb 2024 13:18:31 +0000
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
Subject: [PATCH v4 06/26] KVM: arm64: nv: Add sanitising to VNCR-backed HCRX_EL2
Date: Wed, 14 Feb 2024 13:18:07 +0000
Message-Id: <20240214131827.2856277-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
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

Just like its little friends, HCRX_EL2 gets the feature set treatment
when backed by VNCR.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index eda05eb16c0a..ced30c90521a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -265,6 +265,48 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res1 |= HCR_E2H;
 	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
 
+	/* HCRX_EL2 */
+	res0 = HCRX_EL2_RES0;
+	res1 = HCRX_EL2_RES1;
+	if (!kvm_has_feat(kvm, ID_AA64ISAR3_EL1, PACM, TRIVIAL_IMP))
+		res0 |= HCRX_EL2_PACMEn;
+	if (!kvm_has_feat(kvm, ID_AA64PFR2_EL1, FPMR, IMP))
+		res0 |= HCRX_EL2_EnFPM;
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
+		res0 |= HCRX_EL2_GCSEn;
+	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, SYSREG_128, IMP))
+		res0 |= HCRX_EL2_EnIDCP128;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, ADERR, DEV_ASYNC))
+		res0 |= (HCRX_EL2_EnSDERR | HCRX_EL2_EnSNERR);
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, DF2, IMP))
+		res0 |= HCRX_EL2_TMEA;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
+		res0 |= HCRX_EL2_D128En;
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
+		res0 |= HCRX_EL2_PTTWI;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SCTLRX, IMP))
+		res0 |= HCRX_EL2_SCTLR2En;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
+		res0 |= HCRX_EL2_TCR2En;
+	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
+		res0 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, CMOW, IMP))
+		res0 |= HCRX_EL2_CMOW;
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
+		res0 |= (HCRX_EL2_VFNMI | HCRX_EL2_VINMI | HCRX_EL2_TALLINT);
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP) ||
+	    !(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS))
+		res0 |= HCRX_EL2_SMPME;
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, XS, IMP))
+		res0 |= (HCRX_EL2_FGTnXS | HCRX_EL2_FnXS);
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
+		res0 |= HCRX_EL2_EnASR;
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
+		res0 |= HCRX_EL2_EnALS;
+	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+		res0 |= HCRX_EL2_EnAS0;
+	set_sysreg_masks(kvm, HCRX_EL2, res0, res1);
+
 	/* HFG[RW]TR_EL2 */
 	res0 = res1 = 0;
 	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
-- 
2.39.2

