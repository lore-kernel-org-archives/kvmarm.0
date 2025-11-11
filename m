Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455E8358D34
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762861116; cv=none; b=ij93OpGHkbTUagzSpHXI//XDvMnJircHiEkmzlr1YqI542T4LHFJL3EhmcB5Ixhr8no9crGt+i0tj2ucRlm9fyAwHm7jAMcJeXKNZJbq8yruFSad1vpEcTXiRu/qpGYeAqg4ld3W2KFkcqnBHENzStND7LowxpaxW37FRD3KdEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762861116; c=relaxed/simple;
	bh=x95u+IAe5V5q3kdJyo2Q7B3yE503oFrO1P0dSeyIme8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K66k7BCWZWqnCXQXrBnK+HfHz+dfZHFJX38wammd/VikkBOHyDnJ75rf8e3dSMPa/wzhBUtdIwyNg+tBVmEE4owj7DoBHIGVDD/NCFit9S+WNLoI495H/fuIDoOp+0oDFpYXtFcFB6NOitZrIjuPe5JoSiwetmCZ+cdIUs4AkLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QVIAW4U2; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QVIAW4U2"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47778b23f64so14811275e9.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 03:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762861110; x=1763465910; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfuWM/BYuIKRAqpYoUgwQd7cyFQJ3HADoloFiEPlZDo=;
        b=QVIAW4U2CCcqse1NXd6/JF9lcdSwPsJ/ObgpLW6E52S+MUPkzBAbCupi6fuOX5XAyH
         TJ4rtwtFi5u1BHG1pbqSvnUxhmRMIlGOjHVGa+BO4AckgIGocX4oMzkbMsw4faezjD5s
         z6PH5sMTL3REFofHVi+5jmtM5tGNexlVXBZvnhNFOrfA7cXYa2fjxnl6ghp5GNQhtAuJ
         jHYYXcfDBiJ64mIdkE/DSiA3UZY+ExXrRj+hqWdzO7Yur3PkYmgkeoy5ab+2ZIFj6QIt
         upzsDHEKuoxgiphEwZ8uhrwGbPH5ZZ0qGtWfzaJ1MZvFMNFHmKy8TJ5hDfpQZtSwybyd
         6Mkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762861110; x=1763465910;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hfuWM/BYuIKRAqpYoUgwQd7cyFQJ3HADoloFiEPlZDo=;
        b=XDPjuyq0oobpMeIpjBd9/h4J6Mi9e35J/6fGZ8J+kAYsVIDzJVfroa1mI4mFH8l62b
         gCcdi4BA9xcDzRDzg+Wns1bWI3PmudXDdhrvRorh42DLNaE3BS+zjt2tbONZqC6okp1W
         BgXhlvKNXbineYy/VoozbZEkHWeOgCQ/Ql4HgdAXGyl3danuGp0oFS8ysXN/BYw0q1QI
         zldnMqjuxmR5vJR2qRW/rV4V+Jiqw4N/kUNZaTyWveE5RU6iiBT+ugCDlCwTrKWIG4qm
         j5NdWeN1hFNJ9TEDjYaCwn9srBkBA9HQtHGyDqefKZyDAM7aRKqm0RMs+l+5KG15LuHW
         K65A==
X-Forwarded-Encrypted: i=1; AJvYcCVNmVcr+vkLKeTzOKZH/xpKGBfdB8WxVynBQRoTbL9DYxLtdPgsfviEAtE+OjQ31K2SyVMrs6w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy33LojACpxZIBjqNbH6ItGH66rlI3NWiBuIbppAtOpp3XNhv4I
	HD2AoYdNRkaYJ2aJhIxYR7+ps9pDbRY4NHCGa/380GFRd7nkdCasaRCKpwVg13FviBQ=
X-Gm-Gg: ASbGncvcHzqCFkXAy+AyBZt4cBw0CrEsramBK9tkAnB40hTw1kokvvlhvTjiwfFou5p
	asxzEfkAdd7tYVPBTQLHRFqIDD2JHx3wz4P96pMXXlnCRcGQ0xnHUs0xPECJLIOlrRiT6oaB7jJ
	IctiC71StZNvARXoimD1h47T+0vHA90jacPO1yUWRj2ySp+4cp/Rhf8KF19SUBuauqS5ISL7TCG
	6QH0EpGYriw1gTElznpchqfyBL51YVAkeUAl7F3y0f/ATXo99+z2LhTCwikB1vh2b+VoVkvC9sY
	m+alxNS+0d41qiLMcePn4pxiJrD6GTsIKFwZHojSridbaEleCQXY9G41m0iVfcnArFmUOmEOJWy
	AVfOQwaMyCJb/bcwtp7Zm2kjsj2sd18QIRMWULvM2HFdy7mF8BoCpIHmvJP8oQ89OZ7LPSuG+Rg
	zQ7xNP+SGAXBUS340jysc+Tevl9+ni6hE=
X-Google-Smtp-Source: AGHT+IGYPR7rqVbdbF+k3EWMkcQQ1XUolXYoeKsYoPvyE020LtvRy4kS5z2d7QV4g2hQ3KZfV9KU5w==
X-Received: by 2002:a05:600c:1c15:b0:477:7c44:c0c3 with SMTP id 5b1f17b1804b1-4777c44c1e2mr78464655e9.40.1762861110374;
        Tue, 11 Nov 2025 03:38:30 -0800 (PST)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675cd25sm28133486f8f.22.2025.11.11.03.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 03:38:30 -0800 (PST)
From: James Clark <james.clark@linaro.org>
Date: Tue, 11 Nov 2025 11:37:55 +0000
Subject: [PATCH v10 1/5] perf: Add perf_event_attr::config4
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-james-perf-feat_spe_eft-v10-1-1e1b5bf2cd05@linaro.org>
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

Arm FEAT_SPE_FDS adds the ability to filter on the data source of a
packet using another 64-bits of event filtering control. As the existing
perf_event_attr::configN fields are all used up for SPE PMU, an
additional field is needed. Add a new 'config4' field.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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

