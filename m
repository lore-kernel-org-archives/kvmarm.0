Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6E53CD8A2
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807786; cv=none; b=ZFn8KEpwyaqC8T6FDCWfNBYe+lRIZYR9GB5149Nbvh/FH+lpsPQJC5HDiDs8sUl1nls8phJLoK3ijkM1SaYbQ0FIfpmD+0hga4CBklUxThBUh3k5wyL/TESdj/xtlFxGIDT2JBg+Vl6phr1h78K+HGEAyqTr+bpwMJML1XkoCMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807786; c=relaxed/simple;
	bh=dn97yqhM5JULZE/7AhmPFYcp2Ky9Bl52SQiCDggGIbs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JLxBN42jBTHv0FI9BFjOAIxm5pGqA/xTfFiR9U0hZesQOYKkQNRUiPPHTTHuJ4Krjwyar34W4juXeoxdTWVpmZ9LWQi4UG5DMCfFEFVQq8K9X833nzQXd5mx9t1gBVyg1t432PmJi+3SBbFZ2BDzTYZ7kSvJZPRREn4zI928FXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2/eZiHMK; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2/eZiHMK"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439c5cce2deso4134147f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807783; x=1773412583; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QsVePr8Brwc4uqDNMxUsa63z10B8xk0sNAC+har7PuE=;
        b=2/eZiHMKZ44p8HGiT0y2U/liQsC16bs0bzJNa0tg9vTQnhs6PNnnf5Rl9auRrOgm4T
         LCQblZ9WPPheQyUsDdOsa0yTUEvWbUwHQNvFJOj7s6bI2wI8TmZZzwavvABN5QVtJjb/
         rNqWGq6Bq0z+3iwELPDnshFhy2k2Y9VcoO0yQOby9jI3X4F7s7DN2Ywx+pMbtWaQOIjF
         F7Wdtiv9rFyuaJFfmIFbTWOmZWzIjZwEuElUsjpDxP1isZHoo81ki3CJuL1/l/o+tPq3
         d/Se8sWdkg2wmxr0uJaWcLkGKTs398lV9aN9oSSjyOUrVlqc8wwQbh7eFA5e/PhxMSmB
         2RGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807783; x=1773412583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QsVePr8Brwc4uqDNMxUsa63z10B8xk0sNAC+har7PuE=;
        b=TTT90VM+yADDSfYvdYiV4cWbCkd/GkV6WOPwQ7sf8hn50UHXqXCFxgzHLYrRpBXqy7
         fmA2yTGgftErNVHmqpoA0aDhSUq9rAYxPtcCxXsPFYuS1mQ8EMcUn9ew/2X3nUU/rDnZ
         NoSiyzhN/uHR4fDgCYrSMpVXDH1vp0QQ2RpA/Dq2iL/AIc6NVwMMLSQhjNOpjVNL4Zee
         d7+TZMNlwmm6FImS0amwLkudhngjDxmyXBqOEan1w8mU6739OYw4Dqp8Z1TiYmtm0a1u
         4GxDgBynnzp5tLLSv8jfaJZqaF6a0zvPkfPeQBzT28r1w7fuDhRJI0iI4m+gn+LgJnNy
         T6Xg==
X-Gm-Message-State: AOJu0Yw3Zwm7EKxInYyQZ/zU3wjTCD8qED8v6hUey8IxH0Oc3dXcccs9
	njc8S6e8tgyU6ce3A/lUQoRMyi1R+Ka7/2nfXtW9zAjB/7ORg0o38/PRqRwnTxu2bvyrYnr72jC
	gTLxSaGTKKxGr476ICLSRoQ==
X-Received: from wrbfn19.prod.google.com ([2002:a05:6000:2893:b0:439:b5ff:8e88])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2681:b0:439:c38e:66cc with SMTP id ffacd0b85a97d-439da88ffdamr3828400f8f.46.1772807783068;
 Fri, 06 Mar 2026 06:36:23 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:34 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-31-vdonnefort@google.com>
Subject: [PATCH v13 30/32] tracing: selftests: Add hypervisor trace remote tests
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

