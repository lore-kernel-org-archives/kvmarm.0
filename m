Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B314A44471D
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567725; cv=none; b=KfrU2BSdcF4aTsERl8F1wtoBLEAVoFumBggmis0KyMb1MUPrdSjrSuvKtf3RIzsK1pR8H4uNdx8bP3YoWZnSXbwL9qS6F2JXuHWmR091ArnqmFq+siIzwEHhmpaP4DN5YlYH2O/WSaXxxOfxzF/O+ZMMXSqim9zRcFzwfS9/RA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567725; c=relaxed/simple;
	bh=lSFwTkG/z8NsWhQtdgMZQMFvJ0uxXEOOmNAsyakMzeg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=d1+tvJHHPkG2CH6Bmo358JQ67HbodAvWJy57jEebj+RChe5uyj0ANMaond1OQWfwyIDQkanMPKqvESXmOSgKhzzkAgAepi2J5LRAOojufn1rlJZj5zc9JgL3xHqrK7jbXPs6MCm/yh8ZqVHNoN7/B0dC6bceL5YaTCQXjeUx5zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HPi/0ZMJ; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HPi/0ZMJ"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-473bc66c837so8705072f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567718; x=1785172518; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UVoemQnQmJJ0JZcsgNr0OJzMZbKjQ12R/fuSO3309Tk=;
        b=HPi/0ZMJg0cYDdN8eArZrGC+l+B5yTVf44dTRIoVbc0CnwffZn6SBli8yK5VpKDilJ
         x41qbGabTsX/xq1f9f/zpoRkiDG7rDNNEaFzABeTVNKowK+EvJtGr2lz2Js0hGlqP5lF
         mEH7kFDjMHJ0RJoNR5t6awo/bRJDn8ZHAtSaXvXmegAK0v4eRQTTUsrLmRmtGf3B30cK
         ybM3z0gQuyHODKU2Vmlr8HiyI1dzTKuHSXlfYAm93KPR17/qagfJH6U6+OhTjBCbLiJd
         6ofpCzgqMjLoUmA2Zt+DIck4Ev7J30AeEaRQPttdmQKv3OyDI00UfeEI3PiQtWoH3FVE
         bd+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567718; x=1785172518;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UVoemQnQmJJ0JZcsgNr0OJzMZbKjQ12R/fuSO3309Tk=;
        b=eq31mCGJFde73dpzoLj/V/lLVkbeT9H5AXeXUaqdfSp9HXYyQH/btF4Y55JRCx1NdL
         G5MpkMVmUe/EiY/CJ19ci0Wj2Bkw3BbdHTrvPlWB1xV5ubPgu1qyrIMQbe3/CYJ9V7Zs
         hxuqYzBgPmWNqKfpviC+l2W8zLXvGhvK+nVfnjhCAEo+IlFPj4krjFxBGgUE3i1K4Fvv
         E63VZOzL5grihjkib1OEmeOHQkRTb+0hgCNWrwz+wlq+zm/kPpKTPDBYAYuwcnPdjwT1
         2lnh9VzIZpPfKINgbQclPFPzpbsPsUW4tp55Aa8yNHCrALWGmlQe8+c+nd1qZHtSoXHn
         +OAA==
X-Forwarded-Encrypted: i=1; AHgh+RqEs2TbQ3CATnfRwASVFihMqil8P+QhBRXF+wm0gBa+/T3mCnTKv5vOInB32um/xCR1DtBCI7g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yznv/lkY7MgkeVd1wpf5u2nwyknfFJZwWX9dPjXXyyhoxwZlkUK
	IaJuL8VeThG7XOpYMA9PG7wvK9G9pJA6DPK7eyXzNQtNCSH470q/e6wNsvezB/Kuah/s1XxgJjP
	IyDD7vNvVMdAUsyleZEwzig==
X-Received: from wruj14.prod.google.com ([2002:a5d:618e:0:b0:462:70f1:9ee8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e195:0:b0:475:a4ae:e630 with SMTP id ffacd0b85a97d-47f623364bfmr18006292f8f.37.1784567717745;
 Mon, 20 Jul 2026 10:15:17 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:14:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-1-vdonnefort@google.com>
Subject: [PATCH v3 00/17] KVM: arm64: Introduce pKVM hypervisor heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

pKVM historically lacked a dynamic memory allocator: all hypervisor-side
VM and VCPU structures had to be sized on the host, allocated as
contiguous pages and donated to the hypervisor.

This design tightly coupled the hypervisor's memory footprint to
host-side constraints, complicated memory reclaim, and severely
restricted VM scalability.

This patch series introduces a dynamically-mapped custom heap allocator
(hyp_allocator) to the pKVM hypervisor. The initial users are the
pkvm_hyp_vm and pkvm_hyp_vcpu structs, and the hypervisor tracing
metadata.

In the near future, this heap allocator is expected to be leveraged to
support SVE in protected VMs and in the distant future, it will also
support dynamic device assignment.

By moving to a hypervisor-managed dynamic allocator, we also allow
deduplicating the donation/reclaim path of EL2-private structures.

The main building blocks for this series are:

1. pkvm_hyp_req:
----------------
When the hypervisor heap allocator goes out of memory (-ENOMEM), it
suspends the hypercall, embeds a PKVM_HYP_REQ_HYP_ALLOC top-up request
into the SMCCC HVC return registers, and exits back to the host.

This building block will also be useful for the future huge-mapping
support in protected guests, allowing EL2 to raise requests such as
block splitting back to the host.

2. hyp_allocator:
----------------
This heap allocator manages a reserved VA space range, dynamically
mapping and unmapping physical pages on-demand to minimise the pKVM
hypervisor footprint. As memory is reclaimed and relinquished to the
host, unmapped holes are introduced within the VA space. To prevent
orphan mapped regions, neighboring unused chunks cannot be merged if
they are separated by an unmapped region.

The allocator chunk metadata is stored directly into the VA space range.
To minimize metadata overhead, chunks only link to each other via a
relative 32-bit offset.

A simple hardening of the metadata is added via a simple 32-bit hash.

3. shrinker:
------------
As the heap allocator isn't reclaimed actively on VM or tracing
teardown, a shrinker is added to allow the host to reclaim unused memory
from the hypervisor when the host is under heavy memory pressure.

v2 -> v3:
  - Remove unsafe WARN_ON(hyp_spin_is_locked(&pkvm_pgd_lock)) check in hyp_allocator_alloc() (Sashiko)
  - Modify MIN_ALLOC_SIZE to 16-bytes to comply with FPSIMD alignment requirements (Sashiko)
  - Allow hyp topup/reclaim HVCs pre-deprivilege
  - Add enum symbols to pkvm_hyp_req_handle event (Fuad)
  - Various clarification in commit descriptions (Fuad)
  - Restore unmap_donated_memory() for PGD on error path (Fuad)
  - Renamed __hyp_allocator_map -> pkvm_map_private_va_range (Fuad)
  - Collected Fuad's Reviewed-by tags
  - Rebased on 7.2-rc4

v1 -> v2:
  - Rebased series on 7.2-rc2.
  - Use scope-based hyp_spinlock.
  - Fix best_missing/best_data_size priority in hyp_allocator_find_efficient_chunk() (Sashiko)
  - Fix missing free_hyp_memcache() in pkvm_hyp_topup() (Sashiko)
  - Fix unused selftest_init() warning when !CONFIG_NVHE_EL2_DEBUG (Sashiko)
  - Fix missing shrinker_free() in teardown_hyp_mode() (Sashiko)

v1: https://lore.kernel.org/r/20260520152650.4107895-1-vdonnefort@google.com

Vincent Donnefort (17):
  KVM: arm64: Add pkvm_private_va_range_pa
  KVM: arm64: Add pkvm_remove_mappings
  KVM: arm64: Add pkvm_map_private_va_range
  KVM: arm64: Add a heap allocator for the pKVM hyp
  KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
  KVM: arm64: Add pkvm_hyp_req infrastructure
  KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
  KVM: arm64: Add reclaim interface for the pKVM heap alloc
  KVM: arm64: Add selftests for the pKVM heap allocator
  KVM: arm64: Add a shrinker for pKVM
  KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
  KVM: arm64: Move hyp_vm refcount into the structure
  KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
  KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
  KVM: arm64: Reject hyp trace descriptors with fewer CPUs than
    hyp_nr_cpus
  KVM: arm64: Reject hyp trace descriptors with fewer than 3 pages
  KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator

 arch/arm64/include/asm/kvm_asm.h           |    4 +
 arch/arm64/include/asm/kvm_host.h          |   14 +-
 arch/arm64/include/asm/kvm_mmu.h           |    3 +
 arch/arm64/include/asm/kvm_pkvm.h          |  102 ++
 arch/arm64/kvm/arm.c                       |    2 +
 arch/arm64/kvm/hyp/hyp-constants.c         |    2 -
 arch/arm64/kvm/hyp/include/nvhe/alloc.h    |   24 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h       |    3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |   19 +-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h |    4 +
 arch/arm64/kvm/hyp/nvhe/Makefile           |    2 +-
 arch/arm64/kvm/hyp/nvhe/alloc.c            | 1223 ++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  124 +-
 arch/arm64/kvm/hyp/nvhe/mm.c               |   51 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c             |  100 +-
 arch/arm64/kvm/hyp/nvhe/setup.c            |    6 +
 arch/arm64/kvm/hyp/nvhe/trace.c            |   70 +-
 arch/arm64/kvm/hyp_trace.c                 |   15 +-
 arch/arm64/kvm/mmu.c                       |    4 +-
 arch/arm64/kvm/pkvm.c                      |  159 ++-
 arch/arm64/kvm/trace_pkvm.h                |   45 +
 21 files changed, 1831 insertions(+), 145 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c
 create mode 100644 arch/arm64/kvm/trace_pkvm.h


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.55.0.229.g6434b31f56-goog

