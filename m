Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5419615E8B
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498767; cv=none; b=PM9nw6Dq8xBpAUROL/AjPc71hM8QGTRbQqKe+E6vTAl8bPa/7+i+yzvB5gq1YPucBktfh2oogZYsrDppRYQMyRJwGFPEzkppYfIpp1XW12joGldUEJi17jBot72pu13VsrhnDc5j9LerfUGFyu0lg39KGlgYCtiiZ5KT4fAKsW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498767; c=relaxed/simple;
	bh=YOcY/2t1xn7bzDzdjSoq/pxkXWDBu/K2LcwDSpcHWtU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cqd2+bIF6zvHEtVti7pHOy2e5/jqE5W20nJ1/NYiQ8PYYBDyQKQJq/zUVoD92qqiJZrNALJrsNp5stgnCqshA6hOVzBhGotxok8mgLD2QMO81hX30DnmdNRNl4HHaK2WvX63s4yXM+7bqfL2ZncfmV1p+qkTUqd4B/6g9lO761M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ntfSmZdT; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ntfSmZdT"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-634779072f7so2902356a12.3
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498762; x=1760103562; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HybwN5usXimaW4enq6meCBW9SZH/kRyin9xx36GATCg=;
        b=ntfSmZdT90H3kAtFnUqscmY/BjHJXdI+u/N8awI07/FRC6m8sygScGjkDU0xAwNVkB
         TsZmqufihV9RzUQM0mGbaqB4p5ylswRbUXsPIHzr0lOwvUP9EgoD/THjKNJL55C28htq
         UtEgFLhiSehXZITB0qg+l74wxRjneKq86VTPN7rCGapesTcsiEBlcwZNZmA1Ea2Fhwy+
         KbYruyzqVzGcI3P8uUFueXevQdwQ0Yd8QO56bIGwsj3KPnG/NVS5A7oalZe//E06SQGf
         GO5DxdwwafAKTyRmd2KLzyPBYY8xlm47JMg1LC2PALTgkl9EJqyC5v1TKvWYbFYxv8rC
         jRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498762; x=1760103562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HybwN5usXimaW4enq6meCBW9SZH/kRyin9xx36GATCg=;
        b=pbWODNwz9f1EGN+yXhhJSjwTGEA9ktSp80ZuAFuJ64ZIQsBH81vQC+Enq1P7Tq94hm
         MaF6VNR7TbISMAzZQHb33sCwCYSptqvNGZMDfTYtOLyly9UxsbiPWrvWvygIRKQEUIq5
         abc87tlHKBOEmD9I9paw3R/wM0720cYsnVVu0+3rx4i8j9i2D5qOdJY1W25Kta8npiEx
         60FoNNmQWNz73gZmHN3Bid4AmaYabJLJ3qot0riJyHzckkwfJuCsqyY3/xW5tDsk8fNk
         OYeK16ZcAApP9mWQpAL/34B3zsUW3LjLiAnsPArt6gzGMNRHpVqlMPzXrFjs0VJPRmNq
         +MbA==
X-Gm-Message-State: AOJu0YzGvHkjE7ZLJS6d5VKivwqi/DbKAPDxgBSsPs3M85Xywx/mB/A+
	gwezZcJJL/3266GqWIbfssUag4gklLaa9a2cKZR7hdRBxmzNEy5J0BEJ7D5YSAqJMKJes9hITph
	OL6RLpUZTuR8nzRDrk25Jrg==
X-Google-Smtp-Source: AGHT+IELwj3gBuJyF3leF3G8LaRkBWs2P6oRG/az18DDC/e2gYixHQvg3JdF7vBDcun0KzShSZpMuULh4WsxehBQ
X-Received: from edpd15.prod.google.com ([2002:aa7:c1cf:0:b0:631:f056:e88b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1d53:b0:637:ec59:3169 with SMTP id 4fb4d7f45d1cf-639348e62c2mr3027788a12.14.1759498762216;
 Fri, 03 Oct 2025 06:39:22 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:24 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-28-vdonnefort@google.com>
Subject: [PATCH v7 27/28] KVM: arm64: Add selftest event support to pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
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
index e06358aaf1af..dc2ac3049428 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -45,6 +45,7 @@ menuconfig KVM
 config NVHE_EL2_DEBUG
 	bool "Debug mode for non-VHE EL2 object"
 	depends on KVM
+	select PKVM_SELFTESTS
 	help
 	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
 	  Failure reports will BUG() in the hypervisor. This is intended for
@@ -82,6 +83,15 @@ config PTDUMP_STAGE2_DEBUGFS
 
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
index f8361520967b..81d8628a9047 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -631,6 +631,20 @@ static void handle___pkvm_enable_event(struct kvm_cpu_context *host_ctxt)
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
@@ -677,6 +691,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_reset_tracing),
 	HANDLE_FUNC(__pkvm_swap_reader_tracing),
 	HANDLE_FUNC(__pkvm_enable_event),
+	HANDLE_FUNC(__pkvm_write_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 73539f5b5e42..7d078f87f86d 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -318,8 +318,34 @@ static int hyp_trace_clock_show(struct seq_file *m, void *v)
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
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace.tc
new file mode 100644
index 000000000000..49dca7c3861a
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace.tc
@@ -0,0 +1,10 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor tracing pipe
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/trace_pipe.tc
+
+set -e
+setup_remote "hypervisor"
+test_trace
-- 
2.51.0.618.g983fd99d29-goog

