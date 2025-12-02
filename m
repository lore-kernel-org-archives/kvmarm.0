Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938F5324B35
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668225; cv=none; b=PFyT41SuhaimNsTy87rIgQmqqpTWUvr3tyHKGPD9DwOT6ff0mKBD0mnGeEGgnsRNmaiSC7YTnNJdNvzA5byi+iybagu4KDj1pkEvng3aoHNOasYNGv/1Mn49N1GZb/zrAq7BcYQIJevq/IjdIBm7d87o3tssng83uMb0yuhuvP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668225; c=relaxed/simple;
	bh=eqUL/kWkYdof9hQMILS88EY8tqaEdynZnep63XC21Sg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JywgOqdUz28IE36/JawhIQ8q5jcSTwPY67pcp8XWRvb88sZuHgxDZ6vP/5Hn4TIhiyCz1q2LUVh/5xGVA76+LX0ImZ9XQbeBOmjTpw4yUBI1ibuuSwLXOhZ+DfmnuV11Y+rNzi27t1zEQB1yBYNYk+p1NlDo9MsTOTO2UWfuwHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jYUSosiC; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYUSosiC"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b72e06680d4so708259866b.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668221; x=1765273021; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+SzM9KLgL2lNiqGPyjU/uTvcU4SeOJpnexCrssRjDMk=;
        b=jYUSosiCHXKzOT14NEH3Z+c0AxoUvJ8C3+YrAd3QJLJtVeiRl+iuUBzN+EzoX3On3P
         7Ct4rxuO0BA3XE2dN2r6Ev4Fq+E+bvxO3ic1aIF003503ub7VVFi2zj9odjsEohvkSQo
         i7dM+SNwGYC7hWqsAUBPW2cSzCuNUxeAqgdX0piOv81wIk5TLSCIIOuJnlFbDWcBs573
         fKT6Y+oKduj8RKakm8BEoy4Aclxf/PuUeZGtfUyoCfOLZeuX99Tyiceh4jr9sF7pqxaG
         NTlcNnv0zDwgmn93BEhPBanI0iLmQZ4N3+CzKGfsxIjQpWUHezd/mFkSINJjWPlAyTgq
         UbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668221; x=1765273021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+SzM9KLgL2lNiqGPyjU/uTvcU4SeOJpnexCrssRjDMk=;
        b=ioVwvWR5bQ8x6ASN3W3Z6btZ6ZwMpHsQG8ER20Yuog/Wyo7O68C+3rntgSFZUNYmjm
         mplVC/8vO+EfGQpyoqCTfuYRmwCNRPGsE0UF6TE9FgpPmWqxHWhDkIOWw6y0NsrOAJJ+
         SmJumUy/ZnjI/UpE6m04nNBuz9yfhIDZQ+hddraHc8HV91xkmJxX5K01243PYQUSY0wB
         P4tkLuCpJDTIE5/d/Uh96cySvH7JQIMMa1w4w9YCwdCVtpWbbI2rScx8ALOtib1rnZMr
         0I/WYAEgsN1u3b+dDWLmkDsBdihNXLCQ3p+tLgdPmANV18gx8YWeYSvxWJuyshsUaN/Q
         /mzw==
X-Gm-Message-State: AOJu0YyP+ou2ANF/uCeWJTV4bvOQWPEvvYFVLAYQc8UXpdzebMut/4Ip
	s3mRLFtjxjS9A++Kt3MTBMSn84nzbMfYNTzyAOVTz3ffLeH2EwreD23KSIF7L7SxgKTcDDC4QPj
	X55iGIPTh4K6wW8O+Z5sScQ==
X-Google-Smtp-Source: AGHT+IHvb3xnp0JFd6fDTPTjFHfgzvMoOO5D/uqUHZuJommh44ByPSgz4fUGk8BxStO8hqDOnZDIAusho37QJVIV
X-Received: from ejcst12.prod.google.com ([2002:a17:907:c08c:b0:b73:3b4b:d5ce])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6eaa:b0:b71:854:4e49 with SMTP id a640c23a62f3a-b767189cf54mr4813189466b.56.1764668220623;
 Tue, 02 Dec 2025 01:37:00 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:23 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-31-vdonnefort@google.com>
Subject: [PATCH v9 30/30] tracing: selftests: Add hypervisor trace remote tests
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
2.52.0.107.ga0afd4fd5b-goog

