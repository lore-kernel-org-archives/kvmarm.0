Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC601F463E
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402877; cv=none; b=suvsooI1yxbFGCvoUANDqAknsq/KyrThjcVONRlaIaYJ83y/SGU3JdYh8tWRY1HZ0/rrfx+IooMecA0aubR9AW9ru4nXiEeQIA1K2XsOLqV7dVg4do3EODPq+BGatzmrP3m5TOdWfl2wHssUxf/rUu8oOyg9PJ8mN7NJpkiXuEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402877; c=relaxed/simple;
	bh=GIq7tCpS5o60lK9Ijz4ADQdx4nU8SBoHG5/76Idfmes=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AE0jUYKLSX3dDDVCMM39Ti6XP20qCfW+EhrKMVRVhmjg++J76HPiV1ZiDQfVrd6D+zZ0mWQR3/9F3zJLGzqllaFWx+3JIgVlvzwoY15aAL7uOXTL69+umYgPLVoo+hxm5cZsychUWKr1rXgm1xnHfhkQEBC99l3czNkKI/lNIBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F02pncxx; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F02pncxx"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a0b5d18cb7so1142397f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402873; x=1748007673; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lUFR7mX34CGfKgUCmeQsVwEXViGiZ8lwRuzfDv0/YGY=;
        b=F02pncxx4mXgTLTe/57WzK1EuQRtg4WunSa7MbE64niKKEiouqtXpMn7QgM5lttYip
         LohA3r4b9uUnnK6c4KwiPAivy72RZbdt3AqYbDu+SM1w3Gdt+9eIzldEEqR7Xl/8wTnB
         s41OO3MfHojks0UT5GN24Qc6FLcRtRSXY4CdK7jezl3prkfsbkG2Ls9W7yJ8h/zvCMSq
         fTiU+huNDFrqASuAE+T8ICz0uQfmBE4zOiqxWgyhcQFYHyB3wgBYefx8nLU9F46fI3lQ
         Lw/o1FLhA9f2bhJ+VOr20kt0OUVhP2ypoPlx6JqcHdOM+cd5magJQ/zt2BvNsHg9zqR5
         X1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402873; x=1748007673;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUFR7mX34CGfKgUCmeQsVwEXViGiZ8lwRuzfDv0/YGY=;
        b=CWHlbW0V/62i79VzZ2rmiT21NIEyuI72KWpipImCFncFs7Fihg17XI4+8MNHYjzHEA
         g1lO1yBLjPKmhpaWgwFczsp1+LgrHIk0I7YeoJ8wHYUKmaQk2vrzSDy64fmjsQAw7P23
         QttQBS+3E8Xs6UbchMd3v212g0aEbNByW6OHhlk3cswvMbUjhjbgOdmM3rSbmeD7EVlU
         19htSWv18HieF46xCSEsXQwAj+6aI/NyI3ThOPJCzuPIYDpQ7l/0aGj1MATZFaWlti2h
         10p/icpRDJgEZyTWoct9H3yEL3NrObFtcvBEK83ve5EZ5sagtRuef1e5G9QLsLPaK3mS
         BZ/Q==
X-Gm-Message-State: AOJu0Yz/vjYXCeakeWYA19BTQNzoOPUfoWH+Ofi9r8Epzqm1zKr9ZAfX
	rJnUfZs2gqDiUXaA7M3xRNgC3mgg+/ZjLSN89CkQyuxnTjgNDTqhNprZHxoiEyxYcB3z5qRfGsv
	YnCEYmxrOlGMiEidiSsQQEA==
X-Google-Smtp-Source: AGHT+IGVC4fNdiNzu3iXYOkrkXpo832GHFE68H+xlkXG8UXT/PiO3x3xWk/shQQW7MtLSB2W1QhSu6ppGBlSn/hS
X-Received: from wmbhc21.prod.google.com ([2002:a05:600c:8715:b0:440:5d62:5112])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:598f:0:b0:3a2:1f1:c3ad with SMTP id ffacd0b85a97d-3a35fe92b09mr2272113f8f.26.1747402873067;
 Fri, 16 May 2025 06:41:13 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:27 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-22-vdonnefort@google.com>
Subject: [PATCH v5 21/25] KVM: arm64: Add trace reset to the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
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
index c73229fb5e1b..65260bfd33ac 100644
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
 	HANDLE_FUNC(__pkvm_unload_tracing),
 	HANDLE_FUNC(__pkvm_enable_tracing),
+	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 };
 
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index 32fd889315f0..b6d97237a7a0 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -230,6 +230,25 @@ int __pkvm_enable_tracing(bool enable)
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
index a6664a03f8a9..5c115c3a26a1 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -301,7 +301,7 @@ static int hyp_trace_swap_reader_page(unsigned int cpu, void *priv)
 
 static int hyp_trace_reset(unsigned int cpu, void *priv)
 {
-	return 0;
+	return kvm_call_hyp_nvhe(__pkvm_reset_tracing, cpu);
 }
 
 static int hyp_trace_enable_event(unsigned short id, bool enable, void *priv)
-- 
2.49.0.1101.gccaa498523-goog

