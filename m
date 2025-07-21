Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549392DE1FE
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103128; cv=none; b=YJkdbojcIUBSPGlvjKAHQOTfQ1j3EEV36hztOpuX26Pvi3lwoUkBZz4p6xvScshBcQk9Uf3plxnAuUHzwg6S2P9EsHrH823QohN6+DozMjNewf5/WAX22slDewfm4gA2KJamEPxfz5YAT5SOy+HQlTtMEo0CU3WUI51xnVmrSCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103128; c=relaxed/simple;
	bh=zEhlu09ovEaZOKs03esXMkQBz9lJahTpuBkvyALKn4E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QnH38qm7Wg5aj2cGNas7Tg3vovYmD6JocjXYOW5fy178jUqtCq3zTGv16Y42aygiAKFkmc7LRcNp1t2I0iEKLUeEwiSba9YHsITNBehDgb6RtkNb3kqE8n+ijLXg6M8RFFQ3wuG+2b/w0JbOZzXyV4NuU704gro2A+WohY+vjfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=evIRqSxw; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="evIRqSxw"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a588da60dfso2591171f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103124; x=1753707924; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dAXIxI7OfKIjbF0vv8PgxXhY9PyJCfDAmY7uglgU/88=;
        b=evIRqSxwg3ezXg8jf02afxuAdjM4kUR0y5k5AnBXiKxqu+vyVkyrcabezQYFvUgSyd
         6H9hle3kl8jy/TQQHA3CZISUmNV6DOFpwM8YEBmwSKnsO2tbJhu8Yp70sRY0CubvzMch
         BSpvKAAANBxc+05KRL63OVXGBCV2AodyP4z3rdCgRXAjZDfSy3cQKePLh1EoRiOZDr5v
         aG0DVlE3sRM3anpSZ5QIUZ6U7jMgsJWGD7IqMhhlA/6pgvJ/uvn60Z+fUo6D8GMxcom6
         QMaDAyYZ/liFoe8aWy9Tt70lfciNSgoT0vgD/ZjP/Gk13vK8Xb8G6o57mL7nPQUvtOVf
         re1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103124; x=1753707924;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dAXIxI7OfKIjbF0vv8PgxXhY9PyJCfDAmY7uglgU/88=;
        b=mVvouC+zGWoI4uBsZceelP6lhw3L/+hh/BunFGudiIHdilmD2NKcW6K4gER0J8Xl3s
         dzsBtq5OfkjiSAa6NBTOocjELVZldsHk3CObc6ZwxVi614P5zFPBjHwLh2T5/NuCoAXX
         r9O+4lH7yRf6ba7YuFcfuANdCiArc8W1lXwA45RLWm8htKBzMtiu4L8BA0yiEOCEfroJ
         1ngh48f1VXdhYJBo0J6ccp3jWFesossE8X8LranP2afr97GEe0qKzElBsgbMarfqHtk7
         IYdYNDl3eM0W1guRJ+RhY/ImP2h0qgOTDKJK81uHqeO9iSXidii6nDwhgJ+DaF0RNvjN
         IRwA==
X-Forwarded-Encrypted: i=1; AJvYcCXFTCpU7XsflDqsL0+NVv+d99ronZ4lufC9PuRf4a8H38l+y32Fj3+AWZzfYg7n1KwY7kl6idQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXXbjSYbCVXTqBaHVzpGUtWgjFX0r7DDWsWJxldmZhaWkNlVMi
	2+vwWuy4v7P6orzO130KguMmlrOMrl+igMU/JHgn/lHLrN4reRWcMZwLc+iuhDeCm0RM445Yyj3
	vdPe0B+A=
X-Gm-Gg: ASbGncvds23Sw+NByiFIlU8k/p1S1OGiJEI8inP6jyPTRXcyZgwf1/T+cLzt6KD00+u
	81RJgS0IEkICzTPrhSDO0WKPakZ3j9hHXD7Qn+qIthxIiOduENXfXvzr5WZPdoAJ4VWfHhP1x/b
	8I9LdrbEl3pWe6FmpzJvWJGcBQw4V92KnZnF7OTMTHM2egFKVG4fTilaAECKO+njwQ8hisz+meu
	0uFAyjsc2RWiBMLdNsTekZ+Q0sxnWeoCJ9c1RdzFRxqA7giX+WMPZQoDPYBOD5yl5ZET4GSWpV0
	5/x+aUVY9d5UuuLGGlhgL30/vGrOXAWWNkmVM50N/8V+HP6lBgLiRMuBPx/IJVuLKluU8CBRKsQ
	Tw/TtZkG7cQP4dX0q/JVNfq7zrdCcwPcPPW9x+gv7fQ==
X-Google-Smtp-Source: AGHT+IHSLKc1NvrbTSBAIr05h8vpMPbd8ZufmUFJ66bwSLRixnUu1C9KFjza66XJ2aN/SIFzmkRf3w==
X-Received: by 2002:a05:6000:385:b0:3a6:eb59:f37f with SMTP id ffacd0b85a97d-3b60e4c5206mr17337606f8f.12.1753103124357;
        Mon, 21 Jul 2025 06:05:24 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:23 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:05:05 +0100
Subject: [PATCH v5 11/12] perf tools: Add support for
 perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-11-a7bc533485a1@linaro.org>
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
index 5ec2e5607987..5f624a63d550 100644
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
index 2380de56a207..2fccdf5879c8 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -291,6 +291,8 @@ __add_event(struct list_head *list, int *idx,
 						PERF_PMU_FORMAT_VALUE_CONFIG2, "config2");
 			perf_pmu__warn_invalid_config(pmu, attr->config3, name,
 						PERF_PMU_FORMAT_VALUE_CONFIG3, "config3");
+			perf_pmu__warn_invalid_config(pmu, attr->config4, name,
+						PERF_PMU_FORMAT_VALUE_CONFIG4, "config4");
 		}
 	} else {
 		is_pmu_core = (attr->type == PERF_TYPE_HARDWARE ||
@@ -848,6 +850,7 @@ const char *parse_events__term_type_str(enum parse_events__term_type term_type)
 		[PARSE_EVENTS__TERM_TYPE_CONFIG1]		= "config1",
 		[PARSE_EVENTS__TERM_TYPE_CONFIG2]		= "config2",
 		[PARSE_EVENTS__TERM_TYPE_CONFIG3]		= "config3",
+		[PARSE_EVENTS__TERM_TYPE_CONFIG4]		= "config4",
 		[PARSE_EVENTS__TERM_TYPE_NAME]			= "name",
 		[PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD]		= "period",
 		[PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ]		= "freq",
@@ -896,6 +899,7 @@ config_term_avail(enum parse_events__term_type term_type, struct parse_events_er
 	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 	case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
@@ -965,6 +969,10 @@ do {									   \
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
@@ -1173,6 +1181,7 @@ static int config_term_tracepoint(struct perf_event_attr *attr,
 	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 	case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
 	case PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ:
@@ -1314,6 +1323,7 @@ do {								\
 		case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 		case PARSE_EVENTS__TERM_TYPE_NAME:
 		case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
 		case PARSE_EVENTS__TERM_TYPE_RAW:
@@ -1352,6 +1362,7 @@ static int get_config_chgs(struct perf_pmu *pmu, struct parse_events_terms *head
 		case PARSE_EVENTS__TERM_TYPE_CONFIG1:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG2:
 		case PARSE_EVENTS__TERM_TYPE_CONFIG3:
+		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
 		case PARSE_EVENTS__TERM_TYPE_NAME:
 		case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
 		case PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ:
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ab242f671031..81af219cafb3 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -58,6 +58,7 @@ enum parse_events__term_type {
 	PARSE_EVENTS__TERM_TYPE_CONFIG1,
 	PARSE_EVENTS__TERM_TYPE_CONFIG2,
 	PARSE_EVENTS__TERM_TYPE_CONFIG3,
+	PARSE_EVENTS__TERM_TYPE_CONFIG4,
 	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ,
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 4af7b9c1f44d..3f83aaf33a34 100644
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
index 609828513f6c..c7782916f932 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1508,6 +1508,10 @@ static int pmu_config_term(const struct perf_pmu *pmu,
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
@@ -1555,6 +1559,9 @@ static int pmu_config_term(const struct perf_pmu *pmu,
 	case PERF_PMU_FORMAT_VALUE_CONFIG3:
 		vp = &attr->config3;
 		break;
+	case PERF_PMU_FORMAT_VALUE_CONFIG4:
+		vp = &attr->config4;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1875,6 +1882,7 @@ int perf_pmu__for_each_format(struct perf_pmu *pmu, void *state, pmu_format_call
 		"config1=0..0xffffffffffffffff",
 		"config2=0..0xffffffffffffffff",
 		"config3=0..0xffffffffffffffff",
+		"config4=0..0xffffffffffffffff",
 		"name=string",
 		"period=number",
 		"freq=number",
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 71b8636fd07d..49ac47e2b44f 100644
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

