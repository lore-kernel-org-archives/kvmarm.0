Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F78C360747
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866195; cv=none; b=kUKzk12cpBch6JcUqErUp/5o4R3rF3G8tf3yAmwfgQ1FxRYVgF14QLtJduDDiyCuLkfH1V97zqu/un9JYbz72SMdgy9W68Fg4tpsNICgGUa9GDRzu8I4y8iHeJRH1NP5KdtQG0YcrzJM3h0H4SVGlZJcFzr747zRqy4BTZJOgM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866195; c=relaxed/simple;
	bh=D32IWT1yvJNiCztIHYR2AGCCVHmxZFcptNwe3+a563g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dff1RZgMOB2Bz0UBpZeS5839ewEJPTnHsA00y85GEWsdY+aJZubJCijeGBngqQ2dfXR7KdeVw2bfqYw2ifMnH8G0dfpPrgid+4fZXmQ7P8kXY5o/DxxmJB0ETjVgiytHiCyDb0TTc/G/L5xJ/shb9/67Jibwo0lapU+bsDubwIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LMSKfaGV; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LMSKfaGV"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47ee432070aso23650815e9.1
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866190; x=1770470990; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x0jKC8f/iEFEqNg/0cUe99XmInCeV76uXOT4uvAYEUM=;
        b=LMSKfaGVIfC+SRm21QQwDYQBxJzBzVEmDMrgdZxzQhPlVJO46GWQRVtuW8jNEy5SlY
         E8BrK7dpC3SJT25kri0hraVvnwy5APZBozkikHh8JAvSowX9wQqZSdmOcENqAwb7FNSf
         FZFScrrX5Y+Dp4iunzVA2fu5MhHcwyh5Qc81iwtYcQC4gRXT6BfounzNIX+620yuGTDb
         I79zvNeYzR8bwcbQBX3UwG1fBTGqZnPOP5cj9GsYdgfuz261ijxFJscIg4Bj/u6m4YIY
         m5hkwN6LCChyoq1zkGCUlYWjYzAamj3vQmLPNjW44TQx0b0dnDmEZuwux76cFnMr8mwA
         XWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866190; x=1770470990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x0jKC8f/iEFEqNg/0cUe99XmInCeV76uXOT4uvAYEUM=;
        b=ThFNgcnfOp7k/+uNFI9fjVIb+KRjoG8PFzSLm5iEdl+utCCrj3FsTdRbNB7OBouKh0
         KjoIjr2JtMTL/wq2HKFbI4lPu9GAkRZn1VMsIdI0rUMjQ10jdUWPH5dmcANEWUaHAgvu
         cdHNuD9ngiqixiW4ncY/5K08gIF8zbcWtlTUsJpvCBt6SsZN7qwloFKTrf83QBNb2MSB
         Pa9VrxJltnUOqjRPU2vF6GaRRrzDEHyDPn0RXaWMePNVfzIYEVxNDFVLlKgVqCRmO+Qu
         A49VXF5nyC4tI/KBzs6ICCONdiuKpSfyi02CKaKKpky4DlqfYyCITdsqkz5vpfYTPBzm
         kZWQ==
X-Gm-Message-State: AOJu0Yw2IyZ/hunT4a3gnfhQ2Z9O1kvsUVC3hJ3gsf7p3AjLcMoDFiDk
	6nspISC3FZx9cVGMSCEqXZ6zPy5BPu3CbcYvZQiw0bQ6/yXgqoupfPB2GcSPDSuRAWjb/YMKMWb
	pwcOrzeL1aYiPIOuzbBnmdg==
X-Received: from wmk26.prod.google.com ([2002:a05:600c:29a:b0:480:4a03:7b5e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4443:b0:475:dd8d:2f52 with SMTP id 5b1f17b1804b1-482db4a317bmr74357055e9.32.1769866190616;
 Sat, 31 Jan 2026 05:29:50 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:48 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-31-vdonnefort@google.com>
Subject: [PATCH v11 30/30] tracing: selftests: Add hypervisor trace remote tests
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
2.53.0.rc1.225.gd81095ad13-goog

