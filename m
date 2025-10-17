Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE41E1DE7
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661170; cv=none; b=qNdqpEEgb7zf3W3B2pK14Ag+DrYoprF4f015YEFvBTphwOvt6SDdc3iBiqXi4m2Um6AWgLl5Rc6gfbd6WprHnnIsdk56tgLLsfygF2VxkX2cLtdoDoAIxJJBR+wjO0wArxvAAb/uzJNlPQpWYZ/pW7YWa4cWzheCUtQ1Acaj484=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661170; c=relaxed/simple;
	bh=ak2l1w4dqrmwmEISFLg2hMy6SydMKCTU9LZWqVjcy/M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fKLepUzS6EUWugzM6xO78q+GGNaA8splAdWfNRsMkdfn0/LS91JX7l5av+lwcA2FCc0UW2N/pT7bpvrjhIzv1grNeDExAZwgVr30UpsKndc9gK8G8WWXAuhAiizKLRWZb/OxjJR4lzXt1TokVY2e10aTJLI5gIeG3ceDhVjUhsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kP/oFjEA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kP/oFjEA"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so1155801a91.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661168; x=1761265968; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IUhhIOZQl1LmuwLSXSpqUy/3rFv/MJFTCRm/41SsmT4=;
        b=kP/oFjEAG5TUMhdQhwexOGFemp0C6Gi/2emGPonsiAt/27k734BUwYousa/t6UhJ1H
         SUTgMEnvVxl98P8baglEtKlCVrY/A3VzVWy9ustAZ229mGp/4VIc+Sjcm+WnKm/Agoa6
         1K4LIokt/NFOytkWnw5I1h71QR9C9mUxEgqmeb/Ut9hB7ICJX0wQd6MI/+t5PrHQqZW/
         SOeuOYbzEbJtsakBaq6wdDkBjRzviMxhoF/gIk5b9Npjmur7SCIvvXLzhzxRaJZ51EnL
         HOzwAXgcRkTzX1AgbYud/A7wcL/+LFZouTR9Ndimre2fI/VLOaydOYTerPcRHRT8eu7j
         RWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661168; x=1761265968;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IUhhIOZQl1LmuwLSXSpqUy/3rFv/MJFTCRm/41SsmT4=;
        b=la6yaJkT5JefxGETO22txiRyTJq8ni0xqWkRfUUx/hy1kb8+QUD88Wx7w4YLG1ChPv
         sdPg0jcmet9NqBpWN96H9c0nVVa4MslswfE8XmDSbnUOdTCLNBPOtwRD1+SWEcCID/tP
         n6jJRsiv2cIc7LIAxqkNbntiiFg4vjUU4LLEXej9Xhwcyl739Y5gNcuoFRHG7Fgadshz
         De7RZXxBq1xryXevQwQITFLeuV56odIsGNwll0NSR93mbmjzGcrfvi8fnjB/RgdYL3Zg
         ef1bnnDyiQTJeTJdw5Mgh09ahmZSoFEWwYxD/FLDRgPutjjEvvz8+6I7H7ObDuypzUKu
         auQA==
X-Forwarded-Encrypted: i=1; AJvYcCV/hJEu339NraxN6JoGZQt+l5znti/PKFac12NV6ASHE1Zrh4rbn7VoS7jjV/hAXVMuu0mYjLw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJU2KVlYHvhGYm69WEGGysbeVDd+Kg+VcATuXTA4mJHreRYUvj
	wVBw/zP3UWGgFNFXl8tjDHpaUMHjX3/+X/5pT1QcSCJxqAU8TjHeSHOxNteprGKn+KGN4xMMCeL
	dCzGUZQ==
X-Google-Smtp-Source: AGHT+IGuHGQyD51mVtQEohHO8NdP+zAwWbn/b6u+mCKYmFM3Ij1iHsaMWgJCqF8QAg/mESpyN5uCXlDFqHE=
X-Received: from pjblk6.prod.google.com ([2002:a17:90b:33c6:b0:33b:51fe:1a74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a81:b0:32e:ddbc:9bd6
 with SMTP id 98e67ed59e1d1-33bcf8f9431mr1768955a91.27.1760661168259; Thu, 16
 Oct 2025 17:32:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:18 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-1-seanjc@google.com>
Subject: [PATCH v3 00/25] KVM: x86/mmu: TDX post-populate cleanups
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Non-x86 folks, patches 1 and 2 are likely the only thing of interest here.
They make kvm_arch_vcpu_async_ioctl() mandatory and then rename it to
kvm_arch_vcpu_unlocked_ioctl().  Hopefully they're boring?

As for the x86 side...

Clean up the TDX post-populate paths (and many tangentially related paths) to
address locking issues between gmem and TDX's post-populate hook[*], and
within KVM itself (KVM doesn't ensure full mutual exclusivity between paths
that for all intents and purposes the TDX-Module requires to be serialized).

Compile tested only again on my end, but Rick and Yan took v2 for a spin, so I
dropped the RFC.

[*] http://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com

v3:
 - Collect more reviews.
 - Add the async_ioctl() => unlocked_ioctl() patches, and use the "unlocked"
   variant in the TDX vCPU sub-ioctls so they can take kvm->lock outside of
   vcpu->mutex.
 - Add a patch to document that vcpu->mutex is taken *outside* kvm->slots_lock.
 - Add the tdx_vm_state_guard CLASS() to take kvm->lock, all vcpu->mutex locks,
   and kvm->slots_lock, in order to make tdx_td_init(), tdx_td_finalize(),
   tdx_vcpu_init_mem_region(), and tdx_vcpu_init() mutually exclusive with
   each other, and mutually exclusvie with basically anything that can result
   in contending one of the TDX-Module locks (can't remember which one).
 - Refine the changelog for the "Drop PROVE_MMU=y" patch. [Binbin]

v2:
 - Collect a few reviews (and ignore some because the patches went away).
   [Rick, Kai, Ira]
 - Move TDH_MEM_PAGE_ADD under mmu_lock and drop nr_premapped. [Yan, Rick]
 - Force max_level = PG_LEVEL_4K straightaway. [Yan]
 - s/kvm_tdp_prefault_page/kvm_tdp_page_prefault. [Rick]
 - Use Yan's version of "Say no to pinning!".  [Yan, Rick]
 - Tidy up helpers and macros to reduce boilerplate and copy+pate code, and
   to eliminate redundant/dead code (e.g. KVM_BUG_ON() the same error
   multiple times).
 - KVM_BUG_ON() if TDH_MR_EXTEND fails (I convinced myself it can't).

v1: https://lore.kernel.org/all/20250827000522.4022426-1-seanjc@google.com

Sean Christopherson (23):
  KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
  KVM: Rename kvm_arch_vcpu_async_ioctl() to
    kvm_arch_vcpu_unlocked_ioctl()
  KVM: TDX: Drop PROVE_MMU=y sanity check on to-be-populated mappings
  KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
  Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP
    MMU"
  KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
  KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
  KVM: TDX: Fold tdx_sept_drop_private_spte() into
    tdx_sept_remove_private_spte()
  KVM: x86/mmu: Drop the return code from
    kvm_x86_ops.remove_external_spte()
  KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
  KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
  KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole caller
  KVM: TDX: Bug the VM if extended the initial measurement fails
  KVM: TDX: ADD pages to the TD image while populating mirror EPT
    entries
  KVM: TDX: Fold tdx_sept_zap_private_spte() into
    tdx_sept_remove_private_spte()
  KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error() into TDX_BUG_ON()
  KVM: TDX: Derive error argument names from the local variable names
  KVM: TDX: Assert that mmu_lock is held for write when removing S-EPT
    entries
  KVM: TDX: Add macro to retry SEAMCALLs when forcing vCPUs out of guest
  KVM: TDX: Add tdx_get_cmd() helper to get and validate sub-ioctl
    command
  KVM: TDX: Convert INIT_MEM_REGION and INIT_VCPU to "unlocked" vCPU
    ioctl
  KVM: TDX: Use guard() to acquire kvm->lock in tdx_vm_ioctl()
  KVM: TDX: Guard VM state transitions with "all" the locks

Yan Zhao (2):
  KVM: TDX: Drop superfluous page pinning in S-EPT management
  KVM: TDX: Fix list_add corruption during vcpu_load()

 arch/arm64/kvm/arm.c               |   6 +
 arch/loongarch/kvm/Kconfig         |   1 -
 arch/loongarch/kvm/vcpu.c          |   4 +-
 arch/mips/kvm/Kconfig              |   1 -
 arch/mips/kvm/mips.c               |   4 +-
 arch/powerpc/kvm/Kconfig           |   1 -
 arch/powerpc/kvm/powerpc.c         |   4 +-
 arch/riscv/kvm/Kconfig             |   1 -
 arch/riscv/kvm/vcpu.c              |   4 +-
 arch/s390/kvm/Kconfig              |   1 -
 arch/s390/kvm/kvm-s390.c           |   4 +-
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   5 +-
 arch/x86/kvm/mmu.h                 |   3 +-
 arch/x86/kvm/mmu/mmu.c             |  66 ++-
 arch/x86/kvm/mmu/tdp_mmu.c         |  45 +-
 arch/x86/kvm/vmx/main.c            |   9 +
 arch/x86/kvm/vmx/tdx.c             | 638 ++++++++++++++---------------
 arch/x86/kvm/vmx/tdx.h             |   8 +-
 arch/x86/kvm/vmx/x86_ops.h         |   1 +
 arch/x86/kvm/x86.c                 |  13 +
 include/linux/kvm_host.h           |  14 +-
 virt/kvm/Kconfig                   |   3 -
 virt/kvm/kvm_main.c                |   6 +-
 24 files changed, 422 insertions(+), 421 deletions(-)


base-commit: f222788458c8a7753d43befef2769cd282dc008e
-- 
2.51.0.858.gf9c4a03a3a-goog

