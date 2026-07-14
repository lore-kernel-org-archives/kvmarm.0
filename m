Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E8F364929
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 10:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024205; cv=none; b=bpIgblaugfzafJYPsUN/9bmV7RutWBIW2PDGy+ycLp/d8ANo4Xh/mM0Qkycptc6K9CHaxa1Cf4/qX6huCbdU1Gu/ttOa+V55S5MxtH1wFbWBBOpmLl5MAqpFltEtTPcW1LcQRV1s2dkXsHZqos8NCNqh8P2xWwxIbOrCeN6PLX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024205; c=relaxed/simple;
	bh=RcHFOcd4cUIFDwkePdeyjmialC76ZU3eCKeO6Mgza2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n4hS8JhZifhiDmFNVpcXQswcvPon4P1PCPdm0Q3MoMqRM7M/ztkC9eKLVbh1QV+93D1KqX6C69yKMM+NptRVbYlD6RpGxgFH19KS8u4X/EMZNkzQjCFodBIzKdZd5ljq8DEB6uleXf9Ue+9PTmzpLvvueOmc5YhgD9fesVInviI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=siO+AR7a; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="siO+AR7a"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784024201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LV5gap+CzXG51tXDcxBhEo+5k8g/SFFulCMXWXH9VaE=;
	b=siO+AR7at9a9PQDirwsaaSNwAwkQ2njbiS2cPxBYp5uutGPJLNLjp/3rw/wHaWKgG3if2M
	daAd6WsZJnCvjuUynbc4rFWrN4hxa4EvoAC9+qJaF9gdSwdkCP99uTm8f2pMxinbJa625V
	Y8Hv4aPnkiSWOO+MiGLAP3SIlmc0sZY=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v5 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
Date: Tue, 14 Jul 2026 11:15:55 +0100
Message-Id: <20260714101601.4142645-3-fuad.tabba@linux.dev>
In-Reply-To: <20260714101601.4142645-1-fuad.tabba@linux.dev>
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The vcpu_{read,write}_sys_reg() accessors are only valid on a VHE host,
so helpers built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be()
cannot be shared with hyp code. exception.c already wraps them in local
helpers that pick the host- or hyp-side accessor via has_vhe().

Rename the host-only implementations to __vcpu_{read,write}_sysreg_vhe()
and turn vcpu_{read,write}_sys_reg() into the context-dispatching
wrappers, so every caller gets the version valid in any context and a
follow-up series can share that emulation code at EL2.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
v5:
  - Named the wrappers vcpu_{read,write}_sys_reg() and renamed the
    host-only implementations to __vcpu_{read,write}_sysreg_vhe(), rather
    than introducing a kvm_vcpu_ prefix. (Oliver)
  - Dropped Vincent's Reviewed-by since the patch changed materially.

 arch/arm64/include/asm/kvm_emulate.h | 20 ++++++++++++++++
 arch/arm64/include/asm/kvm_host.h    |  4 ++--
 arch/arm64/kvm/hyp/exception.c       | 34 ++++++++--------------------
 arch/arm64/kvm/sys_regs.c            |  4 ++--
 4 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c7..429bda6f48d94 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -506,6 +506,26 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
+/*
+ * __vcpu_*_sysreg_vhe() are only valid on a VHE host; wrap them so the same
+ * call site also works at EL2 under nVHE.
+ */
+static inline u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
+{
+	if (has_vhe())
+		return __vcpu_read_sysreg_vhe(vcpu, reg);
+
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
+static inline void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
+{
+	if (has_vhe())
+		__vcpu_write_sysreg_vhe(vcpu, val, reg);
+	else
+		__vcpu_assign_sys_reg(vcpu, reg, val);
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5c..f3c3c86b3d7fb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1215,8 +1215,8 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 		__v;							\
 	})
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
-void vcpu_write_sys_reg(struct kvm_vcpu *, u64, enum vcpu_sysreg);
+u64 __vcpu_read_sysreg_vhe(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg);
+void __vcpu_write_sysreg_vhe(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg);
 
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index bef40ddb16dbc..754e2dc1df54a 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -20,22 +20,6 @@
 #error Hypervisor code only!
 #endif
 
-static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
-{
-	if (has_vhe())
-		return vcpu_read_sys_reg(vcpu, reg);
-
-	return __vcpu_sys_reg(vcpu, reg);
-}
-
-static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
-{
-	if (has_vhe())
-		vcpu_write_sys_reg(vcpu, val, reg);
-	else
-		__vcpu_assign_sys_reg(vcpu, reg, val);
-}
-
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target_mode,
 			      u64 val)
 {
@@ -101,14 +85,14 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 
 	switch (target_mode) {
 	case PSR_MODE_EL1h:
-		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
-		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
+		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
 		break;
 	case PSR_MODE_EL2h:
-		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
-		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
+		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL2);
+		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL2);
+		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
 		break;
 	default:
 		/* Don't do that */
@@ -185,7 +169,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
  */
 static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
 {
-	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	u32 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 	unsigned long old, new;
 
 	old = *vcpu_cpsr(vcpu);
@@ -281,7 +265,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
 	unsigned long spsr = *vcpu_cpsr(vcpu);
 	bool is_thumb = (spsr & PSR_AA32_T_BIT);
-	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	u32 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 	u32 return_address;
 
 	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
@@ -305,7 +289,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	if (sctlr & (1 << 13))
 		vect_offset += 0xffff0000;
 	else /* always have security exceptions */
-		vect_offset += __vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		vect_offset += vcpu_read_sys_reg(vcpu, VBAR_EL1);
 
 	*vcpu_pc(vcpu) = vect_offset;
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 08ba882799d48..c6a416974a61f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -291,7 +291,7 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
 	}
 }
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
+u64 __vcpu_read_sysreg_vhe(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 {
 	struct sr_loc loc = {};
 
@@ -338,7 +338,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
+void __vcpu_write_sysreg_vhe(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
 {
 	struct sr_loc loc = {};
 
-- 
2.39.5

