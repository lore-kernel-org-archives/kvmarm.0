Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6102D8389
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753102461; cv=none; b=iYh0O3jFXn/6rVZ2FOs7ZUHktF6j9KemK7XyMxnp2+O+42Vm2EwOt5sznl3rGMTkhTcc8UZ/X5Si9r0VHrD5j/BHKq5djB8BYIw4C17G1S0ZLCeXFYsICMwFrO/KzRvuN3gbwrhFFUT0PQgtg2M4U+Z0uglPDmby+2xN0usOiGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753102461; c=relaxed/simple;
	bh=9uMRLY3tW+LsgB/KLohPx6Pdb8SvPdWaSQtNDtaYois=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i93X6RN8WAR+5zLjXLajh/1T9T/E0qTu7XSbt2So/bKnh8H7q60BrcbT+j538aYMjdjjf75+GrC9KWkLL8ua6xHrPHKHSKhQuqtwua60YCtbOewUA1j7c6M71psFoF/8Nq+VWI2QCFFC/dswr0snGDWJ+r2wErk0ZKG+/bhujzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eGW7yT3r; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eGW7yT3r"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-455b00339c8so30247575e9.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 05:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753102458; x=1753707258; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ei/HnJSvouST6mpmth1X7iDdKdrsxcGxYeWK5nNgG1Y=;
        b=eGW7yT3rTrf6LWwmIhrvRdwsRFGogLy2sHpwu1hNqJIhE3/78rYEYO6ZqLBLdI3LRO
         namU61UY5oktucjG7egfWw62U4qfncM0Bh4oZqhEUjPl6rY5O2Wv5w3fJpniie1lk9q5
         eHjYhwTouVoUOod4lGSf7KBNBsCO+sM3q4xtX9rvaRW9nLt9Hv18xpzUcXCB2QgwbSz3
         PGLK5EzbHYKqlQW1wjRrmaLk8fapbAgfKxpg+rPoK2XTjARyn83OTNWt9GJrdxE3jbFH
         8WxztWjbrZEozVIxRZkxBQVYrflgs3DTTy1XGfgaKYAJL6LbXI51lyKYg8PEknorSz9n
         NfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753102458; x=1753707258;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ei/HnJSvouST6mpmth1X7iDdKdrsxcGxYeWK5nNgG1Y=;
        b=bP10X7/3WNUyeTX0Uoav6Yft33LkiwxVEb7rCSLmTX5pjNv0s0eBb3SoswCwJbbGY3
         ZmHBhuUK+BDBUpKN6JfD2hTWwf+BFT38jNrDs8Izw+D32s2HMRo4l4MlKLJFdmbsLO55
         azvSUeL+cdzKwWzVwE60clMQT75I8ihEUBwnM3lAcok/e5gfxM8MTUX/hs4wwygOd3sj
         1zU+XG2SUUBkAX+Q/tjI6V1otyNuJJ1/msaFwxqDNhlY7uVUTBMjre/imCkcGSeC+yqm
         hb1FZSxB7fkkB7MRylmmKpduJJApvXTnJ3s0gNnMBaQXGPKOCkxU/7hZ6I7WCQ+Vg6F+
         5NqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGNLCyHKcNT4xPjOLAaPlM8va3YCwi/LOXJzDKEvD5wjIXzvyneeNYfHm1YTZknBR7IQMoWGY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+H0ipYOT09bvF3jD7fnDyKRrbskYDzRkGht2NMgwk6HHlNpE1
	bShhcdYBttRSWj1MECjbVQyaF5+Yqs+jIAxC67y9/L7A4oj/RhEUgnTb6VbFK9RiMHU=
X-Gm-Gg: ASbGnct6mD2Xk9gb8JGJaO3HeQ7inYXCVv6K4TwtzdHakM4QjRTWe75muOC1fRNaL07
	UtnaCpSFrbAaowOu1sHBvDYUzV0gZjeDK68rEyZK82jO+uxcWJoRhQ3mrqWSO9w38/Jhy6ZtzEL
	ME+nx2TJ+Hm61Ofpwys5MONqHdo1c79RTwy+QQu5Fna3Z+HvZeTQeaWR8+ZBOIWw6lnRZRcFDGT
	zFDrDhd/53aFe+A8i6uKn8LlaC/2aZRH+RXxGcf5nCWrDonVx37uLF21CP6pVM1PmS0tJ5TMca5
	/4RFkDy66OLlhbaptXnqgi8DPz70OpsQkjLjebfeXMhZLkIKB0KAClYp4/enC7kU1z5VrhvNFZV
	RB0CMGRKb9wS7KFuSp9G6L1pinb9HPO8=
X-Google-Smtp-Source: AGHT+IGXHG3FB2msUxbdeDts98g2pPebzoNgn/wdUbPPp8qpa2AIRfLTEy0hX7PjnhlcduPhaxdQQw==
X-Received: by 2002:a05:600c:1c0b:b0:456:285b:db24 with SMTP id 5b1f17b1804b1-4562e37c48cmr144674035e9.28.1753102457591;
        Mon, 21 Jul 2025 05:54:17 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75de26sm98995225e9.33.2025.07.21.05.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:54:17 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 13:53:37 +0100
Subject: [PATCH v4 06/12] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v4-6-0a527410f8fd@linaro.org>
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
 kvmarm@lists.linux.dev, Leo Yan <leo.yan@arm.com>, 
 James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

SPE data source filtering (optional from Armv8.8) requires that traps to
the filter register PMSDSFR be disabled. Document the requirements and
disable the traps if the feature is present.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 Documentation/arch/arm64/booting.rst | 11 +++++++++++
 arch/arm64/include/asm/el2_setup.h   | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index ee9b790c0d72..b4f6d487a322 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
     - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
     - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
 
+  For CPUs with SPE data source filtering (FEAT_SPE_FDS):
+
+  - If EL3 is present:
+
+    - MDCR_EL3.EnPMS3 (bit 42) must be initialised to 0b1.
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HDFGRTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
+    - HDFGWTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
+
   For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
 
   - If the kernel is entered at EL1 and EL2 is present:
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 2bb0d28952e4..7c89e0d6e739 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -284,6 +284,17 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
 .Lskip_pmuv3p9_\@:
+	/* If SPE is implemented, */
+	__spe_vers_imp .Lskip_spefds_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x1
+	/* we can read PMSIDR and */
+	mrs_s	x1, SYS_PMSIDR_EL1
+	and	x1, x1,  #PMSIDR_EL1_FDS
+	/* if FEAT_SPE_FDS is implemented, */
+	cbz	x1, .Lskip_spefds_\@
+	/* disable traps to PMSDSFR. */
+	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
+
+.Lskip_spefds_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
 	msr_s   SYS_HDFGWTR2_EL2, x0
 	msr_s   SYS_HFGRTR2_EL2, xzr

-- 
2.34.1

