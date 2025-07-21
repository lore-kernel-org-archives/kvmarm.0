Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB762D5A0E
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753102459; cv=none; b=MXcPGXBMo5GaR5EVNHlMuLqvBEUdfe2FDk4cLHGTweNaDaPZs1NT5pLJkMDmFsJVR1cOv4t9LggglBnGMGffN32m9waHIwjHJSBAtSaMNjBXWhjwRWqLEOsScNHflfHwncuyXg/f27LX3/Mgd8xnTjlhKdK7BxFxHpFm7pxqZB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753102459; c=relaxed/simple;
	bh=YxvmYpOV+737fyfcSQi4SIm2ZMFnBONYtUfp6vtMhrI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N56C3B5caCQ6ZkbHNZBO3XyajF5n1lOC/P1jJufIqW7YVPq4x+a3SwCXisPJdCqPIPCkNrPlshyLKoj+OF+ZMaJRMDCBoagzZF+kiXSNqROnxm1X+ADOjNdC8jhNnAXi024gsrd/l0WYCq+LNbX7oErtZB1Km5arQSOV8XFs/V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gzNcDDnX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gzNcDDnX"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45600581226so44955785e9.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 05:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753102456; x=1753707256; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJFteMx4M8CuvuwGOOEAn5xVwGW4RJ+pfzFY5hwg8co=;
        b=gzNcDDnXyqIcMlLYnEJwmMUVjvDJf7HbMc0A7IYtIk8MRw5Fr5ne+Q+hILAVPm2P1+
         mBWXi0AEzp9+i2uDa1vCzeHKwN8OpTIhNB+kqycPZ5vV2sLStHtSk/9xRCUkmXXoAZco
         rK5r6lw+Kcp33e7Oe2eYWo4b+8SBsx4CN5UmWJNo2uW1r1qIbdoAfFv1Ba7yv/Vdfbwz
         Ldtk72XYkLe1Si6CgdYr4p5O/YcegEa/LgRXG/5PYNcKj2JO8oySrJTKyL0WLVShUM8t
         FrOyvfdxoBrQGFWEH4LLIKqbW5d+Erc0zPscll+BD0xsKIbBDwUp5YdrtI1uaVHDX5BF
         xNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753102456; x=1753707256;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJFteMx4M8CuvuwGOOEAn5xVwGW4RJ+pfzFY5hwg8co=;
        b=Gd1UEjlf4kbhqK8ciUVW8OrgW+3CDaaGlhLDq+px9cJbJJNf3WbceV9HFgE8bCJ+8+
         7A60GmeKT2nY2SuwT1NsC678nWYvYMpJVFtB19roxv8daQvSxjyCXVCbUyP3JweyUGXt
         9GwvRIs52fIguZSnKvmtsMlQo2e7OyHVhdIbBq7RK15oqyxitgiCas+7wHclToJB7XlN
         NwirIxnH7K6XrUMsl1TbpqQNhgdxFHtobF1t5byqyLcDU/Yu72YUeBexlPGe4S2oO36K
         oYXBt6Dljgvd1y8Qa4rQvyNYNXZa3HRkbX1dL5cSwon/4BHIDATF49auWfY3qQX48eKP
         8oLA==
X-Forwarded-Encrypted: i=1; AJvYcCXL4QZnYILmnN1wGCPeaZrUIUBPbg2p1R9/W9sB1GoRUW1j/4NRx8jhvjq4al58MeODT/PQiq8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxASPmTapr82+1EYCbNSs7LOAhU/uuZjj/31gthL+bF+kGzyX50
	xRgs4o6a5vK28Nx5GXqbiOuNs7b1lndIBPBCQM6o9w+HoZT7hUm4Ex3LLPOqppWkEL4=
X-Gm-Gg: ASbGncsH8IOPclHqhfNLWD/1VUZlLNU9etkUo+mTRBbKot+icm50Jbm6iIJkcutKkV8
	ybCIL4nyLzPtN/eNTmNFi7ZEQHFznFpNiia9bbG+rRKzjb4x9orsRvfqC/zRIKC+SmjKl9cddKJ
	fVUQvvvmuZrPP1ayOZmSlM8xN6Rj/5OrKI68NvO8wVoZS5xxlEIuTBoKH21e4xF2R2prYJtjNx4
	uqwIfdrns0XeHAD3cmx4FG7ae+MLjinTB+gge2QfuJBb4ypRd7hfzfZrOkjR9aX+Gcs6QHR2kJ4
	p1yG5JyKM2yNtoxtHljLRaTVFu+3wGn1aYg1a3/Jg2jvPVV2qYLUqwR3Wjngy7AWbQof6LoIThh
	iUKkF/+odfyDSQipqqN9sWXYnaQ8Hlbg=
X-Google-Smtp-Source: AGHT+IGmbQWssAINXf1JMCsxu7iT/5v/bYbxuFsBy9x2nb4iGuog7PTzyHokdJFF6f22G9q2Sa/2qg==
X-Received: by 2002:a05:600c:4f91:b0:456:25e7:bed with SMTP id 5b1f17b1804b1-4562e23b6a5mr208680525e9.14.1753102456271;
        Mon, 21 Jul 2025 05:54:16 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75de26sm98995225e9.33.2025.07.21.05.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:54:15 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 13:53:36 +0100
Subject: [PATCH v4 05/12] arm64/boot: Factor out a macro to check SPE
 version
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v4-5-0a527410f8fd@linaro.org>
References: <20250721-james-perf-feat_spe_eft-v4-0-0a527410f8fd@linaro.org>
In-Reply-To: <20250721-james-perf-feat_spe_eft-v4-0-0a527410f8fd@linaro.org>
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

