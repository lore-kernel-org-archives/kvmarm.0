Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A665D33508E
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424286; cv=none; b=gpSSXDmPryfFuYJw9qxozanah0xi7JfOUgWrKhuekBZaRREPEkwbXMFJr18ccm8EBVYFgQoCIKjzJ++taOKevwWGQhqRkAyo/9q5kSt7j/FanA7WEU4GQ1LkQgJS1M8r2talEOAp7IM0vNfNJh/Z3s+DKoUAsfKVDrFsoxCfVEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424286; c=relaxed/simple;
	bh=+E83IqF+W5HGdaZV8YeGmeArEiV/GcB4OlenBzDOJBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z3WkoIJaSlU1rVPj1ZN70nzA6SDxbuicen7nsFKksU2zxnsBQYeGm+UHf1qdBKbuioJ4TAGblSUpYTu4Tb0esLvDZcdii0k9w2mWJafpcgSaekHXcOI5ztSyQdJXAJwd2vDJSk2kUfN1Qf3nt+ny6PcYtQ+K45Z6ulDcCo1AFcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kxTl5ri0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kxTl5ri0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47ee8808ffbso32712825e9.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424282; x=1770029082; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YywhJHdQmzvLYqPf/VNWfmyvJv23Am2v8tnakAtmlS0=;
        b=kxTl5ri0vKB16od6fY0+q/YreXsm3ZjHVwm5f8k8sNSKAdXyv3zxnJgopFn65pdAVx
         QnPn+b1aIWxSUwHaa44wL7Y8Pgi6YLV+8QrokFZlE1C8tzS21b3tOMv8Sab2nB7POMTA
         /E3+VS9ocMgmtkd33pR88iy5Zqhh4eGDrnrgaM2CPnD8+dzRJxrFImvWiCaWCS4bBsLV
         ex8K42rwiHxurCGAI2+LmqpDy7DK9wlDeox1QftQ0LtzO0T52/6i0gBSZqly8MXJQoWk
         wYuHuekJFPTWrScPne14e02Ty+zMjVDfgvdQLUeKUryyNk1P9tNy+3HsbkxGu7hJakHG
         4n6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424282; x=1770029082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YywhJHdQmzvLYqPf/VNWfmyvJv23Am2v8tnakAtmlS0=;
        b=fjNl0lQtAQFqk4GiFir0hksNF926fznYcDRTfe5gpreMCFLnNnvdyKGr2HlDNqBDMk
         K4/K1IoHMfkzR90UHZIuWD3rp63uxjhj32t0SbjWIOK8gfcxlF0fcaUBYBZE4OULdgRL
         FK6FXAlfpRjYYzKM5v/8CbyUKG3qdDEYoQurdoWgqItmLD5vjp6J2JeUkP5Avw0Kz/Fn
         /t0rjm9qyIrDH8fE5c5ap2EUmLpqXknvTIH0YNVeYFwNhN1ZKfN+IJTj23KRv61C3t2T
         jZXDhS7svylQ4P/9hBzxuinhSvgZJNALXfiYK+Pherv6q9SXtIpNUE9Eyp7J9nYDDgkP
         OXAQ==
X-Gm-Message-State: AOJu0YyX8oEZq5mD4Sp1Z4thmg8eBqd/v3nQRrGCj+Tafp8rnk1hREqm
	YGcgrwlXCpJPPrbS5yADDBHlFsyL9GXp1OJmzD8BgZSbZ31JedUxiuoQpkKsCn5uWUdcNbKM2hI
	OY4ED6WvqNvF/pRCEu/c8SQ==
X-Received: from wmkg7.prod.google.com ([2002:a7b:c4c7:0:b0:477:5a4b:d57f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5395:b0:47e:e20e:bb9c with SMTP id 5b1f17b1804b1-4805cd40991mr56788285e9.8.1769424282193;
 Mon, 26 Jan 2026 02:44:42 -0800 (PST)
Date: Mon, 26 Jan 2026 10:44:07 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-19-vdonnefort@google.com>
Subject: [PATCH v10 18/30] tracing: Check for undefined symbols in simple_ring_buffer
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
index 9e86c43bf320..9f675d5d27c7 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -131,4 +131,20 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
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
2.52.0.457.g6b5491de43-goog

