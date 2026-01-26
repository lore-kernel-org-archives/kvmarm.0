Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670FF335077
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424297; cv=none; b=TFsik22Zl1tkWGsI5xe1m/M7gLHsLMF8kFU7VYguTqMFw7DqXL54d6kl/fYU1RCofjMyD/aM/3KVOn1G9lwiKfgUn1Tq+jqZMqEo/Ogj1TLEptNocdJs7JnBW/HhlLru00VKIPrrAlz9SAetSNA04ZHMjup9T0mixts3M/Lw000=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424297; c=relaxed/simple;
	bh=rQU0pqdKqe8avW/ctXbf7hWIvHSRj7RwdreDLZd/I2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MH/sykXCJHvD6AAhA7Qrs1ra8bQEed48YlfW4MZV5rTCLvGenqxd5VoYRbRTVdvhGioudACgK3ZNjSIDyX2Xa13Jd3M49huHWE6kLUHVbEAPY3lBJlK52YTRLOvAlGMD5z2uAzypYkdJML5lCZLLS/KZDznqrnLdq+TLjZ9T+ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1VYM16OG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1VYM16OG"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-480600391e2so7887525e9.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424293; x=1770029093; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rcuxT0tCf/T7ct2VsPnptK2x4TV5cU08DiX9A8D84RY=;
        b=1VYM16OGDdJHQpU7IJr9rDNk4bP+6e5KiTaoaOwptp1TSAO71uVp3brtVNgmaS46IC
         fJRvFqQlvrCIIM1wIrW8Y4Cz0EC5G1vE0Kgy5g3cs0tprM+DkY/EbGz1S4/0iq4LU3+n
         Me7Mx5Y9eGoqxCG57chpdGr3rz13XPvS6K/60w2WJ3La6/t5i/yZN/7bqe1d736W+cmP
         YT/5PyaYyf7qeeTwYXv6i8Q6m2X0DevkbP8FxloSlaW7B+WTT0K2ojIL9n22ffyIUzR2
         tYUw7xEt6fRYRQSmft3i4/Z4XXQn+Dxdxg+OPBWHYDwcnpTal38NkP3ApfWjMvTD/4U9
         doew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424293; x=1770029093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rcuxT0tCf/T7ct2VsPnptK2x4TV5cU08DiX9A8D84RY=;
        b=kF3puxldbQO3uM0SzmAkOlu84n7Po6H+8oxByxSdOtGl7M1qH8FPPNyFsv6cP68BJ4
         dkH4TvSStz8NO/a+1MMKuu4g9ejHYcN2Pc/ox78KJqPUCTRxkq+5kH8NsulwBCSnowI5
         E3H9jXjTF6kTyFfjr0xUTMe5I1xUrBIYJ+qwcoh/4waR6BdASETIPgXPH2rLeNAdbjsW
         eEOx31VsTgsa4DrSlWxDzSHQ5T87a79F0ryMYkKczVkx/PhQFuEhGT/q2iOL/P7mxuFO
         0WUR9JAQkigQbOmCwQTnScLM12lO9aZpIIifIbNzuH7jjz5Qgv6quYvZTXY0z6MLORbC
         L72w==
X-Gm-Message-State: AOJu0YwvckwMA4YSG7fAryKdDIebALPPXa1yTEQNAjGjw0ZiEnQ0nt0N
	1t1O+0vX6ZQlGjsJD+b9CPFRiE138R7oZ3Bx2IbkJlmj81b+m7vOjYofRq93OFclYl9yeRu6Q0G
	jMuwPOW6MEDY7VVakYH/Uww==
X-Received: from wmbdn2.prod.google.com ([2002:a05:600c:6542:b0:477:9b3e:67e3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3ba0:b0:47d:5d27:2a7f with SMTP id 5b1f17b1804b1-4805d064554mr67628505e9.26.1769424293569;
 Mon, 26 Jan 2026 02:44:53 -0800 (PST)
Date: Mon, 26 Jan 2026 10:44:19 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-31-vdonnefort@google.com>
Subject: [PATCH v10 30/30] tracing: selftests: Add hypervisor trace remote tests
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Run the trace remote selftests with the trace remote 'hypervisor', This
trace remote is most likely created when the arm64 KVM nVHE/pKVM
hypervisor is in use.

Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/buffer_size.tc b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/buffer_size.tc
new file mode 100644
index 000000000000..64bf859d6406
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/buffer_size.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test hypervisor trace buffer size
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/buffer_size.tc
+
+set -e
+setup_remote "hypervisor"
+test_buffer_size
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/reset.tc b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/reset.tc
new file mode 100644
index 000000000000..7fe3b09b34e3
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/reset.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test hypervisor trace buffer reset
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/reset.tc
+
+set -e
+setup_remote "hypervisor"
+test_reset
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/trace.tc b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/trace.tc
new file mode 100644
index 000000000000..b937c19ca7f9
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/trace.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test hypervisor non-consuming trace read
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/trace.tc
+
+set -e
+setup_remote "hypervisor"
+test_trace
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/trace_pipe.tc b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/trace_pipe.tc
new file mode 100644
index 000000000000..66aa1b76c147
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/trace_pipe.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test hypervisor consuming trace read
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/trace_pipe.tc
+
+set -e
+setup_remote "hypervisor"
+test_trace_pipe
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/unloading.tc b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/unloading.tc
new file mode 100644
index 000000000000..1dafde3414ab
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/hypervisor/unloading.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test hypervisor trace buffer unloading
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/unloading.tc
+
+set -e
+setup_remote "hypervisor"
+test_unloading
-- 
2.52.0.457.g6b5491de43-goog

