Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7543ED128
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073581; cv=none; b=p1mMV9ytC2ILPkDN4PXseWhLl4GNeA6ndiDf3n4eunb16cMfEgBhSv7fpxrV0qEFvZcOhSFdFIQlu9meFFRqrh0ECPjc0WLPNRkADd0XTQPxUAu8+KTCbqJY74AEoQQdffpLTjKToyEZbw+2sYVDXTDMaJImzndK5qHdF4TOuHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073581; c=relaxed/simple;
	bh=7bMiRK0ShivdAJEqAqq8p+bSixyyMffBJzLzrorCG00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WRD1AVHOrGSRtR6RY3trJLz4MkpdT5OmXncVIs1NS/yIy8sAbI6O3tRW7a4mzAS3Y6W6m85bgRn/4S0JC/wv2dH2Rr+hia29+bkXEdQKFZX1aGAI1FuVVYRAVcnn4ic9023rIsmutwIEW4XJ39N45XEcU13fiehXQT5r6Xju5h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v1Mcwtpf; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v1Mcwtpf"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485345e2fdfso9189915e9.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773073577; x=1773678377; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B6OW0CQFlfUo8gIs8zWJuy/R7hSbmdzTUEKNvWrAy54=;
        b=v1Mcwtpfc6Di3oQHgnV7iO4KSGWD3oli/WG+ayqtJW3Nff3xYY1lghD6FCRP5Ipfb7
         7mDzxhORhDlyKdb0X6ZM6T4CmRGfkGUrw6sed416mQfD1BACDAPRF4I7YTm5pkrQ09HN
         K6ozVHVe6ZUFMldNMMke73bp03IoKSZkrDuKxuQd8FXtDYyKRLmVKanuzp0//UQ9U6PS
         TwkyDA+25/iNZXn9ek32cAciF6hXFrJj1IwZUem3235ph+KALQdfWiRtVn5ytUMlWTYP
         WbguyM9LZyvgcsK+3bJ9RYtgg4DJyp0WNivbh1KESmLf58Tnw3fEx1Jroav8I8igaJPH
         N2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773073577; x=1773678377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B6OW0CQFlfUo8gIs8zWJuy/R7hSbmdzTUEKNvWrAy54=;
        b=djzNU2SK1zDt+yZPLToJcHt5/SRTt2Dso6sW1TyKxkT0lkBdqsmv95Z+AJY0KufVMU
         CMTAVW0OSes/FPb+sLih+Njhb/W1y2j9VDoscIcsrQRbnZl03fcD8/ObQlTfHIBkKS0e
         CTJPdR03SrHn6Ti9fY5ssZBvjqCTcBkRh1+BRltDvBhfvR+QXG6gG+A5eoklQLWlbefe
         DlCipbXix3yYit+Fuz3yGCSVmNOhRIOSopO38N7J+7a1i9kmAeYJc7QLbDgGCMn34g/K
         ltSpQ7EsbAJ3p6LFkd+JVuXzRR3bhB/5zCApcYkjRmqziGmid0yT/3ZdiYXjYqoviMb6
         rxxg==
X-Gm-Message-State: AOJu0Yy9TZWWLhBqIg2BaSRSffOJWspQwgdXrQ++2l3gI0JSgspkUrU0
	YuP5oB1kFVNmvl/hlDLLGk/TMxbOJu8lNadEbW3sn6YIlRnt0Id0q8uhTTnGBtO1s0l6tqfZ00V
	gmDomwy8TrXVKcFjOmt7oPw==
X-Received: from wmmr21.prod.google.com ([2002:a05:600c:4255:b0:485:35d3:c8b9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d0b:b0:485:4136:99a8 with SMTP id 5b1f17b1804b1-48541369c0cmr13223965e9.22.1773073576611;
 Mon, 09 Mar 2026 09:26:16 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:25:02 +0000
In-Reply-To: <20260309162516.2623589-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260309162516.2623589-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309162516.2623589-17-vdonnefort@google.com>
Subject: [PATCH v14 16/30] Documentation: tracing: Add tracing remotes
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

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index 338bc4d7cfab..036db96864d2 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -91,6 +91,17 @@ interactions.
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
index 000000000000..1f9d764f69aa
--- /dev/null
+++ b/Documentation/trace/remotes.rst
@@ -0,0 +1,66 @@
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
+Firmware and hypervisors are black boxes to the kernel. Having a way to see what
+they are doing can be useful to debug both. This is where remote tracing buffers
+come in. A remote tracing buffer is a ring buffer executed by the firmware or
+hypervisor into memory that is memory mapped to the host kernel. This is similar
+to how user space memory maps the kernel ring buffer but in this case the kernel
+is acting like user space and the firmware or hypervisor is the "kernel" side.
+With a trace remote ring buffer, the firmware and hypervisor can record events
+for which the host kernel can see and expose to user space.
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
+Once registered, an instance will appear for this remote in the Tracefs
+directory **remotes/**. Buffers can then be read using the usual Tracefs files
+**trace_pipe** and **trace**.
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
+Registered events appear in the remote directory under **events/**.
+
+Simple ring-buffer
+==================
+A simple implementation for a ring-buffer writer can be found in
+kernel/trace/simple_ring_buffer.c.
+
+.. kernel-doc:: include/linux/simple_ring_buffer.h
-- 
2.53.0.473.g4a7958ca14-goog

