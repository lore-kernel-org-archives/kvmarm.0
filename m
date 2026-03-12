Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D503EF0A0
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773339628; cv=none; b=OsopWada9lSCHB6xxmpQYMVidZO853mO+zsszlqYi+Kk6y8mRzchNqJOQIYNKKEOvFsQYCP+aaqPlB57o2CIjcin4K9tQ/JkJo6vm3c2fR8uDnDs0eaEp3337AQicsi5NIAn5EO7fUN2Nhe8ZWVBTbIyckTSkZpHd88kfSFtrg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773339628; c=relaxed/simple;
	bh=A+A+tratlevD3a3rMI2wmVXp/n07E7eNLHxYMsuqPio=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PtmZl+x7FvmLwtIb4mTrYGstXS69iX1qDTTlmlb7TW5Y/1RRGgVqNH3youQvWXAX902qpRCXsc/Jgzvyl0bU5iHaLbwYSLZtCFyrbfRVuZKjN/jSqgq88ydVnvMzRk03mE4O4aUXXa3stnaNqrAcEQfQwF7Kk1WwIyK5uOaiDOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dY+VzPPY; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dY+VzPPY"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b0af42aso19104885e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 11:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773339623; x=1773944423; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dK9k5DTKgk7wxx2+4cg6YZWZrym/c7pdTbONfQY+9AY=;
        b=dY+VzPPYVM4ad8j5Y/NTf5VCYuggXf4SzNNorrM6J3KL3d+1g2ayg/QsHnmR2PUFzp
         osztXyXAzkEStN+ArBoD0VGaFWmfRVVctqy6kVL5F7ZWJGY5G+BPdoYyNrHrEe+9oiFB
         ztlYGcZK/90MVRabZEcLmhuKGY1bS9jIEoVNegO4cMuELtAA9znlsUnDHfEA+gv1giA+
         6Cj5JTGHvqgvdtgs2pn6TO4TL6b4kAzGa7Npz/Iytg7fVgBrJN4yikro4TNiXGuxDvqD
         kLOPbCZdbkKMuSuKfKIJWxzuuFGiiauaHxV4T87qzxrEwAMcDYNS71gU2EHDC9GriaCk
         lp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773339623; x=1773944423;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dK9k5DTKgk7wxx2+4cg6YZWZrym/c7pdTbONfQY+9AY=;
        b=kjZks+ub6WygKEN6tE5CYSGgA3q2fWpJTLZ2cewhMeFMayipTxTcGqEgT+kHGBJ0FX
         uhauSPuplTM0UnXHhAPwpudLhreW16SwvETXZVoSJJAjY92Dd5B8wbsSkFSr05N8s970
         8Uk+JsxtBm6h0C37Z5u7aPF76zGqDPW1NCD3mPOi7aQaIoH0dFAr5s16HyNYvtRBrSva
         J78lk+5grliDdeimDz5lqLMS9WkI+9CZoXjTTzQAuq/nq2cCpEDn6HYEHKMd4u/KnxAZ
         MOKaN709DoWV1UZLjTZKO524M/ODsgtYlyJ4b6ljZVUQuC2bL3SDChz8JLBpfLtRn2jY
         v3VA==
X-Forwarded-Encrypted: i=1; AJvYcCUHnTINZX9iByxDDnkTelGnHMuAh81LteV8xzY58+pfgTSQQGUIraEFSODr0Cql1lVN4XA/vEU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8tZT7JRJWuzu93cYxHlxJtBkDUH6q2AsQeBEysQyHT2FkRYRu
	K63xDAq2IbGJhjTeTY4wHTxY/PYoq+bfOK+Zib1jQjEQdVFi9pYmYPk0nkA3H0DR+nq1vsTiexp
	svZN3ZwnCLXI+y/XwUELrow==
X-Received: from wmcu23.prod.google.com ([2002:a7b:c057:0:b0:485:385e:a8c1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:644a:20b0:485:3bb0:194 with SMTP id 5b1f17b1804b1-48556714b41mr3819805e9.35.1773339622932;
 Thu, 12 Mar 2026 11:20:22 -0700 (PDT)
Date: Thu, 12 Mar 2026 18:20:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260312182010.111013-1-vdonnefort@google.com>
Subject: [PATCH] tracing: Generate undef symbols allowlist for simple_ring_buffer
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

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index beb15936829d..3b427b76434a 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -136,17 +136,37 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
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
+$(obj)/undefsyms_base.c: FORCE
+	$(Q)echo '#include <asm/page.h>' > $@
+	$(Q)echo '#include <asm/local.h>' >> $@
+	$(Q)echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);' >> $@
+	$(Q)echo 'void undefsyms_base(int n);' >> $@
+	$(Q)echo 'void undefsyms_base(int n) {' >> $@
+	$(Q)echo '	char buffer[256] = { 0 };' >> $@
+	$(Q)echo '	u32 u = 0;' >> $@
+	$(Q)echo '	memset((char * volatile)page, 8, PAGE_SIZE);' >> $@
+	$(Q)echo '	memset((char * volatile)buffer, 8, sizeof(buffer));' >> $@
+	$(Q)echo '	cmpxchg((u32 * volatile)&u, 0, 8);' >> $@
+	$(Q)echo '	WARN_ON(n == 0xdeadbeef);' >> $@
+	$(Q)echo '}' >> $@
+
+clean-files += undefsyms_base.c
+targets += undefsyms_base.c
+
+$(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
+
+extra-y += undefsyms_base.o
+
+UNDEFINED_ALLOWLIST = __asan __gcov __kasan __kcsan __hwasan __sanitizer __tsan __ubsan __x86_indirect_thunk \
+		       $(shell $(NM) -u $(obj)/undefsyms_base.o 2>/dev/null | awk '{print $$2}')
 
 quiet_cmd_check_undefined = NM      $<
-      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
+      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(addprefix -e ,$(UNDEFINED_ALLOWLIST))`"
 
-$(obj)/%.o.checked: $(obj)/%.o FORCE
+$(obj)/%.o.checked: $(obj)/%.o $(obj)/undefsyms_base.o FORCE
 	$(call if_changed,check_undefined)
 
 always-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o.checked

base-commit: 33f2e266515717c4b2df585dadefa0525557726c
-- 
2.53.0.851.ga537e3e6e9-goog

