Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA14B239E67
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875279; cv=none; b=hzwFz4MS+YD0C1CJVWDCGcJ/RoxPb30siQEqFmPHxNeTCccxHZnswQK1xU15EBWAKxP1wyUn+/teHYlGbC5YxPJk8yDiGIdhcwA9Syrr5lNv51Mr7IAuDPrFvVaIh//2+X7tWxqECvB87ZRyz/W2hAaCCWZgUwFDRY3E8/L062w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875279; c=relaxed/simple;
	bh=CdKM1gl6kIjyxS8EkDKIGKQsLnoRGhN4OqsunPcs93Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=n48xb22WOLDUnQ+JGchyQ6CQkRzmAWX6eqCzf8QMl88z9wf+h4yPwaD9Tib7NeU+8hv35DKbkIFX2nvHTRwMdkeN3oe2TLGY1W2mewde6BklQ/TUmwgC4Isqog0Rrzd6Q3hvNA/NylrDbG9GCFUhzHvJEKMZEK17A9KOQBZttdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oBqcorod; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oBqcorod"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2697410e7f9so138501025ad.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875277; x=1760480077; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TmMr+35oqSfmP0HZIXQIA/YFMO4f30/qn0vmxY19vhg=;
        b=oBqcorodGJQWMn+3XPPfpsToJpyziGLjSSkQolUpT46N4HhinpWOnWr8mGvO23Or9c
         1AYPteF+UN+C3fMOJoqRBOim3KBDFC/jl50wILxuSLnbMs/v1ka2EMYQhOrpO3CZ11sf
         eWLGGIS/TcijSR1qRsDoe0izCw7UcYkOyrl9MgXaj7mLkG4WZHlbBza6RxclBqStJrY6
         uAApBCFO0wipKF4Sv2+xo7Dl9OoJUNKQdjIAWlM8JgXv0dwXbewJL2i2mCGSOHpPsWQp
         1PsI8jDnexSohEiA5uzh/egtcd28rljG+ODBfdZFDT0SA9nsq8wPalzQ/C85QTZtvuSt
         sLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875277; x=1760480077;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TmMr+35oqSfmP0HZIXQIA/YFMO4f30/qn0vmxY19vhg=;
        b=rnvrTgT13z+6rliSGkkzHVZvHb+CpXCGSnlic2lqXAErUCiexVuepZ+hxgV0Jy1R6X
         cI3PH9WWV0nF9CoDfguRH3QmpTGR0ZZSVuDubkhYFfN1S7rCaypSR4Agu8JQHDNjULcU
         5XuY7Ib6c5sXqe4AtWztit1M8LN2xEdtffk+B2TVrIj3hkfoI/AZIDTKw4bgGiEj17uw
         wTMJTtjN5xWK4cYkzXoJYQo99OXlwF9VVM/A5XjEfsR29jvPbsc/fqHMZvLI2hhpWedR
         Y+SWzeL5ZZvuubJoOVK4KajlMwAJAjgv/eoJ4whDm3SXavFrd1fbYh6hSzCPlqJAil7v
         4EVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqmESw/OGMwBq3sSjm3cP/iaW1mVPOVC8FGMwcZRPefrbYvk/uyz/dk7zpIi6krQOi30LxM6A=@lists.linux.dev
X-Gm-Message-State: AOJu0YygyVwbziSTPhFiq1xeeAsdw/iqIR06tndQTIYx1YHcgLCTEgCj
	KIoqLpOT/L8FKaAz2gI7edTLr7pJy+ed7OBNrMMz3n8CFs/10bmREN9OjZv2bBPqMbsXOphiZQU
	VoB8cJA==
X-Google-Smtp-Source: AGHT+IH40/3oJtT6BLYIY8yrwnu2Bd+0rWeu7YkPyebNcu0Zon9xu4JQyWq3gycTlYxIm/ZLLZj531D/TW0=
X-Received: from pldb2.prod.google.com ([2002:a17:902:ed02:b0:24c:cd65:485c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2350:b0:274:aab9:4ed4
 with SMTP id d9443c01a7336-29027312ffamr15750085ad.57.1759875277026; Tue, 07
 Oct 2025 15:14:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:08 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-1-seanjc@google.com>
Subject: [PATCH v12 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Shivank's series to add support for NUMA-aware memory placement in
guest_memfd.  This is based on:

  https://github.com/kvm-x86/linux.git gmem

which is an unstable topic branch that contains the guest_memfd MMAP fixes
destined for 6.18 (to avoid conflicts), and three non-KVM changes related to
mempolicy that were in previous versions of this series (I want to keep this
version KVM focused, and AFAICT there is nothing left to discuss in the prep
paches).

Once 6.18-rc1 is cut I'll turn "gmem" into a proper topic branch, rebase it,
and freeze the hashes.

v12:
 - Add missing functionality to KVM selftests' existing numaif.h instead of
   linking to libnuma (which appears to have caveats with -static).
 - Add KVM_SYSCALL_DEFINE() infrastructure to reduce the boilerplate needed
   to wrap syscalls and/or to assert that a syscall succeeds.
 - Rename kvm_gmem to gmem_file, and use gmem_inode for the inode structure.
 - Track flags in a gmem_inode field instead of using i_private.
 - Add comments to call out subtleties in the mempolicy code (e.g. that
   returning NULL for vm_operations_struct.get_policy() is important for ABI
   reasons).
 - Improve debugability of guest_memfd_test (I kept generating SIGBUS when
   tweaking the tests).
 - Test mbind() with private memory (sadly, verifying placement with
   move_pages() doesn't work due to the dependency on valid page tables).

- V11: Rebase on kvm-next, remove RFC tag, use Ackerley's latest patch
       and fix a rcu race bug during kvm module unload.
- V10: Rebase on top of Fuad's V17. Use latest guest_memfd inode patch
       from Ackerley (with David's review comments). Use newer kmem_cache_create()
       API variant with arg parameter (Vlastimil)
- v9: Rebase on top of Fuad's V13 and incorporate review comments
- v8: Rebase on top of Fuad's V12: Host mmaping for guest_memfd memory.
- v7: Use inodes to store NUMA policy instead of file [0].
- v4-v6: Current approach using shared_policy support and vm_ops (based on
         suggestions from David [1] and guest_memfd bi-weekly upstream
         call discussion [2]).
- v3: Introduced fbind() syscall for VMM memory-placement configuration.
- v1,v2: Extended the KVM_CREATE_GUEST_MEMFD IOCTL to pass mempolicy.

[0] https://lore.kernel.org/all/diqzbjumm167.fsf@ackerleytng-ctop.c.googlers.com
[1] https://lore.kernel.org/all/6fbef654-36e2-4be5-906e-2a648a845278@redhat.com
[2] https://lore.kernel.org/all/2b77e055-98ac-43a1-a7ad-9f9065d7f38f@amd.com

Ackerley Tng (1):
  KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes

Sean Christopherson (7):
  KVM: guest_memfd: Rename "struct kvm_gmem" to "struct gmem_file"
  KVM: guest_memfd: Add macro to iterate over gmem_files for a
    mapping/inode
  KVM: selftests: Define wrappers for common syscalls to assert success
  KVM: selftests: Report stacktraces SIGBUS, SIGSEGV, SIGILL, and SIGFPE
    by default
  KVM: selftests: Add additional equivalents to libnuma APIs in KVM's
    numaif.h
  KVM: selftests: Use proper uAPI headers to pick up mempolicy.h
    definitions
  KVM: guest_memfd: Add gmem_inode.flags field instead of using
    i_private

Shivank Garg (4):
  KVM: guest_memfd: Add slab-allocated inode cache
  KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
  KVM: selftests: Add helpers to probe for NUMA support, and multi-node
    systems
  KVM: selftests: Add guest_memfd tests for mmap and NUMA policy support

 include/uapi/linux/magic.h                    |   1 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |   2 +-
 .../testing/selftests/kvm/guest_memfd_test.c  |  98 +++++
 .../selftests/kvm/include/kvm_syscalls.h      |  81 +++++
 .../testing/selftests/kvm/include/kvm_util.h  |  29 +-
 tools/testing/selftests/kvm/include/numaif.h  | 110 +++---
 .../selftests/kvm/kvm_binary_stats_test.c     |   4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  55 +--
 .../kvm/x86/private_mem_conversions_test.c    |   9 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |   5 +-
 virt/kvm/guest_memfd.c                        | 344 ++++++++++++++----
 virt/kvm/kvm_main.c                           |   7 +-
 virt/kvm/kvm_mm.h                             |   9 +-
 13 files changed, 576 insertions(+), 178 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h


base-commit: 67033eaa5ea2cb67b6cdaa91d7f5c42bfafb36f7
-- 
2.51.0.710.ga91ca5db03-goog

