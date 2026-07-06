Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0C9233926
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360465; cv=none; b=AW/ID1g/dyXSXQYK+OlF3SE651K849Q9ULSCe5w/7tyog23RCOKcE9CD4eIwBL5OFKFu63GJxwGQ7ypulIMeOQ5tsXGsAS3t6EJdVZdeN7vTGWNYdCJKdHVVv7L3Fj3gNYWoOFfvnSSdfzuDhh0GffNnlnb0Ch0JC/oxW5QlNGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360465; c=relaxed/simple;
	bh=UYzTYbAtvFle5/zsWQmFRLQm8unbr2pDUjRYM49v4Ck=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KTVQTrQsx6UBYGX1Z1ahzlT29NYXi8or6d6Pjq0uFFMAtwlkWef7EVyi29WwtfqsEUNEFU39dZWYbJAv9Ar6VmTmhNZuwHNWHIwEnQDJAdkWoX0bu6iKTeKbFHQ0O/3pB/qQKJVHFUm/LUJ2c5uvcDEk28ofD9ypSN6pYljzMyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=INLAufHW; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="INLAufHW"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-470cb859d96so1707910f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360461; x=1783965261; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R1Fq6vKEPrXMgPLx08XSndJMwPqltkg40bPnPrjHOfI=;
        b=INLAufHWWi+g2p2T45pfbfSTrnxeSe8XXTzqhRDGpzQlor/Fgv5zRsbldpQFdFfeIb
         y3QMIckzBjbGJtyP1QCcjjk0MJXWi0vuUuaOx2V8r4GPIvYn6b5zE+SjlA4wBp9DvdRf
         VKcidIpDQWdDdxQT0+Gusd7RLFvJiL646k/4sZg15TB8tO8l20dr+Nf4P6VVHCoj9xKT
         QiPPIzBEt3QlQhVwhvn7nJRlpnTVGt53Q28X67vDtqK+uq3VYCF+Cgco1rl0GOhx076q
         A+g14hQ7v7sSzlMUUuNXPsvZ+wg2k4MoGFqWb+mVoYp8vwnzJTfkCR8JoopJ1Q1O9Z93
         tqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360461; x=1783965261;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R1Fq6vKEPrXMgPLx08XSndJMwPqltkg40bPnPrjHOfI=;
        b=hrH5335bKPWjqabSx+sQqW4ioRlJdTt7qBm1Nt2cYlXbL0cLF0gB4KxDOiIcC5r7mq
         bbABG9eWGxjdZjolgwR7MrtyYQoOkU/3OcTyGv+X14jH5aIofYwjp8D3U2+AoJU8Xvwv
         GhOoTzX30gN/z5BMOexaUkOTYYMIf+RJsNvBfH5XV5gcbufYw2Xkz4uxKcXsUaxOXsBm
         N3nuyJVvKaIRn0L5Zrw1ZCtFlWxjfOyNjVehXSYHebDs3nVEDgGkqq25YI4yF4ES3p2k
         w8ch13GQl/Ew/RlrN325oBCcTKTPFfJFbmkvVvfY8ZHvvZ/5r5L7t7l+tBxVcLm9KF9A
         CpGQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpv1shhd83CCdWOXsVIHQmTLz8i8o2Q8s84Zc6Dtbk8JM1bsW48HGa8xCfBFsxhCNBW7hxP0is=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKMhcF1J0M53dvjz8lNNcxQwTUK9gQNl2CrCs5rNKFwurn3iwq
	CjpQhz9ces4SXuZKhRVQyuXR7UuHqaxyR/HT8teNMcv7UAs1I00JBtzTcHgqTx+QKxTSgLg/Aq8
	+8A2dQVfIol0+I7g2OAV9AA==
X-Received: from wrpx16.prod.google.com ([2002:adf:f650:0:b0:478:511d:6f9e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:29d7:b0:46f:a0f1:c346 with SMTP id ffacd0b85a97d-47de66fdd24mr1141479f8f.29.1783360461311;
 Mon, 06 Jul 2026 10:54:21 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:53:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-1-vdonnefort@google.com>
Subject: [PATCH v2 00/18] KVM: arm64: Introduce pKVM hypervisor heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
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

v1 -> v2:
  - Rebased series on 7.2-rc2.
  - Use scope-based hyp_spinlock.
  - Fix best_missing/best_data_size priority in hyp_allocator_find_efficient_chunk() (Sashiko)
  - Fix missing free_hyp_memcache() in pkvm_hyp_topup() (Sashiko)
  - Fix unused selftest_init() warning when !CONFIG_NVHE_EL2_DEBUG (Sashiko)
  - Fix missing shrinker_free() in teardown_hyp_mode() (Sashiko)

v1: https://lore.kernel.org/r/20260520152650.4107895-1-vdonnefort@google.com

Vincent Donnefort (18):
  KVM: arm64: Add __pkvm_private_range_pa
  KVM: arm64: Add pkvm_remove_mappings
  KVM: arm64: Add __hyp_allocator_map for the pKVM hyp
  KVM: arm64: Add a heap allocator for the pKVM hyp
  KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
  KVM: arm64: Add topup interface for the pKVM heap allocator
  KVM: arm64: Add pkvm_hyp_req infrastructure
  KVM: arm64: Handle PKVM_HYP_REQ_HYP_ALLOC request
  KVM: arm64: Add reclaim interface for the pKVM heap alloc
  KVM: arm64: Add selftests for the pKVM heap allocator
  KVM: arm64: Add a shrinker for pKVM
  KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
  KVM: arm64: Move hyp_vm refcount into the structure
  KVM: arm64: Use noclear for PGD in __pkvm_init_vm error path
  KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
  KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
  KVM: arm64: Reject hyp trace descriptors with fewer CPUs than
    hyp_nr_cpus
  KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator

 arch/arm64/include/asm/kvm_asm.h           |    4 +
 arch/arm64/include/asm/kvm_host.h          |   14 +-
 arch/arm64/include/asm/kvm_mmu.h           |    3 +
 arch/arm64/include/asm/kvm_pkvm.h          |  104 ++
 arch/arm64/kvm/arm.c                       |   26 +-
 arch/arm64/kvm/hyp/hyp-constants.c         |    2 -
 arch/arm64/kvm/hyp/include/nvhe/alloc.h    |   24 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h       |    3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |   19 +-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h |    5 +
 arch/arm64/kvm/hyp/nvhe/Makefile           |    2 +-
 arch/arm64/kvm/hyp/nvhe/alloc.c            | 1217 ++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  124 +-
 arch/arm64/kvm/hyp/nvhe/mm.c               |   33 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c             |  111 +-
 arch/arm64/kvm/hyp/nvhe/setup.c            |    5 +
 arch/arm64/kvm/hyp/nvhe/trace.c            |   66 +-
 arch/arm64/kvm/hyp_trace.c                 |   16 +-
 arch/arm64/kvm/mmu.c                       |    4 +-
 arch/arm64/kvm/pkvm.c                      |  136 ++-
 arch/arm64/kvm/trace_pkvm.h                |   37 +
 21 files changed, 1801 insertions(+), 154 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c
 create mode 100644 arch/arm64/kvm/trace_pkvm.h


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

