Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2028228FA8F
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518402; cv=none; b=ByriGeX6bJTE3n/zfRHXdg3M580c2f1BfkjQvgE+K1zCpY2a8lWEJ3f2wo4K4DQFCfWmfneT/pyzJV/lgyPRIYrdxf8o1FAeqMgEgGqMYVPnzydPjQZMeCJko6wZicSXS9mzB+xTIoL4K5/2W9TMR8IgM1pVp1OPTWAnPg2iyrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518402; c=relaxed/simple;
	bh=zvP1e+1MWcLi6dFHbap1BiJEf/Gwy+p9o8HThmnNJIg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fACNnXH3/JMiUWh8xAw6R8b40kBNMLWrdXo50dO82b6U9wk5SZJa3REZ1bR54fzy/J7Pp/jPZIztj357EwSw89yQ+s/5qa1OcVmiqB+8W/eVq1HzSFFGuxc/BtpfBOvErdwQy6BCMcJGPyJLIFBA/u0SGbMHgQ5OO+Xt/VJNEk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WfyUcCiR; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WfyUcCiR"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-450d37d4699so1640365e9.0
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518398; x=1749123198; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Q5mn8xtPi9u9sDm1H7ybxkZxNw4efqIccO1SNVExHM=;
        b=WfyUcCiRVAVueBS75UICT76latInfiiiceUeWNgphNVUlHYYPjYZdi4S98eZo9htW8
         8j9y+PfDQIoVe7OsjXGGX4CXgNX17r15WWEEzermNj80w/e27y/mEWsPdnl01t5382Ep
         XgyNEOnzcRlWlNRM8WuVlxOJ+vFuYCxz59llk3HSaBW+Q6AOylJzEY2K+PyLwWCPiDMv
         QX7d5dWIiJq1D8EsgJjg+MWI1Tom+5V+jRlyZELXZgniiYZmEPEZfaslIrLfdTeova9M
         +1Jfet0flPg8btpqzKktFYiY5cIMrUYHXxKTmV6orAX+UT7QPHvsrSzJGtqUrVoTQ46w
         AQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518398; x=1749123198;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Q5mn8xtPi9u9sDm1H7ybxkZxNw4efqIccO1SNVExHM=;
        b=g/7X0JNxDKEev+5h5ulIZSQZHpiK68D4c1mJ2erUdswm4F6KgCAc0aQnpm1Ft20tY7
         KSgi0Bj6dWwSPs8+1fA1/CAtXc4yxpHu5X0gvcLEpRGDYDTqq0+GAOYbN4W1OV2AO7nI
         W4wFee82WHVrjOYojzSJUJhh56vEE596IhMNOiQM+4m6nrTSilGqge/rXbFfiNGKFWS3
         2ltWSUwEmvRRFj4N0dUbuKm0uqEumhYdwBm9FoddrpLtEFwnAqiSkXh6r92vTY486vQz
         4pJD5cTKYO3teG3GDSw2dfGa2ne7XERFwddj/dAUqEFMSi7zSNvJheq2N5LKXcpgLVsu
         pKJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzu1ZGaWsP0CoRsSvkIiau0vcHGejH/r8uZdGDnttgDR5us6AhpIDAaHFnIguUg2FGnXPkadg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzScLBsxYiczh9jykUNXux61RNQCfNhcVE3KjxsU95Gr7CvjKpq
	PUwYqs/qmfPZJt3OIEf23rfLyC6BcRB3lX/3rvtlGnNHpwti70nW/jdfzYvBFOqr7J8=
X-Gm-Gg: ASbGncvfAiuw/675dh6z94ja2G6oYzcAi3e9JkE0r0o5tt23AcUlnYxD+HCxq2FOh9z
	C4hu6xiom7d9NiAqueFrS6+OG/OctE7OZnpFyI37F0xRsWu4uIwSuKTdVB7omOPmJloTwFRpt24
	cAfo5Z1L5mJBzZeO+B+AtAoihjrTznoV3OOoEIXdn8BDkiRjmMs+ewVHXwURUKnE39UZ0Dxbs1r
	vuWeZ96L+C3h8m8Rtstf7QwE1onB6hzrRdf1tdjP/Aa+H7PDTNfMuH+YHmbKe8ZkqCKnWeyDkbm
	VLRbbmufLAf5iEN8Mwq/PNHY1H4Co3Px1DfLz9hwOTeqkvhQQVQiDrDyKDIlHlq39wcgiuw=
X-Google-Smtp-Source: AGHT+IFacLMgy8Sgufz8crND9drSgOY6qRlCAWckmK5shHNZ9zSnAptuNxdT/H2WMCBvDy1/kfCobg==
X-Received: by 2002:a05:600c:1d8c:b0:43c:e478:889 with SMTP id 5b1f17b1804b1-4506b541d07mr59510265e9.0.1748518398270;
        Thu, 29 May 2025 04:33:18 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:17 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 29 May 2025 12:30:28 +0100
Subject: [PATCH v2 07/11] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250529-james-perf-feat_spe_eft-v2-7-a01a9baad06a@linaro.org>
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
 kvmarm@lists.linux.dev, Leo Yan <leo.yan@arm.com>, 
 James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
packet using another 64-bits of event filtering control. As the existing
perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config4' field.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 include/uapi/linux/perf_event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 78a362b80027..0d0ed85ad8cb 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
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

