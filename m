Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50D8358D08
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866182; cv=none; b=kO/MQkS42/ECO839YXLAoNwoTxPp4KGCv3k+QCutxON3nMaWXACWotidxaqcXT1XJ0BQv49BsfFuQN/JnDLkhpNXZSS9JMYAludfOp2Xv2HBdiBCvD4Qck1+afqDc4/qpSp4u392sewP4UoBNL4d2VZil/5OjwOrZ9ck1epvSUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866182; c=relaxed/simple;
	bh=GbGuivigEnOxXZ6AzKbFEuI6H/bL1pwWbx0et86tPxQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pLmlBZ2qMgeFMVZap+iSErfHRZsEQ0u+nd8Pf+jiUxWDDRzyxs2bojkwImqphDOwsnIlKg6n/5RRnyqmNgY9m4IESgWrai0ND4do/yi2lzy4QuQEVjg7UnNqQLTF4yIBsndMMKW9ajKx6lyA9eN5dj7G1VFoPq8zThpSJPfmGTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pj83Ysyo; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pj83Ysyo"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4802bb29400so37327145e9.0
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866178; x=1770470978; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TvedzD7+kJrfpkXnSgvR+lwDnj1DXH1BG+s75ebhGeM=;
        b=Pj83YsyoO5Vq00nHyLOPnocTeobVnQiRlzIDkwHL7aU5jhYFBhmXvy0cm0IxaGMJF0
         4oeXlc48kSUivVt9KpWXJwpjEovF0dODZDV4K+ceUX3UY6a8vox9mA5mMxF7HbUOQRJt
         3+aoHr0MV6zz4IYgKvN3q1AzenBb1OdDgTqrM2Mw5Lus7HUhrTPsvE8lsaBjxaQAwQV9
         OIF+5josI9GiF0YTYLcfgwD5HzR7njbfpxI7a/N+jXacqacAuBl06z7PqBlkJsnkGElO
         OHkQoAbqeWId75/hCNK1icT8sGxNsZrVdC+Hryf1V4JrVRRIF1dZNT9nR4LrwaJtXlhv
         hwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866178; x=1770470978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvedzD7+kJrfpkXnSgvR+lwDnj1DXH1BG+s75ebhGeM=;
        b=XaNeoJR6eg3fYhw+rXouA5W3pWZgroHDFvHbHfa0eZ/IGqxEUp76/AEthQz5sW/qbj
         8LDeKvkROQIfSVDK3Aj4wHLfUootRnqKx+VOQXZIjhNUqoqMUp/zEMAtY5Gdm3QERuis
         CJxu1CYsfSa6fbnyrC012jO9vu72LbTsNxVquOI13YY6dnLoD2CouADBG8Zjc3/PhYXt
         SQqIg5H5uw62afUMD/wBVsImdxwkRF802T7c1h/k/70IYT9Pl3UNmFzkCOqCMWzEkWv6
         Yv+xhwAGKzkP+hLSl+jP9WA+xfILEIxvyYuNI4QWmIzjbczW5plJfftsdy96Kb1AaANm
         hjkw==
X-Gm-Message-State: AOJu0YwklTil7CbHFwmWzMo56dyJMIcUPW2TybHY4DlwR2d1LrdEgDP0
	ErDAf4R5YdsBaTFBis3VYz7Hw3EoCtEj/5DQHLf/9D+ztlbgIubi6j71Z7qRBVTKhAql7ci+6xU
	zbIn4aM7ZU5mxp5TtE/Eg3w==
X-Received: from wmpc35.prod.google.com ([2002:a05:600c:4a23:b0:47e:dc0c:276f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8289:b0:480:32da:f338 with SMTP id 5b1f17b1804b1-482db45cb90mr66590785e9.14.1769866178166;
 Sat, 31 Jan 2026 05:29:38 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:36 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-19-vdonnefort@google.com>
Subject: [PATCH v11 18/30] tracing: Check for undefined symbols in simple_ring_buffer
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
2.53.0.rc1.225.gd81095ad13-goog

