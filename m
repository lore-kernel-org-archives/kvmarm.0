Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4922D369990
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790779850; cv=none; b=jozgup4SQ7Dct5IrWLFdxnLTwwqDxLnzhVsULfLp5HFHDEIWVquAm8KAC9/KXiq4MI9T70/fJ9J8XjlehXjQzrPiRv3CQQtHPRgXrmGdDGSoJBNkhtH54VQRDMtYtXKMckj6risvUyA4Kv9M+x+aiElVNfIbTZPCNIxzEcJg9vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790779850; c=relaxed/simple;
	bh=lbw6QDjvmAOom4BsQ6obu0qG9SHaZVacueJ3ljC1rII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CsX+MCo4k5fbJ+gd2lCFhcnFHG/SImZFYkCap6DgjaMDm439GZ0YQoQA3LBVVmFL+MAAiVYtUx5YX1ZqEgWk2JQgvjae8qlL4HMPFaea0GPA0ivS1aFsIG8p8Ya2sl+S9JjmbXYLisYynyvVwPU113xLcoHIUswswhqnef/HehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=icGCLbKc; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="icGCLbKc"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ce364488dso7223255e9.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 07:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790779837; x=1791384637; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ugl/kEsibxaOMxwiAB8ohvG+dBs5XjVCSnq2cxUbe8c=;
        b=icGCLbKccKh7oeRTiQGthmm7FWasE6N23DkaQdK/bY2CRB2eKAgjZXxKqSNWTuVP53
         CMmKUg+PuN7tMVoA/+n49TJfTl2w90EH67skKQk3zAA5kP/u1x3NI6fOiDXBs2Dbaqyc
         HKxJS5T6CdB9SL1ABxC6N7BX3utN/oISwUunoHmQIxRxG3mP5gVhPtPFqjEDiTLDwGFu
         TUepy9RE91BP3lL4SCO/Os2zXAEkRUeSL9oPfcw1e/dpnZi+CGprkfKO2jMSh7RpH537
         +ex4tilYElqp4TSv/+fuFzBYr7RmwB8dEkvZo9TKtMSXHpWpms9ANAgDnR58bNdNVDmi
         4LDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790779837; x=1791384637;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ugl/kEsibxaOMxwiAB8ohvG+dBs5XjVCSnq2cxUbe8c=;
        b=eIIxMDenWoEjb8dVhEQc80tcWxzBzPDYibU1J+oGtgaSRz5LnjeUmkflQWBpCLkaLz
         X0OwM++1nu2WZ97FsjUJkhYDRU7RdGB7C2Jzvc5bNtIeQSvmm297GHiwP2wMvs0KXwGR
         fMESlyypJv9EJsb1CFg6xo1gQsnRvgyBpmbUWNyxiNwrwbcKnw4/D84aBx1/C8UtbJeO
         I4OmPPg7vezYZZTWv7P6e9dG7Ndv0/jDj7/ViV4GnlMrGf7jXZgbHwbZtFaPQwZDq1d/
         D1njiqDWXOYzP0t7C0UfgdMJtLvo3IaPtqIoe4rv7WZHOhVMfcO7w1VFTXHmiRMSOeCA
         gDrw==
X-Forwarded-Encrypted: i=1; AKwUvBw5I5TkfCj/rFhCjqSuFQA7UgyvpoF9OSdgftjkDjVdWsaoKw7gf7dYY9xb1w7/TPufDT9Ua28=@lists.linux.dev
X-Gm-Message-State: AFuF++mAQVmNMCl29v9qf4ETAJsQoXrKXze3kJKlCDwVMiAmzrA6HpXd
	EtFR9vDz1TGVb9WsKCV9OKA9qVPQXglx3DOw7A6eVl+Rws09ER1Xt+PYyL3TmrM8UcmiXz3Rocz
	2CnLgl5Rv
X-Gm-Gg: AYBFou2JhM2SnyXul1pVeBf/uRILg0EiuJawm2Jp3fvdsFlHCInLwBdZGhVdMsCWk1J
	hsK3ljca3FGeM9EqpWZI8EH2s1qdcvYreK/91ZGjejeTrw0KqYbDL0cwUH6bpS/Lca32hwgx37i
	IUxwiyhvhU3ihn1rPd5mNqMMQrzlVv0AyKWjU5hrj7XyNeb6uSHM4+0UpMii9n+/431HB2CZVB5
	GNJtmdoFzBnGIXd7xYAAAnbLGH+BcwDEB0f/2ZhY86qkkSmVXV/E8vt5pBrwzwMxtsThgRCJeIm
	9eCASV7w9/l1uJxgZOVEQqJOekBoKPIxlIh+ptZBxjvg9WdxsrhhGCmLW/CKFQC5jTPDO4YdCFf
	ALZOOrETLKCwngqohSk1iZ6MIpmy3C/H0YVUcqFU29Yid2yzoQV3KCitb6Q8/AGG1h3OV9AszKq
	O/X/Rw/kCFXDpemyMFG/8R3KRzUaSXj1ZEMq3l/Zm+sC4uq2UGaARVnbdMZC6VgXC7b6PRpR3mn
	MkEE1J9iTZMm5X4yxWDG1q6Wazwh0ptBSWqlZDaf6E=
X-Received: by 2002:a05:600c:1f95:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-4a01b1a1138mr26323985e9.8.1790779836298;
        Wed, 30 Sep 2026 07:50:36 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01e67e01esm3856325e9.13.2026.09.30.07.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 07:50:33 -0700 (PDT)
Date: Wed, 30 Sep 2026 15:50:29 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com
Subject: Re: [PATCH v5 00/18] KVM: arm64: Introduce pKVM hypervisor heap
 allocator
Message-ID: <ar0htZydVZdB9zVk@google.com>
References: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>

Gentle ping for this series, 

It's been fully reviewed by Fuad and is already based on 7.3-rc1.

-- 
Vincent

On Tue, Sep 01, 2026 at 09:09:23AM +0100, Vincent Donnefort wrote:
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
> Changelog
> ---------
> 
> v5:
> 
>   - Remove unreachable !prev checks in hyp_allocator_destroy_chunk() (Fuad)
>   - Add kerneldoc to pkvm_call_hyp_req() (Fuad)
>   - Avoid duplicate handle___pkvm_hyp_alloc_selftest() definitions when !CONFIG_NVHE_EL2_DEBUG
>   - Chunk pkvm_hyp_reclaim() with cond_resched() to avoid blocking in EL2
>   - Allow shrinker to scan across all runtime topup IDs
>   - Reclaim chunks before draining allocator->mc in hyp_allocator_reclaim() (Fuad)
>   - Make is_ttbr1_addr() check in __kern_hyp_va() conditional to pKVM (Fuad)
>   - Rename pkvm_memcache to stage2_mc
>   - Rebased on 7.3-rc1
> 
> v4: https://lore.kernel.org/all/20260731143541.956291-1-vdonnefort@google.com/
> 
>   - Add kerneldoc to pkvm_remove_mappings
>   - Allow pkvm_private_va_range_pa() to work with block-level mappings (Sashiko)
>   - Add rollback and harden pkvm_map_private_va_range input (Sashiko)
>   - Add missing mc count into reclaimable memory
>   - Differentiate -ENOMEM from hyp_alloc in errno_to_smccc() (Sashiko)
>   - Collect Fuad's Tested-by
> 
> v3: https://lore.kernel.org/all/20260720171513.1415357-1-vdonnefort@google.com/
> 
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
> v2: https://lore.kernel.org/all/20260706175415.2604046-1-vdonnefort@google.com/
> 
>   - Rebased series on 7.2-rc2.
>   - Use scope-based hyp_spinlock.
>   - Fix best_missing/best_data_size priority in hyp_allocator_find_efficient_chunk() (Sashiko)
>   - Fix missing free_hyp_memcache() in pkvm_hyp_topup() (Sashiko)
>   - Fix unused selftest_init() warning when !CONFIG_NVHE_EL2_DEBUG (Sashiko)
>   - Fix missing shrinker_free() in teardown_hyp_mode() (Sashiko)
> 
> v1: https://lore.kernel.org/r/20260520152650.4107895-1-vdonnefort@google.com
> 
> Vincent Donnefort (18):
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
>   KVM: arm64: Rename vCPU pkvm_memcache to stage2_mc
>   KVM: arm64: Reject hyp trace descriptors with fewer CPUs than
>     hyp_nr_cpus
>   KVM: arm64: Reject hyp trace descriptors with fewer than 3 pages
>   KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator
> 
>  arch/arm64/include/asm/kvm_asm.h           |    4 +
>  arch/arm64/include/asm/kvm_host.h          |   16 +-
>  arch/arm64/include/asm/kvm_mmu.h           |    3 +
>  arch/arm64/include/asm/kvm_pkvm.h          |  117 ++
>  arch/arm64/kvm/arm.c                       |    4 +-
>  arch/arm64/kvm/hyp/hyp-constants.c         |    2 -
>  arch/arm64/kvm/hyp/include/nvhe/alloc.h    |   28 +
>  arch/arm64/kvm/hyp/include/nvhe/mm.h       |    3 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |   19 +-
>  arch/arm64/kvm/hyp/include/nvhe/spinlock.h |    4 +
>  arch/arm64/kvm/hyp/nvhe/Makefile           |    2 +-
>  arch/arm64/kvm/hyp/nvhe/alloc.c            | 1211 ++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  125 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c      |   10 +-
>  arch/arm64/kvm/hyp/nvhe/mm.c               |   79 ++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c             |  104 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c            |    6 +
>  arch/arm64/kvm/hyp/nvhe/trace.c            |   70 +-
>  arch/arm64/kvm/hyp_trace.c                 |   15 +-
>  arch/arm64/kvm/mmu.c                       |    6 +-
>  arch/arm64/kvm/pkvm.c                      |  200 +++-
>  arch/arm64/kvm/trace_pkvm.h                |   45 +
>  22 files changed, 1915 insertions(+), 158 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c
>  create mode 100644 arch/arm64/kvm/trace_pkvm.h
> 
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.55.0.897.gb25b4bd76c-goog
> 
