Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5699171B48
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706647550; cv=none; b=C3OiUnKXQN5Gn3O9pcnyX4wHFIENcvxfdifeETiYi9ZVrp8LDT+0ew/ZFNue2qobFJMFvORYmCEEAuSG6Bkb9Nk4zUI9xmoCIrL5ofjBeYxw2ip5+ijdt33/R/PXcx17iMnN+xl+O0DmVw7GQcnDvUAwSdX/Rp9HAuXUmCSgNO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706647550; c=relaxed/simple;
	bh=B/6FlZ3nZ7pe9HDUXR4jrSO+oREhKeJWYRg3IBNZB1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ggh4Z8P4iHYzT8x3PpLeBVPJoZ19zD7nqTUpAskqcgXPD5wveOD20rSNbBgZ3godmmZVUgtqxp+iDKBqbjaMc6m9PT600uRYaLDxi5pmiUuJkzsYJ04/ES7T8OEfmhHFleVnibALIgQSK5VcuXTVb8Sb37IMLdZGOdFnHSoRctE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a3MxQ+ar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a3MxQ+ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AC0C43399;
	Tue, 30 Jan 2024 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706647550;
	bh=B/6FlZ3nZ7pe9HDUXR4jrSO+oREhKeJWYRg3IBNZB1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3MxQ+arsXyHEtjWJvr4/8PkIUhgzcQkgdvYmqJdmxD4jGuU+WQy2503xRBRMXT48
	 ARti5zSPQMFIgyAG/jUSPfUAGYKwr+CYKVt1U1DKEusG4XgaK61xE+qq5Nk0+MRxYW
	 cyr97hyD+G2qF3LbhY2KBcQXR+mwsZ1Yahs/QpZoLrrtyxn6SSOM8uLpSDmmTG7fPF
	 awu/+Ptd+azAHYACZYD3sfmoy500QEkcd3O28/oez37HN2kZhvTi0i7p349XYB4kIr
	 I8ircB2a1w2Ahv8OfS3Ov0yw1Ft1DhWNJttkmufi0sg40QKON5Huhp0cRSjAbGkXWT
	 /RyhKJFXtUjHw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rUuzM-00GNsE-7X;
	Tue, 30 Jan 2024 20:45:48 +0000
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
Subject: [PATCH v2 17/25] KVM: arm64: Add Fine-Grained UNDEF tracking information
Date: Tue, 30 Jan 2024 20:45:24 +0000
Message-Id: <20240130204533.693853-18-maz@kernel.org>
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
index b1a2b4cbc721..a7c3b9d7ec73 100644
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

