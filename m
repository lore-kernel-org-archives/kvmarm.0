Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D446D30F527
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668221; cv=none; b=maCXIMFFP3Gv29dJvZLEiu48MeMQ9P6G5QgVQTVIkpDRzLLftCh4ddpz9kvDJaimGu0qpEpDN7EgAs1OGIqaZq8eUbKA6QX5YoRlNUU5oBiUGURNMlZm2UyMVvz3RwvQOVY+HV+34CW8u8uD+UsWnT/o/BVa0ftdVkiZmpdZ3iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668221; c=relaxed/simple;
	bh=qTbHPCSdBPQqySVFZymIwcDF5oRcWOCun/2CVgn5za4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YKL6VokrRkKOlQ5XNmQ9FJt4Hh4DvFfVPImXH6UzXy3MDbM5DBrQWO2hSgJjs2WMuOa8V5X1G/LL3cUejuUd8GSh+oVF5GVUhbfvuevjsD2e76K7yyF2YzzV1RPHYX89cFC2Jde89ZGHGL3/Yb3vZTvwVkNaMbjoewfb2V98J78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qGMXkka0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qGMXkka0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso41992295e9.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668217; x=1765273017; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bEnANpDqC7DUDnEr2ekaLVgf0v4JzeZNFTwI2/AeuLE=;
        b=qGMXkka0KLxepZj1uGSw81xkBit3KDdzQuTlyE4ZrugRqfQajSGLUtVSnFPIx0a4jC
         XNTmyMBPRTqHR7u3xMNdo+Y/6P6KzykJCKUzhUrtZGN7tyJAj1wfO1w3melz3lAhlgyP
         dRR4q4xf3i3O6AgyghWvfHVrjaq8qZdPnAY7F2/yh4an2MIEM6++sPCFWNNN3IQSSL+R
         eJY41+N3y2/u3CLyJVC9EYtuWE/ldsRamh+7G7cG972VvLw//6YcF2+tKOQNNBFiw70I
         JYhpjFN2MRHzjVXngZF3Ql4JO++oL5+jo45G6UOJ7t0zEkKxANHbbP5xom+sMjYK1o9O
         5XwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668217; x=1765273017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bEnANpDqC7DUDnEr2ekaLVgf0v4JzeZNFTwI2/AeuLE=;
        b=FAbPdilWDrAK7ktjAF5GAe+O9iRYwwd94UsoFzT7ZK3WcjD0o9khjHAIaiL8oN8bg+
         uIK4kL0PzqlIjvPIo53PoX1j/GlQtDAHPuXYFKeBXaHjLajHJQo0keAAyWQPCdNzToVP
         cjodfiTCKLFpQCER0yaCcbqk5jtHe66a5gka8itZP2/jKNpY5+WAJcT0KgvBbfBfFTZB
         nqve5w0wByFaiR2puEjhviEuL+jdz3qGywZjd6yuchGAXod/+aUtJYeDIw0aIxRHk0+C
         ddx9gzcuYsuDEFuTmtl45HrKULZIYfhePQxQBn13nG6Zn8TmDOSyUOr1XnwAfVBeehvd
         eZ1g==
X-Gm-Message-State: AOJu0YxzImuelRt3lCBCnwTmxmgbWsd+6qyPcYNfS8zv/Cuoptf8C7zz
	xMi7BLf5BG7JVvrMO8a8uyZkIDwCbF1XMqI46qkRA3EdpvMWaIiRcxztw26VxY+X0V+0UKtyQSy
	DZPj5bzYOHDIgTRTa5Vyj6w==
X-Google-Smtp-Source: AGHT+IER9UhUXOk0INPeDjv7f9jwsIm3/XwUKhMfyM3LlqPp5ud54kE4SsIEfAALA0iAVFhbNzkMQB7hQXqYJZIE
X-Received: from wmga5.prod.google.com ([2002:a05:600c:2d45:b0:477:aa1e:920c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c8f:b0:471:989:9d7b with SMTP id 5b1f17b1804b1-47904b160e3mr277571685e9.21.1764668216619;
 Tue, 02 Dec 2025 01:36:56 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:19 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-27-vdonnefort@google.com>
Subject: [PATCH v9 26/30] KVM: arm64: Add trace reset to the nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Make the hypervisor reset either the whole tracing buffer or a specific
ring-buffer, on remotes/hypervisor/trace or per_cpu/<cpu>/trace write
access.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 375607c67285..a28b072125ec 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -94,6 +94,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_enable,
 	__KVM_HOST_SMCCC_FUNC___tracing_swap_reader,
 	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
+	__KVM_HOST_SMCCC_FUNC___tracing_reset,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/hyp/include/nvhe/trace.h b/arch/arm64/kvm/hyp/include/nvhe/trace.h
index fd641e1b1c23..44912869d184 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/trace.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/trace.h
@@ -12,6 +12,7 @@ void __tracing_unload(void);
 int __tracing_enable(bool enable);
 int __tracing_swap_reader(unsigned int cpu);
 void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
+int __tracing_reset(unsigned int cpu);
 #else
 static inline void *tracing_reserve_entry(unsigned long length) { return NULL; }
 static inline void tracing_commit_entry(void) { }
@@ -21,5 +22,6 @@ static inline void __tracing_unload(void) { }
 static inline int __tracing_enable(bool enable) { return -ENODEV; }
 static inline int __tracing_swap_reader(unsigned int cpu) { return -ENODEV; }
 static inline void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
+static inline int __tracing_reset(unsigned int cpu) { return -ENODEV; }
 #endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 45b8f70828de..f92e82cbfcb4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -625,6 +625,13 @@ static void handle___tracing_update_clock(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = 0;
 }
 
+static void handle___tracing_reset(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(unsigned int, cpu, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __tracing_reset(cpu);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -671,6 +678,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__tracing_enable),
 	HANDLE_FUNC(__tracing_swap_reader),
 	HANDLE_FUNC(__tracing_update_clock),
+	HANDLE_FUNC(__tracing_reset),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 97e9f6c1a52c..93475cc36640 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -287,3 +287,20 @@ void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
 	/* ...we can now override the old one and swap. */
 	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
 }
+
+int __tracing_reset(unsigned int cpu)
+{
+	int ret = -ENODEV;
+
+	if (cpu >= hyp_nr_cpus)
+		return -EINVAL;
+
+	hyp_spin_lock(&trace_buffer.lock);
+
+	if (hyp_trace_buffer_loaded(&trace_buffer))
+		ret = simple_ring_buffer_reset(per_cpu_ptr(trace_buffer.simple_rbs, cpu));
+
+	hyp_spin_unlock(&trace_buffer.lock);
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 1e5fc27f0e9d..09bc192e3514 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -313,7 +313,7 @@ static int hyp_trace_swap_reader_page(unsigned int cpu, void *priv)
 
 static int hyp_trace_reset(unsigned int cpu, void *priv)
 {
-	return 0;
+	return kvm_call_hyp_nvhe(__tracing_reset, cpu);
 }
 
 static int hyp_trace_enable_event(unsigned short id, bool enable, void *priv)
-- 
2.52.0.107.ga0afd4fd5b-goog

