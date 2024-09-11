Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F81139FF3
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047048; cv=none; b=WpgNv7hGO+Dx2MnCSQCqKvDNlufyvWJS9VE7cZG4v5eb0B09k8CeBWwb0y2HjqrpCECFGocgKwz348UhE772PuBIo8Kw0bnISpDNF2habu31NT75UP9VQ2NYoY3L9mxSU7IxQrg/jFRi9YmUqQolfgk9gX5VLhERV2LZj1jZj8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047048; c=relaxed/simple;
	bh=2PaBkI0R5lLeVp6p2dH/xLId4x0A7so2AeTlfXbJP0U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eVhBZBmpKI8IMuN7AjIZ3qMpO7UqN/ALTulZWw3bU/EbSmfoKUP3FIFdIcohpLuehVUhnW187mEZQXG050KfqjJUvR0Bguasv2HDdpB/BWE45Ulb5rIXH3+uCxxDb07bOc+BhcPH0R6brZRBbeDUpuMsAWIIhF3rKsa63GBP/tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hkdx6eVW; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hkdx6eVW"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-690404fd230so41543677b3.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047044; x=1726651844; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h8P9fRb3EkrhUUvJp18ppHORqEKlJylySnTNQBBAPmg=;
        b=Hkdx6eVWfui826dYUeuqVHeLEglfCP8WCKqMeHfWAfN+ITx5VkftYMpeEEqJQuoXSQ
         17h1BbVMZTjFIwCNU+L1qEd1Cq+FXCq/TfJyrzhrJy4YWeR/rtNgD2E2SCVHUBLlZA8X
         3Ye4WBrZiJtjKayKHnOFpQgc+vspa49DSUjPofrrfM2h0Qck0acsEbLEqExBWSFjfMS6
         3eYD0OGs9OwYid9PR+D6lZCWcpPwg9cmcLognL4f+ACQh0JMPr3lTv/Viku2TISjgGXT
         FcszV+TrorIc+UfWKK0pp4b20wDiI7kYXED9Sq5Z5e39z/a1Zqbwowvar/kLnp0ewjfC
         +baA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047044; x=1726651844;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h8P9fRb3EkrhUUvJp18ppHORqEKlJylySnTNQBBAPmg=;
        b=rEgsVpKRRV+bWKNETAa0DPFuYp1JZ+OKQVCTEDCsF8lcvkqIJ5NlH6+/Ow/vrXOzyA
         0b/NUf3E+GcX2TY/bxMm5vbWjCweJUOgQhGYA9QJnffRi3M6aiVLkh6E/w7R5vcScgS9
         mxCH0/sktwwqDQiXDVsz6y2t2cJeJvf6VJZcGzzmNB8MrJAbY8kYC4RsydsK3t39Js4C
         UdCG4YNKjqUsG2VPjJqRxI1ZkOiCNnCmEs13TaaXj0dkBGAmOy2NWe5RWHWiCRWthtQy
         w1w7SSZ6KTEg2qJg3xxCfRrQLqQPZe1Vt37/Vobc9sve5tTeW21bnDCqTQZj5iB+/e9O
         9+bw==
X-Gm-Message-State: AOJu0YzUhGy4mvkU3NtD4fjhClDDR7+nDNj93Q1fc2a4hywzKwyHolMj
	3ramIX4KUObsccb9PsHICbq+Nydke3BafQdunuDHQytcjOuv09llVCTegvNgS1gEKRoZeXE5f/J
	FwgEjJ+h1xJCqSNPbnA==
X-Google-Smtp-Source: AGHT+IGFJzMtbH6bztpXDokzlEMqa87wZ0wTsQ3uWLqW9OgpdVO/LQvEq/lwGL5QyMWloPi5k3zXE+um8VY/kbR9
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a25:d64e:0:b0:e03:3683:e67f with SMTP
 id 3f1490d57ef6-e1d8c39e976mr2989276.5.1726047044436; Wed, 11 Sep 2024
 02:30:44 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-1-vdonnefort@google.com>
Subject: [PATCH 00/13] Tracefs support for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The growing set of features supported by the hypervisor in protected
mode necessitates debugging and profiling tools. Tracefs is the
ideal candidate for this task:

  * It is simple to use and to script.

  * It is supported by various tools, from the trace-cmd CLI to the
    Android web-based perfetto.

  * The ring-buffer, where are stored trace events consists of linked
    pages, making it an ideal structure for sharing between kernel and
    hypervisor.

This series introduces a method to create events and to generate them
from the hypervisor (hyp_enter/hyp_exit given as an example) as well as
a Tracefs user-space interface to read them.

A presentation was given on this matter during the tracing summit in
2022. [1]

1. ring-buffer
--------------

To setup the per-cpu ring-buffers, a new interface is created:

  ring_buffer_writer:	Describes what the kernel needs to know about the
			writer, that is, the set of pages forming the
			ring-buffer and a callback for the reader/head
			swapping (enables consuming read)

  ring_buffer_reader():	Creates a read-only ring-buffer from a
			ring_buffer_writer.

To keep the internals of `struct ring_buffer` in sync with the writer,
the meta-page is used. It was originally introduced to enable user-space
mapping of the ring-buffer [1]. In this case, the kernel is not the
producer anymore but the reader. The function to read that meta-page is:

  ring_buffer_poll_writer():
			Update `struct ring_buffer` based on the writer
			meta-page. Wake-up readers if necessary.

The kernel has to poll the meta-page to be notified of newly written
events.

2. Tracefs interface
--------------------

The interface is a hypervisor/ folder at the root of the tracefs mount
point.  This folder is like an instance and you'll find there a subset
of the regular Tracefs user-space interface:

  hypervisor/
     buffer_size_kb
     trace_clock
     trace_pipe
     trace_pipe_raw
     trace
     per_cpu/
             cpuX/
                 trace
                 trace_pipe
                 trace_pipe_raw
     events/
            hypervisor/
                hyp_enter/
                          enable
                          id

Behind the scenes, kvm/hyp_trace.c must rebuild the tracing hierarchy
without relying on kernel/trace/trace.c. This is due to fundamental
differences:

  * Hypervisor tracing doesn't support trace_array's system-specific
    features (snapshots, tracers, etc.).

  * Logged event formats differ (e.g., no PID in hypervisor
    events).

  * Buffer operations require specific hypervisor interactions.

3. Events
---------

In the hypervisor, "hyp events" can be generated with trace_<event_name>
in a similar fashion to what the kernel does. They're also created with
similar macros than the kernel (see kvm_hypevents.h)

HYP_EVENT("foboar",
	HE_PROTO(void),
	HE_STRUCT(),
	HE_ASSIGN(),
	HE_PRINTK(" ")
)

Despite the apparent similarities with TRACE_EVENT(), those macros
internally differs: they must be used in parallel between the hypervisor
(for the writing part) and the kernel (for the reading part) which makes
it difficult to share anything with their kernel counterpart.

Also, events directory isn't using eventfs.

4. Few limitations:
-------------------

Non consuming reading of the buffer isn't supported (i.e. cat trace ->
-EPERM) due to current the lack of support in the ring-buffer meta-page.

[1] https://tracingsummit.org/ts/2022/hypervisortracing/
[2] https://lore.kernel.org/all/20240510140435.3550353-1-vdonnefort@google.com/

Changes since RFC: https://lore.kernel.org/all/20240805173234.3542917-1-vdonnefort@google.com/

  - hypervisor trace clock:
     - mult/shift computed in hyp_trace.c.
     - Update clock when it deviates from kernel boot clock.
     - Add trace_clock file.
     - Separate patch for better readability.

  - Add a proper reset interface which does not need to teardown the
    tracing buffers.

  - Return -EPERM on trace access.

  - Add per-cpu trace file.

  - Automatically teardown and free the tracing buffer when it is empty,
    without readers and not currently tracing.

  - Show in buffer_size_kb if the buffer is loaded in the hypervisor or
    not.

  - Extend tests to cover reset and unload.

  - CC timekeeping folks on relevant patches

Vincent Donnefort (13):
  ring-buffer: Check for empty ring-buffer with rb_num_of_entries()
  ring-buffer: Introducing ring-buffer writer
  ring-buffer: Expose buffer_data_page material
  timekeeping: Add the boot clock to system time snapshot
  KVM: arm64: Support unaligned fixmap in the nVHE hyp
  KVM: arm64: Add clock support in the nVHE hyp
  KVM: arm64: Add tracing support for the pKVM hyp
  KVM: arm64: Add hyp tracing to tracefs
  KVM: arm64: Add clock for hyp tracefs
  KVM: arm64: Add raw interface for hyp tracefs
  KVM: arm64: Add trace interface for hyp tracefs
  KVM: arm64: Add support for hyp events
  KVM: arm64: Add kselftest for tracefs hyp tracefs

 arch/arm64/include/asm/kvm_asm.h              |   8 +
 arch/arm64/include/asm/kvm_define_hypevents.h |  60 ++
 arch/arm64/include/asm/kvm_hyp.h              |   1 -
 arch/arm64/include/asm/kvm_hypevents.h        |  41 +
 arch/arm64/include/asm/kvm_hypevents_defs.h   |  41 +
 arch/arm64/include/asm/kvm_hyptrace.h         |  37 +
 arch/arm64/kernel/image-vars.h                |   4 +
 arch/arm64/kernel/vmlinux.lds.S               |  18 +
 arch/arm64/kvm/Kconfig                        |   9 +
 arch/arm64/kvm/Makefile                       |   2 +
 arch/arm64/kvm/arm.c                          |   6 +
 arch/arm64/kvm/hyp/hyp-constants.c            |   4 +
 arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h   |  13 +
 arch/arm64/kvm/hyp/include/nvhe/clock.h       |  16 +
 .../kvm/hyp/include/nvhe/define_events.h      |  21 +
 arch/arm64/kvm/hyp/include/nvhe/trace.h       |  60 ++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   1 +
 arch/arm64/kvm/hyp/nvhe/clock.c               |  49 +
 arch/arm64/kvm/hyp/nvhe/events.c              |  35 +
 arch/arm64/kvm/hyp/nvhe/ffa.c                 |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  85 ++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |   4 +
 arch/arm64/kvm/hyp/nvhe/mm.c                  |   2 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |  14 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   5 +-
 arch/arm64/kvm/hyp/nvhe/trace.c               | 660 ++++++++++++
 arch/arm64/kvm/hyp_events.c                   | 165 +++
 arch/arm64/kvm/hyp_trace.c                    | 981 ++++++++++++++++++
 arch/arm64/kvm/hyp_trace.h                    |  15 +
 include/linux/ring_buffer.h                   | 108 +-
 include/linux/timekeeping.h                   |   2 +
 kernel/time/timekeeping.c                     |   4 +
 kernel/trace/ring_buffer.c                    | 294 ++++--
 tools/testing/selftests/hyp-trace/Makefile    |   6 +
 tools/testing/selftests/hyp-trace/config      |   4 +
 .../selftests/hyp-trace/hyp-trace-test        | 254 +++++
 36 files changed, 2932 insertions(+), 99 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_define_hypevents.h
 create mode 100644 arch/arm64/include/asm/kvm_hypevents.h
 create mode 100644 arch/arm64/include/asm/kvm_hypevents_defs.h
 create mode 100644 arch/arm64/include/asm/kvm_hyptrace.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/clock.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/define_events.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/trace.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/clock.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/events.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/trace.c
 create mode 100644 arch/arm64/kvm/hyp_events.c
 create mode 100644 arch/arm64/kvm/hyp_trace.c
 create mode 100644 arch/arm64/kvm/hyp_trace.h
 create mode 100644 tools/testing/selftests/hyp-trace/Makefile
 create mode 100644 tools/testing/selftests/hyp-trace/config
 create mode 100755 tools/testing/selftests/hyp-trace/hyp-trace-test


base-commit: 8d8d276ba2fb5f9ac4984f5c10ae60858090babc
-- 
2.46.0.598.g6f2099f65c-goog

