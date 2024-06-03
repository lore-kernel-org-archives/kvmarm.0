Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8BE77118
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417756; cv=none; b=lFJYDq4Voorx2zHs9ul2cU0kXjA/5hhZ7Fkeb8+Dd62Ws+ycBt8yKkMQ045/3FhIziHQPRqMRSJDLXvs5sppY2zD18l2dchoTx6TCdoSz4gME8o8i4cRBMPifGwmwvHTkc5OpJnXsn03HGOZ6oV45/pq0BfgejNmplcNOnoLVIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417756; c=relaxed/simple;
	bh=1knDe/yc8ItOiUSldHnx+AYhW4LnmqeoorRUBNdqDKU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fb55z7NeYnQTwcO4zFBK/9dfgnUckHPftkoY/NVXhf7OfFZYMcllaQwteY1h1b5VfC/6myBgJ4P7F94FepQyRsZgagjqXwN8UNucpHe7sXnOskYUylaaZwXQob6XhPOLI2WKX3ivCM63Tvrcey0JisSbH+G/i0Sqhiior2NHSt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t+1608AZ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t+1608AZ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-35dcb3f1ab3so2279149f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417753; x=1718022553; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WtWJBKyFvGQD5szW6F8dKzbbhPp6g7pDAESGBVUK8Gs=;
        b=t+1608AZOIaHbLCS4eSgR98tgghXKYYdaVPW3sXCjg0GMQStvFaBnzrdXY7udxlZ2q
         pnMkvNO2h+f5EbMuYX1Km5Q6aiEzPE+Q+t7019nbTVqLZDMbRaepr0/6D3JxP7gS4LbI
         G6dAzE5gbjHBy9dX9UZbev1GSM8FCCbWrI+9jnzc/YjBLsrXe/jLlybm4YVkfvD7hKC4
         UuEEsGaU2I9xdIJFmUcs0zvuCV2GdNaYFu0kUOHY/DbBdsoAgguIntqeQZ6lIVq3FE0D
         9zAp8GGflTaLlsJ73z2shxORFyF7GXvRnGEanttLwckBfu5DgbKxL/JKAWdPM8hq/5SG
         We4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417753; x=1718022553;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WtWJBKyFvGQD5szW6F8dKzbbhPp6g7pDAESGBVUK8Gs=;
        b=gHOGVdnhAeeyrLi7a2Sp/TQ49ogk/KgiczcLOjypVFpb7vYmvqHdk/wzc9hi5G5i4Y
         ouvQgmzrE2wsuDMtcxoglf2k19uf7sanun047XwQBQpI8AK9MjCMVq6lEaLP5jJ37tcH
         mL36yrrlaWtXNitByCLyZ/0w+IAy6NuLdMu+5haO8lEAsdQB6XR0KQt7YU8raHNq6ib5
         milNm6G/vIp82sXfEzZa+aW8Z5Vf7WiDp1/nWekpJZyKtAi9+RPzEQ0wn7vdXtl31rGg
         Co0c6JfmDfVA5i01OxEZh8NskCRKkUPo93JjzfcpBKjxdfD+4LxZ05CsL7LQ6K2uTeYO
         IPYg==
X-Gm-Message-State: AOJu0Yy7FT3PwpMzSXHVFWay/zRGvgxcoSGkS0W5o1JlXel+lGGI4dA6
	F6KAqjVwsjFf7Dj5zoSBRx9VXO3L1N9gT687gqbbqqOI1e8B5YIWciPK0w8GHAQPJqyjDnAaJKF
	TmVbth4IvQTe8Uzpz1E+GRnn1Kul21XKBqHP5cxuR4syJnLr3u9/I6GAgXdj5bmqJHUPuWJ8S9r
	AOhh9407EDVsog6jtmWVgGBnPm/Kk=
X-Google-Smtp-Source: AGHT+IHfcB5a1lbKfVtUCtqK3R/QQErL+IjhZ9ZMu+RhPRnWwnQ6oByi4b3Q8VEPpjcFOM1UW9AMlgjWpQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6690:0:b0:354:f145:32a with SMTP id
 ffacd0b85a97d-35e0f26a36amr17870f8f.6.1717417752516; Mon, 03 Jun 2024
 05:29:12 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:50 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-9-tabba@google.com>
Subject: [PATCH v4 8/9] KVM: arm64: Refactor CPACR trap bit setting/clearing
 to use ELx format
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

When setting/clearing CPACR bits for EL0 and EL1, use the ELx
format of the bits, which covers both. This makes the code
clearer, and reduces the chances of accidentally missing a bit.

No functional change intended.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/el2_setup.h   | 6 +++---
 arch/arm64/include/asm/kvm_emulate.h | 9 ++++-----
 arch/arm64/kvm/fpsimd.c              | 4 +---
 arch/arm64/kvm/hyp/nvhe/pkvm.c       | 2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c     | 5 ++---
 arch/arm64/kvm/hyp/vhe/switch.c      | 7 +++----
 6 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index e4546b29dd0c..fd87c4b8f984 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -146,7 +146,7 @@
 /* Coprocessor traps */
 .macro __init_el2_cptr
 	__check_hvhe .LnVHE_\@, x1
-	mov	x0, #(CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN)
+	mov	x0, #CPACR_ELx_FPEN
 	msr	cpacr_el1, x0
 	b	.Lskip_set_cptr_\@
 .LnVHE_\@:
@@ -277,7 +277,7 @@
 
 	// (h)VHE case
 	mrs	x0, cpacr_el1			// Disable SVE traps
-	orr	x0, x0, #(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
+	orr	x0, x0, #CPACR_ELx_ZEN
 	msr	cpacr_el1, x0
 	b	.Lskip_set_cptr_\@
 
@@ -298,7 +298,7 @@
 
 	// (h)VHE case
 	mrs	x0, cpacr_el1			// Disable SME traps
-	orr	x0, x0, #(CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN)
+	orr	x0, x0, #CPACR_ELx_SMEN
 	msr	cpacr_el1, x0
 	b	.Lskip_set_cptr_sme_\@
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 2d7a0bdf9d03..21650e7924d4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -632,17 +632,16 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 	u64 val;
 
 	if (has_vhe()) {
-		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
-		       CPACR_EL1_ZEN_EL1EN);
+		val = (CPACR_ELx_FPEN | CPACR_EL1_ZEN_EL1EN);
 		if (cpus_have_final_cap(ARM64_SME))
 			val |= CPACR_EL1_SMEN_EL1EN;
 	} else if (has_hvhe()) {
-		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
+		val = CPACR_ELx_FPEN;
 
 		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
-			val |= CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN;
+			val |= CPACR_ELx_ZEN;
 		if (cpus_have_final_cap(ARM64_SME))
-			val |= CPACR_EL1_SMEN_EL1EN | CPACR_EL1_SMEN_EL0EN;
+			val |= CPACR_ELx_SMEN;
 	} else {
 		val = CPTR_NVHE_EL2_RES1;
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 1807d3a79a8a..eb21f29d91fc 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -161,9 +161,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	if (has_vhe() && system_supports_sme()) {
 		/* Also restore EL0 state seen on entry */
 		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
-			sysreg_clear_set(CPACR_EL1, 0,
-					 CPACR_EL1_SMEN_EL0EN |
-					 CPACR_EL1_SMEN_EL1EN);
+			sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_SMEN);
 		else
 			sysreg_clear_set(CPACR_EL1,
 					 CPACR_EL1_SMEN_EL0EN,
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ea67fcbf8376..95cf18574251 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -65,7 +65,7 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	/* Trap SVE */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids)) {
 		if (has_hvhe())
-			cptr_clear |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
+			cptr_clear |= CPACR_ELx_ZEN;
 		else
 			cptr_set |= CPTR_EL2_TZ;
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index bef74de7065b..6af179c6356d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -48,15 +48,14 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	val |= has_hvhe() ? CPACR_EL1_TTA : CPTR_EL2_TTA;
 	if (cpus_have_final_cap(ARM64_SME)) {
 		if (has_hvhe())
-			val &= ~(CPACR_EL1_SMEN_EL1EN | CPACR_EL1_SMEN_EL0EN);
+			val &= ~CPACR_ELx_SMEN;
 		else
 			val |= CPTR_EL2_TSM;
 	}
 
 	if (!guest_owns_fp_regs()) {
 		if (has_hvhe())
-			val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
-				 CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN);
+			val &= ~(CPACR_ELx_FPEN | CPACR_ELx_ZEN);
 		else
 			val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 20073579e9f5..8fbb6a2e0559 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -93,8 +93,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_ELx_TTA;
-	val &= ~(CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN |
-		 CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN);
+	val &= ~(CPACR_ELx_ZEN | CPACR_ELx_SMEN);
 
 	/*
 	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
@@ -109,9 +108,9 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu))
-			val |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
+			val |= CPACR_ELx_ZEN;
 	} else {
-		val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
+		val &= ~CPACR_ELx_FPEN;
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-- 
2.45.1.288.g0e0cd299f1-goog

