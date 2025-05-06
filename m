Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A1B221D93
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746531765; cv=none; b=ahdyST2CSo4YAUE0vDde991+F5x9vVgpi9EC7uvCh+53pcovvIQpUH6hv7BY4RI5e8sHYCqpFE5BXo0bpxDFnw/xFV/MWQb789jjrvU9aetZcXAtsoQ2Z/Yi5bK7+Rdj1ZS5g6QbAM5vuOrhdkPRs4KswlE47OBhY35azy4hpGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746531765; c=relaxed/simple;
	bh=1Orlrzff9rVR0JZWyMg++jiq5IsyuYfqKzNJU/EyCi0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XJNVzli1BkbukSK+vwxqw2qE/hMF7URdppbSvmxkvpY/XDQbPQ89//58T1CSpc/CgZ/zVvl5FQW7eajSmVQCI1m7xx6+xhyYLfJ3Pl2J2liYELH7BZ9224uoZEdHWjdjoDlYwiFrDgolFa2Hn115PRA7GvvH8C3iRmkU4zKIZJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TsLLCuS3; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TsLLCuS3"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39efc1365e4so2609301f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 04:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746531760; x=1747136560; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NIZcQ6bjIvx3LOuJqJtvWPXqPFlWznoYfJ+QWY9umw8=;
        b=TsLLCuS3lFssJDIMSE4XHUziFvKg7/u2Jm/+G96KKCxPKtea4ODaAOdcNTrPiCC4F6
         DpTHog29RB4iWugnDn1d2ZNpMvaF0EJLK1fAwdKvgd7xdFH8/TbSpn85XaQTVQepoJMC
         1SbCnySUJQV6gcrrRbHDbANRf9qlciQKxU9zL178rgorh38Xf9TpKXq651PvpUwm6YB9
         a1f9oBj1vIQKaVXRlHIvrnWjBIkC67thBd93iklOrxEyhzeP9xldhlws+gVzollpzZ9e
         TSTFOt1tfowSdBlwYERvC9nh0Hvrvk1yLl6bJkRbTiFn4t6FoaiyCWzFsz3esloqJ0K7
         w2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746531760; x=1747136560;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NIZcQ6bjIvx3LOuJqJtvWPXqPFlWznoYfJ+QWY9umw8=;
        b=MKe6dDYSjshf3A5Kr8saAumZBtpx4/jvbH/ROOmXW+c7gMoKXcxBlKXLAKazSXSza/
         u2VvopfN9g01QTKfZIB54MH/eytbYcCJA4Pf2g6C2gz2uVMthAsfCScZk3LqnlUtB5B2
         6ekq7ENfopj/J2l+H1VT1fYlQ8vurfFkBxdN36blE8Zut+JvwGgi3eW7FiJG/6c0GeSo
         W60C80NqXhdz88S8AQ4p00ddCUtOAUmue6Y3VoYwPlvHHYIPSRSyqeLC7N/ED5BG65rs
         qf4zzvWel/y4MQ3EIlojTbGjUTAwsvn7LmFS1hOpTtqexaM1VA3GmA4Xdo3yDCDl2JFH
         ZLdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTwKy52FZxXXpXjNS3NvbLwB2HYtB8iFMPKX4JQcmwDd9ROKah/91M7XnYiDXJxKsh7I3qurY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4IEuBcdY/adEHd3yveKmi/+HordwQ9lWyPzPbD1yrpg5OKrw+
	Z9scQkMKFrQgG0WktXIR6g8hNHnyYn5JN9hGWtNBQbGmrF4AeRpDiBm44LZmX10=
X-Gm-Gg: ASbGnctos8zMpgEneFNtoplKGDyQ/cbBwg6MnyZ5MYBI6ua3LnPA4p4Ov0ywJerGHjS
	VGizcMRXaJb3ej9mihvaL4tz3WagzSUcd6rG0rnf3Ndn4lCq3Q8QgItZDiyV5X/GlGZgKTiJlUI
	3Hu1x6HDuD1lcKhM6XjjmrxWD/g+3Z+0LNItWP4lbg+r8AggFoo1gZI0Iekh09mpW2ryf6wsun+
	ceTO7RiBt8G7czfMB6P3dis8/NzXvjQSJ4tYZ+8wmtBrJM5AF2tMHKUVNPlyipp64ui/xOUcT3F
	+0QihgXdTA4bx99/yNelBHMsRh9f44NQby8G8JBSZRSK3ZU=
X-Google-Smtp-Source: AGHT+IFOd1IsGOuUERaKBF17xqjJD9v+resYFgda6lTrrEteCoMMOKMSD17uDHezFeocGMqRKvBkWQ==
X-Received: by 2002:adf:e6c8:0:b0:3a0:b1de:1be0 with SMTP id ffacd0b85a97d-3a0b1de1dacmr1217177f8f.31.1746531760579;
        Tue, 06 May 2025 04:42:40 -0700 (PDT)
Received: from ho-tower-lan.lan ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae344esm13198473f8f.25.2025.05.06.04.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 04:42:40 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Tue, 06 May 2025 12:41:38 +0100
Subject: [PATCH 06/10] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250506-james-perf-feat_spe_eft-v1-6-dd480e8e4851@linaro.org>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, James Clark <james.clark@linaro.org>, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14.0

Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
packet using another 64-bits of event filtering control. As the existing
perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config4' field.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 include/uapi/linux/perf_event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 5fc753c23734..c7c2b1d4ad28 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -379,6 +379,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER6	120	/* add: aux_sample_size */
 #define PERF_ATTR_SIZE_VER7	128	/* add: sig_data */
 #define PERF_ATTR_SIZE_VER8	136	/* add: config3 */
+#define PERF_ATTR_SIZE_VER9	144	/* add: config4 */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -533,6 +534,7 @@ struct perf_event_attr {
 	__u64	sig_data;
 
 	__u64	config3; /* extension of config2 */
+	__u64	config4; /* extension of config3 */
 };
 
 /*

-- 
2.34.1

