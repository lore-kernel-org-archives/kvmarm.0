Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1B1537E3
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916716; cv=none; b=iER6qGqL6UJpza012jQeLD2EYVDgkeRRSOjEIuytxVEDrTgTIWafXxReZXqsTyaWCQiIullV3+g91Ek1OZqfE5HixGbmvqPFToHhfx7smSipWO1MttyJ8aSW4KQ/YVvNuyhzYfbTIGRg3gThcXqirTOt9uIck51IB7hlx5cknmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916716; c=relaxed/simple;
	bh=sGpYjJLG8+pnEDEI2UMEpWKsKmNFiEZnTbigmPxqf2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MdLwdeDpjUVO4ASfXSL9tKm1d+wgOnKDcLGsqOxRQHQcK5T+Oxgfz37vnTQT8RcGzACxY20D90cnwq8+c5Hb21Th/BIa+rkuJGdPHjygK0gevwNHhnZTkrZiw9hcWg5VVd2FBTzg2eI9uYF3N6OZQcDGfAeTD7aX/ZVJr7Y2Imk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyBIxHLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyBIxHLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E7DC433F1;
	Wed, 14 Feb 2024 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916716;
	bh=sGpYjJLG8+pnEDEI2UMEpWKsKmNFiEZnTbigmPxqf2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyBIxHLZjLr9NMz2UJ8hwCM5lv7pUrbCpXugoHuzRadj4RxnUolbV9KoANu7AYJ9k
	 mIZ26IRmJRhuqz7unulFZTUo2grtgk4qgnOFkNTJTjomUO5SW8aSXvvErYb3yklwH3
	 Wn8iwOd82Fmxrjo74M8q9uKXLOKgzJlxbLBB6Y/ZHxbfdTy8DAAaVoVWSQMPf4QAJd
	 P2bZ+MqCZYshUVJ9CgucUMuxAtF+ffMdBfUEEyyzcNyyQ+yPixwOWQdZUyHPBYGl0r
	 SGQeN9kjaw7LijqbkgmDlzVdYnOkxtINf1kl18zY8zbusKTh4gwq2zTl63X7nfuHZf
	 Bd4ehp+/WNuTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9m-00394l-6H;
	Wed, 14 Feb 2024 13:18:34 +0000
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
Subject: [PATCH v4 17/26] KVM: arm64: Add Fine-Grained UNDEF tracking information
Date: Wed, 14 Feb 2024 13:18:18 +0000
Message-Id: <20240214131827.2856277-18-maz@kernel.org>
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
index 914fd54179bb..c69b258fc989 100644
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
index 4f2a32a8f247..b67078b8271b 100644
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

