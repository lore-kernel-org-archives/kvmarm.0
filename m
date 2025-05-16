Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02DA1D5161
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402863; cv=none; b=BkopShukrCFFEjKiiKihRlrZf9dYzcTFGyRq4v/hZv7Cv7SdC2XpE8tFDVWq7xEwcNEF+7Q5bsb0yDzE7uVyyli3O7NE90y7qyry0wR9DZfH35rHwru+ZTb0W4Vni99GixN7SWioXjzfRcqwYX+x65/qimjR7wO5URFdS7vsmRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402863; c=relaxed/simple;
	bh=mCkGhXQ9HdT6vaPKf9v0QJ96Q8g5D32UXPYyP/6Il5I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KmGlGEajfQf+cx1QdavIZ/iPGiInSjYCM0gREe+BOrXm0F5H5ufBLM0RZsnDHM2r7NxqHqkkkGb4awWWXFc064RKor0ADUmn4pUJ9eHthUEM7e7X9CK0hGoVarUth8Pvbl8VzD/zcKkY6LyzXKHqD7j29BgIO4uw06wHnvipXsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wzGty0MQ; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wzGty0MQ"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cfda30a3cso11917595e9.3
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402860; x=1748007660; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/CZG/M9udoL/6ITBTvAzkp9kaJCKtk/wbKte22WkTiI=;
        b=wzGty0MQ43udG9j/r9ODIuYmoW0rDP1YdM4oaewHaaOFntoePIOHYGQICZU0w61kvs
         7OqHQwNXKm6bBQmHe7OWYV+j5xJpWWwjk26geAOE1+jdrzvHjnMv7uJjCvXAjuOsrLuM
         EouBGJbOAalPiFkZq/XI1l0pcwRY2pPNoui1bvjEcyO3cvj5gT6SnTNWOdro0GAoER6G
         zWRGjjlytjqdqy7LzHzLAoNZN8iJ9b7M7BjcTlqLL7+8LxMSEhBlJoQSyRx7ctepxA/w
         MH1GV+HWdyy7XthXJJK+HQNQ9loQOnODBqOBhOG4lQST4KllVeL+N53MmbZjKtB6D5J5
         aPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402860; x=1748007660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/CZG/M9udoL/6ITBTvAzkp9kaJCKtk/wbKte22WkTiI=;
        b=FGkM61w1jeF0Yu1n/Azvc5uoIOWPFcGSJb8ail6WdbG50uJoBTj12Y8ljY5IG90bYU
         /v9es6a+p6FJBikFAwPq6IFqvpwPGlJ1Rf3bTym1pG/yA5UzcgW6IRJHYwfr8Vt+0dcm
         vnq1Sp1RzUZiQM3rOHqI0A0U/bSjAIO0XhGvZVZGT259rDZXnd40TdAs3VU3kMxQScaT
         36IAaCwVKgFH01kODdzeRmMfvkPa6tDahZiWWukjmgW9DUz5OA5nQQDZKMhFqeQIASms
         Fzi7u675LdIMwOiaguBbjZrmXREJKXrLHxyZcUHCskjihpCgg+J/i1TGGwN/oW97YwVp
         CaWA==
X-Gm-Message-State: AOJu0YwD9+phKQQ9tEvse3Hz+PuHcxn9QmTUeYmpl7I2qV6bJrxOeCJG
	+Fb39zWNhjSGd/kB2ojsqtBBdT0952mfePjJ2w4pOISnElZEmOvi30WrXrtFAA8npiTXhJxrH7B
	5gGGldxmEUtZ7ncp1rkNS5g==
X-Google-Smtp-Source: AGHT+IFmCUr9TTt3q0ScKQbNlGA2kldElMEmGgUhWM5ki5iG13VQEOpV9idvmUymy+nrLiyBs1jUYWF7uKdlvNF9
X-Received: from wmbes7.prod.google.com ([2002:a05:600c:8107:b0:43d:9035:df36])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6296:b0:43d:46de:b0eb with SMTP id 5b1f17b1804b1-442fefee254mr27261565e9.12.1747402860332;
 Fri, 16 May 2025 06:41:00 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:20 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-15-vdonnefort@google.com>
Subject: [PATCH v5 14/25] tracing: Check for undefined symbols in simple_ring_buffer
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The simple_ring_buffer implementation must remain simple enough to be
used by the pKVM hypervisor. Prevent the object build if unresolved
symbols are found.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 8f5e194eba71..eb7b70fd5ccd 100644
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
2.49.0.1101.gccaa498523-goog

