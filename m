Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B312D28B4FC
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550165; cv=none; b=o/GAxfLRYoz5/MzSDPYO8FHDPNbt5fysb9pMz9enD2cb/PVxDlGKXihs1oqpjoJhE2zWL1UKgMzymXaNWF1UM6K3J++NhPvV45SjQQ/l8XX4G2kPB9MY2gM28MzeBNIYpbN4f1y2fOai4qxVAeRIJntRGS2HXNvIpYagFuuncc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550165; c=relaxed/simple;
	bh=SXTqbOasp/TqdqW1YsbgPK8z8iSOzKeN6sV6qzo9fec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ILVK4o8eVb55GKi2GJtAYCyOIQxNdQxQDkFw+TCA/ZM18MpxyRYqNbjJEyLZx7IRhG5XXXhwU8/FMaxBiqb40/CsoH31KCLIAiWIfdAhLiG1CkMcw+WVTgp3EnGiHs+KqXRHH7EhZq8tec9XhSfctzPW9NGk90L8ikZ4k1pYxJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=smO9m8gB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="smO9m8gB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf327e9a2so43593795e9.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550162; x=1747154962; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BvNkBXky1rMWTOoRULydoN1R7LqdNRvlY7olOpHHYgM=;
        b=smO9m8gBt5mKjGEGlaTv9UclbyNKwmIYRGG9RohqkRFSzpe7woxv3Ng26hmfnf8kV3
         qCJE78sBQ432FvzbUMrNsOZVOSg1za9Q/T8si7D1W0W5bRr77iK6/SahXVCPB1sNQLTA
         QmDh/wUNsuw9npaE+RenfNQXDGFJtYMWJq+2vBaL2t2YLFGxgj1Oa2PblqvRU1Yp1GgR
         CKFs2dMEtO2I0/tPcBplCOx7Z+AW0Fj50NgkybHxhNSJqORP5wLlI21CyEVKrZg/nRlt
         h0A6YW/vi2ySesxX/XMf7PQ5b1mVg642u/rR9c/Kqvy3CcrUH4ScyHk3NVyjBLpc2gvV
         qvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550162; x=1747154962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BvNkBXky1rMWTOoRULydoN1R7LqdNRvlY7olOpHHYgM=;
        b=jLuLjDkbyARKCFkSjyywS+upJSXhgrlBVybUdLKNiAxi72+HLWjd1/iaFaEfv0jqrk
         dE4ReoK50yMjVgykO5qL+zGvyFlOXajhBI/3h+lLNvcCZNPTEHUdcCPtlxxzN2EpjBFx
         Ia4YhL8kyS/uML8yw8eZGSq+SPm+oKaPzMHfyxK9My3gvZHMIttFBaXpCYIJNRHRAMOG
         uezK3JPCw0E0cub9HKXzT0U5ues6xR552aE3RiachGrIg7VfUTTRHqC2hVTD2PZpeSdZ
         5OQ3qtt3CbC0fRelsLHQ94XcztvKrGcxYPYb2J6CD1SXxefCGV3wRqondIW3moNEHvdf
         9Nsw==
X-Gm-Message-State: AOJu0Yw07DDAULz+sqm2+OslVZsnl346GtwRnegBM8d0fX855+7VyU7n
	cFZ04OFtwxV5aiO7ZSiPzEW/GHMkM/DiBA8KBB39uvtGQIYzwJchJXTY7wn6MguFByIvK7KK8nI
	wRwkKb8+CXciH42CETw==
X-Google-Smtp-Source: AGHT+IFKrv9e+xqEfJtd2WRNi0C/3aV9GxXet9wyyDu73BVkgka8qgyhXibytzzFcNtjbq2/6XJRmSf3F2kX+J4p
X-Received: from wmhu7.prod.google.com ([2002:a05:600c:a367:b0:43b:c7e5:66e0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f01:b0:440:6a37:be09 with SMTP id 5b1f17b1804b1-441d0fd26fbmr38538295e9.16.1746550162319;
 Tue, 06 May 2025 09:49:22 -0700 (PDT)
Date: Tue,  6 May 2025 17:48:19 +0100
In-Reply-To: <20250506164820.515876-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250506164820.515876-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-24-vdonnefort@google.com>
Subject: [PATCH v4 23/24] KVM: arm64: Add selftest event support to pKVM hyp
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
index 1a4313362aa0..ee3af685d8dc 100644
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
2.49.0.967.g6a0df3ecc3-goog

