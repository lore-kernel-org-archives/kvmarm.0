Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E2248873
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120614; cv=none; b=d4sc4Ca1lFw5Wi+em9/0ZQuAcHA5Z4kyFQhhfAu4PNe35meY14TNSWn8Ys8Lvtdc6rv1eAdj/68rT0OU7kflglQTG4aGawtsnKivjnW+T6TI4Qg8J03iXHKwENc1Wg+70pclVaPyInEo9wK9IHld6trVnGnP72RxoxLv1hbuIFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120614; c=relaxed/simple;
	bh=luIKfiwgtXeAFEj50ve3W9I2lyEw3hMNW0iXhyMCu40=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IcV1Tdud+WoFRpb2eVTLqPsiEtcmfWCkjVOyaFeNOCo7yViMkpQD0mqzhMZfv51i8F820mc5eNM4Y/WWUtybpYolBhRBFdxp+hDwKDpkMZyQ8dmhaOIpqdFTDAt5Ezc1/P377maA5gx3CW2JfpKj974FdebVEluRe3wFaT1BQMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eKPyK1eN; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eKPyK1eN"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a36efcadb8so685155f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120611; x=1749725411; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j9Rue6bPIg/trhgv/sEGIp6PJe+iLR+ZUbz2D5vC1ck=;
        b=eKPyK1eNmoiNWk916wzfgYBh0FaZwCmGSDO86WCofJCNjgSarI3Myso+M+mZjoeiw3
         J3G7QqcWYto88u8XY7W6mYHIp8deToTL4hT9Rx/3shzpIdF6azwxVsdmu3Cnai8vOzXs
         ZJivcoGKNoXVe3Ha/T9HF9L8QqUX8/pSI/yqdaWv3PoGQJ4WNvocB1n0FkWw3E93p81b
         Ticq+mBGg7aUMJ0aZpstdfFmhSx5X76KyQyVZjPqF/zIqtb/fEx5fGf6+/f/6g6rlA+A
         4RY15JURTPy1E0N9GAIv4xavtwqNQpU9cwmuqUleFkN0aXGh5b9csIwi95SguBJo6aqQ
         +v9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120611; x=1749725411;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9Rue6bPIg/trhgv/sEGIp6PJe+iLR+ZUbz2D5vC1ck=;
        b=XS7st1Y9UbrjJg2k9pbEOx95dKAe4l32MJaSKM65P7PZLHEvyzR8YV2PVaBEn+E5Ws
         MbSadJXblwwRjOH1NBWy+DZt+Hy3zXtuqIKgHqfe6RsN5oUlMJugznOwRFDoSTNvAWVK
         a+4WsAKaWP0tXVgf5jlpYuldli8Rr+x1uh7x+dtveba2loFzKQ425aAoiR6yNcNSARBg
         BkQTt1l1ql7PEBUoU3lZ0tO0aceX4yYusaW8pNgZFAxsyQ6a+S05cH2vuzjX6fhE1H+k
         iQz/MPUmL09oAHN+cx+lstaA64MIIXnbgBpJkddySNqrWT5sNM967jI/oP9biO8YIwI6
         ONyQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0yftjTWGV/xZDrkARpjEfRZE8wQIBbNr0pCldyrdPgkw9amSM1mC49U2q1MvcGb4S4m0dxRs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8AIuVok9QFlWjhXhI/k98r0Dw8IWpaaCekW6HvxF9HGrU894e
	cgergjKYjaW9HpddpGMXBt7wzCP+wlaswazZdOGg120I4FLGeG+iYEtf6guL7Dvpxx4=
X-Gm-Gg: ASbGncvD6d3U/hBC0rZEhU/vZywA6gkRdc+RgwoS2t+uHkA8DMpVGICNc9IbZ1N3kyD
	SY8s7MXQ5Gz4S7X7r0PfHrG3v9B1CwnlO27ma0w+N/tsNPDIae7lYleWe2sdbgdFxMinSvWspMW
	afz2srYbvcfB9p7VyEKydSP7i0WvBBo9V9RUWYYY0bLFMxvLKEZ2fHmBbJG16SW47rn2wPLhRze
	qhznzzjLFNe5tIqHptyiSlF4AghJ0r+dj65bVUh79u79zSTsAT6/pCOWcJKqv8P7+TKohZVivze
	Is0drpo5591uebP+BryAJ2I8MwseyjbCGgjXB2Lhh1NEy6ss8IWaKvJG6KpM
X-Google-Smtp-Source: AGHT+IGgu16RRFx+Y09hUhjKjxwfPfRayhA9cKQUsDuzGVsP3y8rnAFwlUH2ULqYWuFyxL3gPk8m4w==
X-Received: by 2002:a05:6000:2389:b0:3a4:deb9:8964 with SMTP id ffacd0b85a97d-3a51d91f899mr5503049f8f.17.1749120610702;
        Thu, 05 Jun 2025 03:50:10 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:10 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:49:04 +0100
Subject: [PATCH v3 06/10] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-6-71b0c9f98093@linaro.org>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
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
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
packet using another 64-bits of event filtering control. As the existing
perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config4' field.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
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

