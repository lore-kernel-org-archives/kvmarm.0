Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23618358D17
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 11:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762861119; cv=none; b=R5WFM8ffCcEThvpU4lMhia3iIqaPKSbFS9HOwUi3v2IU4gRqBS9I6PRL9cno4pMsZYFXoBz1QyAoAxOfDZ9i4XiHrCDm1fa3d5AmvhxQYsRFyjBBMu122wtPJ0gaBe/+gSq640VUW/rQAv+o8y9dRE8K51c3ZaFdsMcUpc+M4XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762861119; c=relaxed/simple;
	bh=b/ttJae4xiEHONrSB61gWYPCVcnCnqIpQyNKL5V/Pqw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I3QE9m2UQTDFNP0mrncsyxR7+nrZIaFLAFagjynUDtyg+Mxwf2bujpoKZ9snDvtu0xmsqTM/DYX72mclWsrwZgSz/+MmCNvathrf0BNSWUUOD4hsiBApX68iS+KWEessTHnEJNWvSxz7wJPJXH+eFKvgziqXrUw6fW65as+4xCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xkhAyHCi; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xkhAyHCi"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4775895d69cso21297325e9.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 03:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762861113; x=1763465913; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=xkhAyHCih6xc/ifUz5Zj0E7SkdV27EzzsUdO8YfEp77BZdtLHGMHjlRh+zSXWOdLtK
         HWKBnHJ6Zy1CFD0KdS8M+QG2EqGDP5k0ivlmKyf/PKgGhZE46ZTpZcAPOVxSIHD1KhTc
         ZvWjPeYg/ApyjFo5S6D09KifqTGEvJLuAzo+bJYQzEjB6LVMmE9Vx0D8a+e4cokbtU/6
         Q4Hm49snxtc4qmCqk1MU61jXC5EXPrrbt9K3qbn8bRcdeeue1nM0sFooEudgIdIumZP6
         GCkubm4lTZJ061hFZr2dfD/7yq8B0IoYVe1CSj+Tt1UQlnQeeT1t6KTk2ctb+GtS9itc
         38Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762861113; x=1763465913;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=duY9rS7DbGY3dlSQ1LLzEXtJCepB/VRfhn8qO6GiFxrAc12NAzz3l3eiCVN6Egqqb3
         8H1pCu4/F1WH75Vr/gCn5PPC8GTRHQDf8eaQjTSzPrQQOHezpzXdt/lMCsOBao4sdTVT
         mx2Q7MM5t7hSMc6/a2ueB90cSVfHwJ+JcIvfAfy45hNTy5DKMxhN80GHU5m/WIUBqlG/
         zOzAjbDcTp6Z8wsDVchFY1U4qMzt7rA+ikxKGQa6k7/L51QRgyAmWHx24xZI4Dz+bxzd
         RcjXC6Kkte6oxJ5KAr0YoybdLJLNqkq/oVaYXORyAIKBLb+/oldvZlXuydOZbAmAdk1h
         qdCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXtueHcsQAM/1wopWvmMdprnQU7Eg5GGI4NIM+v2x4Bkl0Ywmxvs7h4QOah7/tQpqf2WFeiq4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzl33xLqqtG+gWIO/pehRvE6SVcaNPfklP+c6wG6svlmpuNrKkT
	NC25lck4qXkIu0eh4XapexYBJ59zc1ZYEiRC6lSvYjXO57e/SYB1UR1jmVbgPbc3UOY=
X-Gm-Gg: ASbGnctmWC2QSM8z6h/Z5HFoKbotdp7Gzg8KRPC+PAjSMmJQVHPGurVbMCPlR8L/fdB
	0HMqv/+oEtIWVrd4RXqXd8wU52nT8mCQTpipbk8jAXkMm+GTgUCHakFFsekY9OxeRPtNueaQVG1
	O+XdVU5zd/BZzEuOB6GjOX8KH5QILiHwHmxEDoNjmE7Uq+29s2icbxnQSREkPqX3fw9LCIrJbwj
	0m08jz8BLlXPfJb2XnwPt3raqJhwDxvpZhlpxyAzwq2ueV/dp1AbgZX1yZUg+QzwSpBvbfl2of9
	DhcGds5SogdwObAwEBPvPnSPFhHGGhfZBV4g1sK+25908+NyejbtAXUVWUIhjY+SpT0qJ8pxPc0
	ZAA8kbOD737ZBNfYMKt0ihUBL4BN8D4yDlZdGyPct7Z0eGbCnlB3PFRd0pXvcKiB60Gk7EdRWN8
	Z3zQ131cBv5kZa5fVZfMtD
X-Google-Smtp-Source: AGHT+IHHKYLRfVgN/W/e843ki5ckqj4gtDXuwTA8cbEV+6RFtEvcngH3q04dA3ZvJO4NaiMzNyBD6Q==
X-Received: by 2002:a05:600c:1c14:b0:46e:4246:c90d with SMTP id 5b1f17b1804b1-4777323ed28mr117807465e9.11.1762861113334;
        Tue, 11 Nov 2025 03:38:33 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675cd25sm28133486f8f.22.2025.11.11.03.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 03:38:32 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Date: Tue, 11 Nov 2025 11:37:57 +0000
Subject: [PATCH v10 3/5] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-james-perf-feat_spe_eft-v10-3-1e1b5bf2cd05@linaro.org>
References: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>
In-Reply-To: <20251111-james-perf-feat_spe_eft-v10-0-1e1b5bf2cd05@linaro.org>
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

