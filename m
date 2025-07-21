Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62632DCF4A
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103127; cv=none; b=nwUvgYRzcDdnQALbPffuE19vmWDLs56mOkEU3A4K7U3+FEzDBbHtBZnu3qEVQbxVSa6zYapczvlaLAqSbIjME7vQDv/YTA2H6iiTxLmIbYq2lcG0j46bWPDW1k83VwINt4ssgW0mRp2jfP3iYw+YZhoAiYbmWyy7aw0mvrkHwjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103127; c=relaxed/simple;
	bh=b/ttJae4xiEHONrSB61gWYPCVcnCnqIpQyNKL5V/Pqw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N/fiEXX+AJmFb4Iy5eEp59qMjQ7V0j2keY3EbK3fTPBfWEIeNEctzXC54LUQdm9HkimUW8W6LXjovhza/CblMUmyXFUMPcFlyrZaNB2UbXd5ma/VZiDAX0wMOuAhStM6dM2SXvmf71htT3fnXdo/QYq+gIceG1I0rUvbwX9TSfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yM7v7tPk; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yM7v7tPk"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a4e742dc97so2786031f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103123; x=1753707923; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=yM7v7tPkv6WFVBZvxCKw86oPaAdRMGkDqoXrS4Hr05CvXvjNguLEo5Ljt2E1FcJvi+
         EmpBvXMBPqz0UzlAYOCwkQIWTkQX17CpoigQpcE/7tW5SHAOyIKFfS4GDVKvlx8XQCfA
         Zy/+TsY8XTu/WyNOWlbAIP+uOr5DPRcgAZNViLGSz1gEsG4L9bdUPzAuZqTiJC3h14KI
         TPvVmQFojdr0pRHs+OoBN5UEDYBu0kKpzEyymzfuy3tWIw/om+w/vXF/RnDY+OfljG9P
         /UADU7AkZMyT+bQT1O78KQOIsmw/XjZ6XigkP19xLdzW72UpBTkapgRoAZ7QS/TAw7+y
         IlQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103123; x=1753707923;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=ofR+zsG326OzhcZuT4mMVNiKzZzs3tp0LkqPu7LsuZ9wgUlCTJBqFZYr6IXdNtZSIH
         KEZd7eMvsh4R4f02dCPTrzDeFFVdHDpOBBocrznMtLCQ3TZstZ9k/p8kaNs+jAn/ivee
         Kzpf/uRS6Zz4qhL9DKsKdboBVC1nemT4m0n7gaHAYrbaxhu132XeBwPTDk/kklZsT8mr
         ppZpysykTQMpC7pUEG3q5CZ8N09ZAh8Ik/v6t9A6tT3KBKwm/HuBnqzbrnHc+jAp1TIR
         uXGqw79pqUei/zUvucp85Y9mzPgDKLURl5H2zmmV2fRupPbDT86Fx3Kv37pDimq+q3yb
         pfng==
X-Forwarded-Encrypted: i=1; AJvYcCUXKCka4YPlfP8r/ikjFMlL2QqbX70SI64gTIqMjJxkvzcx1k3Gto+l4BVCxHBZjHWbu1BNkc8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8NJQZ9jvPbhfJW3kMa1je8NE/kGfJro8BkIZwuhkG9asEVNZa
	SehF+G5iru9G2UgSyuLu58aOC+4uHy4pK9Bjbis4csVkmLzU528Yn5PZZocA9Qk0DHw=
X-Gm-Gg: ASbGncswsd4YhqkiXgQBLsKexD2VI67hEO+JVOS+bABCN5SCok6Bm6WibrTkwLmzyti
	X+cGlXaM5AclvhLgewH3gPDdgDoDEtnlh5YOzSoXwQ4gToD+b9F/J8HQ+vlEpjoBDSbiGD+eduO
	VyU8FyoXo7spWUKiFU7Y63f+zoIBOppkOGv17Bh4v+AatPbZhTWPNju0kfmcGvUPQXiGh09iE6T
	9rCnghdqR6HBQ26fcsF1nyl75r8wZerbyuWzDpY1mKo2fqJfkICL0OrJOpM30BgzZIp5R3RSK/M
	eycDa1yRlgPmCCrTgJOPXmOTKomu+fYd1WdbaOIBYg2va58GBQrv8yhF6G1qpB2WaBwFRZQIPbH
	w246JZ31Yf0ohLxKM0hDS3p0tEatsgx8=
X-Google-Smtp-Source: AGHT+IF6B+UvXtx0IYpruCvoBGXj7r+Qm/RbuQTzDQMBKY6Xx1qYG8QQ00o/M8y4LjQhDqQ1Ad7BQg==
X-Received: by 2002:a05:6000:25c4:b0:3b5:f151:207f with SMTP id ffacd0b85a97d-3b613aa23a2mr14510920f8f.3.1753103123024;
        Mon, 21 Jul 2025 06:05:23 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:22 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:05:04 +0100
Subject: [PATCH v5 10/12] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-10-a7bc533485a1@linaro.org>
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

