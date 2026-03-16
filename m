Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CF92367CF
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 09:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773653331; cv=none; b=AawVbBLWqbOQUmlBMj1QQhBRoFFugL4azsuWnuuqiMXZQrft7bCAPcZqXh6z9HBLCivZ6TByGiFVpBlhAlrY1CrlmE4F6vR+kQn0IaNQ26+aS8QciH3LxJDy7HUPbDzEiJWUCxnxsdMAcGgzw8OozaVNw0gd2tqC/5RMvyk1nLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773653331; c=relaxed/simple;
	bh=d9SlOdr+yuwtL457l0FPmZf+z68vKfPB7woQApK9XA0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DsD9FsWR6EjXDG4bOKgdjSu0qaL3fiz5hxlpUPa6I+vLEcG+HIrPHv8KCt+hncCr+7jVmsm0ED5FOIPjqNtGGq3ZBSbhscn5n9eMtP3hwTTlIyeq/0ih/nfa71X03L1E7GRlAlFf7J3WF8m52vH3/8nkwtKcott3QkavLy4+R4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kuu0Mq0P; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kuu0Mq0P"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-662ff83887eso5770804a12.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 02:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773653328; x=1774258128; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xL4r3k0b9XFrHQ5zaFvHH136zETo7UQFZ5XYSWnx7+E=;
        b=kuu0Mq0PRWdeli1IAZnN3NAr0gXRHmOe/LiCF8w8w7nmRuacpzLWnQ7a18eVndnoq1
         Yd3fd3aLMCIKp8toe1XZTnJlB96VeSRezF+3MgNAt7mFny0YWcXtwijnqFIUTYlsJjNs
         SAs9507/TVM5FHBU86H2UTffs+Ar7FMSqobHJUvvFFgvXkpLdNR8iBSte9QEk7HjScNl
         w7uDFGb8QY3IqdZG5759biwgzRWO6TPOnIjjCPekS5xxlypadTcLiOggol6hu0Po3/cg
         15Nmgwavb9niBbIECTZWi7i0GJdor7OuAimfAEXeod9c4BI50NYkR/AJY5YBXsVFTAe8
         HI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773653328; x=1774258128;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xL4r3k0b9XFrHQ5zaFvHH136zETo7UQFZ5XYSWnx7+E=;
        b=motph/DC+8Xys/OFP3T8qA0Hw2ugeUdciRPzBYFrI7qZR5w0EpUv9gtt4N+zA0XFnU
         a6xfdnOk5VBALxgQkrwHRYrrWmxdgH4y/Ec+wiOzXtQccnqn+sM9JM/G+n6gAL0UIVPi
         KXwT3944/fmx6ZTTJPwsr5TECu0E0Kgb0IHB3eHJH5MJa9dBrHMNHr2DoibC5miKOT5+
         NamR1UafukXPP4WntXZhNwxUQMcsuFkfyS2ycrmlYVEbNT9v4rRXx95v5bhlNcI2d29H
         KiqF2581gj81ny+0cqzQ9Vidx18nCUJJ/Vv6VJCd9VgmU/C/eU3e3f9z4LecXThl3sNK
         fgRw==
X-Forwarded-Encrypted: i=1; AJvYcCUbvsTSstpFdYyNH1LuJNWuDy1mT8Rs1n/vAibLf+Am7fk2i0swfpZj0ftMgW1d9AnnqgTR/q0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIrpYuSaiEsffombQ3CzDujZiy032C8hThkihPY+pnJc8DzrRe
	5rATPZO3GtRlzJJiarR/7n8lVwYsilFeQf1Sqvizff2jDiKEZkM2VZnC1r+7A7BGOVFtpL3V4fW
	FA0bUQSkMyvt8hIcYayCVhQ==
X-Received: from edtb21.prod.google.com ([2002:aa7:c915:0:b0:664:dc29:5652])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:34c3:b0:665:33eb:22fd with SMTP id 4fb4d7f45d1cf-66533eb2557mr2129585a12.4.1773653327890;
 Mon, 16 Mar 2026 02:28:47 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:28:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260316092845.3367411-1-vdonnefort@google.com>
Subject: [PATCH v3] tracing: Generate undef symbols allowlist for simple_ring_buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org
Cc: rostedt@goodmis.org, arnd@arndb.de, nathan@kernel.org, 
	linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Compiler and tooling-generated symbols are difficult to maintain
across all supported architectures. Make the allowlist more robust by
replacing the harcoded list with a mechanism that automatically detects
these symbols.

This mechanism generates a C function designed to trigger common
compiler-inserted symbols.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

---

Changes in v3:

  - Enforce KASAN to ensure FORTIFY_SOURCE isn't disabled on some arch (Nathan) 

Changes in v2:

  - Use filechk (Nathan)
  - Removed deprecated extra-y (Nathan)
  - Added simple_ring_buffer in allowlist (Nathan)
  - Added memcpy() to generate more symbols (Nathan)
  - Added __sancov 

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index beb15936829d..f4503a001d4c 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -136,17 +136,47 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 # simple_ring_buffer is used by the pKVM hypervisor which does not have access
 # to all kernel symbols. Fail the build if forbidden symbols are found.
 #
-UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
-UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer llvm_gcda llvm_gcov
-UNDEFINED_ALLOWLIST += .TOC\. __clear_pages_unrolled __memmove copy_page warn_slowpath_fmt
-UNDEFINED_ALLOWLIST += ftrace_likely_update __hwasan_load __hwasan_store __hwasan_tag_memory
-UNDEFINED_ALLOWLIST += warn_bogus_irq_restore __stack_chk_guard
-UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
+# undefsyms_base generates a set of compiler and tooling-generated symbols that can
+# safely be ignored for simple_ring_buffer.
+#
+filechk_undefsyms_base = \
+	echo '$(pound)include <linux/atomic.h>'; \
+	echo '$(pound)include <linux/string.h>'; \
+	echo '$(pound)include <asm/page.h>'; \
+	echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);'; \
+	echo 'void undefsyms_base(void *p, int n);'; \
+	echo 'void undefsyms_base(void *p, int n) {'; \
+	echo '	char buffer[256] = { 0 };'; \
+	echo '	u32 u = 0;'; \
+	echo '	memset((char * volatile)page, 8, PAGE_SIZE);'; \
+	echo '	memset((char * volatile)buffer, 8, sizeof(buffer));'; \
+	echo '	memcpy((void * volatile)p, buffer, sizeof(buffer));'; \
+	echo '	cmpxchg((u32 * volatile)&u, 0, 8);'; \
+	echo '	WARN_ON(n == 0xdeadbeef);'; \
+	echo '}'
+
+$(obj)/undefsyms_base.c: FORCE
+	$(call filechk,undefsyms_base)
+
+clean-files += undefsyms_base.c
+
+$(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
+
+targets += undefsyms_base.o
+
+# Ensure KASAN is enabled to avoid logic that may disable FORTIFY_SOURCE when
+# KASAN is not enabled. undefsyms_base.o does not automatically get KASAN flags
+# because it is not linked into vmlinux.
+KASAN_SANITIZE_undefsyms_base.o := y
+
+UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sancov __sanitizer __tsan __ubsan __x86_indirect_thunk \
+		      simple_ring_buffer \
+		      $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
 
 quiet_cmd_check_undefined = NM      $<
-      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
+      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(addprefix -e , $(UNDEFINED_ALLOWLIST))`"
 
-$(obj)/%.o.checked: $(obj)/%.o FORCE
+$(obj)/%.o.checked: $(obj)/%.o $(obj)/undefsyms_base.o FORCE
 	$(call if_changed,check_undefined)
 
 always-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o.checked

base-commit: 33f2e266515717c4b2df585dadefa0525557726c
-- 
2.53.0.851.ga537e3e6e9-goog

