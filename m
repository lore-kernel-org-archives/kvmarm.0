Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6492836AB
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550122; cv=none; b=CU0rMV0oUoYkrXQ3Xafwa6dPMPS+AujmsMsWrHoL0L3r1aSCrZSX9lR4hvlrl4UEmcsVT46fj7rGFR4SIPWb/a9nL6/Lt+5qe6JgjglWpzEadS2Grr0g4+PAkfWUXd2Bia0woWf/I/x3xJO0fFTe3eEDbp7hU6uB08IPW3E1KfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550122; c=relaxed/simple;
	bh=VeYJiM4TgKxyjozN0KYUp0m+eWQXdV73kcBz7MMxCIQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gA1RlS5F/R0wtLGmGQj0Y/slrHpM9r+gyBxrdXETI6zirudo9LU+Tg2B3NtFjK86oWexOSlWbHkjwJ2RuUgvuxVEy3Ukob+yN1LvE9E/JI9NrazaTCcV3k7NlL7haR32yUxLlRglTVs9VcdkuGir43xvXZfu/aBEui8yly9NQKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wK3DHQcH; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wK3DHQcH"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a07a7b4298so3012893f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 09:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746550117; x=1747154917; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fvtRPkNg7XQhBPUcN5+kuOnLQYVJvsdpdM4FJLMBc5I=;
        b=wK3DHQcHb+WYKg6J1HUC2Zem/FxHQrnAQv4Z6IkKOi7TiwIzN4sNqU+MxaWuOR/CzL
         2RQq936lCWqYaaYSeuywWm7IeoF/aZWG4GiX8mw6iaFX2ct1hToK/jlYdCiXx+4PgeOG
         SoS2wpvdzOoTpzg+OHhvyM/3w+iue305+F6A40u8oxSDoJeHcIh0sdVN2a93aNfsxj4O
         0hPD4OSd5SuSp89k5upFneUkafCFGOOegOwBbTJglJEfaDY9YzoQg75S2kuMCDG8ooXi
         jxqA7rFEfwyeCPAxiwNBekGQ51e3iaxkZs1aklndQyLApX/4hDJOpJDRGg/xdDTMt739
         EaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550117; x=1747154917;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fvtRPkNg7XQhBPUcN5+kuOnLQYVJvsdpdM4FJLMBc5I=;
        b=C3blY9+gB8uE0+r9+XfFPlA02VytDUH8WU4H7TBAe+Yngs2mWBieb2qWJAwxH//7AO
         wvQE9yqztuuahaMTKjcMlqOrgM4I5K6cu+nvv2snRqNbpn76m9O6AQH9VCyVuI1viiYy
         zx80n0vQy4KeKhk277x8z0hoR2kKCSZwJTn5lUefIp7ZEnhrr7IIMAOoAaQ/qCeVvT+3
         7oqNjXZne+OTxdTN8sLYSywv8k1HiORyT904PnNE8a/cNYJRTaydGiCyMj/+Xxa8G/Gn
         +HjQ7Sq+qPdH8vVAhnQ3AcxMr0CbjrhSgvBUOGiVlQTd1glDngpJmsQ79V3EFcMEHkS6
         /UOQ==
X-Gm-Message-State: AOJu0YxzKKB+h6HAE0xL6TNJAG0G3EJiBmH5kl1ymFvsgDewI4BRPAsY
	1qXrQefHdLnJ8DvgKtdu9yycxUNDTJKlBiTI1vK1tq3IXZrDSkHIXd7c1+YN5ulg28mQ7HEcjF+
	D5VVmMUNpchIolQYwbQ==
X-Google-Smtp-Source: AGHT+IEv/Gc7S+F9X13R39RO2qDXEDXNw26NOkhCUMUe/NUI8fsrYQIxNwYe7SuAQsj3X8CBruTiPdos44RjOlZf
X-Received: from wrbew2.prod.google.com ([2002:a05:6000:2402:b0:39d:8425:6355])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2204:b0:3a0:8a1c:ef0 with SMTP id ffacd0b85a97d-3a0b49bbdb3mr175373f8f.24.1746550117763;
 Tue, 06 May 2025 09:48:37 -0700 (PDT)
Date: Tue,  6 May 2025 17:47:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506164820.515876-1-vdonnefort@google.com>
Subject: [PATCH v4 00/24] Tracefs support for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
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

This series first introduces a new generic way of creating remote events and
remote buffers. Then it adds support to the pKVM hypervisor.

1. ring-buffer
--------------

To setup the per-cpu ring-buffers, a new interface is created:

  ring_buffer_remote:	Describes what the kernel needs to know about the
			remote writer, that is, the set of pages forming the
			ring-buffer and a callback for the reader/head
			swapping (enables consuming read)

  ring_buffer_remote():	Creates a read-only ring-buffer from a
			ring_buffer_remote.

To keep the internals of `struct ring_buffer` in sync with the remote,
the meta-page is used. It was originally introduced to enable user-space
mapping of the ring-buffer [1]. In this case, the kernel is not the
producer anymore but the reader. The function to read that meta-page is:

  ring_buffer_poll_remote():
			Update `struct ring_buffer` based on the remote
			meta-page. Wake-up readers if necessary.

The kernel has to poll the meta-page to be notified of newly written
events.

2. Tracefs
----------

This series introduce a new trace_remote that does the link between
tracefs and the remote ring-buffer.

The interface is found in the remotes/ directory at the root of the
tracefs mount point. Each remote is like an instance and you'll find
there a subset of the regular Tracefs user-space interface:

  remotes/test/
     buffer_size_kb
     trace_clock
     trace_pipe
     trace
     per_cpu/
             cpuX/
                 trace
                 trace_pipe
     events/

            test/
                selftest/
                          enable
                          id

Behind the scenes, kernel/trace/trace_remote.c creates this tracefs
hierarchy without relying on kernel/trace/trace.c. This is due to
fundamental differences:

  * Remote tracing doesn't support trace_array's system-specific
    features (snapshots, tracers, etc.).

  * Logged event formats differ (e.g., no PID for remote events).

  * Buffer operations require specific remote interactions.

3. Simple Ring-Buffer
---------------------

As the current ring-buffer.c implementation has too many dependencies to
be used directly by the pKVM hypervisor. A new simple implementation is
created and can be found in kernel/trace/simple-ring-buffer.c.

This implementation is write-only and is used by both the pKVM
hypervisor and a trace_remote test module.

4. Events
---------

A new REMOTE_EVENT() macro is added to simplify the creation of events
on the kernel side. As remote tracing buffer are read only, only the
event structure and a way of printing must be declared. The prototype of
the macro is very similar to the well-known TRACE_EVENT()

 REMOTE_EVENT(my_event, id,
     RE_STRUCT(
         re_field(u64, foobar)
     ),
     RE_PRINTK("foobar=%lld", __entry->foobar)
     )
  )

5. pKVM
-------

The pKVM support simply creates a "hypervisor" trace_remote on the
kernel side and inherits from simple-ring-buffer.c on the hypervisor
side.

A new event macro is created HYP_EVENT() that is under the hood re-using
REMOTE_EVENT() (defined in the previous paragaph) as well as generate
hypervisor specific struct and trace_<event>() functions.

5. Limitations:
---------------

Non-consuming reading of the buffer isn't supported (i.e. cat trace ->
-EPERM) due to current the lack of support in the ring-buffer meta-page.

[1] https://tracingsummit.org/ts/2022/hypervisortracing/
[2] https://lore.kernel.org/all/20240510140435.3550353-1-vdonnefort@google.com/

Changes since v3 (https://lore.kernel.org/all/20250224121353.98697-1-vdonnefort@google.com/)

  - Move tracefs support from kvm/hyp_trace.c into a generic trace_remote.c.
  - Move ring-buffer implementation from nvhe/trace.c into  a generic
    simple-ring-buffer.c
  - Rebase on 6.15-rc4.

Changes since v2 (https://lore.kernel.org/all/20250108114536.627715-1-vdonnefort@google.com/)

  - Fix ring-buffer remote reset
  - Fix fast-forward in rb_page_desc()
  - Refactor nvhe/trace.c
  - struct hyp_buffer_page more compact
  - Add a struct_len to trace_page_desc
  - Extend reset testing
  - Rebase on 6.14-rc3

Changes since v1 (https://lore.kernel.org/all/20240911093029.3279154-1-vdonnefort@google.com/)

  - Add 128-bits mult fallback in the unlikely event of an overflow. (John)
  - Fix ELF section sort.
  - __always_inline trace_* event macros.
  - Fix events/<event>/enable permissions.
  - Rename ring-buffer "writer" to "remote".
  - Rename CONFIG_PROTECTED_NVHE_TESTING to PKVM_SELFTEST to align with
    Quentin's upcoming selftest
  - Rebase on 6.13-rc3.

Changes since RFC (https://lore.kernel.org/all/20240805173234.3542917-1-vdonnefort@google.com/)

  - hypervisor trace clock:
     - mult/shift computed in hyp_trace.c. (John)
     - Update clock when it deviates from kernel boot clock. (John)
     - Add trace_clock file.
     - Separate patch for better readability.
  - Add a proper reset interface which does not need to teardown the
    tracing buffers. (Steven)
  - Return -EPERM on trace access. (Steven)
  - Add per-cpu trace file.
  - Automatically teardown and free the tracing buffer when it is empty,
    without readers and not currently tracing.
  - Show in buffer_size_kb if the buffer is loaded in the hypervisor or
    not.
  - Extend tests to cover reset and unload.
  - CC timekeeping folks on relevant patches (Marc)

Vincent Donnefort (24):
  ring-buffer: Introduce ring-buffer remotes
  tracing: Introduce trace remotes
  tracing: Add reset to trace remotes
  tracing: Add init callback to trace remotes
  tracing: Add events to trace remotes
  tracing: Add events/ root files to trace remotes
  tracing: Add helpers to create trace remote events
  ring-buffer: Expose buffer_data_page material
  tracing: Introduce simple_ring_buffer
  tracing: Add a trace remote module for testing
  tracing: selftests: Add trace remote tests
  tracing: load/unload page callbacks for simple_ring_buffer
  tracing: Check for undefined symbols in simple_ring_buffer
  KVM: arm64: Support unaligned fixmap in the nVHE hyp
  KVM: arm64: Add .hyp.data section
  KVM: arm64: Add clock support for the pKVM hyp
  KVM: arm64: Add tracing capability for the pKVM hyp
  KVM: arm64: Add trace remote for the pKVM hyp
  KVM: arm64: Sync boot clock with the pKVM hyp
  KVM: arm64: Add trace reset to the pKVM hyp
  KVM: arm64: Add event support to the pKVM hyp and trace remote
  KVM: arm64: Add hyp_enter/hyp_exit events to pKVM hyp
  KVM: arm64: Add selftest event support to pKVM hyp
  tracing: selftests: Add pKVM trace remote tests

 arch/arm64/include/asm/kvm_asm.h              |   8 +
 arch/arm64/include/asm/kvm_define_hypevents.h |  21 +
 arch/arm64/include/asm/kvm_hyp.h              |   1 -
 arch/arm64/include/asm/kvm_hypevents.h        |  41 +
 arch/arm64/include/asm/kvm_hyptrace.h         |  26 +
 arch/arm64/include/asm/sections.h             |   1 +
 arch/arm64/kernel/image-vars.h                |   6 +
 arch/arm64/kernel/vmlinux.lds.S               |  36 +-
 arch/arm64/kvm/Kconfig                        |  18 +
 arch/arm64/kvm/Makefile                       |   2 +
 arch/arm64/kvm/arm.c                          |  11 +
 arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h   |  13 +
 arch/arm64/kvm/hyp/include/nvhe/clock.h       |  16 +
 .../kvm/hyp/include/nvhe/define_events.h      |  21 +
 arch/arm64/kvm/hyp/include/nvhe/trace.h       |  59 ++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   1 +
 arch/arm64/kvm/hyp/nvhe/clock.c               |  65 ++
 arch/arm64/kvm/hyp/nvhe/events.c              |  36 +
 arch/arm64/kvm/hyp/nvhe/ffa.c                 |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  86 ++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |   8 +
 arch/arm64/kvm/hyp/nvhe/mm.c                  |   2 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |   5 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   4 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |   5 +-
 arch/arm64/kvm/hyp/nvhe/trace.c               | 286 ++++++
 arch/arm64/kvm/hyp_trace.c                    | 385 ++++++++
 arch/arm64/kvm/hyp_trace.h                    |  11 +
 arch/arm64/kvm/pkvm.c                         |   1 +
 include/linux/ring_buffer.h                   | 102 +-
 include/linux/simple_ring_buffer.h            |  57 ++
 include/linux/trace_remote.h                  |  27 +
 include/linux/trace_remote_event.h            |  33 +
 include/trace/define_remote_events.h          |  73 ++
 kernel/trace/Kconfig                          |  14 +
 kernel/trace/Makefile                         |  19 +
 kernel/trace/remote_test.c                    | 259 +++++
 kernel/trace/remote_test_events.h             |  10 +
 kernel/trace/ring_buffer.c                    | 254 ++++-
 kernel/trace/simple_ring_buffer.c             | 404 ++++++++
 kernel/trace/trace.c                          |   2 +-
 kernel/trace/trace.h                          |   6 +
 kernel/trace/trace_remote.c                   | 920 ++++++++++++++++++
 .../ftrace/test.d/remotes/buffer_size.tc      |  24 +
 .../selftests/ftrace/test.d/remotes/functions |  33 +
 .../ftrace/test.d/remotes/pkvm/buffer_size.tc |  10 +
 .../ftrace/test.d/remotes/pkvm/reset.tc       |  10 +
 .../ftrace/test.d/remotes/pkvm/trace_pipe.tc  |  10 +
 .../ftrace/test.d/remotes/pkvm/unloading.tc   |  10 +
 .../selftests/ftrace/test.d/remotes/reset.tc  | 105 ++
 .../ftrace/test.d/remotes/trace_pipe.tc       |  57 ++
 .../ftrace/test.d/remotes/unloading.tc        |  36 +
 52 files changed, 3599 insertions(+), 53 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_define_hypevents.h
 create mode 100644 arch/arm64/include/asm/kvm_hypevents.h
 create mode 100644 arch/arm64/include/asm/kvm_hyptrace.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/clock.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/define_events.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/trace.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/clock.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/events.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/trace.c
 create mode 100644 arch/arm64/kvm/hyp_trace.c
 create mode 100644 arch/arm64/kvm/hyp_trace.h
 create mode 100644 include/linux/simple_ring_buffer.h
 create mode 100644 include/linux/trace_remote.h
 create mode 100644 include/linux/trace_remote_event.h
 create mode 100644 include/trace/define_remote_events.h
 create mode 100644 kernel/trace/remote_test.c
 create mode 100644 kernel/trace/remote_test_events.h
 create mode 100644 kernel/trace/simple_ring_buffer.c
 create mode 100644 kernel/trace/trace_remote.c
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/buffer_size.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/functions
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/pkvm/buffer_size.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/pkvm/reset.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace_pipe.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/pkvm/unloading.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/reset.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/unloading.tc


base-commit: 02ddfb981de88a2c15621115dd7be2431252c568
-- 
2.49.0.967.g6a0df3ecc3-goog

