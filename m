Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99AA25A64C
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498764; cv=none; b=HGkwL4nT23kZ84JsYDFyXOip9EaHJTv+JCql+iPMYoVZV6Wdo2BfkjrUwAQdy+nR61p4ako9yjHnv2wvgNiWmYTyE0yM8ol8lGcZQj8HPWtexejEyRnuYoCxaWNRhAF5bg+sFKnKnwjwfGUExWmLB8hfS0RKl5Kg5oCnsv5oXEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498764; c=relaxed/simple;
	bh=YYPtZx7KhRfp3aC5CCHm1JhakHuUybZFtGRIGxxWxOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WUCa8NOFrXeDTeWrH7TF1wmqyDip8dHzfWEHlQhXCx8BlarxZlS3HRdbNqPs8MF1tgKRAPOiTi3y1gZQ9sp8hjF794x0RfqAuyx5O0pm/vOjlXQQwYIZKkhJ4fPJQnhpyRM0UhOTeGbNt3FlPXUemYJk+JQckBfblgeHedP2uqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ziMrkubh; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ziMrkubh"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e4943d713so16933825e9.1
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498759; x=1760103559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CKoVOt7SfjBg9tHla8UyfyracQ+ttFmAkYCdQchY/Cw=;
        b=ziMrkubh9gjgYZP5ndRgpJizS6hJjmp4qafz7Uv+WfpEBYskJNW4cpobMdmmslc4cS
         iYtRmSQNUakxBXf70UTXeCvfklvSzky1xuP54lCE3NP39fQzW25Dlebb6n3e99PnVexl
         DG7ov2I+2ofTQ8mzSQw28yCR61DdXd+QXiyf4Qe/5JE4CuzlCssmJ9SVDvmkyBFFASCM
         EoqXfSM1Lh5yVxQGvPc43P0t9jc/dl8GQSfxslJPihy1gI8eAa94WE0bj08TEWZJAvQd
         ZkiMgjbvYYpwQxpsTKBv+FhpYNVdkFerjBbAeG2T5KDX1RJTpnl56/LnSbTmm5fnP651
         O4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498759; x=1760103559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CKoVOt7SfjBg9tHla8UyfyracQ+ttFmAkYCdQchY/Cw=;
        b=KAesJ9v6U9zc9636AEpXBD3im4lEqS7GT43FCjDcEJnA83+3O+vKW3rtj5/K3zru2U
         JCLUbtSPLY0z5JfDW3ilZaXDQhE0F6b8o9Z3WnoNE3zWrQwyJtTxiNlNCUlY38jM2apR
         w2K4UMCixRyX5ikiK4DjZsC+9eaQ7Usuql+E5gnKybqLFeznNl0WWUso5k+7nsiUYgpI
         3Sb0m8Wg2B12W2ahXtS8fcCryGWu4Zx0Fhru2rdfAuGYgvYVYKh/w+dHnjZdiuYx7zkz
         HIWRhKkBE48T70n/9HuB7uq6c+h7ibDDd9BzLJjdACgFLl5a/IDyW2PvsWIiw9KEg4RB
         qtUg==
X-Gm-Message-State: AOJu0YwSz8RWt636TvmiRHG5sdZf0dA+yQPFrVsSYgO7RSmtYFQgiipp
	Ois5bJytk590qDBS441JgGcN3WI8YzXCO/ZnxqSpz1qURXlA1nEEnS7dHRNUC5jSgVmjgMO4NLZ
	iB+RoyFmABoUSrunRY3HBgQ==
X-Google-Smtp-Source: AGHT+IF3XrIOuZLzr95zLbd7FnCvuwGAUE/NKipTgwAL9Vm4NhQ+xCaEbNPY72ptqM5YQLLSLemYx+UklOwNUX8Q
X-Received: from wmoe6.prod.google.com ([2002:a05:600c:4486:b0:46e:67c8:72a6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3551:b0:46d:27b7:e7ff with SMTP id 5b1f17b1804b1-46e7115c811mr23867565e9.36.1759498759672;
 Fri, 03 Oct 2025 06:39:19 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:21 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-25-vdonnefort@google.com>
Subject: [PATCH v7 24/28] KVM: arm64: Add trace reset to the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Let the hypervisor reset the trace buffer when triggered from the
tracefs file remotes/hypervisor/trace.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d122d79718a0..c40820a4b049 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -91,6 +91,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_load_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_unload_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_tracing,
+	__KVM_HOST_SMCCC_FUNC___pkvm_reset_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
 };
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index 4e11dcdf049b..0d2732f0d406 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -11,6 +11,7 @@ void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cy
 int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size);
 void __pkvm_unload_tracing(void);
 int __pkvm_enable_tracing(bool enable);
+int __pkvm_reset_tracing(unsigned int cpu);
 int __pkvm_swap_reader_tracing(unsigned int cpu);
 #else
 static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
@@ -21,6 +22,7 @@ void __pkvm_update_clock_tracing(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cy
 static inline int __pkvm_load_tracing(unsigned long desc_va, size_t desc_size) { return -ENODEV; }
 static inline void __pkvm_unload_tracing(void) { }
 static inline int __pkvm_enable_tracing(bool enable) { return -ENODEV; }
+static inline int __pkvm_reset_tracing(unsigned int cpu) { return -ENODEV; }
 static inline int __pkvm_swap_reader_tracing(unsigned int cpu) { return -ENODEV; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 36a263422e4e..a7c5e9fc27a0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -608,6 +608,13 @@ static void handle___pkvm_enable_tracing(struct kvm_cpu_context *host_ctxt)
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
@@ -658,6 +665,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_load_tracing),
 	HANDLE_FUNC(__pkvm_unload_tracing),
 	HANDLE_FUNC(__pkvm_enable_tracing),
+	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 };
 
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index d146ac3046de..1fd9b32950fe 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -236,6 +236,25 @@ int __pkvm_enable_tracing(bool enable)
 	return ret;
 }
 
+int __pkvm_reset_tracing(unsigned int cpu)
+{
+	int ret = 0;
+
+	if (cpu >= hyp_nr_cpus)
+		return -EINVAL;
+
+	hyp_spin_lock(&trace_buffer.lock);
+
+	if (hyp_trace_buffer_loaded(&trace_buffer))
+		ret = simple_ring_buffer_reset(per_cpu_ptr(trace_buffer.simple_rbs, cpu));
+	else
+		ret = -ENODEV;
+
+	hyp_spin_unlock(&trace_buffer.lock);
+
+	return ret;
+}
+
 int __pkvm_swap_reader_tracing(unsigned int cpu)
 {
 	int ret;
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 4f154ec743f3..1062b4310f8c 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -302,7 +302,7 @@ static int hyp_trace_swap_reader_page(unsigned int cpu, void *priv)
 
 static int hyp_trace_reset(unsigned int cpu, void *priv)
 {
-	return 0;
+	return kvm_call_hyp_nvhe(__pkvm_reset_tracing, cpu);
 }
 
 static int hyp_trace_enable_event(unsigned short id, bool enable, void *priv)
-- 
2.51.0.618.g983fd99d29-goog

