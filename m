Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE8723BD17
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759498757; cv=none; b=B75U2J5F7tXJD7Lel2v8S9UwIdeaT+4xLwujfnkQajcGhMQ3zr6YASXK/28d7jyJjIaom2D8HB9t6mZlnIG8FWgWIsxgZr8u5GOYQaJSLMJ8wVQhGeYrIc0g9Gbbt97pRvBcPxvkZcQ2Vkz2ODmyDgkRjazkRp3FD9jOcAmKUys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759498757; c=relaxed/simple;
	bh=8Cw2K0IyrMbYYLIH+BNRbrAbypKpGcwbo42Tv7az5a8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DpxwyW+MKebCUbWCAVi4hMtJB7lRUlYbSs6gCV9FDN2oOxpxAlkKULrRRcHsVRaI1t4vv0lnX4UeGt9BGsKSkTgeBYI7fPjSk9YMDjkYXyNE7NmKTiZGwUgILu4icDPOKWoj9IqTQzDLvWxb9jQo15YTNhT3tImUz9W3EPwfu3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4cFlPp62; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4cFlPp62"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-63049fca047so3177592a12.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759498752; x=1760103552; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ptOXAsK02KET+nuGM2NvZr5tn+Cruj7KUoPt2v9bC4=;
        b=4cFlPp627/SXv7GRUaAo9z9uWtneEF0unsuzYbVE7U4LrSIxUMJq7JsUdiIki6Nw4G
         EvA3lDjzj56eJJXHNsIg6JtsP+qBqcOqoEPlCjrcrhFkiJzcWRX1bGYpC0NS3Q10Ekhf
         EaUkZ6gtogA0K0qSAuF75vb9vWd9DrfmwW6up47GJguKxrrSUOQYqOms3LdnrShS1L7O
         ckFY875vgpTz67CqsjWHEQZotSpYM7u3+2+kDbSQMxHo0W5IG4erdK0s8Pcy0DoGG/VP
         0SYqYxq9GQzZCo4W7wbtoFRjRYQkVR5QkrJHp0NFEOLPowTY6DKngzdep3k154aI6zpi
         tm0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759498752; x=1760103552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ptOXAsK02KET+nuGM2NvZr5tn+Cruj7KUoPt2v9bC4=;
        b=I/ysBza6Y9T/e1oTGFtctK7+6zDDYkP9p6vKPgZqSIzksDaW417cNI/xISnhgII2uI
         1PYD48uHfFv/pWUUzC7JTwODb8C78DhkHbohzaETUTZaITUkl41M+L7ijlMVUFmaaUzb
         5mXQe9ROhjxCq81rGwV2bNkgVYixhdjYZJ1Ci/2Mig7LbK2SkP+StD13X1fr3Th/Ux+S
         G9Cex9J+KWo4N+TNAbPOBericv0+HbCVkr9uNpUauQB6oQddaJAZYpDBBkRY4zriUqT0
         H3vHtVbYwRoIq0QyqxpaIvIxf2e59B+AVo5Ho4xfdhjDn15i5ovVQ7+3IK7l16eetlcL
         nMWg==
X-Gm-Message-State: AOJu0Yysx3aeSKhMjvoeij38HwcrWoNYIzsjw2CjCyeqmuiOyLO+QR9A
	A3E6SpYNAIt3S8dtQZvXDndMicvDO3ydEYtttIie/ydV6abrMMb+Mr2MClkTehDwuG3C4VA3lnC
	qFHiXSgSG+jbFiwDTmO8RKg==
X-Google-Smtp-Source: AGHT+IH1xhwr98a1KjzKNYHcZRC7sH0MEyc8VNAbl5gX0uevl9b95kinJk1XW3eUNT+SGJ+58Lgd/woZKqcy9o+d
X-Received: from edwr6.prod.google.com ([2002:a05:6402:346:b0:636:640b:3c66])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:50c7:b0:637:e17e:1a9a with SMTP id 4fb4d7f45d1cf-63939c2df6dmr3356826a12.26.1759498752381;
 Fri, 03 Oct 2025 06:39:12 -0700 (PDT)
Date: Fri,  3 Oct 2025 14:38:13 +0100
In-Reply-To: <20251003133825.2068970-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251003133825.2068970-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003133825.2068970-17-vdonnefort@google.com>
Subject: [PATCH v7 16/28] Documentation: tracing: Add tracing remotes
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
2.51.0.618.g983fd99d29-goog

