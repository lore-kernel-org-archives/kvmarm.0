Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526BF34405B
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513421; cv=none; b=o40MSmLbcXLYWOwDECe+qhsgUNJAVIh+F4BbMuKVQb/mImX2KLpum0W4AgvLC7APuggUjjvqPsIBExPcDEdpl0ZWdq6br1rVMqto9XlW3vvpZ6Qcttvt7vBAuhva/039Zq9Wrif0j5ueGHs6ffYN9epByfJhe87gI03N5YPtH/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513421; c=relaxed/simple;
	bh=I+pJGIs0Epojic7l7vjIxFwm13eg3s/jxJWStIzBqmU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uY8GoTNiB8/SUOqkmFKZQNDNKBuuP7febG9AVpebqSP0Sdg1/6pM1hzmZT2UUjqc0DZdPaCnr0CDR+WY9L8zzd2+JAiQFd5duEeFHGpOSpYPN61jG0zxB8E13Rj+vE9QdGZSl+3tZ9qsb45Tl9ME6CPXwIVpprHOPFZVFIqUGDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eCEQiJS4; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eCEQiJS4"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8fc132b0b4so120631566b.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 07:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771513418; x=1772118218; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sPhLrsaL6GHqnFz8k7XCh7wMYB+F4ptERk94umByGuM=;
        b=eCEQiJS4pSigTfNdP0iURAKUZnzArL6Qxx2wiwcmxeb3hAPWiEpJ54Az3aMukbAVHD
         j0PHs56JtS6YvW6MoSl7KtO3qeHgBFNR4JXupD0aTlYp32xi1rM31VeKDWFNixbhPEm+
         fRfQlttkYYMEPKhMfuMbwxLfQ54giUkMz6EoBCAPSQ75hZdaddVKPv4XTV3GY9qyvpyc
         vqLhVCCxp2yXfYhyKK069UJCWJudc9aa/23PaAt0UKDT5u9GD3ELOUXjO8HVM6/lXMu+
         bvGZzLJnjsx2wim9BTSDy3SPkpaPD57VY8uSLbyEvMONzFAyUO8imkEchnkJ+tXcjBma
         ACvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771513418; x=1772118218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sPhLrsaL6GHqnFz8k7XCh7wMYB+F4ptERk94umByGuM=;
        b=rWPrGkF5blI7kZCJEPtNfkNUxg4X+rhJ9rgf5gF0TUSGQ/zo/FhpPB23aLqHqFNzrd
         083bUTLB8Xu1ZS5V7Nmh0tZgbsFkNK+uCn+RZ6nlH2+khidCpre3+3XWm2u4q9LJAI96
         VPJoVfD75v/fMbrOUIAn0XG1+X/9eTFYlvMMzXHCWdgtIzG7DONDRVPcxNE5kXV1+wjl
         UO4FXy/TSCIqZ0sgLwz71CAxmbmPXNU4SapWdwuKglWfhKA7xggLeUluixqYCXaLVbX0
         /MAdR0hsuSE8IXnJwYMnqXxqo0pdFlRoPa/4JQg5X/dDtUSCy4OtgAqANsktNpbjVT7B
         oJwQ==
X-Gm-Message-State: AOJu0Ywyb/XGV9jTGe3IFQXvsMeMgidVDDdGNPz/GyPu8AS2jkr/Hlbe
	aDS9CUlnJkd7rTqvT0panF8W/dmPPAS3CaoPu1HGkY7Aql7LvS9k2STpyCgPQRzGrZ03bYHW3rL
	y+FtHMc5tgKtSjaFO5+IL7g==
X-Received: from ejcyl14.prod.google.com ([2002:a17:907:bc8e:b0:b8f:943e:13b9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c82:b0:b88:16dd:d835 with SMTP id a640c23a62f3a-b903da49047mr298923766b.1.1771513417420;
 Thu, 19 Feb 2026 07:03:37 -0800 (PST)
Date: Thu, 19 Feb 2026 15:02:53 +0000
In-Reply-To: <20260219150307.14538-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260219150307.14538-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
Message-ID: <20260219150307.14538-17-vdonnefort@google.com>
Subject: [PATCH v12 16/30] Documentation: tracing: Add tracing remotes
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
2.53.0.335.g19a08e0c02-goog

