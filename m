Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3EE2F745C
	for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 09:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755163575; cv=none; b=NUiJEm0UjxYpHP0rNXKberJR8SXjPnuZOmDBrGvT15IdNzTJy/jl8a4BxottjoLFN9qhtDn+uIYxAIuEgBvqlfG5xYwczWuSwlbnkbc1uVqIEzPLd69Kg2RIZAx4ZePH8/FQxvAt2P6fquyMyI9l1OzKf0CDx39TQrXarnwgYt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755163575; c=relaxed/simple;
	bh=b/ttJae4xiEHONrSB61gWYPCVcnCnqIpQyNKL5V/Pqw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UBvfS0vMeVxQ9ZY5ZLNILHrudlErfHkYMgQtmklnSSiFWwkWM6qhuUJ4pLrTQdgREwuUGrD8Gy6b8FpCY599kZvpN2oQXS39uT3FBxSQgcpbzVWzgdM5gyVRr9itb0DqBqQq3Dz45ct8f7AbxIuZIt9mhlTqa+N8c7DjpaQIW0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q0o71cax; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q0o71cax"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a1b0becf5so3233345e9.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Aug 2025 02:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755163571; x=1755768371; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=Q0o71caxR/ROFZZ/INfQf2wTeq3W5eY6E9hfeJQG0i+MTWmwZ6Iqo+QnccZT3C0bOm
         ffHXBSyZ4j/wDpEvXgFMIq2fDW3keAuaP6voDUvsn5IK5ZyStVnbmMZx8RZ4/KQwCsZo
         av4xxBoDwN5vARwTDbo+XLpVvXnVQQxrn2YyQe9eaqy+BlF5hILtbvzVbprlRgwJR9t6
         ax3WNXtH131tMCWSBWdUa7yj/CyuS8VhbxcIP3/Jw9folaJ42/J2/Am6UKX/BS3r2kZk
         hV4whHDKqtRMVFD9aPggks7AkwiIZO/N9zxOfpE47pRHRCWgnou/FQUIDJtKCJ0KWqCt
         qSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163571; x=1755768371;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=i0nrn2l/lIxhGIiAxa8CQhueKOu63ZbJWU3WhYZGKmwp1dkOJl5O0S3wOg7iIdOYzc
         5zX6Ia26sDr7jfbcHXqdcpRwjW1BRzCFh4W4uTILM8PEIB25EkN6MRn6ycMxsQr5c1EU
         H4K53kgF/GqQysvG341UeaH6BMaJa6Rp0mAm/7wApxcqNwXVKzOtqQuqBPfWKaHQgwE3
         SOAxHSBJrS4u4/dRTXpOvjEZf/q3kO/ktrjhgDAv9m0Krxxay2oUVw3hnkPdio5n15Gq
         pADmgDCtFVPgLO1XdBTDtSB28OBuhRURrA1cHLqr8GMSjexcTPJHgHFW1DcTIYR50FMz
         MeVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHQj6p0mRMjNtUGpGqIXRm7OQZjrTh4GtaSR7ySx6pRk6jBtuZAy93fjEd9kL5VPQmhQ92fbU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVuVLUrG9VhFCZdglV1YQQs1vW/DrGsV0+nqTG85RAr7kxVzcn
	xYoIuZmj1qd0ISKduhxA4INqb4e1w9+IHK6iCYVbPMnI1eNZzNnh4UC3ITMKFPevIdNdauqQVw7
	naF/q
X-Gm-Gg: ASbGncs6iQzpTNqx24M9U8waKwhgOvN2Mjd5NtsZk45WI7pvQWtHipKRVDVvCi8QL42
	ftyUOfTjKmhlHRKc2BjjrSoazEn4FbQ60+KbJM2s/NGsXU50eIY1vG6uyuPKNt7iF8/a/4nqMwu
	dSf+/qZ17Qoi3bVNkcI5Iyhzwk6IGQzHL9I4QJxqaDwTPL8V+mm8a4tDrd2JEuCb76S+Kh9aIUE
	ogMMQehYW7sf5425ApPqTS9esqN3s7iSljkgu+GYBZrr4Q3BMZ0cEb2djwB6J9U5xJdEBSqXF2k
	W8VQn868i9Rtt3aNxdIykKMs6pVulcNHhzOPmYSEtRktW2i4HEevcvoUe40KUS53hlUHO+EyKAN
	Dr6ulBYSwrtUmMS+HhE9C6bTS5iuIKaE=
X-Google-Smtp-Source: AGHT+IHtct+umesyv5x7r2OiRVf/2g4YUX/d+UTbwfLkfG/5sEvYEqn1B72mWCeZftKk8wn55AxWng==
X-Received: by 2002:a05:600c:3543:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-45a1b628566mr17809305e9.13.1755163570902;
        Thu, 14 Aug 2025 02:26:10 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c76e9basm14536775e9.21.2025.08.14.02.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 02:26:10 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Thu, 14 Aug 2025 10:25:32 +0100
Subject: [PATCH v7 10/12] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-james-perf-feat_spe_eft-v7-10-6a743f7fa259@linaro.org>
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

