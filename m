Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76F516F901
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901164; cv=none; b=tZRKKDlbeIbu6CXAwtVX9uzyx0SvC3Uw9Sfy3mj1POAMwDSw8I8X2KPH7lv42GlKkN/M53abyJm49SfZTU/WyvRNVYtfbeK9kULfDR7Ix3rt1Wm/x30+R56eImGl2idl+8GvbJgoZppvgrao9tiamd/1si7ZSWo7waa/7qIEKD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901164; c=relaxed/simple;
	bh=TbjMBbz8en3y5fx0qhntxZIyCtn0N2qxe2vT3tQtVeo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QJWdTy0oEEJfagohkt1zRYKDnnMvYUvIlp7lm1Bx3VE1hRXqxhZNf8L32uRDJPXVJieT65hpr6s4MzB39+9NdyBqQlGkNp1+fqB0TnYSW79YdbhFdqqAdD5gvDY7OUxQESL85FbI8Cf0pa4AzzhFc2WVZ2EUgrCPupS20/w6j+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sFPspr4l; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sFPspr4l"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df4dc93d0d3so1303508276.2
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901162; x=1717505962; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DpUaRlWGgdD5U77Lipr8bfVqZDCHq0MnG7BJaO/Is2k=;
        b=sFPspr4lOnHnBX3dWxXyjsqUpPFkULsaBcIvB3/Lij0TT3x26iIbEO0y24WnlLeIMI
         y6QJE6ZQMH+AZrjolExTjDoiRcjr442aMQen+lvSpLR/fP5pGlbJjjemi3UcOAkwLE+O
         sE45TklJWTLR6HppO1BXq9ydWWeV/nyIA7q2c+PfGq+bGIQRWqHT8j5FbwLTzszNui9f
         m6LKNVI766PD4WUgUw6sFUq0NKz2LPQJKKC848fHYb36D35ddXEiJ4MoHd2qAcqxvUCc
         DFMeWn59s2WeIHZKyxEluH/e2C14IdPTuPyUYHP6AKGtmJAJ1mn1Vx8h/waUffFplTOj
         KeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901162; x=1717505962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DpUaRlWGgdD5U77Lipr8bfVqZDCHq0MnG7BJaO/Is2k=;
        b=DDDQonDQvqJmg9K5FHhhHE9k/Il1udRvmr0g3V9Wq32z/ZrKqsjPnOMELlTTHLbT3G
         4UDZpsNT7CzAX3L7BxARNEvYQfR0i9KhoZ/lysWBT6zrGZFm6Fexp2hJ50jXQcInxd8D
         4DU2SxYC/K9wU2hKpLjzus+z482MHCNU7yrYBGDgJckXCYInKtnYoW/OJJI+KBQUmQJ1
         hqOOec7W/6H0LjLaRdCQQFLw+0OkQ/YbxybbZ9PuRzG1ehFBjSLX4GB2qMS+NzpB0rCA
         rz93DuChUx1G9ZyF/MYEESn1cW6bcwiH2GvmtZUp24cFah+PlUokPSQ1uw5euw7vXjrF
         uIYg==
X-Gm-Message-State: AOJu0YyFokVATIUrpz8+ZCJfa4yXnX4/+dtzdCtgjvi44BF1Od+tREvI
	1UY9d8B5Ff77Tx/j31809SAgn9mdJ3PYRtdnTOKFdRCo6YQf1giKrDBTGhdMOI6HAb84mxweIDM
	mqVjXserabtWLmmJPuErXbaLINQoIVT6EEKQkH7Cv8aG4kg5l7qkchYo0Wxc1xLLkRfn2gikyQS
	8FojZ024yMYAgHIpWlrd22h/T3jZE=
X-Google-Smtp-Source: AGHT+IFB6d2vtmbxhDXoSSIA1DwhFhFMgph7+N9zqLFpAVFu28sBuIph3cwkSHCk5aHSPIK6FrlH+Blhqg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1003:b0:dd9:1db5:8348 with SMTP id
 3f1490d57ef6-df77221d8b1mr3071482276.8.1716901161626; Tue, 28 May 2024
 05:59:21 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:05 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-3-tabba@google.com>
Subject: [PATCH v3 02/11] KVM: arm64: Abstract set/clear of CPTR_EL2 bits
 behind helper
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
index a92566f36022..2cfbfedadea6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -330,7 +330,6 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	bool sve_guest;
 	u8 esr_ec;
-	u64 reg;
 
 	if (!system_supports_fpsimd())
 		return false;
@@ -353,19 +352,10 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
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
+		cpacr_clear_set(0, CPACR_ELx_FPEN|CPACR_ELx_ZEN);
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

