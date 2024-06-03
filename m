Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689B112BEBE
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417745; cv=none; b=pDbtmiguNmFCZnfHgTpmafz0bT7PNMg3Na/tWqZHUSGBxppb6EVW5dgVJ4+JNyeoeQbKH1ASN1z9M2zMTzn8KB3emJqtrRr30tUvu9Nr41E7Qr3QvkmIAUSS7NCUldCo9cE/uRK/f9ceBTne0Sqg42xuVQ6zOJuUCUybRixcVec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417745; c=relaxed/simple;
	bh=jOgggU0psL0RxWwbfhgL9muO3jiSPSY+/2AdeeoxxIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I8adrISRqAqbdTA6cGtggX8hs5XyW11WEwDFyu9MK6+Tv6NykOwPGBaLlxdI9Rhj09Tjp78P+zyiUREj7bdrm4yRnOk6AjkmBIy0KuCsw15blRlBiymNj9odG4haSMwKsnThhBSsKO39OEzfS5C+gHUXuWvbqkJdy2O8+K6IT8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CndXqA8Q; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CndXqA8Q"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-35e0f8bcc3cso1571481f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417742; x=1718022542; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iic9SadJLy1VA1CEhDIRT1Y/PJahOm/1dLNWZNTFh7s=;
        b=CndXqA8QvMFB6OsPAR7nFOGvYrR9mmV509HZ02xfOkOCJa1rpRMiJq4+BYyARJWUNE
         J5qkoNg7LSZIdCGGn74Wv1xy7FH6FtBWFXGligWfwYkvqHSqrxs8739j471PObXAdWeh
         hr2MLXxANjJbiTtJBDoZb2u5GapVlX4sJlfDhPsNosNT2u7/zQTZmDj5ClyS3/DiIyLr
         Z+Ti/xzzc2CNN1nyQWRfW7XMNIync91puPqxe6K/mWEUjKJ9I1ib4cp0jJk+QMKrHnT3
         7Tq8x/ekK63GsCWV11bchgSFXE6E0/K/BqANEkdQUoZ6TtT2ZgIdMlVshyM6M2mIMSER
         gv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417742; x=1718022542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iic9SadJLy1VA1CEhDIRT1Y/PJahOm/1dLNWZNTFh7s=;
        b=uVd0SKnFYu04hQujGnb0RZh6SsohRhtXmtM9P+9Crj8tdT7pV0jIi2d+f7t4/2rXea
         9Ihip/bnmflHr0hbvSGIWNpdJUG5lIZ6QTKwpivabHp1nNb/LYg+FhWXX8qkcBhezpwd
         5BeLbnvC8ZAN5TqcsgLilO2T5Z1hW262iRlqO3GshrBRyzMEh0Bw+E6hqprC/8CbqbE1
         Amsp0vRa35z+XCEwteawUVGNdWnc3QEItQw8GTXCoUgg2fnxpAeFlAPArLF0Ce0vDyiA
         6a/qKar/osGZCbDeOWHTVq8w6L+gchd1SxXuCMPBIEcxogFWZSC5P2ynIY/JsAu/XmwF
         Kdxg==
X-Gm-Message-State: AOJu0YzOPYKQIjPYpuVsR45UcGcLtQXzrTsk9+DkgwDXWvCG90VGx2fA
	Ghla3t1GU2fUx1INwbLgXWqOlo7dCLw3HFjwSFMO3K/RpRj1idnRQFNdhdNbkVnpnQbpIRGaYaR
	LMjE2bEZdN8NVltW37fErZAKBPeHJM5oRL1d6+I0LxIYSGBdoRUzGx70BtuvDOTBVqCx1o8JZ28
	cbsyIYqZxdicHHbSlli49jAbgyEPA=
X-Google-Smtp-Source: AGHT+IFS3J57WBH+i+TvNBNocCH4IlXysxMIphQg3aN14u+C/JFnqvUTYAZ4F31DO8h7LepQHQcwi26Kyg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:4011:b0:34d:9055:c5de with SMTP id
 ffacd0b85a97d-35e0f258a07mr21482f8f.1.1717417741135; Mon, 03 Jun 2024
 05:29:01 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:45 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-4-tabba@google.com>
Subject: [PATCH v4 3/9] KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

The same traps controlled by CPTR_EL2 or CPACR_EL1 need to be
toggled in different parts of the code, but the exact bits and
their polarity differ between these two formats and the mode
(vhe/nvhe/hvhe).

To reduce the amount of duplicated code and the chance of getting
the wrong bit/polarity or missing a field, abstract the set/clear
of CPTR_EL2 bits behind a helper.

Since (h)VHE is the way of the future, use the CPACR_EL1 format,
which is a subset of the VHE CPTR_EL2, as a reference.

No functional change intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h        |  6 +++
 arch/arm64/include/asm/kvm_emulate.h    | 62 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 18 ++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 +--
 4 files changed, 73 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e01bb5ca13b7..b2adc2c6c82a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -305,6 +305,12 @@
 				 GENMASK(19, 14) |	\
 				 BIT(11))
 
+#define CPTR_VHE_EL2_RES0	(GENMASK(63, 32) |	\
+				 GENMASK(27, 26) |	\
+				 GENMASK(23, 22) |	\
+				 GENMASK(19, 18) |	\
+				 GENMASK(15, 0))
+
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 501e3e019c93..2d7a0bdf9d03 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -557,6 +557,68 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 		vcpu_set_flag((v), e);					\
 	} while (0)
 
+#define __build_check_all_or_none(r, bits)				\
+	BUILD_BUG_ON(((r) & (bits)) && ((r) & (bits)) != (bits))
+
+#define __cpacr_to_cptr_clr(clr, set)					\
+	({								\
+		u64 cptr = 0;						\
+									\
+		if ((set) & CPACR_ELx_FPEN)				\
+			cptr |= CPTR_EL2_TFP;				\
+		if ((set) & CPACR_ELx_ZEN)				\
+			cptr |= CPTR_EL2_TZ;				\
+		if ((set) & CPACR_ELx_SMEN)				\
+			cptr |= CPTR_EL2_TSM;				\
+		if ((clr) & CPACR_ELx_TTA)				\
+			cptr |= CPTR_EL2_TTA;				\
+		if ((clr) & CPTR_EL2_TAM)				\
+			cptr |= CPTR_EL2_TAM;				\
+		if ((clr) & CPTR_EL2_TCPAC)				\
+			cptr |= CPTR_EL2_TCPAC;				\
+									\
+		cptr;							\
+	})
+
+#define __cpacr_to_cptr_set(clr, set)					\
+	({								\
+		u64 cptr = 0;						\
+									\
+		if ((clr) & CPACR_ELx_FPEN)				\
+			cptr |= CPTR_EL2_TFP;				\
+		if ((clr) & CPACR_ELx_ZEN)				\
+			cptr |= CPTR_EL2_TZ;				\
+		if ((clr) & CPACR_ELx_SMEN)				\
+			cptr |= CPTR_EL2_TSM;				\
+		if ((set) & CPACR_ELx_TTA)				\
+			cptr |= CPTR_EL2_TTA;				\
+		if ((set) & CPTR_EL2_TAM)				\
+			cptr |= CPTR_EL2_TAM;				\
+		if ((set) & CPTR_EL2_TCPAC)				\
+			cptr |= CPTR_EL2_TCPAC;				\
+									\
+		cptr;							\
+	})
+
+#define cpacr_clear_set(clr, set)					\
+	do {								\
+		BUILD_BUG_ON((set) & CPTR_VHE_EL2_RES0);		\
+		BUILD_BUG_ON((clr) & CPACR_ELx_E0POE);			\
+		__build_check_all_or_none((clr), CPACR_ELx_FPEN);	\
+		__build_check_all_or_none((set), CPACR_ELx_FPEN);	\
+		__build_check_all_or_none((clr), CPACR_ELx_ZEN);	\
+		__build_check_all_or_none((set), CPACR_ELx_ZEN);	\
+		__build_check_all_or_none((clr), CPACR_ELx_SMEN);	\
+		__build_check_all_or_none((set), CPACR_ELx_SMEN);	\
+									\
+		if (has_vhe() || has_hvhe())				\
+			sysreg_clear_set(cpacr_el1, clr, set);		\
+		else							\
+			sysreg_clear_set(cptr_el2,			\
+					 __cpacr_to_cptr_clr(clr, set),	\
+					 __cpacr_to_cptr_set(clr, set));\
+	} while (0)
+
 static __always_inline void kvm_write_cptr_el2(u64 val)
 {
 	if (has_vhe() || has_hvhe())
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d58933ae8fd5..055d2ca7264e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -331,7 +331,6 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	bool sve_guest;
 	u8 esr_ec;
-	u64 reg;
 
 	if (!system_supports_fpsimd())
 		return false;
@@ -354,19 +353,10 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	/* Valid trap.  Switch the context: */
 
 	/* First disable enough traps to allow us to update the registers */
-	if (has_vhe() || has_hvhe()) {
-		reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
-		if (sve_guest)
-			reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
-
-		sysreg_clear_set(cpacr_el1, 0, reg);
-	} else {
-		reg = CPTR_EL2_TFP;
-		if (sve_guest)
-			reg |= CPTR_EL2_TZ;
-
-		sysreg_clear_set(cptr_el2, reg, 0);
-	}
+	if (sve_guest)
+		cpacr_clear_set(0, CPACR_ELx_FPEN | CPACR_ELx_ZEN);
+	else
+		cpacr_clear_set(0, CPACR_ELx_FPEN);
 	isb();
 
 	/* Write out the host state if it's in the registers */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d5c48dc98f67..f71394d0e32a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -405,11 +405,7 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_smc(host_ctxt);
 		break;
 	case ESR_ELx_EC_SVE:
-		if (has_hvhe())
-			sysreg_clear_set(cpacr_el1, 0, (CPACR_EL1_ZEN_EL1EN |
-							CPACR_EL1_ZEN_EL0EN));
-		else
-			sysreg_clear_set(cptr_el2, CPTR_EL2_TZ, 0);
+		cpacr_clear_set(0, CPACR_ELx_ZEN);
 		isb();
 		sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
 		break;
-- 
2.45.1.288.g0e0cd299f1-goog

