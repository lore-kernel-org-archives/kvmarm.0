Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3331D367
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508360; cv=none; b=bEVWY1cIDt49IPghZLMnMJ7+bkKjwMOTQZUtN8AdeKgoIfHR7sufQP1a3REh1aAhzWYINOLYuRyLtXHMWrNjndTCRQ+vPyOQ7/atMDsioN1ezpMwkf7CyYvTI+zZeVFk6yYZsVJkWgvT5qzRURCaqjFEyX9rXTTzpGD/cUI5uwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508360; c=relaxed/simple;
	bh=FSHBZshxGqpNtFR2tBK6AAI7ONDbMwOQc+bxV8nB2pM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=akdvLkW85yd6RKSMf9d0H1CQ1NZvlPKyJuRhaUGT+rSkywwVQA+fXCJH5DT72YnFAwnjLxTLluPeZfFkP4sUWc5weCSHfivO4UiMBSnI9ZxxywPm1IPthnqHmdBSaz5vq8pTL3ZeW2aDXdN97S8Dnj+134ZTN9EzYZWm01Dcs8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qMGCyf6K; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qMGCyf6K"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477632c240bso5117665e9.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508354; x=1763113154; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XbzgYWavEDkucaAQHkJWm/yuhE4r5kJ12caCWyV8SCQ=;
        b=qMGCyf6KI+LlfYjX0ryQbuBjw3jabeC0GKy56whBkPW98XaiU5z/geCs9zIcyhr6YY
         v8nWcHaf9l2kATpMtWGjlk+nyObqv62Z1iDxyDfaXt++xi3w45EGwQJxMgcG1dV5JHmy
         dr7u2K3ffFDYlLew2yGaMtlKKt2ISeu1qikq7ObC/mrsO3dDppK6KlQ5vU7g2LE5L6Vf
         G8+ShlQ8XiASg1HVkeNIxUihscC+M1cbHcY9okZ+A+e7uUFGK8ZakthcqZ4e6R9F/Y1o
         9YmkjqarMiGoADGPlvBDdlDXLyieTPVVs+FdvNXHHAbDKjkmuyqLwgOb7qZ+WksZr8hh
         xuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508354; x=1763113154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XbzgYWavEDkucaAQHkJWm/yuhE4r5kJ12caCWyV8SCQ=;
        b=W0nFQCmgZCr1JXS3FlZSeIGYyu+Sh1Dw762ByzoC7JaG21bEn3Fx1Jxv3ELPVfTM75
         p9n6qQCk5WnaBtqYw7Ubg8Ljd6Us+fHdKhcdGj/E5abvsvHha+C9mU1LE+piMV4vSuV9
         dK5FTVClMcqAP4CyMGJm1D6fB48XpNuz6tE1+IGK31bfjg7QRx2iM2asw/Mt3GOKYHEc
         HuhhorJ8hRK6TzJ8RTdt1NJ1l1810AKY37k8X2rP02BBKyCgs64rWGUQRW/PV1SthB9H
         WUbwU+3aCnjydNY7B84F18ZLosip/YqU72amJCbBxxXUNsHTTvo8dl8hOXeCwEFUifrV
         KOCg==
X-Gm-Message-State: AOJu0YwxD4WdwyCTm+FAxrd2MmSaoMFoqSDlOdH22jU0W5Uaozhf1XTY
	621JNvM0Y0BedK+/Vc++sUJ4QQFKEV8KSwKEr9tER/Hfxi374r61TxVWxF8sVkAW+weyANFeYBG
	coPZUeXja4euG51s1FxOveA==
X-Google-Smtp-Source: AGHT+IF60dCQJ41NPrptxy3Gj7Wrk7uExuUAy3Aow0y9dEr8CGkC0R5jKhv9OaLVv5BJbKI98weG92o8nKAmsyEF
X-Received: from wmdb6-n1.prod.google.com ([2002:a05:600d:486:10b0:46e:37d6:c1a6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:468f:b0:46e:32a5:bd8d with SMTP id 5b1f17b1804b1-4776bc89facmr19293645e9.3.1762508354525;
 Fri, 07 Nov 2025 01:39:14 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:40 +0000
In-Reply-To: <20251107093840.3779150-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251107093840.3779150-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-29-vdonnefort@google.com>
Subject: [PATCH v8 28/28] tracing: selftests: Add pKVM trace remote tests
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
2.51.2.1041.gc1ab5b90ca-goog

