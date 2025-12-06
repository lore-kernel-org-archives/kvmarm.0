Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE91218ACC
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980254; cv=none; b=LKY/HjQeqqSwJ+UlbmPswswMFQN59eTQVIUquG8t4iK1wIhWdee/trp85liJQogtD5H514qvu7rc7S/Z4veUR8cm0EG4NvokZJq+Y4M2jst8HjJtNLqG65Cv//8advzri68IIEMhMB8DX55MrPoqWm4DrruDLON+RVKhAkzC4iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980254; c=relaxed/simple;
	bh=53ZMr2ZRIpu7IbiEdlebeII/cbBReqilV+Dt6eLN4/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Al0ffW29cFYUPzX5hqOqURRLCjJ4t0pmhNC0snZE+q+kTS0/yv0U5VJfYZCxgVi169+UAzz9PaAoDLr0r+wcfJgE+GvQNUDiPTUFW+Wfh2OtVuVhZZEiLZdm54vaA+LGYPvikF56y2vTk/8e7ctMN5T/7lbF3VLwz3WMINl+fwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1jkKLpxZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1jkKLpxZ"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-341616a6fb7so2792642a91.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980251; x=1765585051; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UxEE6YFCrywRRLGygEARIDA06aPKgmiMBn7nXQjzdiI=;
        b=1jkKLpxZ6EL0NYxAZqQypnsuIOhggSeetNC0hyF4Nn1SS63OszaZfxECPbpHtkhWsp
         COQvieIVm2DCEAp1t4w7Y0O1hrGr9rVmOVnTCBzSi05uFVhrVrLJ+ndZ4eYwPhc4+0TR
         jAu9J3MUyQn1z0RxEV4bSujiebgP68dqaw/k1RBqfFNXqMTRMe85A1Ju6efmE0DuLc9R
         Ibn7rYAt6UzizsQh0aptZDraBTdPmYm3PCDF+gRV1C0yLcVrNl54KlAKqq3J8WzzdoKB
         DNgI4d32Z+R2PeCL7KDij9edW305ERrNvPgXR6iE8Aus7mwNni1UX6U58y+0Fkq2VHZC
         QFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980251; x=1765585051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UxEE6YFCrywRRLGygEARIDA06aPKgmiMBn7nXQjzdiI=;
        b=rXIqMr02pgtPPS75KCaRSpjLaPHrQg3wO+FugHSnZBHpZbIKIUR/VgqrET0HgZ6kZ0
         D3mepz5IVeIxj53+pvvBvcmW3Bpc1PUHg/hO7V3A0VS95qrMt262raqEOS7vZ90669U7
         T/6prpZ+CPtDdrNTGEwe1iHyVsI3DsPIfAX3Q0zTmjTsVtg9ey565xWnWCSYl08DMsle
         9OylOf5F53GyHxiKNvJJUOqztl5E48UVQAygOTaAKHCMl5GyPukmrUDeCbTNbNDopS4J
         vPTKKgzKUveKqxDqBj1KmYM5TdqenRCrDcmfKTBhQdMrEAA4yVeTia7n61QliXcfOhlc
         zYuA==
X-Forwarded-Encrypted: i=1; AJvYcCWWXKpJ1LUpazWQfmriOSRAcCMGbeg8SGl0tOe7nMtjeoafjc1jEuaQSoqNlKg6OGV09Omvhb0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxlcNM2ytgXMy4TLUhAsukW6Tmhx7YqvgT/WdJHl8akFa+r06+U
	Y21s4Yg/pwlOZf3EnafvE5ea9KEHM/40Xfa8QDDJzPp3Jj6Rd7fRDnenqV9KmrszJDKRm2+m6SY
	o4MS6Qw==
X-Google-Smtp-Source: AGHT+IHjg9edpOr3D1FDjetV+9fqRbGzj3yZXk9Coy0VtACLss4vYlJyIABW7Xcv++xOTx44sX1NPQCjnv8=
X-Received: from pjbkr8.prod.google.com ([2002:a17:90b:4908:b0:343:387b:f2fa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d0:b0:349:8116:a2e1
 with SMTP id 98e67ed59e1d1-349a25fe29fmr699857a91.20.1764980251086; Fri, 05
 Dec 2025 16:17:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:38 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-3-seanjc@google.com>
Subject: [PATCH v6 02/44] perf: Add generic exclude_guest support
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

Only KVM knows the exact time when a guest is entering/exiting. Expose
two interfaces to KVM to switch the ownership of the PMU resources.

All the pinned events must be scheduled in first. Extend the
perf_event_sched_in() helper to support extra flag, e.g., EVENT_GUEST.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/events/core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4cc95dd15620..1e37ab90b815 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2872,14 +2872,15 @@ static void task_ctx_sched_out(struct perf_event_context *ctx,
 
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
@@ -2935,7 +2936,7 @@ static void ctx_resched(struct perf_cpu_context *cpuctx,
 	else if (event_type & EVENT_PINNED)
 		ctx_sched_out(&cpuctx->ctx, pmu, EVENT_FLEXIBLE);
 
-	perf_event_sched_in(cpuctx, task_ctx, pmu);
+	perf_event_sched_in(cpuctx, task_ctx, pmu, 0);
 
 	for_each_epc(epc, &cpuctx->ctx, pmu, 0)
 		perf_pmu_enable(epc->pmu);
@@ -4153,7 +4154,7 @@ static void perf_event_context_sched_in(struct task_struct *task)
 		ctx_sched_out(&cpuctx->ctx, NULL, EVENT_FLEXIBLE);
 	}
 
-	perf_event_sched_in(cpuctx, ctx, NULL);
+	perf_event_sched_in(cpuctx, ctx, NULL, 0);
 
 	perf_ctx_sched_task_cb(cpuctx->task_ctx, task, true);
 
-- 
2.52.0.223.gf5cc29aaa4-goog

