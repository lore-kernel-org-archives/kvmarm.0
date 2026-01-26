Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DF6339848
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424293; cv=none; b=p41jMk2//xRbngXKUW1UJaS5T/qT6khXZ2yC9y9sMAiFv9uQoyvPe9892ayqQ4F0QCIxqO2G7tYG0bX3WtFaSw3kOphfCnHWLA1sXiZ+eTyhVoa8i3gqfmWE9F6nKTfMvU0FaPa7l0VYma6IXXXWxjD2qknVGI3Dmfalz8YOcXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424293; c=relaxed/simple;
	bh=IEHoas6fg4+rHvu4ApD3tBhREacTshdHwr1AnsNE2hI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=okmfA7lRIDxhYPA5pnqH4UdXzFFB7CGcnOwHpBRjP8n4GcXvefxa6/meBftjvVHjI/OtuBQY3JaifjI61cRv7IGWtxIHjrq9MdDSiCk9mD2dy2rcqlnsC+v/hrtesef/S09Xze8y/1jayN7MmJLLJA0yLMmxx3QAlEQ9xjf6e/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AY867DXn; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AY867DXn"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47ee7346f8bso31738335e9.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424289; x=1770029089; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GrrY1Bo4caR7Yg7iMIVZCactU50F+u23O+ceOpCGr/k=;
        b=AY867DXnUeVmiz8fNC3OGWhRRMq/MIMSZhyO+rqxV8xgjNzvBBY6r9u/hJ9Ga3ZOzt
         zvpyWVH8N0J3dVIiyQ8ul7zDZ1/6xMLVPRb1OVmjLLHO5N4m9TVIyIEQoqOn3GYzcmga
         uQ/BN26XxpnaOiO65BOW8ODlSDy77clcJ8bxhmeSTEQ/fxuBBAY26m2aYCaS6Ez481nO
         O6pUFdMdOc27JL7PyrEshPiMm42zpZxxOb5muTYK6y8U0+07tbRq6WEj7cVUOupHoi6N
         bgODtlfkX7kH+7gdf/1wlCizJfwPj18oLhGZzn6SxVV3ML3xrPI7xwWVZJ7mgRpWYu9j
         Lf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424289; x=1770029089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GrrY1Bo4caR7Yg7iMIVZCactU50F+u23O+ceOpCGr/k=;
        b=qSOmV8ignXHoq/qfe95ydfo06mYOdi3r2zPPUTuNP/YbDpOXmo32x4SxmBRpm8GPIy
         BinPW2FagNTHE2hZ8bxGp3hNViYQISnSh8a79S2jDOB8cEVIG7Tii+/xMX0FGJgXOoa6
         Xj6hCFfSkclJCjdHubs9axHkOf4VfU40y5brrZm1IObMpY6bT3QrYxe5OpCgYfFYSii0
         g7/JmFlhi4BjQA4a7hDk3+BoDhOolp0FAEdvCo8Pz3ptZkPMfXCcZFfScrJWIfnOYwvi
         trkwJ9EcavebCHkdcTc3d4XvKaNnMFepidsilucE2w8BpAzfT9HiMMNXjgYvUVkMbF4f
         3VmQ==
X-Gm-Message-State: AOJu0YxmpyeXf4Xj2eaiiZu68PmUwPjR9vI78PWo8KSvDXKDWYSpwqD+
	b1De7bmZ2fs2xlrmjzrc8g4ri0x4bsLVgEGaxKobLF+UcN/zeXgGO3uG07vE/shfBCtS6i6pzJX
	w5MyvGTfXVH6N4oeh4dYINg==
X-Received: from wmbjj24.prod.google.com ([2002:a05:600c:6a18:b0:480:4a03:7b79])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:b95:b0:477:55ce:f3c2 with SMTP id 5b1f17b1804b1-4805ce3faf5mr68562295e9.14.1769424288788;
 Mon, 26 Jan 2026 02:44:48 -0800 (PST)
Date: Mon, 26 Jan 2026 10:44:14 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-26-vdonnefort@google.com>
Subject: [PATCH v10 25/30] KVM: arm64: Sync boot clock with the nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, 
	"Christopher S. Hall" <christopher.s.hall@intel.com>, Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Configure the hypervisor tracing clock with the kernel boot clock. For
tracing purposes, the boot clock is interesting: it doesn't stop on
suspend. However, it is corrected on a regular basis, which implies the
need to re-evaluate it every once in a while.

Cc: John Stultz <jstultz@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Christopher S. Hall <christopher.s.hall@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index c3a7fc939f42..352ebbedaab2 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -93,6 +93,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_unload,
 	__KVM_HOST_SMCCC_FUNC___tracing_enable,
 	__KVM_HOST_SMCCC_FUNC___tracing_swap_reader,
+	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 7da8788ce527..fd641e1b1c23 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -11,6 +11,7 @@ int __tracing_load(unsigned long desc_va, size_t desc_size);
 void __tracing_unload(void);
 int __tracing_enable(bool enable);
 int __tracing_swap_reader(unsigned int cpu);
+void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
 #else
 static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
 static inline void tracing_commit_entry(void) { }
@@ -19,5 +20,6 @@ static inline int __tracing_load(unsigned long desc_va, size_t desc_size) { retu
 static inline void __tracing_unload(void) { }
 static inline int __tracing_enable(bool enable) { return -ENODEV; }
 static inline int __tracing_swap_reader(unsigned int cpu) { return -ENODEV; }
+static inline void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index eddbf5df5d13..9df0d37a494b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -615,6 +615,16 @@ static void handle___tracing_swap_reader(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __tracing_swap_reader(cpu);
 }
 
+static void handle___tracing_update_clock(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, mult, host_ctxt, 1);
+	DECLARE_REG(u32, shift, host_ctxt, 2);
+	DECLARE_REG(u64, epoch_ns, host_ctxt, 3);
+	DECLARE_REG(u64, epoch_cyc, host_ctxt, 4);
+
+	__tracing_update_clock(mult, shift, epoch_ns, epoch_cyc);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -660,6 +670,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__tracing_unload),
 	HANDLE_FUNC(__tracing_enable),
 	HANDLE_FUNC(__tracing_swap_reader),
+	HANDLE_FUNC(__tracing_update_clock),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index df9d66fcb3c9..97e9f6c1a52c 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -271,3 +271,19 @@ int __tracing_swap_reader(unsigned int cpu)
 
 	return ret;
 }
+
+void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
+{
+	int cpu;
+
+	/* After this loop, all CPUs are observing the new bank... */
+	for (cpu = 0; cpu < hyp_nr_cpus; cpu++) {
+		struct simple_rb_per_cpu *simple_rb = per_cpu_ptr(trace_buffer.simple_rbs, cpu);
+
+		while (READ_ONCE(simple_rb->status) == SIMPLE_RB_WRITING)
+			;
+	}
+
+	/* ...we can now override the old one and swap. */
+	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
+}
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2866effe28ec..1e5fc27f0e9d 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -4,15 +4,133 @@
  * Author: Vincent Donnefort <vdonnefort@google.com>
  */
 
+#include <linux/cpumask.h>
 #include <linux/trace_remote.h>
+#include <linux/tracefs.h>
 #include <linux/simple_ring_buffer.h>
 
+#include <asm/arch_timer.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_hyptrace.h>
 #include <asm/kvm_mmu.h>
 
 #include "hyp_trace.h"
 
+/* Same 10min used by clocksource when width is more than 32-bits */
+#define CLOCK_MAX_CONVERSION_S	600
+/*
+ * Time to give for the clock init. Long enough to get a good mult/shift
+ * estimation. Short enough to not delay the tracing start too much.
+ */
+#define CLOCK_INIT_MS		100
+/*
+ * Time between clock checks. Must be small enough to catch clock deviation when
+ * it is still tiny.
+ */
+#define CLOCK_UPDATE_MS		500
+
+static struct hyp_trace_clock {
+	u64			cycles;
+	u64			cyc_overflow64;
+	u64			boot;
+	u32			mult;
+	u32			shift;
+	struct delayed_work	work;
+	struct completion	ready;
+	struct mutex		lock;
+	bool			running;
+} hyp_clock;
+
+static void __hyp_clock_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct hyp_trace_clock *hyp_clock;
+	struct system_time_snapshot snap;
+	u64 rate, delta_cycles;
+	u64 boot, delta_boot;
+
+	hyp_clock = container_of(dwork, struct hyp_trace_clock, work);
+
+	ktime_get_snapshot(&snap);
+	boot = ktime_to_ns(snap.boot);
+
+	delta_boot = boot - hyp_clock->boot;
+	delta_cycles = snap.cycles - hyp_clock->cycles;
+
+	/* Compare hyp clock with the kernel boot clock */
+	if (hyp_clock->mult) {
+		u64 err, cur = delta_cycles;
+
+		if (WARN_ON_ONCE(cur >= hyp_clock->cyc_overflow64)) {
+			__uint128_t tmp = (__uint128_t)cur * hyp_clock->mult;
+
+			cur = tmp >> hyp_clock->shift;
+		} else {
+			cur *= hyp_clock->mult;
+			cur >>= hyp_clock->shift;
+		}
+		cur += hyp_clock->boot;
+
+		err = abs_diff(cur, boot);
+		/* No deviation, only update epoch if necessary */
+		if (!err) {
+			if (delta_cycles >= (hyp_clock->cyc_overflow64 >> 1))
+				goto fast_forward;
+
+			goto resched;
+		}
+
+		/* Warn if the error is above tracing precision (1us) */
+		if (err > NSEC_PER_USEC)
+			pr_warn_ratelimited("hyp trace clock off by %lluus\n",
+					    err / NSEC_PER_USEC);
+	}
+
+	rate = div64_u64(delta_cycles * NSEC_PER_SEC, delta_boot);
+
+	clocks_calc_mult_shift(&hyp_clock->mult, &hyp_clock->shift,
+			       rate, NSEC_PER_SEC, CLOCK_MAX_CONVERSION_S);
+
+	/* Add a comfortable 50% margin */
+	hyp_clock->cyc_overflow64 = (U64_MAX / hyp_clock->mult) >> 1;
+
+fast_forward:
+	hyp_clock->cycles = snap.cycles;
+	hyp_clock->boot = boot;
+	kvm_call_hyp_nvhe(__tracing_update_clock, hyp_clock->mult,
+			  hyp_clock->shift, hyp_clock->boot, hyp_clock->cycles);
+	complete(&hyp_clock->ready);
+
+resched:
+	schedule_delayed_work(&hyp_clock->work,
+			      msecs_to_jiffies(CLOCK_UPDATE_MS));
+}
+
+static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enable)
+{
+	struct system_time_snapshot snap;
+
+	if (hyp_clock->running == enable)
+		return;
+
+	if (!enable) {
+		cancel_delayed_work_sync(&hyp_clock->work);
+		hyp_clock->running = false;
+	}
+
+	ktime_get_snapshot(&snap);
+
+	hyp_clock->boot = ktime_to_ns(snap.boot);
+	hyp_clock->cycles = snap.cycles;
+	hyp_clock->mult = 0;
+
+	init_completion(&hyp_clock->ready);
+	INIT_DELAYED_WORK(&hyp_clock->work, __hyp_clock_work);
+	schedule_delayed_work(&hyp_clock->work, msecs_to_jiffies(CLOCK_INIT_MS));
+	wait_for_completion(&hyp_clock->ready);
+	hyp_clock->running = true;
+}
+
 /* Access to this struct within the trace_remote_callbacks are protected by the trace_remote lock */
 static struct hyp_trace_buffer {
 	struct hyp_trace_desc	*desc;
@@ -183,6 +301,8 @@ static void hyp_trace_unload(struct trace_buffer_desc *desc, void *priv)
 
 static int hyp_trace_enable_tracing(bool enable, void *priv)
 {
+	hyp_trace_clock_enable(&hyp_clock, enable);
+
 	return kvm_call_hyp_nvhe(__tracing_enable, enable);
 }
 
@@ -201,7 +321,22 @@ static int hyp_trace_enable_event(unsigned short id, bool enable, void *priv)
 	return 0;
 }
 
+static int hyp_trace_clock_show(struct seq_file *m, void *v)
+{
+	seq_puts(m, "[boot]\n");
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(hyp_trace_clock);
+
+static int hyp_trace_init_tracefs(struct dentry *d, void *priv)
+{
+	return tracefs_create_file("trace_clock", 0440, d, NULL, &hyp_trace_clock_fops) ?
+		0 : -ENOMEM;
+}
+
 static struct trace_remote_callbacks trace_remote_callbacks = {
+	.init			= hyp_trace_init_tracefs,
 	.load_trace_buffer	= hyp_trace_load,
 	.unload_trace_buffer	= hyp_trace_unload,
 	.enable_tracing		= hyp_trace_enable_tracing,
@@ -212,8 +347,22 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 
 int __init kvm_hyp_trace_init(void)
 {
+	int cpu;
+
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
+#ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
+	for_each_possible_cpu(cpu) {
+		const struct arch_timer_erratum_workaround *wa =
+			per_cpu(timer_unstable_counter_workaround, cpu);
+
+		if (wa && wa->read_cntvct_el0) {
+			pr_warn("hyp trace can't handle CNTVCT workaround '%s'\n", wa->desc);
+			return -EOPNOTSUPP;
+		}
+	}
+#endif
+
 	return trace_remote_register("hypervisor", &trace_remote_callbacks, &trace_buffer, NULL, 0);
 }
-- 
2.52.0.457.g6b5491de43-goog

