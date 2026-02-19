Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75ED342C88
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513429; cv=none; b=T+Oufbtg/9ouRlPMSbFJl4O3w7kyD99vUZDUZIC9pUCMqig2J2uqwSKGxyngLEInSOwLrQ/OXlLf5mscmyHbikPO+hDL9UPIQOfMMlvrlmrWGN2d8y/EWIgQr8qi7bVdsWkzGFWJmWfP7SDT5ZacS3j+lIt/K2RLTIOt0VJU2xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513429; c=relaxed/simple;
	bh=lNMC0YrJEXrzZjF7fNCbj6N9ycgkN2r499mLz7p2F+k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CSIb0XkIVVWjWeIokCnc3DjOVcyZPNTbGrt6aT6Cgehm0dQNDocBRREgD/EObp2sT709cxo3u87jF7F1V68uiMXSvrGIavRRqLAukWtgFSAcuo0aHcGLw+jrLhaZbGTmm4Y776Os2EHbKoqCUdYB++H71nsK+ZY+ZJGIKBfVbBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=loiF8/JU; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="loiF8/JU"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837f288194so9052615e9.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513426; x=1772118226; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3FakAQ6ZAGTITbWRJY7PLQmzeD0Nlfh0Im2ooiMduTE=;
        b=loiF8/JUafVDtF0QmFN+h3m7XJ4+gpMnHjpYZYZrh1HBByGkAq8XpoHRyBAOKAKbcs
         NLs156CtkXdkXamLcbhUL0CDdMDIjq7m6+QVQRsXIirXevErWHRmdakEsolCEBOGnSd5
         wF9qZ85G5GI6IuNe6laqjLVAwljbOKAfP1ALHRlm4DWln9kshc83QbKhlDwlqdCb0uF9
         7uAE7IfzM1101rLQGho/cqT4DhtWNVfsNRET4LUkSX8VO3CvDrw3H8mpRlvJNHkXKMO/
         k0hXXZHts/Bwlc17OLklaJRYQ8r+4SY9+kUxtauuwUjkfJ3N2BnoMq/kzJNBwdS1CMwR
         GlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513426; x=1772118226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FakAQ6ZAGTITbWRJY7PLQmzeD0Nlfh0Im2ooiMduTE=;
        b=vorXU199uDHNyrdq7GVDXQTKNj34mMghg5IS1lv18nYXRfmQEggDqG6itd1hWAif0+
         JMN0lNbQXfJ3AxmxiY6ykEUIU+u6IgWlxd/RH4m5BApmxvV50i9QYSA91E8/6VpB5vnH
         7KkYynyTKWcQ+plJI/rLgzF6nhg2ZnLDElrImqxfTlXdIahJ2imhc1FRUpc+S3ml5uDt
         GT3oK/kF3S27oNaw+QqMhSsDbXU99h5VFUGUGkr+83lCxlr8X7iMFv7UrylqVxa4dt23
         0i3ulBlC8HL0ctkeJUP1Pj46EfmxD6E0ThC+1F909p0a5wNgAyA9ly9Y2u3bIQT1KHRf
         X9lA==
X-Gm-Message-State: AOJu0YxEQze1/dl0bOqeYbLouTxt5kkKK2WInjMkaVkfFVWCcGbjLWov
	YdVEQcKpgHXLCn3hKrOxHZpsuqJKL3tob/jjBThkqSVt2YmuRj7eGHqiZGu7akr5qwfJbcIClUk
	9fVGI46KjCyesPT9YDQm0JQ==
X-Received: from wmjv9.prod.google.com ([2002:a7b:cb49:0:b0:483:41b6:adeb])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b4c:b0:480:39ad:3b7c with SMTP id 5b1f17b1804b1-4837106152cmr357089555e9.16.1771513420581;
 Thu, 19 Feb 2026 07:03:40 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:56 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-20-vdonnefort@google.com>
Subject: [PATCH v12 19/30] KVM: arm64: Add PKVM_DISABLE_STAGE2_ON_PANIC
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
2.53.0.335.g19a08e0c02-goog

