Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38D3EDACA
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073582; cv=none; b=q0BgmASicdVmc/tBOZV3KQYxhm/kW0hN4xUmW/DViGFkQdxStniN2eavpMgssp98BxOOq3d0El+r1lOQbqTsTNEpySPJIVj1x3wBtf0+lcgjUYBv+UeerJxnO6932JQ8QxUCfZiNrIdFu0/fqBLCNY5JIuNcHd5/8Qo5FJLCXmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073582; c=relaxed/simple;
	bh=nvJVMgivk0n7tnxwYIskJ85licES15A0ESfOQLBBACk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o/vQ9gh9elma3NPPi9Qn9VisHhjjDqcHsf0kECPRTjF7ujQIXV/pQFgoZ/I2L6mToxKREjWR2amne6CBjYkRHedSuP4xiSDBMbkq1WwLzcBP4bbr1N52c6g5WB+UnURWzPLHtZAwQBlriJ+/+c2+cXi9xi7/BOQZp4QtheTGyr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zeVK8PpL; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zeVK8PpL"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485390246c8so15441535e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073579; x=1773678379; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ISTtnZxQZml/VUbaQMgN/rAKYfhBuJPSGaUgT7FyeoU=;
        b=zeVK8PpL2A55pMe4tumI1lU+WUHliWB870V2ewSF+4jknBL90EpdbaHx4nGjeSvmIn
         8DQJfxWxFS6nHuBzql+dMFxe2PmxrpUdPO2B+JtAXPB6KwS5WO9uo1M5Gezq+y5Sp7qE
         H/LHjtWyE77gZLNeAdqtE8sXP75T73NXW9jpC2aQyvl+X0rc/UfXqNN5wLbt7hMnL9H9
         9QKdsjyHPdGkkKp0dW4T9sUwPF45T2KS3yiK+MNiwamqTww1yhRoAtEd2WvEnRBCQpk8
         Wdih4tE3FRzWxA2Jdr9TLUGMSpDUTg+we8KEZVWh4/BENzYhv5tLhPLiACki4HFXtl4e
         FVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073579; x=1773678379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISTtnZxQZml/VUbaQMgN/rAKYfhBuJPSGaUgT7FyeoU=;
        b=MoQDovXgV70FCiOETVo/WPHGo01h8TOJggVSbf+nOLHkQN6Fe0olLM7Dip0KKmIPKA
         FN5o4CXAYuFCBR488k7lZr8d3+wxvyVKrCf4WxmBJzmP8lKDV64onVfbEzAo0+0Z92Ht
         iycXMKFvCOIE99r7rxdmMhvadH5BtbvYLRnnQR4bar4j4XQCmYx/XXDjcEp1PkhDJAN5
         Z8H/q2/h9tLvGO1fEDqdrkVy8Gdj2nhPifTskT+Km7CcfC+xWjKEkkx1iTHNksfdcnhq
         kFQRc+63I6Tz7PJnK/nBlBMN4FvZdXSwHKxyilPqKOI23q4tJb0kubAizy0R6283/xgz
         mhcQ==
X-Gm-Message-State: AOJu0YxR1HW1xBZYRdQiBCSfXPIzSogaqMNBggl8grdM60QaMtT1Jeq+
	gkxY4EOMrv1zZ98eTxJSpyHGoVx/vX7nbd1ZZIfZmAioQwO2g/mVGoAP0XUMiHC+HppvUq/A+Fr
	6XQQrGeBTD+/Za96aoZHruw==
X-Received: from wmgb20.prod.google.com ([2002:a05:600c:1514:b0:485:2a9b:6c33])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b68:b0:485:3991:5d4 with SMTP id 5b1f17b1804b1-48539910730mr79369045e9.31.1773073579022;
 Mon, 09 Mar 2026 09:26:19 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:04 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-19-vdonnefort@google.com>
Subject: [PATCH v14 18/30] tracing: Check for undefined symbols in simple_ring_buffer
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
2.53.0.473.g4a7958ca14-goog

