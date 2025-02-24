Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1CB2571C1
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399327; cv=none; b=kBnBAy8raP11FzbZ8tRu3O5WRh7tIS4lO6d7nVrl4mwO4Jc/aWCOjSIXP3gEAVutBtm2Y0xZYqS1VGtY3x2b+VaajPcVLu3gIfMA19PpkGYVzW/QrDgL6AF9woQYUXVF5u0dInqJS8frDAZgOg6PrWQyFR7vTG78xL4IEJiG4N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399327; c=relaxed/simple;
	bh=nKmWAe63Mj68yOOXWVXWh9b+a5whjJ9Og9jru54EyS4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cfFUeaREoqbbhsh1r9nZ4PoKOhFE9XaSTds9mubwIPX59+ApXRzyXQy/88uOSSeauJXHDynh+Jx5fVF4zTxP0GdUncAGwNKT4ovYQ/F/iaph0x7NeQq+2eyar9erXntJyN0svg38vm/Ahn6xBwkgxIg/kCq7Z7S0YmatKDgUEYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tSvv50qC; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tSvv50qC"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43935e09897so30757795e9.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 04:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740399324; x=1741004124; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LzaC9vqP6kUjpCy0JlsAsL71itZdwLUiOfQB7eqyz9I=;
        b=tSvv50qCmOI9dDdejK2gO2Bv+Dk7hupY7L3xWMnWKTYe0IDbWqYvXTg/89RRwhv7v4
         9Q6rKhwsWuh6RNkSTFwrMFERvx8Ftt1w0ZWCmIiPbWJhmmPysCnyzYEZbG0yBBf/QKx7
         gVFUtX0ZbYxgmWoL6NlOhpPwQcYBDxE/MbDqhgk+dJWuXCVz6SfXXLLWRlKquIb3nmpY
         tyd0/PKH6t281Y0lV9Agb8eiQFEF1/EAc8PVbm2a4r+44+L5jfp4nfX/dJcJN1cU+Wkb
         6TrtN3TzA0sotVvVaNYPLZ7IyNC/aX0rc6hKpjT8+VqmlFFfjsGXqrfYgzUwdRqRoZqr
         IA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399324; x=1741004124;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LzaC9vqP6kUjpCy0JlsAsL71itZdwLUiOfQB7eqyz9I=;
        b=kY30mL/XsM5FhzlUypf44RXjzfmG7ozb0aZaGoIQAecq3tfwnbSwk9Mr2HmuiO9rO1
         VhGj6MaxlIuRlGUENtO743KNNwJ1ka/LOB8M7C+HZr66JilOu1hnFx4Fg3xckhL6bi9A
         69omyjxntB7SBXhVW6pPDJKbGDlkJOrVgahSNYrBTuhyrTQnpVUYsvYsoOCAedCqgFJe
         UK9/lXzs61mm2DY2Ry6K0bgpgbmpxK2ar0h+BUSPskhxsN9nMwL6a0exUllOp1sn5Uw0
         u7c4ffrSMujdfvpSq8tDGDhz4QUAilDcWjElHee9+dZA+xEplYtuCR/+3mFYyY3j5Mwm
         0AyQ==
X-Gm-Message-State: AOJu0YwX92RM1RuiuGYXK/9y8WhfBMyzSKGmIEBQWulFXEpQ4dmD87uD
	kYo1gnmfeLLqp1t95DPd/Nbjh2CUvAGsWNn52POa6zb3vN9lY5iJxInKV3D917v5n2IsKgS2l+K
	K9EMG/t+vnExFIbuuMw==
X-Google-Smtp-Source: AGHT+IGq7Ah+/9K65lRrSXhYF3LTy/vPYkKHPnaPYRlmgY1IoCrtf1gy8Og3tpRwyNmKnBlWZvFn3mXAiXiNSkKi
X-Received: from wmbfp16.prod.google.com ([2002:a05:600c:6990:b0:439:9379:38c7])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1ca3:b0:439:6e12:fdb4 with SMTP id 5b1f17b1804b1-43aae9b6c73mr12266695e9.14.1740399324109;
 Mon, 24 Feb 2025 04:15:24 -0800 (PST)
Date: Mon, 24 Feb 2025 12:13:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224121353.98697-1-vdonnefort@google.com>
Subject: [PATCH 00/11] Tracefs support for pKVM
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

This series introduces a method to create events and to generate them
from the hypervisor (hyp_enter/hyp_exit given as an example) as well as
a Tracefs user-space interface to read them.

A presentation was given on this matter during the tracing summit in
2022. [1]

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

4. Limitations:
---------------

Non-consuming reading of the buffer isn't supported (i.e. cat trace ->
-EPERM) due to current the lack of support in the ring-buffer meta-page.

[1] https://tracingsummit.org/ts/2022/hypervisortracing/
[2] https://lore.kernel.org/all/20240510140435.3550353-1-vdonnefort@google.com/

Changes since v2: https://lore.kernel.org/all/20250108114536.627715-1-vdonnefort@google.com/

  - Fix ring-buffer remote reset
  - Fix fast-forward in rb_page_desc()
  - Refactor nvhe/trace.c
  - struct hyp_buffer_page more compact
  - Add a struct_len to trace_page_desc
  - Extend reset testing
  - Rebase on 6.14-rc3

Changes since v1: https://lore.kernel.org/all/20240911093029.3279154-1-vdonnefort@google.com/

  - Add 128-bits mult fallback in the unlikely event of an overflow. (John)
  - Fix ELF section sort.
  - __always_inline trace_* event macros.
  - Fix events/<event>/enable permissions.
  - Rename ring-buffer "writer" to "remote".
  - Rename CONFIG_PROTECTED_NVHE_TESTING to PKVM_SELFTEST to align with
    Quentin's upcoming selftest
  - Rebase on 6.13-rc3.

Changes since RFC: https://lore.kernel.org/all/20240805173234.3542917-1-vdonnefort@google.com/

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

Vincent Donnefort (11):
  ring-buffer: Introduce ring-buffer remote
  ring-buffer: Expose buffer_data_page material
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
 arch/arm64/include/asm/kvm_define_hypevents.h |  61 ++
 arch/arm64/include/asm/kvm_hyp.h              |   1 -
 arch/arm64/include/asm/kvm_hypevents.h        |  41 +
 arch/arm64/include/asm/kvm_hypevents_defs.h   |  41 +
 arch/arm64/include/asm/kvm_hyptrace.h         |  37 +
 arch/arm64/kernel/image-vars.h                |   4 +
 arch/arm64/kernel/vmlinux.lds.S               |  18 +
 arch/arm64/kvm/Kconfig                        |  10 +
 arch/arm64/kvm/Makefile                       |   2 +
 arch/arm64/kvm/arm.c                          |   6 +
 arch/arm64/kvm/hyp/hyp-constants.c            |   4 +
 arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h   |  13 +
 arch/arm64/kvm/hyp/include/nvhe/clock.h       |  16 +
 .../kvm/hyp/include/nvhe/define_events.h      |  21 +
 arch/arm64/kvm/hyp/include/nvhe/trace.h       |  60 ++
 arch/arm64/kvm/hyp/nvhe/Makefile              |   1 +
 arch/arm64/kvm/hyp/nvhe/clock.c               |  65 ++
 arch/arm64/kvm/hyp/nvhe/events.c              |  36 +
 arch/arm64/kvm/hyp/nvhe/ffa.c                 |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  85 ++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |   6 +
 arch/arm64/kvm/hyp/nvhe/mm.c                  |   2 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |  14 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |   5 +-
 arch/arm64/kvm/hyp/nvhe/trace.c               | 628 +++++++++++
 arch/arm64/kvm/hyp_events.c                   | 159 +++
 arch/arm64/kvm/hyp_trace.c                    | 985 ++++++++++++++++++
 arch/arm64/kvm/hyp_trace.h                    |  15 +
 include/linux/ring_buffer.h                   | 100 +-
 kernel/trace/ring_buffer.c                    | 252 ++++-
 tools/testing/selftests/hyp-trace/Makefile    |   6 +
 tools/testing/selftests/hyp-trace/config      |   4 +
 .../selftests/hyp-trace/hyp-trace-test        | 264 +++++
 34 files changed, 2921 insertions(+), 51 deletions(-)
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


base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
-- 
2.48.1.601.g30ceb7b040-goog

