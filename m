Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652423;
	b=PUQbkN/sEMBjMRU46y7/QvlSpptDyx16sRYToxlJyh+m6wVjVtWeZp5JnnMS2e5Swbst
	 Jg7raxzueuPfXauT4z/AVBOTMGzYjfaaPqyk4YdlcULiBcKnMbJQE+USZ47Gbgyo7Vop+
	 tBVwFjxUopHOKFyUfp6OyzFDZl0pC2AtgU8lL7ZuLfFFwGqfyzLchtgnSsSBZByP54DSG
	 oiG3RrgZ/FZvKIfv8kQl4j19pvHuvnWtSSvIcfmd4DiPvtQJL8QoXx0tWL4rcOgu4Diqb
	 10aWbAIndAqh5rZo5YvCFkFuNw+LryPBYcM1qnS+RBF2JgHucQ4gGsxuAXFGYqpE3Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=zMsJQgVrf0JZ++d3iFatLVEh5rUSU8qY+49KgPh446g=;
	b=fZWrVO647MQ+xqBynBo/HoyrZIJaAMFCln/x1J3vT3DT2eVnoSG6YZCwIs6I3+WI5Eb4
	 //w+qFrGDHa0QHeKZ/w0opPAiOGF6IWkKDoJrAaAqilSxBWtoCsC3ZpUhDK3uATMEFRCq
	 HZyl6h9vR01KdgS+k6hp6WZiDDXRjWeZIr7tywPXUs/YkAYRdBXVTsTMAk3Pu+429L0W9
	 zn5U683nEEcg2Kc3PxUTkVAE6QS/es2a2b733MHQ6fA0e4hmYOMT7IMNMm1yZYPeJG+ei
	 jhuV+vzQ/y0eMdYAm4CvHWcPyzUhTgBNM0WLl1x709uXBJQtUZc3O8Yhtcbf18wSxqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gg2txX4I;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59EC606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A59EC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gg2txX4I
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a35e1d2dddso32294905e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652421; x=1794257221; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zMsJQgVrf0JZ++d3iFatLVEh5rUSU8qY+49KgPh446g=;
        b=Gg2txX4Ivhcv6tzWtsVdHggSo8YQlskHy0LUJrfmoFhNHe19WKWu43OaTLFkyFDK4x
         vouWePE/VGOpgBZ2l6nvdqNxlLzc+p1Gtw8S2grFewnSVMo5m7kXQGzZOraP9NMyIPXs
         mORpjBKCed1th1B7X1W9gOdSl+EcgYb25EP51v4CB7sCqCvdJCsZT+rUtUG0zj42ALhq
         +h7SdM9g25ed9SawpDqWAQPJCqqDIiulKd1GnwpiPFgpaFUUGT9QdsmpIqbKDqRXOBZR
         AtRI7n2gVnJNJJ3Ta2tdUSRMEkAKqN2DmkNQUtljQtiTjGdufdsX3cmIV7oDRmAPw6FR
         Kv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652421; x=1794257221;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zMsJQgVrf0JZ++d3iFatLVEh5rUSU8qY+49KgPh446g=;
        b=tVtBT1MXpGjDHQr8TUgmGaOpxTvt/JU+/yZTNKRfjB/l452+qy+8v6L8j9Nxc0aERi
         Uslt9WJxLUxjBN/7x6he/IYMxfelItAqNb11sd024F6LoE9yUdlbE8nm8tAojd1cF1qk
         EN25xRhvx5YmwTu96qo7gw7CisRGWjrMpDAz+0RheA5uKjBselF76VCYUo1rfNMKYI39
         sckZ5e93WPOyVz4YB6imnP+yImQEFX9QrwPXb9IC6X1rc4eWl2wP4i/sPbptxkumDPnT
         o1x+qJx9eQHcwKcSV2VY5h3u6ecdixDp+8pvfDgI0Fj1AhdEloE4/xsPv04NFQSC5ZWO
         wCgQ==
X-Forwarded-Encrypted: i=1; AKwUvByYdR8d3+WHRr318SmkT+YVDj65ms1Bjw/qagUX7orPkZ5KBIdVqQswAdF5ej1oXwTiKS3WeFg=@lists.linux.dev
X-Gm-Message-State: AFq9FYJJp3YLU3IDUV+U0pSfPgWuaRO++tp8ZStC3Q2K5GJiqUxiDb1G
	D4fUSgr2Qc5SOmVUDI8/lodhqtqTDhs5EbzklXzH7jzlXwI9L7GpsiVwDffqT5eopsIuKcMHF+K
	al8xs5rNZ3w1XriMzwTSaiQ==
X-Received: from wmos18.prod.google.com ([2002:a05:600c:45d2:b0:4b0:ea12:73b5])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:609a:b0:4a1:7c56:d4e2 with SMTP id 5b1f17b1804b1-4ac1709aa77mr243577525e9.16.1793652420742;
 Mon, 02 Nov 2026 12:47:00 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:05 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-1-vdonnefort@google.com>
Subject: [PATCH v3 00/23] Huge mapping support for protected VMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
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

v3:
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
 arch/arm64/include/asm/kvm_pgtable.h          |  12 +
 arch/arm64/include/asm/kvm_pkvm.h             |  35 +-
 arch/arm64/kvm/handle_exit.c                  |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   5 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   6 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  43 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 591 ++++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  59 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 165 +++--
 arch/arm64/kvm/hyp/pgtable.c                  | 139 +++-
 arch/arm64/kvm/mmu.c                          | 128 ++--
 arch/arm64/kvm/pkvm.c                         | 247 +++++++-
 arch/arm64/kvm/trace_pkvm.h                   |   4 +-
 18 files changed, 1126 insertions(+), 403 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.385.gac671c819a-goog

