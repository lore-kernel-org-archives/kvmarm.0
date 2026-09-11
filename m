Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081C8315D49
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134665; cv=none; b=XHTHVqwhf9or9ad4UUAOWpWaS8RwN6UIEIYQRAm1pXnu5oEbXQ6APrUSqTSUSi0WfJaMfnAXuBRJfzxMQBt5ZjEHLEEim9o/v9/kTkvV2RlMw/CYuh7vglQKFL8FslCy/+BWBGwQLaST7NzrmtOCeqxDy5giNBdwjVraU1vSEcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134665; c=relaxed/simple;
	bh=BTVw4BZWivcrbmZoie5zllHVfxspntg9niLEwaVDMjc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MtNX0SibrFaSXGshd2TxahKhcQvVCy9Z6BF+Sxd7rgeYJthLfttID3wB1RZ4A0YE1607awPH4K/eDaOtB6LAiEniUkh40Un0Cm2PjyjR/gKs8hCFB98nl7GA4HoVSbInOgBz4BZq06y9V4KxOnc589WNI4AhqS/r0kSTVhSfjA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I6yjcsiE; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I6yjcsiE"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49d0ae342b9so7436285e9.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134662; x=1789739462; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0QzfJ3v+aRb95us3MnZgava0wEqdBBJqMw7WQnYDtqE=;
        b=I6yjcsiEEVVd50BI/yl7dx6slcvWZwqiTHzJ9ZGtlrCmRabivaUkYIM6qlNY9aISju
         qWFFwBzDOW6q4qI5xyLTKE5esBVkmUV5CCG+g1IgI4Y65VLym7GiIn2TJIfA4URo0j4o
         BX90MBkGMVnudP5EzTp0fRdPnaRYPTzXtmal4EFp9wMCJ7S3UYax3ug+5MNfK+2ihV74
         XT8Kuh4jUbKZLsX6rLzMDYcD92VOzZcM3RIEUdbZxqBSgfajQnPkM0IVbNLrT50DosbR
         AwcuLq0Rux56dtlFRgq5DRuHqpT8ErgF2W7QnjRqFA7bYVTdS1DzIkfk/nfScCGWXemN
         gYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134662; x=1789739462;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0QzfJ3v+aRb95us3MnZgava0wEqdBBJqMw7WQnYDtqE=;
        b=YWupq+x+fBWGk5PBqnCNSO6xc16Siv/Nt16tXgNq460e7ZRIi2IX2T4B9WbJ2oguGq
         DFijxS4ilRJJhyLE3VIoy6Ku0YhcBDRKn0d4yNJRUDhkZ/OzWrxEoCPpksKgtPAEVI5i
         mMKvOlQG47ZK04MgeYKAAQDqx10pocM/rK1kEl/GkHwhw52PTNKxtgfRyiTnmqTKV8u3
         mKDwNIDC+rQgAIvKOHPBIJXAnU+Qyg2Dz+obHRcubRhvlb9++NnWC6UCEY8VFCLO8QE9
         EonfUFhNL+HRut44qtUTTmStH7zmunj5tEhLJFOQV2UUk+HOsotOo8LJI9nzaaF1l826
         0qtQ==
X-Forwarded-Encrypted: i=1; AKwUvBzun9OgZgn/2EPQpueADh/PpCSNzojCJ+UZ5FH/rbuTNuhzqrdGUQVZIwOhtQB8BFuzhRMUUAQ=@lists.linux.dev
X-Gm-Message-State: AFuF++kSJozS7O7e5SbMQW22jCjH9Rbxb1AcFret/xjDtZsHSMXHaY0f
	vpPNV07wZlNARfoA8MwjSQ28yL1PoG/a3soNhcJXyX2VH8beSDXL66JiPtfBNay27LNJb27Xosv
	xVC0M9YHCl55B//zZx1sNww==
X-Received: from wmdv10.prod.google.com ([2002:a05:600c:12ca:b0:49d:2629:5e30])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8485:20b0:49d:1e3d:3b3f with SMTP id 5b1f17b1804b1-49e6198bd27mr3941365e9.8.1789134661787;
 Fri, 11 Sep 2026 06:51:01 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-1-vdonnefort@google.com>
Subject: [PATCH v2 00/22] Huge mapping support for protected VMs
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

v2:
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

Vincent Donnefort (21):
  KVM: arm64: Propagate host stage-2 annotated entries on block split
  KVM: arm64: Allow block-level stage-2 annotation
  KVM: arm64: Use block-level annotations when setting up the host
    stage-2
  KVM: arm64: Make pKVM ownership selftest an HVC
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
  KVM: arm64: Add pkvm_hyp_req infrastructure
  KVM: arm64: Introduce kvm_pgtable_stage2_table_install()
  KVM: arm64: Add __pkvm_host_split_guest HVC
  KVM: arm64: Extend pKVM page ownership selftests to cover guest block
    split
  KVM: arm64: Add PKVM_HYP_REQ_SPLIT
  KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing
  KVM: arm64: Stage-2 huge mappings for protected VMs

 arch/arm64/include/asm/kvm_asm.h              |  14 +-
 arch/arm64/include/asm/kvm_host.h             |  19 +
 arch/arm64/include/asm/kvm_pgtable.h          |  12 +
 arch/arm64/include/asm/kvm_pkvm.h             |  18 +-
 arch/arm64/kvm/arm.c                          |   2 +
 arch/arm64/kvm/handle_exit.c                  |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   5 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   6 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  48 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 588 ++++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  59 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 140 +++--
 arch/arm64/kvm/hyp/pgtable.c                  | 137 +++-
 arch/arm64/kvm/mmu.c                          | 119 ++--
 arch/arm64/kvm/pkvm.c                         | 230 ++++++-
 arch/arm64/kvm/trace_pkvm.h                   |  44 ++
 18 files changed, 1129 insertions(+), 352 deletions(-)
 create mode 100644 arch/arm64/kvm/trace_pkvm.h


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.55.0.1007.g17ff1f9808-goog

