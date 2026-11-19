Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114357;
	b=RJFcHg24bwx7ZI0rcPyaXdiM5msVAM//hyf5Kp+Sx1bUKGO0jzqdEb8TFE4yUz9ZtDbT
	 xrEm9oxoUXKGVQW99txO7316ULohA/ruKhoYofjfF344g89yKRj9TEwL4SdnjXp4q1grs
	 F3TW6PiF7ytuqvbfuQGfASY9g6xhQqCpE4x42+n4ZGfmVHISHyQVeHYIc8fKrjRCsiZ0p
	 P6vQw5Q8bgFUITDgWzL2bfmlEstrqvbYlRYq0Igu+6dNyPVTdvwjSNCu3I8ftIcq5Q5nM
	 ApLo6Cag9NyLLdtdYvq+JBDU/nhx48FSpcHhDOPI1yrYHPZcd/exeSoEQbr4mCMAPzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114357;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=RoqvmCK2qkOodjdsXGnbvnsvP/GHWBE0XmbngxrSrDA=;
	b=EKGoCUjZay5nuw9rrBkCoGvlhjJm4Ct5NuCeffCytCmlUfPjACVbBSxq9KKUlkyW58D6
	 9pSMssCNnXCq1WH5sNXlrEL+ToCxwnWVwy3HZaBULWI64Rick52k8nAVnzVKcCViaCWHp
	 xOZu1ZND0inBGOyvY2hhkMCctmGRX1GF65QPIrf8T799+bVZ913TpsBCwA2BgPDHnWFJQ
	 SxZacbbIsNjYBpyLIA0WSNJqCD1zmVsE37kWP1vgz1lR83ZVvlAP6RB6PxLxEzBbPWNNP
	 sBbSlpXSGhKT2kmwhU3iPFg2fUbgpMRvmM1i/YhIde2ceGKrevifYR1yklGSODW/LCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=g6s8Q5ld;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F2B606DC99
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3F2B606DC99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=g6s8Q5ld
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-5713cd0fb42so1649187b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114356; x=1795719156; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RoqvmCK2qkOodjdsXGnbvnsvP/GHWBE0XmbngxrSrDA=;
        b=g6s8Q5ld24/s6K1r/acWuRbsRH4vy2xWnBZa5UguRtO+sTCRBa0pwrUgCN4dZ+f/Ko
         bEGYS8hHZTU3qzSDKcHgKvNeJUUEAbvY6wjjd89lL/CimVdeF7h+eNb/fxN93ErrtNWb
         kPBd4PV+z6v+T0BTc0r1V7fIwIH2VG9xkNs7RDX+rFP67nOOX3QZrb43Lgca1kKKTPLd
         lekKQDe5sk+BT0q35OoA12EEf1Y9Z1QOiXKdo4rKUb3LP+NZ2WbT+e18Putsnj1txGUj
         XfVe6y8UgH9ylKAkZLu9wUb1UMQJhAUjc/FWekbtvBlms9CmN96KzOcDf+o7m1cevQ2/
         7Q+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114356; x=1795719156;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RoqvmCK2qkOodjdsXGnbvnsvP/GHWBE0XmbngxrSrDA=;
        b=m0EkpJX9/e2XcDIqneKttH+nQr7sSBvxVXw+B4gesXNLan0EO9NX/P3oo9HmHcETjL
         67/HB47aY8QzhqRy/zFBeMwzAblaMhwhEXdxlTmMbRaN9X6yx6Gr6MG8OWuy6z2pXhGo
         af033tTXW8nqIpn86OTUH6NVdmXtDDqnbeNrwpP8h0yHmgEYnunmoqL+nzD8CYcz1mL2
         wwB1F9VCpq8itD9Eh5nIUGQ0UGkPN3kO8qBUVJu34VAm10N/6AIMXMPs/P12WBhXTWUo
         f1RJ9zgVwaXZZLDdmNixjAiYdarCvGKCAOtWT638rCYVErIOC/AAT2QtvvuwLUGFxwwk
         3tLA==
X-Forwarded-Encrypted: i=1; AL+hErFqZ+ogsKuIiJGKMxNHiEB1Uc+V/HWDQKZl1IB8xq6+24p3iLoXOX7R/Jvl8pqmJu9m5TmmWNc=@lists.linux.dev
X-Gm-Message-State: APuU4Z/ePV3tCGj5eLRlYAOl2vwcgtDvbMUHyl+HtTXHFX6hwzXVwWuk
	+1daj3EbAG/T9kz02yiVQwZfPdaNJ6g9s/1SSgD6w4S+jlZSEhwF0spXhnltuvH6Rx63dhLpoSs
	bctjN5AmhctJy+RMRtOL5mfGB5w==
X-Received: from ilen3.prod.google.com ([2002:a05:6e02:13a3:b0:524:d8ac:6887])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6b8e:b0:521:561a:8e8c with SMTP id 5614622812f47-5797d6add74mr1519937b6e.33.1795114355656;
 Thu, 19 Nov 2026 10:52:35 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:02 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-21-coltonlewis@google.com>
Subject: [PATCH v10 20/33] perf/core: Prioritize kernel-owned pinned events
 when scheduling groups
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When scheduling event groups in visit_groups_merge(), pinned and
flexible groups are ordered by group_index (creation order). Normally,
kernel-owned pinned events such as the hardlockup NMI watchdog are
created at boot with group_index 0 and are scheduled ahead of userspace
events.

However, if the NMI watchdog is disabled and re-enabled at runtime
after a userspace pinned per-CPU event is already active, the
watchdog's group_index is larger than the userspace event's
group_index. When hardware counters are constrained (for example, when
PMU partitioning reserves counters for a guest and leaves only one
general-purpose counter for the host), the userspace pinned event
claims the remaining counter first and merge_sched_in() transitions the
kernel watchdog event into PERF_EVENT_STATE_ERROR.

Order pinned kernel-owned events (is_pinned_kernel_event()) ahead of
userspace pinned events in perf_event_groups_cmp() and
perf_less_group_idx() while leaving flexible groups ordered by
group_index for normal round-robin rotation.

Suggested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 kernel/events/core.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dbc42ded5f698..6b82029b8ebc5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -237,11 +237,16 @@ class_perf_ctx_lock_constructor(struct perf_cpu_context *cpuctx,
 
 #define TASK_TOMBSTONE ((void *)-1L)
 
-static bool is_kernel_event(struct perf_event *event)
+static bool is_kernel_event(const struct perf_event *event)
 {
 	return READ_ONCE(event->owner) == TASK_TOMBSTONE;
 }
 
+static bool is_pinned_kernel_event(const struct perf_event *event)
+{
+	return event->attr.pinned && is_kernel_event(event);
+}
+
 static DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
 
 struct perf_event_context *perf_cpu_task_ctx(void)
@@ -1781,7 +1786,8 @@ static inline struct cgroup *event_cgroup(const struct perf_event *event)
  */
 static __always_inline int
 perf_event_groups_cmp(const int left_cpu, const struct pmu *left_pmu,
-		      const struct cgroup *left_cgroup, const u64 left_group_index,
+		      const struct cgroup *left_cgroup, const bool left_kernel,
+		      const u64 left_group_index,
 		      const struct perf_event *right)
 {
 	if (left_cpu < right->cpu)
@@ -1824,6 +1830,9 @@ perf_event_groups_cmp(const int left_cpu, const struct pmu *left_pmu,
 	}
 #endif
 
+	if (left_kernel != is_pinned_kernel_event(right))
+		return left_kernel ? -1 : 1;
+
 	if (left_group_index < right->group_index)
 		return -1;
 	if (left_group_index > right->group_index)
@@ -1839,7 +1848,8 @@ static inline bool __group_less(struct rb_node *a, const struct rb_node *b)
 {
 	struct perf_event *e = __node_2_pe(a);
 	return perf_event_groups_cmp(e->cpu, e->pmu_ctx->pmu, event_cgroup(e),
-				     e->group_index, __node_2_pe(b)) < 0;
+				     is_pinned_kernel_event(e), e->group_index,
+				     __node_2_pe(b)) < 0;
 }
 
 struct __group_key {
@@ -1853,8 +1863,9 @@ static inline int __group_cmp(const void *key, const struct rb_node *node)
 	const struct __group_key *a = key;
 	const struct perf_event *b = __node_2_pe(node);
 
-	/* partial/subtree match: @cpu, @pmu, @cgroup; ignore: @group_index */
-	return perf_event_groups_cmp(a->cpu, a->pmu, a->cgroup, b->group_index, b);
+	/* partial/subtree match: @cpu, @pmu, @cgroup; ignore: @kernel, @group_index */
+	return perf_event_groups_cmp(a->cpu, a->pmu, a->cgroup,
+				     is_pinned_kernel_event(b), b->group_index, b);
 }
 
 static inline int
@@ -1863,9 +1874,9 @@ __group_cmp_ignore_cgroup(const void *key, const struct rb_node *node)
 	const struct __group_key *a = key;
 	const struct perf_event *b = __node_2_pe(node);
 
-	/* partial/subtree match: @cpu, @pmu, ignore: @cgroup, @group_index */
+	/* partial/subtree match: @cpu, @pmu, ignore: @cgroup, @kernel, @group_index */
 	return perf_event_groups_cmp(a->cpu, a->pmu, event_cgroup(b),
-				     b->group_index, b);
+				     is_pinned_kernel_event(b), b->group_index, b);
 }
 
 /*
@@ -4024,6 +4035,9 @@ static bool perf_less_group_idx(const void *l, const void *r, void __always_unus
 	const struct perf_event *le = *(const struct perf_event **)l;
 	const struct perf_event *re = *(const struct perf_event **)r;
 
+	if (is_pinned_kernel_event(le) != is_pinned_kernel_event(re))
+		return is_pinned_kernel_event(le);
+
 	return le->group_index < re->group_index;
 }
 
-- 
2.56.1.708.g77570a6a1d-goog

