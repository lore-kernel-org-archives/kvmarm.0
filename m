Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C8D345726
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752806; cv=none; b=EVcDRGWow0ZsA1GeJVjXx/y3H7tNID8qWjSGJml0eH9svpQYBsxnxJDPbfK7NNfw4fKhQogeVeNfARnGLS0ILmoyNHKBbO9NC9mJ82nvcC5y5zkERP5XH6Vvqyg0IJPJ647wE/2csRFowp9tfya8SLoRKBQznYfvIVS8cV0Z5D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752806; c=relaxed/simple;
	bh=b/ttJae4xiEHONrSB61gWYPCVcnCnqIpQyNKL5V/Pqw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=t5McCdiq4N58bZ2Mgyalew9N96MKzdjGAoYhY+uJP7MnUBdua4EPdi5cyvOT52hhREO88Q2/Y8kqfnAQH9zPnh/oBHTg83iXCoSalqu2zB0kiW8ZQAjAvgR5sUDkAOfy68USMmB5/u8ALVKIFcBlr0VR+9AL7QWZcQ8FG9hA+0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Cg4lssCP; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cg4lssCP"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so49412125e9.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 08:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761752803; x=1762357603; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=Cg4lssCPrSem6ZklWU+ce0Q7VCspuiqINlTmDo0XY5BXS/eNNcw6We0VjV1IzDRqJa
         xFM9d0F/naIu2oWLG+Y4ipycPAKK+TL1/Vy6/ZSdcaYSlLrY3sL2MPCdhj9h5N7qntDI
         UlxFQaME40Xy9co9lkqzIpMfPsJUzZnAlcXpmkDvtrtkZCJrfuuYKKWiIOBskKgaBfpp
         ui10EEW/ylHpMHwE5WzBPyKtioziXApdYD0DNC2evSdvM9YKw+ew5SOxvx1+fUsLiWBB
         y27U2WSzVtMfDVblcsCT89uAmG67x1cyIS5V0NhM13FooZOoUTUqMmvq5Cn6T+VQE1j2
         NoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761752803; x=1762357603;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=e9AcZdF4L/T+E/dBUQ01FpZA9ONbV1us8BIzHnGYiVpE4cLDU1FQmXjX10PSdE4DuG
         JtwbqYZ/1USibV49jLproHMUEjYT3gcJzjWMOboMI6jF9dvK6BTswVhUOi8xkDT69q/5
         6rk7vmccBYUVR8VfFpNxhQEgiTgTJNwEFMVLWLUNOIivjiefoc2jY67MTZ6DnogQaBhM
         sv+dSPL/iL3O5Fd0/k/DXnfq9VuZWSnqKRkmST8HVWWSJgL7vRNqSDJJPAdBohyDX+EL
         2xE+T9ZFhU2KdV2ZOQ5ekXpNSEVI7WDQcovh/tK3rhYKqLKIRWjc6ebsyKCvUZllemM/
         Aoig==
X-Forwarded-Encrypted: i=1; AJvYcCVyUFUiKWuyBZrnMarEy0f98kKs8IPJKFMvo/sb1zVcOmb8TKlBSGlskM1sBNMH0mt01OMkE+U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxaCKw3SMhNYU3/hF8vzAUf7qUeOcPgTuk0xpEWgYKdkrpAZvK0
	U97G8aLfQQpgbTg8a8ZCv2QK6v6HoUMhppP++FE84OpEMwhoJ12cnvCfwbicRzdFevU=
X-Gm-Gg: ASbGncu8C4vV6v6FCLU444bXMO+tB9Qd5bY7P6hzblkcAf6uVxVZIIIwL7jol7VhOpX
	YBuhkGus6jXAwJMpE1krVttDRnwzHgmZu6Se+YxKBKXVwWZ8fQeFCmVjN96RX7xI8c8WlqLn/Ym
	hQg2+Cm7x5tzQsFs9jLzjBF+zpk17MnSGEkioJXKeCZ4JQzK057Pk4yxKK4pbhoqjuPzLsWs8Ud
	C07FDxeuCLYHoJM0aqLx3OGs8gXfifS3S1f/w6mBws+1Nhb9+/MRrFtwvRJWGrawiHeUVJ6XUne
	NuMJAsjskDN/ubWKegRE9OyiTat/wKScJJ8W84lQHZc2youXq5L1FQ1CXuJUok1RF4o1sT5Hih+
	/vl1Iue38m2+D2kdsPa+vmLTzoX7PHNZVW/7fIf2bbtGkXyye93yh97q11v5EngH4KSVCi9IrnD
	dNzMDcG2mBLgomeQUlqzJv
X-Google-Smtp-Source: AGHT+IGgMpgZEFzxgXHO7KovTsc5aHb3zJSnvVbjxNijmQFt3YOgqBA/a+6DV3XDRna+PgQBEaHpRg==
X-Received: by 2002:a05:600c:3b29:b0:477:e09:f0f with SMTP id 5b1f17b1804b1-4771e165a0cmr33584695e9.8.1761752802900;
        Wed, 29 Oct 2025 08:46:42 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e3b9994sm53745535e9.16.2025.10.29.08.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:46:42 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Wed, 29 Oct 2025 15:46:03 +0000
Subject: [PATCH v9 3/5] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-james-perf-feat_spe_eft-v9-3-d22536b9cf94@linaro.org>
References: <20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org>
In-Reply-To: <20251029-james-perf-feat_spe_eft-v9-0-d22536b9cf94@linaro.org>
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

