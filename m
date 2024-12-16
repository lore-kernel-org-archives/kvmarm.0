Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5690207E03
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371888; cv=none; b=tE8k6O15CCh8VBOvXTczNeyfoshZNyRND3WTqkSnt97bY7qc7CY/SLNeBzlK3KPaKmyyEsf5b6OWBf3mJghxXt5+T4FCinjCS/8j198AWM2UlfHVJRTauZuKa0VshfQxIhl6N89WVsyxL0Hx3Jn7xtZ/6VUTcZqXRKn1++NJMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371888; c=relaxed/simple;
	bh=7tIt7bChg8ottnajrUmnj8LyLrDCeA8W2VS5FD0IT+c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GPCPwdvxKn9462dJ/DXPG8LrgrW1aQnjOXSRgv89okoxJ7DmNJaD3ivm+TTxqG5bAe4QW7o4+6l2IZO7fnDiofcpWbR7apydKJzt+hgnMlNmTTAuzLLP4kjwcEmm4YUaIpIj+yStpha8RilX+KI6pVrXYxPfo7QGYg1/Jc8Y8No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0zsy0toF; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0zsy0toF"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa698b61931so316435166b.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371885; x=1734976685; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WIvO63JbCPAYWlPtJwQFaD85WRtYv7NId9N6OYZZ/Zg=;
        b=0zsy0toFIBlIzXh6irTtmqqoAKjh/j30Lw+6GXFMditkOgkzWleias+03dqXS6XCVK
         GXX53V/rAqcGUGRxNybjYHRevlBUsUzg2nW2XO2kI7zwnUb+t0sd+sILz/BZFpgHDlcc
         9XPzqm0wI/Joc23Z5xsweXJBsHT+5p8FsA6Qk5eGnyOT1NlQLip8fFsW5pqLcjvGhBbz
         rJcDXEvBJsBJ90TCF3fsZajyONQo8hYr9fOK4xSNFvwWxw0tZHRebGbJ+7KFuaD53fEi
         IP6q3g+XgpFzdL9Pc2mOe6tJKUKJWuZGbTtPILxxWasg7uunCY4i2jCCJWbhr9HEY77A
         uLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371885; x=1734976685;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WIvO63JbCPAYWlPtJwQFaD85WRtYv7NId9N6OYZZ/Zg=;
        b=NdsBWtda4SzT8agThvNyFDrfwtLYfyt3sz2R/dMeQPzFxLxcCbsDMtO6t2oRlOtNaF
         r04LeGe/v/8pgRjSHpMVxf4/h6C2r8DAGRUK5f+l1bj9zP/QFHhmXn29zQk7QssKUPZZ
         1KmYRCAFPL+aFFlEIX3D2CAaC0tP2OBd48m5xd9VhMy4RlWMsLUBJNq1cfNFEsuHSThJ
         NSwm2+53Pt/tVsTkvBtfUF1OOWzyfasDC+Er/uFhrVpjyTDxHgJqFvSimwUlpXPCsgOo
         OGQGP3kJbpnFKlFLnpWBcTETCRYxjL37MON6RcTOT/cPwqT1/PuwCbZJTZeCfMyK5nJw
         uTxg==
X-Forwarded-Encrypted: i=1; AJvYcCUJ5FfQTh4zHVtyFsThFYnIswmRe/Pn0Pn8UA4WBzVMbIx//5DnB3t9OH2H/Q2Lm7ExlU+1qeU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzA4AjGLfArBNWCCZaEZCmO/+Nx5rdjDnjTuVThP2EXuv2ilmmF
	BXIxgKSRAx/DtjZRWpEZJIM2nN7iTUwFdxEf2pIEIpBKG4UiBpWhxihu90K1tM4fMVLMAZtlA2U
	j10qH0A==
X-Google-Smtp-Source: AGHT+IEFD4waSVQTOAsVyudNcn7ejn8ek5PuLwOxwXNXNljOaLhuHKDLNM7nryfElBbu4DGNYAQqJVhQvzfM
X-Received: from educ20.prod.google.com ([2002:a05:6402:1014:b0:5d0:84dd:d775])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7f0c:b0:aa6:5e35:d72d
 with SMTP id a640c23a62f3a-aab7793eb42mr1425279566b.24.1734371885432; Mon, 16
 Dec 2024 09:58:05 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-1-qperret@google.com>
Subject: [PATCH v3 00/18] KVM: arm64: Non-protected guest stage-2 support for pKVM
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

This is the v3 of the series adding support for non-protected guests
stage-2 to pKVM. Please refer to v1 for all the context:

  https://lore.kernel.org/kvmarm/20241104133204.85208-1-qperret@google.com/

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
 - Rebased on 6.13-rc1 (small conflicts with 2362506f7cff ("KVM: arm64:
   Don't mark "struct page" accessed when making SPTE young") in
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
 arch/arm64/include/asm/kvm_pkvm.h             |  23 ++
 arch/arm64/kvm/arm.c                          |  23 +-
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  38 +--
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  42 ++-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  16 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 201 ++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 320 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  14 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  68 ++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   7 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  13 +-
 arch/arm64/kvm/mmu.c                          | 113 +++++--
 arch/arm64/kvm/pkvm.c                         | 198 +++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   6 +-
 19 files changed, 1010 insertions(+), 145 deletions(-)

-- 
2.47.1.613.gc27f4b7a9f-goog

