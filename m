Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66D4846A
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 15:55:32 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46-20020a9d0631000000b00666823da25fso2910857otn.0
        for <kvmarm@lists.linux.dev>; Fri, 04 Nov 2022 08:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rdANC8NrUTH0lQipJQx568c5Das7/Cs95kVjxC07YnA=;
        b=dIdBtE1reof0Paff6VKc8awbAh8baiGBvWXHedkf3f7vcAu4eh1wdCrGDsEEHgLueb
         rrRvUNl47GDNQiS25xoSIzSw669nP2s04Nli93cZ83jeOSuYmpqVqhx4kIfXLWuthJHs
         nfg1HvnQVTtC+RkBFLJjUhQovbQuoBiqX+/opDlh8yBcwD8KBvIvIjtIxNOzj3sPtKBr
         c65qfX4KAudcM2/rlPFSIZEy0yuQEqZQteQ6mkWBQYasKEiJFNjSi87UPsskVDxe0QiY
         jbZCHV0I3IYT3gH9WcHv57gMLF9Lmq5ML3pMMUHI9h6E8p3i50iln+gK5DZZTUKOlFWX
         rMwg==
X-Gm-Message-State: ACrzQf0/SR9jdPJTlO/VMCwkQVqMYcqIJKcx+4hyx0IhxRlrD9v6OZIU
	Yu1Tj90T6wErOvgrgxzhag==
X-Google-Smtp-Source: AMsMyM59dgaW5KOcOiwYnuILFe/BJR9IA6bPecpfclxA2KHdZ3Eq+UoizXI26yxdMDvL0GyieiOjSA==
X-Received: by 2002:a05:6830:1241:b0:66c:3bc2:f919 with SMTP id s1-20020a056830124100b0066c3bc2f919mr16838358otp.33.1667577331662;
        Fri, 04 Nov 2022 08:55:31 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l21-20020a05687040d500b0013d9bd4ad2esm1906311oal.12.2022.11.04.08.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:55:31 -0700 (PDT)
Received: (nullmailer pid 1880422 invoked by uid 1000);
	Fri, 04 Nov 2022 15:55:18 -0000
From: Rob Herring <robh@kernel.org>
Date: Fri, 04 Nov 2022 10:55:07 -0500
Subject: [PATCH v3 7/8] perf: Add perf_event_attr::config3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20220825-arm-spe-v8-7-v3-7-87682f78caac@kernel.org>
References: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, James Clark <james.clark@arm.com>, Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-Mailer: b4 0.11.0-dev
Message-ID: <20221104155507.5YhU5BFp_weS2QY3mJvIo-anIeEK4pkprMTEWYNmZUI@z>

Arm SPEv1.2 adds another 64-bits of event filtering control. As the
existing perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config3' field.

Tested-by: James Clark <james.clark@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v3:
 - No change
v2:
 - Drop tools/ side update
---
 include/uapi/linux/perf_event.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 85be78e0e7f6..b2b1d7b54097 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -374,6 +374,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER5	112	/* add: aux_watermark */
 #define PERF_ATTR_SIZE_VER6	120	/* add: aux_sample_size */
 #define PERF_ATTR_SIZE_VER7	128	/* add: sig_data */
+#define PERF_ATTR_SIZE_VER8	136	/* add: config3 */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -515,6 +516,8 @@ struct perf_event_attr {
 	 * truncated accordingly on 32 bit architectures.
 	 */
 	__u64	sig_data;
+
+	__u64	config3; /* extension of config2 */
 };
 
 /*

-- 
b4 0.11.0-dev
