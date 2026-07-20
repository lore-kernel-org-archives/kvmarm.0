Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A597426438
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553763; cv=none; b=s+d1/yeh+5/oZmgslWcwS1SXpn7/pDXzK2lFR/ziiRvc9cJBc7D0WNRcAqIiMiFfOSJ+NoH0RwiADYC6gBCDghbJb93QHB+MfOXL6b1DUwG9Ph/XvmDVIIHtj5YBVbRaLm6ngseRwTqRRupdPx6YbO51RLoattUEII2bHNEnyAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553763; c=relaxed/simple;
	bh=RffESpG93j+KSJUdPxLCDUPRb809kIq3cx+7BmNeEMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYMzkmhtvxBo1zb+LC9eezp4WYmkaWoKtHtXnrYmeBXZeyEimnU2PMt4lLlBJ5a+fCGQisXCTjWa6J4m30kn8H2Gv1zdjhgLI+UHeiDc4npkI7yx6ixXP5CDY+f5zfECnWbLEbhTzYNIFNWnN2rjqH5xWw4F6zMc6r/PSA6OqNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuRJydzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuRJydzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5609A1F00ADB;
	Mon, 20 Jul 2026 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784553761;
	bh=mysYLAOcgRXAMfXwBbgWe+Khp8cP0XxEbUdBU8szG/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuRJydzZpYJzQD0zEzLWvYr+Ca/AuSKGldaFcklxSx2+fgr3cVkBART7LNk3LiDXh
	 2PjrgW+B2PcbBY9912ALmPovK14sO4pQv6Sn8sWYw8RZWFuAi+E+IWdG5QjcYSLT6k
	 yHRANhw6B7pxEJ0qZcAmAlKX6/VFmDMAFXnSxuNw1JKIhyjbvAZbMAjCm3Rmg2c8pf
	 BeMP5iVxZb57giDNbkpXZ7gWMDt9Gm3+6pDoHsC85FRcFQKmZZJpKean1UpelltYPj
	 tcgqcscdP0AvO8Kzgd4uboPk8H4OZe7sv+NUt2GIEgMJEeiC1Vg2NN6CXYBYwUscsa
	 oG2P9muAwS9VQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wlnx9-00000006oKK-2sjx;
	Mon, 20 Jul 2026 13:22:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5/5] KVM: arm64: vgic-v3: Kill kvm_vgic_global_state.ich_vtr_el2
Date: Mon, 20 Jul 2026 14:22:20 +0100
Message-ID: <20260720132220.2143486-7-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720132220.2143486-1-maz@kernel.org>
References: <20260720132220.2143486-1-maz@kernel.org>
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
 arch/arm64/kvm/nested.c          |  3 ++-
 arch/arm64/kvm/vgic-sys-reg-v3.c |  8 ++++----
 arch/arm64/kvm/vgic/vgic-v3.c    |  5 ++---
 arch/arm64/kvm/vgic/vgic-v5.c    |  5 +----
 arch/arm64/kvm/vgic/vgic.h       | 22 +++++++++++-----------
 include/kvm/arm_vgic.h           |  2 --
 6 files changed, 20 insertions(+), 25 deletions(-)

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
index 68d4a486df0a1..7682cbbe3d8bf 100644
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
@@ -966,7 +966,6 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
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
index 4f65a210041ff..e709ef8dd97af 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -71,17 +71,6 @@
 				 ICH_VTR_EL2_IDbits)
 #define KVM_ICH_VTR_EL2_RES1	ICH_VTR_EL2_nV4
 
-static inline u64 kvm_get_guest_vtr_el2(void)
-{
-	u64 vtr;
-
-	vtr  = kvm_vgic_global_state.ich_vtr_el2;
-	vtr &= ~KVM_ICH_VTR_EL2_RES0;
-	vtr |= KVM_ICH_VTR_EL2_RES1;
-
-	return vtr;
-}
-
 /*
  * As per Documentation/virt/kvm/devices/arm-vgic-its.rst,
  * below macros are defined for ITS table entry encoding.
@@ -197,6 +186,17 @@ static inline u64 vgic_ich_vtr(void)
 	return vtr;
 }
 
+static inline u64 kvm_get_guest_vtr_el2(void)
+{
+	u64 vtr;
+
+	vtr  = vgic_ich_vtr();
+	vtr &= ~KVM_ICH_VTR_EL2_RES0;
+	vtr |= KVM_ICH_VTR_EL2_RES1;
+
+	return vtr;
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
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

