Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F7F200B9F
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402884; cv=none; b=Th10ZfIonbocjkRS5njYJ4pmrfXLeQri4ETiyz/v83upoPewMia4aI735+73gCuo94wgaGgUs6pm+bdf6/gSr/KFdPgciRaCeF6I1+qnXRIa2mAhawxIp3WuhYQ8fb9gpLb7Icc61WmCEQ9slKCZZD5X23es9/J7licQfQ/uW9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402884; c=relaxed/simple;
	bh=uJWI89wvuu58ssW9qPj7mRyoSGLNQzk4PZd/GC7Hv54=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rmWM4gE7A/h7QkeVnxBF89Be3irtWuHc+FzDJhrZdRhwgSlBp47NePX13nZtRFOV7fTZ2S3jnhF5yg8VclSWJy9t3G/snbCkBouq9DGIsCUE8zpllS2CE51NPyK6WW3zaaxjBQNtlM+yY8e7VjgASVenWUEaMABl24w+Ujaqcok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XjOPRukn; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XjOPRukn"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a1c86b62a8so1448563f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 06:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402880; x=1748007680; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P7GVxU0/r+w5zLWT8gZSbiy4WliZZRj39MPigOv2RvQ=;
        b=XjOPRuknE1y4TLz6tpJyXfSw0Y9+TP7jlVOUM5i3i2AdSjP1DpogzUwCy1502DxkLA
         ZxNY1zpYvSxGhIhrXh7ZYHadpWd5kB7+snKsuP0Wdn/UjiCFka3TEVPXq8232X2EifNm
         Ds5FyeJBx+R4xUes3cGJAxMZ7BXiIm/TqU/JsXTRQizxGvNjF2FpUo4JLe0G9Q7FCMw/
         IsAZbQW+RETcHqnneEYCXu0ri7MaKE2fs9BvzxITbSpXp2CH0JBo5OX3ikvqTKNftgsz
         Xjk+fP2d2LmHr9Xp1NbHUzj93XUWbXnnr7UXiMfnT1eVW6anYKFUInm3+Cke2PH9H17Y
         5nbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402880; x=1748007680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7GVxU0/r+w5zLWT8gZSbiy4WliZZRj39MPigOv2RvQ=;
        b=AHHevpCMaVYC9BIIBOq47pdsD0RBS7V39MWtWezgZC/TiIrU7gP4+hmJAYS9ShprlU
         mAouVXAHKENjSUTncu7Plk/jX7/gtj5MB66onkUriiXpwUIIDhoFupbi2g1saeAV1vcx
         ocJiR8K55k2VABtM8036a/ZRb/H4EBdTEQN4aQnTQzhnAYDFyVOqnWyVGz8EtDepP/PD
         C5OZsTALfi+KphYeelve0vZIZkymYvvmgFOH0BebsVnfwFAfArjJnwzdONypGCdqah2+
         91kSbfaZKJJd9j6eb4SBvHCcn/btwrYEmyl24ePX3BdmzKdnpM1epWU34v0Clgc8ubF6
         Q7PA==
X-Gm-Message-State: AOJu0YxYRsHJbjr8KazsN6zFp63vkT4M9jjXr+ZgFaxie9D6W3p9xXCi
	v8OPCBN2AQLRXmE887NBYtlsPKOBEmH36kZo6WZsYyXIIyTjVRRsE1l9jbtUWd9Za8iupIRog8O
	oDj4ITGsR+opnzYY+Tp//Bw==
X-Google-Smtp-Source: AGHT+IF5jgzJGfaBS/UHJ3X8WaZX+60Zli0llPdcw+b0LDQXYJrpjyQFz+/w5KLRHR1Rt2m4D1p45WOPNgP2H7ul
X-Received: from wmbhg17.prod.google.com ([2002:a05:600c:5391:b0:43d:58c9:bb51])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2289:b0:3a0:bcb1:fc02 with SMTP id ffacd0b85a97d-3a35c84ae4dmr3449099f8f.54.1747402880322;
 Fri, 16 May 2025 06:41:20 -0700 (PDT)
Date: Fri, 16 May 2025 14:40:31 +0100
In-Reply-To: <20250516134031.661124-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250516134031.661124-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250516134031.661124-26-vdonnefort@google.com>
Subject: [PATCH v5 25/25] tracing: selftests: Add pKVM trace remote tests
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Run the trace remote selftests with the pKVM trace remote "hypervisor".

Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/buffer_size.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/buffer_size.tc
new file mode 100644
index 000000000000..383ef7a84274
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/buffer_size.tc
@@ -0,0 +1,10 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor tracing buffer size
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/buffer_size.tc
+
+set -e
+setup_remote "hypervisor"
+test_buffer_size
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/reset.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/reset.tc
new file mode 100644
index 000000000000..679e31257d0b
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/reset.tc
@@ -0,0 +1,10 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor tracing reset
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/reset.tc
+
+set -e
+setup_remote "hypervisor"
+test_reset
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace_pipe.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace_pipe.tc
new file mode 100644
index 000000000000..4c77431e884f
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace_pipe.tc
@@ -0,0 +1,10 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor tracing pipe
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/trace_pipe.tc
+
+set -e
+setup_remote "hypervisor"
+test_trace_pipe
diff --git a/tools/testing/selftests/ftrace/test.d/remotes/pkvm/unloading.tc b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/unloading.tc
new file mode 100644
index 000000000000..059c7ad1c008
--- /dev/null
+++ b/tools/testing/selftests/ftrace/test.d/remotes/pkvm/unloading.tc
@@ -0,0 +1,10 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# description: Test pkvm hypervisor tracing buffer unloading
+
+SOURCE_REMOTE_TEST=1
+. $TEST_DIR/remotes/unloading.tc
+
+set -e
+setup_remote "hypervisor"
+test_unloading
-- 
2.49.0.1101.gccaa498523-goog

