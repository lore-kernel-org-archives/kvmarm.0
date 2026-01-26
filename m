Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB99331A7B
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424284; cv=none; b=tremXxxERYoCgYDU4IjNKuYLB8jEASpB7M97kcqh36yF8uloy3HqPTbPb+J8hlwXPL+xX5mcq2qVS8MW3sfyS4zyuvyyPkXAhDZCkd/QgfVparGNNYHs//uV61XUIEVfU2ShqQo/GslCcD5id/lKxwRZeRVjcDgjDsYTad1mDPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424284; c=relaxed/simple;
	bh=EpZK/BzfjQaUyxEz514oZ/jLm3vGGjz0nMsmnHSNIkI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FFSJBz5jglFS6wVD40ADt0NMcCj3bduZ0Zrvig4FlH5rnLQDfGD93XBy6tkXbSnChq17qP63NGfFYnByuN3uphQY0oA3PrPVC4Bp7p4p/77kjafTxlHdcBrPYp0Jql54oTf7csSOUjuS/bJ3G0WpaEBW6qMXkzeIUOjfl7IeKUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wIoPBpCa; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wIoPBpCa"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47ee7346f8bso31737585e9.2
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424280; x=1770029080; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zUro18mbSKiw5/VA7IRp/lLCcUE0ruHzOjVvSoVnLbM=;
        b=wIoPBpCaEOXLis8ZQa15lxxd11wmFPl7azDcmPU9ZYT4kSxbgtoB/Zc1z5XzbgwTnD
         xOXiobRTrABPcbeRCArRU9+Oi/TLGBXfMABavmQuKtuJkqHujcmBksxYEuhUlojENp5e
         RsZyePrs3aIwPxrJfQYkufAhztUQybDWNexMJp2rtC4o8pZ2xjXGJoxA3Oz/68NI8YyT
         0jdOijirer6SOmr2Rq57jWC85TqEtE7WcQoL2mD/CL+lOLBFAnVCzxjRQzG1vg08ZMdy
         kXy1cK8rAJa4lb6btf2hweae3rHDYd8TJFEPoq/jt5Q5oR8Lv2QneHdB+aZ1rKMZ6wBq
         zzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424280; x=1770029080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zUro18mbSKiw5/VA7IRp/lLCcUE0ruHzOjVvSoVnLbM=;
        b=HDTG78PKu57Mrm+p50g+OZjsLomTaTa1fFA7cuyGe30MFVJg8tB8wQtOUOLKS/g4FN
         640mbNe2hp78Zpbg5ICwmxKv49gdYtlk5VL2gqM49wL60Ms/I8uApuMIQVd7TENQWDpg
         5habSO9UlQZuRq0oO/B7GjDy5L2BNjK1NxHMPJI29rqrHyyS0aV41jvuxpD9ppPsxWNn
         EnJrqf0qsk1xG6ul0sQRBwUH37zoS2vITDcM/CNdBYx/5rhWGXGyKVMSdev4bNHzK3Ui
         pMQ3gCdOAsHItlAbUaGmcrJVxoEH2nz/4pNj20un9chVq+/JaQn7N3kWk3X9706LfaDM
         3JMg==
X-Gm-Message-State: AOJu0Yxu9NQONXgMXI++nKouA9KlU0Rx6e/3d7aW6/0ZKj57nhdgv++N
	PfKoYVGnF3DlSNBv52JsxJCEqgdYQXPYOfcYRXhTFGi0oVCXnoRz73wc+Puz3YCoaw+EgqWX2Ia
	zBBAH06ueSP5k6wpXBJwnpQ==
X-Received: from wmom18.prod.google.com ([2002:a05:600c:4612:b0:480:4a03:7b80])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34c7:b0:477:a978:3a7b with SMTP id 5b1f17b1804b1-4805cf5ec2cmr63608005e9.22.1769424280511;
 Mon, 26 Jan 2026 02:44:40 -0800 (PST)
Date: Mon, 26 Jan 2026 10:44:05 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-17-vdonnefort@google.com>
Subject: [PATCH v10 16/30] Documentation: tracing: Add tracing remotes
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add documentation about the newly introduced tracing remotes framework.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index b4a429dc4f7a..d77ffb7e2d08 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -90,6 +90,17 @@ interactions.
    user_events
    uprobetracer
 
+Remote Tracing
+--------------
+
+This section covers the framework to read compatible ring-buffers, written by
+entities outside of the kernel (most likely firmware or hypervisor)
+
+.. toctree::
+   :maxdepth: 1
+
+   remotes
+
 Additional Resources
 --------------------
 
diff --git a/Documentation/trace/remotes.rst b/Documentation/trace/remotes.rst
new file mode 100644
index 000000000000..e7fb3ee96c30
--- /dev/null
+++ b/Documentation/trace/remotes.rst
@@ -0,0 +1,59 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============
+Tracing Remotes
+===============
+
+:Author: Vincent Donnefort <vdonnefort@google.com>
+
+Overview
+========
+A trace remote relies on ring-buffer remotes to read and control compatible
+tracing buffers, written by entity such as firmware or hypervisor.
+
+Once registered, a tracefs instance will appear for this remote in the Tracefs
+directory **remotes/**. This remote can be read and controlled using the same
+files as regular Tracefs instances such as **trace_pipe**, **tracing_on** or
+**trace**.
+
+Register a remote
+=================
+A remote must provide a set of callbacks `struct trace_remote_callbacks` whom
+description can be found below. Those callbacks allows Tracefs to enable and
+disable tracing and events, to load and unload a tracing buffer (a set of
+ring-buffers) and to swap a reader page with the head page, which enables
+consuming reading.
+
+.. kernel-doc:: include/linux/trace_remote.h
+
+Declare a remote event
+======================
+Macros are provided to ease the declaration of remote events, in a similar
+fashion to in-kernel events. A declaration must provide an ID, a description of
+the event arguments and how to print the event:
+
+.. code-block:: c
+
+	REMOTE_EVENT(foo, EVENT_FOO_ID,
+		RE_STRUCT(
+			re_field(u64, bar)
+		),
+		RE_PRINTK("bar=%lld", __entry->bar)
+	);
+
+Then those events must be declared in a C file with the following:
+
+.. code-block:: c
+
+	#define REMOTE_EVENT_INCLUDE_FILE foo_events.h
+	#include <trace/define_remote_events.h>
+
+This will provide a `struct remote_event remote_event_foo` that can be given to
+`trace_remote_register`.
+
+Simple ring-buffer
+==================
+A simple implementation for a ring-buffer writer can be found in
+kernel/trace/simple_ring_buffer.c.
+
+.. kernel-doc:: include/linux/simple_ring_buffer.h
-- 
2.52.0.457.g6b5491de43-goog

