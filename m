Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A83A3B8924
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807774; cv=none; b=qSC4d2rM0SVADlADJILufvInFIU4LPkTV/ypkix4m/MO7KSGii1UA9D751+iN+GzYrkIKqj10Tk7NLc8s3qBAQWnbJI4o8qu4Qv84zMq2tm9tksK7cGd6caX4bumVccKrtZEd450mLlgMboG9LD7eYwHTu4si+76JcKONnxcgus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807774; c=relaxed/simple;
	bh=nvJVMgivk0n7tnxwYIskJ85licES15A0ESfOQLBBACk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ovrnf/OgVuunsMZoSpwqvA+/ohwDkE/5FQaP0Tws+eoOAuLv2Ysgt0ZTQ69VIWKVjYNaJK4Orup4Pu95HQAipCgTZxCW5XLxOtzq9bkc17hkoZ9szDlZYFDA9tMX5pbAOWPS9vHSk1taHKx7gXYyjhscPsGSofOZqMp1A4tKTrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ny4B7+Ic; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ny4B7+Ic"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48069a43217so97677455e9.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807770; x=1773412570; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ISTtnZxQZml/VUbaQMgN/rAKYfhBuJPSGaUgT7FyeoU=;
        b=Ny4B7+IccTiXQZ7zi1eFoovwO5kDnWPr/R8B8rROOBQgEkve/6E9wIwpepbBYnxb8v
         xdPWntpimVaYBvVrzUfxahNdArC6Xr17zMztAmTACliKjF0CCD7P9SKK+NSYZbN3ja/o
         qcNiNH0blBRV7c4M/XpmJayH3gbTyUio1+olMQXemZughFXZRC0q/m68hF8tfgztSO9r
         nuAW0YmFbhNpHNEmu4PNyROPaJ/0+ssVRc0DsfzZDVxUfl6juW+hDtYKvR8seqUtExfn
         8NojFdbPZej9QVecysQJBilfLr5qazakMZx39S9mbYNddpXmWVa6chJjkgQMzSnUOrif
         fmaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807770; x=1773412570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISTtnZxQZml/VUbaQMgN/rAKYfhBuJPSGaUgT7FyeoU=;
        b=BzmEbDMXFdezZ3ApbCcEUaeeu3K78WV4KckAZ9G/fSS17/HJJnnrTzTE9UGAJOdn8i
         UqefYJHtMYvyqlwuCQHs7DdGnAyyk01dJ2HXlC3j/8bX8p5rjl0jnP7TinbKQ9bCP3P5
         zBwCOybUFcBbYy8Se0Sb42mRkta8MOpYq0iBFCW+q1G5C2R8VxOX7JRXNGiKHX1iH4K1
         6gTJdcTkxMNTtKPS+63G/UicDyl/df8ETGQT/LI0fDWpNowwf7DooNtFgJo6vPpriUOE
         WWnK2SIowFBLkFV14Q59S17uszv0TDbBQBuT8fETS1Icb6wkF/aWFKtTFyOinMAQDJZX
         jYVA==
X-Gm-Message-State: AOJu0Yypdym5oGo0ZSxiZFgyfSvlmA56k/czEc+rrfjQcS99vmKsNKTa
	Gq92FfQPQvTv56XXu0BdWJt0SAl3dMfLdguDf3tfwzFr1ttfABZcdPdwhiz+YMM5vHdmUeEraQz
	prSMZtCwUjFuRueUYuGspxw==
X-Received: from wmbfl21.prod.google.com ([2002:a05:600c:b95:b0:483:6ff0:11a0])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e88:b0:483:1403:c47f with SMTP id 5b1f17b1804b1-485269182b5mr44060185e9.6.1772807770415;
 Fri, 06 Mar 2026 06:36:10 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:22 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-19-vdonnefort@google.com>
Subject: [PATCH v13 18/32] tracing: Check for undefined symbols in simple_ring_buffer
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

