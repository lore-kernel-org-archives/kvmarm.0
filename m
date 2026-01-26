Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6877C3375C2
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424287; cv=none; b=sy2C52ry2lSDwtNAtH/K5FdbJ2ulPvcBPZRz+6oF/Blg/dIrEXA2ip8Veck70xfDov6Vvtad8lqITfNWwrQzH0ep+ClI4gtdG53o3uDAwZ4qJKNpqxAks+ox+8AmfUBiiapFEhr782L2IoIjZ+HrjdGDUQkVRfHPku3Tl6OSaeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424287; c=relaxed/simple;
	bh=oQepgTds953X9ZSRx8narASK/dLpitaUTQSyWeif9Uw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SZMK2yEyKeaVki0cMP4HD2lux9KW+u2e4YNQTlc61/8AmgydziRmP91qQQhFVmB/1CxzAdfrljrST+Pddq1bebltgOFIMmmdLJ01sLPWguSnOdUZuu0972o6E48w3psYFEZFT2tY38fpnG9TAtp3TG3AvBN0EkiSGdO+aa4MrgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XC2HFoGG; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XC2HFoGG"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4801e3aab32so21231555e9.3
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424283; x=1770029083; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nCWSwRRLX2vVrxRiofVP3mO9oKo652mx1rQXYMhNwUA=;
        b=XC2HFoGGIOt/cdHbM51AaVbROxBjm9oYF0wcMr8E6EAeSsoUQGAVTzRM6Pxw5Zogqj
         wEVKStE1GhySzead5zQ3YRoI6AXZua2kJA0iE1rExzB/YljRe4cXEk0twgrkMDd0Xh+6
         TAOnfc4tRfShcgzKRyXD5GWfrkGTArj/2iEvJeTp1W8O9KsbRTPniQ5AOcdqVw+1SW5v
         XUd5wbRayBrG5nCemHpAVwdQ7d7dcp+2FQ2bO2aesIzLC7MmZJaLkZz8xIacNBTvoggN
         tVkT5bT99Cd/veeEsAvTE9VimSh0urQlShDY/wsFKM9M3aRQOBnjt8oKS1Lse63gAnh0
         BC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424283; x=1770029083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nCWSwRRLX2vVrxRiofVP3mO9oKo652mx1rQXYMhNwUA=;
        b=PMpmtlt6ytcCHZSVtENndykI4AMSh6NCK5AKROiPx8zbBYXPp9vDSookVLsfS1cCNc
         r4eoR750RZFx5lPtqC419+RqoTZayCokkCnPsB3YrRP8qKO6teb8XEOr0sQdAFIG57qc
         2wu3B+LKbRB7m9oYk5kAta6bF4KI7M4Mx/BRQi4xsEWjsc43F+tFzOf7hLQDlwRb1H8r
         KnE4B8iPVeDmB0mC6a7JFUgiUIcBiT7mRkoDoFaqKnsUfZ1DOdr5qCJVgrcbiGShDEPD
         x3MhAhPxIrFU2eFJEmsTotG8F2Ch9RMrDruuQVCk6/HWwZROu6LJdZlmFqi0oA3LRNaE
         aKmg==
X-Gm-Message-State: AOJu0YyXZI1qAs10K2XMKK2dec04xiN+RXAmY8ijzQXUdEWvTGbuu1vE
	WQu+AHWskdkjxolS3gzK/HyNqrGpyknqB+9qQs6CyRAzaH43pvf0nxocrDC4JktaLNqhjSILjUB
	loveKK0XDfVDvzYWpUkNkUg==
X-Received: from wmbjn6.prod.google.com ([2002:a05:600c:6b06:b0:479:36b0:ff54])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b55:b0:477:a1a2:d829 with SMTP id 5b1f17b1804b1-4805ce3fc93mr55832515e9.13.1769424283227;
 Mon, 26 Jan 2026 02:44:43 -0800 (PST)
Date: Mon, 26 Jan 2026 10:44:08 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-20-vdonnefort@google.com>
Subject: [PATCH v10 19/30] KVM: arm64: Add PKVM_DISABLE_STAGE2_ON_PANIC
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

Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 4f803fd1c99a..6498dec00fe9 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -43,9 +43,27 @@ menuconfig KVM
 
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
@@ -53,10 +71,23 @@ config NVHE_EL2_DEBUG
 
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
 
@@ -66,21 +97,6 @@ config PROTECTED_NVHE_STACKTRACE
 
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
2.52.0.457.g6b5491de43-goog

