Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507303B95F6
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807772; cv=none; b=L8mGMg+RcTXHl44Be1ebA1QBOdSJKA0RqtH05EKMe8NvWjuv5dHAbxCt8J7KKSJzHinQB/6QbcLZJWvkkfu+K9EnrN7KNeEuK55Yl15mDuRrr38DRdrRBGqBXsuxRV9f2u8whYDaUrLcTdm8UgbWzEMKb9fP+xuUxFb3b1YVz+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807772; c=relaxed/simple;
	bh=7bMiRK0ShivdAJEqAqq8p+bSixyyMffBJzLzrorCG00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T/Zj8TzI4j0jwUbrpYDgOWF4X168vDuHXca02XSbK8NR6d4gCixLdDaRWXJ/h3ewi3bYYCghbgsx5LOfwK6LTfWSSmWeM5OVa93KDH/dpkDr7KwMmxP4SextBsQLtH6LPvbMOjSvmViydh6fsJdfEzZuRtJj0kPZm7lmdjvbo6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eBXIXyc4; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eBXIXyc4"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836bf1a920so99905605e9.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807769; x=1773412569; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B6OW0CQFlfUo8gIs8zWJuy/R7hSbmdzTUEKNvWrAy54=;
        b=eBXIXyc4yoONsYDjfQBcBOoI2rbusdXxZP3QGyRWE3zy+fGQJjM+OBADiOOgBQK3hw
         EYL+v3PimvHI1O//yI9Wf1HFAmmldHGonC/RPl/sFcLiurVSfRsOIddiKOKjO/L7I1JN
         MHMaU5IVdtVGQ9aQLJfs0q5qa7hr62zy7MprzCV60ehSsTNWXRiG9+WzyRlttt5ItC6A
         JSC08jnzxsPJrjiWOdRLHdILkkidS/LQYCbhk6YdBQXrm7m4QpdShFba3JJF/QuQU2b2
         ctFJhBuZv2+4vMH5yM9zCjt5Aj/kIylVI/Uq6Dgt2UPvvFLfcEtyN5Bj8m87Odvcvm3q
         p8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807769; x=1773412569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B6OW0CQFlfUo8gIs8zWJuy/R7hSbmdzTUEKNvWrAy54=;
        b=bYlWKlRVcJiBIl7MI4rbDdgEHJ8m1ZuMOuy58g7Q4Pp4UyjkbUPn0268gfQRtD7OW5
         9l2VyEn6VkAVTEf4Oxa5DfqK/bajnH13EKRGJk9FL7XB224WoyDkbSINnGDA4AhMN3OR
         Wf/Yo2NwinHOtLO0Fs+Rny/oRpEojOHys8ySdnVM1Z6FyE5Ug8k7C2ZX6gR21/aEDBJm
         4+VxvmFjAnhyNZGkRR89H/tQWMuroiO4g0Lf+WWoKNhDWNH/rM9qSAngICTxJKRBQiTa
         K9am3oGhBlwusQ+GJBnj3YWa16Mru5LsByDJo/QO5Qh+cwlLLUchASjNPiATYiK7zFQY
         1OGA==
X-Gm-Message-State: AOJu0YzbsX2Nr95YhKXvt7VdUe6vOR+Sq3rvbUwpkaG4nLrMO+QsoVH2
	eX+/T6yflAFVe11n9oXKAHrCDzoHXpUQ3XBnDXDvFrbLF3Jfg0TF0byhV5ir3thFsQ+ep2ua91k
	M0q8goqEeuRALULsTP668hw==
X-Received: from wmlu14.prod.google.com ([2002:a05:600c:210e:b0:480:6c6f:8c06])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4451:b0:483:bcff:7948 with SMTP id 5b1f17b1804b1-4852692427cmr37315825e9.10.1772807768794;
 Fri, 06 Mar 2026 06:36:08 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:20 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-17-vdonnefort@google.com>
Subject: [PATCH v13 16/32] Documentation: tracing: Add tracing remotes
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

