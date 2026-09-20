Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33304825B7
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933180; cv=none; b=lCwyKJmeQfNyWBKhyPs7vdv9SRbq+KGF9aX0V05zo1ZxoiQsvcrRVZP1d5T6bNWed3tcXsyILOhngsvcjljhsFrtO0Eh/BKzK59ZvxEmZgkjUTLsavkDMJ1WNRFzG0/MzNsi3pVvy8g6I4SOHXuOKoKA4aCb0PfiurdZXCynMKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933180; c=relaxed/simple;
	bh=78Oj5iRg2iS0yUQr9Ohdj/zGQg4mp9fYA4cUdml6pdk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvJ8mPkMkR3pNTNtgfoQdDnkSJW5MxcV8BvgXJeYJe7ZxbhWRpjoQ+MynAqOJTrl9SiX7/xEOsj+m5pCImjv0mgJ1+IPDGogaaaaeNaqduG/q74pDwc1bjZNy1yn7/+i+oO2UoQNfHoPdUv4je2IiuBipw3w6nEp26nLUs8CMNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=fDH1zDmJ; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="fDH1zDmJ"
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e50968489so2009170d50.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933175; x=1790537975; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lFt/o0KNYbZHy97cErlVMXJCCdXfeb4ZyjWQT3y79I4=;
        b=fDH1zDmJDOmIhZJ7gsBsmQiHE0+xTsC+8qgx4GFGAeDUbsVa3yapS4lUvQKFK5gSxF
         9uFJMa6u3WvKWMD+t6ZcTNqkj9MdPdF3CVlWgr7FBU1WL/B4Y0rDyTYLaCn0hM71oXKl
         JE+x50f/Zpp5hnCQ17GSpFxm3FI0IRvKJ44XPK7wvwMPpRnaJ0DSGOafo0JJXBBCb1sd
         l0H9ThdBVU32R/yYP9IhNLbtGLHJc7vu88Nu9w6XfhVkAQ58tuhhJ1Nj4smAEiDTpU1c
         W9hXnxJzATX3jDf5dbs2I+v8rqYJ8oRryscOCCZuHQiwqlCSJbLcswyNvnyh3VRC3gLH
         0W/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933175; x=1790537975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=lFt/o0KNYbZHy97cErlVMXJCCdXfeb4ZyjWQT3y79I4=;
        b=EICWNMfrVTYQBLOPfkiRweNoWnsG6tLATzzJLNlOP58lHlmcrvT0OVN0wFVeOzMOXv
         9vpgfA9PrYZxaLa6mzT6EF7U42mnKq2HYTtOWjNUCQK/jmEBXDueH8uLqRaeU5SpeceG
         zHQsrwqGWxkmSuSYw6TD5YdUJwH5DmIeqDDsn1hSsantXazHoWYi6sbqhfiflYLRurvQ
         in1LaxEh4Jug7jA45mPdAMPhr3lPxTcViDeSUarrzOb/Py3KVb1AFz09RGxQEOJhAUZO
         u4qfmuihhRHPzVF0v3UuBr7arnjgrDMiCZKtuPBBl5VELU0M5Mj0Zs+ct/tic4fBdH8H
         NoTw==
X-Forwarded-Encrypted: i=1; AKwUvByZwVLOFccKXrt0BPFRG7NeO7aQidKRSJs98H1JktW5yadULUyXV7ab+aPos2t4hRm1MmSmtjg=@lists.linux.dev
X-Gm-Message-State: AFuF++kUzjboXJsT2Pvrx/cQK1OzHrSOl39Z8w5WCDS9NgvICdiWQ6pB
	FuApALrs35H+t7E9bRqZruTb/1Pj2bCfVFh/bFt0wGtNfuLOr7LNPE/2Mu05ZGyb51c=
X-Gm-Gg: AYBFou3DKS2oW/HidSH/z7Lbq38Mh3OK8X6OTV8emjpwRdjjXZCd6gm1WZqRo5SkZvX
	VvA7TgKiBxpRvU+aT6VOK+zEmI0cDxtRVsXSO+DDVEFw9zw3rhybYXYRPF+nP9EastRJmIw0O2y
	0YJwSxMrxAiMEdLkTP9XONMbBugHpDeNhDUc1ClOpYfkL82xgS637cMg06MozCMGXl0Rj94dudw
	bE7FOk8l8lfhOq9fenm77obVFgMtoypa3sMJITE2t7AJseg6eEt14Bm1WYkFCpRnmcJ0gD1ePsR
	E334x/EiZgFDc+CrLwCs1qvsc1xPJwFQgLTbh9DzG7/Ba1bcMTUi7dibXF8FENNhJaY5r2Su5Bt
	xNodd32zVSs963IKO7gX6B78pACv2s7uu3uQMwLix9TT5KcK8fN/66839MiNN9UR4QoXlvVaNH7
	zr3Nd5DiR+cdgrpQ8fty6GzjIEqirbTQs1Enu8yhth8Fi5XtYoSrYNp0qjvkTrWoGyNEEJzN2a8
	X+yWLonpUgEgVipZGWzabFV5wtVbLgR/NtfoiDHYZ4oJgUX7rpyTv44MCfc9CTz9YRGn8JEGZu6
	wl0gFYGAMPp89PLodi/1
X-Received: by 2002:a05:690e:1902:b0:671:70e4:5180 with SMTP id 956f58d0204a3-6717fdfb83fmr2660413d50.106.1789933174452;
        Sun, 20 Sep 2026 12:39:34 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6729910a52dsm2551721d50.16.2026.09.20.12.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:34 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 27/46] oncore: Implement on-core session lifecycle and scheduling loop
Date: Sun, 20 Sep 2026 15:36:31 -0400
Message-ID: <20260920193650.3373435-28-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement On-Core session management, job submission and cancellation,
isolated address space mapping helpers, and the round-robin time-sliced
scheduling loop for preserved physical CPUs in kernel/liveupdate/oncore.c,
and include the On-Core kernel-doc documentation in
Documentation/liveupdate/cpu_preservation.rst.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/liveupdate/cpu_preservation.rst |  14 +
 kernel/liveupdate/Makefile                    |  12 +
 kernel/liveupdate/cpu_preserve.c              |  15 +
 kernel/liveupdate/oncore.c                    | 947 ++++++++++++++++++
 4 files changed, 988 insertions(+)
 create mode 100644 kernel/liveupdate/oncore.c

diff --git a/Documentation/liveupdate/cpu_preservation.rst b/Documentation/liveupdate/cpu_preservation.rst
index a7a534188685..605d808e61c8 100644
--- a/Documentation/liveupdate/cpu_preservation.rst
+++ b/Documentation/liveupdate/cpu_preservation.rst
@@ -18,6 +18,20 @@ Architecture Backend Interface
 
 .. kernel-doc:: include/linux/cpu_preserve.h
 
+On-Core Execution and Scheduling Framework
+==========================================
+
+.. kernel-doc:: kernel/liveupdate/oncore.c
+   :doc: On-Core Execution and Scheduling Framework
+
+On-Core Session & Job API
+=========================
+
+.. kernel-doc:: include/linux/oncore.h
+
+.. kernel-doc:: kernel/liveupdate/oncore.c
+   :identifiers:
+
 CPU Preservation ABI
 ====================
 
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index 486f7854bb75..ab0d44079fb2 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,6 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0
 
+KASAN_SANITIZE_cpu_preserve.o := n
+KCSAN_SANITIZE_cpu_preserve.o := n
+UBSAN_SANITIZE_cpu_preserve.o := n
+KCOV_INSTRUMENT_cpu_preserve.o := n
+KASAN_SANITIZE_oncore.o := n
+KCSAN_SANITIZE_oncore.o := n
+UBSAN_SANITIZE_oncore.o := n
+KCOV_INSTRUMENT_oncore.o := n
+CFLAGS_REMOVE_cpu_preserve.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_oncore.o = $(CC_FLAGS_FTRACE)
 CFLAGS_cpu_preserve.o += $(call cc-option,-mbranch-protection=none) -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
+CFLAGS_oncore.o       += $(call cc-option,-mbranch-protection=none) -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
 
 luo-y :=								\
 		kho_block.o						\
@@ -14,3 +25,4 @@ obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
 obj-$(CONFIG_LIVEUPDATE_CPU)		+= cpu_preserve.o
+obj-$(CONFIG_LIVEUPDATE_ONCORE)		+= oncore.o
diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
index 9a039ba9e912..430afbca860d 100644
--- a/kernel/liveupdate/cpu_preserve.c
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -178,6 +178,7 @@
 #include <linux/liveupdate.h>
 #include <linux/mm.h>
 #include <linux/objtool.h>
+#include <linux/oncore.h>
 #include <linux/reboot.h>
 
 #include <asm/sections.h>
@@ -1552,14 +1553,22 @@ static int cpu_preserve_preserve(struct liveupdate_file_op_args *args)
 	if (ret)
 		return ret;
 
+	ret = oncore_session_add_cpu(args->session, cpu);
+	if (ret) {
+		cpu_unpreserve(cpu);
+		return ret;
+	}
+
 	fser = kho_alloc_preserve(sizeof(*fser));
 	if (IS_ERR(fser)) {
 		cpu_unpreserve(cpu);
+		oncore_session_remove_cpu(args->session, cpu);
 		return PTR_ERR(fser);
 	}
 
 	memset(fser, 0, sizeof(*fser));
 	fser->cpu = cpu;
+	KHOSER_STORE_PTR(fser->oncore, oncore_session_get_ser(args->session));
 
 	scoped_guard(mutex, &cpu_preserved_lock)
 		fser->stack_pa = cpu_preserved_outgoing.pcpus[cpu].stack_pa;
@@ -1580,6 +1589,7 @@ static void cpu_preserve_unpreserve(struct liveupdate_file_op_args *args)
 	cpu = fser->cpu;
 
 	cpu_unpreserve(cpu);
+	oncore_session_remove_cpu(args->session, cpu);
 
 	kho_unpreserve_free(fser);
 }
@@ -1587,8 +1597,12 @@ static void cpu_preserve_unpreserve(struct liveupdate_file_op_args *args)
 static void cpu_preserve_restore_incoming_cpu(struct liveupdate_session *session,
 					      struct cpu_preserved_file_ser *fser)
 {
+	struct oncore_session_ser *oncore = KHOSER_LOAD_PTR(fser->oncore);
 	unsigned int cpu = fser->cpu;
 
+	if (oncore)
+		oncore_session_restore(session, oncore);
+
 	scoped_guard(mutex, &cpu_preserved_lock) {
 		cpumask_set_cpu(cpu, &cpu_preserved_incoming.mask);
 		cpumask_set_cpu(cpu, &cpu_preserved_mask);
@@ -1646,6 +1660,7 @@ static void cpu_preserve_finish(struct liveupdate_file_op_args *args)
 		cpu_preserve_restore_incoming_cpu(args->session, fser);
 
 	cpu_unpreserve(fser->cpu);
+	oncore_session_remove_cpu(args->session, fser->cpu);
 
 	kho_restore_free(fser);
 }
diff --git a/kernel/liveupdate/oncore.c b/kernel/liveupdate/oncore.c
new file mode 100644
index 000000000000..196ed0a67563
--- /dev/null
+++ b/kernel/liveupdate/oncore.c
@@ -0,0 +1,947 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * On-Core Session and Scheduler Framework for Live Update
+ */
+
+/**
+ * DOC: On-Core Execution and Scheduling Framework
+ *
+ * The On-Core framework enables latency-sensitive workloads to continue
+ * executing directly on preserved physical CPUs (__cpu_preserved_text /
+ * __cpu_preserved_data) across a kexec Live Update (CONFIG_LIVEUPDATE_CPU)
+ * while the outgoing host kernel shuts down and the incoming kernel boots.
+ *
+ * Each Live Update session (struct liveupdate_session) can create an
+ * oncore_session that manages:
+ *
+ * 1. Isolated Address Space (struct cpu_preserved_as):
+ *    Page tables containing only the preserved runtime text/data sections,
+ *    the session and runqueue metadata, and workload-specific buffers
+ *    explicitly mapped via oncore_session_map_range() or
+ *    oncore_session_map_buffer().
+ *
+ * 2. Preserved Physical CPU Pool:
+ *    One or more physical CPUs isolated from Linux scheduling via
+ *    cpu_preserve and attached to the session via oncore_session_add_cpu().
+ *    Each preserved CPU switches to the session's isolated page tables and
+ *    executes oncore_cpu_schedule_loop().
+ *
+ * 3. Cooperative Time-Sliced Runqueue (struct oncore_runqueue):
+ *    A lockless/atomic round-robin FIFO scheduler supporting M jobs across N
+ *    preserved physical CPUs (including M > N oversubscription).  It provides
+ *    initial-run starvation avoidance, least-loaded CPU assignment, work
+ *    stealing, single-job fast-path continuation, and low-power backoff (WFE on
+ *    arm64, PAUSE on x86) when the queue is idle or a job returns
+ *    ONCORE_EXIT_STALL.
+ *
+ * Integration with KVM Caretaker and Future Kernel Caretaker Workloads
+ * --------------------------------------------------------------------
+ * On-Core is workload- and hypervisor-agnostic:
+ *
+ * - KVM Caretaker: During LUO prepare/freeze, KVM detaches each vCPU into a
+ *   self-contained KHO-preserved Caretaker page (caretaker_x86_page on x86,
+ *   caretaker_arm64_page on arm64), maps the page and guest/virtualization
+ *   structures into the session's address space, and submits an oncore_job
+ *   whose callback enters the guest (VMLAUNCH/VMRESUME, VMRUN, or EL2 world
+ *   switch) until the time-slice deadline (deadline_ticks) expires, the vCPU
+ *   yields on HLT/WFI (ONCORE_EXIT_YIELD_IDLE), hits an exit requiring the
+ *   incoming kernel (ONCORE_EXIT_STALL), or observes the incoming kernel's
+ *   reclaim signal (ONCORE_EXIT_ATTACH_SIGNALED).
+ *
+ * - Future Kernel Caretaker Workloads: Any self-contained kernel subsystem
+ *   compiled into the preserved runtime sections (such as hardware watchdog
+ *   feeders, health/heartbeat responders, or zero-loss network/storage
+ *   polling drivers) can submit an oncore_job_fn(void *data, u64 deadline) to
+ *   share preserved physical cores alongside or independently of KVM vCPUs.
+ *
+ * Architecture Requirements
+ * -------------------------
+ * To support CONFIG_LIVEUPDATE_ONCORE, an architecture must implement:
+ *
+ * - <asm/oncore.h>:
+ *   - arch_oncore_read_counter(): Read a monotonic hardware counter directly
+ *     from __cpu_preserved_text without relying on kernel timekeeping
+ *     (e.g., rdtsc() on x86, __arch_counter_get_cntpct() on arm64).
+ *   - arch_oncore_counter_freq_hz(): Return the hardware counter frequency in
+ *     Hz used to convert the time quantum (oncore.quantum_ms) into ticks.
+ *
+ * - <asm/cpu_preserve.h> (from CONFIG_LIVEUPDATE_CPU):
+ *   - arch_cpu_preserved_switch_pgd(): Switch to the session's isolated PGD.
+ *   - arch_cpu_preserved_park_wait() / arch_cpu_preserved_kick(): Low-power
+ *     wait instruction and cross-CPU wakeup mechanism.
+ *
+ * Public Interfaces (<linux/oncore.h>)
+ * ------------------------------------
+ * - Session & CPU Lifecycle:
+ *   oncore_session_add_cpu(), oncore_session_remove_cpu(),
+ *   oncore_session_get_ser(), oncore_session_restore().
+ * - Session Address Space Mapping:
+ *   oncore_session_map_range(), oncore_session_map_buffer(),
+ *   oncore_session_get_pgd_pa().
+ * - Job Submission & Control:
+ *   oncore_session_submit_job(), oncore_job_set_data(),
+ *   oncore_job_cpu(), oncore_job_session(),
+ *   oncore_session_activate_job(), oncore_session_cancel_job().
+ */
+
+#define pr_fmt(fmt) "oncore: " fmt
+
+#include <linux/cpu_preserve.h>
+#include <linux/cpumask.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kexec.h>
+#include <linux/kexec_handover.h>
+#include <linux/list.h>
+#include <linux/liveupdate.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/oncore.h>
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#define ONCORE_DEFAULT_QUANTUM_MS	10
+#define ONCORE_CANCEL_TIMEOUT_US	1000000
+#define ONCORE_CANCEL_STEP_US		100
+
+enum oncore_job_state {
+	ONCORE_JOB_NEW = 0,
+	ONCORE_JOB_RUNNABLE,
+	ONCORE_JOB_RUNNING,
+	ONCORE_JOB_CANCELING,
+	ONCORE_JOB_DEAD,
+};
+
+struct oncore_job {
+	struct list_head		node;
+	struct list_head		sess_node;
+	phys_addr_t			next_job_pa;
+	struct oncore_session		*session;
+	enum oncore_job_state		state;
+	oncore_job_fn			run_fn;
+	void				*data;
+	int				assigned_cpu;
+	int				last_cpu;
+	u64				total_runs;
+};
+
+struct oncore_sched_config {
+	u32				quantum_ms;
+	u64				quantum_ticks;
+	u64				counter_freq_hz;
+};
+
+struct oncore_runqueue {
+	atomic_t			lock;
+	struct list_head		runnable;
+	unsigned int			nr_runnable;
+};
+
+struct oncore_session {
+	struct list_head		node;
+	/* Protects session state and job list */
+	struct mutex			lock;
+	struct list_head		jobs;
+	phys_addr_t			first_job_pa;
+	struct oncore_runqueue		rq;
+	struct oncore_sched_config	sched_config;
+	struct cpu_preserved_as		*as;
+	struct oncore_session_ser	*ser;
+	bool				is_incoming;
+};
+
+static struct oncore_sched_config global_oncore_sched_config __cpu_preserved_data;
+static DEFINE_MUTEX(oncore_sessions_lock);
+static LIST_HEAD(oncore_sessions);
+
+static inline struct cpumask *oncore_session_cpus(struct oncore_session *sess)
+{
+	return to_cpumask((unsigned long *)sess->ser->cpus_bitmap);
+}
+
+static inline void oncore_rq_lock(struct oncore_runqueue *rq)
+{
+	while (atomic_cmpxchg_acquire(&rq->lock, 0, 1) != 0) {
+		while (atomic_read(&rq->lock) != 0)
+			cpu_relax();
+	}
+}
+
+static inline void oncore_rq_unlock(struct oncore_runqueue *rq)
+{
+	atomic_set_release(&rq->lock, 0);
+}
+
+static int __init parse_oncore_quantum(char *arg)
+{
+	u32 val;
+
+	if (kstrtou32(arg, 0, &val) == 0 && val >= 1 && val <= 1000)
+		global_oncore_sched_config.quantum_ms = val;
+	return 0;
+}
+early_param("oncore.quantum_ms", parse_oncore_quantum);
+
+static void oncore_sched_update_ticks(void)
+{
+	u32 ms = global_oncore_sched_config.quantum_ms ? : ONCORE_DEFAULT_QUANTUM_MS;
+	u64 freq = arch_oncore_counter_freq_hz();
+
+	global_oncore_sched_config.counter_freq_hz = freq;
+	global_oncore_sched_config.quantum_ticks = (freq * ms) / 1000ULL;
+}
+
+static void oncore_runqueue_init(struct oncore_runqueue *rq)
+{
+	atomic_set(&rq->lock, 0);
+	INIT_LIST_HEAD(&rq->runnable);
+	rq->nr_runnable = 0;
+}
+
+static int oncore_sched_enqueue(struct oncore_runqueue *rq,
+				struct oncore_job *job)
+{
+	int cpu;
+
+	oncore_rq_lock(rq);
+	job->state = ONCORE_JOB_RUNNABLE;
+	list_add_tail(&job->node, &rq->runnable);
+	rq->nr_runnable++;
+	oncore_rq_unlock(rq);
+
+	for_each_cpu(cpu, oncore_session_cpus(job->session)) {
+		if (cpu_is_preserved(cpu))
+			arch_cpu_preserved_kick(cpu);
+	}
+
+	return 0;
+}
+
+static int oncore_sched_dequeue(struct oncore_runqueue *rq,
+				struct oncore_job *job)
+{
+	oncore_rq_lock(rq);
+	if (!list_empty(&job->node)) {
+		list_del_init(&job->node);
+		rq->nr_runnable--;
+	}
+	if (job->state == ONCORE_JOB_RUNNING)
+		job->state = ONCORE_JOB_CANCELING;
+	else
+		job->state = ONCORE_JOB_DEAD;
+	oncore_rq_unlock(rq);
+	return 0;
+}
+
+static struct oncore_job *__cpu_preserved_text
+oncore_sched_pick_next(struct oncore_runqueue *rq, int cpu)
+{
+	struct oncore_job *job = NULL, *iter;
+
+	if (!rq || READ_ONCE(rq->nr_runnable) == 0)
+		return NULL;
+
+	oncore_rq_lock(rq);
+
+	/* 1. Starvation avoidance: if head job has NEVER run, take it immediately */
+	if (!list_empty(&rq->runnable)) {
+		iter = list_first_entry(&rq->runnable, struct oncore_job, node);
+		if (iter->total_runs == 0) {
+			job = iter;
+			goto found;
+		}
+	}
+
+	/* 2. Prefer job affine to this core */
+	list_for_each_entry(iter, &rq->runnable, node) {
+		if (iter->assigned_cpu == cpu) {
+			job = iter;
+			goto found;
+		}
+	}
+
+	/* 3. Work-stealing fallback: take oldest job from head of queue */
+	if (!list_empty(&rq->runnable))
+		job = list_first_entry(&rq->runnable, struct oncore_job, node);
+
+found:
+	if (job) {
+		list_del_init(&job->node);
+		rq->nr_runnable--;
+	}
+
+	oncore_rq_unlock(rq);
+	return job;
+}
+
+static void __cpu_preserved_text
+oncore_sched_put_prev(struct oncore_runqueue *rq,
+		      struct oncore_job *job)
+{
+	oncore_rq_lock(rq);
+	job->state = ONCORE_JOB_RUNNABLE;
+	list_add_tail(&job->node, &rq->runnable);
+	rq->nr_runnable++;
+	oncore_rq_unlock(rq);
+}
+
+static void __cpu_preserved_text
+oncore_cpu_schedule_loop(int cpu, struct oncore_runqueue *rq,
+			 struct oncore_sched_config *cfg)
+{
+	enum oncore_exit_reason reason;
+	struct oncore_job *curr = NULL;
+	u64 deadline;
+
+	if (!rq || !cfg)
+		return;
+
+	while (!cpu_preserved_should_exit(cpu)) {
+		/* 1. Pick the next runnable job from the FIFO queue */
+		if (!curr) {
+			curr = oncore_sched_pick_next(rq, cpu);
+			if (!curr) {
+				/* No runnable jobs; execute low-power park wait */
+				arch_cpu_preserved_park_wait();
+				continue;
+			}
+		}
+
+		/* 2. Compute quantum deadline */
+		deadline = arch_oncore_read_counter() + cfg->quantum_ticks;
+
+		/* 3. Execute workload on physical silicon */
+		curr->last_cpu = cpu;
+		curr->state = ONCORE_JOB_RUNNING;
+		reason = curr->run_fn(curr->data, deadline);
+
+		/* 4. Update telemetry and accounting */
+		curr->total_runs++;
+
+		/*
+		 * A stalled job cannot make progress until the incoming kernel
+		 * reclaims it, so re-running it immediately would just repeat
+		 * the same unhandled exit as fast as the hardware allows.  Back
+		 * off in the architecture's low-power wait (WFE on arm64, PAUSE
+		 * on x86) first.  arch_cpu_preserved_kick() wakes it, so the
+		 * attach signal is still observed promptly by the checks below
+		 * and at the top of the loop.
+		 */
+		if (reason == ONCORE_EXIT_STALL)
+			arch_cpu_preserved_park_wait();
+
+		/* Fast-path: single runnable job continues uninterrupted */
+		if (READ_ONCE(rq->nr_runnable) == 0 &&
+		    READ_ONCE(curr->state) == ONCORE_JOB_RUNNING &&
+		    reason != ONCORE_EXIT_ATTACH_SIGNALED &&
+		    reason != ONCORE_EXIT_ERROR &&
+		    !cpu_preserved_should_exit(cpu)) {
+			continue;
+		}
+
+		/* 5. Handle exit and return job to queue */
+		oncore_rq_lock(rq);
+		if (curr->state == ONCORE_JOB_CANCELING ||
+		    curr->state == ONCORE_JOB_DEAD ||
+		    reason == ONCORE_EXIT_ATTACH_SIGNALED ||
+		    reason == ONCORE_EXIT_ERROR) {
+			WRITE_ONCE(curr->state, ONCORE_JOB_DEAD);
+			oncore_rq_unlock(rq);
+			curr = NULL;
+			continue;
+		}
+		oncore_rq_unlock(rq);
+
+		oncore_sched_put_prev(rq, curr);
+		curr = NULL;
+	}
+}
+
+static void __cpu_preserved_text oncore_sched_cpu_worker(void *data)
+{
+	struct cpu_preserved_stack_context *sctx = cpu_preserved_get_stack_context();
+	struct oncore_session *sess;
+	int cpu;
+
+	if (!sctx)
+		return;
+
+	sess = sctx->workload_context ?
+		(struct oncore_session *)(uintptr_t)sctx->workload_context :
+		data;
+	if (!sess)
+		return;
+	cpu = sctx->cpu;
+
+	if (sctx->session_pgd_pa)
+		arch_cpu_preserved_switch_pgd(sctx->session_pgd_pa);
+
+	oncore_cpu_schedule_loop(cpu, &sess->rq, &sess->sched_config);
+}
+
+static int __init oncore_sched_init(void)
+{
+	if (!arch_oncore_counter_freq_hz()) {
+		pr_err("Counter frequency is unknown; on-core scheduler disabled\n");
+		return -ENODEV;
+	}
+	if (!global_oncore_sched_config.quantum_ms)
+		global_oncore_sched_config.quantum_ms = ONCORE_DEFAULT_QUANTUM_MS;
+	oncore_sched_update_ticks();
+	pr_info("Round-Robin scheduler initialized (quantum=%u ms, ticks=%llu)\n",
+		global_oncore_sched_config.quantum_ms,
+		global_oncore_sched_config.quantum_ticks);
+	return 0;
+}
+early_initcall(oncore_sched_init);
+
+/**
+ * oncore_session_map_range - Map a physical memory range into the session's address space
+ * @sess: On-Core session (may be %NULL to map into the global preserved address space).
+ * @pa:   Start physical address of the range.
+ * @va:   Target virtual address in the isolated page tables.
+ * @size: Size of the mapping in bytes.
+ * @prot: Page protection flags.
+ *
+ * Maps `[pa, pa + size)` at `@va` in the isolated page tables used by
+ * preserved CPUs executing workloads in @sess across kexec.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int oncore_session_map_range(struct oncore_session *sess, phys_addr_t pa,
+			     unsigned long va, size_t size, pgprot_t prot)
+{
+	return cpu_preserved_map_range(pa, va, size, prot);
+}
+EXPORT_SYMBOL_GPL(oncore_session_map_range);
+
+/**
+ * oncore_session_map_buffer - Map a direct-map kernel buffer into the session's address space
+ * @sess: On-Core session.
+ * @va:   Kernel direct-map virtual address of the buffer (no-op if %NULL).
+ * @size: Size of the buffer in bytes (no-op if 0).
+ *
+ * Convenience helper that resolves `virt_to_phys(@va)` and maps the buffer at
+ * its existing kernel virtual address `@va` with %PAGE_KERNEL permissions in
+ * the session's isolated page tables.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int oncore_session_map_buffer(struct oncore_session *sess, void *va,
+			      size_t size)
+{
+	if (!va || !size)
+		return 0;
+	return oncore_session_map_range(sess, virt_to_phys(va),
+					(unsigned long)va, size, PAGE_KERNEL);
+}
+EXPORT_SYMBOL_GPL(oncore_session_map_buffer);
+
+/**
+ * oncore_session_get_pgd_pa - Return the root page table physical address of a session
+ * @sess: On-Core session.
+ *
+ * Return: Physical address of the session's isolated PGD, or 0 if @sess or its
+ *         address space is %NULL.
+ */
+phys_addr_t oncore_session_get_pgd_pa(struct oncore_session *sess)
+{
+	return (sess && sess->as) ? sess->as->pgd_pa : 0;
+}
+EXPORT_SYMBOL_GPL(oncore_session_get_pgd_pa);
+
+static struct oncore_session *oncore_find_session_locked(const char *sname)
+{
+	struct oncore_session *sess;
+
+	if (!sname || !sname[0])
+		return NULL;
+
+	list_for_each_entry(sess, &oncore_sessions, node) {
+		if (strcmp(sess->ser->session_name, sname) == 0)
+			return sess;
+	}
+
+	return NULL;
+}
+
+static struct oncore_session *oncore_find_session(struct liveupdate_session *s)
+{
+	guard(mutex)(&oncore_sessions_lock);
+
+	return oncore_find_session_locked(liveupdate_session_name(s));
+}
+
+static struct oncore_session *oncore_create_session_locked(const char *sname)
+{
+	unsigned int nr_ser_words = BITS_TO_U64(nr_cpu_ids);
+	struct oncore_session *sess;
+	size_t ser_sz;
+
+	ser_sz = struct_size(sess->ser, cpus_bitmap, nr_ser_words);
+
+	sess = kho_alloc_preserve(sizeof(*sess));
+	if (IS_ERR(sess))
+		return NULL;
+
+	memset(sess, 0, sizeof(*sess));
+	mutex_init(&sess->lock);
+	INIT_LIST_HEAD(&sess->jobs);
+	oncore_runqueue_init(&sess->rq);
+	oncore_sched_update_ticks();
+	sess->sched_config = global_oncore_sched_config;
+
+	sess->as = cpu_preserved_as_create();
+	if (IS_ERR(sess->as))
+		sess->as = NULL;
+
+	oncore_session_map_range(sess, virt_to_phys(sess),
+				 (unsigned long)sess, sizeof(*sess),
+				 PAGE_KERNEL);
+
+	sess->ser = kho_alloc_preserve(ser_sz);
+	if (IS_ERR(sess->ser)) {
+		cpu_preserved_as_destroy(sess->as);
+		kho_unpreserve_free(sess);
+		return NULL;
+	}
+
+	memset(sess->ser, 0, ser_sz);
+	sess->ser->nr_cpu_words = nr_ser_words;
+	strscpy(sess->ser->session_name, sname, sizeof(sess->ser->session_name));
+	sess->ser->sess_pa = virt_to_phys(sess);
+	KHOSER_STORE_PTR(sess->ser->as, sess->as ? sess->as->ser : NULL);
+
+	list_add_tail(&sess->node, &oncore_sessions);
+	return sess;
+}
+
+static struct oncore_session *oncore_get_or_create_session(struct liveupdate_session *s)
+{
+	const char *sname = liveupdate_session_name(s);
+	struct oncore_session *sess;
+
+	if (!sname || !sname[0])
+		return NULL;
+
+	guard(mutex)(&oncore_sessions_lock);
+
+	sess = oncore_find_session_locked(sname);
+	if (sess)
+		return sess;
+
+	return oncore_create_session_locked(sname);
+}
+
+/**
+ * oncore_session_add_cpu - Attach a preserved physical CPU to an On-Core session
+ * @s:   Live Update session handle.
+ * @cpu: Logical ID of the preserved physical CPU to add.
+ *
+ * Creates the On-Core session for @s if it does not yet exist, adds @cpu to
+ * the session's CPU mask, configures @cpu's preserved stack context with the
+ * session pointer and isolated PGD physical address, and attaches
+ * oncore_sched_cpu_worker() so @cpu begins servicing the session's runqueue.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int oncore_session_add_cpu(struct liveupdate_session *s, int cpu)
+{
+	struct oncore_session *sess;
+	int ret = 0;
+
+	if (!arch_oncore_counter_freq_hz()) {
+		pr_err("On-core counter frequency is unknown; refusing to add CPU\n");
+		return -ENODEV;
+	}
+
+	sess = oncore_get_or_create_session(s);
+	if (!sess || cpu < 0 || cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	guard(mutex)(&sess->lock);
+	cpumask_set_cpu(cpu, oncore_session_cpus(sess));
+
+	cpu_preserved_set_workload_context(cpu, sess,
+					   oncore_session_get_pgd_pa(sess));
+
+	ret = cpu_preserved_attach_workload(cpu,
+					    oncore_sched_cpu_worker,
+					    sess);
+	if (ret) {
+		cpu_preserved_set_workload_context(cpu, NULL, 0);
+		cpumask_clear_cpu(cpu, oncore_session_cpus(sess));
+		return ret;
+	}
+
+	return 0;
+}
+
+static void oncore_sync_jobs_pa(struct oncore_session *sess)
+{
+	phys_addr_t *tail = &sess->first_job_pa;
+	struct oncore_job *j;
+
+	list_for_each_entry(j, &sess->jobs, sess_node) {
+		j->next_job_pa = 0;
+		*tail = virt_to_phys(j);
+		tail = &j->next_job_pa;
+	}
+	*tail = 0;
+}
+
+static void oncore_session_destroy_incoming(struct oncore_session *sess)
+{
+	struct oncore_session *old_sess;
+	struct oncore_job *job;
+	phys_addr_t job_pa;
+
+	if (!sess->ser) {
+		kfree(sess);
+		return;
+	}
+
+	if (sess->ser->sess_pa) {
+		old_sess = phys_to_virt(sess->ser->sess_pa);
+		job_pa = old_sess->first_job_pa;
+		while (job_pa) {
+			job = phys_to_virt(job_pa);
+			job_pa = job->next_job_pa;
+			kho_restore_free(job);
+		}
+		kho_restore_free(old_sess);
+	}
+
+	kho_restore_free(sess->ser);
+	kfree(sess);
+}
+
+static void oncore_session_destroy_outgoing(struct oncore_session *sess)
+{
+	struct oncore_job *job, *tmp;
+
+	list_for_each_entry_safe(job, tmp, &sess->jobs, sess_node) {
+		list_del_init(&job->sess_node);
+		kho_unpreserve_free(job);
+	}
+
+	if (sess->ser)
+		kho_unpreserve_free(sess->ser);
+	kho_unpreserve_free(sess);
+}
+
+static void oncore_session_destroy(struct oncore_session *sess)
+{
+	scoped_guard(mutex, &oncore_sessions_lock)
+		list_del_init(&sess->node);
+
+	cpu_preserved_as_destroy(sess->as);
+
+	if (sess->is_incoming)
+		oncore_session_destroy_incoming(sess);
+	else
+		oncore_session_destroy_outgoing(sess);
+}
+
+/**
+ * oncore_session_remove_cpu - Detach a preserved physical CPU from an On-Core session
+ * @s:   Live Update session handle.
+ * @cpu: Logical ID of the preserved physical CPU to remove.
+ *
+ * Detaches the On-Core scheduler worker from @cpu and clears @cpu from the
+ * session's CPU mask.  When the last CPU in the session is removed, destroys
+ * the session's isolated address space and reclaims all KHO-preserved job and
+ * session structures (via kho_restore_free() in the incoming kernel after
+ * kexec, or kho_unpreserve_free() in the outgoing kernel on cancellation).
+ */
+void oncore_session_remove_cpu(struct liveupdate_session *s, int cpu)
+{
+	struct oncore_session *sess = oncore_find_session(s);
+
+	if (!sess || cpu < 0 || cpu >= nr_cpu_ids)
+		return;
+
+	scoped_guard(mutex, &sess->lock)
+		cpumask_clear_cpu(cpu, oncore_session_cpus(sess));
+
+	cpu_preserved_detach_workload(cpu);
+	cpu_preserved_set_workload_context(cpu, NULL, 0);
+
+	if (cpumask_empty(oncore_session_cpus(sess)))
+		oncore_session_destroy(sess);
+}
+
+/**
+ * oncore_session_get_ser - Retrieve the KHO serialization block for an On-Core session
+ * @s: Live Update session handle.
+ *
+ * Called by the preserved-CPU LUO file handler (cpu_preserve) when serializing
+ * a preserved CPU file descriptor so it can store a KHO pointer
+ * (&cpu_preserved_file_ser.oncore) to the session's metadata across kexec.
+ *
+ * Return: Pointer to the KHO-preserved &struct oncore_session_ser for @s, or
+ *         %NULL if @s has no On-Core session.
+ */
+struct oncore_session_ser *oncore_session_get_ser(struct liveupdate_session *s)
+{
+	struct oncore_session *sess = oncore_find_session(s);
+
+	return sess ? sess->ser : NULL;
+}
+
+/**
+ * oncore_session_restore - Reconstruct an On-Core session in the incoming kernel
+ * @s:   Incoming Live Update session handle.
+ * @ser: KHO-preserved session metadata handed over from the outgoing kernel.
+ *
+ * Adopts the KHO-preserved session metadata and isolated page tables (@ser->as)
+ * in the incoming kernel so that subsequent calls to oncore_session_remove_cpu()
+ * as preserved CPUs reattach to Linux can cleanly release the preserved page
+ * tables, jobs, and session structures.  Idempotent if @s has already been
+ * restored.
+ */
+void oncore_session_restore(struct liveupdate_session *s,
+			    struct oncore_session_ser *ser)
+{
+	struct cpu_preserved_as_ser *as_ser;
+	struct oncore_session *sess;
+	const char *sname;
+
+	if (!ser)
+		return;
+
+	sname = liveupdate_session_name(s);
+	if (!sname || !sname[0])
+		sname = ser->session_name;
+
+	guard(mutex)(&oncore_sessions_lock);
+
+	if (oncore_find_session_locked(sname))
+		return;
+
+	sess = kzalloc_obj(*sess, GFP_KERNEL);
+	if (!sess)
+		return;
+
+	mutex_init(&sess->lock);
+	INIT_LIST_HEAD(&sess->jobs);
+	oncore_runqueue_init(&sess->rq);
+	sess->is_incoming = true;
+	sess->ser = ser;
+
+	as_ser = KHOSER_LOAD_PTR(ser->as);
+	if (as_ser)
+		sess->as = cpu_preserved_as_adopt(as_ser);
+
+	list_add_tail(&sess->node, &oncore_sessions);
+}
+
+static unsigned int oncore_session_cpu_job_count(struct oncore_session *sess,
+						 int cpu)
+{
+	struct oncore_job *j;
+	unsigned int count = 0;
+
+	list_for_each_entry(j, &sess->jobs, sess_node) {
+		if (j->assigned_cpu == cpu)
+			count++;
+	}
+
+	return count;
+}
+
+static int oncore_select_job_cpu(struct oncore_session *sess)
+{
+	struct cpumask *cpus = oncore_session_cpus(sess);
+	unsigned int min_count = UINT_MAX, count;
+	int cpu, min_cpu = -1;
+
+	for_each_cpu(cpu, cpus) {
+		count = oncore_session_cpu_job_count(sess, cpu);
+		if (count < min_count) {
+			min_count = count;
+			min_cpu = cpu;
+		}
+	}
+
+	return min_cpu;
+}
+
+/**
+ * oncore_session_submit_job - Allocate and register a workload job in an On-Core session
+ * @s:      Live Update session handle.
+ * @run_fn: Workload callback executed on a preserved physical CPU.
+ * @data:   Opaque context pointer passed to @run_fn (may be %NULL and set
+ *          later via oncore_job_set_data() before activation).
+ *
+ * Allocates a KHO-preserved &struct oncore_job, maps it into the session's
+ * isolated address space, assigns it to the least-loaded preserved CPU in the
+ * session, and links it into @s.  The job is not placed on the runqueue until
+ * oncore_session_activate_job() is called.
+ *
+ * Return: Pointer to the allocated &struct oncore_job on success, %NULL if @s
+ *         has no preserved CPUs, or an ERR_PTR() on failure.
+ */
+struct oncore_job *oncore_session_submit_job(struct liveupdate_session *s,
+					     oncore_job_fn run_fn,
+					     void *data)
+{
+	struct oncore_session *sess = oncore_find_session(s);
+	struct oncore_job *job;
+
+	if (!run_fn)
+		return ERR_PTR(-EINVAL);
+	if (!sess)
+		return NULL;
+
+	guard(mutex)(&sess->lock);
+	if (cpumask_empty(oncore_session_cpus(sess)))
+		return NULL;
+
+	job = kho_alloc_preserve(sizeof(*job));
+	if (IS_ERR(job))
+		return job;
+
+	memset(job, 0, sizeof(*job));
+	oncore_session_map_buffer(sess, job, sizeof(*job));
+	INIT_LIST_HEAD(&job->node);
+	INIT_LIST_HEAD(&job->sess_node);
+	job->session = sess;
+	job->state = ONCORE_JOB_NEW;
+	job->run_fn = run_fn;
+	job->data = data;
+	job->last_cpu = -1;
+	job->assigned_cpu = oncore_select_job_cpu(sess);
+
+	list_add_tail(&job->sess_node, &sess->jobs);
+	oncore_sync_jobs_pa(sess);
+
+	return job;
+}
+EXPORT_SYMBOL_GPL(oncore_session_submit_job);
+
+/**
+ * oncore_session_activate_job - Map a submitted job's data and enqueue it for execution
+ * @s:   Live Update session handle.
+ * @job: Job previously returned by oncore_session_submit_job().
+ *
+ * Maps the first page of @job->data (if non-%NULL) into the session's isolated
+ * address space, places @job onto the session's round-robin FIFO runqueue, and
+ * kicks the assigned preserved physical CPU so it wakes from low-power park
+ * wait and begins executing @job.
+ *
+ * Return: 0 on success, or -EINVAL if @s or @job is invalid.
+ */
+int oncore_session_activate_job(struct liveupdate_session *s,
+				struct oncore_job *job)
+{
+	struct oncore_session *sess = oncore_find_session(s);
+
+	if (!sess || !job)
+		return -EINVAL;
+
+	guard(mutex)(&sess->lock);
+	if (job->data)
+		oncore_session_map_buffer(sess, job->data, PAGE_SIZE);
+	oncore_sched_enqueue(&sess->rq, job);
+	if (cpu_is_preserved(job->assigned_cpu))
+		arch_cpu_preserved_kick(job->assigned_cpu);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(oncore_session_activate_job);
+
+/**
+ * oncore_job_set_data - Set the opaque argument passed to a job's run callback
+ * @job:  Job to update.
+ * @data: Pointer handed to @job's run_fn.  May be %NULL.
+ *
+ * Callers that cannot determine @data at submission time submit with %NULL and
+ * call this once the object exists.  It must be called before
+ * oncore_session_activate_job(), which is what maps @data into the session's
+ * address space.
+ */
+void oncore_job_set_data(struct oncore_job *job, void *data)
+{
+	if (job)
+		job->data = data;
+}
+EXPORT_SYMBOL_GPL(oncore_job_set_data);
+
+/**
+ * oncore_job_cpu - Return the preserved physical CPU assigned to a job
+ * @job: Job to query.
+ *
+ * Return: Logical CPU ID assigned to @job, or -1 if @job is %NULL.
+ */
+int oncore_job_cpu(const struct oncore_job *job)
+{
+	return job ? job->assigned_cpu : -1;
+}
+EXPORT_SYMBOL_GPL(oncore_job_cpu);
+
+/**
+ * oncore_job_session - Return the On-Core session that owns a job
+ * @job: Job to query.
+ *
+ * Return: Pointer to the owning &struct oncore_session, or %NULL if @job is %NULL.
+ */
+struct oncore_session *oncore_job_session(const struct oncore_job *job)
+{
+	return job ? job->session : NULL;
+}
+EXPORT_SYMBOL_GPL(oncore_job_session);
+
+/**
+ * oncore_session_cancel_job - Stop and free a submitted or running On-Core job
+ * @s:   Live Update session handle.
+ * @job: Job to cancel.
+ *
+ * Removes @job from the session and runqueue.  If @job is currently executing
+ * on a preserved physical CPU (%ONCORE_JOB_CANCELING), kicks that CPU and
+ * waits for the current scheduling quantum to finish before unpreserving and
+ * freeing @job.
+ *
+ * Return: 0 on success, or -EINVAL if @s or @job is invalid.
+ */
+int oncore_session_cancel_job(struct liveupdate_session *s,
+			      struct oncore_job *job)
+{
+	struct oncore_session *sess = oncore_find_session(s);
+	int cpu, retries;
+
+	if (!sess || !job)
+		return -EINVAL;
+
+	guard(mutex)(&sess->lock);
+	list_del_init(&job->sess_node);
+	oncore_sync_jobs_pa(sess);
+	if (job->assigned_cpu >= 0)
+		job->assigned_cpu = -1;
+	oncore_sched_dequeue(&sess->rq, job);
+
+	if (READ_ONCE(job->state) == ONCORE_JOB_CANCELING) {
+		cpu = READ_ONCE(job->last_cpu);
+		retries = 0;
+
+		while (READ_ONCE(job->state) == ONCORE_JOB_CANCELING &&
+		       retries < (ONCORE_CANCEL_TIMEOUT_US / ONCORE_CANCEL_STEP_US)) {
+			if ((retries % 50) == 0 && cpu >= 0)
+				arch_cpu_preserved_kick(cpu);
+			udelay(ONCORE_CANCEL_STEP_US);
+			retries++;
+		}
+	}
+
+	kho_unpreserve_free(job);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(oncore_session_cancel_job);
-- 
2.55.0.1082.g2b9226bbc0-goog

