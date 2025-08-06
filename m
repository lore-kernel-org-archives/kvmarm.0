Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B06E2BEFE4
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510265; cv=none; b=hIoKU3WKF3B8pWkfNGSEUX20lctwvkD41KPXNLTjiEQ8w0PynDoxKCRbInodZYjegWpECBFBbt4aivBYfGBJlkowPu4inNOQpPexFcKfzYsoQ5hxM4taCGOlqYqcIgim47I8KwEBOUwBSX7j/vLTUO4oshBgKihYUKBtx62Sx8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510265; c=relaxed/simple;
	bh=p9dwRoIkAdNKqXS3ork0V3QcmE8t7/wykyfY7BDBXjw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HIZ2957u04JC14bm8Asq7476cIBac7ecjJHan6ZPocvdmVmdwgorC+4W7YHwAXQIVu8dWG8z1nRaSLpJp8OpjNlCC0ELcMiwfWzSVVa9x6D24eXjD9oIaSiRZC4CBFErSgZ1RJdTTSF5ynv3F7lJh4DjXxmPG+414sAcieu6U4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pxoNTZIT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pxoNTZIT"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23fd8c99dbfso1407255ad.2
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510261; x=1755115061; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1cgAGvW2Sa5tNwASy1Md3TT+4FZc1wpWNQfNLgFp1cE=;
        b=pxoNTZITzf6mecLAYwPhKVSqH88KbvNBB6YWcgZjNpwjXN796hQX6F7dvQF6RifRkK
         ra9c81XUl/a96yMfeOq9tVXELtp0JDHRRHZ76TnlnwRpbegFXQcATszJ83fYykjRvvv9
         /LWDY/IF+2PFRGLFNt2+VSPpKGbYEYxufseIHMy7oPgnKErEOtov4xjLLPIeCcYNtnPY
         zixlovOZjzKDwoSWwurTTJCo8XMmQtDmT3dYRqiL4lronY3LhBTzm267GsOR7Zqw8mlU
         760iTG+SQl7qNeBEx7Ir1w4U8O5CyBrOXsaY5IKkroUeRwNvS9vmBzaydZxl3nYunrYZ
         IXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510261; x=1755115061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1cgAGvW2Sa5tNwASy1Md3TT+4FZc1wpWNQfNLgFp1cE=;
        b=ByE84QtLCdj5wVUQj+0m4YUS8+JgfyGDQEgbhVKgjUb9f0F9QdgG9SGZB7mGaLKKAu
         lBBBQ+g4PIJmEsEsjRtZrcGCWh5zD/5qbOgcWAbbQPRthzWJ5MKDP+/5DccaL/jcdJ+m
         jTeJl6e0xCWBl9VJWVRxWM2vhKURJt9iH5Nwj7DMz3wobLb5zfS1E63InZm5btjqSmRo
         yCJGYkUCs3koE/sV7pMN2enapREtAfBzsHz0DbPKVOJsQ7CmD4J59jeFBYATMzOU9VTh
         BOhSixGNumplp69e469EoCHL3PKv5Ui7jc2ckt++I4ELfwA6mSSTLNOvjkxYD8VhPEd4
         I2oA==
X-Forwarded-Encrypted: i=1; AJvYcCVzw47NWOnPmYETEkl/I14FO4nC0rvUC+GOAD1zGa2Z3KT9q2JuNifgt1MjIHEQw3BixbXXVUQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEAsQbAIlPBgbIWCWtd3bPlM+Lv7cJ3gHy66zyUOy/i0BEqYDA
	8sSFD8sRfEQ2TZEFky3NGywpKcC625iDrgcm2DDNZM6VOHTpLtMCz3WfOJmzMVlQg5TtQKXNQa6
	glwJC3g==
X-Google-Smtp-Source: AGHT+IEQshj25YWfgh8jlPDalwm585npWoyFxUPXBG4oqUn1ilItXjqTi+CTUz913BcUQcsY19RFz/4rdM8=
X-Received: from plrj9.prod.google.com ([2002:a17:903:289:b0:242:abd5:b3bf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c405:b0:240:b879:fed2
 with SMTP id d9443c01a7336-2429f55daaamr65961135ad.16.1754510261485; Wed, 06
 Aug 2025 12:57:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:29 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-8-seanjc@google.com>
Subject: [PATCH v5 07/44] perf: Add APIs to load/put guest mediated PMU context
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

Add exported APIs to load/put a guest mediated PMU context.  KVM will
load the guest PMU shortly before VM-Enter, and put the guest PMU shortly
after VM-Exit.

On the perf side of things, schedule out all exclude_guest events when the
guest context is loaded, and schedule them back in when the guest context
is put.  I.e. yield the hardware PMU resources to the guest, by way of KVM.

Note, perf is only responsible for managing host context.  KVM is
responsible for loading/storing guest state to/from hardware.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: shuffle patches around, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/perf_event.h |  2 ++
 kernel/events/core.c       | 61 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0958b6d0a61c..42d019d70b42 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1925,6 +1925,8 @@ extern u64 perf_event_pause(struct perf_event *event, bool reset);
 #ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
 int perf_create_mediated_pmu(void);
 void perf_release_mediated_pmu(void);
+void perf_load_guest_context(unsigned long data);
+void perf_put_guest_context(void);
 #endif
 
 #else /* !CONFIG_PERF_EVENTS: */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6875b56ddd6b..77398b1ad4c5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -469,10 +469,19 @@ static cpumask_var_t perf_online_pkg_mask;
 static cpumask_var_t perf_online_sys_mask;
 static struct kmem_cache *perf_event_cache;
 
+#ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
+static DEFINE_PER_CPU(bool, guest_ctx_loaded);
+
+static __always_inline bool is_guest_mediated_pmu_loaded(void)
+{
+	return __this_cpu_read(guest_ctx_loaded);
+}
+#else
 static __always_inline bool is_guest_mediated_pmu_loaded(void)
 {
 	return false;
 }
+#endif
 
 /*
  * perf event paranoia level:
@@ -6379,6 +6388,58 @@ void perf_release_mediated_pmu(void)
 	atomic_dec(&nr_mediated_pmu_vms);
 }
 EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);
+
+/* When loading a guest's mediated PMU, schedule out all exclude_guest events. */
+void perf_load_guest_context(unsigned long data)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	guard(perf_ctx_lock)(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(__this_cpu_read(guest_ctx_loaded)))
+		return;
+
+	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
+	ctx_sched_out(&cpuctx->ctx, NULL, EVENT_GUEST);
+	if (cpuctx->task_ctx) {
+		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
+		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
+	}
+
+	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
+	if (cpuctx->task_ctx)
+		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
+
+	__this_cpu_write(guest_ctx_loaded, true);
+}
+EXPORT_SYMBOL_GPL(perf_load_guest_context);
+
+void perf_put_guest_context(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	guard(perf_ctx_lock)(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(!__this_cpu_read(guest_ctx_loaded)))
+		return;
+
+	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
+	if (cpuctx->task_ctx)
+		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
+
+	perf_event_sched_in(cpuctx, cpuctx->task_ctx, NULL, EVENT_GUEST);
+
+	if (cpuctx->task_ctx)
+		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
+	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
+
+	__this_cpu_write(guest_ctx_loaded, false);
+}
+EXPORT_SYMBOL_GPL(perf_put_guest_context);
 #else
 static int mediated_pmu_account_event(struct perf_event *event) { return 0; }
 static void mediated_pmu_unaccount_event(struct perf_event *event) {}
-- 
2.50.1.565.gc32cd1483b-goog

