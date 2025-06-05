Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3E7255F26
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120622; cv=none; b=fjKrkXleUIE69fsLHBYkc0f6nswpmv/6JRLoEQtok6fGze/Bb1d5XDiQtrEkVsKrUeqnp/RjMag6d/9e+eDAfeSIrJY73CH4DgkwLfV1WhGbBbr5mZAW++PfXsxjq8PFUHnH+kwcKl2PfuzGIziPKbLGMDhJAggaAd0VOxQSKHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120622; c=relaxed/simple;
	bh=MMFbkI7zMPzBdRBdPQfb7pTJMjgrsMrJkf8SuH2PcGg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mkMo8EBNKEh9Kh5xPX9x0xfwtA6gXN71jLU8COXf4HGOQ5mWvTDMbL7KV8sYH1G0i1zYaJn9GqqoWCNUsPje6woc5bhJtofAP5+Az44xDgsvqs0Vv6yhG9oiQTED1Amxj/RdhG2mj+gHDYY94zFVbZpOKKEC/MHOBFgZFTjQ6cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CahSg8nh; arc=none smtp.client-ip=209.85.128.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CahSg8nh"
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-450ce671a08so4984765e9.3
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749120618; x=1749725418; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TYtpnIAkK3WcCc9sKEGdtsuC5KifjqgSXfNa01d683g=;
        b=CahSg8nhmzFwznSO4wcLU3sOg9lJSXUyBO/MeFJ56V9NckkqWgjhEbJn9UuRJLqgYO
         152wm+vgK18bgkfmQ3+t1cBwhjLk5shVVC9DzBQgt90Rgcb+KbX7Ar8v0tRLXthbQM9a
         Z3Jqtv2MoyfsBMuCruuFyPWMNyAIsD4b9chnMfMMClc21qTWzu89fjCc6i5OwVQYGi9b
         r5fNCEiVhaybVJGEeLUmuvHW31krFXcgDFVRa4M8kU0/xnqszCjYmM/ezcEBa3MJ91E5
         +u+vmCWmZLfwObFmFalUukSy/n597DoD7vu8+ZdUzTPXEaulHLcJ61avdmdsu/NMcbeT
         nPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749120618; x=1749725418;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TYtpnIAkK3WcCc9sKEGdtsuC5KifjqgSXfNa01d683g=;
        b=cS9SMOXM/ToLT0dN5Y4rZAaWVGM7KAde1Fi8rVw+bip2U3HAuQgCFVBPSfo+bcGRcC
         wSMoluDZiPQHXPf6w/fTiXd0wZxXlP1R9HOEJmBEEQhE6oKNhpHdiHe57ufJ6AKowRik
         GhCBwCFJL5bjOFwITgmwALHXFUZfR0Y+rRtHT2eARki2F8uZodyHyY+OFZvEOT1MB9B2
         MwU9eWL5beZaZzvifZdIm5gaOMIXN/YSW+UkzdyPoqLk25iuP0j3eVZvYwcdZgUZtMwZ
         YZh8MV2Rb6/Kqp4rZxw2c2MOd3xzjykgpp/hph4XSh/yC73l46SLovu/3/+qkF7iV0ku
         Y1uQ==
X-Forwarded-Encrypted: i=1; AJvYcCWj37W5oOAGzdSAKJL6cgbcNONeJSCZX4Cro6vHN5X7nwjr0UNmFPKbb0B07tuhCkUJvxDdkp4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJlTcYDA6tLefAQ1fmVmf23NsmgxhO/wy4NlavQLPm9iXL0FCl
	lnd5dzb6lXWaWWeXhb41uLV9xiky2p4uradS3aA5jDegpVCOepzx/PRnAnxmyr1MoLI=
X-Gm-Gg: ASbGncvrWu6mm/OcdH918Du+fevSo3gF+YWOA1yDHwbAFWTC90+BmCaqX87E2ks/F3/
	Ez21iQe4gOtOLED4Ya4dp97zM70OzHQ5fv0e46DPrJ7zQNtpvyqvBKUKvRfqDiSfSdtDSTJiN7T
	IaqGndVk6RJ0tDQ6ETm2L9O/9qBfyt+hJ4hA9AOd0X1NOGkp6j9X7wHtPsK7xcf30LJ6OFngj8f
	WEsQDuPpskBSu3FPg8fAAmey4WxWZFe5PPdFltYaUHAsqEaulzLJY7EOanble5aDTGcx6HzqQha
	XfV96napEGaPpIzvZfbD4/bbQcZM/WNtWuuS4obswp6ITOSUyYnM3/ZbRu22
X-Google-Smtp-Source: AGHT+IF209QtdWKQIFSgWNU834ITMWh9f6gxkjT2rjm5O4GQe4Nyl3IJTR6vikF94ywt0/mEA5L8wg==
X-Received: by 2002:a05:600c:548d:b0:43c:f597:d589 with SMTP id 5b1f17b1804b1-451f0b20d15mr54093555e9.27.1749120617749;
        Thu, 05 Jun 2025 03:50:17 -0700 (PDT)
Received: from ho-tower-lan.lan ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f990cfe3sm20629965e9.23.2025.06.05.03.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:50:16 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 05 Jun 2025 11:49:08 +0100
Subject: [PATCH v3 10/10] perf docs: arm-spe: Document new SPE filtering
 features
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250605-james-perf-feat_spe_eft-v3-10-71b0c9f98093@linaro.org>
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

FEAT_SPE_EFT and FEAT_SPE_FDS etc have new user facing format attributes
so document them. Also document existing 'event_filter' bits that were
missing from the doc and the fact that latency values are stored in the
weight field.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 tools/perf/Documentation/perf-arm-spe.txt | 97 ++++++++++++++++++++++++++++---
 1 file changed, 88 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-arm-spe.txt b/tools/perf/Documentation/perf-arm-spe.txt
index 37afade4f1b2..4092b53b58d2 100644
--- a/tools/perf/Documentation/perf-arm-spe.txt
+++ b/tools/perf/Documentation/perf-arm-spe.txt
@@ -141,27 +141,65 @@ Config parameters
 These are placed between the // in the event and comma separated. For example '-e
 arm_spe/load_filter=1,min_latency=10/'
 
-  branch_filter=1     - collect branches only (PMSFCR.B)
-  event_filter=<mask> - filter on specific events (PMSEVFR) - see bitfield description below
+  event_filter=<mask> - logical AND filter on specific events (PMSEVFR) - see bitfield description below
+  inv_event_filter=<mask> - logical OR to filter out specific events (PMSNEVFR, FEAT_SPEv1p2) - see bitfield description below
   jitter=1            - use jitter to avoid resonance when sampling (PMSIRR.RND)
-  load_filter=1       - collect loads only (PMSFCR.LD)
   min_latency=<n>     - collect only samples with this latency or higher* (PMSLATFR)
   pa_enable=1         - collect physical address (as well as VA) of loads/stores (PMSCR.PA) - requires privilege
   pct_enable=1        - collect physical timestamp instead of virtual timestamp (PMSCR.PCT) - requires privilege
-  store_filter=1      - collect stores only (PMSFCR.ST)
   ts_enable=1         - enable timestamping with value of generic timer (PMSCR.TS)
   discard=1           - enable SPE PMU events but don't collect sample data - see 'Discard mode' (PMBLIMITR.FM = DISCARD)
+  data_src_filter=<mask> - mask to filter from 0-63 possible data sources (PMSDSFR, FEAT_SPE_FDS) - See 'Data source filtering'
 
 +++*+++ Latency is the total latency from the point at which sampling started on that instruction, rather
 than only the execution latency.
 
-Only some events can be filtered on; these include:
-
-  bit 1     - instruction retired (i.e. omit speculative instructions)
+Only some events can be filtered on using 'event_filter' bits. The overall
+filter is the logical AND of these bits, for example if bits 3 and 5 are set
+only samples that have both 'L1D cache refill' AND 'TLB walk' are recorded. When
+FEAT_SPEv1p2 is implemented 'inv_event_filter' can also be used to exclude
+events that have any (OR) of the filter's bits set. For example setting bits 3
+and 5 in 'inv_event_filter' will exclude any events that are either L1D cache
+refill OR TLB walk. If the same bit is set in both filters it's UNPREDICTABLE
+whether the sample is included or excluded. Filter bits for both event_filter
+and inv_event_filter are:
+
+  bit 1     - Instruction retired (i.e. omit speculative instructions)
+  bit 2     - L1D access (FEAT_SPEv1p4)
   bit 3     - L1D refill
+  bit 4     - TLB access (FEAT_SPEv1p4)
   bit 5     - TLB refill
-  bit 7     - mispredict
-  bit 11    - misaligned access
+  bit 6     - Not taken event (FEAT_SPEv1p2)
+  bit 7     - Mispredict
+  bit 8     - Last level cache access (FEAT_SPEv1p4)
+  bit 9     - Last level cache miss (FEAT_SPEv1p4)
+  bit 10    - Remote access (FEAT_SPEv1p4)
+  bit 11    - Misaligned access (FEAT_SPEv1p1)
+  bit 12-15 - IMPLEMENTATION DEFINED events (when implemented)
+  bit 16    - Transaction (FEAT_TME)
+  bit 17    - Partial or empty SME or SVE predicate (FEAT_SPEv1p1)
+  bit 18    - Empty SME or SVE predicate (FEAT_SPEv1p1)
+  bit 19    - L2D access (FEAT_SPEv1p4)
+  bit 20    - L2D miss (FEAT_SPEv1p4)
+  bit 21    - Cache data modified (FEAT_SPEv1p4)
+  bit 22    - Recently fetched (FEAT_SPEv1p4)
+  bit 23    - Data snooped (FEAT_SPEv1p4)
+  bit 24    - Streaming SVE mode event (when FEAT_SPE_SME is implemented), or
+              IMPLEMENTATION DEFINED event 24 (when implemented, only versions
+              less than FEAT_SPEv1p4)
+  bit 25    - SMCU or external coprocessor operation event when FEAT_SPE_SME is
+              implemented, or IMPLEMENTATION DEFINED event 25 (when implemented,
+              only versions less than FEAT_SPEv1p4)
+  bit 26-31 - IMPLEMENTATION DEFINED events (only versions less than FEAT_SPEv1p4)
+  bit 48-63 - IMPLEMENTATION DEFINED events (when implemented)
+
+For IMPLEMENTATION DEFINED bits, refer to the CPU TRM if these bits are
+implemented.
+
+The driver will reject events if requested filter bits require unimplemented SPE
+versions, but will not reject filter bits for unimplemented IMPDEF bits or when
+their related feature is not present (e.g. SME). For example, if FEAT_SPEv1p2 is
+not implemented, filtering on "Not taken event" (bit 6) will be rejected.
 
 So to sample just retired instructions:
 
@@ -171,6 +209,31 @@ or just mispredicted branches:
 
   perf record -e arm_spe/event_filter=0x80/ -- ./mybench
 
+When set, the following filters can be used to select samples that match any of
+the operation types (OR filtering). If only one is set then only samples of that
+type are collected:
+
+  branch_filter=1     - Collect branches (PMSFCR.B)
+  load_filter=1       - Collect loads (PMSFCR.LD)
+  store_filter=1      - Collect stores (PMSFCR.ST)
+
+When extended filtering is supported (FEAT_SPE_EFT), SIMD and float
+pointer operations can also be selected:
+
+  simd_filter=1         - Collect SIMD loads, stores and operations (PMSFCR.SIMD)
+  float_filter=1        - Collect floating point loads, stores and operations (PMSFCR.FP)
+
+When extended filtering is supported (FEAT_SPE_EFT), operation type filters can
+be changed to AND using _mask fields. For example samples could be selected if
+they are store AND SIMD by setting 'store_filter=1,simd_filter=1,
+store_filter_mask=1,simd_filter_mask=1'. The new masks are as follows:
+
+  branch_filter_mask=1  - Change branch filter behavior from OR to AND (PMSFCR.Bm)
+  load_filter_mask=1    - Change load filter behavior from OR to AND (PMSFCR.LDm)
+  store_filter_mask=1   - Change store filter behavior from OR to AND (PMSFCR.STm)
+  simd_filter_mask=1    - Change SIMD filter behavior from OR to AND (PMSFCR.SIMDm)
+  float_filter_mask=1   - Change floating point filter behavior from OR to AND (PMSFCR.FPm)
+
 Viewing the data
 ~~~~~~~~~~~~~~~~~
 
@@ -204,6 +267,10 @@ Memory access details are also stored on the samples and this can be viewed with
 
   perf report --mem-mode
 
+The latency value from the SPE sample is stored in the 'weight' field of the
+Perf samples and can be displayed in Perf script and report outputs by enabling
+its display from the command line.
+
 Common errors
 ~~~~~~~~~~~~~
 
@@ -247,6 +314,18 @@ to minimize output. Then run perf stat:
   perf record -e arm_spe/discard/ -a -N -B --no-bpf-event -o - > /dev/null &
   perf stat -e SAMPLE_FEED_LD
 
+Data source filtering
+~~~~~~~~~~~~~~~~~~~~~
+
+When FEAT_SPE_FDS is present, 'data_src_filter' can be used as a mask to filter
+on a subset (0 - 63) of possible data source IDs. The full range of data sources
+is 0 - 65535 although these are unlikely to be used in practice. Data sources
+are IMPDEF so refer to the TRM for the mappings. Each bit N of the filter maps
+to data source N. The filter is an OR of all the bits, so for example setting
+bits 0 and 3 includes only packets from data sources 0 OR 3. When
+'data_src_filter' is set to 0 data source filtering is disabled and all data
+sources are included.
+
 SEE ALSO
 --------
 

-- 
2.34.1

