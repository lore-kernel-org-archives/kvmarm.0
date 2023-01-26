Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1825390
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 20:45:01 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id w70-20020a25df49000000b00803e799d7b1so3173699ybg.10
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 12:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tR+9e0WH8ejfT5bQyMqYGVgHaYV65JzCXZXsv3/vdaE=;
        b=sBf6nSf9W+yg3jl9ikNbQCUJZLO/WPlZKu2y4EiVKKHALKTncjVIKZC02SWuWSNETc
         XuoE1whnOWClQf6umgz02GeGah23sex7PlInifYrLbTjjMCPHzjJIBT3ymT3wAc1vbYH
         BCqk4JZWiJNnnBgb6HO+ynmd+qkT7n1tPD0PZSkRXo6Cl9AQle9UVEXQdRW4rgwjIAmP
         VSFrR5lLVDeDKkispgnL16j4J2m9pPCoeBcrFV+catr9AAF/lyMxldG8a5qFtmxed6t4
         iKhuGXj7NAXNGVI9+VDG9pGvK8MHnHHoCP8dfW+IyglTyrsCc/pB+vXj6YAO1QNKuUm8
         yv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tR+9e0WH8ejfT5bQyMqYGVgHaYV65JzCXZXsv3/vdaE=;
        b=YpF+S2euYWwizjv7qMHS9GZWATXtlf9vlmwj1r5P5vvk+KLG24BIvA+MW1AY0kjL2l
         NLiUxDWSOUw0YR6JvlCrFpFtaWm8LV5wPYYPT5l1gA3JmBuklZ1/hpG2uvovRrYw7I77
         HnkCgzv7gm2WPxYjzdvLdRloiMm4t8ci7kCzf6bHma83wqfOjNvm3NF096sgBqfX0CI+
         VEu+BQpq8fBpAcGxEvoPKBwa2TfDPK9L5ASUDe9rcBVZTUA+On8stDbnuQv5emlnL571
         WdQmWWi+nbEyq9xhrqQuqsuF0+vtAqk0Wfddf1S6fUvuAdUqoQt7tEPdMiV9oSzsZTe8
         CPnQ==
X-Gm-Message-State: AO0yUKUNQAP4U6YbU8MMwweka/J1guWgur7W0eYfBgzrldsoB1murzZL
	mopUKM736Z7mK8ske5x30zPnf5eVmEXUnYQ=
X-Google-Smtp-Source: AK7set/hsVwW2nMS3JQswecSr6rmsnIhyJiRn87by2p6kpGIzHO5WnDstl5QfvYOaOlZ2lyNCHAfN95tSsHwFt4=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a25:4148:0:b0:80b:7569:8227 with SMTP id
 o69-20020a254148000000b0080b75698227mr955575yba.282.1674765900796; Thu, 26
 Jan 2023 12:45:00 -0800 (PST)
Date: Thu, 26 Jan 2023 15:44:41 -0500
In-Reply-To: <20230126204444.2204061-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126204444.2204061-1-zalbassam@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126204444.2204061-6-zalbassam@google.com>
Subject: [PATCH 5/8] perf: pmuv3: Change GENMASK to GENMASK_ULL
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
---
 drivers/perf/arm_pmuv3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index d7063dd52827..67d90c1d4bae 100644
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
2.39.0.246.g2a6d74b583-goog

