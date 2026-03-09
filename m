Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7943E9F75
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073595; cv=none; b=agEqdjWnacAER/8wgD/IMNaTeAq9qrk4yikk7YEqwDIea+gWm7JsanMGkgGTK/N8PUytT4wqZWqrTzV1uxOL9qrFASmJTskYnPjkDN/eLsjh779E8MKCahFHUlb90TuA69yYUJzFApnm6gz9ZGC2OtbICQQNJ90vTKCEFEdtqf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073595; c=relaxed/simple;
	bh=dn97yqhM5JULZE/7AhmPFYcp2Ky9Bl52SQiCDggGIbs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nfqs6JB8RiHzDPwyv3CudPbSUFKUcL3B0qfO4t2wvQbaLzxJvc8HfCi+jGhoGGvvl/5TcmeGq5YMT9CZ9JRZhF+N60aLU7usrDOD6az7AubqG5mCmeESpliNhKml0gxQwXnd8CYnMbB5xiZUbru0Ltjv7yJ/VO/QWImOO/v/qJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qI+6X/p0; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qI+6X/p0"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853efceaddso6562055e9.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073591; x=1773678391; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QsVePr8Brwc4uqDNMxUsa63z10B8xk0sNAC+har7PuE=;
        b=qI+6X/p0nBBAIOUwkDtfPYfxKS/AjrmsAru5Vb6ZuWiE5ukbqzeO2VftQeaQ5n0R+S
         YmmD4Lp3JkuOaa1pIl7ymHPOLDb8P5+uR6x7tJX/eADZ0mDnavtxNbz7i/7uBy+efoGm
         g0EECFFxYQASJcnFFk5+usxMHDyycPaPXLcF9IfQSMq0yQoGis2cfX3fe/ryV7wfTr6m
         PCwpeeJXMnvU1nijv1aZXIi2jDisKxwwvcAa8gCaU3eK2lWksgkYKj2mPKqMNmP1c4bQ
         z1OhZBD+5MtYcvw8vzXFVGxZWPtZ/i6oFh5dbje1as1VCoNOJQmqbqxFjN1gRKEWC4Sc
         yHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073591; x=1773678391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QsVePr8Brwc4uqDNMxUsa63z10B8xk0sNAC+har7PuE=;
        b=GQx2fQehy6M0V+JA6+9aEES1oIoU1BdfdJJvofYJSYz+jWcuHP5QDDm3isMR36vEyG
         Y/Ql3CqKmdNUjA6g/zsuq4NS+qwnRrt0uqE8SrppNu9d2JGuosMGQOo/LZ5HgUHDUWJE
         pswrNmd+8HChPO7rwi1e++/UYgpMdJ2/U9OXii8efe/9x9KQRfLQ1JjN41tV2Vu4oJqk
         IfgbZMLiJYJhmW+mg9PA1gY7E1/MACKode3Vrm0l1c5K6FiVcMan7RCEVraQrYJOm+Ek
         jRWmUOzoegunUWUuid0aF49RxulxprRaP+cpKDfKrZiCQBYNphmyHDKT+qcHOXNoo+Po
         85YA==
X-Gm-Message-State: AOJu0YweFfpzcJU0wn5ea10yVMplJFsv15UFpPr2UHyMsB5mBfJx7iiu
	JoeISL6olMru0hzY4AaL59yuA76c/co5eTSZUhdfCOwCBldaRd3Ep2TaSNf3x8ed9AzZSwa6S1v
	kWBKEQ3LW0h0eA3tRxyS7ig==
X-Received: from wmfq22.prod.google.com ([2002:a05:600c:2e56:b0:485:318b:96c6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b13:b0:47f:f952:d207 with SMTP id 5b1f17b1804b1-48526969359mr225784865e9.19.1773073591541;
 Mon, 09 Mar 2026 09:26:31 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:16 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-31-vdonnefort@google.com>
Subject: [PATCH v14 30/30] tracing: selftests: Add hypervisor trace remote tests
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
2.53.0.473.g4a7958ca14-goog

