Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C81241693
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747747101; cv=none; b=a8KCb0+YiVg5vU4idVLHGCowII3NvwxjsZC6ikLcOkthMOpwswDNGaTXPvddiFrsczxdGmI2Q+vgOd7Rj9S282eaEEiHNGcrLqGgk5b1/0UExWivj+5neLAG0pLw/vth4LbfxjrOzG2Dquoy6g5yzYeoaybrAKqmGAuQqwO7myM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747747101; c=relaxed/simple;
	bh=378Kkw9OSgPqyTiyeShgF0O9mnvCb2QyG9sE6pA39Rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQNtLRGW25eSfDgrQvLVl6D1QUea/17Ejk4EjLJhVPNjZHn6j5lYyuaQBD8FZUHzAZ7tva0abRRYg9TbugnN+rPkfEnSFg9vNdnsUxDQIzj0bFnCpyqzaUZgVq9rM31XZ4MPCzhzAzgqcopC6X6UW5bB04ZTRKbA3KVcYnywvc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AACCC1516;
	Tue, 20 May 2025 06:18:05 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 963163F5A1;
	Tue, 20 May 2025 06:18:18 -0700 (PDT)
Date: Tue, 20 May 2025 14:18:16 +0100
From: Leo Yan <leo.yan@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 09/10] perf tools: Add support for
 perf_event_attr::config4
Message-ID: <20250520131816.GQ412060@e132581.arm.com>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-9-dd480e8e4851@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-9-dd480e8e4851@linaro.org>

On Tue, May 06, 2025 at 12:41:41PM +0100, James Clark wrote:
> perf_event_attr has gained a new field, config4, so add support for it
> extending the existing configN support.
> 
> Signed-off-by: James Clark <james.clark@linaro.org>

Reviewed-by: Leo Yan <leo.yan@arm.com>

> ---
>  tools/perf/tests/parse-events.c | 14 +++++++++++++-
>  tools/perf/util/parse-events.c  | 11 +++++++++++
>  tools/perf/util/parse-events.h  |  1 +
>  tools/perf/util/parse-events.l  |  1 +
>  tools/perf/util/pmu.c           |  8 ++++++++
>  tools/perf/util/pmu.h           |  1 +
>  6 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
> index 5ec2e5607987..5f624a63d550 100644
> --- a/tools/perf/tests/parse-events.c
> +++ b/tools/perf/tests/parse-events.c
> @@ -615,6 +615,8 @@ static int test__checkevent_pmu(struct evlist *evlist)
>  	TEST_ASSERT_VAL("wrong config1",    1 == evsel->core.attr.config1);
>  	TEST_ASSERT_VAL("wrong config2",    3 == evsel->core.attr.config2);
>  	TEST_ASSERT_VAL("wrong config3",    0 == evsel->core.attr.config3);
> +	TEST_ASSERT_VAL("wrong config4",    0 == evsel->core.attr.config4);
> +
>  	/*
>  	 * The period value gets configured within evlist__config,
>  	 * while this test executes only parse events method.
> @@ -637,6 +639,7 @@ static int test__checkevent_list(struct evlist *evlist)
>  		TEST_ASSERT_VAL("wrong config1", 0 == evsel->core.attr.config1);
>  		TEST_ASSERT_VAL("wrong config2", 0 == evsel->core.attr.config2);
>  		TEST_ASSERT_VAL("wrong config3", 0 == evsel->core.attr.config3);
> +		TEST_ASSERT_VAL("wrong config4", 0 == evsel->core.attr.config4);
>  		TEST_ASSERT_VAL("wrong exclude_user", !evsel->core.attr.exclude_user);
>  		TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->core.attr.exclude_kernel);
>  		TEST_ASSERT_VAL("wrong exclude_hv", !evsel->core.attr.exclude_hv);
> @@ -813,6 +816,15 @@ static int test__checkterms_simple(struct parse_events_terms *terms)
>  	TEST_ASSERT_VAL("wrong val", term->val.num == 4);
>  	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "config3"));
>  
> +	/* config4=5 */
> +	term = list_entry(term->list.next, struct parse_events_term, list);
> +	TEST_ASSERT_VAL("wrong type term",
> +			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG4);
> +	TEST_ASSERT_VAL("wrong type val",
> +			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
> +	TEST_ASSERT_VAL("wrong val", term->val.num == 5);
> +	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "config4"));
> +
>  	/* umask=1*/
>  	term = list_entry(term->list.next, struct parse_events_term, list);
>  	TEST_ASSERT_VAL("wrong type term",
> @@ -2451,7 +2463,7 @@ struct terms_test {
>  
>  static const struct terms_test test__terms[] = {
>  	[0] = {
> -		.str   = "config=10,config1,config2=3,config3=4,umask=1,read,r0xead",
> +		.str   = "config=10,config1,config2=3,config3=4,config4=5,umask=1,read,r0xead",
>  		.check = test__checkterms_simple,
>  	},
>  };
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 5152fd5a6ead..7e37f91e7b49 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -247,6 +247,8 @@ __add_event(struct list_head *list, int *idx,
>  					      PERF_PMU_FORMAT_VALUE_CONFIG2, "config2");
>  		perf_pmu__warn_invalid_config(pmu, attr->config3, name,
>  					      PERF_PMU_FORMAT_VALUE_CONFIG3, "config3");
> +		perf_pmu__warn_invalid_config(pmu, attr->config4, name,
> +					      PERF_PMU_FORMAT_VALUE_CONFIG4, "config4");
>  	}
>  	if (init_attr)
>  		event_attr_init(attr);
> @@ -783,6 +785,7 @@ const char *parse_events__term_type_str(enum parse_events__term_type term_type)
>  		[PARSE_EVENTS__TERM_TYPE_CONFIG1]		= "config1",
>  		[PARSE_EVENTS__TERM_TYPE_CONFIG2]		= "config2",
>  		[PARSE_EVENTS__TERM_TYPE_CONFIG3]		= "config3",
> +		[PARSE_EVENTS__TERM_TYPE_CONFIG4]		= "config4",
>  		[PARSE_EVENTS__TERM_TYPE_NAME]			= "name",
>  		[PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD]		= "period",
>  		[PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ]		= "freq",
> @@ -830,6 +833,7 @@ config_term_avail(enum parse_events__term_type term_type, struct parse_events_er
>  	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
>  	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
>  	case PARSE_EVENTS__TERM_TYPE_CONFIG3:
> +	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
>  	case PARSE_EVENTS__TERM_TYPE_NAME:
>  	case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
>  	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
> @@ -898,6 +902,10 @@ do {									   \
>  		CHECK_TYPE_VAL(NUM);
>  		attr->config3 = term->val.num;
>  		break;
> +	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
> +		CHECK_TYPE_VAL(NUM);
> +		attr->config4 = term->val.num;
> +		break;
>  	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
>  		CHECK_TYPE_VAL(NUM);
>  		break;
> @@ -1097,6 +1105,7 @@ static int config_term_tracepoint(struct perf_event_attr *attr,
>  	case PARSE_EVENTS__TERM_TYPE_CONFIG1:
>  	case PARSE_EVENTS__TERM_TYPE_CONFIG2:
>  	case PARSE_EVENTS__TERM_TYPE_CONFIG3:
> +	case PARSE_EVENTS__TERM_TYPE_CONFIG4:
>  	case PARSE_EVENTS__TERM_TYPE_NAME:
>  	case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
>  	case PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ:
> @@ -1237,6 +1246,7 @@ do {								\
>  		case PARSE_EVENTS__TERM_TYPE_CONFIG1:
>  		case PARSE_EVENTS__TERM_TYPE_CONFIG2:
>  		case PARSE_EVENTS__TERM_TYPE_CONFIG3:
> +		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
>  		case PARSE_EVENTS__TERM_TYPE_NAME:
>  		case PARSE_EVENTS__TERM_TYPE_METRIC_ID:
>  		case PARSE_EVENTS__TERM_TYPE_RAW:
> @@ -1274,6 +1284,7 @@ static int get_config_chgs(struct perf_pmu *pmu, struct parse_events_terms *head
>  		case PARSE_EVENTS__TERM_TYPE_CONFIG1:
>  		case PARSE_EVENTS__TERM_TYPE_CONFIG2:
>  		case PARSE_EVENTS__TERM_TYPE_CONFIG3:
> +		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
>  		case PARSE_EVENTS__TERM_TYPE_NAME:
>  		case PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD:
>  		case PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ:
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index e176a34ab088..6e90c26066d4 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -58,6 +58,7 @@ enum parse_events__term_type {
>  	PARSE_EVENTS__TERM_TYPE_CONFIG1,
>  	PARSE_EVENTS__TERM_TYPE_CONFIG2,
>  	PARSE_EVENTS__TERM_TYPE_CONFIG3,
> +	PARSE_EVENTS__TERM_TYPE_CONFIG4,
>  	PARSE_EVENTS__TERM_TYPE_NAME,
>  	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
>  	PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ,
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 7ed86e3e34e3..8e2986d55bc4 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -317,6 +317,7 @@ config			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG); }
>  config1			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG1); }
>  config2			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG2); }
>  config3			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG3); }
> +config4			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_CONFIG4); }
>  name			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_NAME); }
>  period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
>  freq			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_FREQ); }
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index b7ebac5ab1d1..fc50df65d540 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -1427,6 +1427,10 @@ static int pmu_config_term(const struct perf_pmu *pmu,
>  			assert(term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
>  			pmu_format_value(bits, term->val.num, &attr->config3, zero);
>  			break;
> +		case PARSE_EVENTS__TERM_TYPE_CONFIG4:
> +			assert(term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
> +			pmu_format_value(bits, term->val.num, &attr->config4, zero);
> +			break;
>  		case PARSE_EVENTS__TERM_TYPE_USER: /* Not hardcoded. */
>  			return -EINVAL;
>  		case PARSE_EVENTS__TERM_TYPE_NAME ... PARSE_EVENTS__TERM_TYPE_HARDWARE:
> @@ -1474,6 +1478,9 @@ static int pmu_config_term(const struct perf_pmu *pmu,
>  	case PERF_PMU_FORMAT_VALUE_CONFIG3:
>  		vp = &attr->config3;
>  		break;
> +	case PERF_PMU_FORMAT_VALUE_CONFIG4:
> +		vp = &attr->config4;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1787,6 +1794,7 @@ int perf_pmu__for_each_format(struct perf_pmu *pmu, void *state, pmu_format_call
>  		"config1=0..0xffffffffffffffff",
>  		"config2=0..0xffffffffffffffff",
>  		"config3=0..0xffffffffffffffff",
> +		"config4=0..0xffffffffffffffff",
>  		"name=string",
>  		"period=number",
>  		"freq=number",
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index b93014cc3670..1ce5377935db 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -22,6 +22,7 @@ enum {
>  	PERF_PMU_FORMAT_VALUE_CONFIG1,
>  	PERF_PMU_FORMAT_VALUE_CONFIG2,
>  	PERF_PMU_FORMAT_VALUE_CONFIG3,
> +	PERF_PMU_FORMAT_VALUE_CONFIG4,
>  	PERF_PMU_FORMAT_VALUE_CONFIG_END,
>  };
>  
> 
> -- 
> 2.34.1
> 
