Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF66B28FFFB
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 11:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518404; cv=none; b=Gg/3JcZ+LehkIPCEeeL4ctvTu8DTXplK305NA7tB/nwvoOIPmw50ibzfZKjPpSHVYAz5QMwqYWhSIHJ56bNl626AjpFgYYrDfUggAu8ZfccwwPp/kBTzZU7+okv9/rNtOBHKg2gPqJM2C+arekNSpiT68G0drdk/eMmouw7JrJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518404; c=relaxed/simple;
	bh=luGNkoeE8UlMJRKbxQ1WFt67Ydxa/TXTNRQ7E6/zPH8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KJXui71sd5ykeyIcipRgJRNAu8X1WTxAIIq2HRlUbgEtMLvul0RhXO2SLUlB1wncJG/6iq+J1/nKD84bpf489RTJf8fiYoc535DfxHguGPh8p06nJrk/J9hkLEegd1LoyH+H5UpUwgXfnDezMT3dPJqYUdw1FmLd/9x8y1PmCFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HIUYuZ4d; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HIUYuZ4d"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-450ce3a2dd5so6681565e9.3
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 04:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748518401; x=1749123201; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TtNy8TV2Q7tdQ7rYLolUVZZNcwM6dcUvbileCfs7vIE=;
        b=HIUYuZ4d1qF/IAtlozxX/8Bfj12ZeMrj3f0kN6EI5ooz8a3K6UKMxQmLaGL91rK2zQ
         vo/6F3O/Fn8WodoDIxiUDVbd+o8915tEcoffW0JvMXjnhdzJ6YkZmBZwLOe+fCbCrtRN
         2CMjhMXeEqRx5ZIswu2W4qzKcczHhaTsEV82FyaZ/RQLryzaQtNhTk4afOIbtCGYYqh3
         3peAvINowQBGAzfRe2W0m7v48LLFpq2Txb5C04Odo2NaKC8jMRuB+n8vkei3WpwFpmkc
         UcNiJ8AmrP98zYPhNBvNk5GdyGJToWcjOII0lI3VSL6Xxvkf84Tu2oK69AIwKAac7cJU
         8orw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748518401; x=1749123201;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtNy8TV2Q7tdQ7rYLolUVZZNcwM6dcUvbileCfs7vIE=;
        b=GySxgMVhKNxb0CRRr9XS9gEPjx5t3evj3cdMvWl9h0l8Cv68dHLPr3qLmrahdIPJQD
         iIQ0Z3CqxVvm8oftDL4z6Z0cOU70FKTca6kwGhMqwbaUb2R3aWjYDBU1OKBgn1GGAbs0
         J3S92jv5UaTnHrc1KXD1H+3mkN+X0WrTisA5+rHkkM9fqHli5hSEb0B6EcuZJflZCPKp
         MvUTN7sMGTlJZgRFZ6hGvBkMh7XQ4YPVb73kRdtqt+tnzxbmJPMO1+eMswMZSbASZ5rU
         GRAKqrX/YD7axn4BfLJ4ghfkW4RxaMb4RLCw2rikVayrVLHi6tWGKocI4fo22uaFoBgS
         MKHw==
X-Forwarded-Encrypted: i=1; AJvYcCXxal+1shkkDcAcNRZ/crVcYx6Hn7Yx1Rbzi8Pcw9h3383nzmEfaspG3FtoKV+U1cOoWrok0HM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzvL7lwYaGf2Oqi0U+CtkvGMYTyfzWD4NR40+JMGf5R1UxkSMZM
	00m/AZuHbtrOJQBKceBC1RXd6BnQgHyLFmVTWmvIqzy8El9X+vV5XP+p7d3tfkWIbFg=
X-Gm-Gg: ASbGncuX2bvq9y523SprV+VXHjR76vi7V/8EHYbEJKbj5ou2Pf0IKww/ckoAzxJ+nXL
	COpDSO1Qm7PQDx/kVAiCQWNkVhYTK/BYgmUAkGHXm/aZd9pqnpiw/TBrlJF545g6Bz2bPdLMvoO
	Yzc8xtKVIGw7gts2M74QSLnQBEtezTiPmfxeWHLDr+9hZA/Ivn9aBxL+ylYc315vYuhWvHPvYhS
	JnIJeiZmRy6qa8AoVYXvY7ulytuCS3QWKBaNViGhc1oI8lYE9cH8eukirCILzjPLcsBOyyPJkj3
	W9CvLoswKstGCtYHhYpcl8uhLAcCrF2vKySVnz6mrdy7I5ue3uVUmLCzgYP9
X-Google-Smtp-Source: AGHT+IHrXdHKaLMm+1yIpS3FqW954SUKKGaokrQq0Fw7uhbVyrwkEnNO9Y6DJeAGvxM0rmC8BWFyjw==
X-Received: by 2002:a05:600c:8411:b0:43c:fe15:41cb with SMTP id 5b1f17b1804b1-44c91fbb039mr231750785e9.15.1748518401174;
        Thu, 29 May 2025 04:33:21 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450cfc3785bsm17443945e9.40.2025.05.29.04.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 04:33:20 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 29 May 2025 12:30:30 +0100
Subject: [PATCH v2 09/11] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250529-james-perf-feat_spe_eft-v2-9-a01a9baad06a@linaro.org>
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

To pickup config4 changes.

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

