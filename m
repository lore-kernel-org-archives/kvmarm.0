Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426D2D5A12
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753102456; cv=none; b=Y51rFeItgnLkAjpwQDeNQYVxI9fCwm3da5HVLfYX/BkVHTI4QVffJVYLtLO3kneM9fDijTZPmVcxs/H07Ll/+UbV8iuxmtvKCZmp8UCSUbCKmzuHo5XUJXKbJ+9/fqnRrIqswqWGcwCAQ2uxPeJuxKO3WZOQnZTxFr5ORnQ3zZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753102456; c=relaxed/simple;
	bh=isf38v+uTebHr/0KouGZLHu/zXcyClycP3zhjgiVfZI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A23YlndBMADmpsMAZr6XtAJ6nO4vM+Yz1E97BhoB1b6FKSqBDFGiaTsGtsRgoq7bSEEXRAXj5hhpf0L4HJkwTkgEtbW1c+46935KpdaLBWu+X/G5ca2a1mOzNM5XMgowN+NQuz+NcKhqFdOgiuNA6HZLAnFYR9FeSQ2cHRKQzJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W9G3wT1R; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W9G3wT1R"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-451d3f72391so43601495e9.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753102451; x=1753707251; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BpkxTGRvQkor5ThWfPSfZfarMFvM1/zI/E944bIEcHE=;
        b=W9G3wT1RS/yjcQJ4uVN9EV8Lg7kc55hycJgANV9BGa9udQz/jWWT3AxUo0tpBFHg9N
         dJeMWrQJ29JNhBHMgNcr7Lr+CnlpSTGkPXIs8eOU3MJEhsj+hAGCG14vjb9DBfnmckZC
         G9qBK2Hhc+fCUaSXgPH3RZoStffFY7+iWvmjXfwPCQ89VAejhSVH+1bSI3APY70I2DYT
         HKoUePIRv2hZy1VwjBIwx7hY3pqQzEsLVxCgCDTE047yg00ywazmJQIWjy62u4s99DJ5
         RMkXvLUSNhpuufRbsWTSqqGh1QrD8wmacCTJXhE3PAhVmsnQ9P4ptzx1gZ0You+sU51n
         WiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753102451; x=1753707251;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BpkxTGRvQkor5ThWfPSfZfarMFvM1/zI/E944bIEcHE=;
        b=YbEEfNQ9nOkuArbNeA/cPYCnh/JKPbQJ8cHrWX2AfPegBBZWArJhOvB1fZrClFmL87
         f1qwXXauO7G+Nk7ADKwLxbdfkslFyotr6gfaFtStKH0XbMcmGpomgJbIrQO+hG5BhSYS
         rUQL6x9OKBJw6BOBYCNvx+FDG7rjVUXDT0n82df5zYJZxi3OiZ/DYyHMj3DNu6LJPmCV
         +rGFaBCDTVYFklMWuFet6OBJlrW3AXS9UgM5xmT/jQKz2YQR8jWtnSkmBqmCDvkIoZK1
         8+puYcm6MrHJjcF231vXApHewRq1Qx6WY4fdOIWyOftLrSgQXp1CwPQ+xqvURNm15MlY
         y0Ig==
X-Forwarded-Encrypted: i=1; AJvYcCWCvYVfiMz/z3eriq8jqSAVM8BD/BwTWMVQ8xwV6zxbicmD7ZQnJekNE1mZePYQBKLZpt1xujg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUr8eLFalmxQPUsLQGFqJKW5aqn8AhgMss8mKMyoRK36stG9JG
	5TuPEhGiysIy/aKK1BmQC+TC+iKY/14Yo6lBiiGaobwCKtmlhSnAO04/pcjES2EP2P8=
X-Gm-Gg: ASbGncsKXTMaGHRnBBxds9zncEuLuy5pFnK23pAS4f0KHfVW23bc2KGhuuFFiC26GqQ
	5wP0n3xBfsjKO0oyUds2Vu5/pUXlmwn/HbUhXmclm8pG21SLOP4eQbgxNo4H4W/x0wg1tMWJCAM
	qP2EoTv5yfFms6+8SaUnZLcN7WSXAR0GkStF8heQzNQarcObLd5HW1EU9umDKV1D6NhLb427T97
	v7s6lmaLhChmH1dJjqGAmHi1orAroB1mTDAc0x4zehBTYxl4wkGVW9qHDswenutwGcqZjWivlqC
	rECw6uDMR73IuHhJrgzQ3DmK4jWFT3l2kKN/D53YNnmBZZXO6jrwVzF0vOqLcBUsjwYPGuTnDjK
	qGSd4qL7UQ4dI97C1HP/UmugcrdRtWfH/bYurEe1iPg==
X-Google-Smtp-Source: AGHT+IEJhlbX9r690UiEzzeJ/Kdt8gvdkx0yoLLcBqhw5wdAqCeDmj5h8tFS/4SfvpSlDeFZRRIY/w==
X-Received: by 2002:a05:600c:a009:b0:456:13d8:d141 with SMTP id 5b1f17b1804b1-456389d8690mr124492795e9.27.1753102451282;
        Mon, 21 Jul 2025 05:54:11 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75de26sm98995225e9.33.2025.07.21.05.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:54:10 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 13:53:32 +0100
Subject: [PATCH v4 01/12] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v4-1-0a527410f8fd@linaro.org>
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

Add new fields and register that are introduced for the features
FEAT_SPE_EFT (extended filtering) and FEAT_SPE_FDS (data source
filtering).

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/tools/sysreg | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8a8cf6874298..2e897d8a4040 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2859,11 +2859,20 @@ Field	0	RND
 EndSysreg
 
 Sysreg	PMSFCR_EL1	3	0	9	9	4
-Res0	63:19
+Res0	63:53
+Field	52	SIMDm
+Field	51	FPm
+Field	50	STm
+Field	49	LDm
+Field	48	Bm
+Res0	47:21
+Field	20	SIMD
+Field	19	FP
 Field	18	ST
 Field	17	LD
 Field	16	B
-Res0	15:4
+Res0	15:5
+Field	4	FDS
 Field	3	FnE
 Field	2	FL
 Field	1	FT

-- 
2.34.1

