Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28A233473C
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730524; cv=none; b=HllEi/SVyi8l7sTlRuW1m2uU2LcCJVEnxg6lWOiN8Wedk+Ldn6mZiMU9SO9JwZ+h73qkZdO8Is7UtBoiHw5XZhvqQZwB797rGF6EwvhdbU290G65gXxjvmxyJeai5r9KytQ6lq1ltUjF2R0KAwmpQ5xwPv6zEFj7jtwvuOLaOgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730524; c=relaxed/simple;
	bh=3yjrpHkX+aMdTK90nxuOJyMh4ajXQ8n+rTYB1GAa/ak=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UtQNf9O3vbIKlnDQCqmR03qhl7ZQITLCgET1KIBSIx/cDMLwi0WxN/ZpFD75XrvMFB2HRIjKePYRzoFTrMR8TMxX/DIhp7cuRRQ1qrZkKIV/3aqYhAVwkiaQnEvjnhxWDYDC2FwZJpH9z/1M8eJBMkNX70B+OPJ9ljS8KPwaA1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FK6SIMwD; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FK6SIMwD"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b8b7ac427so6206185e9.2
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756730520; x=1757335320; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=FK6SIMwDcnCU5gP3tiXi7e9hJkIJxpKf59MaQCB1HEUfu35RdhcUe2ytUoqFVL6irb
         ZPvqshrSQflgiUwv+pDyUCSgGFg9qR8sq1MF7j+nnebO1ysGEJjzWoWgR7SBCLnHG1Zq
         avkNZn6AoYoCsUTzAcgfENVgSh8tMt8D+fTauoI2LqGc282NzRMj/59ypFGT9wMTu9/w
         /B8JY1yH6p4+8tRZj7J65W9Q3BPWYeB/20km5bWWyzAKhLHKTMQJdljDvytFsfnoJ9Je
         qDZz+k//bwhT5d9MxMaIZHuIO5GyBw/DNqZR5+rNTcshmMfD2UoAIDCjwyo5ccW1wKAT
         YSfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730520; x=1757335320;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=KubvWu1Q8MFJsg/K8Zdt/jv5mW438GsS7JPckmIfSmNrbIZ5P62z5QfqX4UZTUILSk
         93b9v3b20EmHCS9u7PXZjEkJT0m6RXabwUETvXhgjirT7S7m86FbLTBLL4K8pEgkBphH
         7S81U6nljnr4dEmY7GCdVa0lP1L+7661AkAZrOLwrBj1CtXAH9ctDvKjOpGIC2c8p5mm
         3JQcHyzKgjsYe7zPdtCrmB0jd+dcjnhgZmR7Acnj4NFcnq26NElS7jkRu4q7Z+Doej2i
         clYUaoqmXD6qXXOXpeE2/9hrelQRetgbAT17VYQjvZEwUxgqaj3CXxYeeTiwWl39C1ia
         haCA==
X-Forwarded-Encrypted: i=1; AJvYcCUHk0gSnL0HLRIemhZgobooft4vCCaeOvEleRwp/N//Cmu9lHCH/i1qS9KxjNvqwip4UZk37Mw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrGpyuBrWZFolZKiinO6j3+2wvaBCy4iN3s0CKsUxVKotms8Jk
	UZT4GrsRZdcppcSt04ropKndfP/XtUpLoJsI3cE4GgoiY8ycX0sfz/OoCKku0i7cXFc=
X-Gm-Gg: ASbGncv2k1pIWn/e7xaO/Vbqb4OWOSZRXSz1w00031WLbPLCkmBzensgzEM7/epzsKM
	N97A7fexKqc34AyJ5mbYdeL25jaGAbkEKnqtpGA0FrIOHVKnj4QOJPl9AE0hvXkRuXcSZPn23op
	EoYZPFVAcCVCZ0EfXtsUL0iryGn19e8DVs/TRqYqBshNqGD9zTQoeEz/+rPXp2wx46PCutU5ymh
	wG19Y9Wb89aidZfDhpq/rRJJLxw9ANMADIJlZfX+ufNgdriJsf9pjxNRpemGOcGN0k1M5KeHdvD
	/xDRVwyrQ7dOkXQkM4ZdO4oZp5kEHbJngvpk1UA/IhWVm/L93hCS4mkiqUUQ/KMZXDWZV7Jkufj
	yMRzgx4teQM/4N2o8C265NNUz02kVgSUnAXV4nApRSg==
X-Google-Smtp-Source: AGHT+IFPTd5JV8rlNw+el2iMeq4VwQ39O/JeQnoM1FnI5OWoImn9QUGVjCoJJX8IN0HGzcTQOolA/Q==
X-Received: by 2002:a05:600c:4f89:b0:45b:8d2a:cce7 with SMTP id 5b1f17b1804b1-45b8e2ee782mr21104445e9.15.1756730519938;
        Mon, 01 Sep 2025 05:41:59 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm154946315e9.19.2025.09.01.05.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:41:59 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 01 Sep 2025 13:40:37 +0100
Subject: [PATCH v8 08/12] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-james-perf-feat_spe_eft-v8-8-2e2738f24559@linaro.org>
References: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
In-Reply-To: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
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

