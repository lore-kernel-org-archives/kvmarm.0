Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12E425B31C
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855002; cv=none; b=IsXUekm4F9T51hEa7kemLua/TND5LYrHfwEMZfDC2unWp+fKjDlb6k9DhkMGe+eXCDQ64ECoao0PuJF+AR1d9ZFW4QLA1UqQU4Ssda2779Ep7lMdtZXfQrMSwVJZHAhDo2IJAPOLS3Jgeyq4cHubgLA+goHmGF58WRtfwGlCxrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855002; c=relaxed/simple;
	bh=iWqK9o5Q9lSs0dNS4loIwGhdjpS9qDnFS67Z8kLa5ZY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QTM3DBVHJukRdXxGGtOCwuTidr26newRPpLLUyTEOtJE/LWBWWSL2zgqZ31qinODrzg/myFNi9cP3KlRATfKN0pgkYN5CLNepFDh5bFSFvKNShbxcFML2Y0YR2GG2+E67Rqd0EYBfXE7dX8MWMA1Nk8OTrcMCUzdKyGbdqZ2UMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DTGqI55w; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTGqI55w"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33d8970ae47so1738446a91.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761854999; x=1762459799; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zrcNX0WZe6UQQAW+Y1acRpaDavildHCqqfp5zf8UBT8=;
        b=DTGqI55wzEYVW1NB2h+8LrW+7l5/EARBomcA83qYy3dScTQHKy3xOSFqexBiGs7Ql8
         iAiwUTMCaBGvAb1rAPbRmAWyWOgaSTVLrmLWfI+pRNYo/XmLrPnlNQFgaNLG74nVYP4w
         5WMdlJPgJASLCSDhikpa8RxIdxY4V4OXSg6JTvv2ByITKrWtoM3Fwi5OcZA4Zz+wEBJs
         JNRiJVhe3/LlfdcN0zhwdnumXGf3sF3mpB6v2SySQ/CFUoABSp3ne9zYekrv6ZbWY1y8
         WAd+NwM3c6HuGnRuOA8KAd2M5vzQCV+/Owk3Z3YEJv1IxA0jd+yiffsoUnAtaa7M6KIi
         66/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761854999; x=1762459799;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zrcNX0WZe6UQQAW+Y1acRpaDavildHCqqfp5zf8UBT8=;
        b=UKD4NLvp971L59D0KwjzFvqv7V6YUgpDxrDtFm33upxCOpmbdCyXveCYoz6PQ/UvP4
         2KTY8s68FhQrA5bUohOyQa0A4VVnkyv+llOekqo43Vnhh8Jv0DtlYVDcCbNUvKcX7fYm
         mTmDjDctYwh3kUAdou6D4jZi5mtKnconCR4tpC0Zt+yQFAvf0UlFwLhj06TLNqVTSKQW
         7ofEdT4F/t3NbWlcedOTQFLsCCCYYjGyP5x9YyC0Yfiah436+FEzt2tu/iacikQKUEaH
         nnIQVn1oKvfzXLcdm7AEeDjRe39WWb/61+46Py7IPlNdrD0GgZYsVAkf3ChdfK6eAoW2
         NQKA==
X-Forwarded-Encrypted: i=1; AJvYcCWD4Derxw2LUejhdXOiqkogqZFdl5vi6nm4saOUkvs6TfhPN17yVVW3E9dXuTGoEeUNEHEGcRs=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywfp6Q5t/TiBDSceciqUECLkT7lkJXyB3xsML707CFlBrhRIMZ3
	B6KKITB8xS0Yxiom4svnUeQibfbB1fjurwhy2IkUREiDrCOUIxG2e50s9f+RYGdISCQgMncoPNc
	DGPKQcw==
X-Google-Smtp-Source: AGHT+IHHZpNGbgjLGw+ZYpoCrFPTV304XH1EL6WE9wIH48O/1tSukWUG1dLDd7KIv/LOoUL3Sr92aGNZzYE=
X-Received: from pjvp23.prod.google.com ([2002:a17:90a:df97:b0:339:e59f:e26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d40c:b0:33b:b020:5968
 with SMTP id 98e67ed59e1d1-34083071b1emr1223925a91.21.1761854998946; Thu, 30
 Oct 2025 13:09:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:23 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-1-seanjc@google.com>
Subject: [PATCH v4 00/28] KVM: x86/mmu: TDX post-populate cleanups
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
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Non-x86 folks, as with v3, patches 1 and 2 are likely the only thing of
interest here.  They make kvm_arch_vcpu_async_ioctl() mandatory and then
rename it to kvm_arch_vcpu_unlocked_ioctl().

As for the x86 side...

Clean up the TDX post-populate paths (and many tangentially related paths) to
address locking issues between gmem and TDX's post-populate hook[*], and
within KVM itself (KVM doesn't ensure full mutual exclusivity between paths
that for all intents and purposes the TDX-Module requires to be serialized).

I apologize if I missed any trailers or feedback, I think I got everything...

[*] http://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com

v4:
 - Collect reviews/acks.
 - Add a lockdep assertion in kvm_tdp_mmu_map_private_pfn(). [Yan]
 - Wrap kvm_tdp_mmu_map_private_pfn() with CONFIG_KVM_GUEST_MEMFD=y. [test bot]
 - Improve (or add) comments. [Kai, and probably others]
 - s/spte/mirror_spte to make it clear what's being passed in
 - Update set_external_spte() to take @mirror_spte as well. [Yan]
 - Move the KVM_BUG_ON() on tdh_mr_extend() failure to the end. [Rick]
 - Take "all" the locks in tdx_vm_ioctl(). [Kai]
 - WARN if KVM attempts to map SPTEs into an invalid root. [Yan]
 - Use tdx_flush_vp_on_cpu() instead of tdx_disassociate_vp() when freeing
   a vCPU in VCPU_TD_STATE_UNINITIALIZED state. [Yan]

v3:
 - https://lore.kernel.org/all/20251017003244.186495-1-seanjc@google.com
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


Sean Christopherson (26):
  KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
  KVM: Rename kvm_arch_vcpu_async_ioctl() to
    kvm_arch_vcpu_unlocked_ioctl()
  KVM: TDX: Drop PROVE_MMU=y sanity check on to-be-populated mappings
  KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
  KVM: x86/mmu: WARN if KVM attempts to map into an invalid TDP MMU root
  Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP
    MMU"
  KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
  KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
  KVM: TDX: Fold tdx_sept_drop_private_spte() into
    tdx_sept_remove_private_spte()
  KVM: x86/mmu: Drop the return code from
    kvm_x86_ops.remove_external_spte()
  KVM: TDX: WARN if mirror SPTE doesn't have full RWX when creating
    S-EPT mapping
  KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
  KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
  KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole caller
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
  KVM: TDX: Don't copy "cmd" back to userspace for KVM_TDX_CAPABILITIES
  KVM: TDX: Guard VM state transitions with "all" the locks
  KVM: TDX: Bug the VM if extending the initial measurement fails

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
 arch/x86/include/asm/kvm_host.h    |   7 +-
 arch/x86/kvm/mmu.h                 |   3 +-
 arch/x86/kvm/mmu/mmu.c             |  87 +++-
 arch/x86/kvm/mmu/tdp_mmu.c         |  50 +--
 arch/x86/kvm/vmx/main.c            |   9 +
 arch/x86/kvm/vmx/tdx.c             | 659 ++++++++++++++---------------
 arch/x86/kvm/vmx/tdx.h             |   8 +-
 arch/x86/kvm/vmx/x86_ops.h         |   1 +
 arch/x86/kvm/x86.c                 |  13 +
 include/linux/kvm_host.h           |  14 +-
 virt/kvm/Kconfig                   |   3 -
 virt/kvm/kvm_main.c                |   6 +-
 24 files changed, 468 insertions(+), 424 deletions(-)


base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057
-- 
2.51.1.930.gacf6e81ea2-goog

