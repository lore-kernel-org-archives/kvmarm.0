Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEC14AA41E
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367287; cv=none; b=TyZpC1o8Sb6u7fr1EZRV/P3OYvzPaWxoA+eVDS1ZDXVyX5ay1F9FAqFAvHBO4biNJ3/VF8MqyXRcNZBmrNOeN/UgjFMnDRd74SPG6sQt0u4MYEOUIDGZM8OobWPP+KuB2+rI1tVoXaYTK1JbDmGDq+0Ru+k9EGRbDxtePkq9WpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367287; c=relaxed/simple;
	bh=zsFbTSNS49K5fTTJHxNrCzc+5y/Ob23CZWVIBOZR8bM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D45Mh10zFfBWSc0tJUxpNxOnzWZ77NrMXxw+Q8ARnU0i+OzaF1w4HMrKdbNxz92DiPW8s2hNKzr/pfUX7HG7dkdw1ipf5WQO2qxLWubRnBuQ/mwoQk4vYMMMtJ+8pCG7K1yGyDhOn7WjNflr+OG3oiYwPo0YLYw+Pt4ozIYTeEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dGDVN6lD; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dGDVN6lD"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3968bb86fb7so1748743a91.2
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367285; x=1788972085; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=frOgBPC40pi3x0hlZEdVguNDXI4epigXANzoQJEvIq8=;
        b=dGDVN6lD/TS0ypGdo8B8R5kXdQuVhJAhgiIaxN8LiZyHPXa4izNxhjYpq5K4kn7ME4
         O2YUwWte73daTZ72g2i+aTNxqpaxCeVffkcdtPq/NAVwcq/IJoJrGTBp9IjEgnPogP4u
         PJwURqe6A2fXrNRMxnpDbHpT3aHACp95vyMnQ11wlFECbEJ2Yq8+Y/d85XA5v3F06YMO
         HdzZuIGdWpBWu+5kO7VgWzu0c4oaqL50raHoH/VHHK/BY8pJxwBAVpj0FpOZfAG/merV
         vQJ6DZJqZZAL3llJ+EYmwGPB8X8jqkPPeK3UIRerz35R1XtXvOGlu0AfTJw7GamVQ/CF
         a39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367285; x=1788972085;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=frOgBPC40pi3x0hlZEdVguNDXI4epigXANzoQJEvIq8=;
        b=NrF9yAbq8qCxmNKQQivYJIeSeEz16KOd3q3l4UqA1iB1XavZWh1JNUhy2PnygHxw4S
         KhvLJuj2cIXjIWls56hhfPLsxJ0DNR7UxO/hNpdYGGxI09N3KCf4iBKWj7nVECMwqRn/
         ca30MqhEmYBpPG03vgDHpO3EJb0XYXhlc4t/kLWDSA+lcD2PKPSI+oMnbnutp0juYzpc
         nT6cM9/xzY4k4cfzRL12Jw4pZ6kQTnC7e3GLhJwJLojc34BZ0C7XBtxDht9/a7jw4KZg
         L7SNRH9LJkRg56WfUuaxp791P8X2heaxkASwG0vu4VY3dltTH2MJJ34tdovnmmFWvWCb
         7nOw==
X-Forwarded-Encrypted: i=1; AKwUvBwL9Z0e4sAklyp1D0tQaEfahjmv3clU+qOKfbIuDPMV5gT2dbLj6NVvyMpyXRviKuJ/Yft1zk0=@lists.linux.dev
X-Gm-Message-State: AFuF++k1ZumFqSEQm/9C0z33Rz1LsGrEPZ7F7siJsQ5cIlMwcf26DGa5
	4a01PiVJb2rUZgJTBz9+78obQuDnf9JSmv2izPCrsj6qvopN3LT84KFrU4msSFGnE9Auc3yuEDf
	1JcCddw==
X-Received: from pjbbh12.prod.google.com ([2002:a17:90b:48c:b0:381:171e:961c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d4f:b0:37f:e1b6:4c7d
 with SMTP id 98e67ed59e1d1-39aedf1aec2mr9689222a91.6.1788367284482; Wed, 02
 Sep 2026 09:41:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:03 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-1-seanjc@google.com>
Subject: [PATCH v2 00/20] KVM: selftests: PPC pre-enabling
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

This is a big pile of cleanups and refactoring to prepare for PPC support in
KVM selftests.  PPC has paging modes that require multi-page page tables, and
those page tables need to be naturally aligned.  The original proposal was to
plumb in an @align param to the page allocators[*], but I didn't love the idea
of adding another rarely used param to the allocators.

v2:
 - Collect tags. [Itaru, Bibo]
 - Use 0x180000 as the min GPA for page table pages on LoongArch, instead of
   changing every other arch to use 0x200000. [Sashiko, Bibo]
 - Opportunistically move the vGIC LPI stress test's global "gpa_base" variable
   into setup_memslot(). [Sashiko]

v1: https://lore.kernel.org/all/20260826230511.972824-1-seanjc@google.com

[*] https://lore.kernel.org/all/df86b5ccdbdafc3509d9538bd5e6796737bab2db.1781093720.git.ritesh.list@gmail.com

Nicholas Piggin (1):
  KVM: selftests: Use goto instead of do-while to retry finding unused
    physical pages

Sean Christopherson (19):
  KVM: selftests: Use MEM_REGION_PT memslot instead of '0' for s390
    regions/segments
  KVM: selftests: Use the common minimum GPA for page tables on
    LoongArch
  KVM: selftests: Use vm_alloc_page_table() to allocate LoongArch page
    tables
  KVM: selftests: Rename "num" param to "nr_pages" for physical page
    allocators
  KVM: selftests: Extend page allocator to support naturally aligned
    allocations
  KVM: selftests: Make the single-page allocator APIs static inline
  KVM: selftests: Use the innermost page allocator API in the memslot
    perf test
  KVM: selftests: Use the innermost page allocator API in s390's IRQ
    routing test
  KVM: selftests: Add a wrapper API to allocate multiple page table
    pages
  KVM: selftests: Initialize vm->memslots[] with invalid memslots during
    creation
  KVM: selftests: Add APIs to override memory region types with custom
    memslots
  KVM: selftests: Add TEST_EXTRA memory region type for "special"
    memslots
  KVM: selftests: Use TEST_EXTRA region in arm64's vGIC LPI stress test
  KVM: selftests: Use TEST_EXTRA region in x86's smaller MAXPHYADDR test
  KVM: selftests: Use TEST_EXTRA region in set memory region test
  KVM: selftests: Take the memory region type, not memslot, in page
    allocators
  KVM: selftests: Use TEST_ASSERT(), not assert(), in
    vm_get_mem_region()
  KVM: selftests: Automatically pick min_gpa for allocations based on
    region type
  KVM: selftests: Add arch hook to force page tables to be naturally
    aligned

 .../selftests/kvm/arm64/page_fault_test.c     |  18 ++-
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |  21 ++-
 .../testing/selftests/kvm/include/kvm_util.h  | 106 +++++++++++++--
 tools/testing/selftests/kvm/include/x86/smm.h |   2 +-
 .../selftests/kvm/lib/arm64/processor.c       |   4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 127 +++++++++++-------
 .../selftests/kvm/lib/loongarch/processor.c   |   5 +-
 .../selftests/kvm/lib/riscv/processor.c       |   4 +-
 .../selftests/kvm/lib/s390/processor.c        |   7 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  15 ++-
 .../testing/selftests/kvm/memslot_perf_test.c |   3 +-
 tools/testing/selftests/kvm/s390/cmma_test.c  |  19 +--
 .../testing/selftests/kvm/s390/irq_routing.c  |   2 +-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 .../x86/smaller_maxphyaddr_emulation_test.c   |   9 +-
 15 files changed, 221 insertions(+), 129 deletions(-)


base-commit: 76671054f9a1ff6abb976583cd8da37650acdc97
-- 
2.55.0.966.g6673acef38-goog

