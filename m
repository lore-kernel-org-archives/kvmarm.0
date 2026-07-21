Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025733E9C37
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653694; cv=none; b=bsuvuDPMzGT9UNQos+Zn/MXGRZ+0iigYDhASJFsjy6qgPP6vgTtrsOhjphiiSAPKlR6xXY+beXP+ZxGQ4L8hpDipnaz/LONIAxm3ZK84O9VK8WdJ4XjrrsBCyIg1IAHayNjG3PYNX5EwKRSK6uBrm7o6dALuHK1vfzMou4p1DJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653694; c=relaxed/simple;
	bh=vTs8Ovf7rDCrJPLcBGYnCklprk+dRN6pX7cS23ftAXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUO5xRNwdBRKqmO1EtTfXs/rQiW8N3MhqZrXpIPTbWlZ083iaRGZfOokL4CI7qDMKo+ixgsQIH12mNjX6eMiP68KjDwvQgn0YYoN5hhkT/RqurZXGjb5ZQ7PC3/M15kEKCHS4YNA1tHFY+llgUpzJwwMPU4j9/ab7e2E+sgmvaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbchJ8TF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbchJ8TF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A5D1F01558;
	Tue, 21 Jul 2026 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784653687;
	bh=MCWnKkozWEtiXyoTWp66gc5dfcyC018gkbNpUXRcL+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbchJ8TFXyWL9mwO8DgctT8Z6RSHIzMVRQfNkWJWwECs3eaYP5SxPDE/G3YMfp8xQ
	 0563tSoVs+OZKrlakCkLYZoFfZWtfF0F+aS+gPmz8y6uJVpDywIeRKZIAcWr/MOY/z
	 FLnyAQWBRDZ8DfODgPfqAoQA0Zn3Tq/BF5FHZGY1Z8QI3y90QZAwA6gO6BME9Usx1e
	 O53dQbGm6TFWHMWUbcVVWzbu0CGDZ4w2JmPdT91SfT7B6m1XRmehWm3ttXhqcnt5Mj
	 4givebuPvrJrMQNHSITDDgOjM2GfmT/hWwU3a8iRZ/RyaeHN40iKCDZzVibtZQEtTl
	 k1/tTPGyg2iUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmDwr-00000007J9p-1nXg;
	Tue, 21 Jul 2026 17:08:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 6/6] KVM: arm64: vgic-v3: Kill kvm_vgic_global_state.ich_vtr_el2
Date: Tue, 21 Jul 2026 18:07:54 +0100
Message-ID: <20260721170754.3150521-7-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721170754.3150521-1-maz@kernel.org>
References: <20260721170754.3150521-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

kvm_vgic_global_state.ich_vtr_el2 is the last bit of caching that
we can get rid of. Not as bad as a sysreg access, but still worse
than a constant.

Move over to the inlined stuff and remove the cached value.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c          | 3 ++-
 arch/arm64/kvm/vgic-sys-reg-v3.c | 8 ++++----
 arch/arm64/kvm/vgic/vgic-v3.c    | 5 ++---
 arch/arm64/kvm/vgic/vgic-v5.c    | 5 +----
 arch/arm64/kvm/vgic/vgic.h       | 2 +-
 include/kvm/arm_vgic.h           | 2 --
 6 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index fb54f6dad995c..54defcd8240df 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -16,6 +16,7 @@
 #include <asm/sysreg.h>
 
 #include "sys_regs.h"
+#include "vgic/vgic.h"
 
 struct vncr_tlb {
 	/* The guest's VNCR_EL2 */
@@ -1904,7 +1905,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	/* ICH_HCR_EL2 */
 	resx.res0 = ICH_HCR_EL2_RES0;
 	resx.res1 = ICH_HCR_EL2_RES1;
-	if (!(kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_EL2_TDS))
+	if (!(vgic_ich_vtr() & ICH_VTR_EL2_TDS))
 		resx.res0 |= ICH_HCR_EL2_TDIR;
 	/* No GICv4 is presented to the guest */
 	resx.res0 |= ICH_HCR_EL2_DVIM | ICH_HCR_EL2_vSGIEOICount;
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index bdc2d57370b27..89315336b9d3c 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -35,12 +35,12 @@ static int set_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 
 	vgic_v3_cpu->num_id_bits = host_id_bits;
 
-	host_seis = FIELD_GET(ICH_VTR_EL2_SEIS, kvm_vgic_global_state.ich_vtr_el2);
+	host_seis = FIELD_GET(ICH_VTR_EL2_SEIS, vgic_ich_vtr());
 	seis = FIELD_GET(ICC_CTLR_EL1_SEIS_MASK, val);
 	if (host_seis != seis)
 		return -EINVAL;
 
-	host_a3v = FIELD_GET(ICH_VTR_EL2_A3V, kvm_vgic_global_state.ich_vtr_el2);
+	host_a3v = FIELD_GET(ICH_VTR_EL2_A3V, vgic_ich_vtr());
 	a3v = FIELD_GET(ICC_CTLR_EL1_A3V_MASK, val);
 	if (host_a3v != a3v)
 		return -EINVAL;
@@ -69,9 +69,9 @@ static int get_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	val |= FIELD_PREP(ICC_CTLR_EL1_ID_BITS_MASK, vgic_v3_cpu->num_id_bits);
 	val |= FIELD_PREP(ICC_CTLR_EL1_SEIS_MASK,
 			  FIELD_GET(ICH_VTR_EL2_SEIS,
-				    kvm_vgic_global_state.ich_vtr_el2));
+				    vgic_ich_vtr()));
 	val |= FIELD_PREP(ICC_CTLR_EL1_A3V_MASK,
-			  FIELD_GET(ICH_VTR_EL2_A3V, kvm_vgic_global_state.ich_vtr_el2));
+			  FIELD_GET(ICH_VTR_EL2_A3V, vgic_ich_vtr()));
 	/*
 	 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
 	 * Extract it directly using ICC_CTLR_EL1 reg definitions.
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 734fa31387235..91514d6faf74d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -490,9 +490,9 @@ void vgic_v3_reset(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->arch.vgic_cpu.num_id_bits = FIELD_GET(ICH_VTR_EL2_IDbits,
-						    kvm_vgic_global_state.ich_vtr_el2);
+						    vgic_ich_vtr());
 	vcpu->arch.vgic_cpu.num_pri_bits = FIELD_GET(ICH_VTR_EL2_PRIbits,
-						     kvm_vgic_global_state.ich_vtr_el2) + 1;
+						     vgic_ich_vtr()) + 1;
 }
 
 void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
@@ -949,7 +949,6 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	 */
 	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
 	kvm_vgic_global_state.can_emulate_gicv2 = false;
-	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
 
 	/* GICv4 support? */
 	if (info->has_v4) {
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 16bc0a670d3e5..4e3e4db24e773 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -40,7 +40,6 @@ static void vgic_v5_get_implemented_ppis(void)
 int vgic_v5_probe(const struct gic_kvm_info *info)
 {
 	bool v5_registered = false;
-	u64 ich_vtr_el2;
 	int ret;
 
 	kvm_vgic_global_state.type = VGIC_V5;
@@ -83,14 +82,12 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	}
 
 	kvm_vgic_global_state.has_gcie_v3_compat = true;
-	ich_vtr_el2 = vgic_ich_vtr();
-	kvm_vgic_global_state.ich_vtr_el2 = (u32)ich_vtr_el2;
 
 	/*
 	 * The ListRegs field is 5 bits, but there is an architectural
 	 * maximum of 16 list registers. Just ignore bit 4...
 	 */
-	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
+	kvm_vgic_global_state.nr_lr = (vgic_ich_vtr() & 0xf) + 1;
 
 	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
 	if (ret) {
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b76bb6e56de37..b71d486ae5145 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -92,7 +92,7 @@ static inline u64 kvm_get_guest_vtr_el2(void)
 {
 	u64 vtr;
 
-	vtr  = kvm_vgic_global_state.ich_vtr_el2;
+	vtr  = vgic_ich_vtr();
 	vtr &= ~KVM_ICH_VTR_EL2_RES0;
 	vtr |= KVM_ICH_VTR_EL2_RES1;
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fe49fb56dc3c9..bd1bb03500b30 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -176,8 +176,6 @@ struct vgic_global {
 	/* GICv3 compat mode on a GICv5 host */
 	bool			has_gcie_v3_compat;
 
-	u32			ich_vtr_el2;
-
 	/* GICv5 PPI capabilities */
 	struct {
 		DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
-- 
2.47.3

