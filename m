Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C4827CCFA
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746531767; cv=none; b=oCzotYyw2LkBcVvyikXhbVNAO2fkVYLD7X5Fqdvo1XsVQCzw14tTLmuiBd6VICCmsTi5lJyQZEHJcWiPmJwUntxAz0oBuhiE9oTpJ5G3UrM/CMpYRdxZrWDymesAmkOrqKeDvKjcV+fY9xS6h4WlqbzW04iTUmvrTnhCU+as80Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746531767; c=relaxed/simple;
	bh=8OmkHkCGDObescNOkagm9A47Swwu3NytmSXnqZHoHGA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hq+Lw9Icy1vNY1KJdlK56VVQFOXBSPDiYgvurXzfMlfQ5YkopdnMNHFm95KlJWGhpwsCRdmi0MJvZQ9vgtCKSpu0mQsyPCZCF9jXwP/r5J43T1k8Ru7J/KrWbk3ziMld8dVR1pvinhPerwg/Bq7fXuvdjJ9VoRT0wIxySSyeHY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uj2+RO4l; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uj2+RO4l"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39149bccb69so4319059f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 04:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746531763; x=1747136563; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gfK4D8WXXHfk2zwldWwUzY+IJqnsgpS7YeB5hPDSAiU=;
        b=uj2+RO4l32tak/pDA0qcvSm30x3vwbN6EoGGxwqi/SNWlOpMJEuo7dsiX9PObrpk91
         e4ZiOwyVZLr7sIwa+1GwvfmWXb3truYqdKYYyEa8bfXPxCC9ovcIJ21BA9DTizF63usQ
         e9mbOTLsZewOOS3OKwkMSWmIIYexwGLXjzImel/yxcFU1zGttoF1vxdH5gbgEbTftY98
         63MnBFwEDqJWdyocx2zkKc9Pt9c4z/rEfqRVSAAP+cLSS0qjlEAwo9PeHOa+LnSoc2Or
         bR6P6QdvRTB1tYCETyAUtgA1APleQQs4PqBwzS3jdCQsDwCwunxjm/4My7Re6agKOPiw
         3K6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746531763; x=1747136563;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gfK4D8WXXHfk2zwldWwUzY+IJqnsgpS7YeB5hPDSAiU=;
        b=h22YQryvqt3sAvx6tZfnf9oxKGlZlHsD1kr8cXjjQU5C2OhwqmEI8GNQyWgzKHNTEy
         C/VMD9GNZnJ0VlNuqBGbDHa9FWOQ173K6iic2FQaFNk8qXv/RLR61N5co5hVtblTAFhQ
         UD1L3O6ZEYYOllMcz/zd8SPON3TD2b148SAZT3f7Y2qaBtlbgZr0FTuiPCayUJY9VxFL
         LUbSwHP/GWqqGGzm/WJosq3B3/SRYh3Prtcw6Rz9Uk0gal/kI/Xt9eH9/l7Eyj4kB3yf
         Mwrw0a+uO3uIUlXGiOpT8wvsn9+PtZ38ozZSMutqTKUyV6y9Qy1iqdW/iwQjGsmnStju
         En4g==
X-Forwarded-Encrypted: i=1; AJvYcCWP7kgPWwGIC2+Aa+Dis7OZzI1+tHgu3DgV585ylqfiEH9IyXKLc8hMwcaslpJ4Z0C5LDhRWNw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyznlxkTmSt9cXhiFq57iG1CnOptsAgmGWHan0T+Uydv0gAdSs1
	uP5ARuXm6PkKJooQrpbaWScn8Bvudg+Z9z2l7AwJdNnRf2V+5LJLzu3qlAlfbkY=
X-Gm-Gg: ASbGnctQoWPpbCja4Vxc15H1dAtexHmVil/CLIr/fRUfLVogmWBPCH6KFs53CwMgNXh
	WCOoXPU53+Dj1Oub8jPVMRd885jxyYAI44yuXxyiL0J3G6RcWmAzTxriAwXm7mjAENzJRvYRCWa
	bK+3lBVBVD9Me5/wW34iAc2fpxW/xEK2GZplIvSeuem+lCpaRgYLkAQxoYCo4JUAkeDZDcYrsYO
	NaLLlJi3mmjL3EpMRskCIomf8sOsR7Je6j12YYaw/5rVj7C9XqHCDV8Uppex78b9CwvBjoBI4pV
	x4GotfmeS78Fixf7U2mHZHG9wgEIZVhIRTTTxGsEUBBhNsD/YhVUjKZK+w==
X-Google-Smtp-Source: AGHT+IFxzoHVTs85nB/2QCYX1+sgmEItPPt1ggabHpBdb5kgred/4/pK2CDSumpwJgEYOUOvr/4oog==
X-Received: by 2002:a05:6000:2407:b0:3a0:82d1:f3c2 with SMTP id ffacd0b85a97d-3a0ac0cb13fmr2410966f8f.10.1746531763203;
        Tue, 06 May 2025 04:42:43 -0700 (PDT)
Received: from ho-tower-lan.lan ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae344esm13198473f8f.25.2025.05.06.04.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 04:42:42 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Tue, 06 May 2025 12:41:40 +0100
Subject: [PATCH 08/10] tools headers UAPI: Sync linux/perf_event.h with the
 kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250506-james-perf-feat_spe_eft-v1-8-dd480e8e4851@linaro.org>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, James Clark <james.clark@linaro.org>, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14.0

To pickup config4 changes.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 tools/include/uapi/linux/perf_event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/linux/perf_event.h
index 5fc753c23734..c7c2b1d4ad28 100644
--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -379,6 +379,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER6	120	/* add: aux_sample_size */
 #define PERF_ATTR_SIZE_VER7	128	/* add: sig_data */
 #define PERF_ATTR_SIZE_VER8	136	/* add: config3 */
+#define PERF_ATTR_SIZE_VER9	144	/* add: config4 */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -533,6 +534,7 @@ struct perf_event_attr {
 	__u64	sig_data;
 
 	__u64	config3; /* extension of config2 */
+	__u64	config4; /* extension of config3 */
 };
 
 /*

-- 
2.34.1

