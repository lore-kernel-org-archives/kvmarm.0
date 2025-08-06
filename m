Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DF82BE652
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510256; cv=none; b=TegzznYA5AoU3Ue9DgcEPeHVOOLHaxGU+tMBO9u+k3HKeZn+KCJRVSOkr1kGn6zsmMOja9W1rhD6Q+IMd2eNTYzH79mr4zwnJ25x1WW439hxcJv5Pktklyb3a8BvbNRyQjR6GB9DttrGCgg9ceZE2CMtdAizhEYpCUiedbmUOdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510256; c=relaxed/simple;
	bh=jUBl1OA0dbcCe9Exxx/O066eDYx/qkeyxg/XjKFA/3U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=izBSCc09/Y632WssNJgcGEYYnEMBfCCYGWg/bODK2tQfx3p3vDH0I2sHSV5Sf1tuTQCWXaXRj8ScH5BwZHB3GVfwYmqh16hWWHtPqx7T1NHXVPKb7cTe6hJNM33Try1Ve775pTo1R25uqUtIgUdptyCrQ7F1TudFKmvEdUCcAMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t+9I7UdA; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t+9I7UdA"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bef13c254so290734b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510252; x=1755115052; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3IAofGMjgJOHx6SdMcFjG4jFgSxJevKv5cJ/ErNkHsk=;
        b=t+9I7UdAI3t+yRyT9+jE4voYQ8CDGe0P+o2sNg90h1+rZIf1d7A00GYphpXOKiLymr
         bQDk9cstMagLupxh3vPgTubVe5/1OTRTTORE8Qq+i7xClziaHs2VntpjMkTY0Kx4+cOD
         IIX6RljujdKeKG/LSteXCk8S6pANxq1VMCk3aAhTof0KOVgDvRGQPfeWChN8zF6RlfGw
         N5sDZ+cvd7KKI4vA4CrPLGDVHuZZyQJKuEDeD+PpQkIh/dG+pEMcgAxvtmZyrr3zUEK1
         TrQGxhB7w8lv9qLlgahd9aeRemtHLb7eU59jW5JR4jByAVau+kgwxAtKev2dO/mNpQW9
         rj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510252; x=1755115052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3IAofGMjgJOHx6SdMcFjG4jFgSxJevKv5cJ/ErNkHsk=;
        b=dcnHoURxt4qKtw46b7F//KzIrXePMimNJMUYnDBx9Hj4W+1Zh8Bx2afQLvxaSy8DTG
         6EcsiwMIhVHnYShuT6fFDeiHdXm04VXtY4SXbsFa4rqCO5KCh8S9ueChFwKuC6F8OtBg
         ELuUmGTd9acEbAmHt4CicswenwW31uzOEc18l0rsdt2Y5KAtZ2J53givZKgn3pay1cIH
         xOGzOp21RlzZcdeiaVsJLL/GzU4+dk0qcCNMM3vup+ttAeDw+LlbkJpF9pOr4H4+qyL+
         oL5igc8kGmn6KU6V4YSNYK2fzIdp/0njitPxdHYFLtZC49omSzQJ+EJ0PS4DP1613KzJ
         kBWg==
X-Forwarded-Encrypted: i=1; AJvYcCWb90GeefcVOe0kglcPX3URvcywnKf5y9ui4BkuLKDSo0q/Gp5055IGg6ZqzxJqwTv6XD82b2s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3Xy1BoKKLVds3ivQacIvKismw5lzMNt2N1eaNaHpXPG3nAAHX
	1H2RuSe5PyZyKyViF+PUZKlmbgHrYcEACjPr0lCbYyn8nOMBhjNm/8WwSPZ5aoc6NCqCUC2aSQ3
	YT0KLRA==
X-Google-Smtp-Source: AGHT+IGg8m1AYQ1T/bkneerdDiI2IWHPXHDhUcioTumR7faJkpYOSLNXQVSuuMxt1I5dkPrSi8WAHfNQ8i8=
X-Received: from pgc3.prod.google.com ([2002:a05:6a02:2f83:b0:b42:2da2:8848])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a103:b0:23f:f712:4103
 with SMTP id adf61e73a8af0-24041364f38mr1167741637.18.1754510252085; Wed, 06
 Aug 2025 12:57:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:24 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-3-seanjc@google.com>
Subject: [PATCH v5 02/44] perf: Add generic exclude_guest support
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

Only KVM knows the exact time when a guest is entering/exiting. Expose
two interfaces to KVM to switch the ownership of the PMU resources.

All the pinned events must be scheduled in first. Extend the
perf_event_sched_in() helper to support extra flag, e.g., EVENT_GUEST.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/events/core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d4528554528d..3a98e11d8efc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2866,14 +2866,15 @@ static void task_ctx_sched_out(struct perf_event_context *ctx,
 
 static void perf_event_sched_in(struct perf_cpu_context *cpuctx,
 				struct perf_event_context *ctx,
-				struct pmu *pmu)
+				struct pmu *pmu,
+				enum event_type_t event_type)
 {
-	ctx_sched_in(&cpuctx->ctx, pmu, EVENT_PINNED);
+	ctx_sched_in(&cpuctx->ctx, pmu, EVENT_PINNED | event_type);
 	if (ctx)
-		 ctx_sched_in(ctx, pmu, EVENT_PINNED);
-	ctx_sched_in(&cpuctx->ctx, pmu, EVENT_FLEXIBLE);
+		ctx_sched_in(ctx, pmu, EVENT_PINNED | event_type);
+	ctx_sched_in(&cpuctx->ctx, pmu, EVENT_FLEXIBLE | event_type);
 	if (ctx)
-		 ctx_sched_in(ctx, pmu, EVENT_FLEXIBLE);
+		ctx_sched_in(ctx, pmu, EVENT_FLEXIBLE | event_type);
 }
 
 /*
@@ -2929,7 +2930,7 @@ static void ctx_resched(struct perf_cpu_context *cpuctx,
 	else if (event_type & EVENT_PINNED)
 		ctx_sched_out(&cpuctx->ctx, pmu, EVENT_FLEXIBLE);
 
-	perf_event_sched_in(cpuctx, task_ctx, pmu);
+	perf_event_sched_in(cpuctx, task_ctx, pmu, 0);
 
 	for_each_epc(epc, &cpuctx->ctx, pmu, 0)
 		perf_pmu_enable(epc->pmu);
@@ -4147,7 +4148,7 @@ static void perf_event_context_sched_in(struct task_struct *task)
 		ctx_sched_out(&cpuctx->ctx, NULL, EVENT_FLEXIBLE);
 	}
 
-	perf_event_sched_in(cpuctx, ctx, NULL);
+	perf_event_sched_in(cpuctx, ctx, NULL, 0);
 
 	perf_ctx_sched_task_cb(cpuctx->task_ctx, task, true);
 
-- 
2.50.1.565.gc32cd1483b-goog

