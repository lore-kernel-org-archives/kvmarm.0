Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2781B488D9A
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785331116; cv=none; b=ObqdOtzXdx5pXzTUtOQmrt1qLItREgcbjcW+sceE/LqBlB0hfzL9QPvPQ67QuOqNzOahVVPOU72RiJ8FTTjXETjBT4nMXBkxe4y2ozylVp42OFgfnYXGPM4JjvKv8VmEisj6J6VTz6thDRQ31pnXvssXMQLoa3NW6xl7XuNloeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785331116; c=relaxed/simple;
	bh=ifSPWQtYb8Tfnx8ljRSFlpqZihdZjPjVUdNtREdVkY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q7kfUkjhTeWHRC/0lPqwc/VBHZIkEPruE0Tc0ZTgiuWgup3GafA1Qyl+wA/f02Tnd/AVVXGj3iP081OfelwQ68c7sI5dow7H7QJjAvdco+h4OLJ66oueXrcmO1eFJsAftwbiG6U+SpfAUqPMzvyjWjH+Ul21tz4YYcn3vs1//Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DBWNQZSR; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DBWNQZSR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785331111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qxoy1Kzk49UcTJHO4dzJoh7+3ty/viZDiAEnpAXvxVg=;
	b=DBWNQZSR/0urrdJLgeuF1T+bmzDeb6aq6VTbFsVvPB7oWA2XMXqhJkdcJTUI8pn7jdAAaY
	2AJEdYoVvob1RcOm1s2VE3WptlJE5sIXlSOXrDw5oalvD6z3Lt/MvSFQrrwwFcn7gM7lfv
	wxnFMSdzz5lNMA1OjMXUuHxuf3ZZwVg=
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
Subject: [PATCH v7 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
Date: Wed, 29 Jul 2026 14:18:17 +0100
Message-Id: <20260729131823.2021516-3-fuad.tabba@linux.dev>
In-Reply-To: <20260729131823.2021516-1-fuad.tabba@linux.dev>
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The vcpu_{read,write}_sys_reg() accessors abstract where a system
register lives, but their VHE implementation cannot be linked into the
nVHE hypervisor, so exception.c open-codes has_vhe() wrappers instead.

Redirect the accessors to the raw context accessors for nVHE hyp builds,
where registers are always in memory, and drop the local wrappers. This
lets hyp code reuse helpers built on the canonical accessors.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h |  6 +++++
 arch/arm64/kvm/hyp/exception.c       | 34 ++++++++--------------------
 2 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c7..fb4062b3ce55a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -506,6 +506,12 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
+/* In nVHE hyp code, registers are always in memory: use the raw accessors. */
+#if defined(__KVM_NVHE_HYPERVISOR__)
+#define vcpu_read_sys_reg(v, r)		__vcpu_sys_reg(v, r)
+#define vcpu_write_sys_reg(v, x, r)	__vcpu_assign_sys_reg(v, r, x)
+#endif
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
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
-- 
2.39.5

