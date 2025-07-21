Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8096E2D9EE0
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753102466; cv=none; b=l+JKQeAZy1F1PmAcXB4z1/nYCEuT6qEC8FnwgzBQda+Y5zeGkDS9c4SyQzY+7JExXqf7oDVhOSnp5nc64nsQzEPRSd6n15tpEECWXeKCMaS6wOJH3/gMv+6m72OpAMK1x/T4xWHO4NgTLhw5P3smgH2ori2EGlympMNbo4Gryk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753102466; c=relaxed/simple;
	bh=XeTbgg1YCZhnU/IzLKbCe1re6NeCWvfz3HX4Zc0ZwHU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GwSyRAFtflYEErpvycI4fTXPMJNzTJoyNfYGktuZhfEu2i0jQKJ0cmn56P7AB/xFQY+cWoHDsBRE2unbGnfT+Zjet5tjtxsExtMMeq9E3Qs385mftIKl4mHx2TTpPlGxlww1M4JkAcHtjaSEDgqMpUBTLObDUD+LWXxWQGfPH6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vE7zYU8V; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vE7zYU8V"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45619d70c72so40370175e9.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 05:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753102463; x=1753707263; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l6klp9EUNzNQb89anQF9S8nNJOTrH6bgf7Ht0lN5b5Y=;
        b=vE7zYU8VyYPAVJKiMiiP1cQAiviEepe7icr9BPO3QgLBeHI0oYvbtmdGxdfzVQOO1r
         Xmo5xLfyTFgeDev59iSOYJVyhiP3I4jZQdNT789z9gcuyeP/Pmv81MDCyx9LCw0401JJ
         PMKBhqIF6BwBnOX7QNx6Dl6kXJ8njIXOHLBL2XZJvIHJfnFgsTz6aakD9cUJ9du923JJ
         02iS8GIb5X12ppUWdHOjjk4j9Ch3Yrtvk2B74Waf1wgzH00FPR4V9ILEiWRrIZpKQoYE
         pibOnnk1qUE13nBupAjwlBSlFNLvhT0OOn1bAJn9z/wB5qup3XW0IgNB6dn89xCzCwas
         7gWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753102463; x=1753707263;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6klp9EUNzNQb89anQF9S8nNJOTrH6bgf7Ht0lN5b5Y=;
        b=vzMz6bzhKv3XMKQCLpQgEyIRWgZOZSlo10upxSB6q9suwO/OS0A8/mKXc/ybeMJd6b
         Xw8jES/TqH1Nn4J19f9ucBuAiBM2xdDKZZPIzu2uhPTvxhKAENKjWvd32ejmhWacXGtG
         UUlUtsFANcKfrR3RplCin071IQXU3vIcnJ2bgYF82zhjcqc52cioaYGmNtspNSvJwG9K
         E1gVuEWQlX37tyZObedmynrKP1KZDl+ETthd0xW/L+V+xPfK4uQNtdmnGN9aO96hy43e
         VP9XEzeoNFjvs5fdAmuma37NM3LtzNPU3CQ/4yxj8QKFgHl+6G4zRYGAVvfV53NHbdTC
         oM8A==
X-Forwarded-Encrypted: i=1; AJvYcCWWmi1k3X1dF7hhR1o6kxILzi63I/nzBo9tHgRGkL2RRFuhp1UmCqkrlE4sigxof8kW4VQiMn8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEaV2sar3XmWGIwfXbvsuEZJ6xSaTjHNWWYymGRNNra5MeIzxe
	2nkqPQC3F9lIjaIaW87iI0grrhfk1uFFRLblUt6sxKX/MMt86sXJ7wQn69SISHFyMjw=
X-Gm-Gg: ASbGncuhk4NoQwkQRkJ7bCzySZtolL62FELMHke444CWJVr7ErP1sVHsjs2R8C5RfQm
	03qNA6dSu7OWN39+UWDjyIu9kdfpQMviFtkOzT2KYIJb3I4jAeAnncq1poVDv/j80rSCPIiKkzd
	eeKICidW9injTpgT/vSdjS7f/cYwt0xgOtpMOXbHy3HhMcPwVvrY+5oB4bgKEQsCnuoen9JIw3C
	lFdVlSyoS6PFEUpsbu1CQd29LHmtJjkz4JMXVzLX4ivPBxn595GMgByQJIDlEdZXXSF2S7ALTrU
	JHptu9ZF7NUkDECZu3CNhwCiqhPQ5uaLFCdeJ+LW3K3KbBWzI98UT10Qa5IBa7eHzr42gDuhCss
	/25lO+kNUpiGLreXUCKH9cc2p+Sfx5lE5xlKiyWI/HQ==
X-Google-Smtp-Source: AGHT+IEKUzmDLNm/S47AjUbVT0TSPyNRSLNS8NrJTl5hmJt7B7yIO3fgiAjEVvKH+pX/3t1gyQ5bcA==
X-Received: by 2002:a05:600c:256:b0:43c:ed33:a500 with SMTP id 5b1f17b1804b1-4563a5416ddmr95607725e9.10.1753102462803;
        Mon, 21 Jul 2025 05:54:22 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75de26sm98995225e9.33.2025.07.21.05.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:54:22 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 13:53:41 +0100
Subject: [PATCH v4 10/12] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v4-10-0a527410f8fd@linaro.org>
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

To pickup config4 changes.

Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 tools/include/uapi/linux/perf_event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/perf_event.h b/tools/include/uapi/linux/perf_event.h
index 78a362b80027..0d0ed85ad8cb 100644
--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -382,6 +382,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER6			120	/* Add: aux_sample_size */
 #define PERF_ATTR_SIZE_VER7			128	/* Add: sig_data */
 #define PERF_ATTR_SIZE_VER8			136	/* Add: config3 */
+#define PERF_ATTR_SIZE_VER9			144	/* add: config4 */
 
 /*
  * 'struct perf_event_attr' contains various attributes that define
@@ -543,6 +544,7 @@ struct perf_event_attr {
 	__u64	sig_data;
 
 	__u64	config3; /* extension of config2 */
+	__u64	config4; /* extension of config3 */
 };
 
 /*

-- 
2.34.1

