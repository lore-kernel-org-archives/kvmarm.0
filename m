Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95F187349
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047073; cv=none; b=GmoP3uczQKAdloiKhhdtRz9rsseTILydkXfneUJspvUC8lryQhzK3nqcCc7m+ENoojBtnkubfEPnKrokbYqAr73w192Wc7PIgwqZXGE/Jqcu9hxG0G/jNLxz7QzOftqFXA34TC+tK465I4XkQKn5DdH7/ktX3j0eqpMjWTmVjSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047073; c=relaxed/simple;
	bh=Hp4qstVpdpGnkkfN1xgcPm4KsX6RZwEnvPl5FeeL/2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BzlKL6pCsTmt/W0AeEeuJ5+IF79cGS8H23MR1KFZUtO7oxyQPeDOLWrU75dfDgDSbEBh9kah2cDcxAi6ggBLMB8XQKzP8aY+5TPpgYlRu3kNb1BVvgkWB1iWUp/zR/yFtbiZDFX3He7WSrwqGheGBxAF+2/23gD+WtTStjdbbmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OwMtYFXr; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OwMtYFXr"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42ac185e26cso51783515e9.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047070; x=1726651870; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TnLSQZSAgoNi0Keo+sYtcTPVeJagPuiIv9Z2VTSsQS0=;
        b=OwMtYFXr70rfvoLADyMcjLYH/4bZMhy2J3mFUEK3SEd/Oi++kzd86165irI/rjqPXE
         e/rVa8aVADSXjFLf30CRTPE8UHIu8wtw5jAFliN0ZKCiEcCnu1XG09DOTD1OwkItRF0G
         hEjIN2K9xf/WYs/mWfIzpyhMM+ESVAq3vmuY7/wPUXgx1/mdXPrduuOG7Fa241bDXcbl
         1ceQagCPEpxqnLasd0IX4vZI4i/uYaT9ZAt9nT8+sK0VmqgN3cc86je5kQXQ49+XB6z4
         HvpykswVpslMpLlLpkr2qSGd/PBbHKkFRLAFBl+xUEU6ujugGWmIQ9fgCSVeOrU4UjLx
         eBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047070; x=1726651870;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TnLSQZSAgoNi0Keo+sYtcTPVeJagPuiIv9Z2VTSsQS0=;
        b=qmDbCdezmbNAnolZXRODB25koLxmJ3MTZCfU+IxCcjpLZhbGXa9uWQN9oo/XDNZaDl
         5GBX2EXtPFNvK9LtHu3qbv67kgX/UN40wSxm8CgkSjdqedwTO3QITSO2SPYu/4BQ1JIM
         1mJWNXvoHh1+Xn61D5Wr89eB7MQLu2tK9ONUMOOunXznbr8VYCKbmSZZ98nfWI4MGcnG
         OfReJ4rpUmubfUkSoHXt19wjA473/6U1LP8dxuBDfOR32gDRhx1y3B+WEaPFiW31/0M5
         NI85ppQDCC/5rQRg3rAggbR2zhalBpH9xzLYj7dfv/v9mX9p3mch8oc/EK0+5Z6itQY+
         BB2g==
X-Gm-Message-State: AOJu0Yy6tV41UAj43odYGIBnaSCFErcbR1/zFVlUI6SZM4xG1nmOYvTY
	YkaWt9pGYqqc/oYBpc2/eNdojPcCLW0utszlGpb+ytoWuAWK7hcyd8w5M7KjzoeEEA0Q1otVXsK
	FwhBo/fmfKvEHALM1pg==
X-Google-Smtp-Source: AGHT+IFBFa1ITmFWdn1hIxeejWg2oOrSElTmg674ffGcdfONVY7m5AHs9mdqHrVmIGHjb5YdccfyU5goBnO2ORC/
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:600c:1da3:b0:42c:afd6:6896 with
 SMTP id 5b1f17b1804b1-42cafd6692dmr355355e9.4.1726047070522; Wed, 11 Sep 2024
 02:31:10 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:27 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-12-vdonnefort@google.com>
Subject: [PATCH 11/13] KVM: arm64: Add trace interface for hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The trace interface is solely here to reset tracing. Non-consuming read
is not yet supported due to the lack of support in the ring-buffer
meta page.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 96490f8c3ff2..17896e6ceca7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -83,6 +83,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_load_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
+	__KVM_HOST_SMCCC_FUNC___pkvm_reset_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
 };
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index df17683a3b12..1004e1edf24f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -20,6 +20,7 @@ void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cy
 int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size);
 void __pkvm_teardown_tracing(void);
 int __pkvm_enable_tracing(bool enable);
+int __pkvm_reset_tracing(unsigned int cpu);
 int __pkvm_swap_reader_tracing(unsigned int cpu);
 #else
 static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
@@ -30,6 +31,7 @@ void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cy
 static inline int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
 static inline void __pkvm_teardown_tracing(void) { }
 static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
+static inline int __pkvm_reset_tracing(unsigned int cpu) { return -ENODEV; }
 static inline int __pkvm_swap_reader_tracing(unsigned int cpu) { return -ENODEV; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7f5c3e888960..dc7a85922117 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -408,6 +408,13 @@ static void handle___pkvm_enable_tracing(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_enable_tracing(enable);
 }
 
+static void handle___pkvm_reset_tracing(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_reset_tracing(cpu);
+}
+
 static void handle___pkvm_swap_reader_tracing(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
@@ -451,6 +458,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_load_tracing),
 	HANDLE_FUNC(__pkvm_teardown_tracing),
 	HANDLE_FUNC(__pkvm_enable_tracing),
+	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 };
 
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 022fe2e24f82..6ea0f1d475bb 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -284,12 +284,20 @@ static int rb_page_init(struct hyp_buffer_page *bpage, unsigned long hva)
 	return 0;
 }
 
+static void rb_page_reset(struct hyp_buffer_page *bpage)
+{
+	bpage->write = 0;
+	bpage->entries = 0;
+
+	local_set(&bpage->page->commit, 0);
+}
+
 static bool rb_cpu_loaded(struct hyp_rb_per_cpu *cpu_buffer)
 {
 	return !!cpu_buffer->bpages;
 }
 
-static void rb_cpu_disable_writing(struct hyp_rb_per_cpu *cpu_buffer)
+static int rb_cpu_disable_writing(struct hyp_rb_per_cpu *cpu_buffer)
 {
 	int prev_status;
 
@@ -299,6 +307,8 @@ static void rb_cpu_disable_writing(struct hyp_rb_per_cpu *cpu_buffer)
 						     HYP_RB_READY,
 						     HYP_RB_UNAVAILABLE);
 	} while (prev_status == HYP_RB_WRITING);
+
+	return prev_status;
 }
 
 static int rb_cpu_enable_writing(struct hyp_rb_per_cpu *cpu_buffer)
@@ -311,6 +321,38 @@ static int rb_cpu_enable_writing(struct hyp_rb_per_cpu *cpu_buffer)
 	return 0;
 }
 
+static int rb_cpu_reset(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	struct hyp_buffer_page *bpage;
+	int prev_status;
+
+	if (!rb_cpu_loaded(cpu_buffer))
+		return -ENODEV;
+
+	prev_status = rb_cpu_disable_writing(cpu_buffer);
+
+	bpage = cpu_buffer->head_page;
+	do {
+		rb_page_reset(bpage);
+		bpage = rb_next_page(bpage);
+	} while (bpage != cpu_buffer->head_page);
+
+	rb_page_reset(cpu_buffer->reader_page);
+
+	cpu_buffer->meta->reader.read = 0;
+	cpu_buffer->meta->reader.lost_events = 0;
+	cpu_buffer->meta->entries = 0;
+	cpu_buffer->meta->overrun = 0;
+	cpu_buffer->meta->read = 0;
+	meta_pages_lost(cpu_buffer->meta) = 0;
+	meta_pages_touched(cpu_buffer->meta) = 0;
+
+	if (prev_status == HYP_RB_READY)
+		rb_cpu_enable_writing(cpu_buffer);
+
+	return 0;
+}
+
 static void rb_cpu_teardown(struct hyp_rb_per_cpu *cpu_buffer)
 {
 	int i;
@@ -602,3 +644,17 @@ int __pkvm_enable_tracing(bool enable)
 
 	return ret;
 }
+
+int __pkvm_reset_tracing(unsigned int cpu)
+{
+	int ret = 0;
+
+	if (cpu >= hyp_nr_cpus)
+		return -EINVAL;
+
+	hyp_spin_lock(&trace_rb_lock);
+	ret = rb_cpu_reset(per_cpu_ptr(&trace_rb, cpu));
+	hyp_spin_unlock(&trace_rb_lock);
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 0d0e5eada816..8ac8f9763cbd 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -196,6 +196,11 @@ static int __get_reader_page(int cpu)
 	return kvm_call_hyp_nvhe(__pkvm_swap_reader_tracing, cpu);
 }
 
+static int __reset(int cpu)
+{
+	return kvm_call_hyp_nvhe(__pkvm_reset_tracing, cpu);
+}
+
 static void hyp_trace_free_pages(struct hyp_trace_desc *desc)
 {
 	struct rb_page_desc *rb_desc;
@@ -354,6 +359,7 @@ static int hyp_trace_buffer_load(struct hyp_trace_buffer *hyp_buffer, size_t siz
 
 	hyp_buffer->writer.pdesc = &desc->page_desc;
 	hyp_buffer->writer.get_reader_page = __get_reader_page;
+	hyp_buffer->writer.reset = __reset;
 	hyp_buffer->trace_buffer = ring_buffer_reader(&hyp_buffer->writer);
 	if (!hyp_buffer->trace_buffer) {
 		ret = -ENOMEM;
@@ -820,6 +826,49 @@ static const struct file_operations hyp_trace_raw_fops = {
 	.llseek         = no_llseek,
 };
 
+static void hyp_trace_reset(int cpu)
+{
+	struct hyp_trace_buffer *hyp_buffer = &hyp_trace_buffer;
+
+	mutex_lock(&hyp_buffer->lock);
+
+	if (!hyp_trace_buffer_loaded(hyp_buffer))
+		goto out;
+
+	if (cpu == RING_BUFFER_ALL_CPUS)
+		ring_buffer_reset(hyp_buffer->trace_buffer);
+	else
+		ring_buffer_reset_cpu(hyp_buffer->trace_buffer, cpu);
+
+out:
+	mutex_unlock(&hyp_buffer->lock);
+}
+
+static int hyp_trace_open(struct inode *inode, struct file *file)
+{
+	int cpu = (s64)inode->i_private;
+
+	if (file->f_mode & FMODE_WRITE) {
+		hyp_trace_reset(cpu);
+
+		return 0;
+	}
+
+	return -EPERM;
+}
+
+static ssize_t hyp_trace_write(struct file *filp, const char __user *ubuf,
+			       size_t count, loff_t *ppos)
+{
+	return count;
+}
+
+static const struct file_operations hyp_trace_fops = {
+	.open           = hyp_trace_open,
+	.write          = hyp_trace_write,
+	.release        = NULL,
+};
+
 static int hyp_trace_clock_show(struct seq_file *m, void *v)
 {
 	seq_puts(m, "[boot]\n");
@@ -852,6 +901,9 @@ int hyp_trace_init_tracefs(void)
 	tracefs_create_file("trace_pipe", TRACEFS_MODE_WRITE, root,
 			    (void *)RING_BUFFER_ALL_CPUS, &hyp_trace_pipe_fops);
 
+	tracefs_create_file("trace", TRACEFS_MODE_WRITE, root,
+			    (void *)RING_BUFFER_ALL_CPUS, &hyp_trace_fops);
+
 	tracefs_create_file("trace_clock", TRACEFS_MODE_READ, root, NULL,
 			    &hyp_trace_clock_fops);
 
@@ -877,6 +929,9 @@ int hyp_trace_init_tracefs(void)
 
 		tracefs_create_file("trace_pipe_raw", TRACEFS_MODE_READ, per_cpu_dir,
 				    (void *)cpu, &hyp_trace_pipe_fops);
+
+		tracefs_create_file("trace", TRACEFS_MODE_READ, per_cpu_dir,
+				    (void *)cpu, &hyp_trace_fops);
 	}
 
 	return 0;
-- 
2.46.0.598.g6f2099f65c-goog

