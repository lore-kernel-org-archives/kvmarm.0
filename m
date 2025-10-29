Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34775346A02
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752809; cv=none; b=nWT0a49xlh9OfhuYmvXDYJnteu+sqSe0wCpf58WMef5n3SmaOLJX/a9vndinjcBlx0mtOJ+P8oeqeFdSHTMNKzP+BgL4VlkkoubudHoFgCYNV+yqO3u58AJUiZjuravhvRE6AeZ3NI9HUCNySNamUN+19J/iTgNsd2PSRQuFAX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752809; c=relaxed/simple;
	bh=XbEjcHmbW1FtIDWd/0bx9+CvqyNH7zPE+8zx4p7Hy7k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QCnefUVmVCa/GmUJsOMMbBEn/D+9Gy41MsKjO8m7hCWE5SO2i1y7zU+/ioxDGYsXQ5UnLBw7CC8bkvsVsTrW27Gb+Hkx0WrAwXVlVIBSUiudXq+GuidE5rvsUdi7lOtJFqmLbasgiWAPU6XhWdwWzuuFvv7UcprNUEkiEkbkfWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I/hZJMwB; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I/hZJMwB"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4770c34ca8eso35062955e9.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 08:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761752805; x=1762357605; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iPuK+VGyQwSflpxe9Kn/c/W9eXle2GUO25lwhLsZYxQ=;
        b=I/hZJMwBHQEpj/AB2xlVDqlrYu+Tw3M8cy69gtSGQMHXBDZ7sAxk9w1a9qtEiuwRzP
         osnij7swNnsgYESj+LCFlKRiG4BhbZW/jFnSmbtcbW7nsbg5gOT646a9sz7Wn16tC1I4
         ouXctVhWXSYonyJG42DyQ0Fh98exrMHt5q6jPe0HzdACdFPFR8nmdh+fbMkd/i1Pz+N1
         HsZg3COuyS6UyRa/NxZ3FgkxBF+E6Fi9Z4Fmi5kIofLnV9WucAgAwBLJNj+IXNadDLse
         3/LkI4OR2zBBRYAyk8xVK8+mjVMghO3yd2aBrbjYWTBoIbCPigSbty3m8jHmCsVJACkM
         PM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761752805; x=1762357605;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iPuK+VGyQwSflpxe9Kn/c/W9eXle2GUO25lwhLsZYxQ=;
        b=CNrqL1plyw/YDTscnKIYxFMRlhFXIi08oDKHG9PTv3YzHbJIEnvvu32GWXMAxKsMzL
         CAw66a8rhDeyf+vyTJoUVA5l8RcCCWyWtBbqDDlP55olRxUPVHUAii3ypAnxk0oDKF/i
         LIx6y7gYc3Rp1eGqxTMJDeT3ikoZMqLe26wEH5qKKC5ONpee/D2pSe2a2w7rJGNADrBj
         +50eJYsJ72jV+JwU9HaeGfNJLM+C5gjxV5tjKnqD+Ak19vWZTEzE9sD22UfEGrKzRfP1
         DHlH6SPweXHgFavTYFC80Um+iRENUaIQVNn9UT23hZBN3l/pevkUqoCJKfaDvU94yg0s
         6mGA==
X-Forwarded-Encrypted: i=1; AJvYcCVH6ZS3CLcU+NQXrgdew1SRGdTwccA3AsjMicU90MtfH1mIP7pV9xywGP2CHxZE0DSobuS4N0M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxaMBqV1Z6+c8StCvsMPKluO+rvD0WKtuKGRDn1RWMu42Tz013o
	WwJGh/Ad3WNboCOTLoQVC6sC3OrhNsGmkvE6dLjz0wSGkmBa3klRBOpeq02XCqU21Hs=
X-Gm-Gg: ASbGncv2O5Ywku+sKl4vezcBYbbq4p/+W4yemBqdNIXIWG0L6B1KFDVSPwQr/GLXBvG
	i+0aDsDIsHQYwsTBVnm4WqCSJeD4JlRKzYU2aw0VujsAcTOw/hJzuMHFAd4kyXfNpxlMLI8WjDf
	RyzzX0+mraO8anlmxKywdixnnCV2NHwoN2voNmvTjksk0lZc/lNN2W3btKvP9XI0x5iM0WJ43GU
	v4B9atT3dIuz0DL311rIt7V34ehy0QlkM8njo7jsuIsb5nSsx02j/Rm4xFQAGMnLn6fmZxyuOxJ
	yHWeVXp5WtSAzvp4m/YqblKpFXodZj+x5zf3BZD/yLYSlCpNkJn92fjj2r3h7XMaxosTKzK7TuO
	/oYp8cmJzEmwSI9JXdq/NQnqXsMaJ5LKff17hSPOzJOZR0rwIoNo4MKkay1Drj3MRnDM0eNi/PD
	Yo3vpyQ53MuQ==
X-Google-Smtp-Source: AGHT+IGsC9+Wjmni3+2e4yMVeUDUDuanVVJlv44swuGrvwo+8Mt7mgUfpsdfmreH7PVIKww4YZHrQw==
X-Received: by 2002:a05:600c:3b15:b0:475:dd89:acb with SMTP id 5b1f17b1804b1-4771e3a88ccmr29964175e9.22.1761752804464;
        Wed, 29 Oct 2025 08:46:44 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e3b9994sm53745535e9.16.2025.10.29.08.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:46:43 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Wed, 29 Oct 2025 15:46:04 +0000
Subject: [PATCH v9 4/5] perf tools: Add support for
 perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-james-perf-feat_spe_eft-v9-4-d22536b9cf94@linaro.org>
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

perf_event_attr has gained a new field, config4, so add support for it
extending the existing configN support.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
---
 tools/perf/tests/parse-events.c | 13 ++++++++++++-
 tools/perf/util/parse-events.c  | 11 +++++++++++
 tools/perf/util/parse-events.h  |  1 +
 tools/perf/util/parse-events.l  |  1 +
 tools/perf/util/pmu.c           |  8 ++++++++
 tools/perf/util/pmu.h           |  1 +
 6 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index e4cdb517c10e..128d21dc389f 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -647,6 +647,7 @@ static int test__checkevent_pmu(struct evlist *evlist)
 	TEST_ASSERT_EVSEL("wrong config1",    1 == evsel->core.attr.config1, evsel);
 	TEST_ASSERT_EVSEL("wrong config2",    3 == evsel->core.attr.config2, evsel);
 	TEST_ASSERT_EVSEL("wrong config3",    0 == evsel->core.attr.config3, evsel);
+	TEST_ASSERT_EVSEL("wrong config4",    0 == evsel->core.attr.config4, evsel);
 	/*
 	 * The period value gets configured within evlist__config,
 	 * while this test executes only parse events method.
@@ -669,6 +670,7 @@ static int test__checkevent_list(struct evlist *evlist)
 		TEST_ASSERT_EVSEL("wrong config1", 0 == evsel->core.attr.config1, evsel);
 		TEST_ASSERT_EVSEL("wrong config2", 0 == evsel->core.attr.config2, evsel);
 		TEST_ASSERT_EVSEL("wrong config3", 0 == evsel->core.attr.config3, evsel);
+		TEST_ASSERT_EVSEL("wrong config4", 0 == evsel->core.attr.config4, evsel);
 		TEST_ASSERT_EVSEL("wrong exclude_user", !evsel->core.attr.exclude_user, evsel);
 		TEST_ASSERT_EVSEL("wrong exclude_kernel", !evsel->core.attr.exclude_kernel, evsel);
 		TEST_ASSERT_EVSEL("wrong exclude_hv", !evsel->core.attr.exclude_hv, evsel);
@@ -849,6 +851,15 @@ static int test__checkterms_simple(struct parse_events_terms *terms)
 	TEST_ASSERT_VAL("wrong val", term->val.num == 4);
 	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "config3"));
 
+	/* config4=5 */
+	term = list_entry(term->list.next, struct parse_events_term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG4);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 5);
+	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "config4"));
+
 	/* umask=1*/
 	term = list_entry(term->list.next, struct parse_events_term, list);
 	TEST_ASSERT_VAL("wrong type term",
@@ -2516,7 +2527,7 @@ struct terms_test {
 
 static const struct terms_test test__terms[] = {
 	[0] = {
-		.str   = "config=10,config1,config2=3,config3=4,umask=1,read,r0xead",
+		.str   = "config=10,config1,config2=3,config3=4,config4=5,umask=1,read,r0xead",
 		.check = test__checkterms_simple,
 	},
 };
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 0c0dc20b1c13..ee4f55cbd3cb 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -215,6 +215,8 @@ __add_event(struct list_head *list, int *idx,
 						PERF_PMU_FORMAT_VALUE_CONFIG2, "config2");
 			perf_pmu__warn_invalid_config(pmu, attr->config3, name,
 						PERF_PMU_FORMAT_VALUE_CONFIG3, "config3");
+			perf_pmu__warn_invalid_config(pmu, attr->config4, name,
+						PERF_PMU_FORMAT_VALUE_CONFIG4, "config4");
 		}
 	}
 	/*
@@ -700,6 +702,7 @@ const char *parse_events__term_type_str(enum parse_events__term_type term_type)
 		[PARSE_EVENTS__TERM_TYPE_CONFIG1]		= "config1",
 		[PARSE_EVENTS__TERM_TYPE_CONFIG2]		= "config2",
 		[PARSE_EVENTS__TERM_TYPE_CONFIG3]		= "config3",
+		[PARSE_EVENTS__TERM_TYPE_CONFIG4]		= "config4",
 		[PARSE_EVENTS__TERM_TYPE_NAME]			= "name",
 		[PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD]		= "period",
 		[PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ]		= "freq",
@@ -749,6 +752,7 @@ config_term_avail(enum parse_events__term_type term_type, struct parse_events_er
 	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 	case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
@@ -819,6 +823,10 @@ do {											\
 		CHECK_TYPE_VAL(NUM);
 		attr->config3 = term->val.num;
 		break;
+	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
+		CHECK_TYPE_VAL(NUM);
+		attr->config4 = term->val.num;
+		break;
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
 		CHECK_TYPE_VAL(NUM);
 		break;
@@ -1064,6 +1072,7 @@ static int config_term_tracepoint(struct perf_event_attr *attr,
 	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 	case PARSE_EVENTS__TERM_TYPE_LEGACY_HARDWARE_CONFIG:
 	case PARSE_EVENTS__TERM_TYPE_LEGACY_CACHE_CONFIG:
 	case PARSE_EVENTS__TERM_TYPE_NAME:
@@ -1207,6 +1216,7 @@ do {								\
 		case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 		case PARSE_EVENTS__TERM_TYPE_LEGACY_HARDWARE_CONFIG:
 		case PARSE_EVENTS__TERM_TYPE_LEGACY_CACHE_CONFIG:
 		case PARSE_EVENTS__TERM_TYPE_NAME:
@@ -1245,6 +1255,7 @@ static int get_config_chgs(struct perf_pmu *pmu, struct parse_events_terms *head
 		case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 		case PARSE_EVENTS__TERM_TYPE_LEGACY_HARDWARE_CONFIG:
 		case PARSE_EVENTS__TERM_TYPE_LEGACY_CACHE_CONFIG:
 		case PARSE_EVENTS__TERM_TYPE_NAME:
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 1012b441e9cd..3577ab213730 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -59,6 +59,7 @@ enum parse_events__term_type {
 	PARSE_EVENTS__TERM_TYPE_CONFIG1,
 	PARSE_EVENTS__TERM_TYPE_CONFIG2,
 	PARSE_EVENTS__TERM_TYPE_CONFIG3,
+	PARSE_EVENTS__TERM_TYPE_CONFIG4,
 	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 8e0ea441e57f..251ce4321878 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -287,6 +287,7 @@ config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
 config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
 config3			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG3); }
+config4			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG4); }
 name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 freq			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ); }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index d597263fab4f..dce03c19dc4d 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1566,6 +1566,10 @@ static int pmu_config_term(const struct perf_pmu *pmu,
 			assert(term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
 			pmu_format_value(bits, term->val.num, &attr->config3, zero);
 			break;
+		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
+			assert(term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+			pmu_format_value(bits, term->val.num, &attr->config4, zero);
+			break;
 		case PARSE_EVENTS__TERM_TYPE_LEGACY_HARDWARE_CONFIG:
 			assert(term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
 			assert(term->val.num < PERF_COUNT_HW_MAX);
@@ -1641,6 +1645,9 @@ static int pmu_config_term(const struct perf_pmu *pmu,
 	case PERF_PMU_FORMAT_VALUE_CONFIG3:
 		vp = &attr->config3;
 		break;
+	case PERF_PMU_FORMAT_VALUE_CONFIG4:
+		vp = &attr->config4;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2000,6 +2007,7 @@ int perf_pmu__for_each_format(struct perf_pmu *pmu, void *state, pmu_format_call
 		"config1=0..0xffffffffffffffff",
 		"config2=0..0xffffffffffffffff",
 		"config3=0..0xffffffffffffffff",
+		"config4=0..0xffffffffffffffff",
 		"legacy-hardware-config=0..9,",
 		"legacy-cache-config=0..0xffffff,",
 		"name=string",
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 1ebcf0242af8..67431f765266 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -23,6 +23,7 @@ enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG1,
 	PERF_PMU_FORMAT_VALUE_CONFIG2,
 	PERF_PMU_FORMAT_VALUE_CONFIG3,
+	PERF_PMU_FORMAT_VALUE_CONFIG4,
 	PERF_PMU_FORMAT_VALUE_CONFIG_END,
 };
 

-- 
2.34.1

