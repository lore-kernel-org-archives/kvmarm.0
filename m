Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EB534405B
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513423; cv=none; b=ak7Zgt3XeM3Hg/erDzGYvC1YKI6L1KooTkzuKdD0vHna71MWnu8gtoIzIxDGHLvH0jjpmJ0cNlqtHXzB9/gqI4SJdq2Z7vjkNxp9P1Ugz2QyN3XKx+TyZLkVfshK49C+INdEKMakpfD82PKIKDWeOHlaJ2TulHXVQb5enjfVvrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513423; c=relaxed/simple;
	bh=7EE95rx0LrgIT4QyX6117YMbNjqFfAiq5/cDJlqfniQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XqxXMX2zN5tv6dC26jZoIFZ4vjqwmvO3veFisq4Rm8r+1R8iZ3lzyEy180mnRuggj3FdWo8a5+AkXWttehfnlSxYkUcEo2uXAYF5FLxtRa7smAmE+lDYnpMn/VToBDfalATppOx5NGbWPKL6f9TNzc+Ux/xJq11E8C7Y9ZF+jW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3WHkX/L6; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3WHkX/L6"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48079ae1001so7399705e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513420; x=1772118220; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wD6LPWf1rq+248KhxWwP0GcpeSFjPhgsN1twvSzFVPg=;
        b=3WHkX/L6rdhFz4YUHcuRILD+tIk5VcmunNYL+y8lvFPHRH73TrwTOWFyTwhKgigAZW
         N1KUWwmpiO6mgUP1RRvtttPAte+r9DpgWwekgWklX5Xn9AZx9Dqv2ww6THhpZsjo3UPE
         gNWVWqkawRWozeWcnYiV0HMWH4aYhqsp6DfiZfuRXQpm13khFokFsUN5YtoTBifea5hT
         bqqGc6riYH7nDLKFHZtlAGY9rw+NYa8NjjfaBi5c+QAtXvKszW+0qMiL75ZJNJclV/BS
         KCUl/xG8GxbPiQhGoUa31O6PJ5K+aUQEibVK2pEPU4isdBHGuZI9WyH8zwlRVnsweKvj
         oxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513420; x=1772118220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wD6LPWf1rq+248KhxWwP0GcpeSFjPhgsN1twvSzFVPg=;
        b=CQPS2wLpK77L0eYHNyWpJl86JeL4fg6RY/SrIPsaLiF+QeH3hgtOlExNMq7lL2RMSn
         wJwhm+BAuiSTua0HqkGI+c6sEOoJg6NPVuoy0n0VYK3E7Oq5k0IhslYRUiJlxfsH/8+t
         zJtcK5oe6JVA00wsh9ZgXgRcrGoYOBXkcb7zAZzmBPvfRVLwHNeTFwOWOM2COcgDXwCu
         4krpd1IrnZ9Vmn5/K2NWwCzwbedvFDcJDrrBU0N0L7htavaWvFMUAhcZYQzQN4g1iog7
         JbRWXJyjOWgYKuMHc9TsoA8W2IOkxRLG+Kifgn34m6TKlAnebLoHgU5JYxHBnPr2bhhb
         2pIw==
X-Gm-Message-State: AOJu0YxMUMKvi5/uc6g+/KL34yObNW6ccj3Zzc33E011HFvUiq3ZacKJ
	g2lRDMINPPvZZSKeh/npGUMo++kKRV2d0c/RiO5kwG18vDiO83kTG/CVjkoX5Aww6lHt4gV9MtK
	3hQ6MnPndgMVnv7sEJABzIg==
X-Received: from wmxb5-n2.prod.google.com ([2002:a05:600d:8445:20b0:483:43dc:999f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4443:b0:47e:e952:86c9 with SMTP id 5b1f17b1804b1-48379b318bamr268163575e9.0.1771513419651;
 Thu, 19 Feb 2026 07:03:39 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:55 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-19-vdonnefort@google.com>
Subject: [PATCH v12 18/30] tracing: Check for undefined symbols in simple_ring_buffer
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

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index d106beca8d7f..3182e1bc1cf7 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -132,4 +132,20 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
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
2.53.0.335.g19a08e0c02-goog

