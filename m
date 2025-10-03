Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740192F0C5E
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498768; cv=none; b=NbxcFEmPp7sQQh3f1woYdVGiJMNY/inwUr3AQ1QUBg8YXzhlWeDfkRH7225kbNEl1wGtzRp+ehi9Sf4XNSotYEvxNn22RF9WntUzg7rzrBXGtgtabpU6OTmPyZ7CgOvCq2eXgzbalEwrtH30+RTg2IliguG8Mqh7quJhPXDnNkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498768; c=relaxed/simple;
	bh=EhJlCtUGcSeWQktaiM83P9YNtXVSdRR4pDoNVCpu5bk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DPnP6ny7XNMYWWDvPnnBUubQOo3fmZOUdhaLiYgMrM8x08r5EkMEvFZ7VSo1RFGqMuOy4WKmVK83XJIRqSoD2zG5wg97+oh2W0jgEuospJU3ZuMpjWZ9PZwiS4b8P81ISbHh2L7rF6rs8XdY1gDBZDiECBDf6vhFD+6BIrQwPzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EtLATf0M; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EtLATf0M"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e41c32209so9806675e9.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498763; x=1760103563; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9UM3bjOGfRXsiIqNoVQZ3XTLMtvfmMCHhcAES2xrn08=;
        b=EtLATf0MIGaqk6BxNWO2a8UVdtdfkU29xhVXSZ4RIHl9cv6aGEqACksvQQXeaEA8I6
         XJWHPX25gFn/4vc5kS2c03Ijjeag2eDpInBwNK2XnROJTWOl7Cgyb55f/itMm+5P3Cud
         hgN/rJW7B9cSuVC68DYwC3zl/3HwS1GSlYNH7o5u3p9Yy1DocENmkrXp2Xc8b+aQBO3j
         KwCMO+e+yo3RrvA3xOuu9GjFMvtx/iDNSgmuQK51uArANiJrp7/0z2Noa2g8uYGTH7rW
         CHix6eYCpMnTSP4ZBzvBMC7WW5eBuC8mwI18U9z+3R9xfUrAEUesGYfE3WRRlR1/9/CB
         VpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498763; x=1760103563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9UM3bjOGfRXsiIqNoVQZ3XTLMtvfmMCHhcAES2xrn08=;
        b=D31HD81Rx829dlFfUGqcyab7MQwGltFnr50jJqTwF7Wd0eDVb5T49q5JO5Vrl5jt8o
         IXAohaj3rJPjQgtBieVAdWpvmRM0Efiu1qc2yH44mZczIKEt+OFONmhHDdZKf+eA0GEW
         f8xVd6jDRWXYtlPOO9FdJlg4AedA6JVz8/57ZTq7zRtYeNfcQljYHKOdDICpN8Vn119i
         4hMf2IFDTNkBQstSjtYjbFYfgqHPfyEIycyJdKMkGsgdpAvIoKmUbQDj2p2ebkIFK5vL
         kVHAFr72KBggklCjNsV6A/qQN9ufHZ0D3QcD86/vs9xKag0WZQ2ZyvTCpwV8EIYPtetf
         LiTw==
X-Gm-Message-State: AOJu0YzvN9XVNh+I+zIB5gAF4x2pOLU1cCr7freFnzXR6DQC47epd6Ed
	Hsb/lgRcw26C9otWEFKssuIGLqnsnlS19BwPJGl/IHY73Y9QU0HquJnyhRO0GQfrviz7K/RSSAE
	TyO7SacVVAleVMSjtwRuibw==
X-Google-Smtp-Source: AGHT+IH69tFTi6ZXKv+400BRPyLOvUgxD9vIa5eZfePSc6PtEn5y2PQMqER0DyOBvI5qOTvfVEhXP1sn9nPiGRc7
X-Received: from wmco6.prod.google.com ([2002:a05:600c:a306:b0:45d:cfa4:ce0d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4447:b0:46e:3dad:31ea with SMTP id 5b1f17b1804b1-46e7113ceddmr26045525e9.17.1759498763415;
 Fri, 03 Oct 2025 06:39:23 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:25 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-29-vdonnefort@google.com>
Subject: [PATCH v7 28/28] tracing: selftests: Add pKVM trace remote tests
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

Run the trace remote selftests with the pKVM trace remote "hypervisor".

Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/buffer_size.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/buffer_size.tc
new file mode 100644
index 000000000000..2de07e4d72fe
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/buffer_size.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor trace buffer size
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/buffer_size.tc
+
+set -e
+setup_remote "hypervisor"
+test_buffer_size
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/reset.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/reset.tc
new file mode 100644
index 000000000000..48afc51627e8
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/reset.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor trace buffer reset
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/reset.tc
+
+set -e
+setup_remote "hypervisor"
+test_reset
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace.tc
index 49dca7c3861a..00aed1c2e650 100644
--- a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace.tc
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace.tc
@@ -1,9 +1,10 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
-# description: Test pkvm hypervisor tracing pipe
+# description: Test pkvm hypervisor non-consuming trace read
+# requires: remotes/hypervisor/write_event
 
 SOURCE_REMOTE_TEST=1
-. $TEST_DIR/remotes/trace_pipe.tc
+. $TEST_DIR/remotes/trace.tc
 
 set -e
 setup_remote "hypervisor"
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace_pipe.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace_pipe.tc
new file mode 100644
index 000000000000..b63339aca380
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace_pipe.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor consuming trace read
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/trace_pipe.tc
+
+set -e
+setup_remote "hypervisor"
+test_trace_pipe
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/unloading.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/unloading.tc
new file mode 100644
index 000000000000..eb1640a927cc
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/unloading.tc
@@ -0,0 +1,11 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor trace buffer unloading
+# requires: remotes/hypervisor/write_event
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/unloading.tc
+
+set -e
+setup_remote "hypervisor"
+test_unloading
-- 
2.51.0.618.g983fd99d29-goog

