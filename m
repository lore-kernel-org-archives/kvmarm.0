Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B4840C0F
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954740; cv=none; b=qXOM2Gc9MoCcJeybL3mnjKtrQJuHwlA5ejvGrEwF9zXn8NdDuA/6RGAgS2zw190EyXEXr4qh1qinK8Y2TI5BsyY+KyfvktRrcF1tB4e1TdTsNENLOgHAThQZeX/qrIy4PNqmwezdm/JAGDyqT2PEoMZAiovAWBcAOcnbPC6YeDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954740; c=relaxed/simple;
	bh=ATf0ih7gkfEuE/hvRMYfwvXo1cLdsttokMnyWpUrPKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EdJPHSRnC5CfkD+dOJKwGvAm42qFOwoOFmGfXHM4469+ptS5hiLluD5H1XcYjn6+WzwdrF5k4cB4MrAP2SMmfVvI+burPDUM1p+fzGxz51fj5UMpK4eMdthTmNrAaZDxYEB6mBoWf0qQv4n0JGLJqbpIomusQXkSXQ6Yj/rBsb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLMbFUVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLMbFUVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAB5C43609;
	Mon, 22 Jan 2024 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954740;
	bh=ATf0ih7gkfEuE/hvRMYfwvXo1cLdsttokMnyWpUrPKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLMbFUVCGyhhvj9YshkPJ/bwgKy3JJYNtTxhlYizkqL0M0ZrfKh7cvis3A5J5OSMA
	 oVgW5RKeG+Bqs6yY2OKMPDsrft3ef7E5qyTrcHK/F2GA4TPUerJaEEFWvb9i6mtpK+
	 zjy4yr72Nsv3iX5yxSJZQj2T4IOaDjKeeTxFmHgqhusuOvGU25yZlRtz+myaH/lBvi
	 DleqS7aEv0Mm2gxxxon00VS2crSpFlwwr5hQEJl/tRAm7o/5uQpxmy31/LcqD9iZgN
	 d46GQNOmmIMnsB5sgW/S5rTmsxVddDjKUWOs9lQNxuJ0m5sZzjGjR04vGEJvaQ8giK
	 rnJSCEhxYuvzg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0l0-00DjkQ-RU;
	Mon, 22 Jan 2024 20:18:58 +0000
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
Subject: [PATCH 17/25] KVM: arm64: Add Fine-Grained UNDEF tracking information
Date: Mon, 22 Jan 2024 20:18:44 +0000
Message-Id: <20240122201852.262057-18-maz@kernel.org>
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

In order to efficiently handle system register access being disabled,
and this resulting in an UNDEF exception being injected, we introduce
the (slightly dubious) concept of Fine-Grained UNDEF, modeled after
the architectural Fine-Grained Traps.

For each FGT group, we keep a 64 bit word that has the exact same
bit assignment as the corresponding FGT register, where a 1 indicates
that trapping this register should result in an UNDEF exception being
reinjected.

So far, nothing populates this information, nor sets the corresponding
trap bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 21 +++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c   | 12 ------------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e7a6219f2929..4e0ac507ca01 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -240,9 +240,30 @@ static inline u16 kvm_mpidr_index(struct kvm_mpidr_data *data, u64 mpidr)
 
 struct kvm_sysreg_masks;
 
+enum fgt_group_id {
+	__NO_FGT_GROUP__,
+	HFGxTR_GROUP,
+	HDFGRTR_GROUP,
+	HDFGWTR_GROUP = HDFGRTR_GROUP,
+	HFGITR_GROUP,
+	HAFGRTR_GROUP,
+
+	/* Must be last */
+	__NR_FGT_GROUP_IDS__
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
+	/*
+	 * Fine-Grained UNDEF, mimicking the FGT layout defined by the
+	 * architecture. We track them globally, as we present the
+	 * same feature-set to all vcpus.
+	 *
+	 * Index 0 is currently spare.
+	 */
+	u64 fgu[__NR_FGT_GROUP_IDS__];
+
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b39ced4ea331..539b3913628d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1009,18 +1009,6 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 
 static DEFINE_XARRAY(sr_forward_xa);
 
-enum fgt_group_id {
-	__NO_FGT_GROUP__,
-	HFGxTR_GROUP,
-	HDFGRTR_GROUP,
-	HDFGWTR_GROUP = HDFGRTR_GROUP,
-	HFGITR_GROUP,
-	HAFGRTR_GROUP,
-
-	/* Must be last */
-	__NR_FGT_GROUP_IDS__
-};
-
 enum fg_filter_id {
 	__NO_FGF__,
 	HCRX_FGTnXS,
-- 
2.39.2

