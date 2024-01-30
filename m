Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AD771B58
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647551; cv=none; b=aiPlyCPoipg/gxeYN/XanEdaEbj9dRvNc5SbhqN3KG/8MtKvPigTqa36yIYjC1PdFSDB+V2Gf4cu0NIPtLLO4oxho3GIaDC3oGMPM7gE7H+4UEZKGM9iekxFj3h2mzkBOhfzutMEBXwBI4g50D+FKRSwIkNLTKDv00iwgwdkK1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647551; c=relaxed/simple;
	bh=PbEge0JmNmSSIOMrnpsKnrx1SCTWD+57m7f8qU0Od9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KDw1tcCNtbJt17IwxF7JqjrukMa3l+Ff2vJG7Jakt9dwsPmdDZpOIBgwMRSQaoUxFAkc4MCMJhhy5HWJgHJL99iehW3bphdtyg4PRtTopEuVxH/sgROPeG2k1Vc9P0fxPqF6zca6h8xocUK5Vs6v9enifSmEwWYEtsqSzcI+wi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WX1N3anf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WX1N3anf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD08C433B2;
	Tue, 30 Jan 2024 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647550;
	bh=PbEge0JmNmSSIOMrnpsKnrx1SCTWD+57m7f8qU0Od9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WX1N3anf+Rfl2H1vQLVnz852lMOyCTpePAuvI5YmWa7r5vp7qMdSYLejfjc9XDdeP
	 uKHd/CT2SdtZ5dn9NIGejWI06J1sI74f4iHN64GFlxKiAhaJxqJw06MnpxF9EQ3zYF
	 7H+TbPx2cXMPO+01s85+X6J52iE4kyqrOmV7PVf9nbKZlDFH3igR2fLN7ZaF3TMpI1
	 RAjJmEzsVi0VAbKpZGVxUdH3jLNo13DQLec8ELsYaGe9BwExT0QSmY5oz5vbTOBZOl
	 U/KGWwzP3boe+FjFS0nXQiy4gAdoe1o+a4dOS1Z9xMud61XzxnXAsWbUNc52LFbH70
	 9PvO+4yaI15pQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzN-00GNsE-3N;
	Tue, 30 Jan 2024 20:45:49 +0000
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
Subject: [PATCH v2 21/25] KVM: arm64: Make TLBI OS/Range UNDEF if not advertised to the guest
Date: Tue, 30 Jan 2024 20:45:28 +0000
Message-Id: <20240130204533.693853-22-maz@kernel.org>
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

Outer Shareable and Range TLBI instructions shouldn't be made available
to the guest if they are not advertised. Use FGU to disable those,
and set HCR_EL2.TLBIOS in the case the host doesn't have FGT. Note
that in that later case, we cannot efficiently disable TLBI Range
instructions, as this would require to trap all TLBIs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 39e7c7f74717..f07ee7c89822 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3948,6 +3948,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&kvm->arch.config_lock);
 
+	/*
+	 * In the absence of FGT, we cannot independently trap TLBI
+	 * Range instructions. This isn't great, but trapping all
+	 * TLBIs would be far worse. Live with it...
+	 */
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
+
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
 		goto out;
 
@@ -3960,6 +3968,32 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 				       HFGxTR_EL2_nSMPRI_EL1_MASK	|
 				       HFGxTR_EL2_nTPIDR2_EL0_MASK);
 
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1OS|
+						HFGITR_EL2_TLBIRVALE1OS	|
+						HFGITR_EL2_TLBIRVAAE1OS	|
+						HFGITR_EL2_TLBIRVAE1OS	|
+						HFGITR_EL2_TLBIVAALE1OS	|
+						HFGITR_EL2_TLBIVALE1OS	|
+						HFGITR_EL2_TLBIVAAE1OS	|
+						HFGITR_EL2_TLBIASIDE1OS	|
+						HFGITR_EL2_TLBIVAE1OS	|
+						HFGITR_EL2_TLBIVMALLE1OS);
+
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1	|
+						HFGITR_EL2_TLBIRVALE1	|
+						HFGITR_EL2_TLBIRVAAE1	|
+						HFGITR_EL2_TLBIRVAE1	|
+						HFGITR_EL2_TLBIRVAALE1IS|
+						HFGITR_EL2_TLBIRVALE1IS	|
+						HFGITR_EL2_TLBIRVAAE1IS	|
+						HFGITR_EL2_TLBIRVAE1IS	|
+						HFGITR_EL2_TLBIRVAALE1OS|
+						HFGITR_EL2_TLBIRVALE1OS	|
+						HFGITR_EL2_TLBIRVAAE1OS	|
+						HFGITR_EL2_TLBIRVAE1OS);
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2

