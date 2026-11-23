Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795461923;
	b=HQy1ANpXdsB3xhYuvewUa0dY060J4KJCGPFs5oP+niDWbOicj8T8d63D2NqNITF4eFLT
	 UxGLOAiE5RiypkvrBva1GFHDxMSxqHV518dUua+JBLPrJW0qEV/JMcLqv8ev/rJ4EDyPY
	 W4uYRjwB4BErVA3Tq+Oi7FON7muHzdAoLLBMA8wIBsnS+E9einPeh7tu3pxJM7vObaKlE
	 TFWKAxGZpS39kZvyVEfHZmWyFRbfCgcv3R1xh/Kn5Q4WQdscYXkEMHe0oCQAoDkgQB0rd
	 JyoPW2+ahU0KErWYEtoElCMz24+kO3XRLvXGuJzkKtw0riPO1dHjIv/iwTQAtS6K8OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461923;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=/ragaaKMlKwCffeuTGxlwHK3dNh4IOsJmPtxIjEmZmU=;
	b=q1qkCKyevHcWoUBAB2zZ5nYC+B0OR3XUOJO8n1I5+retDTshLU5yKMLLZVUnzbfkGp+6
	 t8wlvrQEPAjBA9KuAulORFcBp7jfS0bp1RG4BovBF4H5E+2h75p2EBzbe+/86uVDiWSg/
	 8wRBqiIiPC350Q745EKdFO/TEckxUbziHE9n2tcCfO8yQNRl/2vpPlRsWa+wRQF3QwSUf
	 a1cfE3LsjOm0luU6TaBkEjFD+qzfTzzghmv8CwVzJqpHPAwj5oSXogYEevW0jCixMH8Zi
	 7FN3BffK/skjymzzHt6ItR9a+AFAM5+xy19GT9m0AP+iHyEulOxXaF7VkHRrVNhmbxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gbPAFq96;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2E1606A31E;
	Mon, 23 Nov 2026 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gbPAFq96
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBE11F000D8;
	Mon, 23 Nov 2026 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795461923;
	bh=/ragaaKMlKwCffeuTGxlwHK3dNh4IOsJmPtxIjEmZmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbPAFq96JH/QABr9L2sR0xpZiGIBgNZ9ZADAXjeCqF1ez34ShfAk7OQVMReca8fEY
	 iKLN43gjlMrcSEyQDxAerUNQp223TTqJ8B0D73whWivvGOqAATRKp4QVHahVflBvoY
	 VQvGXn9zurparhsG3scX4T0nt/9LPdplBZfIELwPrlAdOyh88v6PLCmnjByFH/e6Tu
	 dsteF8/+rkHBWca6ueSvJ2t2hAU2poKe3g8QA3K13fRQ3Sf/LbTYvytvT1D6jytyhQ
	 bq9ZVxT893y+5CuRZoXCN+npgrnIAUK3cNO+yXXL41CLBupv0yd7AGcNrfKCyTXnYS
	 LJGFTc2fuHebw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xVZfF-00000002A6V-23e4;
	Mon, 23 Nov 2026 19:25:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 2/3] KVM: arm64: Add GIC idregs sanitisation to common framework
Date: Mon, 23 Nov 2026 19:24:56 +0000
Message-ID: <20261123192457.8700-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123192457.8700-1-maz@kernel.org>
References: <20261123192457.8700-1-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It takes no least than 3 ID registers to describe whether a GICv3 or
GICv5 is supported. Define the sanitisation tables for the relevant
fields and the set of relevant callbacks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 56 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 40965513ebacf..7e702ce587a48 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -436,6 +436,23 @@ static bool feat_vmid16(struct kvm *kvm)
 	return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
 }
 
+static bool feat_gicv3(struct kvm *kvm)
+{
+	return (irqchip_in_kernel(kvm) &&
+		kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
+}
+
+static bool feat_gicv3_aarch32(struct kvm *kvm)
+{
+	return (kvm_supports_32bit_el0() && feat_gicv3(kvm));
+}
+
+static bool feat_gcie(struct kvm *kvm)
+{
+	return (irqchip_in_kernel(kvm) &&
+		kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5);
+}
+
 static const struct reg_bits_to_feat_map hfgrtr_feat_map[] = {
 	NEEDS_FEAT(HFGRTR_EL2_nAMAIR2_EL1	|
 		   HFGRTR_EL2_nMAIR2_EL1,
@@ -1357,6 +1374,42 @@ static const struct reg_bits_to_feat_map id_aa64mmfr3_el1_feat_map[] = {
 static const DECLARE_IDREG_FEAT_MAP(id_aa64mmfr3_el1_desc, ID_AA64MMFR3_EL1,
 				    id_aa64mmfr3_el1_feat_map, FEAT_AA64EL1);
 
+static const struct reg_bits_to_feat_map aa64pfr0_gicv3[] = {
+	ENUM_FEAT(ID_AA64PFR0_EL1_GIC_IMP, feat_gicv3 ),
+	ENUM_FEAT(ID_AA64PFR0_EL1_GIC_NI, NULL ),
+};
+
+static const struct reg_bits_to_feat_map id_aa64pfr0_el1_feat_map[] = {
+	NEEDS_FEAT_FIELD(ID_AA64PFR0_EL1_GIC, aa64pfr0_gicv3),
+};
+
+static const DECLARE_IDREG_FEAT_MAP(id_aa64pfr0_el1_desc, ID_AA64PFR0_EL1,
+				    id_aa64pfr0_el1_feat_map, FEAT_AA64EL1);
+
+static const struct reg_bits_to_feat_map pfr1_gicv3[] = {
+	ENUM_FEAT(ID_PFR1_EL1_GIC_GICv3, feat_gicv3_aarch32),
+	ENUM_FEAT(ID_PFR1_EL1_GIC_NI, NULL),
+};
+
+static const struct reg_bits_to_feat_map id_pfr1_el1_feat_map[] = {
+	NEEDS_FEAT_FIELD(ID_PFR1_EL1_GIC, pfr1_gicv3),
+};
+
+static const DECLARE_IDREG_FEAT_MAP(id_pfr1_el1_desc, ID_PFR1_EL1,
+				    id_pfr1_el1_feat_map, FEAT_AA64EL1);
+
+static const struct reg_bits_to_feat_map aa64pfr2_gcie[] = {
+	ENUM_FEAT(ID_AA64PFR2_EL1_GCIE_IMP, feat_gcie),
+	ENUM_FEAT(ID_AA64PFR2_EL1_GCIE_NI, NULL),
+};
+
+static const struct reg_bits_to_feat_map id_aa64pfr2_el1_feat_map[] = {
+	NEEDS_FEAT_FIELD(ID_AA64PFR2_EL1_GCIE, aa64pfr2_gcie),
+};
+
+static const DECLARE_IDREG_FEAT_MAP(id_aa64pfr2_el1_desc, ID_AA64PFR2_EL1,
+				    id_aa64pfr2_el1_feat_map, FEAT_AA64EL1);
+
 static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] = {
 	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
 		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
@@ -1468,6 +1521,9 @@ void __init check_feature_map(void)
 
 static const struct reg_feat_map_desc *idreg_feat_maps[] = {
 	&id_aa64mmfr3_el1_desc,
+	&id_aa64pfr0_el1_desc,
+	&id_aa64pfr2_el1_desc,
+	&id_pfr1_el1_desc,
 };
 
 static struct resx compute_idreg_field_deps(struct kvm *kvm,
-- 
2.47.3

