Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968CD31D386
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508356; cv=none; b=klCn2oxXpN8i5qn2Hq4vQH5eXUp9BLA4zKrwxCsXMpwQxJ/AxsRwl0KX3FPgLNA6yjmYh5B/kMq3gxa0hjIZ6Fy0vv/Zks1Wr5kdk2UzGASceB6iy52lRTCbJweKXnthnHhadqGyDepedFoFB9Nd980bjXVDYatiutt5nywDaX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508356; c=relaxed/simple;
	bh=LNtLVW8oNI3U4HVa0ggAaHW8fxfh+l3SMZbnLj+XxLw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=imLzwHOJyaYKQe9gascyF1M6tFopg3EKcX+Za4ZYyRpAvNfd5vV77iTM1rOW59fHmsHHSEdo2NStp1Qo9/129xzUVrrsnlpXLq9HnZ42BypEx7ixOdT/YG87f1iAUl000xi6lokKH92q5f8vBQ2M0DnUrQjD1OucYf2lOBdNg4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SUNxbXNQ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SUNxbXNQ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429c521cf2aso396281f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508350; x=1763113150; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mXzGf2UIzsE9vtnsTrMx+m6Cqky190jMXVJHzI/NpsI=;
        b=SUNxbXNQVuxapzb0Qp5OJswFRPD1bI8l31fvCT+JQGMAeDuOFqwbG6g27qpOluYBe+
         oi5D6PtGW9ujXtN3nm0AQ8XPX7UD9uczsU3SsnFlVMdKE8zbf1HYgUxgCIaTslOlE+Ec
         x9W0i46h2Gx/x+6dnguSKwX0WbiyU5bP71QwS06ruJHdheciyKrSNRG/jbfJVFcde5tu
         RTewZbyI052AmD5hC2XNoSZ1HCklvAVxT/MtBuCASS2IWUEDND8CLWXDj5P1GoyCr3ka
         iEmyhTnoPy7kkoncJ1PSug2DNd9raXWcYELVa5di7PI/KLHQNeqwzosAGDrWovBH9xWZ
         vG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508350; x=1763113150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mXzGf2UIzsE9vtnsTrMx+m6Cqky190jMXVJHzI/NpsI=;
        b=QBeGJ6zEubXHi3AHMe6VoFdludjMo6mR2Zx0uJMPGB5sCK5a95NIjqH142WnDn3Dnz
         Y80A1k0JvpxzRsqpol3gChDlYmUkGcA8IsyuNV7yIdHy7nTUpJKSNUqYE8+FydWSbdbf
         eOtbjmEjQN30XL3DL+X/w09wkhg+kgvZCl1XgbpyEovJpNTFJZdG1kxXAqtu/P/UH0w8
         R4YQerEUVAPz/2eLhfiL6L0GCMyH/2is/d040SyHuEUb3Q97bQKrUqg+GDwIx6eYWdRC
         8fs44VY6tQ/lP6hH/CH0vnNcMzgnY6nrUbCRGTsry92XyxyCFlh1k9rbCDe12FgqOuX0
         n1/w==
X-Gm-Message-State: AOJu0Yx/h5D6Cj0gC4hT225I8bffnfhnJ6vildMe7hejWrBDMabCAlSe
	ujnhnnQYBKNkYljQxRCVfJ8xLlA6WYqfkad49MJnXVofHySUeQhDBbSvZCvl1gsv896wbm2HAXO
	vsiVi/eNUAdpdJC62+C/wkg==
X-Google-Smtp-Source: AGHT+IHkRp/N9BfpTVKwGlWfyc4Y1rtqqdCtN6rhng36wKjtc+HvLOewKvEx2dD8PFbJvsAmqePp4tbQ3CaaD1np
X-Received: from wrui2.prod.google.com ([2002:a5d:6302:0:b0:429:de3f:8287])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1869:b0:429:c93b:7f6b with SMTP id ffacd0b85a97d-42ae5ae8b68mr2108050f8f.53.1762508350492;
 Fri, 07 Nov 2025 01:39:10 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:36 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-25-vdonnefort@google.com>
Subject: [PATCH v8 24/28] KVM: arm64: Add trace reset to the pKVM hyp
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
index b6e016584de7..4faabf398881 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -93,6 +93,7 @@ enum __kvm_host_smccc_func {
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
index d13ab9baceb6..8adad701fc76 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -620,6 +620,13 @@ static void handle___pkvm_enable_tracing(struct kvm_cpu_context *host_ctxt)
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
@@ -672,6 +679,7 @@ static const hcall_t host_hcall[] = {
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
2.51.2.1041.gc1ab5b90ca-goog

