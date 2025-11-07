Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DED3016FA
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762508332; cv=none; b=sfQ6akxqaF8sWW0z0x4NtFOsug6xF7tqGQjIlef0v9warhPRnMtv1s5dDGFbRicDD+sjMKUutKxsXbMJ7e472IX2tDc7RkKePobfbUAAWddIvKaoJRSIZPqSoc4ziR+txwf1Ubjtet7JgDULtPPKNuALEi6cQJmxlXvWx9Dt2ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762508332; c=relaxed/simple;
	bh=XWMgBOh3tecE5Cam8h2x8JCUJEw9yCxZol5YPoWu0Zs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=M+pk1KIVVpnkFwvgFnSSisTuZ81Qzuo7H0pG2jVIOP5p49zu7oU3QOsgIKFcUr4fmoi+Ct9HV/oAU3Yp0SNzwdJva5hlwMl3qw+yyfPSGiCWRQM4b2ILQBtc78RO7DRYjFWGMiWKlKENPuNywyg0uU/zEosywCmCvlnw9wiLv3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jTvwhS2a; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jTvwhS2a"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477632c240bso5115445e9.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Nov 2025 01:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762508328; x=1763113128; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wpuwLj40pZ9KCOC1lXwKFxFCPpXg12Gl6Xialk5a7Rs=;
        b=jTvwhS2aSKS/QJ/EReLs7x7o7vmF+zFG/7AblVlj88Q3tTZfIug4xqH+3o7O2hY+fv
         u6E7vr8xaCNW/jGT1Vl43FZyHA6K9NK/4oCuhbnBOAudr3iuhSc/4brpjGaoyHVVIpFF
         +r19PR+JDeQWuFbo0ynVJDefpSomoM5DQ5VaJst2IvN9cIitT9rAg92PMn82stdg6GaD
         mfmmdWHR8BNdT0dn9whiieD9xbvaMw1DO2TypuguzGQuET+9aM8/LCrgTxK/99s5oKba
         h2QMbuzJAPHd3JGLiPqW94JP0/aLVpzq4ZxBC5SCRHX0/x2XWlVbe6qi+gCjz7rkKYbI
         4HEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762508328; x=1763113128;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wpuwLj40pZ9KCOC1lXwKFxFCPpXg12Gl6Xialk5a7Rs=;
        b=m+gvSFR4NpK9JjHbyHMUBeFdLi2Hjhs8VhXC5p5dGquuiUUjjSebGLrEIaCmCAAxXR
         ftsYe9RGntokpb+grvotEuUyD8NHqdbm7b99plSKjuRZTFnjDOEdBrPT3YcnM40YtNXS
         Co8ZxbaYcuirzl4TYgVvJfsPxirBodw+aFE+H0MbwxJcZPmPh2iSkVd38cdEV4zWDJHA
         yTHwjmrwe4I2qc1TjmJSPYN5Ip8alInXm0PfNuDJJCgqKizOLXso4pHLTpf/tq417i7Z
         NiY2rWxZlRr6ePC3y6/WbDqP4yKMjjjJ1QrgtqMhIEM2dUgCpNY60oWHRbUWgBAH2Mhb
         HoTg==
X-Gm-Message-State: AOJu0YzKN/rtLsC9dAmeN+99e/tEL5ppBWSN/GjLam9HWosgjXYgCWqr
	1+KvmbCutzyd8Z5tpKjTo+00lGjZW+1u19jMObrjFgcatmmfl/tEPiUEhpsxt9w6ijR8WI+N4nb
	n1+mE+bGMbNrLD8njl2nXAA==
X-Google-Smtp-Source: AGHT+IGgAYFWG6uwltrMjvytO67rDbbNz4HfAgGdjnhsaI8Fiw0AjF7OiP46Ma/MkPDDVBzTkj7K8xCCDfwO3FyF
X-Received: from wmj4.prod.google.com ([2002:a05:600c:244:b0:477:1022:3342])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c8d:b0:477:4483:f491 with SMTP id 5b1f17b1804b1-4776bc96819mr19032465e9.10.1762508328710;
 Fri, 07 Nov 2025 01:38:48 -0800 (PST)
Date: Fri,  7 Nov 2025 09:38:12 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107093840.3779150-1-vdonnefort@google.com>
Subject: [PATCH v8 00/28] Tracefs support for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
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

   remotes/test
	|-- buffer_size_kb
	|-- events
	|   |-- enable
	|   |-- header_event
	|   |-- header_page
	|   `-- test
	|       `-- selftest
	|           |-- enable
	|           |-- format
	|           `-- id
	|-- per_cpu
	|   `-- cpu0
	|       |-- trace
	|       `-- trace_pipe
	|-- trace
	|-- trace_pipe
	|-- tracing_on

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

Changes since v7
   - Add missing EXPORT_SYMBOL_GPL for remote_test.ko
   - Rebase on 6.18-rc4

Changes since v6

  - Add requires field to the selftest (Masami)
  - Use guard() for ring_buffer_poll_remote (Steven)
  - Rename ring_buffer_remote() to ring_buffer_alloc_remote() (Steven)
  - kerneldoc for trace_buffer_remote and simple_ring_buffer (Steven)
  - Validate trace_buffer_desc size in trace_remote_alloc_buffer
    (Steven)
  - Add non-consuming ring-buffer read (Steven)
  - Add spinning failsafe in simple_ring_buffer (Steven)
  - Range check for hyp_trace_desc::bpages_backing_* in hyp_trace_desc_validate()
  - unsigned int cpu in hyp_trace_desc_validate()
  - Fix event/format file
  - Add tests with an offline CPU
  - Add tests for non-consuming read
  - Add documentation
  - Rebase on 6.17

Changes since v5 (https://lore.kernel.org/all/20250516134031.661124-1-vdonnefort@google.com/)

  - Add tishift lib to the hyp (Aneesh)
  - Rebase on 6.17-rc2

Changes since v4 (https://lore.kernel.org/all/20250506164820.515876-1-vdonnefort@google.com/)

  - Extend meta-page with pages_touched and pages_lost
  - Create ring_buffer_types.h
  - Fix simple_ring_buffer build for 32-bits arch and x86
  - Try unload buffer on reset (+ test)
  - Minor renaming and comments

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

Vincent Donnefort (28):
  ring-buffer: Add page statistics to the meta-page
  ring-buffer: Store bpage pointers into subbuf_ids
  ring-buffer: Introduce ring-buffer remotes
  ring-buffer: Add non-consuming read for ring-buffer remotes
  tracing: Introduce trace remotes
  tracing: Add reset to trace remotes
  tracing: Add non-consuming read to trace remotes
  tracing: Add init callback to trace remotes
  tracing: Add events to trace remotes
  tracing: Add events/ root files to trace remotes
  tracing: Add helpers to create trace remote events
  ring-buffer: Export buffer_data_page and macros
  tracing: Introduce simple_ring_buffer
  tracing: Add a trace remote module for testing
  tracing: selftests: Add trace remote tests
  Documentation: tracing: Add tracing remotes
  tracing: load/unload page callbacks for simple_ring_buffer
  tracing: Check for undefined symbols in simple_ring_buffer
  KVM: arm64: Support unaligned fixmap in the pKVM hyp
  KVM: arm64: Add clock support for the pKVM hyp
  KVM: arm64: Add tracing capability for the pKVM hyp
  KVM: arm64: Add trace remote for the pKVM hyp
  KVM: arm64: Sync boot clock with the pKVM hyp
  KVM: arm64: Add trace reset to the pKVM hyp
  KVM: arm64: Add event support to the pKVM hyp and trace remote
  KVM: arm64: Add hyp_enter/hyp_exit events to pKVM hyp
  KVM: arm64: Add selftest event support to pKVM hyp
  tracing: selftests: Add pKVM trace remote tests

 Documentation/trace/index.rst                 |   11 +
 Documentation/trace/remotes.rst               |   59 +
 arch/arm64/include/asm/kvm_asm.h              |    8 +
 arch/arm64/include/asm/kvm_define_hypevents.h |   21 +
 arch/arm64/include/asm/kvm_hyp.h              |    1 -
 arch/arm64/include/asm/kvm_hypevents.h        |   41 +
 arch/arm64/include/asm/kvm_hyptrace.h         |   26 +
 arch/arm64/kernel/image-vars.h                |    4 +
 arch/arm64/kernel/vmlinux.lds.S               |   18 +
 arch/arm64/kvm/Kconfig                        |   18 +
 arch/arm64/kvm/Makefile                       |    2 +
 arch/arm64/kvm/arm.c                          |    4 +
 arch/arm64/kvm/hyp/include/nvhe/arm-smccc.h   |   13 +
 arch/arm64/kvm/hyp/include/nvhe/clock.h       |   16 +
 .../kvm/hyp/include/nvhe/define_events.h      |   21 +
 arch/arm64/kvm/hyp/include/nvhe/trace.h       |   60 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |    3 +-
 arch/arm64/kvm/hyp/nvhe/clock.c               |   65 +
 arch/arm64/kvm/hyp/nvhe/events.c              |   36 +
 arch/arm64/kvm/hyp/nvhe/ffa.c                 |    2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   86 ++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S             |    6 +
 arch/arm64/kvm/hyp/nvhe/mm.c                  |    2 +-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c          |    5 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |    5 +-
 arch/arm64/kvm/hyp/nvhe/trace.c               |  292 ++++
 arch/arm64/kvm/hyp_trace.c                    |  386 +++++
 arch/arm64/kvm/hyp_trace.h                    |   11 +
 fs/tracefs/inode.c                            |    1 +
 include/linux/ring_buffer.h                   |   58 +
 include/linux/ring_buffer_types.h             |   41 +
 include/linux/simple_ring_buffer.h            |  120 ++
 include/linux/trace_remote.h                  |   92 ++
 include/linux/trace_remote_event.h            |   33 +
 include/trace/define_remote_events.h          |   73 +
 include/uapi/linux/trace_mmap.h               |    8 +-
 kernel/trace/Kconfig                          |   14 +
 kernel/trace/Makefile                         |   20 +
 kernel/trace/remote_test.c                    |  259 ++++
 kernel/trace/remote_test_events.h             |   10 +
 kernel/trace/ring_buffer.c                    |  356 ++++-
 kernel/trace/simple_ring_buffer.c             |  468 ++++++
 kernel/trace/trace.c                          |    2 +-
 kernel/trace/trace.h                          |    6 +
 kernel/trace/trace_remote.c                   | 1318 +++++++++++++++++
 .../ftrace/test.d/remotes/buffer_size.tc      |   25 +
 .../selftests/ftrace/test.d/remotes/functions |   88 ++
 .../ftrace/test.d/remotes/pkvm/buffer_size.tc |   11 +
 .../ftrace/test.d/remotes/pkvm/reset.tc       |   11 +
 .../ftrace/test.d/remotes/pkvm/trace.tc       |   11 +
 .../ftrace/test.d/remotes/pkvm/trace_pipe.tc  |   11 +
 .../ftrace/test.d/remotes/pkvm/unloading.tc   |   11 +
 .../selftests/ftrace/test.d/remotes/reset.tc  |   90 ++
 .../selftests/ftrace/test.d/remotes/trace.tc  |  127 ++
 .../ftrace/test.d/remotes/trace_pipe.tc       |  127 ++
 .../ftrace/test.d/remotes/unloading.tc        |   41 +
 56 files changed, 4592 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/trace/remotes.rst
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
 create mode 100644 include/linux/ring_buffer_types.h
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
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/pkvm/trace_pipe.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/pkvm/unloading.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/reset.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/trace.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/trace_pipe.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/remotes/unloading.tc


base-commit: dc77806cf3b4788d328fddf245e86c5b529f31a2
-- 
2.51.2.1041.gc1ab5b90ca-goog

