Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BF7156991
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550865; cv=none; b=ivRtI61pp+9XH8CbR2prxsdfCmo3KVN6xzPBe1GZZ2Pf7OqbwD/0I6BWZgT5pej/i9FJCHfOBVuAR6PRMCA0r9czspobeNAVFwCaKBIb+z7nuHN0GqEjo+5KOuUw5tZ6RvS2Kt3S/rd2PHm0ecBslXrkHxc7j/HtnQjazGM91lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550865; c=relaxed/simple;
	bh=zshUS4w0ve2iUp3o84hDt1hlZ5z3480G0Ybp7ZRHk7E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=f8Z7THZF139BvPy8p8M2LHyY0rlHm9Z2C9iTogcHK6TPxUeO6ey+Vk+cmwKh/vJWjtoeHEHuGIJNESIHdrVd1xC2r/qVAI84WiCYjzEZu/W/wEvEJ63y/EHSEIJmnMA/tfPqFY8LHUMP5j8u+TysUwIN2KHvlQvggw6VN83bmuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=raup3Gjm; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="raup3Gjm"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa6a87f324cso360166b.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550862; x=1735155662; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y0egGk+E5zbRv4inQflxneULbdFdTnonLDTj+BKj8O4=;
        b=raup3GjmsbtIOnCzK1979/m4mFZhdk/vsy6NdbQe2DgR7Nf5nTs8TZ/ePTrYYs31EU
         B8CKJdFGltdTpscaRpSLQCyugK0KPzfekbU4hNoDiYOsGKpth+MEe2waJ7S6UvsFBy/g
         AcN0w1APN9TLxwFQySZg2uXKjAMgGlINajrXoXjU0o5N4OalaouzUaoGG8CgxR295o4j
         3kKQoeENIVJgsQivDBTsn+SIFiDEGiICbDU6Rvztp3cYDFxJJAsASX1CBBANkQJQMksN
         1wLAHCI0tT35P71HJ9k1sQfHFOO/iHDpTfLer+dV6lPMTA2uEzF/AsZMWybQGO9sH308
         5j/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550862; x=1735155662;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y0egGk+E5zbRv4inQflxneULbdFdTnonLDTj+BKj8O4=;
        b=khQJQtJeHxgSwBH1zHmEPadZqzytU0CXueKG6MjUCsQOtEttkdBelGmUFehKf1ZD6z
         D0X9YsxAQBep+Zfjqgwn9sVMw3+Hlx2T8cMnPR7YNIfkZyxm6bYuvMuzagJgJ/EB/6I1
         PPHV2RCTA2EoETD8n6bciMuw6bXKyrSbFnJ/2tZDA2MyRvXbWMss65MHe8oOGutUE8gN
         aqXhPcUMRVoHCxpsqZqEIFn9xPfZLNOBfH0Mf8FjpJcGdtES3qBz7Bv0xhTis48TXppM
         gKG4u0eZW3tiI7AEJxPdTQLwtVFat4RDi/pth/nJipcHqOWlgNDFsFwGP5Un9ZDxCPoy
         UyOw==
X-Forwarded-Encrypted: i=1; AJvYcCVAhX94DZgQyMLKfvrFSd+2yYXRqCqWrgRcl7XpSPe99OAlpLUmp/yq1c4mDzVltO/IMi68pAI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwI34tUd3ooyR9p9N2+/71DA4Nl4Kv9SMDMIisVsfB9EZqUyPos
	vBOTIpyMfUvZ3e7BZ8H0JUABBsH3i3Sq5B9zHjUFE5RJwNxuhmdIo7UHW8uCYk22MeQCCCdKUaX
	AK5IYww==
X-Google-Smtp-Source: AGHT+IFF9Bdl3ykGIZN5hSEGfg9Lfi7RyKI7xaF+0V/m/PtNz8TEdHZF7hKeCCrU7cTy07W+PAd0JMzpUqE1
X-Received: from ejcsr10.prod.google.com ([2002:a17:907:398a:b0:aa6:a5c6:7ad0])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:32c4:b0:aa6:762e:8c1c
 with SMTP id a640c23a62f3a-aac07a51ea1mr60053066b.48.1734550862066; Wed, 18
 Dec 2024 11:41:02 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-1-qperret@google.com>
Subject: [PATCH v4 00/18] KVM: arm64: Non-protected guest stage-2 support for pKVM
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

This is the v4 of the series adding support for non-protected guests
stage-2 to pKVM. Please refer to v1 for all the context:

  https://lore.kernel.org/kvmarm/20241104133204.85208-1-qperret@google.com/

Please note that in its current form, this series has two main
limitations that will be addressed separately:

 - We don't support mapping devices into guests: this requires
   additional hypervisor support for tracking the 'state' of devices.
   No device assignment until then.

 - Stage-2 mappings are forced to page-granularity even when backed by a
   huge page for the sake of simplicity of this series. I'm only aiming
   at functional parity-ish (from userspace's PoV) for now, support for
   HP can be added on top later as a perf improvement.

The series is organized as follows:

 - Patches 01 to 04 move the host ownership state tracking from the
   host's stage-2 page-table to the hypervisor's vmemmap. This avoids
   fragmenting the host stage-2 for shared pages, which is only needed
   to store an annotation in the SW bits of the corresponding PTE. All
   pages mapped into non-protected guests are shared from pKVM's PoV,
   so the cost of stage-2 fragmentation will increase massively as we
   start tracking that at EL2. Note that these patches also help with
   the existing sharing for e.g. FF-A, so they could possibly be merged
   separately from the rest of the series.

 - Patches 05 to 07 implement a minor refactoring of the pgtable code to
   ease the integration of the pKVM MMU later on.

 - Patches 08 to 16 introduce all the infrastructure needed on the pKVM
   side for handling guest stage-2 page-tables at EL2.

 - Patches 17 and 18 plumb the newly introduced pKVM support into
   KVM/arm64.

Patches based on 6.13-rc3, tested on Pixel 6 and Qemu.

Changes in v4:
 - Collected Tested-by and Reviewed-by tags
 - Reworked KVM_S2_PGT to help ctags/grepping kvm_pgtable_* functions
 - Minor cleanups throughout

Changes in v3:
 - Rebased on 6.13-rc3
 - Applied Marc's rework of the for_each_mapping_in_range() macro mess
 - Removed mappings_lock in favor the mmu_lock
 - Dropped BUG_ON() from pkvm_mkstate()
 - Renamed range_is_allowed_memory() and clarified the comment inside it
 - Explicitly bail out when using host_stage2_set_owner_locked() on
   non-memory regions
 - Check PKVM_NOPAGE state as an equality rather than a bitwise
   operator
 - Reworked __pkvm_host_share_guest() to return -EPERM in case of
   illegal multi-sharing
 - Added get_np_pkvm_hyp_vm() to simplify HVC error handling in
   hyp-main.c
 - Cosmetic changes and improved coding consitency thoughout the series

Changes in v2:
 - Rebased on 6.13-rc1 (small conflicts with commit 2362506f7cff ("KVM:
   arm64: Don't mark "struct page" accessed when making SPTE young") in
   particular)
 - Fixed kerneldoc breakage for __unmap_stage2_range()
 - Fixed pkvm_pgtable_test_clear_young() to use correct HVC
 - Folded guest_get_valid_pte() into __check_host_unshare_guest() for
   clarity

Thanks,
Quentin

Marc Zyngier (1):
  KVM: arm64: Introduce __pkvm_vcpu_{load,put}()

Quentin Perret (17):
  KVM: arm64: Change the layout of enum pkvm_page_state
  KVM: arm64: Move enum pkvm_page_state to memory.h
  KVM: arm64: Make hyp_page::order a u8
  KVM: arm64: Move host page ownership tracking to the hyp vmemmap
  KVM: arm64: Pass walk flags to kvm_pgtable_stage2_mkyoung
  KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
  KVM: arm64: Make kvm_pgtable_stage2_init() a static inline function
  KVM: arm64: Add {get,put}_pkvm_hyp_vm() helpers
  KVM: arm64: Introduce __pkvm_host_share_guest()
  KVM: arm64: Introduce __pkvm_host_unshare_guest()
  KVM: arm64: Introduce __pkvm_host_relax_guest_perms()
  KVM: arm64: Introduce __pkvm_host_wrprotect_guest()
  KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
  KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
  KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
  KVM: arm64: Introduce the EL1 pKVM MMU
  KVM: arm64: Plumb the pKVM MMU in KVM

 arch/arm64/include/asm/kvm_asm.h              |   9 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/include/asm/kvm_mmu.h              |  16 +
 arch/arm64/include/asm/kvm_pgtable.h          |  38 ++-
 arch/arm64/include/asm/kvm_pkvm.h             |  26 ++
 arch/arm64/kvm/arm.c                          |  23 +-
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  39 +--
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  50 ++-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  16 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 201 ++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 320 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  14 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  69 ++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   7 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  13 +-
 arch/arm64/kvm/mmu.c                          |  93 +++--
 arch/arm64/kvm/pkvm.c                         | 201 +++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   6 +-
 19 files changed, 1006 insertions(+), 145 deletions(-)

-- 
2.47.1.613.gc27f4b7a9f-goog

