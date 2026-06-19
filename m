Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EF0346AC5
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852846; cv=none; b=cuqTSIv9qyL1005h7jLLME3EIfwi8Tkq7iGWX8KjgD4MCP6kQa0pixlqOEq2UkGqNwhVCpvShZOc5aObGnOPqGpBsKtNeL18suU1vQokQ+P8rCQwtJ4AIogSmEfipzEujNaga1yaqt2CqJnjlBO+9Z7d8+hwNN08eiRxJJHJb44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852846; c=relaxed/simple;
	bh=oporByX9JvndB121j052L9KOtoOezl6MOjGOTBaP8ik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t82Ih387g+ZaKizStZ5V+NQMQEuaqo084KIZIcFm1acyVcbr9CJpWenJdi3ineLv/xaYH6mv4Qegxh2Zr9PM+Z7kQEbBnCvha+aFdL9Zr9sUrz8r5P/8oRNw7HnB+v35T92RBBU9BQVdXt3ke09kwODWszpBg1/m/OsTZ4parkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cq0xlGFC; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cq0xlGFC"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-46010392f89so1552154f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852843; x=1782457643; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lWlZcW5gocf23/J+R+I6tOG13UyKgx7kXKNby8lhWlE=;
        b=Cq0xlGFCxT61Sydbd+LPAeSBC8gFsyyyY4GXdm/MNula4LF2j+wf3gD9XHDP8yrTbR
         pp/VbtwFoJQiagrVWThLGm294DHDCBF6GMUj60PH8hsRhKcIlw4AA92NxGjvn6IGgkd3
         5y0Eo4AacUiktLOPaEg1oLy+OzAAmcXsiim+b8F+Q7zinD0KmwQn3wSPNZCNAm3KWB5g
         EDpOYRcsE48ZeBwtCa/+kPj1QgqkXMHSUu/EA5BVknvzgSNWhPZZVoJJHv6H527ETJ+U
         oe8iemwMudPYj4YruZNvTLghLTPDDqPLWSOcQL/M45BXM+IVUp2myRmWqkHnWoo83ttD
         Hc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852843; x=1782457643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lWlZcW5gocf23/J+R+I6tOG13UyKgx7kXKNby8lhWlE=;
        b=lmldo18WbPhs9zta54ns1uvERiiEzQsyKX4DFyiK8svMxAwfN/kz7zDVEz03KDFthu
         /Gjc450D/+ab7ob97iauCqRom9YUzgeTLdL6wRNGWNfJxLTQTZWwUAYwWZg46i4Mrbnk
         9qKBwkM36Wy6r6CenJxia8TuqN8KDcBGRhsUG8SWe4b+UUZBHZ8BZm2iVnST0YdpZXQC
         JlAmNycUWeF/7WQyD3qxtf/z9je+mjnk6sMI4YRUfe1zjd/J7aIh97uTMVgigd9VEizd
         sCQPeOpRl4apO3G+0BM7zJ1TOarLXVyr6F5jCzZfYwQdBJhjX1YTcBCOzy7Sk2aNKnwe
         o1gQ==
X-Forwarded-Encrypted: i=1; AFNElJ/tXP/5if27TiUGt6ies+bAhKqouYHd5n6ixEUMjL+/vVGz5CyoO5rERoII6XWpaWYdye7mGR8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyO7oJ1Hqna3kRXlqHYShz7L5E82lECcChuXcGaRXMKjb5xaDpq
	aKrGwpeJUuuhfpNEeMIHih6sByP5glN9wq23mxwSwdZ6c81Jha8+g9CG+tK9gZLcJ7EpAYzNRS+
	9Pw==
X-Received: from wrcl8.prod.google.com ([2002:a5d:5268:0:b0:460:18c0:dfeb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:38d:b0:43b:5b25:67f8
 with SMTP id ffacd0b85a97d-4656dff1fa8mr1790919f8f.20.1781852842970; Fri, 19
 Jun 2026 00:07:22 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:07:13 +0100
In-Reply-To: <20260619070719.812227-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070719.812227-3-tabba@google.com>
Subject: [PATCH v2 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg available
 to HYP code
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
shared with hyp code. exception.c already wraps them in
__vcpu_{read,write}_sys_reg(), which pick the host- or hyp-side accessor
via has_vhe() and so are valid in any context.

Move those wrappers to kvm_emulate.h as kvm_vcpu_{read,write}_sys_reg()
and switch the callers over, so a follow-up series can share that
emulation code at EL2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++++++---
 arch/arm64/kvm/hyp/exception.c       | 34 ++++++++--------------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c..80b30fead3d1 100644
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
index bef40ddb16db..2cb68dc7d441 100644
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
2.55.0.rc0.738.g0c8ab3ebcc-goog

