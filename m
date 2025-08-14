Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37EE2ECEAC
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163572; cv=none; b=BIINdrW16aSBSZStCzgEEKZhnXaxVHDU9FlireJ+aPRDtdmAvBMDtta4V0GcYR/68bRvUr/cQDBA8ZbVVYcJKR1xDe1sZbtRUFXU+e7WwRfcEJBNXS0CBc4BiPsNmMfQBsK0G8weXVMsb55E7j0vTxUxeTW7icFcfa1QMYq9/gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163572; c=relaxed/simple;
	bh=3yjrpHkX+aMdTK90nxuOJyMh4ajXQ8n+rTYB1GAa/ak=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JeOktDfc68aJS2E/PqnaDVHa8EZnCZON9Jg3omzmyF4xZbUvTJIZ+rmGxkIwARiu9V0VKEr5pEMbekgHg33sIYlYq006QpskFwGTAVCjukkKRB8VJJGy1uAlJikZByUw7RglpDUb6SRLS/a1MBrzq9oXUG01oX6omvpubLqr4UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E0M7SFew; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E0M7SFew"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1abf5466so4566125e9.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755163568; x=1755768368; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=E0M7SFewa1Zhm68FERG+9PUB2afBeNHIy4adMJCog4sZ7x7sJ1XAuM2bVMtJsD8L+N
         91azVvrl20ISwYvSKWEck+aGPUOrIF1uizoh6TruFL2qsHdF5mh++ObvQC801fJAHfft
         Uh+I5pAXnFb5Zs4sl1PZzlNByW0F2YF/j59SIW8ghngGx7BYOJbTyQyxI1HHzjgfkoTC
         /7rWGVZooq0VZlnhkd0TM1C5IXqR7K4gj1HT4NHsSyNEytPhzYRiZGEcqdlmHIU49ZB9
         7vVpmrJXri86hndzC5ircj6m9BS6qd7v094jklHx7PNCPxRHEP6JWAoLpMnvgikFtanj
         kmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163568; x=1755768368;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=FSrjRjTns09N06ItQubDHIWHVjfwWsBapfB1xj23u/2KcjJ5plK3bLTX752WAGb4DG
         BmdAn08qkrbp40Wk2nkvYIvT415B8JY3Kn9UAIpaZhhs0BauhvSutzW8UgsmrFCjD6r6
         2WzuKxEfZgfAnNnYuNGEv0cVrd6BWM55c0WF+zRc1NypeAdjSMT/fO4Ym0wb+9zFk+Sn
         KE6gjCEcALNvsHIx3MEnuhq8rt/bFuB8p1P9vljEU3w0QJNrc3mrNJp6aDYEzv2s0df7
         1tNANqaQjIv904IHYMG/GULe/ToW3FoFJtiay2sjC+y7pCoSRizy5TIjYN202PfOPT4n
         +Fuw==
X-Forwarded-Encrypted: i=1; AJvYcCW5ra13CcRBEnC8Bc5LDM2iJrOgonoD0Po7mqUZK4k1SIcHgf/P+gvrBQpTCb3Fh02Zkw11AFU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2/x55ercNGDUt/tvuXmPIyELfAXxknFaotV8kNzKyJWxbeqEQ
	r7NK8rKPVYAxXaPn/A/0kox7vo+rLWEQkfn2TqhSz9j2a1UOiJpuZ8HnncSoxrIMJEzZocsefUn
	FGUzF
X-Gm-Gg: ASbGncuPZJBa2qpzqf9craGdqpJD6Okqj1daEdslxCsLYuDqOAda9p2sZz2HQvchKYG
	VbL8Rs4m2pUzM7HXbY210o5I2jFsiHc1Xa+7gaAvWpi3OFjKDht9t4ZjSIzqK8aHGfvUSEq9tHq
	1VHWqjUG3/QhAyWkDiUy51TmYY/lUQ/l7cagQaEViJ1oaRSOvq7OKG/oH56n77TIVkaD0jSbA2r
	DzFq3FE12t8WBDaFJRRYuvaTpRWOAKzLeh7sGqUqhtIjjSIGU5NAMApJJU/zxi8nfBkXFCyguWR
	JR0//qZbzzDtB+SG8P9saj9S9c7n8ZWRnBuCfYjQnvEVSVSmrtYcMULzKhKjNFNynHbooxLFYag
	XAUk/4JCV9TeKHTTc4GsGPa1fAGAPsYU=
X-Google-Smtp-Source: AGHT+IEfiNAJpBqr1EBOXZKivbX12m1SjqEMe6qLmXAWuSO2UYgUUw0TISQjYJI+9nhScFZ8SMs3Cg==
X-Received: by 2002:a05:600c:1d04:b0:458:b8b0:6338 with SMTP id 5b1f17b1804b1-45a1b79573cmr16522705e9.6.1755163568201;
        Thu, 14 Aug 2025 02:26:08 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm14536775e9.21.2025.08.14.02.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:26:07 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 14 Aug 2025 10:25:30 +0100
Subject: [PATCH v7 08/12] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-james-perf-feat_spe_eft-v7-8-6a743f7fa259@linaro.org>
References: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
In-Reply-To: <20250814-james-perf-feat_spe_eft-v7-0-6a743f7fa259@linaro.org>
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

