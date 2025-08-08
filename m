Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606C0277815
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652244; cv=none; b=MzsXlnGKiCT3ESvcemW+YepZURh8Qy7dM+bWQ/XDI5liJit4ekX53Su4coEfcmewrlRlxhl+wklYWr53asJkoaq7phL2+pTCbNY5nITSa2ng4Atb2/Ef2oyEflWegiAKQMeAOV9L3U5pC07rLkq0+b2mGohIWp7P0zUMVZ2/rb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652244; c=relaxed/simple;
	bh=CNBe14pNLnXU+RaS/M5L+smgEMoBVwqw6DTZL4A5ZNc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kznzs0z4okkeaeJqIzKvOhXbfILnW8/vblT6VLkpUaLn7HDdeHqwpjqaYSD5v5DND1ZG7ESL/Fj0WdeqW7t+YaGVQ4tTv6NQZm2DdGwVmrH+9O19tYQQx6DcXWtMhI6t7m1cc8A4Jy+zKaBdHDmc8Ry9tTN3F2WVay1UPL07h7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Vvr5Y/wK; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vvr5Y/wK"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b7823559a5so932532f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652240; x=1755257040; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7XfWTbVgLd+JOqYthg70wtq8ZILm6OycONzgKD9jOeg=;
        b=Vvr5Y/wKrVWUQgEesfkYZWKqAkHjq7zJbSTxa/tk9tjbbUGwHX0taXgPiqnf3SVvfj
         X22Z1940ZwSuE/SZi6wtx+UycdQ5N/6LvR1chS3J5z+rsqJLBTPu3+OtuK2dQlSR/Brl
         98Bl9dt3KHjtHS/RiGFTEMueVBbFpjv9L4cUYXsZT+xAUzuITdp4Jr76AjJKLeu27fEb
         ePe3QYyhLFmaFq01ugQI1JudrNM0b4f+3mcWVn1/hTaveT6gqACN9XYcgFkGRh0GrEMo
         9UNkiPOhsQOi4ykz/lLxi05fPikCVpexLg4nACzpoYynvyHGlGfgB9cU+9RoJ6Ak2T2G
         ANzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652240; x=1755257040;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XfWTbVgLd+JOqYthg70wtq8ZILm6OycONzgKD9jOeg=;
        b=mRL2HYDDOPVj6BAtqxdTaHZTsYs24aHbvEvYBCY9PQXAEtZumr8CqHRB2lazeWXR2U
         6psuazwc3hGjnjuopNbrtWECH94eg8k3DLyISvso/hK7zGv52wlxFlltfq/AbdQr8Hjw
         bPai1XqzZfrz9B/ur+XrLoh/W9D4cK2Gtoty6QMKqe2UsZcC/tS9J3ATBej3nmXW16iY
         SydO1QZWYcj6UYpXYzJU99Zymrop0t1/HoKd1mtzwRrzJCHGNJZFjEWU4G83/EFWLx5p
         IwYIOD9wMp2styQP387oPS9CtHhYSi2z/vBeXCkF0UrGOFZZ/8K4hpyGuXM7jQUwpy99
         PAcg==
X-Forwarded-Encrypted: i=1; AJvYcCUPj308V5gBwDDWiyJxJdv66FtbVJhsSR1/HQPRcYVYggDNq9VUJnwWAIaTBFqgYf670Zk8Hoo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUBeBEdDgpWHd8F6V+P1vLxb2545954Su9IxiNxVi9JyB5WDNU
	GMS34JerhMNaosiMzhsrhvO5j9bKlxv3eRjhiih18xXTVvE+YqFgbR/95SKJKwbVlUw=
X-Gm-Gg: ASbGncvGL7DSCpEffs+SFu0d3kohZdj7//ci6T9OeOJAPNtAfhyRpRL0m8nPkXIr8Ee
	xVtFV6PrW1Ly7JNAtz8NnCB//TvcfkIfcBgfMZhcRrA6UkvOgFH5CUbXgnWPjKXTsKCcQtFYLy+
	ppFOWWp1FH8wyKwlcZOyQqMG27BpsLrsaP1aYLMAkPODLoY+JQR/wTFjukvflHoX1rtqAmUWdaT
	sHX7vJPPn2IJmhicxdIOYb55Yoj8SN+V6c/IAw67j2ZssKnbq5MW5d5SxuxSUl4EBeICq7s+eQZ
	OOwaleEnxtCfTcU0w+Z9rvc187lPX0vciz8mIqRAhsFYjKuFdrVhvMoJaVTSzqCNVXs3KSfOdDp
	bv93D33P9mVyHTVwottTGQWoQPjGsxYA=
X-Google-Smtp-Source: AGHT+IGCueR4XsLqFJZvSYTsaohegfumGwRIqixWP89UFLd+1Fro5zFiBhtlyZeCuLb75QBbufFgyA==
X-Received: by 2002:a05:6000:240b:b0:3b8:d360:336f with SMTP id ffacd0b85a97d-3b900b4d2d7mr2237756f8f.28.1754652239740;
        Fri, 08 Aug 2025 04:23:59 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:59 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:23:08 +0100
Subject: [PATCH v6 11/12] perf tools: Add support for
 perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-11-6daf498578c8@linaro.org>
References: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
In-Reply-To: <20250808-james-perf-feat_spe_eft-v6-0-6daf498578c8@linaro.org>
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
 tools/perf/tests/parse-events.c | 14 +++++++++++++-
 tools/perf/util/parse-events.c  | 11 +++++++++++
 tools/perf/util/parse-events.h  |  1 +
 tools/perf/util/parse-events.l  |  1 +
 tools/perf/util/pmu.c           |  8 ++++++++
 tools/perf/util/pmu.h           |  1 +
 6 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index bb8004397650..342ed896b703 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -615,6 +615,8 @@ static int test__checkevent_pmu(struct evlist *evlist)
 	TEST_ASSERT_VAL("wrong config1",    1 == evsel->core.attr.config1);
 	TEST_ASSERT_VAL("wrong config2",    3 == evsel->core.attr.config2);
 	TEST_ASSERT_VAL("wrong config3",    0 == evsel->core.attr.config3);
+	TEST_ASSERT_VAL("wrong config4",    0 == evsel->core.attr.config4);
+
 	/*
 	 * The period value gets configured within evlist__config,
 	 * while this test executes only parse events method.
@@ -637,6 +639,7 @@ static int test__checkevent_list(struct evlist *evlist)
 		TEST_ASSERT_VAL("wrong config1", 0 == evsel->core.attr.config1);
 		TEST_ASSERT_VAL("wrong config2", 0 == evsel->core.attr.config2);
 		TEST_ASSERT_VAL("wrong config3", 0 == evsel->core.attr.config3);
+		TEST_ASSERT_VAL("wrong config4", 0 == evsel->core.attr.config4);
 		TEST_ASSERT_VAL("wrong exclude_user", !evsel->core.attr.exclude_user);
 		TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->core.attr.exclude_kernel);
 		TEST_ASSERT_VAL("wrong exclude_hv", !evsel->core.attr.exclude_hv);
@@ -813,6 +816,15 @@ static int test__checkterms_simple(struct parse_events_terms *terms)
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
@@ -2451,7 +2463,7 @@ struct terms_test {
 
 static const struct terms_test test__terms[] = {
 	[0] = {
-		.str   = "config=10,config1,config2=3,config3=4,umask=1,read,r0xead",
+		.str   = "config=10,config1,config2=3,config3=4,config4=5,umask=1,read,r0xead",
 		.check = test__checkterms_simple,
 	},
 };
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8282ddf68b98..5f0b4a3c3dda 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -247,6 +247,8 @@ __add_event(struct list_head *list, int *idx,
 						PERF_PMU_FORMAT_VALUE_CONFIG2, "config2");
 			perf_pmu__warn_invalid_config(pmu, attr->config3, name,
 						PERF_PMU_FORMAT_VALUE_CONFIG3, "config3");
+			perf_pmu__warn_invalid_config(pmu, attr->config4, name,
+						PERF_PMU_FORMAT_VALUE_CONFIG4, "config4");
 		}
 	}
 	/*
@@ -811,6 +813,7 @@ const char *parse_events__term_type_str(enum parse_events__term_type term_type)
 		[PARSE_EVENTS__TERM_TYPE_CONFIG1]		= "config1",
 		[PARSE_EVENTS__TERM_TYPE_CONFIG2]		= "config2",
 		[PARSE_EVENTS__TERM_TYPE_CONFIG3]		= "config3",
+		[PARSE_EVENTS__TERM_TYPE_CONFIG4]		= "config4",
 		[PARSE_EVENTS__TERM_TYPE_NAME]			= "name",
 		[PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD]		= "period",
 		[PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ]		= "freq",
@@ -859,6 +862,7 @@ config_term_avail(enum parse_events__term_type term_type, struct parse_events_er
 	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 	case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
@@ -928,6 +932,10 @@ do {									   \
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
@@ -1153,6 +1161,7 @@ static int config_term_tracepoint(struct perf_event_attr *attr,
 	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ:
@@ -1294,6 +1303,7 @@ do {								\
 		case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 		case PARSE_EVENTS__TERM_TYPE_NAME:
 		case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
 		case PARSE_EVENTS__TERM_TYPE_RAW:
@@ -1332,6 +1342,7 @@ static int get_config_chgs(struct perf_pmu *pmu, struct parse_events_terms *head
 		case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 		case PARSE_EVENTS__TERM_TYPE_NAME:
 		case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
 		case PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ:
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 62dc7202e3ba..9e482cfdaaf9 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -60,6 +60,7 @@ enum parse_events__term_type {
 	PARSE_EVENTS__TERM_TYPE_CONFIG1,
 	PARSE_EVENTS__TERM_TYPE_CONFIG2,
 	PARSE_EVENTS__TERM_TYPE_CONFIG3,
+	PARSE_EVENTS__TERM_TYPE_CONFIG4,
 	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 2034590eb789..300d84fd09ad 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -317,6 +317,7 @@ config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
 config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
 config3			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG3); }
+config4			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG4); }
 name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 freq			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ); }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 5a291f1380ed..5868d654872b 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1539,6 +1539,10 @@ static int pmu_config_term(const struct perf_pmu *pmu,
 			assert(term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
 			pmu_format_value(bits, term->val.num, &attr->config3, zero);
 			break;
+		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
+			assert(term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+			pmu_format_value(bits, term->val.num, &attr->config4, zero);
+			break;
 		case PARSE_EVENTS__TERM_TYPE_USER: /* Not hardcoded. */
 			return -EINVAL;
 		case PARSE_EVENTS__TERM_TYPE_NAME ... PARSE_EVENTS__TERM_TYPE_CPU:
@@ -1586,6 +1590,9 @@ static int pmu_config_term(const struct perf_pmu *pmu,
 	case PERF_PMU_FORMAT_VALUE_CONFIG3:
 		vp = &attr->config3;
 		break;
+	case PERF_PMU_FORMAT_VALUE_CONFIG4:
+		vp = &attr->config4;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1912,6 +1919,7 @@ int perf_pmu__for_each_format(struct perf_pmu *pmu, void *state, pmu_format_call
 		"config1=0..0xffffffffffffffff",
 		"config2=0..0xffffffffffffffff",
 		"config3=0..0xffffffffffffffff",
+		"config4=0..0xffffffffffffffff",
 		"name=string",
 		"period=number",
 		"freq=number",
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

