Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FF63DC4C4
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782457475; cv=none; b=kJIx4+GAqBzLQjmvLWr6uT2tbVnuCTmSjjlAC/poctuAD6dd1f5odkdvX9xyc3716N1JWAX1K09Kw9FssqkniUh9Tt1fBQSFar4RhqfCMxIJ28NbMwkEMEGdP2r9zllIUtpvIc4OZziWB7tIJ9krAjyoVoFlrM8bMP6QzRSHCGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782457475; c=relaxed/simple;
	bh=b8oLRDjW1XqDHlvfjux0EA89xL6awtH3hvKYm4XJjZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=swBaDNU4Ew2/2It6dyMdpMCltlK67ZR0AXJKD0YeEvL5Yw/gpjfTCyiIaVtQMmmvGp4/OfI48L8b9mHT7hTM4NPegf10OovoRSUaeqqlEv53zL+q06PddkfxvhQ7cXJSBS9LE6X1WNJ6r9W+/io7GjGmXZ1knXzAVPRRtVj/sk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ca515uk9; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ca515uk9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782457471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eJOIv5y3265WBGZLY+kMBJBpQgKZfZP/G0nDS8Gem9g=;
	b=Ca515uk9RWqS4o0ekFj8+/hqcTO3KLcVDX624/QWpNbXaPOqvZ14bYSvlizztu0mgSxjGM
	g3vSO4GH7OhBDh6bSFHpg9WhcpZdttdV93dtCNkTy8HBFjfh5aMQoD0VSDny6dj9+xu6o1
	ZdCbKP7F7pDuOqqkDAG+g/qzRTTirpQ=
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
Subject: [PATCH v3 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
Date: Fri, 26 Jun 2026 08:04:02 +0100
Message-Id: <20260626070408.3420953-3-fuad.tabba@linux.dev>
In-Reply-To: <20260626070408.3420953-1-fuad.tabba@linux.dev>
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
shared with hyp code. exception.c already wraps them in
__vcpu_{read,write}_sys_reg(), which pick the host- or hyp-side accessor
via has_vhe() and so are valid in any context.

Move those wrappers to kvm_emulate.h as kvm_vcpu_{read,write}_sys_reg()
and switch the callers over, so a follow-up series can share that
emulation code at EL2.

No functional change intended.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++++++---
 arch/arm64/kvm/hyp/exception.c       | 34 ++++++++--------------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c7..80b30fead3d16 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
+static inline u64 kvm_vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+{
+	if (has_vhe())
+		return vcpu_read_sys_reg(vcpu, reg);
+
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
+static inline void kvm_vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+{
+	if (has_vhe())
+		vcpu_write_sys_reg(vcpu, val, reg);
+	else
+		__vcpu_assign_sys_reg(vcpu, reg, val);
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
@@ -516,9 +532,9 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 
 		r = vcpu_has_nv(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
 
-		sctlr = vcpu_read_sys_reg(vcpu, r);
+		sctlr = kvm_vcpu_read_sys_reg(vcpu, r);
 		sctlr |= SCTLR_ELx_EE;
-		vcpu_write_sys_reg(vcpu, sctlr, r);
+		kvm_vcpu_write_sys_reg(vcpu, sctlr, r);
 	}
 }
 
@@ -533,7 +549,7 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
 	r = is_hyp_ctxt(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
 	bit = vcpu_mode_priv(vcpu) ? SCTLR_ELx_EE : SCTLR_EL1_E0E;
 
-	return vcpu_read_sys_reg(vcpu, r) & bit;
+	return kvm_vcpu_read_sys_reg(vcpu, r) & bit;
 }
 
 static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index bef40ddb16dbc..2cb68dc7d441e 100644
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
+		vbar = kvm_vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		sctlr = kvm_vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+		kvm_vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
 		break;
 	case PSR_MODE_EL2h:
-		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL2);
-		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
+		vbar = kvm_vcpu_read_sys_reg(vcpu, VBAR_EL2);
+		sctlr = kvm_vcpu_read_sys_reg(vcpu, SCTLR_EL2);
+		kvm_vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
 		break;
 	default:
 		/* Don't do that */
@@ -185,7 +169,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
  */
 static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
 {
-	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	u32 sctlr = kvm_vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 	unsigned long old, new;
 
 	old = *vcpu_cpsr(vcpu);
@@ -281,7 +265,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
 	unsigned long spsr = *vcpu_cpsr(vcpu);
 	bool is_thumb = (spsr & PSR_AA32_T_BIT);
-	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	u32 sctlr = kvm_vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 	u32 return_address;
 
 	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
@@ -305,7 +289,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	if (sctlr & (1 << 13))
 		vect_offset += 0xffff0000;
 	else /* always have security exceptions */
-		vect_offset += __vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		vect_offset += kvm_vcpu_read_sys_reg(vcpu, VBAR_EL1);
 
 	*vcpu_pc(vcpu) = vect_offset;
 }
-- 
2.39.5

