Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A163A334705
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730527; cv=none; b=MUluENY7Jrk6mp6bdTIec4Ejm3DNuWVl5KAns7LONSlzMmyDK7V46HVfV8yXY0kwN7xThSQrEL1tngB93gQiPtCzQjtX4WqpKKjjge432NzviVU+KZz4w1EyOiFv3Zo7IMZuSBnXGIO6TbKoKpAhOVRZiOW6X9JuuEE3J6pEccY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730527; c=relaxed/simple;
	bh=b/ttJae4xiEHONrSB61gWYPCVcnCnqIpQyNKL5V/Pqw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MS7EaBDG+PD6J1CVZZ9CrKQiV2coQVqc+WmjXIcjspajf3aYrlvqAxJBtwTxzFFpcmV9n7sS/aGSsXd21DTTYyTnPLMZB2CNzpPpgYAeSGpZNxEDlngeLBhfgyh8GGiOVb3Dtpf4rv8ymgum4LId5nEqsFBazP6u8KKae5yqD6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iMoIxhL+; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iMoIxhL+"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45b83ae1734so15460675e9.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756730523; x=1757335323; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=iMoIxhL+Cz0L8mD/ST1WM9D+wvUZz82JL1017E4j1hJIvLWPtfuhfB+pqD2NZ6YpPP
         m8+pE0O1nyETn04SJeHRwbu6e5vb25E6zEZ5AJVbYNHvGF48KXSeRd+eeQz/v4HRewm1
         R5APvrLmH0uhhgPhHS1OueDyOgzgC6vgwx1u2tyBDtZMKJQMyHNtu45NFybRpgpvWIYn
         ZjBFLVvUhbWHBJ5FGWDvOFoZHZhlO3IfavPpc74Te30gLUxn72fEAEmP9wSqlLIT7YrK
         QnM5EaEm2Zt6GTL7CKcua4FEvP+4YSXdxMYwyfCfNb8WCgsvjaRK+GKaDazMgE6NraUG
         vWQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730523; x=1757335323;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YGtpCZfgBTuGsyBPIkbeq53HmntuKbontBvcg3TVESk=;
        b=hJbH5EzUVhth7H/nGcu/CD4QiqeiMK071tB4CzU5iVsHRkKecCWXmpzPlKtzX44keD
         PHLPETgckE4yNToDZh6gmbM6qqN/XY9ZdOeSkZ1IOrvbo9F7JaH8ip25X5UOvMdFSObU
         588W0H7XTvpHTa4mRmzM5Tb5RnWsZDCyp46h/2YQh5L0qH61ZfeQtLDhQKxqsfJiCQm2
         bxGMEAV9GJAxvz3ee7Dt3EzI05x9lVJCgzCprMoITKefAGEd/ImW3tffdgrZFbpYpNwU
         w5gpX1HbO3hjGYd/8Frgty0Kp2vaxE44Le8BDZXyn3Cq+ZQsPqFBoOhrkyXyALwSsSCJ
         an9w==
X-Forwarded-Encrypted: i=1; AJvYcCW1za4eVf82g//2bSOx/fvgPr63at8631+9AoFOgJfXJ35LGFHVecyCujJjVEavGA8DlBu3AQc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMzOncveoFuAq9VoCu4SCz95stvdA4AmgknPqmZW7AacXgkNxX
	JWfROdVhlxmBL9miPBDota1Sh94E0j2kJdBFk4LgwxTCAq0B/uWvV3TpZcyxAyNmubE=
X-Gm-Gg: ASbGncsXFz6yV2PJY+zlS96UeLcZHAK0c5grF00DcSvVjA/mxop0b8wzcKHyU7FqFnK
	kj5evAZP0JY61B3gexCLBxesxMEPx/RMPUlE0GmOcvvR88wBAftimrwcU+UYEOwZ280f17FhovW
	K64/JUepharK5juAjdqc3ub8DzesoofX4rdefETsLLczR06kn9eR9J0bxaRm/R7TQyKfzWF1s1u
	7tbImQ9iEciUcC4jJVl0pnuEH+cGTgPGEJqhbItwLJ3Wk16hff3CAT0wgwaczsZEWh8LIay5MlM
	KH3Ed2kIvM50ZocvBRlQCTZ6HDzSh5AjZGYysnOVMFzgNO7lfV1/cHVry1JwDPXXAr/p6P3lmYu
	9e+pVxQgwqN/p9+gORR4nbH8dEusTBQE=
X-Google-Smtp-Source: AGHT+IEQj3GrkfSjpxyNOrXOZvvlmQ+TSw4g8/XmWwPgGUWH337/Zp0pT39A7m8T0jFPe3YqQi07Lg==
X-Received: by 2002:a05:600c:46c6:b0:45b:84b1:b409 with SMTP id 5b1f17b1804b1-45b855ad0b0mr80544675e9.30.1756730522690;
        Mon, 01 Sep 2025 05:42:02 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm154946315e9.19.2025.09.01.05.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:42:02 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 01 Sep 2025 13:40:39 +0100
Subject: [PATCH v8 10/12] tools headers UAPI: Sync linux/perf_event.h with
 the kernel sources
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-james-perf-feat_spe_eft-v8-10-2e2738f24559@linaro.org>
References: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
In-Reply-To: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
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

