Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA8E1FF7B3
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402883; cv=none; b=eWQtrfQeFRhAs06hFzIpappkzWn1YmZj36f1R858pf/GMmcLRxoismUs0pTeK/G2A4mnQ5ASqFgHGnkWktNStGhZbQUr8CTzyNO2HyQ4OjSf4gjkbs0vyNa4De89EVzr6f68ILyWMhUByb49yGi1MOd5tumx6kg2J1r+FtkhDRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402883; c=relaxed/simple;
	bh=gtmroQFekXKLWe/nKseT96/h3TyZYMQQgPfNxygd8SU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G7OUc/mFuDkZLFEn8Oxh0jguzFWvK5cioem1c52XmdWsOK9dvocrMjDIozAPXsV6HNacv658CpqohFf4EvAFWuf4sZF/EkIzi5wqKzah3Qo9Sl9upP9uuF2Ta+apsII2Q5e9xIq5sOa/i5FBulLi10pYaFSB63YbDTINhp6fvAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UA3loUjP; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UA3loUjP"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a360d01518so488743f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402878; x=1748007678; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OpAELfoeAsFVtMepRzx2zM79+vNwJLrfBYC1dznWjvY=;
        b=UA3loUjPsK/OfMvCJGEEhRpbbeafr1Mhz0ClwKSbJ7l9JvPrVj8u1Hdmip8CyvlTb1
         BIapXfCpKHg6q9t0j7iP+n50/3u1QVXJ/MSHeM/Px3w2XT9p8TUQPn8U08hV8iWZsWoS
         7+SPON1CSuXmlZWCbUT/ZhmO961N/gJS4AGESrRibpDH6abPve5LODDVGwEFWvrvWRjj
         MivX67yLMw/qqpXA2NbBjl035ymO+PwFpz75V0yuQfZaYpIulpJTjhktf0lNYeit0YN7
         T8VDGh5MF8LtD+E47LTPfhn5S1ZQ/xXn9jmoZvuiffDEGFwFdhNrSbOf6xbZX2y0qFLF
         679Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402878; x=1748007678;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OpAELfoeAsFVtMepRzx2zM79+vNwJLrfBYC1dznWjvY=;
        b=tfJgd5CM7070ho1TLmzRG6N0mk8w5CxseH3iAy8RfnAncuwmoshND1cuxopRWwCvil
         KV4au5I5Ahin0yPWcsnIF5BibliY8TbgoI6uviKg6+GzmrsA3o3dIS/Rux4sNV0XK7wR
         x9FkTonGAOOgdyJUyR3g0+UbAhmDuKgN/77slC6H8e7fYZYSkwlGOPPMceJh7ilsxEqO
         be0v7RyiY3P6dXGgz7vKlHToandRLo2EJzWvFGjIB53eFvYYmw0OV4Wcu9+dzB7zdvZ/
         sYj+6V3U+rhZNeQlwJw9PBVv6YYxn78td7QdPlne7Xiybu9iITiXMNQVlPoeqLcCdFBL
         clFw==
X-Gm-Message-State: AOJu0YwT9rRmpln7nx7WRS1HH9i47m+A62Uaiz4iu6r7bn5Rh3aXZWIE
	Xq5iB3J6Xi1NOL6QKDxZHYcOcBc9Yws5rsis3z2atjWm/dLKXXw2N0bRWQboVI3FGBSSv9TFWyj
	OgZuP/wBI1FKfwkDwvIYiMg==
X-Google-Smtp-Source: AGHT+IEExJBuC7RFCuynPTpengmlGUugJWjBceO6wu7ms84bKjx06UaFKlpNW0XZ+nv2qFVPSYjFHNd7fTq0iTw5
X-Received: from wmbec10.prod.google.com ([2002:a05:600c:610a:b0:441:b661:2d94])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2502:b0:3a1:fc84:f75f with SMTP id ffacd0b85a97d-3a3601d09b9mr2120545f8f.58.1747402878524;
 Fri, 16 May 2025 06:41:18 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:30 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-25-vdonnefort@google.com>
Subject: [PATCH v5 24/25] KVM: arm64: Add selftest event support to pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a selftest event that can be triggered from a `write_event` tracefs
file. This intends to be used by trace remote selftests.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 79019e11f529..522cccef32b7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -94,6 +94,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_reset_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_swap_reader_tracing,
 	__KVM_HOST_SMCCC_FUNC___pkvm_enable_event,
+	__KVM_HOST_SMCCC_FUNC___pkvm_write_event,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index ce3953bc884a..3d1244972869 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -24,4 +24,18 @@ HYP_EVENT(hyp_exit,
 	),
 	HE_PRINTK()
 );
+
+#ifdef CONFIG_PKVM_SELFTESTS
+HYP_EVENT(selftest,
+	HE_PROTO(u64 id),
+	HE_STRUCT(
+		he_field(u64, id)
+	),
+	HE_ASSIGN(
+		__entry->id = id;
+	),
+	RE_PRINTK("id=%lld", __entry->id)
+);
 #endif
+
+#endif /* __ARM64_KVM_HYPEVENTS_H_ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index f7d1d8987cce..333824325c9e 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -46,6 +46,7 @@ menuconfig KVM
 config NVHE_EL2_DEBUG
 	bool "Debug mode for non-VHE EL2 object"
 	depends on KVM
+	select PKVM_SELFTESTS
 	help
 	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
 	  Failure reports will BUG() in the hypervisor. This is intended for
@@ -83,6 +84,15 @@ config PTDUMP_STAGE2_DEBUGFS
 
 	  If in doubt, say N.
 
+config PKVM_SELFTESTS
+	bool "Protected KVM hypervisor selftests"
+	depends on KVM
+	default n
+	help
+	  Say Y here to enable pKVM hypervisor testing infrastructure.
+
+	  If unsure, say N.
+
 config PKVM_TRACING
 	bool
 	depends on KVM
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7d7d0c07a6d4..e6b45631c48b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -628,6 +628,20 @@ static void handle___pkvm_enable_event(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_enable_event(id, enable);
 }
 
+static void handle___pkvm_write_event(struct kvm_cpu_context *host_ctxt)
+{
+	int smc_ret = SMCCC_RET_NOT_SUPPORTED, ret = -EOPNOTSUPP;
+#ifdef CONFIG_PKVM_SELFTESTS
+	DECLARE_REG(u64, id, host_ctxt, 1);
+
+	trace_selftest(id);
+	smc_ret = SMCCC_RET_SUCCESS;
+	ret = 0;
+#endif
+	cpu_reg(host_ctxt, 0) = smc_ret;
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -674,6 +688,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 	HANDLE_FUNC(__pkvm_enable_event),
+	HANDLE_FUNC(__pkvm_write_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 70c0939ebc6a..5b5d17a47ecc 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -317,8 +317,34 @@ static int hyp_trace_clock_show(struct seq_file *m, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(hyp_trace_clock);
 
+#ifdef CONFIG_PKVM_SELFTESTS
+static ssize_t hyp_trace_write_event_write(struct file *f, const char __user *ubuf,
+					   size_t cnt, loff_t *pos)
+{
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_write_event, val);
+	if (ret)
+		return ret;
+
+	return cnt;
+}
+
+static const struct file_operations hyp_trace_write_event_fops = {
+	.write	= hyp_trace_write_event_write,
+};
+#endif
+
 static int hyp_trace_init_tracefs(struct dentry *d, void *priv)
 {
+#ifdef CONFIG_PKVM_SELFTESTS
+	tracefs_create_file("write_event", 0200, d, NULL, &hyp_trace_write_event_fops);
+#endif
 	return tracefs_create_file("trace_clock", 0440, d, NULL, &hyp_trace_clock_fops) ?
 		0 : -ENOMEM;
 }
-- 
2.49.0.1101.gccaa498523-goog

