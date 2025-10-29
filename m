Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9709733C520
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 15:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752803; cv=none; b=LUt1Tj2gRY4rwvBYSquSBRIZI/oF88BRcJQAL8TTRdwXttYwAecxlfS8/4oeC//xc/CCa1ACvBi0FvHAfxxLcM8uLhnoMjxY4CogHaVUflzfPRxmytiQSDek6H4qcPv9AA42KMXzt78CmxSs3P13BQ2CAeS//Un+/e01+3BqH6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752803; c=relaxed/simple;
	bh=3yjrpHkX+aMdTK90nxuOJyMh4ajXQ8n+rTYB1GAa/ak=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CLH2jLs/YvEzSs/uYQHgLooZ9IIwFP6izeB4FXLZ8pDVq7/Derd7/QDzhX8Ki+8OScZAT5J//bhQJ26nt/ES3T8Vai3jdWCGz2RDzr5PJybVOIGpzpk/F2v3Ry3pNK2xS8uMa56MZkFQ0S0kMJPYgg+PhG8f0JrWUo5hRxxQPXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vgPrmW6h; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vgPrmW6h"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-475dbc3c9efso35102925e9.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 08:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761752800; x=1762357600; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=vgPrmW6hzY1keVDRyfGNlGzFrJuIUtm0/EZc2gOI4k9dPnXOjQnPcAYjpzom7voxB/
         guBzBRV2vcDJEzuICYvtrpLFgZ8ZvrcMPVhgW3ORqY32y9dfyBkSVP/6fleCaVGdyIVy
         tDCFpPrdmFM2QhWQfqOgzAAOhUnCUXl5myl6FNwFX5pPMuykz3gQKqpeM01WLp7pHn70
         V1F7+DkZsxkbFEj0LqkNzEH4W04Vm8PVNIPXkvjWAZ09fwUb3ObzQCELOcY5823Qgg2u
         +5vMLgvJX4FH9sP/bVZrMXU23xR+ECjS35LilUauTi9g69ABcvPZu34LYrnDRrJBqMxr
         WMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761752800; x=1762357600;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=bG0z7o1eRgia/+SgoRnBzyzeR0iRGauAIT7AMnXazpAf+0f9OSSdvtyHjiSVPR7TAQ
         GH5XmXkLHIOdX0UbUDLUPez8IE0bzG0bvpjbXeEdUoj7KhrxuCwFdK3sU8VQw2t/nF3h
         UACeLTqXdZlvi6bwNYP8YcQtkt4pOdhW9STIgzogpgPs5oFInqjrMRLqcOH3lT1a5Fs1
         z1FJEPkaKay/a4ZK5IbYF7flGSotmzfLORf2YwH0kCyvLhLjS2wQyFYhwclUyYRONOFX
         qznpsdeVgMwDTVESA+4tjvZf6ZjHCyNo9Lw9eDnVklLA88zWQqEH/AkNbgidL4OMVMaB
         feZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAxVWGTFlziF9alYueiq41pz27LhDqy2SSqhoDpzxXC172LPk/Ryd/Yby99VglVDNM/EvLYo4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRlVqBE7TOjNjImRW7avACyJpK7kvN1Jo0kZKAFViUiva+/Osn
	IC+GQxZdA3FphJzthJ9c0oo6HodXKXDfHZd2fTZmLiT3tP+om74eMtlDJWsd/kL+3Fc=
X-Gm-Gg: ASbGnctaEHbOIy2juIb/W/XRS6fK3jCJAITf9dFdkJ8tWONWPsB4xFJEbb8zd7qSI4r
	5i+e/PKnlubDNaSSmXJuEY9V2/Y8MgEq/RDqUpr39ZRhlFbDQA+dNkDu+h5qxyJLyKl+XuDIN0h
	7gVVKgWmk6wI7GlOby9RUHpZXN+/bkR0DBzEtJ2KoOTOtRfoFfkMImwI3TuoY8FHIe4ymR+0LkT
	KkaTbrAm1piK+BO+lu+1iVSZvOlcuoDGW7Gkly/Ohur/e+SxHLY6/QlvIhg2DRJ8d1RHzazLiz6
	GH0WUnCs8vEtd97qg/l4Wh2qQmRDneKnVgaG5s4jX5Y17w+BQTiDbiaAb2c/8NLlt95stAV8Xa4
	rjlXy0dc81zHQVCUorN58DQ61QHm6Xw57GaOy5zUntRvibuvVCzFo2XxZgTSnUVHyVWKe0JMMeD
	2aqqmF3JkuQg==
X-Google-Smtp-Source: AGHT+IFr7xoJyrWL0httFE1U9OU6ySb/0qu1huluXCe0kPZLPOso65sDtiDjLwsED64lDMpKMdKhUQ==
X-Received: by 2002:a05:600c:8484:b0:46e:442c:f5e1 with SMTP id 5b1f17b1804b1-4771e24b0a5mr30445885e9.35.1761752799881;
        Wed, 29 Oct 2025 08:46:39 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e3b9994sm53745535e9.16.2025.10.29.08.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:46:39 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Wed, 29 Oct 2025 15:46:01 +0000
Subject: [PATCH v9 1/5] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-james-perf-feat_spe_eft-v9-1-d22536b9cf94@linaro.org>
References: <20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org>
In-Reply-To: <20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org>
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

Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
packet using another 64-bits of event filtering control. As the existing
perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config4' field.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
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

