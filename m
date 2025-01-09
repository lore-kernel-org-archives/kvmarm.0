Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73255200B95
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 20:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455798; cv=none; b=fkilRFfzE8ZaqvOffjTK7ApIOwAdG7umcgRPgbIBTSS4MZ0FB0t0O6wSYPyeno2E1u8eYtM4MjHtnFnsvI9RT/B2aEuDGQRLwTAVSwZwEsCeETqv9QI/Q84xPtEYAPdUgPS+ZjZvSz13xh6c0bUYdaAdL3owlVcdS6HnTAJpToo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455798; c=relaxed/simple;
	bh=YkgfGnO9YuSs6jW3cToj++wCeLfYHp3+3X5IEmvRJsw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Lk/oKatC2NCHJJfeOhHiZt/e/tZGC1x+GGR0lfT+t/erIwr9w+HlBoTV3waRjRDIsB8ujZxKMWu8y4MDAWzkT7M7OJWODONERKFEgugbEya5GhsLQOUQOZmp7aShiSgrt9zASyv0ZEHQxsYXSa7RXTOqv4DfZWoT7EhQeuF6/4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FhS1DF4L; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FhS1DF4L"
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-8610ad53f70so343254241.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 12:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455795; x=1737060595; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zwxnelFEQr4C3vtPtPgRGtQjenWxHSmpAHQLFMvsChA=;
        b=FhS1DF4LKz+8K0brml/6pbym8TcrqJ0sjpHQoeFhbrx7eAu44IquXRfOFAcWZUwTS2
         QME5vcGk2NQJSX/AAtmjWprn3qsXt1lR6cUjBjNwY0BzgZzIv4STK6v/iUe7CuEmjHU7
         9qBH51sUKqYGFNfrmQaREArDv/ARLAGXqvQGAnzJ2oR0wY5NnGGXHYP9px33eFQki3qV
         DEKaQP87V+Y3ga/NXAdBn5ZZZVfQWe6hkB1hFyD0cJh0PmP7wImB0r8PUK1W5ZjZgWqt
         S6tDxH6m76/ANAXMCm/vmR/vJjz80UHHsxh/wDt5RxoyA35l2roBT1Hplwe5EqTmGd32
         nY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455795; x=1737060595;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zwxnelFEQr4C3vtPtPgRGtQjenWxHSmpAHQLFMvsChA=;
        b=osB3GyigJc7wbTkrY5LIu7kbBLuyW/ztx3rVneDWGeAwUITjtGlLYy6q18jvavXgOC
         81wvY9J5WvHC22cwzX+JMXnhJj6paiOoxJanR4VSTcsltM8g5hsCQkRHJZ6yY2CNUDYy
         Adg5OfCXqUYkSMMwPPI4FNdaLfT051ae1XkuiAny64mKUEXiz6H6W2O0sXmsZJ5nbIv+
         WkE8/r4a716ZOlXh2kFLDj+IkpSa7q/jYypb/vGIA+Cqn05+Dr6Ozls0aDPbsHtDqdEz
         so9RK+l7JWRe/OO0JTVdFc/4h+c3eD6OIbWfopnWsKrnZbLiOvWSBZFEjYsZ1nTgDOh4
         S+Fw==
X-Forwarded-Encrypted: i=1; AJvYcCWbHe7g6zv0KitluR+XROOBTPkaacirxgEejxMoveFo7ZKsYO0L4KUP44X0ql8AMdin7EfMIcY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjo7mHvDsWgzkrQMS55+kjMvgt10KJx4kV9nqE8PxTKBLmQuGk
	0zhLCLx+1sJCDOF1KpOYBHSwd08g3hJimFw7kd9YoMNcYKXyapSaetLdk0IYYkZz+i4oHpLwNac
	VR1cA7uIhizQ0pzMWyw==
X-Google-Smtp-Source: AGHT+IEQb1u/rfnn1fSyPTU2pPIfyZ5lKsGhAlzX80eQpvo3eWAajg+PF8bqh67MyuBcqLLCXncCH9d2iaL7ubsN
X-Received: from vsbbq8.prod.google.com ([2002:a05:6102:5348:b0:4af:b35d:162c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:2b92:b0:4af:f892:e9f0 with SMTP id ada2fe7eead31-4b3d0f2d8f1mr8447963137.14.1736455795460;
 Thu, 09 Jan 2025 12:49:55 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-1-jthoughton@google.com>
Subject: [PATCH v2 00/13] KVM: Introduce KVM Userfault
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This is a v2 of KVM Userfault, mostly unchanged from v1[5]. Changelog here:

v1->v2:
- For arm64, no longer zap stage 2 when disabling KVM_MEM_USERFAULT
  (thanks Oliver).
- Fix the userfault_bitmap validation and casts (thanks kernel test
  robot).
- Fix _Atomic cast for the userfault bitmap in the selftest (thanks
  kernel test robot).
- Pick up Reviewed-by on doc changes (thanks Bagas).

And here is a trimmed down cover letter from v1, slightly modified
given the small arm64 change:

Please see the RFC[1] for the problem description. In summary,
guest_memfd VMs have no mechanism for doing post-copy live migration.
KVM Userfault provides such a mechanism.

There is a second problem that KVM Userfault solves: userfaultfd-based
post-copy doesn't scale very well. KVM Userfault when used with
userfaultfd can scale much better in the common case that most post-copy
demand fetches are a result of vCPU access violations. This is a
continuation of the solution Anish was working on[3]. This aspect of
KVM Userfault is important for userfaultfd-based live migration when
scaling up to hundreds of vCPUs with ~30us network latency for a
PAGE_SIZE demand-fetch.

The implementation in this series is version than the RFC[1]. It adds...
 1. a new memslot flag is added: KVM_MEM_USERFAULT,
 2. a new parameter, userfault_bitmap, into struct kvm_memory_slot,
 3. a new KVM_RUN exit reason: KVM_MEMORY_EXIT_FLAG_USERFAULT,
 4. a new KVM capability KVM_CAP_USERFAULT.

KVM Userfault does not attempt to catch KVM's own accesses to guest
memory. That is left up to userfaultfd.

When enabling KVM_MEM_USERFAULT for a memslot, the second-stage mappings
are zapped, and new faults will check `userfault_bitmap` to see if the
fault should exit to userspace.

When KVM_MEM_USERFAULT is enabled, only PAGE_SIZE mappings are
permitted.

When disabling KVM_MEM_USERFAULT, huge mappings will be reconstructed
consistent with dirty log disabling. So on x86, huge mappings will be
reconstructed, but on arm64, they won't be.

KVM Userfault is not compatible with async page faults. Nikita has
proposed a new implementation of async page faults that is more
userspace-driven that *is* compatible with KVM Userfault[4].

See v1 for more performance details[5]. They are unchanged in this v2.

This series is based on the latest kvm/next.

[1]: https://lore.kernel.org/kvm/20240710234222.2333120-1-jthoughton@google.com/
[2]: https://lpc.events/event/18/contributions/1757/
[3]: https://lore.kernel.org/all/20240215235405.368539-1-amoorthy@google.com/
[4]: https://lore.kernel.org/kvm/20241118123948.4796-1-kalyazin@amazon.com/#t
[5]: https://lore.kernel.org/kvm/20241204191349.1730936-1-jthoughton@google.com/

James Houghton (13):
  KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
  KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
  KVM: Allow late setting of KVM_MEM_USERFAULT on guest_memfd memslot
  KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
  KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
  KVM: arm64: Add support for KVM_MEM_USERFAULT
  KVM: selftests: Fix vm_mem_region_set_flags docstring
  KVM: selftests: Fix prefault_mem logic
  KVM: selftests: Add va_start/end into uffd_desc
  KVM: selftests: Add KVM Userfault mode to demand_paging_test
  KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
  KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd toggle tests
  KVM: Documentation: Add KVM_CAP_USERFAULT and KVM_MEM_USERFAULT
    details

 Documentation/virt/kvm/api.rst                |  33 +++-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          |  26 +++-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  27 +++-
 arch/x86/kvm/mmu/mmu_internal.h               |  20 ++-
 arch/x86/kvm/x86.c                            |  36 +++--
 include/linux/kvm_host.h                      |  19 ++-
 include/uapi/linux/kvm.h                      |   6 +-
 .../selftests/kvm/demand_paging_test.c        | 145 ++++++++++++++++--
 .../testing/selftests/kvm/include/kvm_util.h  |   5 +
 .../selftests/kvm/include/userfaultfd_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  42 ++++-
 .../selftests/kvm/lib/userfaultfd_util.c      |   2 +
 .../selftests/kvm/set_memory_region_test.c    |  33 ++++
 virt/kvm/Kconfig                              |   3 +
 virt/kvm/kvm_main.c                           |  54 ++++++-
 17 files changed, 419 insertions(+), 36 deletions(-)


base-commit: 10b2c8a67c4b8ec15f9d07d177f63b563418e948
-- 
2.47.1.613.gc27f4b7a9f-goog

