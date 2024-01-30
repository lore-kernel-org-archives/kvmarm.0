Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CC969E19
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647548; cv=none; b=Y97EZqfeyT7NWIA9RJRnA1q4puqb9KgrU7l6nI6G45tc+9uLEtSz7r/7bXLr8w+XNyHA8M23AMt0+zq5kR/cIaeS2M20jYSV9FDZyh7EPC2RYjQdbtDMA3rWbnQ4EM3vuDy3bgH8RU/+PtMxDbpJBlAb6poUKnBsw0mvXJfpELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647548; c=relaxed/simple;
	bh=m73GaNk6Q1JttW/VA1g/4L96gSDtT/YiwI4oChhKoTg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CVYoSOJxDaqOE5jaHfDY1acEvYiPeSI05ngoi6p4bRXcBZK0au0ORtJMHFuZzBWCpveRXk9jnzz406IHUS2IjrmVRngZHu9BjJQuiA6W+cTsDJj6xFsRviub3/eWO6RA/yKDGq2zquLaF0qqNydHZ90QIjVvgznreI8Ta3sNhfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmWam9MN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmWam9MN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EB5C43394;
	Tue, 30 Jan 2024 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647548;
	bh=m73GaNk6Q1JttW/VA1g/4L96gSDtT/YiwI4oChhKoTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmWam9MNyEL6AvWpwSqfDBcC22kYI8Wz0rldTJPeghxDVE/RGBInJ/yYRKMVdowkz
	 OsjSGCN/ZfRfWoJ1laxFBQWHrYJ9KVl6wc4rMgqECCI/Qb22rHMW5vu8EvJbEqU5KJ
	 4hfNjZdMzMfQ8zTdTMZp6yJEgIH5RMxikND4BV3t5soS5jUOZvwEVuh8apOpf3854r
	 9JhvJmR+1+i8jeSjg2bnY1XvVapPRhk0F5pgMUA6bStoweAt4sWpII9mHTFzDn8VNI
	 a0kNUU95bS2mTVItfmYQI/ILqFrUGJOFFKzPf4BB8iCImG6TiasSVGTmlgyGAUQOK3
	 7+MvrdUI3805Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzK-00GNsE-J8;
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
Subject: [PATCH v2 09/25] KVM: arm64: nv: Correctly handle negative polarity FGTs
Date: Tue, 30 Jan 2024 20:45:16 +0000
Message-Id: <20240130204533.693853-10-maz@kernel.org>
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

Negative trap bits are a massive pain. They are, on the surface,
indistinguishable from RES0 bits. Do you trap? or do you ignore?

Thankfully, we now have the right infrastructure to check for RES0
bits as long as the register is backed by VNCR, which is the case
for the FGT registers.

Use that information as a discriminant when handling a trap that
is potentially caused by a FGT.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 59 +++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 8a1cfcf553a2..ef46c2e45307 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1892,9 +1892,61 @@ static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
 	return __compute_trap_behaviour(vcpu, tc.cgt, b);
 }
 
-static bool check_fgt_bit(u64 val, const union trap_config tc)
+static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
 {
-	return ((val >> tc.bit) & 1) == tc.pol;
+	struct kvm_sysreg_masks *masks;
+
+	/* Only handle the VNCR-backed regs for now */
+	if (sr < __VNCR_START__)
+		return 0;
+
+	masks = kvm->arch.sysreg_masks;
+
+	return masks->mask[sr - __VNCR_START__].res0;
+}
+
+static bool check_fgt_bit(struct kvm *kvm, bool is_read,
+			  u64 val, const union trap_config tc)
+{
+	enum vcpu_sysreg sr;
+
+	if (tc.pol)
+		return (val & BIT(tc.bit));
+
+	/*
+	 * FGTs with negative polarities are an absolute nightmare, as
+	 * we need to evaluate the bit in the light of the feature
+	 * that defines it. WTF were they thinking?
+	 *
+	 * So let's check if the bit has been earmarked as RES0, as
+	 * this indicates an unimplemented feature.
+	 */
+	if (val & BIT(tc.bit))
+		return false;
+
+	switch ((enum fgt_group_id)tc.fgt) {
+	case HFGxTR_GROUP:
+		sr = is_read ? HFGRTR_EL2 : HFGWTR_EL2;
+		break;
+
+	case HDFGRTR_GROUP:
+		sr = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
+		break;
+
+	case HAFGRTR_GROUP:
+		sr = HAFGRTR_EL2;
+		break;
+
+	case HFGITR_GROUP:
+		sr = HFGITR_EL2;
+		break;
+
+	default:
+		WARN_ONCE(1, "Unhandled FGT group");
+		return false;
+	}
+
+	return !(kvm_get_sysreg_res0(kvm, sr) & BIT(tc.bit));
 }
 
 bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
@@ -1969,7 +2021,8 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 		return false;
 	}
 
-	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(val, tc))
+	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu->kvm, is_read,
+							val, tc))
 		goto inject;
 
 	b = compute_trap_behaviour(vcpu, tc);
-- 
2.39.2

