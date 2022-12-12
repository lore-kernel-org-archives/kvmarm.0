Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F7F2585
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 12:59:16 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id 17so4542335pll.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 04:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC2iVrhN64qx0wh1++pd8s8D/4z8tTuZKSx0qqh+jVk=;
        b=oaByAgTh/mGEsWxXHZhNoHOBQEsZc14IJwDr2btqBiJxfwbgrsIlb9Be3eeDwVB8yn
         8lLvfVs9DcNU69/EZpheUyDC+TWzd9tcqcRnwZu9v5yKueGX//nlPtoCp+pg1dWf2WPs
         NeY/qq2otESM0rg3evIACrKeQazyqdSa9ZFwsl8ljsDk+OQKfpAnsnMljwczl4Kap00p
         j0+/r0QonsHnbcSKj8O4v35+txfNyJnf9UO2dBS+7JQ8O3nL3jNb2s1suZmIwpyHJka5
         leuOe9bT/YJY0KJ5bcpEuGjGDjy92bxqn/JQKaJi42HbpmKkn4L8mg9JH+9q8W628to0
         LHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eC2iVrhN64qx0wh1++pd8s8D/4z8tTuZKSx0qqh+jVk=;
        b=dUQiTHmd9ZvHlS8/eo6QhalYV7rTuE3e2pt86+lsFHY07qwX4gRAngisoiqlnod10P
         hihp1Bzf3Lw32pUcm5T8ISH7i8nhq5N9SUsGEjNRPSIpix+/9Px9eAO6mNdTxgzAAqj1
         uMAnVUVHtnkxqb0/Nhw5SmWYE/qB6WLPoDp2V1oCatBkgpzn/xrujWiU7oBvDht2houj
         SJzvfBpLU1Igg9XoqtFD8SdsNvB7wGj2eRU+63Jo2LGmmD7bstFmajfEiWFBPt9VkpSO
         CzsXRnmVJJg8wMPAOcH3crNw+MNxI49WwUCL9D2nRPmLJkXM0gsCvnHLFj5T5N4oD8wd
         5AXQ==
X-Gm-Message-State: ANoB5pmWBrtcxr3GizdU2kihgrc1vRjzZVc/9oKKIddpJQJevj3b9lbv
	d1NMNeRzunPn58bEZ7XyCIs=
X-Google-Smtp-Source: AA0mqf4KTmGbap+xoQWGEIBCNcnSByCIwuI9ifKJmSUv2uj5R1Bvnm7bWWoLlnJCQMM8sJMN59So0A==
X-Received: by 2002:a17:902:ba95:b0:185:441f:7091 with SMTP id k21-20020a170902ba9500b00185441f7091mr15323679pls.22.1670849956058;
        Mon, 12 Dec 2022 04:59:16 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:15 -0800 (PST)
From: Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Fenghua Yu <fenghua.yu@intel.com>,
	kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org
Subject: [PATCH RFC 1/8] perf/core: Add *group_leader to perf_event_create_kernel_counter()
Date: Mon, 12 Dec 2022 20:58:37 +0800
Message-Id: <20221212125844.41157-2-likexu@tencent.com>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20221212125844.41157-1-likexu@tencent.com>
References: <20221212125844.41157-1-likexu@tencent.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Like Xu <likexu@tencent.com>

Like syscalls users, kernel-space perf_event creators may also use group
counters abstraction to gain pmu functionalities, and an in-kernel counter
groups behave much like normal 'single' counters, following the group
semantics-based behavior.

No functional changes at this time. An example will be that KVM creates
Intel slot event as group leader and other topdown metric events to emulate
MSR_PERF_METRICS pmu capability for guests.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: kvmarm@lists.linux.dev
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/arm64/kvm/pmu-emul.c                 | 4 ++--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 4 ++--
 arch/x86/kvm/pmu.c                        | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c              | 2 +-
 include/linux/perf_event.h                | 1 +
 kernel/events/core.c                      | 4 +++-
 kernel/events/hw_breakpoint.c             | 4 ++--
 kernel/events/hw_breakpoint_test.c        | 2 +-
 kernel/watchdog_hld.c                     | 2 +-
 9 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..11c3386bc86b 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -624,7 +624,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 
 	attr.sample_period = compute_period(pmc, kvm_pmu_get_pmc_value(pmc));
 
-	event = perf_event_create_kernel_counter(&attr, -1, current,
+	event = perf_event_create_kernel_counter(&attr, -1, current, NULL,
 						 kvm_pmu_perf_overflow, pmc);
 
 	if (IS_ERR(event)) {
@@ -713,7 +713,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	attr.config = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
 	attr.sample_period = GENMASK(63, 0);
 
-	event = perf_event_create_kernel_counter(&attr, -1, current,
+	event = perf_event_create_kernel_counter(&attr, -1, current, NULL,
 						 kvm_pmu_perf_overflow, &attr);
 
 	if (IS_ERR(event)) {
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index d961ae3ed96e..43e54bb200cd 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -952,12 +952,12 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	u64 tmp;
 
 	miss_event = perf_event_create_kernel_counter(miss_attr, plr->cpu,
-						      NULL, NULL, NULL);
+						      NULL, NULL, NULL, NULL);
 	if (IS_ERR(miss_event))
 		goto out;
 
 	hit_event = perf_event_create_kernel_counter(hit_attr, plr->cpu,
-						     NULL, NULL, NULL);
+						     NULL, NULL, NULL, NULL);
 	if (IS_ERR(hit_event))
 		goto out_miss;
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index eb594620dd75..f6c8180241d7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -204,7 +204,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 			attr.precise_ip = 3;
 	}
 
-	event = perf_event_create_kernel_counter(&attr, -1, current,
+	event = perf_event_create_kernel_counter(&attr, -1, current, NULL,
 						 kvm_perf_overflow, pmc);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f951dc756456..b746381307c7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -299,7 +299,7 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1,
-						current, NULL, NULL);
+						current, NULL, NULL, NULL);
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("%s: failed %ld\n",
 					__func__, PTR_ERR(event));
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0031f7b4d9ab..5f34e1d0bff8 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1023,6 +1023,7 @@ extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
 				struct task_struct *task,
+				struct perf_event *group_leader,
 				perf_overflow_handler_t callback,
 				void *context);
 extern void perf_pmu_migrate_context(struct pmu *pmu,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7f04f995c975..f671b1a9a691 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12674,12 +12674,14 @@ SYSCALL_DEFINE5(perf_event_open,
  * @attr: attributes of the counter to create
  * @cpu: cpu in which the counter is bound
  * @task: task to profile (NULL for percpu)
+ * @group_leader: event group leader
  * @overflow_handler: callback to trigger when we hit the event
  * @context: context data could be used in overflow_handler callback
  */
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 				 struct task_struct *task,
+				 struct perf_event *group_leader,
 				 perf_overflow_handler_t overflow_handler,
 				 void *context)
 {
@@ -12694,7 +12696,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	if (attr->aux_output)
 		return ERR_PTR(-EINVAL);
 
-	event = perf_event_alloc(attr, cpu, task, NULL, NULL,
+	event = perf_event_alloc(attr, cpu, task, group_leader, NULL,
 				 overflow_handler, context, -1);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index c3797701339c..65b5b1421e62 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -771,7 +771,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    void *context,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk, triggered,
+	return perf_event_create_kernel_counter(attr, -1, tsk, NULL, triggered,
 						context);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
@@ -881,7 +881,7 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 
 	cpus_read_lock();
 	for_each_online_cpu(cpu) {
-		bp = perf_event_create_kernel_counter(attr, cpu, NULL,
+		bp = perf_event_create_kernel_counter(attr, cpu, NULL, NULL,
 						      triggered, context);
 		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
diff --git a/kernel/events/hw_breakpoint_test.c b/kernel/events/hw_breakpoint_test.c
index c57610f52bb4..b3597df12284 100644
--- a/kernel/events/hw_breakpoint_test.c
+++ b/kernel/events/hw_breakpoint_test.c
@@ -39,7 +39,7 @@ static struct perf_event *register_test_bp(int cpu, struct task_struct *tsk, int
 	attr.bp_addr = (unsigned long)&break_vars[idx];
 	attr.bp_len = HW_BREAKPOINT_LEN_1;
 	attr.bp_type = HW_BREAKPOINT_RW;
-	return perf_event_create_kernel_counter(&attr, cpu, tsk, NULL, NULL);
+	return perf_event_create_kernel_counter(&attr, cpu, tsk, NULL, NULL, NULL);
 }
 
 static void unregister_test_bp(struct perf_event **bp)
diff --git a/kernel/watchdog_hld.c b/kernel/watchdog_hld.c
index 247bf0b1582c..bb755dadba54 100644
--- a/kernel/watchdog_hld.c
+++ b/kernel/watchdog_hld.c
@@ -173,7 +173,7 @@ static int hardlockup_detector_event_create(void)
 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
 
 	/* Try to register using hardware perf events */
-	evt = perf_event_create_kernel_counter(wd_attr, cpu, NULL,
+	evt = perf_event_create_kernel_counter(wd_attr, cpu, NULL, NULL,
 					       watchdog_overflow_callback, NULL);
 	if (IS_ERR(evt)) {
 		pr_debug("Perf event create on CPU %d failed with %ld\n", cpu,
-- 
2.38.2

