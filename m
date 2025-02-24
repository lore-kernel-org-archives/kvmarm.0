Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B168248886
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399346; cv=none; b=u7lZUkKLtjkazzKdrKZ3bZNT0ouwD9l5xKBFrq+qDpXurtPR+HhJKt+UzIxFSQvxXP/zFLh4DTs942Zw6PUEG2G3wEgHqMmkVy1v+zh+ZrOgBH2aksWLlOU63jLZpwzj6/QSLtt+ePSDgONvKrfr2+AnftSGX4JwVS10vbGyIhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399346; c=relaxed/simple;
	bh=05R1f6qSDs9X//FiWcH4FYRMEz2TUBIVmAVXQ/CwdFo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lyQk44vz3Bcuue2T/UGBQLmrkXgjiq5Z4IDSW2MrL55amZxWsKh0TJUorMepf3hU2tSgAVPifsE4wYok/R2gVxP5PeCaEldjcsZGnTqW89tbNDqu5YW17YTbCSdKxZdv1nPyufvnS8It3T/Tllq26eS7zvIvewYrmDin10D8bEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qnC7xtuh; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qnC7xtuh"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43995bff469so36951885e9.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 04:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740399342; x=1741004142; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7FagIlwvy2X9P44Nj2FCz/VtczZ4pRRHPPhhjGlScn4=;
        b=qnC7xtuhIsRv57+sAgTGz2Gw92mPlxf1P9zU6rxUVNSoRulWibc3W0D6F4fvqF9xA7
         Mr1iwsvKD676Ac2RlOOL7a28cZYKztImdyjdddIxZ3Kqqx9EDI1yJ1JpnCCS9I9vA/FC
         lErGGqg7rfzhgv1Sq2r43Mj4OQZh3KysMJlU8bNppSS592/xvCdx2sT9pyzWx8mpe1aB
         +1r75g0YBfBin9Bh2Qs7GxpkARx4ckH2hVKpQdROziQ74sPtnKpkC0D+vLTsH4JlSxtZ
         WReYrXYzJjlwZYwIv2S3mw6sUOetL0HjFO77LRulnp+qLA+TFnzN6qh974wv5q55Eguz
         +XzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399342; x=1741004142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7FagIlwvy2X9P44Nj2FCz/VtczZ4pRRHPPhhjGlScn4=;
        b=U5UdyKukSsmQx6suf/CxAjsDbjkPOkrNJ6htC0tA9Ahda6prTyN6xHtmuyrLfPMvng
         MKEsjPn1eQ8eVPzcmOTVb62mfk9pMGjZo+Rvh5TW4tPCoEiB/q4TG6vR60xnas95gs5z
         8FQlDWeEHExs8xvnDi1LyXHWcRR0ibpLde9tk/x3wZLwlRnr0SWUN0zy5NRQ01Zm5mhO
         /FoOaBMK2uW2HaOZzoNcCk9mPLYH+u70L3zJZXiO/Qn/3WHFzP6YTztiuaxhipyjRSgB
         gPbzRxG9lWeBsjhhKT8y7YPzmfPBT9Bh0ArpCoG7T4ROAlAqV4lhfyW4mlrj7gAp7YFo
         FmPw==
X-Gm-Message-State: AOJu0YwDuXV4D7TuK4/FYpF4U4v+ksN4a4mnQANGum1G25okoplqsbRx
	FQ1mjotn08jRpPzaUCswt4JK8BOipwsMirERpHw0oeM07Hp2ZWPEqYm9K4bDpMgjptxauNYaTT8
	XPi0uA7daT2Ql6gY59Q==
X-Google-Smtp-Source: AGHT+IEfGb128a2DZBA8iW3Df9rmq3CoqidzScBKQXE2CAExXpW8soetaBJWs+nYkO8TCElzGRor5RI3Vx2qFvd6
X-Received: from wrbgx18.prod.google.com ([2002:a05:6000:4712:b0:38f:478d:618d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:45c5:0:b0:38d:e0be:71a3 with SMTP id ffacd0b85a97d-38f708593a9mr7968419f8f.54.1740399342646;
 Mon, 24 Feb 2025 04:15:42 -0800 (PST)
Date: Mon, 24 Feb 2025 12:13:51 +0000
In-Reply-To: <20250224121353.98697-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224121353.98697-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224121353.98697-10-vdonnefort@google.com>
Subject: [PATCH 09/11] KVM: arm64: Add trace interface for hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The trace interface is solely here to reset tracing. Non-consuming read
is not yet supported due to the lack of support in the ring-buffer
meta page.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 87d3e0e73b68..74f10847a55e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -91,6 +91,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_load_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
+	__KVM_HOST_SMCCC_FUNC___pkvm_reset_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
 };
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 6f1cc571b47a..28bbb54b7a0b 100644
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
index a8b497b22407..e2419c97c57d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -605,6 +605,13 @@ static void handle___pkvm_enable_tracing(struct kvm_cpu_context *host_ctxt)
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
@@ -655,6 +662,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_load_tracing),
 	HANDLE_FUNC(__pkvm_teardown_tracing),
 	HANDLE_FUNC(__pkvm_enable_tracing),
+	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 };
 
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index d79b6539377e..bf935645ed91 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -262,7 +262,7 @@ void tracing_commit_entry(void)
 	smp_store_release(&cpu_buffer->status, HYP_RB_READY);
 }
 
-static void hyp_rb_disable_writing(struct hyp_rb_per_cpu *cpu_buffer)
+static u32 hyp_rb_disable_writing(struct hyp_rb_per_cpu *cpu_buffer)
 {
 	u32 prev_status;
 
@@ -272,6 +272,8 @@ static void hyp_rb_disable_writing(struct hyp_rb_per_cpu *cpu_buffer)
 					      HYP_RB_READY,
 					      HYP_RB_UNAVAILABLE);
 	} while (prev_status == HYP_RB_WRITING);
+
+	return prev_status;
 }
 
 static int hyp_rb_enable_writing(struct hyp_rb_per_cpu *cpu_buffer)
@@ -284,6 +286,44 @@ static int hyp_rb_enable_writing(struct hyp_rb_per_cpu *cpu_buffer)
 	return 0;
 }
 
+static int hyp_rb_reset(struct hyp_rb_per_cpu *cpu_buffer)
+{
+	struct hyp_buffer_page *bpage;
+	u32 prev_status;
+
+	if (!hyp_rb_loaded(cpu_buffer))
+		return -ENODEV;
+
+	prev_status = hyp_rb_disable_writing(cpu_buffer);
+
+	while (!hyp_bpage_is_head(cpu_buffer->head_page))
+		cpu_buffer->head_page = hyp_bpage_next_page(cpu_buffer->head_page);
+
+	bpage = cpu_buffer->tail_page = cpu_buffer->head_page;
+	do {
+		hyp_bpage_reset(bpage);
+		bpage = hyp_bpage_next_page(bpage);
+	} while (bpage != cpu_buffer->head_page);
+
+	hyp_bpage_reset(cpu_buffer->reader_page);
+
+	cpu_buffer->last_overrun = 0;
+	cpu_buffer->write_stamp = 0;
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
+		hyp_rb_enable_writing(cpu_buffer);
+
+	return 0;
+}
+
 static void hyp_rb_teardown(struct hyp_rb_per_cpu *cpu_buffer)
 {
 	int i;
@@ -572,3 +612,17 @@ int __pkvm_enable_tracing(bool enable)
 
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
+	ret = hyp_rb_reset(per_cpu_ptr(&trace_rb, cpu));
+	hyp_spin_unlock(&trace_rb_lock);
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 38d97e34eada..03a6813cbe66 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -200,6 +200,11 @@ static int __get_reader_page(int cpu)
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
@@ -361,6 +366,7 @@ static int hyp_trace_buffer_load(struct hyp_trace_buffer *hyp_buffer, size_t siz
 
 	hyp_buffer->remote.pdesc = &desc->page_desc;
 	hyp_buffer->remote.get_reader_page = __get_reader_page;
+	hyp_buffer->remote.reset = __reset;
 	hyp_buffer->trace_buffer = ring_buffer_remote(&hyp_buffer->remote);
 	if (!hyp_buffer->trace_buffer) {
 		ret = -ENOMEM;
@@ -825,6 +831,49 @@ static const struct file_operations hyp_trace_raw_fops = {
 	.release        = hyp_trace_raw_release,
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
@@ -857,6 +906,9 @@ int hyp_trace_init_tracefs(void)
 	tracefs_create_file("trace_pipe", TRACEFS_MODE_WRITE, root,
 			    (void *)RING_BUFFER_ALL_CPUS, &hyp_trace_pipe_fops);
 
+	tracefs_create_file("trace", TRACEFS_MODE_WRITE, root,
+			    (void *)RING_BUFFER_ALL_CPUS, &hyp_trace_fops);
+
 	tracefs_create_file("trace_clock", TRACEFS_MODE_READ, root, NULL,
 			    &hyp_trace_clock_fops);
 
@@ -882,6 +934,9 @@ int hyp_trace_init_tracefs(void)
 
 		tracefs_create_file("trace_pipe_raw", TRACEFS_MODE_READ, per_cpu_dir,
 				    (void *)cpu, &hyp_trace_pipe_fops);
+
+		tracefs_create_file("trace", TRACEFS_MODE_READ, per_cpu_dir,
+				    (void *)cpu, &hyp_trace_fops);
 	}
 
 	return 0;
-- 
2.48.1.601.g30ceb7b040-goog

