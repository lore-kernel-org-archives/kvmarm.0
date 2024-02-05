Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F30B17584
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 10:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707129290; cv=none; b=ea+RykaWYH9rqTXkAw6JXRwwPdMrq5AcUfxLI2KVbscMLee2Rc60TLWKKhXZNcsPmmjUHMJySxe0cZaHKX9MbuEz2NtMIXIW6b+zbb9LElzG7JbAlGzqr9kcWrUyXqefaP24YqV7WouGUw9QoPdMBY/vCYv33+w1Awlm/mK58ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707129290; c=relaxed/simple;
	bh=sGpYjJLG8+pnEDEI2UMEpWKsKmNFiEZnTbigmPxqf2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uTS8DPVYUmu2B4JUteeIQLXnm5Vdoy1smXfswX/svpxqW2zywv8jitJw+h2DFJy0fZML1XtY1NvWKGwRmTpYgLjSht0gX498gtWn43LvuvWBRo1+RjhFXmo4mCmttfnw4WtQtw42i8GuU4eElWh2sMqj7bt0+r2fkTNQD05b8no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RzMwLIQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RzMwLIQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C9EC43390;
	Mon,  5 Feb 2024 10:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707129290;
	bh=sGpYjJLG8+pnEDEI2UMEpWKsKmNFiEZnTbigmPxqf2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzMwLIQh/JQHDFMezb/tC4ecSK5LaePI4p2YSYoVGo4Osxwz2W2CLoCW8xuN2QvrQ
	 v+yJN61IFdC/X4fBjGNd/QDKv1K/6d1JLmruPsm+jCUDLL1LDUYuHLQMpo1FLl9q2W
	 9x01NKYE6MKEQbu7IRubWCtW38UdkHodccXT6+JEWmJjbuZHITzadEexKNk9HsffbA
	 T25fxHA0oP21ki4oGR4A4yaJckzhzaqqv7BC8to9ZeLQ8EO1PNTwuGhEWpdvl2F6xs
	 5vqlMmb1dnRYF4H/hbPHW5Mu6o7Dhy/vkLosCyRFkbhjFgyM3JDYhgq7OcEUXqnZ8k
	 TjbSHqJ4gYTVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rWwJM-000Nc3-A1;
	Mon, 05 Feb 2024 10:34:48 +0000
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
Subject: [PATCH v3 17/26] KVM: arm64: Add Fine-Grained UNDEF tracking information
Date: Mon,  5 Feb 2024 10:34:22 +0000
Message-Id: <20240205103431.1104133-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
References: <20240205103431.1104133-1-maz@kernel.org>
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

