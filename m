Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAE52E3EE
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294037; cv=none; b=cG2FOodq5xcY/ZuDJWZ736eUwRQQTwtEXXmnesre40VefJEMA5ZicB1iqhkzPSpNwD7hnmoe8/JTpVXIzsHQZea8MP1srHyfwQbneRlilb14vZL7wMQHHak6hGbD/sXi4X4K2X4qpveOPub2dKD0rNN9cR0nMXurvO0f+0S1e/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294037; c=relaxed/simple;
	bh=u/avhju8ZiLbU2V29l1YNg6nH1/y9XIL6wCj4z25zsk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XhW3WqJhHjnyCghU6j2W2JJK4N+qhmEhdSux8asfbsTU75TM0f+brt2xwh0cSKaPJYIz5Pm4muFkJtoSnKEwHTyoNXLd9CRXxL3+OH10F3RKljkufMBgBYy822vWd6DTuUghJjhN3YhgA7D9HngY6MPJavApiviWOSUINeBaZsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eLSZdQvH; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eLSZdQvH"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-382411ea5eeso1364493f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 08:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732294032; x=1732898832; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fJeINAZHCBu2Qf4xyRN0jajeOXOn86gSYL/Mvl+4mzU=;
        b=eLSZdQvHrWjexU5SMooplw+e653jsIaTUgvJo5rwSjEXZdmLKzFRjU7jgpyq9L8Gl0
         eSr2H3G6QpoFzOyq1MPP2TXcGkhqLH57VlE6ba7kBFKSwWwOe+ExaKjEOVG2Vzzg3+5G
         AKbwAIzNeo8VAhg7cIgf0UZgBZ+07A1LsLnDqrQkwCh+veU26VZ4GZ95xqLV8XfGFA3a
         PyY0l/gqg2dRXr7JuFZzkqYDd6CHZoHAorXbaietVwZRrVaec6bKId/YtStEKxqQVQBc
         hdMGDxG54oh/EcJApwuh84EGyp7/IPJdEbYEXV7F0atMZDXCG1+mRPOlUAHr10tMMVOd
         egrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732294032; x=1732898832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fJeINAZHCBu2Qf4xyRN0jajeOXOn86gSYL/Mvl+4mzU=;
        b=UZiakd3bfHKL70Kium2PrXwzr4O9HxdTFg2FvAXaoV26Xhblmzx/qN3x4Wa1WfY+Aq
         y2AcqptdoxKF7NRKi7IriZOiL5RV823DuZQIycaihAeNg72OpdBxkxt/KvDkbLPmIHKW
         u2V5VgLxzVefmMzRQJ7D+CHfGm/Ha1s6LQ6TNfGTM9N+AGSJAwZR+oeAIjB7myww6Wpj
         9TmZWVufmvmj1NL8cGfHANgOXSj9Vg78oWaoitCGgWpjqacva5iKUDAPBJMXITF7Q5bV
         SeZvXmrd5Jd0xDKC0QKmxVlYtRR75yauGbMHSxTh+bSuq1vp7jDaDS7dwHwboAyp9mO7
         GLmg==
X-Forwarded-Encrypted: i=1; AJvYcCUof2fWyQUVUZ7k0VItDE3rrOpTZA7auz3w7uAA3MSXk1LFL0Yiof8NH8TMbM/ZnLZvs17oM4c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzDgJzxO3D8jaxTx9U3vwdu/pIJBl0GH2v3YzpcgM6HpYkH0Bb
	qxoRPIQ+ZZSAnT8U6gClvOtdZF7Ya5dJLFrquo3UWHKtyrCLP9u7yVZOJXUBuX8=
X-Gm-Gg: ASbGncs+8YA+kBlt57k4bFJLLSTNta1YfmqPwfq3TXZ+QmEq0UaGh4AF6keA+qKiFIP
	P34EdD0YHD4CZ/HxAHD1KdpYokcFSOESidw69OKd1POYRgH8JUahqmHYyvfGUy9uj5WV4QR4m1w
	bLLVdhJXVPPrpr2CpOw8Jloy1sSgR7Ug3MyLM5ix2aX4HW0hCf1Wr1ZYzW2JBD0hw+yhBTA3jJK
	Mv0w7Km5zozVVUVBJUyKppxknXUo+FgDHo72QNsEhKlM1FCzn4=
X-Google-Smtp-Source: AGHT+IHcQ74w3L8E5gBsmMqb9rkz/2NNvWSY9aaHifqJFdgHc67xg00mFf+1ZhdtlpPb45JX0tyD6g==
X-Received: by 2002:a05:6000:1acc:b0:382:42d7:eec4 with SMTP id ffacd0b85a97d-382601132ccmr2984325f8f.4.1732294032116;
        Fri, 22 Nov 2024 08:47:12 -0800 (PST)
Received: from pop-os.. ([209.198.129.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbe91a6sm2897458f8f.86.2024.11.22.08.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:47:11 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: will@kernel.org,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Clark <james.clark@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: Fix usage of new shifted MDCR_EL2 values
Date: Fri, 22 Nov 2024 16:46:35 +0000
Message-Id: <20241122164636.2944180-1-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the linked fixes commit, these masks are already shifted so remove
the shifts. One issue that this fixes is SPE and TRBE not being
available anymore:

 arm_spe_pmu arm,spe-v1: profiling buffer owned by higher exception level

Fixes: 641630313e9c ("arm64: sysreg: Migrate MDCR_EL2 definition to table")
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/el2_setup.h | 4 ++--
 arch/arm64/kernel/hyp-stub.S       | 4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 4cd41464be3f..f134907d3c08 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -79,7 +79,7 @@
 		      1 << PMSCR_EL2_PA_SHIFT)
 	msr_s	SYS_PMSCR_EL2, x0		// addresses and physical counter
 .Lskip_spe_el2_\@:
-	mov	x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
+	mov	x0, #MDCR_EL2_E2PB_MASK
 	orr	x2, x2, x0			// If we don't have VHE, then
 						// use EL1&0 translation.
 
@@ -92,7 +92,7 @@
 	and	x0, x0, TRBIDR_EL1_P
 	cbnz	x0, .Lskip_trace_\@		// If TRBE is available at EL2
 
-	mov	x0, #(MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT)
+	mov	x0, #MDCR_EL2_E2TB_MASK
 	orr	x2, x2, x0			// allow the EL1&0 translation
 						// to own it.
 
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 65f76064c86b..ae990da1eae5 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -114,8 +114,8 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 
 	// Use EL2 translations for SPE & TRBE and disable access from EL1
 	mrs	x0, mdcr_el2
-	bic	x0, x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
-	bic	x0, x0, #(MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT)
+	bic	x0, x0, #MDCR_EL2_E2PB_MASK
+	bic	x0, x0, #MDCR_EL2_E2TB_MASK
 	msr	mdcr_el2, x0
 
 	// Transfer the MM state from EL1 to EL2
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 01616c39a810..071993c16de8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -126,7 +126,7 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 	/* Trap SPE */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer), feature_ids)) {
 		mdcr_set |= MDCR_EL2_TPMS;
-		mdcr_clear |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
+		mdcr_clear |= MDCR_EL2_E2PB_MASK;
 	}
 
 	/* Trap Trace Filter */
@@ -143,7 +143,7 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 
 	/* Trap External Trace */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), feature_ids))
-		mdcr_clear |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
+		mdcr_clear |= MDCR_EL2_E2TB_MASK;
 
 	vcpu->arch.mdcr_el2 |= mdcr_set;
 	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
-- 
2.34.1

