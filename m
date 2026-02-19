Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B0034D384
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513443; cv=none; b=RVvDXw0xtLxvYCxP2Sgw45gTJf0kdP/OxsgrPspVm0NN6b2PuqLcjlw82qvy24HN0FjA8cu7RkIUQBQ8ga+1R3W37iOkHBOmpPh3/KvsDeicuteH8imZOeTEH7xqovcLkA1QD9BtFyrr2BAgO2z5yThIpiYGo9qTEehtvR0VZog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513443; c=relaxed/simple;
	bh=nC5Ozd5peuX3ykhnKdo5Pz3W6ePP4RFYtKgnnVuRb/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=flFNzEW/8XhHV/oK4a70F3c7QazSHXAR5Ws/FHFxZnw6fh1T9O/S8AKx1u86Lj1rCHQIYVB7npRenNWe5fS2AGXDqThndNWZTk8sp6ARmJkkSVTYrLOMBcODZiJ/QAaBXNvfQ0tmsScm1tb8RPSpQ+Abz4vOhb7jqGe3XIOJWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wnuLDvnf; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wnuLDvnf"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836fbfa35cso6491035e9.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513440; x=1772118240; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B8HAfsDbzjcEm8omLFyotBep6HDlIYV4sfcPciyFXCw=;
        b=wnuLDvnfGjD6FwB2SzmiGO+JvFQbuFnKrAL4IShJo7d6RSUnPaZHFY/U6yu7ST+6ff
         ys+1MZQWrv7dukWvgymO04DeCp18zBBghsfNjIoAwF1YQXXJSRK0BFIwiTaLaXgfgOi+
         gmo0KyTEGPPm3oEZ50dTxtVVsG2vOVQEVCw519XWRQ3g+a5PwgJAY9yghFRXVn/tV0v1
         f2tDlL1/ao0uq2x33bxklW0+dbavp2qPtHIEDuD309luzr9Nz3aScOGQNnKqZfhGiZK5
         wPeawFylJmCFBinJ7Lg3oxJzwpfc6mORMJzBGaEGX52pvIZmdfqTZqrwQFST70CQLR8N
         g6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513440; x=1772118240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B8HAfsDbzjcEm8omLFyotBep6HDlIYV4sfcPciyFXCw=;
        b=OuxkwZ4fznkwcTE6BZj4hFi0Rd0wdra6bwY9GiCR3l/+hFNcNRigs7RtdjaLJghGRn
         KEfEu7fdOsuJ6Mflc9wa6W+d9BVtUUKy1zSGyOqmFynBUe8EYyFN93yTPb/Wb6XqEABp
         Aly6yP5CdV09gV8yfVSRwlDv8vlk1zKePUKOawwS8kRKJIuwfI4f4GlkTXBxvXXn5CqC
         TX0PkNa9Owllibef3PxdOqVhQmqagSHxvKNjeoxmrTIlOTh/xXKynnzN3T/SClcgC7hx
         Q8GOTsaih7269YKQfj959b1q0rypkVfHUMiVEbDSWgDYHEdnXRyqaRJF/nWANwAYNkr6
         8OQA==
X-Gm-Message-State: AOJu0YxW9qzPpq7i6phg/m9WPpyGlpPC4TNrWq85FSFQHq5/3SXWYj+q
	MHa8kc4wj2A5uOANnlsFS4AK6fzagpcXyzFq+en1Bvcz/d1MGgdPUIRiSU/rO/wtchoKPq3o+3a
	egSyLdBPeFk2JmrhS2jCdAA==
X-Received: from wmjq15.prod.google.com ([2002:a7b:ce8f:0:b0:480:4a03:7b63])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3485:b0:47e:e9c9:23bc with SMTP id 5b1f17b1804b1-4839e669135mr40605035e9.30.1771513439603;
 Thu, 19 Feb 2026 07:03:59 -0800 (PST)
Date: Thu, 19 Feb 2026 15:03:07 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-31-vdonnefort@google.com>
Subject: [PATCH v12 30/30] tracing: selftests: Add hypervisor trace remote tests
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
2.53.0.335.g19a08e0c02-goog

