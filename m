Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2A2357716
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866180; cv=none; b=Hoq+xu6VRWcz4XcCy310NGk2ENqMAouM5OlKyDCuWx8Akn4yILzlEZf0Ca+aokUtMT+hmB4xyl3F1MZr+jxjIXkfu7hLNt5y4ppT0+u4KX55f72nDhNetd3PZh7P56CuxxC3PGU8QY1uriWInb8VoYgyzuIOlsam2+knCZTTtwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866180; c=relaxed/simple;
	bh=KqGQJ3tC3qFnZ/Dn8gtyeUO3Ghwgazfb45Eed7HGhOY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pjkybcKaJ+X66FuoCFWCp6SFdOxI8PgnM2XcGSf7DM1SSR2V7SmoQjr2g3qgMfBI8VAS9/EFRnYkqHYOYjGBknvJTavOZdX4PqTN3IbaYnUNThw3r1TGpUQO70ABAqvTn/MubZkh2ef8iH3zJcvMQ4Am352B/BglopzcdGyLzrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FpRmmYml; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FpRmmYml"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4804157a3c9so36045265e9.1
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866176; x=1770470976; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t7Sypasz+bQGyNEk8DfMJjS2f0ZOWyjNay6SOTdco7o=;
        b=FpRmmYml6xrBpjwkIQPaj1PSin0mxuBmxeIeJXVByXzsjinL6yy3i7V2sFV/XjpOEe
         SxRqzn3QJgn4spGPy3gBpqI6DbNpBnt0Eb6Rcbvq2F5tbI3s0p9cYXmhvqK9hO1gHiN0
         9q+QiJ4IBYFzx6Wvg94AgAEtMSCmkshttrR9BDBP/Tu5QNjS5Hy5Y5YMbVTZw9tDjmCF
         +zHLpby+74zKc3FVBdZAAkfGAYj0U46KJ4AF4M9WvRUbiu8VCcSVXixjwbxfCSXkxIjd
         bMrKvY/XVZYLqGFHcWqsyyesyyVrg4iYRcpKQQiRfSigR23gWaG/W/oLJI01l0a7u21g
         kh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866176; x=1770470976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t7Sypasz+bQGyNEk8DfMJjS2f0ZOWyjNay6SOTdco7o=;
        b=SfG9mdB9yfOzTRGznU63PUbywSCXa30+lPJQX+367515IcFxvnAntGovjOHL2Gf4jr
         3hSH+u17iB1dKMKCO5tYj903pmx2W4094gm880ujZaWSCYSo4xEL7Uy/Mcs9Yi9RtQvx
         iaYxQln4Ekrqm3Qq/T55rWR6GTgLS9zQyBkI2+Sk46cF9D7GuouF8bTMBKSPO1eBKhnk
         dqY2TxqGtTiPQXLGVut/Iq2KrtsqrP++fp2V4AtJza9oZ1Cr7W7jZ4F+790Lo3X24cQa
         wJnLXw2pNdciSvTVTqaSjlIREfXtIvRQJ+WkGa8ygHmPuH6CSVd/Y6f3qpBn2VO9A3i0
         AHZw==
X-Gm-Message-State: AOJu0YzDDkdGLYYbV/NDTE41jbxlh2tSv0URHmYc/wnWByRpweYltcK+
	DIkzJERA0Fyji0KIdq09oW9rMBiIA5eFLtz+yIoTjtx+Kcmr0VT1sgQmO/rOhs21FkPkfTLaCXp
	PFXzItVSo7vJ4Ag73Ailrdg==
X-Received: from wmot11.prod.google.com ([2002:a05:600c:450b:b0:480:6ccb:80fd])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34cd:b0:480:1a3a:5ce6 with SMTP id 5b1f17b1804b1-482db46b665mr66755355e9.14.1769866176467;
 Sat, 31 Jan 2026 05:29:36 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:34 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-17-vdonnefort@google.com>
Subject: [PATCH v11 16/30] Documentation: tracing: Add tracing remotes
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
2.53.0.rc1.225.gd81095ad13-goog

