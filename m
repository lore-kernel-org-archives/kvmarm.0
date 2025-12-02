Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E5313281
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668211; cv=none; b=mkCFdKTCexi0rEtN7V7gk/LXo8OxuOcUfzprcbGjg1eHqZMxJ0MSO7sAVT5rnulNE7fvW369RFZ+oZblwbgNpGOZqZfDOhNduJx1GZuF3M+Vw9Rl+ANXsPkvRd2NYetkAYAfDe5Yqskw5p7dFwliUT7dOEmpqBBKgCSwdvKV3a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668211; c=relaxed/simple;
	bh=6F+v6J+CWN//r6wGF64D0I/BsKCCCENIMewP2BSYDLg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wcs7OtbJfz/HGNFCMfAc5iDBMaDavUNlZvHNne3W0YqqZfNjH/NNnH4t6DuKQQzoZ4m8ygvyVI9zS9eeWH8AV2VR87tdI2OFouhjrp4ueiA4fM4yXgDgisYHCQChBfUDQmvL5on60WMLGJB/kIG0c3tFKyL65Tlez3gbb4juNXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jpAlxbaz; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jpAlxbaz"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b72a95dc6d9so176238966b.0
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668207; x=1765273007; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1k9lnCa35g0aTUreNVQa2rVX+IRvV+YbWj70G3JIso4=;
        b=jpAlxbazv/o+VHus8xgf32XSYmXc2NIhqmQhakNP1ouahNhsGvXMmBeLaFpzAz0BZ2
         5mAlh/cv5c0Vz21q4++b15eS6n9hNwI9UkRJquSP4A2NfzUpH8MHCescmliXygCQETFQ
         QqzK3EaDA//y7KQvroLykgUr8jh/QF/pWIb5MR8+JgYs9hqy0rmrYPKucISJGdcxGfMj
         U1H83cxiWy+6eaVsl57I9VxHJnUC9IV0vYVNur+0gH4ckXbml5afeAaxe3jnn7aErfx/
         LN3KEtvDKH4RiF6etNqSEWsswDuQkJnpxCyZFn0/oMtwImiTciz+odteti7kABFDh8Hs
         Eefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668207; x=1765273007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1k9lnCa35g0aTUreNVQa2rVX+IRvV+YbWj70G3JIso4=;
        b=nfeijH5935HMyjjc0ALStNNtO2pzYtROgSTUzlzvW3Af/4iI+0oySC50DT6bflytDI
         QOivzyBonibFrSDurzzPB91IKZ2cBvzc+fZA+plNTKsSg36zAQf0HKWI/V4X0QxaaPUn
         V7T4UpnMw9C+Lpd9WBFTscLTayeP1MU8GI3ld0whwnCSlQ5UV9aWnDqIMTJvSsTdeMR9
         XLoRvO7ILsVhrUWC8nJ11+xubWdwc67EYZUQDeZKiooxHPdyQVRaRmrsjqrMXv7fdWq2
         ur3K160YbbcIewvmwypITTmkxOHMBbnqSWQE9q10Dzbp5OX3IvegpWwA72SEiGexNFSA
         EOeQ==
X-Gm-Message-State: AOJu0Yzi9xXfO+VAf7XqRp9NqB95x2oJLxaJEUCXHdMaUCqDpSbN8/It
	C4LwGieFyXyvpEVz1xebTqZKhTvOXTUrP1Me1l8rsQy8fKv8PcuKVZGudhPfrDn57D0yJKanpNi
	0y+RZcWfEwrS4HxUqdoW2xQ==
X-Google-Smtp-Source: AGHT+IH6ccFpR0WrW+/F3kealA6pNGmuZbYCFARi/n7zyIqU+hpmNdIgKjNmor9NcQZqnGFg0KMHEyXXFtwtLCUK
X-Received: from ejcse13.prod.google.com ([2002:a17:907:a38d:b0:b73:580c:b277])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:eec2:b0:b76:69d6:f9fe with SMTP id a640c23a62f3a-b76c566bfaemr3010632366b.60.1764668207371;
 Tue, 02 Dec 2025 01:36:47 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:09 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-17-vdonnefort@google.com>
Subject: [PATCH v9 16/30] Documentation: tracing: Add tracing remotes
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
2.52.0.107.ga0afd4fd5b-goog

