Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D32837C109
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254182; cv=none; b=dvn82KXXwxwW/Cf1lp5bRTtVy9vTNHNRcdHsNUD+q6NnsBH2LMbqbUK2cu4CtoPkRh0qkYRP0iYCVsD6hfjFFtw4r7G32Ek2pp+X1jdjY1CFIXkU4FQLKsOdNRE3lV7powo/PT2VFXC03MMumG/k2j0RGFj1TpcBIMfoRt0CoQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254182; c=relaxed/simple;
	bh=9Dv/wj4BXR+93xnM/55FQRZfJhUM3XB6ykASoHyxW48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5o12AaDnrofSFWSy/E9PqfyBiZnDcBbG/HdgyWKeXxII0yYvuy7uJHAs87bezsLuvJMc2GBAhA+GRJqd9ge+MwuWGjw8CwICB3CoQjZmkorEfaf+cZhVLBsDJ7TbIunoP+FpjRq/onC/AYBV78gox/yp/X0zIfAsJWU3YaGEnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOEQOpwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOEQOpwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D411C2BCB3;
	Wed, 15 Apr 2026 11:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254182;
	bh=9Dv/wj4BXR+93xnM/55FQRZfJhUM3XB6ykASoHyxW48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOEQOpwrKpeAVAtutdhPnSNmmuaWL2dFm5B5BwMNFmLx2L4rz4DBQAaD4eY1eAZRl
	 TMSeOaIuMfPawL/I8MU0pTf5ROEKYs/XVXFqBFKjXbAl6dlIqLDpOHQvLJ+YBqiba5
	 P7Rtsfc3ffCVJDo4SYJPJ6brhusNWXaOgze3GiQIPmBrGVDj9/wwv6zkpYo/Cqysdc
	 G947tfPNy5HbP7ds7klnUCk2fxUNNmMhe5aSyH4XW5nzQb9eSRqYmeX1EZn9CIq2pO
	 nVtggc1Bb6zvkAKCE7/ZIOaMH8o8CQbdoQIYpco+uvWehgIfyFKE0SQ6M3SsGUXGCm
	 wsd69eVZl0f4Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyqy-0000000Bqsi-32Yq;
	Wed, 15 Apr 2026 11:56:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 08/18] KVM: arm64: vgic: Rationalise per-CPU irq accessor
Date: Wed, 15 Apr 2026 12:55:49 +0100
Message-ID: <20260415115559.2227718-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite adding the necessary infrastructure to identify irq types,
vgic_get_vcpu_irq() treats GICv5 PPIs in a special way, which
impairs the readability of the code.

Use the existing irq classifiers to handle per-CPU irqs for all
vgic types, and let the normal control flow reach global interrupt
handling without any v5-specific path.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 3ac6d49bc4876..b697678d68b01 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -106,24 +106,23 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 
 struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
 {
+	enum kvm_device_type type;
+
 	if (WARN_ON(!vcpu))
 		return NULL;
 
-	if (vgic_is_v5(vcpu->kvm)) {
-		u32 int_num, hwirq_id;
-
-		if (!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid))
-			return NULL;
-
-		hwirq_id = FIELD_GET(GICV5_HWIRQ_ID, intid);
-		int_num = array_index_nospec(hwirq_id, VGIC_V5_NR_PRIVATE_IRQS);
+	type = vcpu->kvm->arch.vgic.vgic_model;
 
-		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
-	}
+	if (__irq_is_sgi(type, intid) || __irq_is_ppi(type, intid)) {
+		switch (type) {
+		case KVM_DEV_TYPE_ARM_VGIC_V5:
+			intid = vgic_v5_get_hwirq_id(intid);
+			intid = array_index_nospec(intid, VGIC_V5_NR_PRIVATE_IRQS);
+			break;
+		default:
+			intid = array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
+		}
 
-	/* SGIs and PPIs */
-	if (intid < VGIC_NR_PRIVATE_IRQS) {
-		intid = array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
 		return &vcpu->arch.vgic_cpu.private_irqs[intid];
 	}
 
-- 
2.47.3

