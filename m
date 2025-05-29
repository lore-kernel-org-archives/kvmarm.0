Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CC328F52A
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518400; cv=none; b=hLaeG81JNfUcASdYVFczJLuYmX3syGFBhWpyWMW3tdHzz9cBHUwHukxj/bvUUWxxkklVwVS/y3hPa+VxB/xjoFGQSpPuZU1Xswpr+nHoCF7vH5roz/eriAtrq4fBmrKpxXql9A2aeEP9Xo0t9Iobcn8RrLQDnpgzVijZq1hH6SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518400; c=relaxed/simple;
	bh=41eja3GEP0F1NgK0VkDUcr/lsnX2RYh7poVYaCc8trk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q1V6NyxBmON4geRQsNh+OriJbE5ndr8ENnQM8qS4rDC4+j5U5njhiZk41N85VS7JWGOUrfGSNVAm0t3e07YB4cooo+JP+/RSVRWGk7l4BvtqTEIicTzbLRW9eTwPAgycCHwUf6ugLSjMfw4TbYEQKBasYKGDcVP+a6XaTYW++Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CEvMCeyz; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CEvMCeyz"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-450cd6b511cso5007775e9.2
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518395; x=1749123195; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YBZfytqoLfoLLkCHGYVhQ8mByrfQ3MODercYrOljLZA=;
        b=CEvMCeyzbR5zwsbeQQqZK/9WzPOOk/1OSr2k+Ze2lUPYxghg0AysWOUHtGeeC5MoT4
         ZwV6ZhV2cnMD/kzaWOHfot0kMgj4ERpOu+OvsOcfpFLaQtYXtQFYjK+7aW5KXa3O6Gu8
         RFphAPHgULwniX7UxEBG5ByoFbZc1WjWKNjnwg187iZOi8ElbY6xZNbvzk4ZYsNLsDrI
         OUOD/kcU1ea5Qw3ezC8zfGcolygTDM7Uc9eYF4pskmrfJJ2+wPBjRAThoXGlNKIrwLMg
         l4hG6kbOYQS1BCzwtQLomA6HnCh6luHd0LU+xuLvfge7VnFoqucQttli2hDTDUBXtBQa
         ygIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518395; x=1749123195;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBZfytqoLfoLLkCHGYVhQ8mByrfQ3MODercYrOljLZA=;
        b=SglbKoelU0KwCyJZEkiKtd8cHvHkCMWpT0UeOInJ8d5WcjgwtcCWTkmgLXocQD01Z0
         eRcUPOK7+zUYrvLSAZOjlAB4n3+HnqTiue8UzzveTD4GTF1Twx7ZGU9coISuZh5nyGeJ
         vr8jFE3Q+GUD/p/I8r5PtlQX+4PguPTJL+EhRzgdTzCG1FzZ5gAYBcuo8zqsMESNKN1k
         JW9mgi3vJueQhsnshRRSzWEYbdAgJvRNhEwuEym7VtXGHjD+g1DPs++eudcawDyfYwZO
         eV7Dcw99nEdQFRVoQrXBtVvQF93psWEiymkGKaRyGhclcLbRQrcLHqAztQ/tJJPKwmCE
         c9rw==
X-Forwarded-Encrypted: i=1; AJvYcCXp0VP1Uwq0LL6sjf2sKCC2vOYNVegHnkfQxRaJuZ4tbM1pQPQQ760lpkcTMvL+Hq2NhINQNEE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpGpMIIS9Fr4XeqWkNMoGa+eSVBXq3NPKN8Si/kY/1/s0BO4G3
	lVxvWJM+1QMLyecl+cil6b0349QhSJV0IE4y/g891cfn6zQTRc3XFliKWvPy+0PLlec=
X-Gm-Gg: ASbGncsTXK9bc2/+RiL/hDP1RGXo0jyEX6QjLF1BFoxcJCoGVNckS17a3co/IjcwF46
	VI9cBZCDHDOQNxz7Mk0Gkt0Vlta7INZchz+N9lqtU/L8mt/7ZNDXidHcDpRzlEiOgEEghluaK7o
	+SRatN7cWegaJ4Wduh52eAYuNGPnnYipUlR5tP+9yF8pZV33LYQz8+lHn5RY0HXXKWFvHW7E2Pd
	uFrYth7Bn8h95DRSrIwmyDg3lmzr9frc/JYvGqrtxp3RGZcD54PFPl+0GZFtxf5zdpcxhXEdBVO
	9ib5zLGLqV99m8zk44l7xA+bW/RtjkemJ1K+oe6cQ6gpVsEiJmJU4h6VYDa8
X-Google-Smtp-Source: AGHT+IHMMfVW7IE9nbkSMy9wDfF0tmM1c9IXy+rbxej/RhTBlE7UtH3OLrCFPOGZOGsnCFRe6FkZLQ==
X-Received: by 2002:a05:600c:4394:b0:450:cc79:676 with SMTP id 5b1f17b1804b1-450cc79077fmr23266695e9.20.1748518395511;
        Thu, 29 May 2025 04:33:15 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:15 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 29 May 2025 12:30:26 +0100
Subject: [PATCH v2 05/11] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250529-james-perf-feat_spe_eft-v2-5-a01a9baad06a@linaro.org>
References: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
In-Reply-To: <20250529-james-perf-feat_spe_eft-v2-0-a01a9baad06a@linaro.org>
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

SPE data source filtering (optional from Armv8.8) requires that traps to
the filter register PMSDSFR be disabled. Document the requirements and
disable the traps if the feature is present.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 Documentation/arch/arm64/booting.rst | 11 +++++++++++
 arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index dee7b6de864f..abd75085a239 100644
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
index f6d72ca03133..6d0d8c25e912 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -279,6 +279,20 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
 	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
 .Lskip_pmuv3p9_\@:
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
+	/* If SPE is implemented, */
+	cmp	x1, #ID_AA64DFR0_EL1_PMSVer_IMP
+	b.lt	.Lskip_spefds_\@
+	/* we can read PMSIDR and */
+	mrs_s	x1, SYS_PMSIDR_EL1
+	and	x1, x1,  #(1 << PMSIDR_EL1_FDS_SHIFT)
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

