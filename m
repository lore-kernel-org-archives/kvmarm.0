Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD5416E88D
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901176; cv=none; b=iXlLZHpRAstm1kYJnJgyvLfxVlAxFUbGB9b8sCQ2jQLt9gh8UsBfOMZxJlVjr6AUeGK4Adm6ZVQT5q7Z770x12EYw5/Nx/6iidZxYBRuxNhIBurCy5/45YOFIL4qeofRYPaHeYfkd9694NQx222nnSGAzONFwwWkv6iPmNgvYSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901176; c=relaxed/simple;
	bh=UywgqDYsXfAVpi/3NV1GjrHU5hmZhVv6NrIG1HIpZHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qOcOJ0RGm1hongXzRdyAzvK5Z4kMz3oDF56XjiBYHZ1rvrCwoIXloJE81rtCLi243r4Ynxglbu8VGHzhGoum4pUvPCHGesGSHhp7cJ32WMxzxtGkyN0dRs3qlh6Lndoskj2e0U0E+BbfTpQdm+oCoNk7Hpj6vHMujrwKDEOqXG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qEK+jhfA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qEK+jhfA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-421205e8d7dso2669325e9.3
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901173; x=1717505973; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW+uL0GDOoKvbN/ulK5nWifOts2Vz2PY7ALPBsE8pvY=;
        b=qEK+jhfAXSa9aK25zEHnjtWj9WKfsqKXiFAc+PCb2kvM8X17ZpxXMfcQRl0QLmXjk5
         BZqvc/6O5WF8PxIX1MkG8hOIw/8BJHoLKtgwU56Ry1C5ioM5rZaWBfQLYun9FWT87EP6
         FclyFnkbHFXJVcfZSpDnrqVFZpT3nK2Q+OV5FlUh4RjC6FnFhvnWNr86LKcVuW8C+Czl
         a7x+6fpuRPYNvdnrPUfm20DfqE6O6o03xZoNGK+QbqOMBUuNVZu1+QLBLow7vtCE87sz
         J3yIbuTepc8gxf7s/PdO1JlHfnuCFeFRg1H4CZ+vIg9vMs8RtOAB1L8ZL7vmpfoR63Dr
         ySQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901173; x=1717505973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW+uL0GDOoKvbN/ulK5nWifOts2Vz2PY7ALPBsE8pvY=;
        b=Zih3oYJtD09fXxH8uKc0YaMSfO74+pEghHq7MmwhBZhWMNa2owMOJoBZSJYJPcMF6p
         959aBCpMWuOCKZNRW6CuULoyYdqBjTXascK7IZPKsMUE1tiUIxBZTV7sjsNrrIY8Sy2b
         PBhY9FjDkMXGlD5I+1ccIQULP8k1LtsALxa/jwb3TuqU84rydaGbL74oOWtrZuNaY3jG
         zHfu2bFzt2EbfcKEgIQNnUWwX+SMXgouGKkOjBQ3voF3U291ug33BN3araonZIl06hH5
         Um75ukmZEAVDF5lkxEPI9g/L5IllTsJXnl72heS58Tw4YF4J/+i85j+Qs0UTv7LKBp5o
         BonA==
X-Gm-Message-State: AOJu0YzDn+VUip34f/Qy28R3jPx9nDRuaS1LiWFIeCL9ytdtTgKsQwdR
	6cRRT1XyHXMc3WCnF8j69dyOwKtNkhOKWC8A/HDXbfPrW4cQWJvDGxwpGAXmo+jTrhzhqc8qFJ6
	0ML20BdlE1TSm0XWgA0ks5jYffULIrDcXAWrSI6RE/xG6Jsza5PMIb6uaeOt+qU7Wi1VEcqmVu9
	ASuaraQSVE4VXQ2ZM4yXst4hD4ZaY=
X-Google-Smtp-Source: AGHT+IFtVyRw0wz+0HcoltuIgTx6jYLuLhohPJxddL3romGCgF3z0WaYdMBwd+3TLUnlFNbIFEImMIVAkQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4fc7:b0:41f:d90f:913 with SMTP id
 5b1f17b1804b1-42108a18e78mr493065e9.3.1716901172941; Tue, 28 May 2024
 05:59:32 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:10 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-8-tabba@google.com>
Subject: [PATCH v3 07/11] KVM: arm64: Refactor CPACR trap bit setting/clearing
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
clearer, and reduces the changes of accidentally missing a bit.

No functional change intended.

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
index bef74de7065b..b264a1e3bb6e 100644
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
+			val &= ~(CPACR_ELx_FPEN|CPACR_ELx_ZEN);
 		else
 			val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 20073579e9f5..1723090f3c4f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -93,8 +93,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_ELx_TTA;
-	val &= ~(CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN |
-		 CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN);
+	val &= ~(CPACR_ELx_ZEN|CPACR_ELx_SMEN);
 
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

