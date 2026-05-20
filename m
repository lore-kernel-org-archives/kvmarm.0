Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09363EDAB1
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290837; cv=none; b=tPxu7YfijMOfbwVQFIBtSHKUuumHuDs4Orlo686rbWNJLrSOsJjpDHc1ah1e4A9t6Ci1ajf7xvwcnxfYXZk2sILH2EUBcVMgfxyDklX89/dtxBK6EtCzZvylnvRE3ZDxtlgUSHL5GuLR6TzyJV2xBbp9nsbhxp+IOxWbsGKJOHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290837; c=relaxed/simple;
	bh=VXtfKW24MCTZuH7HGpHcszSfo316OnyUHrfUrNBWajg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EkPy9j3bHDyR0GMJ0RsHJElZwPGjLCDmdAEwIy4r5srqAtItMnrz6oqjkIqpcIQNe3fk/FQFTXNoCQthdLJQaNyc3er+s/HJIUKETS6VNWcnn/2uK13PllgcFA/bIJI+yotejIhr4b6xKD+W+Vypb0EbwWXfz/0seyCmZNtdwc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nhZ1Ejq4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nhZ1Ejq4"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fe44ce385so40570795e9.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290834; x=1779895634; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DYdgcm/vWN2I8yVr+k4yh1FcDS21+U9vfHPjdUVDhrc=;
        b=nhZ1Ejq4VFIVUwSIsXXwnpHr9fh1l6iBnuFNECrucm+QHrH/e6Y8NQrDiXlrmEqQkf
         zAw4lxWQ4+KvxddWdUHnM09JeppOaubMTrbrYQ2eZacheDUT5PuUyBwFwvR3guPboDNQ
         3ltTmYcWeRY6iBLJ/NZlD+s+n9Ro/Q9Q6o0Mb3vdGLzKTQdOq0rn6tu6Q+bHqjLqJq8z
         CoenmTEDxe0CPzkxvG/lZpmTz7uQP9S3Tn5up//FntjPcenIoG/TpM5FzoEW0xokNK3c
         bOHzFacBHmxCjGFs0eXmVVoIU+NH5MKz3fmUjvqoUqjgf8TAl7K6Hpy053vFCKAJss1q
         XPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290834; x=1779895634;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DYdgcm/vWN2I8yVr+k4yh1FcDS21+U9vfHPjdUVDhrc=;
        b=emmzDsZRN0xPAi4M2Htd8/qeuLx73da6c22mlpA8cFh1tBWEqR4zFKDzBkxMJyjJBp
         AFFyChoJ6VXYeS1L+d9eSBm43LTgTLA2q3QLnLHOsCUXWlpc/mVi597uIcH8l8eWrGXe
         6D4Lt8juGGeVanlM0J++jU55IH90z5bMBapCFIZU0pNCKy74TJ6MelPWrMiANoKXI8Gz
         tkmT3jsCFOgNYom6w4GAT2zngQe1+qo55P0ZJSn2thdpPyHHHxCCZKa2ertp97bvSgfG
         e6/ZWPGrcDO5s7bEPrAcbF8NQJbSsXdRpKZzEPtEK+AevgQVJHgATWPioKPhfhB0s7wA
         ygEQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LxBxVv5evHmeiZS4DQCUONXGtlZ2TqV2w6uwJTxZsHdYfSOxiGIviJReQipDvVAhPsVujmEI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxgj7VxcmVPDE8RiaCjYnmRof0D+E6BOz6sKRs1FlQ0mDqSesuG
	Xjdc/xNMAczPLGZ3SzLckvWKepk36LY+IXCpS6E26S+G5Z+mHrwgovneg1ag+OQqzl+ZXaFnEYZ
	OUpVa6IVqQOsEdNR1AJnqWw==
X-Received: from wmbjd23.prod.google.com ([2002:a05:600c:68d7:b0:48a:5e23:da86])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:885:b0:489:c57:7836 with SMTP id 5b1f17b1804b1-48fe6517fdfmr235377385e9.27.1779290833937;
 Wed, 20 May 2026 08:27:13 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-1-vdonnefort@google.com>
Subject: [PATCH 00/17] KVM: arm64: Introduce pKVM hypervisor heap allocator
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

Vincent Donnefort (17):
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
  KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator

 arch/arm64/include/asm/kvm_asm.h        |    4 +
 arch/arm64/include/asm/kvm_host.h       |   14 +-
 arch/arm64/include/asm/kvm_mmu.h        |    3 +
 arch/arm64/include/asm/kvm_pkvm.h       |  104 ++
 arch/arm64/kvm/arm.c                    |   24 +
 arch/arm64/kvm/hyp/hyp-constants.c      |    2 -
 arch/arm64/kvm/hyp/include/nvhe/alloc.h |   24 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h    |    3 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h  |   19 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |    2 +-
 arch/arm64/kvm/hyp/nvhe/alloc.c         | 1233 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  123 ++-
 arch/arm64/kvm/hyp/nvhe/mm.c            |   33 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  111 +-
 arch/arm64/kvm/hyp/nvhe/setup.c         |    5 +
 arch/arm64/kvm/hyp/nvhe/trace.c         |   69 +-
 arch/arm64/kvm/hyp_trace.c              |   16 +-
 arch/arm64/kvm/mmu.c                    |    4 +-
 arch/arm64/kvm/pkvm.c                   |  130 ++-
 arch/arm64/kvm/trace_pkvm.h             |   37 +
 20 files changed, 1808 insertions(+), 152 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c
 create mode 100644 arch/arm64/kvm/trace_pkvm.h


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.54.0.631.ge1b05301d1-goog

