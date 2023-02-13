Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C726AD54
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 21:03:41 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id m16-20020a62a210000000b005a851506993so6810989pff.4
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 13:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qrN9jlWUGKebcMV0yhiCKjFphcO4anlDt9wV3VUtSLs=;
        b=jGU4lA8/hoEqIDLvQcR9p4fzHotKwBmrSvnF6Wow0R1HGQvNAaoEO1bMcHJHg/ge/G
         0Dg6FgengoCE+KVeRUjumTtZBJET+HTRwvM1oe29kGguaC81c9eSVb4eEFZN7bjwEj7W
         x3BgTlUqJo7pFoUOCvj/uuAZju8B4HaSGiad6kqNvVHMgH/l/BnnLj2zwDGk56mMY7w6
         +1iitZ1AJ2d+QkUVeqaO1oGEWfiLDMi3KajzG7y44b68gO5UzHzmt/IP2VWuV4JlVy9o
         FtAmUBaUaKQLJT9i56zUDjV50OWclWQBdZDisY6qkIYmi6bj8YMKtM6AA5UnUNyD2nYm
         uz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qrN9jlWUGKebcMV0yhiCKjFphcO4anlDt9wV3VUtSLs=;
        b=oAP5I3YccSvQGJHv20s3isCWxTJSUzzupO+Qj9VKQl5J3ZlHveP8DjAHXfyzKd4k8o
         vDLosZv7CW+fnThWmiFmDjgpH7SJef1PBxVXL62sLE8IbvaxQoNJxCG9p8D+0nmCGVb4
         Tuwe0nBsdkX/RLcn9ZMKG2FIH2in4LKrY2Ndi4/6ragem3a4EOxG4eO6lroSQj8kF+8f
         ZPnbN5Hq/DD8da6/+d9KycgeJeqgedLdv5Vx48ehHkYgwvB0Wst6IebV5XerCmOae9fU
         WDgYhejhbGgz/pSDtKqqAkBLOXlhMutguurTDFYOAW83jNiopDgFd0BH1esszPFNZEku
         nSLg==
X-Gm-Message-State: AO0yUKW+Ab4kgimVgZphG8lfUrJZijYpzjF6wgukjhvhLGDQvarun2WC
	+alzaxtQSLDl7iiIO5Ex9a5IEqlYpcrqZ3A=
X-Google-Smtp-Source: AK7set+fIZPdMnmqrLDxEeV303sJ8KLR7tYv16tUjdhla8rqMw8CnQM55yRxFm/Zin2t6D5s0G6MgPEgavkoAT8=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a17:90b:1483:b0:233:e9c9:67f with SMTP
 id js3-20020a17090b148300b00233e9c9067fmr1318318pjb.9.1676322220898; Mon, 13
 Feb 2023 13:03:40 -0800 (PST)
Date: Mon, 13 Feb 2023 16:03:16 -0500
In-Reply-To: <20230213210319.1075872-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213210319.1075872-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213210319.1075872-6-zalbassam@google.com>
Subject: [PATCH v3 5/8] perf: pmuv3: Change GENMASK to GENMASK_ULL
From: Zaid Al-Bassam <zalbassam@google.com>
To: Jesus Sanchez-Palencia <jesussanp@google.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Cc: Zaid Al-Bassam <zalbassam@google.com>
Content-Type: text/plain; charset="UTF-8"

GENMASK macro uses "unsigned long" (32-bit wide on arm and 64-bit
on arm64), This causes build issues when enabling PMUv3 on arm as
it tries to access bits > 31. This patch switches the GENMASK to
GENMASK_ULL, which uses "unsigned long long" (64-bit on both arm
and arm64).

Signed-off-by: Zaid Al-Bassam <zalbassam@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/perf/arm_pmuv3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index b3683fdf8d0b9..dc8b8c8f1b3ed 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -489,7 +489,7 @@ static bool armv8pmu_event_needs_bias(struct perf_event *event)
 static u64 armv8pmu_bias_long_counter(struct perf_event *event, u64 value)
 {
 	if (armv8pmu_event_needs_bias(event))
-		value |= GENMASK(63, 32);
+		value |= GENMASK_ULL(63, 32);
 
 	return value;
 }
@@ -497,7 +497,7 @@ static u64 armv8pmu_bias_long_counter(struct perf_event *event, u64 value)
 static u64 armv8pmu_unbias_long_counter(struct perf_event *event, u64 value)
 {
 	if (armv8pmu_event_needs_bias(event))
-		value &= ~GENMASK(63, 32);
+		value &= ~GENMASK_ULL(63, 32);
 
 	return value;
 }
-- 
2.39.1.581.gbfd45094c4-goog

