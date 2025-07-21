Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B12D9EDE
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103121; cv=none; b=ssF/g+rJBLXBw+OkqQJ7Qlclf8ZGehtEXGUq6qKO2mKsoJXKDLdUAlBuvNaDMjKDFEemx/Om52ym0anid3r2mFe5dvrhwJtyKPk9PSE2EQflA+eE7UKlHYO+7Drl3nqPP5l38/p7YPmXaHmFH6/Od9/yOnoiChoMkPtUjlCXsu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103121; c=relaxed/simple;
	bh=YxvmYpOV+737fyfcSQi4SIm2ZMFnBONYtUfp6vtMhrI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G+Xid3+eeasgw9wsbBI8EB060nqgn+mKAneaf8D90uy6Hc0j7QiuGJDyNQ8Mww3ia3Sr444s7dpjp0JR2Y9ZNjhz3h10xCIltqt5uFErZJA6sgyxdngae13b5pGxdCqJKtQgOCuui/3H+k0/RvA12mzC6roKtYbheZiIyPVNIcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QW8vpQ1e; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QW8vpQ1e"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3ab112dea41so2519689f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103116; x=1753707916; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJFteMx4M8CuvuwGOOEAn5xVwGW4RJ+pfzFY5hwg8co=;
        b=QW8vpQ1eGNY7kTQOYYdSBCHrWoxg7ZaSngUS1h5WrIvI2+raM1akLjzbDdVeJqwOv1
         7u7KrSdeWr+X3t0oEE4rYmRp07LCq5tJjWg3pUxljuIjLpAhJFZxOmTQGmtJLQmcNuIr
         vUdbx1mXf8QBPlctFCstWKl8KIiQGa8vvTmGXBmalgfLf4/KVw7uo1osK/t42wCFPOYv
         xomhtkPccNg/Ip6sRm1ca/ErSNRgIt2rNxioaE+tj49LkJBMkDNJQszF2d9OmAgJ+zZp
         7a0wiXsW5Mig3i3sQ1L0jp+OrbppAvykU0jrIw6what/Cth4FpHHuOLZUt34hngXMqtW
         48Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103116; x=1753707916;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJFteMx4M8CuvuwGOOEAn5xVwGW4RJ+pfzFY5hwg8co=;
        b=QG+SX+2dVJLZgMjR7etD7KThPfTQR359M5vN0tU6PfpRQjbFdodVsvp5nVJZRJ4JH3
         l9bBsDk9EI5QKa2IfTChViSYmFYk2Ut2nlCZmNjpZEdKCDC0Wr2NGHxnSF2HbcWUBrYM
         CLCfUrwu5ayPZlgzVuIv6DR0C45TwnD0vVE962S6v4zYdHfNt/1KNdjGtBk2UfRrkHA3
         lykAA53zwOdYgSDb3Iu0hPvRLfBbgShWWyrEkCemblkg7VxTiyXAQBygAJHobS7KWeEi
         rh+tSEgu7YNnFXSLe86XR+mffaKor5FgVFg1mp2bN54DoE2nRBLA9lLVdLff6zYskGsF
         XaNA==
X-Forwarded-Encrypted: i=1; AJvYcCWf8so22lBQanHqstmM5r648tENfG1SSCMZA8orlk9JnNa8UeAjdgTYCCWiETRJuF2rMNAKz7g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVP1n2oyXGbot9Fae0UlfKAUO+SNqNJHBk6TByZ3cpzm6NKcGJ
	6M+zukz6g09HPCSgrA+ziEK/eTzBNEYuND15x8Q3BeQ+YL0A3sVZLs4QejkLnlwlNyg=
X-Gm-Gg: ASbGncvm1DhZtprzTlZ+U3aMwP/Pk6oZ4EnFd+Jw175HFvVHj9YhS1A7+LpMoxxkm2d
	sOtWObUowAQetUgiCCF2QGJvBj3qAHuoi9ecGM4OrkIpGJ0soQ5om3OwLH0fSEPBpKspyXhHHqA
	Yr1KKVKaMcgZrmrtwinzvPdBtrEpbP9WINlksK84VdkWmlK7aEkmccS4dCGpalti6CPKNp/jAT1
	I/MLuzO4ogr9ytNpbahHNHRr0zdOklCYLyZ3kjML+mtJSA/FGnZ0RhkzF/iofOOygkDrCZAgl8W
	oIWXOcYZflZMTfO1KUUKeVI2fjutqIXQ+7H+ZAx6BJmw5dFCkcGZ82Bo74/1k/O0zyPzXOTzbRy
	hjexm2kFo723yWDL8VNMipFJnj7DebJeDSV1zYnIuFg==
X-Google-Smtp-Source: AGHT+IH/BaFdm6qjB9ghQzr4BZgdXtPtkOCmYQc/NNyMmIYlQPK76Vqi5YsqsCJo4ftIcTCJzUtW6A==
X-Received: by 2002:a5d:64e8:0:b0:3a0:7d27:f076 with SMTP id ffacd0b85a97d-3b60dd651d2mr15563166f8f.2.1753103115987;
        Mon, 21 Jul 2025 06:05:15 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:15 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:04:59 +0100
Subject: [PATCH v5 05/12] arm64/boot: Factor out a macro to check SPE
 version
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-5-a7bc533485a1@linaro.org>
References: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
In-Reply-To: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

We check the version of SPE twice, and we'll add one more check in the
next commit so factor out a macro to do this. Change the #3 magic number
to the actual SPE version define (V1p2) to make it more readable.

No functional changes intended.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/el2_setup.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 9f38340d24c2..2bb0d28952e4 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -103,8 +103,7 @@
 	csel	x2, xzr, x0, eq			// all PMU counters from EL1
 
 	/* Statistical profiling */
-	ubfx	x0, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
-	cbz	x0, .Lskip_spe_\@		// Skip if SPE not present
+	__spe_vers_imp .Lskip_spe_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x0 // Skip if SPE not present
 
 	mrs_s	x0, SYS_PMBIDR_EL1              // If SPE available at EL2,
 	and	x0, x0, #(1 << PMBIDR_EL1_P_SHIFT)
@@ -189,6 +188,14 @@
 .Lskip_set_cptr_\@:
 .endm
 
+/* Branch to skip_label if SPE version is less than given version */
+.macro __spe_vers_imp skip_label, version, tmp
+    mrs    \tmp, id_aa64dfr0_el1
+    ubfx   \tmp, \tmp, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
+    cmp    \tmp, \version
+    b.lt   \skip_label
+.endm
+
 /* Disable any fine grained traps */
 .macro __init_el2_fgt
 	mrs	x1, id_aa64mmfr0_el1
@@ -196,10 +203,8 @@
 	cbz	x1, .Lskip_fgt_\@
 
 	mov	x0, xzr
-	mrs	x1, id_aa64dfr0_el1
-	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
-	cmp	x1, #3
-	b.lt	.Lskip_spe_fgt_\@
+	/* If SPEv1p2 is implemented, */
+	__spe_vers_imp .Lskip_spe_fgt_\@, #ID_AA64DFR0_EL1_PMSVer_V1P2, x1
 	/* Disable PMSNEVFR_EL1 read and write traps */
 	orr	x0, x0, #(1 << 62)
 

-- 
2.34.1

