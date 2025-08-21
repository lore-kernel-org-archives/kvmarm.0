Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42F52ECE89
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 08:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764082; cv=none; b=LpdfoRcczgnT9W6mo51su73WXmMosWP/HTpHymKInF85MVqpqVIl46eaosAtxE1n0PsPUaYany4IPEqJiEMQhZ3dvvIb5zZntzhvLnupCGVzHoNXil8rTyr0UmK/OybYqkqT95c5IhsvCKXyg2bZ1ntNlx4uKYAQ5LNHsUBX664=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764082; c=relaxed/simple;
	bh=QTf+X2xLBmpOy4zyRAuMjGmCvLxjicUtPQoHjzlz3nE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nx6x9VLQhYsLIWOXZSYrDGHSLZXxFAksfrc0GasfOBwsbE0T8Lz3geNkLHrHKuAXAUl8YEtlE4AGFzIspUXzsQ8p6U4LCnQIVCJmFaacKkEqWsChlnUuXjSzT3MxunBJF00keg+MyIpXZUbZDSCHqAneW8g6h94Kc0n1DyP8pVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0+EK1DI3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0+EK1DI3"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0cc989so4610465e9.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 01:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755764079; x=1756368879; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P1WnKbqGJMz5GKuhjASXO9eryfCuYBOVak1j8VKvvaQ=;
        b=0+EK1DI330RsuK0PvyeWvplTjISPOar+KPuKXc350V8hB13LZQCUjHCGWl/0Hcz6/v
         S7taZw3fmLft2HdKBT5Tg7RFhOjFY2NVN57Zr+c5kmKAk2rxcKRWtSSw7j6C22EsfqO8
         cMqFwPcZ2nLgLEvQmlCOv+O7rQLbzoKBYSndA0g8klXjXnMVYZdLdIgPE698Ox961JFS
         1Gj+Bmy2mWXVvp00sjRWrbLqcqwvicubBijiMO9PUIrKaoTutk7zVy0Ty84/TTpSV7wT
         UDWl6srvFcNXyRnVMXJORXvjGf/xF8V40EpuLAeW23gc+rKJxpcKS0t1Ube5Tx9t/6EO
         GQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755764079; x=1756368879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1WnKbqGJMz5GKuhjASXO9eryfCuYBOVak1j8VKvvaQ=;
        b=h7MBZjFZFJ4jCCLcGvvDXMCOi/LODoT2qkU2L+bHDw7y7hNhVAmqEAfKsQxHDwrAhy
         ji72f3IyHzEcLuWg1JkCEoGCJcbnQhL4vUsTfXCDyKBOc8L+5qIGKoBn0w4qZZzIeX7n
         0kGEUMlBK83yavCgQYuWUp+4CRbzZ8gZqur8Hzd5o7bv2Yu39kRhGetG0fKO3KsSolIj
         bsQFdDyuZ/EeG7jdZeBcDPr2PE6TWlvEv3WAVuedT9ASjt5x1nmA2fHd5FaI0eyfBC/o
         FpaOajnM/O51LU2n3wyHs5Z8BX/eF44wOdkmRg3Pvws5gmd8l/5NjNveL0PH+GKT0B5F
         8/Qg==
X-Gm-Message-State: AOJu0Yw42vUJXw8RY9lswwpwb9YL4koi+fuy1P/V4O/MtEjgAV00rXlV
	TqPmNL2BCWfgVCDkSlwT+NAn/21wtA8Emfyj/3+fxz5z6UfbVir8Q6qYzOzdxO18TJ4iAW71BUH
	P9j7yAx2J/rlcl/nElai0uA==
X-Google-Smtp-Source: AGHT+IGDwbMV0G2Q6eX5Ty92Ruu8G0gWgsOI3nyPGZY41v04cwU8/dEgbGIM8RR7KNaNp8Qt7tiVh+uNmLBvDtT9
X-Received: from wmbep22.prod.google.com ([2002:a05:600c:8416:b0:459:d776:c35d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e51:b0:459:d709:e5a1 with SMTP id 5b1f17b1804b1-45b4dc74ff9mr10294255e9.6.1755764079281;
 Thu, 21 Aug 2025 01:14:39 -0700 (PDT)
Date: Thu, 21 Aug 2025 09:14:02 +0100
In-Reply-To: <20250821081412.1008261-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821081412.1008261-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250821081412.1008261-15-vdonnefort@google.com>
Subject: [PATCH v6 14/24] tracing: Check for undefined symbols in simple_ring_buffer
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
2.51.0.rc2.233.g662b1ed5c5-goog

