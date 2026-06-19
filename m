Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A56D31354F
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852715; cv=none; b=lf4JbpjMnj6KXBkY3vC6553CS4inxTn/CFRBfUQwlkfKPFiiJiPKPQYo2AnwoWAQWe6yjKUyBgcMqsOm/6i72paxiF8j1OpwBSBqIBl/HdxkbolFVNErX0SaTmzB2aZIGnEBTzAQ7EgWWuDVbReKFMR24TZ0uicXfYFP9Td47es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852715; c=relaxed/simple;
	bh=oporByX9JvndB121j052L9KOtoOezl6MOjGOTBaP8ik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=luokYBGBMvDI3IbCzYHrkGNSUBYRAC8gwCuBZPbnoOmx288/gNFiF2XlV4eeEepArxwf1SeS3KHv89TZN5dfXLPpKcwnOjc6gqXFUlvyFOIPIC+taRFChyYLrz6EJv+JYPWG9p2RW30u8jb8BamrSfPUpD1uw5dM2U0o0PYt1zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sH4E7Skm; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sH4E7Skm"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45ef616db45so1646437f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852712; x=1782457512; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lWlZcW5gocf23/J+R+I6tOG13UyKgx7kXKNby8lhWlE=;
        b=sH4E7SkmSjVlYunQysQ4r04erzeCgLmu70Q+7/P+edZHT6Y/iqIlcWG4rz0zKPoz1d
         AXfklWSzt68R11VPdU38WyPIls/snl6PY1NlaJ1SM9n+HM+S8MN5OWf6Jc0wwn958rs5
         AunTefzzDdfRKczgpsyWSr+uyOV+0O+KdeNvf4Dc+Y8R2dyunCvSmFGKBJD2zVDmRJq7
         BvvDs3q85txerh1XEikhB9R1Yp3cFGG0ZdTYhUWMOgwFG4rs/Uv1hR5usUMCHHZesBHy
         1ugZy7l/yVyglTDzYB28hP+UwRphdTxEFQKWVaySRf8RDa9bIN8pyZU7ogOWWA0aIBcz
         dZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852712; x=1782457512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lWlZcW5gocf23/J+R+I6tOG13UyKgx7kXKNby8lhWlE=;
        b=lX5lo+9LAiTabuKyNEgdl0N+6ZMGCak6Ra9qaq4xFC4w7EpgBQ+oFiUGMH02fJY7E9
         Vl1/S8ds98plqxX1vMH0f34T06Gd4Ssv9Yzb+G78IUX9Rewt7Phi7MkacvAI/4mP03an
         MsLYzKost3EHmnKseIogmtweslH99P8tVE6K+OHdX+c3/opbVue7d/PvPaAEGxLAJnXz
         2vq1U3RXTCCY7wfyQdzgLGeEU2CdL4Mn8A8SW5oFjyK+qysL0i1PoOLSE+PS60W+Bkb2
         dqe2LE/gFwcSLEH/HQy8I5L9CD+KD/N8eOytHhscUK4bF4RtISc8xQVokYI91BoITKkF
         NNZg==
X-Forwarded-Encrypted: i=1; AFNElJ8ARgZVTKPi5fhr32pxphqbLAgIdoZobg5QGyLyNiVlWrd/X1zLGhZAXII4ZUwqdWxX3lIILjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfHYLs1MpGclVi1nRxX9l3WfIsgmi8G5qV38YggwCbsHSwDHfz
	npwlUcXjce9jYZ+v+ndOnk2Ax0H0ZWleNDO3DqRvdNIel3aiojSlTDCB0mdUQxrW0z0ThhuuyVU
	Grw==
X-Received: from wmpd18.prod.google.com ([2002:a05:600c:4c12:b0:48e:6f63:7624])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a7b:c384:0:b0:490:b642:ce31
 with SMTP id 5b1f17b1804b1-4923ef53bcemr32354745e9.2.1781852712103; Fri, 19
 Jun 2026 00:05:12 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:05:02 +0100
In-Reply-To: <20260619070508.802802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070508.802802-3-tabba@google.com>
Subject: [PATCH 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg available to
 HYP code
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

