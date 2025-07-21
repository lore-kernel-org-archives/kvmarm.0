Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212422DCC04
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103130; cv=none; b=Kz3iNxNypv2Vgwf3gBtK10nAqNevnggKZYa1EH8ralYHXGTZzlJgmwqLAJaSWPLqdWD236yKAERJ0JVoNGV8Mn6FClUQ0W6zbuiDkkh57Zr1+UPCSlWKIDDT51s4L7eFFicJlE3M/a4YBn7UPLHnTupCPD0jkApI6+3V1f1Pnk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103130; c=relaxed/simple;
	bh=aRUWGynzXd2I0iPJ8E252lMe7rGfIx7dGynoHirUSWM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UXh5ykXGv5sF2MENduWi7VU7UPybp3tpLPgu6LZzWzdi2efE8Pkvex+KWUiVaMwsFK4cE1Vp3gYQXN+U8Pk9XY45SDiy8uh4640Zd1bRQfuaWV5ESymsjyOwNG+PwC1SDjwvc6FWH5/jmdfIJBrbN+m/IzfMRNrNj5Pcm+Tt+Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vatWv8hu; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vatWv8hu"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a4fd1ba177so2760458f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103126; x=1753707926; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJMmlptoopG7uLnpNHx3BFeWdRFU3hEImM+p7yUrZvk=;
        b=vatWv8hufgZSjGurMHtBbqtkScRMpMm2qjC8WQe5EJa4h5ZpqayJ0l0WvsqEmFNDGL
         LPUYcTz4686QMljjQaJ3pfD6coVC52qP5MdVgvH2DS08zzxSh5cBd9JkinH9XJY7v85j
         zPPfNCFxAjUxvXlzucDaBEV/MAXTIP8ctAXScDj81Rdq9flQoxCBIuntu64cRxxjJFBX
         A0sMUPyALghOFgafMtg04iNgrhg5VmEb/PwwkvlYOzLgkZf3vLj5HsUi+7Ik9g2HlWfM
         MoM3hH09KQCLnOu/JCl4oSPvjhowHB/HFmEG3ruSKppkNzrhHEaXPmutpjm0eAGiJFRT
         aXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103126; x=1753707926;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJMmlptoopG7uLnpNHx3BFeWdRFU3hEImM+p7yUrZvk=;
        b=HOHnfAykI5GQhlmMqBmwQAWBGoJ6L6kH50uMlpO4HZlFxCvf2hyj4xKmJGejYmJ8uQ
         HSanPG9QtweaZjpsdEGBYjvFSMhShJ4p34T9uueWXVF4qIIaXwxL386Tak7q8nBEvLnB
         e8H0yt6k/rVSyH0cFD5PLBoyrIMCOvQD4CGmJpCzR6ZGhOGddS2yOTe5WtHBXUd3XPph
         JiHXpRQDHcZRlAKS8GD55PvhWLVysgthHHkJOIAjC/lwouyjBwTwbz+46FGHdWBi2l/h
         vhhiCa0LvEvYnK0wTFvERk3LbGWcQnfNaLM7bNyLcwNXwvOLc8Er0wdZwg1XdWSBcUl7
         Z9XQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOZBKUp1nC9eX4Tj2vOroqIG+LvML/7VfYZnm6ErJXHvhy5LKp8evd+dUx7NdaoO02uYVdTXE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1A3T1g7fdGfiGzFAhegwPsUFfiGBSsbHHLiG9R8POvNJFqYsh
	Hk9kmH2Cltp9UpW2BUAsxjTrGByufY9m2QqAORhS5jQpxfF3J1ZmmM8P/r53slCL9fg=
X-Gm-Gg: ASbGnctv5/VZn+SsI/oWqSUePirzuw12RwNHO3Ze+rjCRetX29XXB96fkZYv4n+cr2i
	OO5ObJxCp4Ag+SHWQXcyWFrs3DAtBr2AIYoEq0iWf7+MAApzK3UXNPkfs/IGpbXp88UFYa/Z0+4
	lTaf2xEsJZa0U00DAnvX3I0xkaz3YZwtPOuwIVlcWUA0Pt+LOtU2KIwGnksbMdahGzXR31r9U1e
	DXQHmqoT+rrbe+3QcMyFnAUIgTA+QksJq7fjVkynWAyV7TkK2LJloRf2ULesXpLnWIUX3jC/5o8
	Vi/K7I0ibPVr4RqDUDxc0P0j1zMzSj4/Lg32pHKmE94XHLUEa/ZIc3zoSndsoD4hhv4k1gMSKwh
	vYqGBWokl2HmMg1mUMbzW9XMGVk8DQjk=
X-Google-Smtp-Source: AGHT+IEQRxB7CE+HdieDcueXWljG81gay0nli7hyPKWhyc70neAo7UklcQhq3PGP9NmaS8BVDvp06g==
X-Received: by 2002:a5d:64c4:0:b0:3a4:e231:8632 with SMTP id ffacd0b85a97d-3b613abe2c2mr14295215f8f.12.1753103126134;
        Mon, 21 Jul 2025 06:05:26 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:25 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:05:06 +0100
Subject: [PATCH v5 12/12] perf docs: arm-spe: Document new SPE filtering
 features
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-12-a7bc533485a1@linaro.org>
References: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
In-Reply-To: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
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

FEAT_SPE_EFT and FEAT_SPE_FDS etc have new user facing format attributes
so document them. Also document existing 'event_filter' bits that were
missing from the doc and the fact that latency values are stored in the
weight field.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 tools/perf/Documentation/perf-arm-spe.txt | 104 +++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-arm-spe.txt b/tools/perf/Documentation/perf-arm-spe.txt
index 37afade4f1b2..c7d1032ff219 100644
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
 
@@ -247,6 +314,25 @@ to minimize output. Then run perf stat:
   perf record -e arm_spe/discard/ -a -N -B --no-bpf-event -o - > /dev/null &
   perf stat -e SAMPLE_FEED_LD
 
+Data source filtering
+~~~~~~~~~~~~~~~~~~~~~
+
+When FEAT_SPE_FDS is present, 'inv_data_src_filter' can be used as a mask to
+filter on a subset (0 - 63) of possible data source IDs. The full range of data
+sources is 0 - 65535 although these are unlikely to be used in practice. Data
+sources are IMPDEF so refer to the TRM for the mappings. Each bit N of the
+filter maps to data source N. The filter is an OR of all the bits, and the value
+provided inv_data_src_filter is inverted before writing to PMSDSFR_EL1 so that
+set bits exclude that data source and cleared bits include that data source.
+Therefore the default value of 0 is equivalent to no filtering (all data sources
+included).
+
+For example, to include only data sources 0 and 3, clear bits 0 and 3
+(0xFFFFFFFFFFFFFFF6)
+
+When 'inv_data_src_filter' is set to 0xFFFFFFFFFFFFFFFF, any samples with any
+data source set are excluded.
+
 SEE ALSO
 --------
 

-- 
2.34.1

