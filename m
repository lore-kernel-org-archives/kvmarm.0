Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937459;
	b=wnQwOFb5d/MxdyMif1vXgV33FG9ParpqOflJ4Z6Zjfl8EJOsX4EFmA8yvNQQbp2c7bZR
	 9O/pvv7e8GGPNxmDqO8CoOMeUOsLwcrdujStCblGe80WrS0bRCRemsNSxhxBy/P2utnWO
	 77sbyInHAR+sZZ6Fuc0wZS/XyrTvsG/9j2Rxj6BWeTe5LI2tToKWFmIOgkdvejVJiLE+Y
	 d4Tp3XvTPLFEWvsNmN95m4XmCeMzzZnJc82W/wZsLABoybVfT5ETUJqfVO0VvJMFZ8U1M
	 /fBxWz0n9MIE0GXteSUINsZJxNgeiXCYHpylJ9qPoA+VHjL2i9B7mwBuzk/V8krcBLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937459;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=U0C2c5C1ky8GXUFhcagNmONxfQIKKMC4L5ZXkx5S6y8=;
	b=nNlaqVGRxm5Rc5Ex5MUIei+IjjGIfwWEF26EO14AY/RTGsz0MSvdBv1ywRKDPMz0WIJ9
	 eXu7UF69bvRL8Ze1YAEv7LaDNNuf2sBQ5UKHdAl7ZCDnjFV2ez91nt4SjSXlhXqmoNtjm
	 7sqCMAmWEg5qeaHFTMkIfcKRvNQTU6UoxGCwQkWbV9BDpbLBG7a6b3hyCoWihtcL6m1qX
	 VqLGlHcPCJg+2GDdzP9xPBcthK23N4pbrbHtFtnDZYXHu8GiA/fKlM9iRtM5fE43+VIf5
	 eIDI31Mi/94bQLKhXH4QdC2sy3VnHxdo1yxUg/qEd65lDB0CN5Rr341vZ5SQUwSFYsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N9oxj2Kq;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883F0606A32A
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 883F0606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N9oxj2Kq
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4b9fde3044dso873965e9.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937457; x=1795542257; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U0C2c5C1ky8GXUFhcagNmONxfQIKKMC4L5ZXkx5S6y8=;
        b=N9oxj2KqHgeTC7NhRv/dqgHJsuY8+LRkQCbg3Q8UwjvVFG1NRyL8AJ5Tmu7m3fQOlk
         O9LOz6da0rkxHHaTyDHZzVuoZ5XSZsXs4L7sXJLzVofjS3UeMK0biS/4sVk1cEv9jdBK
         TKuTGeV+qyDDfIB1InO0JwblxJZt/6lhDtHEV+kyhW7IusPhI/VF2Qs+ABz/TK8mFpMz
         2jPK+WG0OQMR+MLICuTjTTgsG/VnStz0w5VpiXAuYAhsWY8diWQzVbtK9Y37lC+5WmgW
         zuk9B7rw3aup6Og/BYnAkqKjjr23ajDnPln3+IxKENfzweCIoFlP8L/aq3r1xC7V6lpj
         PZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937457; x=1795542257;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U0C2c5C1ky8GXUFhcagNmONxfQIKKMC4L5ZXkx5S6y8=;
        b=WRaVcS7pUEg22GimqokKkKsXHBCh0XmBZD2NqJRU4Ndyaq5qVyuI0rEzj2oASvNUT3
         pP/M7QeGsYX6KGoXrF7KBGTAo/eHnF0A/4Xs5/euylPHqQiw/9mBfTClvhR3TVMgi9Lc
         dzpNnA6XvVjvuKQx/l/ylRg+0lse0Kh5odIAHQsOsChY4CbekcdVtDOOVMoWaOptTvT/
         uTL3JBue9YwkzRFwVR7i3o6ApzuqBRBb226dyBFT6tYKPQmg+3ilFhT6rLVtacLtllCC
         vFEoATTUnwQm93mF+TDuxgfXF5QBZjnPEgqBtBX0FbbgPWvREIU/sD3lDZG0GRpwjqRK
         vC9A==
X-Forwarded-Encrypted: i=1; AL+hErH/p7Ac7+tkvUFQFYC1TGSBmUu7FMbjt4J/r/wehlpGowj4MQDBQXHjMobRSozO6/ccG6XPUhA=@lists.linux.dev
X-Gm-Message-State: APuU4Z8kO/QiIm+Mc0OCF9WJWQUlTl2FJHCPY3Fq+I1bmW6h1Dwx2nrd
	LNgIVxBSYReQukAmoh4X7fTNhmKIsuMzzXkApqFLCpJ6ZbeqWXOPFHvaFWNTpcfAIOO4zgawzG6
	6oNDjyjKAjURfAv/eRFpihg==
X-Received: from wmbeb10.prod.google.com ([2002:a05:600c:678a:b0:4a2:826:6d11])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:12:b0:4bb:6d61:af7c with SMTP id 5b1f17b1804b1-4bb6d61b56fmr164962325e9.35.1794937456737;
 Tue, 17 Nov 2026 09:44:16 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:39 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-1-vdonnefort@google.com>
Subject: [PATCH v4 00/23] Huge mapping support for protected VMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, pKVM handles stage-2 mappings and ownership tracking strictly
at the PAGE_SIZE level. This series extends pKVM to support PMD_SIZE
block mappings, thereby enabling Transparent Huge Pages (THP) for
protected guests. hugetlbfs is currently unsupported as it does not
appear as swapbacked.

Summary of changes:

1. Enable host stage-2 block-level annotations:

The host stage-2 being annotated with the GFN of the guest on the
host->guest donation transitions, we allow block-level annotations to
ensure the host stage-2 mapping size matches the guest stage-2.

2. Expand ownership transition HVCs:

Enable the ownership test to work with PMD_SIZE so we can test
transitions supporting more than PAGE_SIZE.

3. Implements the PKVM_HYP_REQ_SPLIT hypervisor request:

Allows the hypervisor to ask the host to split a mapping. This ensures
the guest s2, pkvm_mapping tree and host s2 are always using the same
mapping size.

4. Wires up THP support for protected VMs:

Use a PMD_SIZE mapping for protected VMs whenever
transparent_hugepage_adjust() acknowledge the presence of a huge-mapping
in the VMM stage-1.

Changelog:

v4:
  - Pass level instead of size to kvm_pgtable_stage2_table_install(),
    check addr alignment, and fix kernel-doc (Sashiko)
  - Wrap host_stage2_split_gfn_meta() with host_stage2_try() (Sashiko)
  - Drop PKVM_HYP_REQ_SPLIT from pkvm_memunshare_call() (Sashiko)

v3 (https://lore.kernel.org/all/20261102204628.401871-1-vdonnefort@google.com/):
  - Move get_page() in stage2_map_prefault_idmap() from PATCH2 to PATCH1 (Wei-Lin, Mostafa)
  - Set map_data.phys in kvm_pgtable_stage2_annotate() (Sashiko)
  - Propagate -EHWPOISON and -EAGAIN from pkvm_pin_user_pages() to protected_pkvm_mem_abort() (Sashiko)
  - Fall back to PAGE_SIZE when a PMD_SIZE mapping overlaps an existing PAGE_SIZE one (Fuad)
  - Reject !nr_pages in pfn_range_is_valid()
  - Use mmu_invalidate_retry()
  - Rebase on 7.4-rc1

v2 (https://lore.kernel.org/all/20260911135053.146435-1-vdonnefort@google.com/):
  - Reorder patches to make the series bisectable.
  - Check memcache and WARN_ON if stage-2 split fails in __pkvm_host_split_guest()
  - __pkvm_pgtable_stage2_split(): return 0 if the block is already split.
  - kvm_pgtable_stage2_table_install() to let mem_protect handle the stage-2 splitting.
  - Refactor fix_host_ownership() (Wei-Lin)
  - Handle non-linear mappings in fix_host_ownership()
  - Drop _page_ from __pkvm_host_reclaim_page_guest and __pkvm_reclaim_dying_guest_page() (Wei-Lin)
  - Make a separate patch for hyp_poison_range() (Wei-Lin)
  - Use folio_add_pins in __pkvm_pgtable_stage2_split() (Wei-Lin)
  - Hold the mmap_read_lock() for transparent_hugepage_adjust() (Sashiko)
  - Catch 2MiB fault on existing 4KiB fault (Sashiko)
  - Add share/unshare testing of split blocks.
  - Rebased on 7.3-rc2

v1 (https://lore.kernel.org/all/20260803100904.3563942-1-vdonnefort@google.com/)

Keir Fraser (1):
  KVM: arm64: Prefault host stage-2 entries on block split

Vincent Donnefort (22):
  KVM: arm64: Propagate host stage-2 annotated entries on block split
  KVM: arm64: Allow block-level stage-2 annotation
  KVM: arm64: Use block-level annotations when setting up the host
    stage-2
  KVM: arm64: Make pKVM ownership selftest an HVC
  KVM: arm64: Reject zero-sized ranges in pfn_range_is_valid()
  KVM: arm64: Add a range to __pkvm_host_share/unshare_hyp()
  KVM: arm64: Add a range to __pkvm_host_donate_guest()
  KVM: arm64: Add a range to hyp_poison_page()
  KVM: arm64: Add a range to __pkvm_host_reclaim_guest()
  KVM: arm64: Add a range to __pkvm_guest_share_host()
  KVM: arm64: Add a range to __pkvm_guest_unshare_host()
  KVM: arm64: Handle huge mappings in
    __pkvm_host_force_reclaim_page_guest()
  KVM: arm64: Handle huge mappings in __pkvm_vcpu_in_poison_fault()
  KVM: arm64: Add a range to pKVM ownership selftest
  KVM: arm64: Warn on pKVM guest stage-2 block collapse
  KVM: arm64: Add vcpu conduit for pkvm_hyp_req
  KVM: arm64: Introduce kvm_pgtable_stage2_table_install()
  KVM: arm64: Add __pkvm_host_split_guest HVC
  KVM: arm64: Extend pKVM page ownership selftests to cover guest block
    split
  KVM: arm64: Add PKVM_HYP_REQ_SPLIT
  KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing
  KVM: arm64: Stage-2 huge mappings for protected VMs

 arch/arm64/include/asm/kvm_asm.h              |  14 +-
 arch/arm64/include/asm/kvm_hcall.h            |  10 +-
 arch/arm64/include/asm/kvm_host.h             |  31 +
 arch/arm64/include/asm/kvm_pgtable.h          |  13 +
 arch/arm64/include/asm/kvm_pkvm.h             |  35 +-
 arch/arm64/kvm/handle_exit.c                  |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   5 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   6 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  43 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 591 ++++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  41 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 165 +++--
 arch/arm64/kvm/hyp/pgtable.c                  | 140 ++++-
 arch/arm64/kvm/mmu.c                          | 128 ++--
 arch/arm64/kvm/pkvm.c                         | 247 +++++++-
 arch/arm64/kvm/trace_pkvm.h                   |   4 +-
 18 files changed, 1113 insertions(+), 400 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.1.708.g77570a6a1d-goog

