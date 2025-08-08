Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE93277038
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652242; cv=none; b=H2l2Ii94xW0ZrQnDVz9eG2r6z19fkzXM1wW3EF/ubES9RGUi+7iN1db2yEZCxvGGdOBk6SXiLR4f3Zhs9cZ2Q9/Y4dLjG3gnfKJDFqUYqxup8/7PcgX5NlJ60W5UgkgO9CvmpkTd1+/9SzPEMJNGzZzUW2vURwzu3LUTZNoqF3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652242; c=relaxed/simple;
	bh=b/ttJae4xiEHONrSB61gWYPCVcnCnqIpQyNKL5V/Pqw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cAq4jCvTVHslkSboIGF2IDVrrpwWx3WnHsBjZbZIrbF3yuUiyXyIqiVrxJWXQuW53/+l6KQxvGAuLk9ULghxbeyvRgL0Gb/1AmVSu3jARigtx9w2SGxvl7nKmt27d871uVPsoV6zRpyNgmsEp5jNHDdARkFr6tXucgawf8i2WuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LPOPOBXV; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LPOPOBXV"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-459d44d286eso13796655e9.0
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652238; x=1755257038; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=LPOPOBXV3s1aAdydetc0WFlOt8NymL+JA9HCSM/kuvvYRmLFfICvw1jTizRC54ifNS
         ty3IjIJ+PYKQUzgiuL1gckwqCijttUc0j5AYP60M94SexLWc/XLbNlzonuU2N3sxLyAj
         k1t2uqfWNyEsIWYhnj+dEH4rOzwuYgdwW7uQ9YWvq73KVBVob/rnjvE8JqXuTbjBsj03
         XV6t1Uf5x1Y4/bVtZfpI5OGSKR7362s4F804v7TjDNKkhbW1LmxJdUPjaqc9rxmyc+1Q
         n7lJ5kwhlhcEhMIahOqrs9wMt+3xMEoZdLHMmiSLhnpHMIVwApOSfUL7hdFtUZ44seym
         yXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652238; x=1755257038;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=ntp2deuNAnOnGDi4Rq+TL3+cniOOKCxo5n+cddQr085zNiUosLlzxqF+WboCQH9syK
         ylR8/iKBcxjG+MwRTGzHwcoVfTYzuZgGCW1WjJlM+X61FOc1u4N5wo6PziqGSEl9rdWm
         jyWN7W76vzcKYoMzv3G00wXjZS1Q4/r8UOWe9CrvWVWArwnF3fMT5CetaKbpXJc5utzf
         9Ool4d4SmKY5EsiY3Ct+oNU1xjnKnnBZYYvhE06wWUNmGh32Wz/VvMlpHxmKK4WiuQO5
         n4EuNdUnyEhIXInvs9RuJeTammT61QYeHWZF+dOSzG8EKYbNsNxGeG7pySx9ROprsG6A
         hCRA==
X-Forwarded-Encrypted: i=1; AJvYcCUrlAMhP4cucb4hnMIV49HslQbbfSVWDO7S3LWoG22quoqKlzO7QtXmrYBA+k9Q3tTjrzkqkYg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFNS3/w/aYBCwTC/JZvX4bNys+0Zwzu5Cl9449OyAne8v3lnFM
	YI06lqWNd1a8HM7wcqddLihLiCW/PywB0lAlhzW1UeoCzSkDulpMEx/4UN8FavSnnLY=
X-Gm-Gg: ASbGncsqVsjn4VrRatpa3+R7QIZKl5vVxsr1RishFJRZ3rOgOzCa33ip8OrOcmV9IYA
	tXaPFdPcJuMD4cqA9U0Ythw7MYYA42wXG6c5bbNIDXhPqVynY0XfNSfgiKe7OUyALvZuDnqp0TU
	Fc18/UIFZo2F7LF/udt/Nihx0dTwOhqWgStE7EXC9w6pICJXhUABQ/Zoz+B0tHBqn0aSFenMeum
	xp0kiNmcItk+8PPLJ1fzgLcRCsUdKvHFdkxXi4LU/KDnI3sXTflgG7WlAqd5+/62V8HmkyaUq66
	7qBWcBE9Dglj/96jUh5CZChH0WSIvXW0P+f1bR9ctoq+D72AmX4BfUvAolYaTN+1X9Dz3QrwRVs
	TZIzP4KFrbzBIMgnFHrMkyr0tHLjPeOw=
X-Google-Smtp-Source: AGHT+IGoaBQKmBj6KMNMQL0VdWvV/9kYUe2OiKjmu5rnVVRKChL318TYjODlxCnVcHM6lZ386h3kaQ==
X-Received: by 2002:a05:6000:4383:b0:3b6:d0d:79c1 with SMTP id ffacd0b85a97d-3b8f97c49afmr6128407f8f.10.1754652238270;
        Fri, 08 Aug 2025 04:23:58 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:57 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:23:07 +0100
Subject: [PATCH v6 10/12] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-10-6daf498578c8@linaro.org>
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

To pickup config4 changes.

Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
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

