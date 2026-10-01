Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEC751E424
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864942; cv=none; b=Gz0p9h6vf/CZHZekG7KEysftTccsvERVscHmFU2lpKco1+c1cUAqbiEcVuzRwUcJ6HNF8DMcYp56+9sGIO9yFmDOOkt5WG7F8l+9MIuFqlFcksQsGV2ydjZCl4xnPt6pi/3tZF5352jdGsVSJDLPefX8iA7xwTQP7pdviS43Fe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864942; c=relaxed/simple;
	bh=EJRZP6A0svwCD48GCGWR+DNLakeWijI3BzaJSrSsxVw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YxeR1FofMDgLuUAh9CeiAWyUfWUb3v5IhhHmfLQEEVOSujIc3yHzRE7AYQOk+USmvg4bcrvKFeYlfRBshkqa3m2pgLIUC8FGkXkpxuHqor04iHLyfEoUlmuwds9zVIPOc/VlHfOr4VEwjiTsE0yro/YgDkT9VrDP1An4sJTFg4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HVSQ92HD; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HVSQ92HD"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49953abe51fso43263845e9.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864935; x=1791469735; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WeoJSJ0MqyLbtcMbjfaohWji+oxZtM4gtXCKIX1KQ+4=;
        b=HVSQ92HDyu9sy/SZl6aSXQF5QRFzqR2I5q/i0XciacrNjRHvPeJv7cbIYrSkRONT1N
         trqUhKStiNpvjClDPTGjhZrdS1phemCIN+FYYfPqGlH1vxe2ihxmye9YvB1pnGuWkAeV
         OFI423NxZYkFWxA/u6BF3LPdC7In4u+IHaWkmZfOjzMe6HNWAX1Zmbtj4syNK9U81aYw
         H2rqPwxtPrzk0KSJBkveqrkWCVvGh+lTo2Mo6If2hZ6+4NoswqyU+k9EsfdzlyEgpspo
         +KhTfluDczWp7s+G2myYiwt/NCqRBf9PbtDU/ZqwUYIvkIB80bABpnvy8eVGZdcWoT2B
         fz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864935; x=1791469735;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WeoJSJ0MqyLbtcMbjfaohWji+oxZtM4gtXCKIX1KQ+4=;
        b=Ck+3zcfD98Nupy0vX4IX2xpd9GguM7HeMir/VDw7Mf0U7gFxg2PR/j8ZIb8B7K0vxK
         foNZOWfuftSHBzA8OFrViR1w75mvGGIFyBF9zLyGVVRKFuZ9+11DWB7rZaGZlI0qOUM5
         rTl7ANyCL4/4sa2EQNnvr5oGt4D3ykHbHX9KBZzNZ01GgAlvlYjzYNBKoBzaxjwjO3rH
         BYBQssXR4afNh/DpkQ9oQTVvC9VoBkoKnz1kiOOdie14P7I8paWYEDsOby6gbvYY+Pax
         DeeOSi/hhAhxXcwXr3XlzClMs/QfrfMfOgOduCGN0Vdrqxj5fWo+7+N4GglSSeBzHWmC
         qumg==
X-Forwarded-Encrypted: i=1; AKwUvBwz6CmdRvbGX0NHHVGh/mTa5BTi7ffHsTGBD8EdoSXS3Ict2Xo2T5PPG3ggLoUR2CFLJCrscGc=@lists.linux.dev
X-Gm-Message-State: AFuF++mVJqCDPX6E8FXodr0V69wU3Hu6MAZutq4uUFA5Aiw57wdK0soV
	/Ldwj5KeJdk7tnTQxNkcNQZTEiLb98r3ssvlAHv09WUbTeLlBsfn6rh6ogFKTiPRyObl+vUt44Q
	KnNvb6mY000CEeht4I27kUA==
X-Received: from wmjk10.prod.google.com ([2002:a7b:c30a:0:b0:4a0:bfe:d59c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46d0:b0:49f:fc26:c2d2 with SMTP id 5b1f17b1804b1-4a01b00c5c5mr84075235e9.22.1790864934263;
 Thu, 01 Oct 2026 07:28:54 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-1-vdonnefort@google.com>
Subject: [PATCH v6 00/18] KVM: arm64: Introduce pKVM hypervisor heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
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

Changelog
---------

v6:

  - Rebased on kvm-arm64/hyp-type-checking-7.4
  - make __pkvm_hyp_alloc_selftest pre-deprivilege only (Sashiko)
  - Remove __hyp_private_va_start for __io_map_next to ease merge.
  - Fix sparse NULL pointer warnings in hyp_allocator_map() and hyp_allocator_create_chunk()

v5:

  - Remove unreachable !prev checks in hyp_allocator_destroy_chunk() (Fuad)
  - Add kerneldoc to pkvm_call_hyp_req() (Fuad)
  - Avoid duplicate handle___pkvm_hyp_alloc_selftest() definitions when !CONFIG_NVHE_EL2_DEBUG
  - Chunk pkvm_hyp_reclaim() with cond_resched() to avoid blocking in EL2
  - Allow shrinker to scan across all runtime topup IDs
  - Reclaim chunks before draining allocator->mc in hyp_allocator_reclaim() (Fuad)
  - Make is_ttbr1_addr() check in __kern_hyp_va() conditional to pKVM (Fuad)
  - Rename pkvm_memcache to stage2_mc
  - Rebased on 7.3-rc1

v4: https://lore.kernel.org/all/20260731143541.956291-1-vdonnefort@google.com/

  - Add kerneldoc to pkvm_remove_mappings
  - Allow pkvm_private_va_range_pa() to work with block-level mappings (Sashiko)
  - Add rollback and harden pkvm_map_private_va_range input (Sashiko)
  - Add missing mc count into reclaimable memory
  - Differentiate -ENOMEM from hyp_alloc in errno_to_smccc() (Sashiko)
  - Collect Fuad's Tested-by

v3: https://lore.kernel.org/all/20260720171513.1415357-1-vdonnefort@google.com/

  - Remove unsafe WARN_ON(hyp_spin_is_locked(&pkvm_pgd_lock)) check in hyp_allocator_alloc() (Sashiko)
  - Modify MIN_ALLOC_SIZE to 16-bytes to comply with FPSIMD alignment requirements (Sashiko)
  - Allow hyp topup/reclaim HVCs pre-deprivilege
  - Add enum symbols to pkvm_hyp_req_handle event (Fuad)
  - Various clarification in commit descriptions (Fuad)
  - Restore unmap_donated_memory() for PGD on error path (Fuad)
  - Renamed __hyp_allocator_map -> pkvm_map_private_va_range (Fuad)
  - Collected Fuad's Reviewed-by tags
  - Rebased on 7.2-rc4

v2: https://lore.kernel.org/all/20260706175415.2604046-1-vdonnefort@google.com/

  - Rebased series on 7.2-rc2.
  - Use scope-based hyp_spinlock.
  - Fix best_missing/best_data_size priority in hyp_allocator_find_efficient_chunk() (Sashiko)
  - Fix missing free_hyp_memcache() in pkvm_hyp_topup() (Sashiko)
  - Fix unused selftest_init() warning when !CONFIG_NVHE_EL2_DEBUG (Sashiko)
  - Fix missing shrinker_free() in teardown_hyp_mode() (Sashiko)

v1: https://lore.kernel.org/r/20260520152650.4107895-1-vdonnefort@google.com

Vincent Donnefort (18):
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
  KVM: arm64: Rename vCPU pkvm_memcache to stage2_mc
  KVM: arm64: Reject hyp trace descriptors with fewer CPUs than
    hyp_nr_cpus
  KVM: arm64: Reject hyp trace descriptors with fewer than 3 pages
  KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator

 arch/arm64/include/asm/kvm_asm.h           |    4 +
 arch/arm64/include/asm/kvm_hcall.h         |   19 +-
 arch/arm64/include/asm/kvm_host.h          |   18 +-
 arch/arm64/include/asm/kvm_mmu.h           |    3 +
 arch/arm64/include/asm/kvm_pkvm.h          |  111 ++
 arch/arm64/kvm/arm.c                       |    4 +-
 arch/arm64/kvm/hyp/hyp-constants.c         |    2 -
 arch/arm64/kvm/hyp/include/nvhe/alloc.h    |   28 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h       |    3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |   19 +-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h |    4 +
 arch/arm64/kvm/hyp/nvhe/Makefile           |    2 +-
 arch/arm64/kvm/hyp/nvhe/alloc.c            | 1211 ++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  129 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c      |   10 +-
 arch/arm64/kvm/hyp/nvhe/mm.c               |   95 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c             |   79 +-
 arch/arm64/kvm/hyp/nvhe/setup.c            |    6 +
 arch/arm64/kvm/hyp/nvhe/trace.c            |   70 +-
 arch/arm64/kvm/hyp_trace.c                 |   15 +-
 arch/arm64/kvm/mmu.c                       |    6 +-
 arch/arm64/kvm/pkvm.c                      |  200 +++-
 arch/arm64/kvm/trace_pkvm.h                |   45 +
 23 files changed, 1931 insertions(+), 152 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c
 create mode 100644 arch/arm64/kvm/trace_pkvm.h


base-commit: 8bd0e6812a1be71d50620f00445940ded0df897c
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

