Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16392DAFCA
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103124; cv=none; b=nwtqFjnJJBmGs8I+z4aikmkdq/XleJWMPYgS2aSjiefqAz2ox9/+p/dvnaBdH5qwEUiJAlUapSiUyowW4O/prYGo3GRFirwU3j4g/nXMxnblvFjot5V2rdB5TUUgx2gOJ6MDfxHiAPdBYb7PCYqAVlH8y3HhRdRK40ryO0lvoiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103124; c=relaxed/simple;
	bh=3yjrpHkX+aMdTK90nxuOJyMh4ajXQ8n+rTYB1GAa/ak=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m000w5Z7mAmXMggbE5jj4ny70B8i3oU1OY2ZsM57sLPRJSUxQcSxh1QoETZzjO/9DycyxsTp/h53icVMRVtmVrp/mhrvZDlZUWdpLkA/eCP3+4R3qLjzZgrjzwG1Xrp6kIvDXdhzwtWngwAGi7AcV5ba5M2keRwINX1lI0L6KyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W/ZSxIJv; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W/ZSxIJv"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b45edf2303so3995570f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103120; x=1753707920; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=W/ZSxIJvdIAvh02goBQYH8vuwMh9ntGnMbdvV0xjhsF9vMH01sovr+nEc7hJR4L2jE
         1bToGG71K85JjWMeH3YdVePSR+YzHVPwOsLtfhLZQ2P95V21WeYJHr/ONnQenorSeSls
         lbOizIu2SKKQZhk6zVPOxexDA30tXmZipdabsxbJ+Uz64YF/9rRJBFVkDa76uP+AA8xR
         Btm+uZDPaeoAUIMZNiBeM3pboRJDTX1d/wduyoapHc+zz/Q/8httpD3if5+aj+ktIDbq
         NPcM9b90QDFHcWmenmJZm/SMZ/ACs2LwUXX/EuGaZeatn9nmzFPAzMk7HX/zQX4k3M3M
         uBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103120; x=1753707920;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=h3YPM6wFEqXBwk2czCBh+nGqygNILfcu490dCDFVBH3+hjNloY60R4G8CUKWlvBbGF
         USZ69dVBnrJwvz59NSGFULai113NQPw9so7QjytKgVvkfTebwx+tCUai4qy0OywWKk+z
         Brhu4f+AOS81aKV0vqPCQ8a5fZfsAbIW0qBlAtWgqXUx8cszP5wx84lGxiTbOcEc+jqv
         tS2+TaTwtSqXERoytZ+3eDiGlkawHT6vEUgq/2Xa+Wk+T+ZV7e+Ijfh3bCixM6AyycTi
         Tmvbj/x2R3bQflL2WzB0gm7uXQ7rHwh6XfN3RRasNplX0y7pltDsnwTjfkTedguM9LL5
         sYMg==
X-Forwarded-Encrypted: i=1; AJvYcCVt9LnFH8oJpCH7E4smCoHdudGSVM7SN1zEiM/Bw1IooTHINKtFoh1NWNVYwQuAX9iZq/dwAvo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFKdEimunZ1Y8yJA1HdpL9bSMfdpzqnNijyY8TeFNo1K4Mz3QE
	qhu9oBifarOGLYaUIA1lxaaFY1UWe9fDGqWhVuKRqNfF6UPo3vxGMNjbOOhUlYuQwUc=
X-Gm-Gg: ASbGnctV75S6/XD5QVO7AW9Uh7GUZwWbxhZ/9SN3W/cx0/ynHudnB4qHwSbxkmjaSLC
	8WynaCqSu5eIumRc9OxhaVZDBwGJddoA9m4IFVdrXKz4rOTgdA6GmWYw/jbmlZq7Jj9oA0JYvFM
	3kYJzO8u9yfNXudYMsfUeqjNlu9FD6znGM9TM+UvkLaOt7+9rDdjh6mWdQUoX7+ENux1n6POJvt
	OoWe5cP112yJojudvwENLKKFpreCibVJNm5RAxENYCpge+buRcQptjgz36mJVACPwkaPWId05wi
	7bPQ262iHxKUFsLXztJifUmqOOBNMyIcRflhMnQCd6/od7CMh+zANkuuWg6SxYV7bOSEp6tM5Yd
	7EcUjxSf7iYx27/Q/ZRjuBTxZ6Ijg26g=
X-Google-Smtp-Source: AGHT+IHcC0WWzrKqr8+Igj35NnjWFuFj+8E1KaR+jWoua9xbcKUEBeLY4nnJZlnbhkk4+Th+Kwau9g==
X-Received: by 2002:a05:6000:4022:b0:3a5:300d:5e17 with SMTP id ffacd0b85a97d-3b60dd731c4mr16367288f8f.29.1753103120265;
        Mon, 21 Jul 2025 06:05:20 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:19 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:05:02 +0100
Subject: [PATCH v5 08/12] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-8-a7bc533485a1@linaro.org>
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

