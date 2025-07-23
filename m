Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EE5248897
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267638; cv=none; b=fINPNK3Aef/9iRC5sLsGRvKNIrEg8kFTa9YcAPo5AmVTM09XuKWskHHsXixnGWyxSAyPdKFXFNQIhQut/WTymluUzLjZOhQAiEHMP9F8Foq8juy3vlWzlWOr/kv9PHerHCkCmd/t7u2puLhjdbgHGzdkt7Y3ta0Z8i+MzxBjDcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267638; c=relaxed/simple;
	bh=HWvZky1qMx/mo2bgy4sdkXFjDXSB0hJpLlSaYWm8CpY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=awFhMIs1yS8UNwk9GGoKhf94QX615k6etrZz+mRLr8YxM/OndELxwQC24bUT9ZipnuFLSI1qd8wlojpCYKwM9WSOxZYX/udbmWmUpnJ0fuUOcbhT6yt5Q5PXnYTAD+Tric9HZEZXtuE24UoExD4cz3wAOQ/H+BmBFLuaA7ITBbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q+7hgSvX; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q+7hgSvX"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-455e9e09afeso28536845e9.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267635; x=1753872435; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=57m6jReu/89PVW3YULNXA1rx8Q7Z0K2J7QywXGEHimQ=;
        b=Q+7hgSvXtlxhEGvaNgumKRf5LzRZxxUYwMz4D0ePOgoVHjOcmYYtlRgT4hpWjnr4LA
         FL74claQAwFQJEdtH6Pi03ePv7eqAqA3QeufqwG9z2j9LbQKpIN33+PRklKpsK8D5eQu
         p83G33AziKm7dc/uTR0pX4UXUtJAsQOhHiI+XFjFh2ztlwdy2/1QWc91IOlNQkymLIiO
         FDd7DetQzkyveGXhaCRRfIhtLKu0+x5+NqhgAthURH0c4cWmvq+CVi6UKe5aQ0DD5PEB
         Qv0gGyO2vSm4DtZlTJ8MH1KRRs0Ql4R1hLEZjd2cMDA9FZcd9enx5RGqy5hOXRcqtMdI
         4nZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267635; x=1753872435;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=57m6jReu/89PVW3YULNXA1rx8Q7Z0K2J7QywXGEHimQ=;
        b=ipcdpt/JxL2JZUSh3qkLUGDG/mFcQk4Dpa/giNOPQ/9MMIS7r889YFkwS1i2zJEpAC
         5HaU7YXSrc4tI5YG67VfZ1XCbmVhGFHhfbKIcF33yZYVO1wT0TKuiaS770Jt/5qN68BZ
         xTLH+jVlGgy5HsjAb5skj63lK2ncc5GBm+GDhUHfUfMZ009I4ITMKVKX0QLtci+vld3n
         DVPeCe8MYU4nagJU5jD82do/8tMia9NWXTYNOrr6zNMEPa2qDzOiV4QvwNI8ISKWXAsD
         9OfEkfALgKbl4nY7dvmopYRsthw5wFfZaf14SPjdruxld5GXPnHbuO9bSBtvGUSoqold
         CVZA==
X-Forwarded-Encrypted: i=1; AJvYcCXjJKcM6mpNJfCQqpqTrVSmwfOMdqj7HYJOwMh4FchxxtSu1Q5CyxR82AYeZCd7VnVElYQP4Xc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsIuRRVJqOrPnjwNr9+8fzTd3T45DkmVC4wpGwpkJtef2DfsQV
	adW5nimUafrTi+dZrDG3Bw5puB6Pjp9aGMrhTJh8EoU2TfND+hsHRjkiW+OgxAi91edmcKA/R/P
	wmw==
X-Google-Smtp-Source: AGHT+IG8guHep8zGOe2nsK6QLt0Shc7PDC8FbYnWdhDsCUpgn83x1Mq6gF7ZIdM6iSjg+GCiMUXCi3Qg1A==
X-Received: from wmbeq10.prod.google.com ([2002:a05:600c:848a:b0:456:257a:e323])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3585:b0:456:8eb:a35c
 with SMTP id 5b1f17b1804b1-45868d6b6d3mr19171885e9.31.1753267635103; Wed, 23
 Jul 2025 03:47:15 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-1-tabba@google.com>
Subject: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Main changes since v15 [1]:

* Rework and simplify Kconfig selection and dependencies.
* Always enable guest_memfd for KVM x86 (64-bit) and arm64, which
  simplifies the enablement checks.
* Based on kvm-x86/next: commit 33f843444e28 ("Merge branch 'vmx'").

This patch series enables host userspace mapping of guest_memfd-backed
memory for non-CoCo VMs. This is required for several evolving KVM use
cases:

* Allows VMMs like Firecracker to run guests entirely backed by
  guest_memfd [2]. This provides a unified memory management model for
  both confidential and non-confidential guests, simplifying VMM design.

* Enhanced Security via direct map removal: When combined with Patrick's
  series for direct map removal [3], this provides additional hardening
  against Spectre-like transient execution attacks by eliminating the
  need for host kernel direct maps of guest memory.

* Lays the groundwork for *restricted* mmap() support for
  guest_memfd-backed memory on CoCo platforms [4] that permit in-place
  sharing of guest memory with the host.

Patch breakdown:

* Patches 1-9: Primarily infrastructure refactoring, Kconfig cleaning,
  and renames to decouple guest_memfd from the concept of "private"
  memory.

* Patches 10-11: Add support for the host to map guest_memfd backed
  memory for non-CoCo VMs, which includes support for mmap() and fault
  handling. This is gated by a new configuration option, toggled by a
  new flag, and advertised to userspace by a new capability (introduced
  in patch 20).

* Patches 12-15: Implement x86 guest_memfd mmap support.

* Patches 16-19: Implement arm64 guest_memfd mmap support.

* Patch 20: Introduce the new capability to advertise this support and
  update the documentation.

* Patches 21-22: Update and expand selftests for guest_memfd to include
  mmap functionality and improve portability.

To test this patch series and boot a guest utilizing the new features,
please refer to the instructions in v8 of the series [5]. Note that
kvmtool for Linux 6.16 (available at [6]) is required, as the
KVM_CAP_GMEM_MMAP capability number has changed, additionally, drop the
--sw_protected kvmtool parameter to test with the default VM type.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250717162731.446579-1-tabba@google.com/
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
[4] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
[5] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/
[6] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-basic-6.16

Ackerley Tng (1):
  KVM: x86/mmu: Rename .private_max_mapping_level() to
    .gmem_max_mapping_level()

Fuad Tabba (15):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: Fix comments that refer to slots_lock
  KVM: Fix comment that refers to kvm uapi header path
  KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
  KVM: guest_memfd: Add plumbing to host to map guest_memfd pages
  KVM: guest_memfd: Track guest_memfd mmap support in memslot
  KVM: arm64: Refactor user_mem_abort()
  KVM: arm64: Handle guest_memfd-backed guest page faults
  KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
  KVM: arm64: Enable support for guest_memfd backed memory
  KVM: Allow and advertise support for host mmap() on guest_memfd files
  KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
  KVM: selftests: guest_memfd mmap() test when mmap is supported

Sean Christopherson (6):
  KVM: x86: Have all vendor neutral sub-configs depend on KVM_X86, not
    just KVM
  KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly from
    KVM_SW_PROTECTED_VM
  KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies iff
    CONFIG_KVM_INTEL_TDX=y
  KVM: x86/mmu: Hoist guest_memfd max level/order helpers "up" in mmu.c
  KVM: x86/mmu: Enforce guest_memfd's max order when recovering
    hugepages
  KVM: x86/mmu: Extend guest_memfd's max mapping level to shared
    mappings

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 203 ++++++++++++-----
 arch/arm64/kvm/nested.c                       |  41 +++-
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |   6 +-
 arch/x86/kvm/Kconfig                          |  26 ++-
 arch/x86/kvm/mmu/mmu.c                        | 143 +++++++-----
 arch/x86/kvm/mmu/mmu_internal.h               |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/svm/sev.c                        |   6 +-
 arch/x86/kvm/svm/svm.c                        |   2 +-
 arch/x86/kvm/svm/svm.h                        |   4 +-
 arch/x86/kvm/vmx/main.c                       |   7 +-
 arch/x86/kvm/vmx/tdx.c                        |   5 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |  11 +
 include/linux/kvm_host.h                      |  38 ++--
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 205 +++++++++++++++---
 virt/kvm/Kconfig                              |  15 +-
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/guest_memfd.c                        |  81 ++++++-
 virt/kvm/kvm_main.c                           |  12 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 26 files changed, 623 insertions(+), 209 deletions(-)


base-commit: 33f843444e28920d6e624c6c24637b4bb5d3c8de
-- 
2.50.1.470.g6ba607880d-goog

