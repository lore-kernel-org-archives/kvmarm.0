Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E97275B06
	for <kvmarm@lists.linux.dev>; Fri,  8 Aug 2025 11:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652238; cv=none; b=KQ3bXvAwssAek5WEj/xSAY24vx22IZqV/9oyBg2sE8wP7c3NPIKFVeeSUSEnG2+giAstHyqES6FOnFgck+LKhodR67NhjNkBTW9wwMCHuQGjMfTRFrlme+YbNDspwgACzbnI9I+kIo50m4E2VTkQlxLw/ndHX6TS9mZl8MzZ5zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652238; c=relaxed/simple;
	bh=3yjrpHkX+aMdTK90nxuOJyMh4ajXQ8n+rTYB1GAa/ak=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iKXCDcGDZtb6pEVYuXBXQqHwdMj3AE8sNhe7MaOWi2pu5ltXzlyzVIX53OU1Yhfst3e8u+Q5uC7HU6RMuak3OO5qMIyJ1zwxsVsL7C9A9+uxGE2BWWjXWbaiaUAD3s8WrtrTKHBYOAS5bzU3I/u82O2SBPOToHTFz2+I2p0gKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZKtsqjHq; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZKtsqjHq"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-459e72abdd2so11626355e9.2
        for <kvmarm@lists.linux.dev>; Fri, 08 Aug 2025 04:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754652235; x=1755257035; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=ZKtsqjHqMg9l9DxFPizrvlwtUPB1LsnzxPIPQlc85ZxNWRzeBPCK123BpAs2q+JHII
         EBV5uTdL3VGsEAnb1eHO91oMMj5/kbVHVOQ+XTEbFr1/uPji4qbDE/uPf8Khg0wePj3M
         9LlyXrBhgV7qKL7XDHVbi1jYG394HCXgCvxs2k/WBqs1P2YyXeR/KOX8js1fPl7MZz4b
         oMHzlsKtbGpqMZzofxbVdBrH7UQ4MxkZyOskU51r4BVMdqzuICjAhuAaXbnXFYoAM1/G
         g1Jln8VCySnu/BbCwVkNAwQ4eN8xLUgGyzZEdvDeEfONpPMzurY3PjJtYS+WGVsaFw1O
         VvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652235; x=1755257035;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45z9IaVf3DvIHNyRK9bNlm2YHb8XHVPseevdKZOW65I=;
        b=iSZC9W+sshhJ92M6YfbqxQgiuhyi5A7IhTIBBI9zG8rruRk9umKu8T3hkRxVbz+Ua3
         /NhJ4vxVOIQ1hxBqu+G6oHFJLtuyYYGkFoUkctvirNHBqIMV0sbC3gqI6gEdIhzqRGCs
         aDVSbzxuHHELnLH5VyRxfBpDb+jmaZqCqdzEjurkfFHfYzZNCJk8d9QO3Zv1zcLBQ3I7
         BCPC9qxnU4PL7hX/XsUGQEF5hF3kH2tVD1EGzSTP4X0YrBhIpHhd0dsY63yKmkTnpo1R
         MBLa9rQ5UdRvmoBpuNj4QT/zacFZcgRe0R4wt6eX7706JfML+WeVI6zmP0zDhVGAs8j9
         uzlw==
X-Forwarded-Encrypted: i=1; AJvYcCXt6PSls1BaKjCr1K3aLH2DWcINk1M6O/RF2gbAxL64Rcr4A2pDXzzAiokGpLzYl/WcVT6+PyI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8N37asBHgvKKIAidjeY7qO/CND5DFRHP+Q4qcKduacS4nMFDJ
	cobFxb0dM6MVXHKftcUNh9Enx1UBEebZiHelqyS92SIo8/mKSHJJcvuO3GkamkwvH14=
X-Gm-Gg: ASbGncsn3caoz4wrsBviEeM2mMhslm/VKelxNAUESrSbEu4g2B27eTAxXX8VbFaqFWH
	idIR+W0El8XsfpNIU3OG06jAVpV5aDh1gJCO/mfsY54Dv5KtNOkh5cyUgjXnAY68J30DVsSwuy9
	I9Vq58tnKqvrdPwEB4L61gCexgQ48Op6nNCJWRpFg6dtBh/YnjHooVRCflIN8BTOkGUXmyXtDDN
	uzaXC5J06TmMtCYoXfxOB88rKmIC0DVGgYW2MoADoUM5yMHtPB2XgB9QX6QjCOWum1QixbQ3KLb
	lZgymlRt61jonBZKSr8XzGUu+nH1vo4VCSxNLtm5b/l63awB/W1cmDHyiFZIQS87tnVFASqaXgJ
	E26BtiXoJ3ikzHZbrnL3H7v4S4sng3y4=
X-Google-Smtp-Source: AGHT+IHOQ18gbVsDEVyKCfZAIEJklPYVqKw1aZ8vUXtA3WE+OW7IGcXWNxJyWSMYhUVtrh63ytt5Fg==
X-Received: by 2002:a05:600c:198c:b0:456:13b6:4b18 with SMTP id 5b1f17b1804b1-459f4fc3a9emr26503515e9.31.1754652235388;
        Fri, 08 Aug 2025 04:23:55 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45923c34af8sm233482635e9.24.2025.08.08.04.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:23:55 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Fri, 08 Aug 2025 12:23:05 +0100
Subject: [PATCH v6 08/12] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-james-perf-feat_spe_eft-v6-8-6daf498578c8@linaro.org>
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

