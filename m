Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F167A17E005
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047068; cv=none; b=tUUuzkZ/QyF6SwAbHWRRg+w/RVLSaFH3agjyn55/IpwYuBSSV8t0kzoRNdNx+cR6PqGk9mcfdfs4sMjiMEZHdST7uMZJWy4UKvw6vTdzlGKjU7fK+HJ6xv5IYt+iQNS5l8tw9KNMZRxoLQNtbF5yBthFEuDKgZQffXwSs4Qdi1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047068; c=relaxed/simple;
	bh=LaenaLuGt4fQVIJCNLVWTUOkToNUk9LbTgeBs7hJkNM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eJNgg8VHPk5+gQqsPCzi9FstpMdai4xUHJG2GAC9WrB2sc//8mWwut9CvhwedFqgx5sUI8lNPCfEhuznIfLsLTA6fBJdwLdBFR5k39mFPeJJFKydp3JetWuK62gU5A5/nih29em0+Zmk3sKa72//FjPOr0Rz7Dr2KlKcTRpNcD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gcDhQS9o; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gcDhQS9o"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0353b731b8so3010634276.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047066; x=1726651866; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PzPcrbftESLspjTEpHjqRTEtmKwNQEBE1twldyLxH1Q=;
        b=gcDhQS9odRy9hfjCJNwjSWMjeAMBkaCi3J9eTnTFoZBpcDBVWoF2lYO+rIXO/wgTe0
         f9sqEUJX1s2kUvKYUR4Ox5xiy5GWCvTChWdQKWcXB1v6xh3jrLkb/1LAlAjEhrAWRDYZ
         Zw1Wef1vbzSLHmHhXNzPoz83K4Z7oAuE9uN8FfT8wolsTbjRUwyUfZVSkG0UfZCyFQoG
         QBy05FIxXhP0J6snL3X9VuxCryyWgzuRScJKXhj4hOsl8VcHGN1a2mM14XNEkjl7B4s4
         pGRWOrFyKVXLnoBVkv285/c1wa43/yK+U/fjL8aCS9emNpHclbwkYpMH3D+gqn4jLRN/
         cgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047066; x=1726651866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PzPcrbftESLspjTEpHjqRTEtmKwNQEBE1twldyLxH1Q=;
        b=NFSOkj2jYgNoORT3uy6orQ1gTilaUBeKt/xmnaagM4lR63pZE7mtiT6/0ltHJ5rwyY
         U/MxvcKusaeH849prBe3N4mZjD/xST+OcDZS/ZNi05XYkLBvBR9rC5hBvKYAXkH5no4q
         0OHtdRi2pNMrB7aCUeuD6lwe4vTUURToClz+jhFew9b0ghElmYwS0zmznkvVnQ5MgYRx
         vzjIbofEW/3Z61r6yCf4qt9OKc0txOmbmwrMtwF2ysU+GzQQ84i8omVlaoByLbiw2dYJ
         4gyjlzApmrRnYJaHSsOtGVI1RiJe69oJxX7REwNeJ/tCPppkbV5OqulWaAOzTAsG1ABq
         HZ8A==
X-Gm-Message-State: AOJu0YzoDAc4sjRXKNf/pFovvGvc0Eo25zv+fpaWQvFVRmBybaTOq+bv
	D+KvT6uzLsavRB1fCpvszSMIgJ+en7+brL6IEqZrZDcPMZ2nZN5dqk+6P2+3feUfMVpqIurmzrB
	689MYOW0VBiigyxmKWw==
X-Google-Smtp-Source: AGHT+IHuqlEQLP9ULLz/rIA3IuW5PevSvq8qj3//zsb2EYi01oSWwNwkd5ANLePPls9k6dmxcvjBnl0eQMrlIAlZ
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a25:7d42:0:b0:e11:7a38:8883 with SMTP
 id 3f1490d57ef6-e1d8c42386dmr2939276.7.1726047066017; Wed, 11 Sep 2024
 02:31:06 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:25 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-10-vdonnefort@google.com>
Subject: [PATCH 09/13] KVM: arm64: Add clock for hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>, John Stultz <jstultz@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, 
	"Christopher S. Hall" <christopher.s.hall@intel.com>, Richard Cochran <richardcochran@gmail.com>, 
	Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Content-Type: text/plain; charset="UTF-8"

Configure the hypervisor tracing clock before starting tracing. For
tracing purpose, the boot clock is interesting as it doesn't stop on
suspend. However, it is corrected on a regular basis, which implies we
need to re-evaluate it every once in a while.

Cc: John Stultz <jstultz@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Christopher S. Hall <christopher.s.hall@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d549d7d491c3..96490f8c3ff2 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+	__KVM_HOST_SMCCC_FUNC___pkvm_update_clock_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_load_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index a7c0c73af0e5..df17683a3b12 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -16,6 +16,7 @@ struct hyp_buffer_page {
 void *tracing_reserve_entry(unsigned long length);
 void tracing_commit_entry(void);
 
+void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
 int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size);
 void __pkvm_teardown_tracing(void);
 int __pkvm_enable_tracing(bool enable);
@@ -24,6 +25,8 @@ int __pkvm_swap_reader_tracing(unsigned int cpu);
 static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
 static inline void tracing_commit_entry(void) { }
 
+static inline
+void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
 static inline int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
 static inline void __pkvm_teardown_tracing(void) { }
 static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1fb3391e122a..7f5c3e888960 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -374,6 +374,18 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
 }
 
+static void handle___pkvm_update_clock_tracing(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, mult, host_ctxt, 1);
+	DECLARE_REG(u32, shift, host_ctxt, 2);
+	DECLARE_REG(u64, epoch_ns, host_ctxt, 3);
+	DECLARE_REG(u64, epoch_cyc, host_ctxt, 4);
+
+	__pkvm_update_clock_tracing(mult, shift, epoch_ns, epoch_cyc);
+
+	cpu_reg(host_ctxt, 1) = 0;
+}
+
 static void handle___pkvm_load_tracing(struct kvm_cpu_context *host_ctxt)
 {
 	 DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
@@ -435,6 +447,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
+	HANDLE_FUNC(__pkvm_update_clock_tracing),
 	HANDLE_FUNC(__pkvm_load_tracing),
 	HANDLE_FUNC(__pkvm_teardown_tracing),
 	HANDLE_FUNC(__pkvm_enable_tracing),
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index debb3ee7dd3a..022fe2e24f82 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -468,6 +468,21 @@ static void rb_teardown_bpage_backing(void)
 	hyp_buffer_pages_backing.size = 0;
 }
 
+void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
+{
+	int cpu;
+
+	/* After this loop, all CPUs are observing the new bank... */
+	for (cpu = 0; cpu < hyp_nr_cpus; cpu++) {
+		struct hyp_rb_per_cpu *cpu_buffer = per_cpu_ptr(&trace_rb, cpu);
+
+		while (atomic_read(&cpu_buffer->status) == HYP_RB_WRITING);
+	}
+
+	/* ...we can now override the old one and swap. */
+	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
+}
+
 int __pkvm_swap_reader_tracing(unsigned int cpu)
 {
 	struct hyp_rb_per_cpu *cpu_buffer;
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index b9d1f96d0678..1720daeda8ae 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -16,10 +16,25 @@
 
 #define RB_POLL_MS 100
 
+/* Same 10min used by clocksource when width is more than 32-bits */
+#define CLOCK_MAX_CONVERSION_S 600
+#define CLOCK_INIT_MS 100
+#define CLOCK_POLL_MS 500
+
 #define TRACEFS_DIR "hypervisor"
 #define TRACEFS_MODE_WRITE 0640
 #define TRACEFS_MODE_READ 0440
 
+struct hyp_trace_clock {
+	u64			cycles;
+	u64			max_delta;
+	u64			boot;
+	u32			mult;
+	u32			shift;
+	struct delayed_work	work;
+	struct completion	ready;
+};
+
 static struct hyp_trace_buffer {
 	struct hyp_trace_desc		*desc;
 	struct ring_buffer_writer	writer;
@@ -28,6 +43,7 @@ static struct hyp_trace_buffer {
 	bool				tracing_on;
 	int				nr_readers;
 	struct mutex			lock;
+	struct hyp_trace_clock		clock;
 } hyp_trace_buffer = {
 	.lock		= __MUTEX_INITIALIZER(hyp_trace_buffer.lock),
 };
@@ -74,6 +90,107 @@ bpage_backing_free(struct hyp_buffer_pages_backing *bpage_backing)
 	free_pages_exact((void *)bpage_backing->start, bpage_backing->size);
 }
 
+static void __hyp_clock_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct hyp_trace_buffer *hyp_buffer;
+	struct hyp_trace_clock *hyp_clock;
+	struct system_time_snapshot snap;
+	u64 rate, delta_cycles;
+	u64 boot, delta_boot;
+	u64 err = 0;
+
+	hyp_clock = container_of(dwork, struct hyp_trace_clock, work);
+	hyp_buffer = container_of(hyp_clock, struct hyp_trace_buffer, clock);
+
+	ktime_get_snapshot(&snap);
+	boot = ktime_to_ns(snap.boot);
+
+	delta_boot = boot - hyp_clock->boot;
+	delta_cycles = snap.cycles - hyp_clock->cycles;
+
+	/* Compare hyp clock with the kernel boot clock */
+	if (hyp_clock->mult) {
+		u64 cur = delta_cycles;
+
+		cur *= hyp_clock->mult;
+		cur >>= hyp_clock->shift;
+		cur += hyp_clock->boot;
+
+		err = abs_diff(cur, boot);
+
+		/* No deviation, only update epoch if necessary */
+		if (!err) {
+			if (delta_cycles >= hyp_clock->max_delta)
+				goto update_hyp;
+
+			goto resched;
+		}
+
+		/* Warn if the error is above tracing precision (1us) */
+		if (hyp_buffer->tracing_on && err > NSEC_PER_USEC)
+			pr_warn_ratelimited("hyp trace clock off by %lluus\n",
+					    err / NSEC_PER_USEC);
+	}
+
+	if (delta_boot > U32_MAX) {
+		do_div(delta_boot, NSEC_PER_SEC);
+		rate = delta_cycles;
+	} else {
+		rate = delta_cycles * NSEC_PER_SEC;
+	}
+
+	do_div(rate, delta_boot);
+
+	clocks_calc_mult_shift(&hyp_clock->mult, &hyp_clock->shift,
+			       rate, NSEC_PER_SEC, CLOCK_MAX_CONVERSION_S);
+
+update_hyp:
+	hyp_clock->max_delta = (U64_MAX / hyp_clock->mult) >> 1;
+	hyp_clock->cycles = snap.cycles;
+	hyp_clock->boot = boot;
+	kvm_call_hyp_nvhe(__pkvm_update_clock_tracing, hyp_clock->mult,
+			  hyp_clock->shift, hyp_clock->boot, hyp_clock->cycles);
+	complete(&hyp_clock->ready);
+
+	pr_debug("hyp trace clock update mult=%u shift=%u max_delta=%llu err=%llu\n",
+		 hyp_clock->mult, hyp_clock->shift, hyp_clock->max_delta, err);
+
+resched:
+	schedule_delayed_work(&hyp_clock->work,
+			      msecs_to_jiffies(CLOCK_POLL_MS));
+}
+
+static void hyp_clock_start(struct hyp_trace_buffer *hyp_buffer)
+{
+	struct hyp_trace_clock *hyp_clock = &hyp_buffer->clock;
+	struct system_time_snapshot snap;
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
+}
+
+static void hyp_clock_stop(struct hyp_trace_buffer *hyp_buffer)
+{
+	struct hyp_trace_clock *hyp_clock = &hyp_buffer->clock;
+
+	cancel_delayed_work_sync(&hyp_clock->work);
+}
+
+static void hyp_clock_wait(struct hyp_trace_buffer *hyp_buffer)
+{
+	struct hyp_trace_clock *hyp_clock = &hyp_buffer->clock;
+
+	wait_for_completion(&hyp_clock->ready);
+}
+
 static int __get_reader_page(int cpu)
 {
 	return kvm_call_hyp_nvhe(__pkvm_swap_reader_tracing, cpu);
@@ -294,10 +411,14 @@ static int hyp_trace_start(void)
 	if (hyp_buffer->tracing_on)
 		goto out;
 
+	hyp_clock_start(hyp_buffer);
+
 	ret = hyp_trace_buffer_load(hyp_buffer, hyp_trace_buffer_size);
 	if (ret)
 		goto out;
 
+	hyp_clock_wait(hyp_buffer);
+
 	ret = kvm_call_hyp_nvhe(__pkvm_enable_tracing, true);
 	if (ret) {
 		hyp_trace_buffer_teardown(hyp_buffer);
@@ -307,6 +428,9 @@ static int hyp_trace_start(void)
 	hyp_buffer->tracing_on = true;
 
 out:
+	if (!hyp_buffer->tracing_on)
+		hyp_clock_stop(hyp_buffer);
+
 	mutex_unlock(&hyp_buffer->lock);
 
 	return ret;
@@ -324,6 +448,7 @@ static void hyp_trace_stop(void)
 
 	ret = kvm_call_hyp_nvhe(__pkvm_enable_tracing, false);
 	if (!ret) {
+		hyp_clock_stop(hyp_buffer);
 		ring_buffer_poll_writer(hyp_buffer->trace_buffer,
 					RING_BUFFER_ALL_CPUS);
 		hyp_buffer->tracing_on = false;
@@ -615,6 +740,14 @@ static const struct file_operations hyp_trace_pipe_fops = {
 	.llseek         = no_llseek,
 };
 
+static int hyp_trace_clock_show(struct seq_file *m, void *v)
+{
+	seq_puts(m, "[boot]\n");
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(hyp_trace_clock);
+
 int hyp_trace_init_tracefs(void)
 {
 	struct dentry *root, *per_cpu_root;
@@ -639,6 +772,9 @@ int hyp_trace_init_tracefs(void)
 	tracefs_create_file("trace_pipe", TRACEFS_MODE_WRITE, root,
 			    (void *)RING_BUFFER_ALL_CPUS, &hyp_trace_pipe_fops);
 
+	tracefs_create_file("trace_clock", TRACEFS_MODE_READ, root, NULL,
+			    &hyp_trace_clock_fops);
+
 	per_cpu_root = tracefs_create_dir("per_cpu", root);
 	if (!per_cpu_root) {
 		pr_err("Failed to create tracefs folder "TRACEFS_DIR"/per_cpu/\n");
-- 
2.46.0.598.g6f2099f65c-goog

