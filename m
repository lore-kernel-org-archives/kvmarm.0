Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F393D6664
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 07:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791225; cv=pass; b=KvOTyDyES8vbFggDplFRKnmCNlf4WKhsxtjTXxU6PPMLE+d0JXk+jg9rjEYOn3ESolRsPf3ObTGFvTotYtj5eotZimXBvXOspF8sbgQ8AbfRYeJaaHDa18fTAtRH+26h9GjxQCk+nXIgF2JUDWt9b2NAX81ng7Q1aVkVLWM5a4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791225; c=relaxed/simple;
	bh=8DmSXLWf2+9X1b8CEhGYj908qYlSgRmvQ6hnyQMUh0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dBSRZfqDDkt271r6m3wobDewjahhiawmM+QIUI41+X4cwybqE4Ze1fb1kDQXuBSsX1GK4XVmCOqJQ9CrrnafxvYsjuFv1HmcrFWSRmeItCr+pPPnKgi+sI1QlE0NF1kUhYmsA0gbJdq3zMqIJ6ZzxS+QbiDoJDUBBotthutqVIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k0xlx7rR; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k0xlx7rR"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c10ed63c0so107961cf.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 00:20:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784791219; cv=none;
        d=google.com; s=arc-20260327;
        b=br9wL6C6ThI/BID8GMYdFhJiUlVpB7nMfKqnUMBZqakllxOEfzE7BNH/XrZlr38RFo
         T+XtnN+ZvNAHJ1wVD1pGr00v0PRvMwmdgJBicB/0PWu9ogaUL3P+hXqiOXcqGKcbgTro
         zbvDXltCoqhuc5yHwrWXU3wZmYnrs1Iq6W9z7vUw1zUg2427szNySv3R7NWCfJSgS9Lj
         9ZUGvdi1mm2VcClRA4ZV8SlCushNlxjLZTJe0ZUz4bvsSOI7IxNH0UKOMGg8CP4PiSpE
         2R1B2fbm9e1t2R9YDLXw8S3CrG4pYOQfx8lnPLxmz0O9pzC5qX/94A7osW3354zSImN2
         42rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=87tY0XBF0Spy12g+WsA7Jvhj0xZPDxN4sdYFmxhScf0=;
        fh=w6EAhuZbSC//pTp9i295sDQxZIlrKvikir0lh9fXdWE=;
        b=W8ws9W5NCMCI6WycYPQLsgLIyt+nnkezQKksMVuazh/YBJhLJnZRgrDSJIM4QzCsXs
         ++kesFYVvNIvCETqp9rAsz5xeYVCXm9C654yAlnZbZoFr+tZ3c4w61s7+bPAvfS+Z4+n
         obRLXsXyZX2wyZxC8uudPqCtDnLp++FbPsRuFCcp2Adp75fRAhXQB4TjHM1UsMXyTzG+
         31tHzEsHmvoXnQQ2hAXEx3ZtnfsPkLDeSgBrINAG5XxcEZtOzuoNbRzp3TIwsv9Hmv5x
         y7bKbTBXXZNxTnzf/YvWaJrmA1ys8JaFo/UNRi4pVzG3q7IQgjIGQHY+xi9JQXeXtaAi
         olrQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784791219; x=1785396019; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87tY0XBF0Spy12g+WsA7Jvhj0xZPDxN4sdYFmxhScf0=;
        b=k0xlx7rRS4QS8louIB0/0UUWnRWCJps4Zpvvwj4czwb8uXXw5N/AhrJnI4H4plZt1Y
         A7SvxQ9rkuDZdu3nKkbSdpu8wGGJA/9g4jpb/yTIqkSC2eSAJY6+Nyb+7VVTU9EOCvWG
         r39f8sVORauSeG/V3f71ZK1J8vv71VZQJapp7wKajXiINQPQckBK8v8+Dfiar8pTVo10
         qZArh9p5qDscYPXAmBx1I49d8rfasbXcG2RIJv3Isd22K94jqIcRuFRzS/qG/Zg8rba7
         11C8cpyFPEWY8Xxv+VKmGTaBGUrO0Q6LfCfSiOI3/a+a99oF+tRJ8XBdTviDTPM3N225
         4EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784791219; x=1785396019;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=87tY0XBF0Spy12g+WsA7Jvhj0xZPDxN4sdYFmxhScf0=;
        b=ppaZJnbCFO4VOrq3ffvfHlbfdN933JsRQ7JVLmUNTVmgMSBtYDS+wCUFuxkD8U4+2u
         KR9sjYfhQULP2Uy70f4ZznpTJdJdSdqWqy3IDk18qHuHa/HYbltmTcie6jpHpKglfqob
         HlPs8Jcs5csmR825eTSgQmpEAU9RZu8Sf29Lx2eUfwD8w3UL8xziuMBN48zNEF3Wjxi2
         Sf2AjZfJMSWEny4hJEwgV473HisoWfmHEY9cmS1x1GGgi2L5K6Dmcrlp3Y6VC1DHNiFO
         eSLixqO5xVtkn3tIX0QSlUOWpeGrauYi800IjjTlCfyb4kfo1+J2qKJcTFWE2uPrfGLs
         E+zA==
X-Forwarded-Encrypted: i=1; AHgh+Rpux/M02H2RvYvXj3oiK/ubb/O4llf/VVbwXKcfGhmiVFM3swZyvDCGVaTO7KIRQfQkNq1Np1Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxb0Yty56ZW1QvcfdmG/vapQ04iPMPvcYUwqYmCys4sroqYEqjr
	y5i5QyDtPUUnRzolmG82B2u6qma6LogdysxC2ka5IgUmGVuq1wLSgYaDzYJtePJC0VlLLA5p/ip
	sEobpDg3vL6cHQ4KLIWc+8BSyIEV6g6D6HnTcKt5g0BcDm+690zSzLGpQUYo=
X-Gm-Gg: AR+sD13tNpqI/IiEMVchjbkRRS2Ui/CCjDzs45TRlrdALjP5kKtQh+JV0YXd1UBOSWv
	kTMqV0675uM26xgtMUFSD+DKxunfg1PhT/02+FJ+ai8Ph9WWsUwLJ1tXle15P9LjzUvMlABr/w7
	21NjBzkHR5X/+mOmCgaSpQiSPKVwgLi0yKvycFlgO+ySxEQpmcGYrSOrP9NlYHjYiQYbV8l2V+g
	0Cd0LvXE6emvPTr3NiI/8vDurn5nnGJ6aAPlbkpR1ThQcNGKRsZwPzHpTxmXA==
X-Received: by 2002:a05:622a:9006:b0:51c:7a8b:c3ff with SMTP id
 d75a77b69052e-5283bbeb11cmr7210611cf.24.1784791218948; Thu, 23 Jul 2026
 00:20:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jul 2026 08:19:41 +0100
X-Gm-Features: AUfX_myAcHFefmBWGcQK4TCfe3jKMad7iXPD1hE8cSakhsQCWUus-2VShzvp7rI
Message-ID: <CA+EHjTzN-68kBkOGfOqdBnRHs8HRotDuQaPACYK_N4Vw8S4ehw@mail.gmail.com>
Subject: Re: [PATCH v3 00/17] KVM: arm64: Introduce pKVM hypervisor heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Tested on QEMU: npVM/pVM boots, the in-hyp allocator selftest, and
hyp-trace buffer load; allocator top-up path confirmed via the
kvm_handle_pkvm_hyp_req tracepoint (HYP_ALLOC).

Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad

On Mon, 20 Jul 2026 at 18:15, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> pKVM historically lacked a dynamic memory allocator: all hypervisor-side
> VM and VCPU structures had to be sized on the host, allocated as
> contiguous pages and donated to the hypervisor.
>
> This design tightly coupled the hypervisor's memory footprint to
> host-side constraints, complicated memory reclaim, and severely
> restricted VM scalability.
>
> This patch series introduces a dynamically-mapped custom heap allocator
> (hyp_allocator) to the pKVM hypervisor. The initial users are the
> pkvm_hyp_vm and pkvm_hyp_vcpu structs, and the hypervisor tracing
> metadata.
>
> In the near future, this heap allocator is expected to be leveraged to
> support SVE in protected VMs and in the distant future, it will also
> support dynamic device assignment.
>
> By moving to a hypervisor-managed dynamic allocator, we also allow
> deduplicating the donation/reclaim path of EL2-private structures.
>
> The main building blocks for this series are:
>
> 1. pkvm_hyp_req:
> ----------------
> When the hypervisor heap allocator goes out of memory (-ENOMEM), it
> suspends the hypercall, embeds a PKVM_HYP_REQ_HYP_ALLOC top-up request
> into the SMCCC HVC return registers, and exits back to the host.
>
> This building block will also be useful for the future huge-mapping
> support in protected guests, allowing EL2 to raise requests such as
> block splitting back to the host.
>
> 2. hyp_allocator:
> ----------------
> This heap allocator manages a reserved VA space range, dynamically
> mapping and unmapping physical pages on-demand to minimise the pKVM
> hypervisor footprint. As memory is reclaimed and relinquished to the
> host, unmapped holes are introduced within the VA space. To prevent
> orphan mapped regions, neighboring unused chunks cannot be merged if
> they are separated by an unmapped region.
>
> The allocator chunk metadata is stored directly into the VA space range.
> To minimize metadata overhead, chunks only link to each other via a
> relative 32-bit offset.
>
> A simple hardening of the metadata is added via a simple 32-bit hash.
>
> 3. shrinker:
> ------------
> As the heap allocator isn't reclaimed actively on VM or tracing
> teardown, a shrinker is added to allow the host to reclaim unused memory
> from the hypervisor when the host is under heavy memory pressure.
>
> v2 -> v3:
>   - Remove unsafe WARN_ON(hyp_spin_is_locked(&pkvm_pgd_lock)) check in hyp_allocator_alloc() (Sashiko)
>   - Modify MIN_ALLOC_SIZE to 16-bytes to comply with FPSIMD alignment requirements (Sashiko)
>   - Allow hyp topup/reclaim HVCs pre-deprivilege
>   - Add enum symbols to pkvm_hyp_req_handle event (Fuad)
>   - Various clarification in commit descriptions (Fuad)
>   - Restore unmap_donated_memory() for PGD on error path (Fuad)
>   - Renamed __hyp_allocator_map -> pkvm_map_private_va_range (Fuad)
>   - Collected Fuad's Reviewed-by tags
>   - Rebased on 7.2-rc4
>
> v1 -> v2:
>   - Rebased series on 7.2-rc2.
>   - Use scope-based hyp_spinlock.
>   - Fix best_missing/best_data_size priority in hyp_allocator_find_efficient_chunk() (Sashiko)
>   - Fix missing free_hyp_memcache() in pkvm_hyp_topup() (Sashiko)
>   - Fix unused selftest_init() warning when !CONFIG_NVHE_EL2_DEBUG (Sashiko)
>   - Fix missing shrinker_free() in teardown_hyp_mode() (Sashiko)
>
> v1: https://lore.kernel.org/r/20260520152650.4107895-1-vdonnefort@google.com
>
> Vincent Donnefort (17):
>   KVM: arm64: Add pkvm_private_va_range_pa
>   KVM: arm64: Add pkvm_remove_mappings
>   KVM: arm64: Add pkvm_map_private_va_range
>   KVM: arm64: Add a heap allocator for the pKVM hyp
>   KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2
>   KVM: arm64: Add pkvm_hyp_req infrastructure
>   KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
>   KVM: arm64: Add reclaim interface for the pKVM heap alloc
>   KVM: arm64: Add selftests for the pKVM heap allocator
>   KVM: arm64: Add a shrinker for pKVM
>   KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
>   KVM: arm64: Move hyp_vm refcount into the structure
>   KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
>   KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
>   KVM: arm64: Reject hyp trace descriptors with fewer CPUs than
>     hyp_nr_cpus
>   KVM: arm64: Reject hyp trace descriptors with fewer than 3 pages
>   KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator
>
>  arch/arm64/include/asm/kvm_asm.h           |    4 +
>  arch/arm64/include/asm/kvm_host.h          |   14 +-
>  arch/arm64/include/asm/kvm_mmu.h           |    3 +
>  arch/arm64/include/asm/kvm_pkvm.h          |  102 ++
>  arch/arm64/kvm/arm.c                       |    2 +
>  arch/arm64/kvm/hyp/hyp-constants.c         |    2 -
>  arch/arm64/kvm/hyp/include/nvhe/alloc.h    |   24 +
>  arch/arm64/kvm/hyp/include/nvhe/mm.h       |    3 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |   19 +-
>  arch/arm64/kvm/hyp/include/nvhe/spinlock.h |    4 +
>  arch/arm64/kvm/hyp/nvhe/Makefile           |    2 +-
>  arch/arm64/kvm/hyp/nvhe/alloc.c            | 1223 ++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  124 +-
>  arch/arm64/kvm/hyp/nvhe/mm.c               |   51 +
>  arch/arm64/kvm/hyp/nvhe/pkvm.c             |  100 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c            |    6 +
>  arch/arm64/kvm/hyp/nvhe/trace.c            |   70 +-
>  arch/arm64/kvm/hyp_trace.c                 |   15 +-
>  arch/arm64/kvm/mmu.c                       |    4 +-
>  arch/arm64/kvm/pkvm.c                      |  159 ++-
>  arch/arm64/kvm/trace_pkvm.h                |   45 +
>  21 files changed, 1831 insertions(+), 145 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c
>  create mode 100644 arch/arm64/kvm/trace_pkvm.h
>
>
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
> --
> 2.55.0.229.g6434b31f56-goog
>
