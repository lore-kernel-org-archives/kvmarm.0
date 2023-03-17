Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADF479D0
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 19:50:43 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-536d63d17dbso56913417b3.22
        for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 12:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679082643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bzLjpALMNgZO7D58TEpXLTW3ZAq+0ArtuotO+lK7MeI=;
        b=rfDE15TqBibmTXBcKQLshSEj4c6MwqUGxMquOL0OuWRBYtGNLzBp8EE5cIbjyXxbRX
         ukRcpP1Wfdp7D7qmGxMa7oLQdH34lzLP9g6O1OToXRqSwo0uaVAIL91sp7hL/FyOL+IR
         EYeYOPg16SxhFexw2qhP1MszVnslWyhD7gvV4faQmDYs/G2EkHE5uUEEwYgK+6KCsn36
         8Z5QorSBDI9KtAxdoIaVBFKPz5RRO+mCmbmdX67tnvlYglVv+lu+suEwbHDH4pPoXlKa
         aMj1juzDu3StwVf4JmKr4iYJBtjmhmL6DKEhwTylpdahoarWAzq+aVp9YqviLI9YapPb
         ctxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679082643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzLjpALMNgZO7D58TEpXLTW3ZAq+0ArtuotO+lK7MeI=;
        b=l974vtKHzgJb8f6fV8ENsOiIv8xtsLw15i/8/FxndOyk+V8h5n0l74wCbYih7hDRyo
         U08qL0n4vPeCKv1elaUAyTu33/B7kNjZcR4OUg6w1UVim1lNNpFN4CtzjDTXY+lw/pf6
         4FnyY9mP1Q7IlFLmJWrxnuR+/CHjWYJJVK5vUA0IhGxRem+nAyJ2JevYaCYVUejXLdWZ
         BaJ8QQq+FRXXkua9WU+DQI4vnxvUTBlzhIzziXyQEZ26EvO+w6Kprxt67+1yROtn+K6+
         UwZkm+ecnPx2YuXXmdWzQlKL7qzfsTXghRaD0oC23bTW+r+S8rayUY9SfFuoshI2nT1S
         6hXg==
X-Gm-Message-State: AO0yUKXljzkdWSFG6C82ZbRjphBVkn8xebzTdyTitMLe+O3mkEnxs4eC
	NQU8bLNc7P5oOAQHAt8Q5YDK9d936ZBKk2E=
X-Google-Smtp-Source: AK7set+m7P9XPq+3Ux7nA0IYcb2cZgCLFWfZ4IOd9qnHlpeaYU67uI0KBzpA9cBUep4TzOcEY2DLbdhoLgSHnk0=
X-Received: from zaidcloud.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5325])
 (user=zalbassam job=sendgmr) by 2002:a05:6902:100d:b0:b51:9eff:ea80 with SMTP
 id w13-20020a056902100d00b00b519effea80mr473731ybt.6.1679082643007; Fri, 17
 Mar 2023 12:50:43 -0700 (PDT)
Date: Fri, 17 Mar 2023 15:50:24 -0400
In-Reply-To: <20230317195027.3746949-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230317195027.3746949-1-zalbassam@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317195027.3746949-6-zalbassam@google.com>
Subject: [PATCH v4 5/8] perf: pmuv3: Change GENMASK to GENMASK_ULL
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
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, f.fainelli@gmail.com
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
index 2cab600af4fd..fc8ed3cd0330 100644
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
2.40.0.rc2.332.ga46443480c-goog

