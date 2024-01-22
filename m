Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F740BEE
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954738; cv=none; b=kR62x/FShkSUqT5PupkjNP3prwMGDsDfwFK5SygnmKu9Q67ko/BtC0fQBEGP/NqRwI9ArZi3hCnx06H7IxPTxvUrAryaXNbOeNhN3r57xc6A1l1cs8Bz6TWhzniW9nRI5iu98ne7T0HjkUXHTe43tfBL9v5co39mRk9zl3sVnAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954738; c=relaxed/simple;
	bh=V4jsnFkvC/c/9ZemWtmHqJ/PM7bk5w2NZRCjWXInV9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M1R7zns65JPnhqdzQI7i8R3rbshljmSn4NILlaBG/QhsOryT9f6SZpRYR3diJMUiomJj20t649PduYUGFhByNftMHnm8LtzOHjWopeqd/of8O+6AUjkxWkaFVvOXnnvJq4XTSKP65QcJpBG7no36uwIvsznzEOzFIaqm6IDvkVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvy07xJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvy07xJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FE1C43142;
	Mon, 22 Jan 2024 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954738;
	bh=V4jsnFkvC/c/9ZemWtmHqJ/PM7bk5w2NZRCjWXInV9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvy07xJxD56HGnWc/4zyVuTujW9D4MD0JL9g5fE/eQgMaTzin6RF9JRO27Owq1TWk
	 8HZ2eoYsbeEXVnNcRv1Wn0S2dp/MkB9Ue7JcUT1cBrCRQoZ5F87+Kda2i4OMWfsvge
	 7H5NzCobNSarcluOwpV+PadgD9K76J/LFUnMzoCBFPgl9KeUudHE7SxPRst1w0+seD
	 urjB8aq1XpOxsF5+6LaeGKp9XUbA/b0ZX7V5jKbfpvbgbgMI2XbOkF8qEDgRKDT6KE
	 5zTIHqjHuZ/RtsGZ/2JGFcOPuXI3+RZpSIlDIp0H8mZ514LOtG48EwXmGdjGxNvSl5
	 AleVD4D0tx2cg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0ky-00DjkQ-Bw;
	Mon, 22 Jan 2024 20:18:56 +0000
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
Subject: [PATCH 04/25] KVM: arm64: nv: Add sanitising to EL2 configuration registers
Date: Mon, 22 Jan 2024 20:18:31 +0000
Message-Id: <20240122201852.262057-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
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

We can now start making use of our sanitising masks by setting them
to values that depend on the guest's configuration.

First up are VTTBR_EL2, VTCR_EL2, VMPIDR_EL2 and HCR_EL2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 56 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c976cd4b8379..ee461e630527 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -181,7 +181,7 @@ u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
 	return v;
 }
 
-static void __maybe_unused set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
+static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
 {
 	int i = sr - __VNCR_START__;
 
@@ -191,6 +191,7 @@ static void __maybe_unused set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u
 
 int kvm_init_nv_sysregs(struct kvm *kvm)
 {
+	u64 res0, res1;
 	int ret = 0;
 
 	mutex_lock(&kvm->arch.config_lock);
@@ -209,6 +210,59 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		kvm->arch.id_regs[i] = limit_nv_id_reg(IDX_IDREG(i),
 						       kvm->arch.id_regs[i]);
 
+	/* VTTBR_EL2 */
+	res0 = res1 = 0;
+	if (!kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16))
+		res0 |= GENMASK(63, 56);
+	set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
+
+	/* VTCR_EL2 */
+	res0 = GENMASK(63, 32) | GENMASK(30, 20);
+	res1 = BIT(31);
+	set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
+
+	/* VMPIDR_EL2 */
+	res0 = GENMASK(63, 40) | GENMASK(30, 24);
+	res1 = BIT(31);
+	set_sysreg_masks(kvm, VMPIDR_EL2, res0, res1);
+
+	/* HCR_EL2 */
+	res0 = BIT(48);
+	res1 = HCR_RW;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, TWED, IMP))
+		res0 |= GENMASK(63, 59);
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, MTE, MTE2))
+		res0 |= (HCR_TID5 | HCR_DCT | HCR_ATA);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, EVT, TTLBxS))
+		res0 |= (HCR_TTLBIS | HCR_TTLBOS);
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, CSV2, CSV2_2) &&
+	    !kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2))
+		res1 = HCR_ENSCXT;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, EVT, IMP))
+		res0 |= (HCR_TID4 | HCR_TICAB | HCR_TOCU);
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
+		res0 |= HCR_AMVOFFEN;
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1))
+		res0 |= HCR_FIEN;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, FWB, IMP))
+		res0 |= HCR_FWB;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, NV2))
+		res0 |= HCR_NV2;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, IMP))
+		res0 |= (HCR_AT | HCR_NV1 | HCR_NV);
+	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
+	      __vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS)))
+		res0 |= (HCR_API | HCR_APK);
+	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TME, IMP))
+		res0 |= BIT(39);
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP))
+		res0 |= (HCR_TERR | HCR_TEA);
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
+		res0 |= HCR_TLOR;
+	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, IMP))
+		res1 |= HCR_E2H;
+	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
+
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 
-- 
2.39.2

