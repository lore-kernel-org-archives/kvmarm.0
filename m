Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6677E2BEC50
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510264; cv=none; b=buoKWVBQ+AC+hIljWNnjs6UGIwExJcqFGMcDyUXCb/xrVipDTennzRQ1//T/ACdeAkojc/nYylTuy1jJD1CjFuIw2jRuvelFZFwo/xlZoBEJZkK63xZkdoJEWL5HmCrF+iuF9yEotQ0EemookiDMCKERy3mAMUOY7hz4wWyMowY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510264; c=relaxed/simple;
	bh=YYCe+4eLi35qElSGVX2EX5EoBQNPxGJxcMCI2Jk+YMU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hfi0KkoKmyJj5HOZ+zw7ylGyuwBHygBYJ0+zXHlD9dvXkgqsVLYwXsRjE/Gl3FPP6qJ4kfxjr+oQZsBm6sxzSZbuCNlmpCXbKlVgyqN0VADx4gHl80xCtqngFgROh9O/ESKsJbREM34lHmVtdIq1qwsftn8z4Mb7SgcIlZXwRPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ls/TL1rU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ls/TL1rU"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f2dd307d4so279586a91.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510258; x=1755115058; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RSqs7LjEbfI/o+XH+tbZdSeN9oFJhrETU4UrZ2e2+po=;
        b=ls/TL1rURTCA6uWw/4Q/pCLvWCbHADqwkePJ78PwPHvxjNIO7J+NShpfFmIdWM4Znt
         J2eGJLCw8qo4YIttdHMmpy8NiQdf7S+m8UxatV3GjTm9hDiK2PB6PKtJ4YCgIMxxRfL8
         3Ri9mfk/5/dStuJ7WOztI8FHWTICSPNr+ODyHQ1zPZb23RhHBL0SeOZQRPJj+YOzS0wj
         vVR4Ampasi5ijQRIXAzptMLMc772XpSgSBEeAq73l/t/YqoWgp/WC6J0Pl9tivsCHyPD
         yGP+YhMbVdZ+FlZbbgn4cF+bslb1HM98eM/9y8JzImI7LnQRONGML+GsWVuwxcoCwWuf
         jvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510258; x=1755115058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSqs7LjEbfI/o+XH+tbZdSeN9oFJhrETU4UrZ2e2+po=;
        b=AmHdmqmUsCHopwrrY+/l8ntML2DBirX2Z77GlZjb3U0TsKYhSfarWpXV4fbQV3N+SP
         2K+rijGwcbGCL8h/A5D+srdEEGmIz5iDOVkRMHlTL3wNhspWq4MtwyuucZ2lBS4EKBQZ
         xJM+zRpxiHfc5ERe6icA+7iL/Xh2ttzpTYZYLAnhwfSeHR0Wl3UfIAk/A5HxbFBoeEbm
         14z4j0ijuYE504Bl0G/60V22bj5bVIhrpBWpvTxHHDhnEmUAJWRnVf5Kk34rqNQCYbkh
         YBhFvfrjbHiW3nvqXE+H2gOY41dCO9v8Xezjf3gopA3QUN5hYoYwWbXtXpu+jUyTlbFK
         H+IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeOLH00B4Z57Ofi9NogZuNH7DyF1LVnVbhk2gVhDS2ANpKdGR2843EYcN7u2Lusu5AM7xE5zk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzb/0PfgzoCJYJvb9Mhvqrme7FdI5H5dQybR8N5P0fge37vPgdi
	bx6/Q3fMAbgY93kZ/BtIC2u8mX1bAS8lDDM0LKGArkvo38QJs8D+2XHC/4Yp2yHWAGkH/g1aDUA
	KZhFw6w==
X-Google-Smtp-Source: AGHT+IHRaSY+k4TAZbl8ZMQSCfgVDMYJiwgIqFCqRbteQRg9trtxOd4uQTojLJyQdeJPXNfHx0P6bSsh+7Q=
X-Received: from pjqq16.prod.google.com ([2002:a17:90b:5850:b0:31c:2fe4:33bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c10:b0:311:ef19:824d
 with SMTP id 98e67ed59e1d1-32166df97d9mr4595576a91.2.1754510257253; Wed, 06
 Aug 2025 12:57:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:27 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-6-seanjc@google.com>
Subject: [PATCH v5 05/44] perf: Clean up perf ctx time
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

The current perf tracks two timestamps for the normal ctx and cgroup.
The same type of variables and similar codes are used to track the
timestamps. In the following patch, the third timestamp to track the
guest time will be introduced.
To avoid the code duplication, add a new struct perf_time_ctx and factor
out a generic function update_perf_time_ctx().

No functional change.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/perf_event.h | 13 +++----
 kernel/events/core.c       | 70 +++++++++++++++++---------------------
 2 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 63097beb5f02..186a026fb7fb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -999,6 +999,11 @@ struct perf_event_groups {
 	u64				index;
 };
 
+struct perf_time_ctx {
+	u64		time;
+	u64		stamp;
+	u64		offset;
+};
 
 /**
  * struct perf_event_context - event context structure
@@ -1037,9 +1042,7 @@ struct perf_event_context {
 	/*
 	 * Context clock, runs when context enabled.
 	 */
-	u64				time;
-	u64				timestamp;
-	u64				timeoffset;
+	struct perf_time_ctx		time;
 
 	/*
 	 * These fields let us detect when two contexts have both
@@ -1172,9 +1175,7 @@ struct bpf_perf_event_data_kern {
  * This is a per-cpu dynamically allocated data structure.
  */
 struct perf_cgroup_info {
-	u64				time;
-	u64				timestamp;
-	u64				timeoffset;
+	struct perf_time_ctx		time;
 	int				active;
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bf0347231bd9..2cf988bdabf0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -815,6 +815,24 @@ static void perf_ctx_enable(struct perf_event_context *ctx,
 static void ctx_sched_out(struct perf_event_context *ctx, struct pmu *pmu, enum event_type_t event_type);
 static void ctx_sched_in(struct perf_event_context *ctx, struct pmu *pmu, enum event_type_t event_type);
 
+static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
+{
+	if (adv)
+		time->time += now - time->stamp;
+	time->stamp = now;
+
+	/*
+	 * The above: time' = time + (now - timestamp), can be re-arranged
+	 * into: time` = now + (time - timestamp), which gives a single value
+	 * offset to compute future time without locks on.
+	 *
+	 * See perf_event_time_now(), which can be used from NMI context where
+	 * it's (obviously) not possible to acquire ctx->lock in order to read
+	 * both the above values in a consistent manner.
+	 */
+	WRITE_ONCE(time->offset, time->time - time->stamp);
+}
+
 #ifdef CONFIG_CGROUP_PERF
 
 static inline bool
@@ -856,7 +874,7 @@ static inline u64 perf_cgroup_event_time(struct perf_event *event)
 	struct perf_cgroup_info *t;
 
 	t = per_cpu_ptr(event->cgrp->info, event->cpu);
-	return t->time;
+	return t->time.time;
 }
 
 static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
@@ -865,22 +883,11 @@ static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
 
 	t = per_cpu_ptr(event->cgrp->info, event->cpu);
 	if (!__load_acquire(&t->active))
-		return t->time;
-	now += READ_ONCE(t->timeoffset);
+		return t->time.time;
+	now += READ_ONCE(t->time.offset);
 	return now;
 }
 
-static inline void __update_cgrp_time(struct perf_cgroup_info *info, u64 now, bool adv)
-{
-	if (adv)
-		info->time += now - info->timestamp;
-	info->timestamp = now;
-	/*
-	 * see update_context_time()
-	 */
-	WRITE_ONCE(info->timeoffset, info->time - info->timestamp);
-}
-
 static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
 {
 	struct perf_cgroup *cgrp = cpuctx->cgrp;
@@ -894,7 +901,7 @@ static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx,
 			cgrp = container_of(css, struct perf_cgroup, css);
 			info = this_cpu_ptr(cgrp->info);
 
-			__update_cgrp_time(info, now, true);
+			update_perf_time_ctx(&info->time, now, true);
 			if (final)
 				__store_release(&info->active, 0);
 		}
@@ -917,7 +924,7 @@ static inline void update_cgrp_time_from_event(struct perf_event *event)
 	 * Do not update time when cgroup is not active
 	 */
 	if (info->active)
-		__update_cgrp_time(info, perf_clock(), true);
+		update_perf_time_ctx(&info->time, perf_clock(), true);
 }
 
 static inline void
@@ -941,7 +948,7 @@ perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx)
 	for (css = &cgrp->css; css; css = css->parent) {
 		cgrp = container_of(css, struct perf_cgroup, css);
 		info = this_cpu_ptr(cgrp->info);
-		__update_cgrp_time(info, ctx->timestamp, false);
+		update_perf_time_ctx(&info->time, ctx->time.stamp, false);
 		__store_release(&info->active, 1);
 	}
 }
@@ -1562,20 +1569,7 @@ static void __update_context_time(struct perf_event_context *ctx, bool adv)
 
 	lockdep_assert_held(&ctx->lock);
 
-	if (adv)
-		ctx->time += now - ctx->timestamp;
-	ctx->timestamp = now;
-
-	/*
-	 * The above: time' = time + (now - timestamp), can be re-arranged
-	 * into: time` = now + (time - timestamp), which gives a single value
-	 * offset to compute future time without locks on.
-	 *
-	 * See perf_event_time_now(), which can be used from NMI context where
-	 * it's (obviously) not possible to acquire ctx->lock in order to read
-	 * both the above values in a consistent manner.
-	 */
-	WRITE_ONCE(ctx->timeoffset, ctx->time - ctx->timestamp);
+	update_perf_time_ctx(&ctx->time, now, adv);
 }
 
 static void update_context_time(struct perf_event_context *ctx)
@@ -1593,7 +1587,7 @@ static u64 perf_event_time(struct perf_event *event)
 	if (is_cgroup_event(event))
 		return perf_cgroup_event_time(event);
 
-	return ctx->time;
+	return ctx->time.time;
 }
 
 static u64 perf_event_time_now(struct perf_event *event, u64 now)
@@ -1607,9 +1601,9 @@ static u64 perf_event_time_now(struct perf_event *event, u64 now)
 		return perf_cgroup_event_time_now(event, now);
 
 	if (!(__load_acquire(&ctx->is_active) & EVENT_TIME))
-		return ctx->time;
+		return ctx->time.time;
 
-	now += READ_ONCE(ctx->timeoffset);
+	now += READ_ONCE(ctx->time.offset);
 	return now;
 }
 
@@ -11991,7 +11985,7 @@ static void task_clock_event_update(struct perf_event *event, u64 now)
 
 static void task_clock_event_start(struct perf_event *event, int flags)
 {
-	local64_set(&event->hw.prev_count, event->ctx->time);
+	local64_set(&event->hw.prev_count, event->ctx->time.time);
 	perf_swevent_start_hrtimer(event);
 }
 
@@ -11999,7 +11993,7 @@ static void task_clock_event_stop(struct perf_event *event, int flags)
 {
 	perf_swevent_cancel_hrtimer(event);
 	if (flags & PERF_EF_UPDATE)
-		task_clock_event_update(event, event->ctx->time);
+		task_clock_event_update(event, event->ctx->time.time);
 }
 
 static int task_clock_event_add(struct perf_event *event, int flags)
@@ -12019,8 +12013,8 @@ static void task_clock_event_del(struct perf_event *event, int flags)
 static void task_clock_event_read(struct perf_event *event)
 {
 	u64 now = perf_clock();
-	u64 delta = now - event->ctx->timestamp;
-	u64 time = event->ctx->time + delta;
+	u64 delta = now - event->ctx->time.stamp;
+	u64 time = event->ctx->time.time + delta;
 
 	task_clock_event_update(event, time);
 }
-- 
2.50.1.565.gc32cd1483b-goog

