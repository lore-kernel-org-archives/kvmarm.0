Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94912D948B
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 12:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753102463; cv=none; b=ibL1DffSAtdUzeKBoPKVdawqbCJcmCD7RqYJzYUo2VBWIPT3GEtrKIW5f6jqvmAgTQguV5sOMeR4z4AV0gEZs62OWj1mO5IPYIbVSwct+MNPEa09W/VOXASseYyFtbiI5U+/tWJv7QPzSbBGYnlrTWDr7lgOtIXcQR08BX30ag0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753102463; c=relaxed/simple;
	bh=luIKfiwgtXeAFEj50ve3W9I2lyEw3hMNW0iXhyMCu40=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Uq57oUkLpVzg8iYDS8kOE5oJ1djbKygD2IUBqj1HKmyktgvBm/D1omo6tBYQ2K/MJBsCebv/RbdmSJdA5P9X+grY9jIJlIbLkYetEzgVeJwbeN++yZr/XifDRVYbR9FKTN2VIdS+ZvU5qdyQz9VdLNKX12ED4S01F3UZkjHlWQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cTJtHkfs; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cTJtHkfs"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4560add6cd2so34973725e9.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 05:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753102460; x=1753707260; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j9Rue6bPIg/trhgv/sEGIp6PJe+iLR+ZUbz2D5vC1ck=;
        b=cTJtHkfsrYflrJoOC15EvYqb8KcJBm8LPJcRqNlpiDDx88YaHZ4emls5Ea6mkgRef/
         bf0labTUjHCd6ZbsYU01dwmBzVJj/dehHd71Z2x9GY8BJywU0WskrJ9+sAoowkbeG9J6
         5tIeKFsL1KWV1p6EJVGP9s7/IVwvWWx8eOIs4dYISRMawsZMBIdo87JqnhxPelENVbqJ
         dqyEqyn8ptrc4dJfLT4xOwVNHZqXfr3dMVgeLFW3bejlKf7V8WavIj2TLThTl32RFQWm
         y/qSVfAEebg0V3aioc3rWXZGe/fMJPR5FnPcG4fCRMO0j+GlUj1rkwivxd8LeemcLd7f
         OkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753102460; x=1753707260;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9Rue6bPIg/trhgv/sEGIp6PJe+iLR+ZUbz2D5vC1ck=;
        b=H3ubmqD2fiBHof2Ct5NmmBTOZN/Cvai1Tzo1xj1iAQld9cdTDlFWWWjoy9yfqB521Z
         T0R7eYCjY1dI2HGO36FjQjZ3nWLjq0I9fIQlJ9nHz7sxX8SOmlE2UAHOelQLmTn3ngGm
         L8pfLRAFZMIrK3QBXRX3qSidtgPRLBHKp0k/DfFtmCHRgo66IEufgLKrnlyjBKlzL6fV
         klE3JkvKfnZHPvbUZQ1moa5VOndaPCvWURLZu0zb/FSzb1XMcosaMeXFf6tCPXoiL4jz
         dGcWg4JBN+2lr7Ksyxn4jul8lhUECrq4u6oMYAgODCooBxq+sqbrUVfqJxSnZ6ZztEwN
         4cJA==
X-Forwarded-Encrypted: i=1; AJvYcCUwsnX1oxaMCPtY6Y4QppBKIFAQqwlDs/xx3SfM40pWJaVz5jxQqyVXMrzOUiXTbsd5n+cO8Vk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYf6+3bOLsdOkPZFWIg+lNnmTz3j42bkhGthaHJ1AUabg3jiXH
	U3ban6wq0vQ+k/tBXCyGrUTIGis3injrVDYJNa1xxW+7npWP+/w2cISMT1B0Z8TjQYY=
X-Gm-Gg: ASbGnct6khuHJKZKvrS5YjGOJYcMMWEK0eG9TnpuqEi2CwpBpvz7bqYCr+AppO/MgMO
	5qjJAiii80WXmI18GtFgEYKdTuHGYP69mWxoU+oI0lVvDa3vN42/EB8EAidapJ1HjMm4PtXL/wp
	nkOF3wt3qXd7/bJq9gbDZSowEO6ruXNcTZkQu9tcg+WqUB1BzsIFxlg8zJ8Kj/41IJuzy500nxm
	mGoli9d+o7KCAOX4ZxEzescuAIWZyUMWOVnpIPfp13AoIW2ko/bRs1ZbP3aTLXTIXCCiTl7mnDn
	fVdpfUqld8tBpEWNiYNJ3Tm9ZTDNBPabwtak3b2sUFd1b3i86OCY7tV0JSUcZJNAj9SCsPPtrTv
	Rq0i5mbim604YoAu24TqQlfeLToY4YXqv0dm3q0TJ5w==
X-Google-Smtp-Source: AGHT+IGxBZUjqF1XoJ+We5sWi+shDrL0KCK0BKEfbRSuVRqaPLjbWwQUIAjCsxGeF4Kf4L6TaJ/XuA==
X-Received: by 2002:a05:600c:45d0:b0:456:21f4:a0a3 with SMTP id 5b1f17b1804b1-4563561a6c1mr160172795e9.5.1753102460225;
        Mon, 21 Jul 2025 05:54:20 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4563b75de26sm98995225e9.33.2025.07.21.05.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 05:54:19 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 13:53:39 +0100
Subject: [PATCH v4 08/12] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v4-8-0a527410f8fd@linaro.org>
References: <20250721-james-perf-feat_spe_eft-v4-0-0a527410f8fd@linaro.org>
In-Reply-To: <20250721-james-perf-feat_spe_eft-v4-0-0a527410f8fd@linaro.org>
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

