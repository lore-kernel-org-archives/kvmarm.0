Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613D73BED7D
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268817; cv=none; b=F/J34W2zzcrMIh+8r6hJxUrffqXDycr9MqUAiFikkWRcI/ZAtVWermYI3mmB/TyHlwzfYedHUHVgjeDqfUQLAOBnrDKlQlInDzpolaJwRH1ueTyTJddUbsN2w/8XGmjqUNmF1c2/KFPgQ+ZDePYHFQ0UcNdBAV4ZcC5BJguyZJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268817; c=relaxed/simple;
	bh=4O2tjpioJqd//0KbFaz1sYAXnYomHj/ux0W5kwRiKFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXs5RwqOy0u88SGVCVQs1rnAv+dpq3fWwOEyXrZ+QXATRDVe/9mHIFQ6d5B5UWZxrOHhhpLp7EN5YDmqGGrG3RO9kl6rFACekoBxZVlc6R1ZXA9iKycVsSZgbP2vfg9M0E1nxxsdMUtRHowO+0LDVWCq4DitH2QgetxvKjkJdzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cR1OSIlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cR1OSIlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833871F0089E;
	Wed, 20 May 2026 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268813;
	bh=QRG2UUB+bvCAJewpeLGo2zr3hssMfYBAjZROWVUDPsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cR1OSIlTlRJlCgyc0nterhjdN7TG11G+i3IDIwwOHMq1vdQoDsbX/IZHlpSKKrTkf
	 W+WPw3P4eo8T3qaSf03yZGvApTawSW6+bkcmp80Z1qn3+vQzX4CR0r10o+3XO1a7jp
	 5Vhec+oQQVuZv7F/mFDMMvoE+chLE5ZOTWcAVPYRuRr/yqSygTv59ujLj8Si3gKMB7
	 vIqYTBH0DQu1o2zxx0LK8Sise+6yvdcI66DbyBNRC85EEm8CBhBaoV7M1lH6XHgSnR
	 TLqJOf254Hi8MHhuHMgQGJKtbgU5XKr+VzVz1CYUWQ5Z4PEoRLgIYPVBI+e/cUWvLU
	 ZpgRfwb3O7AWQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd63-00000004IaV-3WyX;
	Wed, 20 May 2026 09:20:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 08/18] KVM: arm64: vgic: Rationalise per-CPU irq accessor
Date: Wed, 20 May 2026 10:19:39 +0100
Message-ID: <20260520091949.542365-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Despite adding the necessary infrastructure to identify irq types,
vgic_get_vcpu_irq() treats GICv5 PPIs in a special way, which
impairs the readability of the code.

Use the existing irq classifiers to handle per-CPU irqs for all
vgic types, and let the normal control flow reach global interrupt
handling without any v5-specific path.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
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

