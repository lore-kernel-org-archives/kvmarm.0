Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF453EDAD8
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073583; cv=none; b=sfPEEaPixdb2kSanB6Ptr7PD3jqiBwuIFiB/cGm67QuDuYM8C7qcpWf1AVcgeWH0FbhqaGiEFtx7ijncuH/DgqphGpoVQBuaHkxmjJdQsrknLTtOaam77LLJsHCKfUsZxqz2taw/OtquvXFYtLHxam/BkvPiFrh9XeFKlRlT84c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073583; c=relaxed/simple;
	bh=wFFwKKRSoeQ+hvE9YtKcm+s8Wq0rCUCB3HKs84iPvt0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tdaRarHiLgII5LW4xEbYJl3bxekwd0SJsPWn3H0bLpSEL/qnc1E5ssH38OSXyD3upWIVhaoRK5MU1WHiemHGqlmxUWEGemeqbdo4A39swKbY7OGH5iPt1ci4ox2hFr9nChCB0EOv2YfWCjhVdA8Vnv1M3uTcItCcXRrDQz/j9Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rxbMQtF4; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rxbMQtF4"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4853ab1cae0so13152045e9.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073580; x=1773678380; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d8Z7WAdfX72ZQ1vrHpbOchqHWcE4sgC6MSulzPzgnyE=;
        b=rxbMQtF4zULG22RnG3JsVh6DzqCRZVcZg91XUvAVh7CD+bnm87aZOIxJAq6yxN2MWz
         0DofXXeJK7R3YCndsUh9P68QL1pkQJde5ncWjsGyvqFB9zHUQk9wbDkaKkdaytmAM9Wx
         9FMCtK2nsfcp8AUcvmh/YAY0whMwpC1K6UW3zMdhEYyz86XVPsN/fzJqCL7QOHDtnyUC
         4mugbwSeK9uTBdifMZ9snyPqWeqtYxA5Znxxgpvf8BXdlUdAn6ZP+WZy05Y+Gw/lKrsm
         EbrqPiLQQ68bvM4Gy+QMLZvGUqG33icRKJ8bJndhrBBe/LdsIHi/X8n4aBdqnSsKejxL
         EUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073580; x=1773678380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d8Z7WAdfX72ZQ1vrHpbOchqHWcE4sgC6MSulzPzgnyE=;
        b=r1rzw2Oz+LO7QAgNe11Dv1U1fqx0k3t9C5VPszzMRMMDHjIkHt+ZXnqIuS1MJ9DPiq
         e+Ezg/Odoe6JUHhIxHnsyyJRGdzxehUktGgn6QvABZ97vrd38XXpSnJzjuSO54CeIRCD
         GNc8DdWRZKYlaCSx5OV2O5WrtPCS09sLK1/CUztuhJ+0bUnxbu9pg+hQzoH+iLhcaiS9
         58b82gzGtSj4+BfbwLLILCvi5g3+H2nO07vwr1q74nQvfzF33QjbWcHrIIi0QF+4//6e
         uBgrU5+1nhlE26SSPuReqBZ/ZSuA1gC+IUEwXCqJsofm3ZbxZqySOW5yIA1TcGbL6jWq
         afqg==
X-Gm-Message-State: AOJu0YwRkQHZj1+bXFLDtmNphFd8jLsqKf5EYASoPYDuyTzXxNLkKtQq
	hElxMQ5aN/l64piIXy6wEes5/eG0lMzj6m4Fz2hHkJJMZLA0bd192Zn11YilYPZG8VWvOHnGmtm
	m/asTbXRsrJKwJ/CuorYrjg==
X-Received: from wmkg8.prod.google.com ([2002:a7b:c4c8:0:b0:485:38f8:2739])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a12:b0:483:badb:618f with SMTP id 5b1f17b1804b1-48526966b07mr181485735e9.25.1773073579913;
 Mon, 09 Mar 2026 09:26:19 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:05 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-20-vdonnefort@google.com>
Subject: [PATCH v14 19/30] KVM: arm64: Add PKVM_DISABLE_STAGE2_ON_PANIC
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>
Content-Type: text/plain; charset="UTF-8"

On NVHE_EL2_DEBUG, when using pKVM, the host stage-2 is relaxed to grant
the kernel access to the stacktrace, hypervisor bug table and text to
symbolize addresses. This is unsafe for production. In preparation for
adding more debug options to NVHE_EL2_DEBUG, decouple the stage-2
relaxation into a separate option.

While at it, rename PROTECTED_NVHE_STACKTRACE into PKVM_STACKTRACE,
following the same naming scheme as PKVM_DISABLE_STAGE2_ON_PANIC.

Reviewed-by: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 7d1f22fd490b..14b2d0b0b831 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -42,9 +42,27 @@ menuconfig KVM
 
 	  If unsure, say N.
 
+if KVM
+
+config PTDUMP_STAGE2_DEBUGFS
+	bool "Present the stage-2 pagetables to debugfs"
+	depends on DEBUG_KERNEL
+	depends on DEBUG_FS
+	depends on ARCH_HAS_PTDUMP
+	select PTDUMP
+	default n
+	help
+	  Say Y here if you want to show the stage-2 kernel pagetables
+	  layout in a debugfs file. This information is only useful for kernel developers
+	  who are working in architecture specific areas of the kernel.
+	  It is probably not a good idea to enable this feature in a production
+	  kernel.
+
+	  If in doubt, say N.
+
 config NVHE_EL2_DEBUG
 	bool "Debug mode for non-VHE EL2 object"
-	depends on KVM
+	default n
 	help
 	  Say Y here to enable the debug mode for the non-VHE KVM EL2 object.
 	  Failure reports will BUG() in the hypervisor. This is intended for
@@ -52,10 +70,23 @@ config NVHE_EL2_DEBUG
 
 	  If unsure, say N.
 
-config PROTECTED_NVHE_STACKTRACE
-	bool "Protected KVM hypervisor stacktraces"
-	depends on NVHE_EL2_DEBUG
+if NVHE_EL2_DEBUG
+
+config PKVM_DISABLE_STAGE2_ON_PANIC
+	bool "Disable the host stage-2 on panic"
 	default n
+	help
+	  Relax the host stage-2 on hypervisor panic to allow the kernel to
+	  unwind and symbolize the hypervisor stacktrace. This however tampers
+	  the system security. This is intended for local EL2 hypervisor
+	  development.
+
+	  If unsure, say N.
+
+config PKVM_STACKTRACE
+	bool "Protected KVM hypervisor stacktraces"
+	depends on PKVM_DISABLE_STAGE2_ON_PANIC
+	default y
 	help
 	  Say Y here to enable pKVM hypervisor stacktraces on hyp_panic()
 
@@ -65,21 +96,6 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
-config PTDUMP_STAGE2_DEBUGFS
-	bool "Present the stage-2 pagetables to debugfs"
-	depends on KVM
-	depends on DEBUG_KERNEL
-	depends on DEBUG_FS
-	depends on ARCH_HAS_PTDUMP
-	select PTDUMP
-	default n
-	help
-	  Say Y here if you want to show the stage-2 kernel pagetables
-	  layout in a debugfs file. This information is only useful for kernel developers
-	  who are working in architecture specific areas of the kernel.
-	  It is probably not a good idea to enable this feature in a production
-	  kernel.
-
-	  If in doubt, say N.
-
+endif # NVHE_EL2_DEBUG
+endif # KVM
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index cc7d5d1709cb..54aedf93c78b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -539,7 +539,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 
 		/* All hyp bugs, including warnings, are treated as fatal. */
 		if (!is_protected_kvm_enabled() ||
-		    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
+		    IS_ENABLED(CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC)) {
 			struct bug_entry *bug = find_bug(elr_in_kimg);
 
 			if (bug)
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index eef15b374abb..3092befcd97c 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -120,7 +120,7 @@ SYM_FUNC_START(__hyp_do_panic)
 
 	mov	x29, x0
 
-#ifdef CONFIG_NVHE_EL2_DEBUG
+#ifdef PKVM_DISABLE_STAGE2_ON_PANIC
 	/* Ensure host stage-2 is disabled */
 	mrs	x0, hcr_el2
 	bic	x0, x0, #HCR_VM
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 5b6eeab1a774..7c832d60d22b 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -34,7 +34,7 @@ static void hyp_prepare_backtrace(unsigned long fp, unsigned long pc)
 	stacktrace_info->pc = pc;
 }
 
-#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+#ifdef CONFIG_PKVM_STACKTRACE
 #include <asm/stacktrace/nvhe.h>
 
 DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
@@ -134,11 +134,11 @@ static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
 
 	unwind(&state, pkvm_save_backtrace_entry, &idx);
 }
-#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+#else /* !CONFIG_PKVM_STACKTRACE */
 static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
 {
 }
-#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
+#endif /* CONFIG_PKVM_STACKTRACE */
 
 /*
  * kvm_nvhe_prepare_backtrace - prepare to dump the nVHE backtrace
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index af5eec681127..9724c320126b 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -197,7 +197,7 @@ static void hyp_dump_backtrace(unsigned long hyp_offset)
 	kvm_nvhe_dump_backtrace_end();
 }
 
-#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
+#ifdef CONFIG_PKVM_STACKTRACE
 DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
 			 pkvm_stacktrace);
 
@@ -225,12 +225,12 @@ static void pkvm_dump_backtrace(unsigned long hyp_offset)
 		kvm_nvhe_dump_backtrace_entry((void *)hyp_offset, stacktrace[i]);
 	kvm_nvhe_dump_backtrace_end();
 }
-#else	/* !CONFIG_PROTECTED_NVHE_STACKTRACE */
+#else	/* !CONFIG_PKVM_STACKTRACE */
 static void pkvm_dump_backtrace(unsigned long hyp_offset)
 {
-	kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE\n");
+	kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PKVM_STACKTRACE\n");
 }
-#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
+#endif /* CONFIG_PKVM_STACKTRACE */
 
 /*
  * kvm_nvhe_dump_backtrace - Dump KVM nVHE hypervisor backtrace.
-- 
2.53.0.473.g4a7958ca14-goog

