Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2529E274FF7
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652235; cv=none; b=YooNyJZH8OPjYPq0MXyzJK/Pf1zypH7cuJjag+0srPwAkUNT1WM2/NVs5L+E0Mu+o7XIM4QY8z7VlaV70qDfs44D5rmdqDa3Jshidnu2F86XcTymsrevCDNcwZZZ/VaHNnoG2c8MbqekCDJIE+rVMwkr/GFb4Cd2+7ha5yqZcmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652235; c=relaxed/simple;
	bh=2M6WcB6KkvvOnu9SyMhbI08CMGWnnDOzfm+WTNCBqlk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fzi86Sw1kwRS1QVQk5VlRcbcnbKIHFWPjSM8iPXm3x2aZk0ZOYAB5/AnBhITZHirD38IDJRCzkSxSkfxlJjgNUz6eNPXPhmVbN74QloDs9M7RfXJ0GbDI4lYzEfX/VcSiS+v8rvaL5Uwxu5p0QZ35qZtK+lnQtjMADbzzwKOJo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xi/4dZUX; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xi/4dZUX"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-458baf449cbso19137805e9.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652231; x=1755257031; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXydwqwRaP7AXP8zkgHzJDBJPfnaYLIQgQCT9Y2uDB4=;
        b=xi/4dZUXyWGkpX9DpkYqF9eFpgNwFePwAEWw/f3/z/1SF5czGOcMrwKHRk5muQom8O
         ujw6Z4vuBptsUL9EB1XHjJ6dL7WKJ0LZok+S2gsIwDZodaSJ6S1oS0S/mFqEiqPFxAcY
         Olz/TjLlkdqft0eQgl23b7M2HDEDuowooF+7GOLZs8KnWi8vTKG3atfDEgAEmfdeGga6
         vMKksSHD2WSeeUuieOKERqCcfs8QN28s/cUWnfI0bXS5Q1GROU6KFS6oy+XoSMESEU0U
         orCyWI4yVQYlj3RyrpJRt2qgjSXYBlS6R3NSD4dSPWovfkwfSy6fkiKxhyHQPYmLQysZ
         E0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652231; x=1755257031;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pXydwqwRaP7AXP8zkgHzJDBJPfnaYLIQgQCT9Y2uDB4=;
        b=DjctZeq5ogSuebEYEVdDOan0n1gT4+D/KFsfbfhP/XuOIxgBeUXhPUWt62LvPJijOM
         q3aI/7FvdgHbnRFYeTFSGURyiJWA2mBbnXPbbMAXTmU7TQKhHm/PxIyaLiqYbwjopgBH
         cFoD72+Ii0ImY+cZrEt8mNN8NjN3VDdeeLVD5/A4gJlQ4TT5MxqOMFooSFi056JDcSMq
         hx5uvGLF9UCEUFABEUBCU+43ruD8RDZwiaPJSrxTpM/kqUckX2idrOfB3FNtpJ0BCWST
         Wi9R75ctaA9GUzJIdKhYQ+QtWtAhkrfWQg0EYfoct0+uu3ZnED/rzbmbjDPozahL9NiS
         7Tcw==
X-Forwarded-Encrypted: i=1; AJvYcCVbYsH4SZbU4g69JhfOWYR4pDqr+pyS7TuICj89mrSowP4CGn0k5T3xG93G20R8f4XucHZ7y68=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKf/Ed7sELgz0YpmPwbNG15tcmaKS2Fd7cbYNSaR+E361BkDRv
	BcPsOn9MqACIy88yqco439onlIwbh8E14Hp6LFv+AKqGSjakqDk7WKb0db6HxGrsIms=
X-Gm-Gg: ASbGncuCKFroaj4xuWJmmJP4OP/6TFVhICMd30n8Ond6IAq2OcyQ5ydf9hdMGtzlIwk
	Wh5tBHszmCZCMaG2aDU768pU/O/CqxevOsrYn92e64aXScQX3X8qdwTw7dF9Cb+X5xUSE7om/w1
	kSpfGUNp7QTqcdqztiHoYQTNkewhbEkh2OmCrbpE7YI6LlU+hLLuO84m8fY7SG2aicDvxFfFjBo
	0vGHiDSitaevu4kAh7KMLyg0FaSqsFjG+OhE0IfST2dbPSoDxG7yjdKFgOYfOC8ZOJMAkLK/O7V
	aPEh17129MxaBUsV4csJXD0blKMZE3qubNacyzfZ5XOcXuQexv3FAgf/zCvuPL9pWvuvn2YMd2J
	XoFwS6LvX97jecY2rjBzvZM0Xq/Ck8Nc=
X-Google-Smtp-Source: AGHT+IGZt07Gv/AHxus95QP1UL0e334J3rp5xUM7DnDTXPfXeFD0bRifb9xINgGQEjtvNdHSQjLqQA==
X-Received: by 2002:a05:600c:154d:b0:459:d780:3604 with SMTP id 5b1f17b1804b1-459f4f3cf5dmr26410715e9.3.1754652231142;
        Fri, 08 Aug 2025 04:23:51 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:50 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:23:02 +0100
Subject: [PATCH v6 05/12] arm64/boot: Factor out a macro to check SPE
 version
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-5-6daf498578c8@linaro.org>
References: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
In-Reply-To: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
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
 Adrian Hunter <adrian.hunter@intel.com>, Leo Yan <leo.yan@arm.com>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
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
index 46033027510c..3a4ca7f9acfb 100644
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
@@ -255,6 +254,14 @@
 .Lskip_brbe_\@:
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
@@ -263,10 +270,8 @@
 
 	mov	x0, xzr
 	mov	x2, xzr
-	mrs	x1, id_aa64dfr0_el1
-	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
-	cmp	x1, #3
-	b.lt	.Lskip_spe_fgt_\@
+	/* If SPEv1p2 is implemented, */
+	__spe_vers_imp .Lskip_spe_fgt_\@, #ID_AA64DFR0_EL1_PMSVer_V1P2, x1
 	/* Disable PMSNEVFR_EL1 read and write traps */
 	orr	x0, x0, #HDFGRTR_EL2_nPMSNEVFR_EL1_MASK
 	orr	x2, x2, #HDFGWTR_EL2_nPMSNEVFR_EL1_MASK

-- 
2.34.1

