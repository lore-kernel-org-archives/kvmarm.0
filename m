Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CD62472B0
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498758; cv=none; b=WfkZFTzBD9wqe48L5cNopkVjcSe1UDcsWJe6ap0qickdT/ghwOQmXeBzPPJRVc6hCsiDYr+zjm2a4AjSFcG6FkQsChQVZNEN07jGslKMMEu0AbSI+6l8jYp30EYsj91XATlGut4gfFUGTy6BjOlNmy6V4T7MqYI4EO6EudZcX6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498758; c=relaxed/simple;
	bh=0GoKLpSdS6ldxQXPbUu3GD19jDi+5YDA57nA2CXdDXI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TNH+K4PBQJbUyTl4WXOMIfpjFD55X0r7e9cMvHe+cOERqtjW6PS2UlpfKETMsJ9ANVtiFmelJl/FRrgxY4K2F9Y9Y4LAjUPjx/SwvNgdLZCQtqY7W5U/Ey+0Hvn3EKWQ6aI90bL3AdyquDstLk0hZ1FHh4fwclorizDQf8c5qPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tyX3Fjma; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tyX3Fjma"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so1081103f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498754; x=1760103554; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QCcr65sPLORj627Lp0bpZGMol0uaDnoIgHQtYd2TdNg=;
        b=tyX3FjmapaEypB7RAeJyjvifAD2pdK93OX8qcjmNEtR/hM9jlK2b1d8T6Brl75DYAO
         NZX3GWgYFJfjKiYxbk3+UQK9MtnL8L7Tdt6m4mJnaFAWdPGCgMdc+m9GpveNcbJlx0AU
         o101oBryZCQfWg6KMtCByKZ9xpItLAZk1FsweGkrLIHFqJPbkPTadcZ1loYgr0aRt2xf
         +DAIwbzaDFjdsFL8qOUsXGRe7uUc24VMgwb1dv/Ru4DMVmw1ISUXOnTrzGUzhSPF+bjV
         MLWM8PYCeHyspSX8XcG23ZUU8vlsax3S5Ui1k8yw2+ggpS6lMwB7r2G4VQdaECUYR98W
         thEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498754; x=1760103554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QCcr65sPLORj627Lp0bpZGMol0uaDnoIgHQtYd2TdNg=;
        b=MZv8oSZaksGWy0r+iGRwUjkm2/5EIGZBu/DeTCciSmA0rgT32QHr7QX4I89qABs724
         7rTiMOogiN3Ck1uwhXJdx+9cdwamnBr9RA4aEtDtxLpaAQRXvnNixuD11RTMk/l2EUau
         a4TKVvYTSlHAzpTsVPi9qaNAuJxmPDJ30h+zhiubmqSaSkbcB16NKDapgZqfRxpeKMDM
         H90/RAMToDxmiQwgFSaIIiaLG8OYje2L2fcqCbNCMQUMp0BehYb9q12pJAAgFKblrESg
         WmDfTFs7QllVsd1j+2K8ajiARzbfJ0ARkgFkmwKg0RZ85TxhRBiJjtCo0YCrPaggrkXC
         PEJA==
X-Gm-Message-State: AOJu0YzmH7/m9M23JleFsep8FR8ejp4RSZWb9I6gds/dvpy8WC41st1x
	0kPWBmhV8GDLPZgMKKtTPig2Rr/ohhoAvsMgwgfJBqreI0l5KZcq+v9spy0hvrj9q8/srbI3ySD
	DUf2EBvCsllLigV9tkm7f4w==
X-Google-Smtp-Source: AGHT+IHQ12IlCfmMAydiKBsHPD9Q4iJr8SeYEXmAn4PmVdl5+Rxkjar+IUCHmSelDg/tdXKzfnSMs19tRFdbpfxM
X-Received: from wmdd3.prod.google.com ([2002:a05:600c:a203:b0:45c:b62f:ca0d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:18a9:b0:411:3c14:3aa1 with SMTP id ffacd0b85a97d-42567139debmr2038918f8f.3.1759498754083;
 Fri, 03 Oct 2025 06:39:14 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:15 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-19-vdonnefort@google.com>
Subject: [PATCH v7 18/28] tracing: Check for undefined symbols in simple_ring_buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The simple_ring_buffer implementation must remain simple enough to be
used by the pKVM hypervisor. Prevent the object build if unresolved
symbols are found.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 53534447e70b..38523ea2e19b 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -114,4 +114,20 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
 obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
 obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 
+#
+# simple_ring_buffer is used by the pKVM hypervisor which does not have access
+# to all kernel symbols. Fail the build if forbidden symbols are found.
+#
+UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
+UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
+UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
+
+quiet_cmd_check_undefined = NM      $<
+      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
+
+$(obj)/%.o.checked: $(obj)/%.o FORCE
+	$(call if_changed,check_undefined)
+
+always-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o.checked
+
 libftrace-y := ftrace.o
-- 
2.51.0.618.g983fd99d29-goog

