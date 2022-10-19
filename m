Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B995C53A3
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 19:11:29 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id n83so20327614oif.11
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 12:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nOSzjJQMiiQFtQCXOfHoj5W8uYrP30fMIHaTAT/kCc=;
        b=x6QRLwk9jSJZj15FMd4q+z6JBP8eBfQUZeWR5xdzv1m1qJHSN04VXTVYhuTYdZlwjT
         Lw9Yqee1H/+jP8RaEmiGUbTUSFxUnf0MzWNxpxvQaY1kdsfRnVL6pHBxya5+GdhEXrNs
         /KbIiRKbVAC5CtHeK+mPzJcI6CKZSn/qW+B2JENowd5ZGzYDWbbglozM/itSzE5WPovB
         TCb4lAIB8aFcF0djLVNY3EUECcRk0Nkk74QAl8wPMN7cn/LGRKnnvL8zkoz3Fq8TykoI
         ZCgNoMc5Nm+yVl6VY6SUDXvjvCsRr5bZPdKuXPTBSDQqq0ckGUrNMVI/eZtvDyRKwWZM
         gsLA==
X-Gm-Message-State: ACrzQf1L9sd+wmhTbtqIRjMraJ5gnb9TO576c8k7PKeGiVQTBBvetr2X
	LGazQAXsPM8n1lzrLp10yg==
X-Google-Smtp-Source: AMsMyM6hBFo6lc3QPPJZLi2rdtLDIwN0Hv6MsBsjwIii7y66xrRf5EteOTh2AxrGHMhQuml0B0j83w==
X-Received: by 2002:a05:6808:3090:b0:354:e8e2:6512 with SMTP id bl16-20020a056808309000b00354e8e26512mr18775295oib.118.1666206688760;
        Wed, 19 Oct 2022 12:11:28 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z9-20020a056870460900b0013191b00f72sm7878011oao.17.2022.10.19.12.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 12:11:28 -0700 (PDT)
Received: (nullmailer pid 3420908 invoked by uid 1000);
	Wed, 19 Oct 2022 19:11:25 -0000
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Oct 2022 14:11:29 -0500
Subject: [PATCH v2 6/7] perf: Add perf_event_attr::config3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20220825-arm-spe-v8-7-v2-6-e37322d68ac0@kernel.org>
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
In-Reply-To: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>, Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.11.0-dev
Message-ID: <20221019191129.RQAZ1N7bJfYSndEqcPI7MrnHK6qCyK995xhZ6XDHx40@z>

Arm SPEv1.2 adds another 64-bits of event filtering control. As the
existing perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config3' field.

Signed-off-by: Rob Herring <robh@kernel.org>
---
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
