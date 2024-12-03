Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEB21E25F4
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222260; cv=none; b=OPCZMvhdTsrXxGqD60LQiIPzUejuyxdoT7rHgryTGp3IbRrG7xdiiEoDg3fQklSU8D0QffRX9pARVkojMQIMiyzkMfG3w0Rx3XaUuXitiUEdW6jVY0HqUyW0pvkLHcHNFvrtDIhWYeRmy8M7W1P86mkafay1gTf/HWi5y5YXwYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222260; c=relaxed/simple;
	bh=q3+FxbCcBkiskXSn831XHlgU64Eqo1nUx21JojjeJx4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IFX2CHB0VY5cILyCj1IsTyoxqkpw53zku402NrZos/JmQXiDMVnTucf79idNz/qWSfIaFcYKYbQ7A/Nagu8VeO3MBUxH4eLYl1v5z0ks23Yjjewu+OzmErWNUH47y8oklexdqgCmuQdxV8vwT/Upc7Lf6SIbPlcz80VV2wTC6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sYcWYEpf; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sYcWYEpf"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d0d341cc43so1690688a12.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222257; x=1733827057; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bhVcEYzfRw8eAXsIDOKtTfeOpA28Wa0JxjqlOgFYMJ0=;
        b=sYcWYEpfFzphUhoetvQeW/j2KJ2CkD0TixasyXXS51i9NzdGPIvXy2PWWhXuXqLiPb
         dpBxnDB+KW2kVXyJOFPGwKGzxysGffAZAVUzxZM+gMz+yTAfBL7XiIviTAUeOdtbzcIR
         yaLFc7qMhL7k3Y36fFOeSwptGA5tOe6Qoqsznp5RqQJEuePon/vUVuyYW6TszXGwZdCz
         PjsdtFpBj0hkOcSB4jQAfd6JkbPMgcEgbjfhcauARR481MSzmKNAqHe3jxpibsi48C8y
         MtYnXCYEG99s1HySOkNCaZfIBs73o467JtmI/KTwGqhElPGw/aTOCQWPEY1xdZQ4Wb6V
         Bf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222257; x=1733827057;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bhVcEYzfRw8eAXsIDOKtTfeOpA28Wa0JxjqlOgFYMJ0=;
        b=udQljCuScaz/918BU+uLNUzd+t/HRNBaOSbfr7fCi+A1XhdNtqvhBG/wafsRK1jg7f
         N3bwOF1JqExkzqtQW3Co9RekHTpFdm4cQ9UszR+UJ+ZDLUj4bbqMNJLirY9pCr0cxt3M
         pxd1tW+OL7kaG65zfX8Ng32Pw1CtL8Kcxb2eV5CuDl7VQhoN08awODSyw2He0NuH/1sa
         deeLcOs8Lo57e3rhwkmS308ZsGqhIbvXvFaTdImnR892qAq5WJYbKHYBq3uEqE8vYg5H
         5+kDTGQHlS/w585sAV6SLUsZT4fAXcXXn0gPzGTarYtRv2ADbRvsJqdxO4kD0PSTGuC4
         8a7A==
X-Forwarded-Encrypted: i=1; AJvYcCUS/MTZ0gU45jhqqbVIZAbERC2g7zYx1c9bQj8IGmDcUP1J5iPpOEQzR6JbM88iRgRkTdzCsuc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/j4nc1GTHai2ef9dl1jqXSSsFpdKvCmOCMgc20Uqa19FdbNFv
	fzd9H0PEtU1dsOnRJFmKPL1pXxT24B7WHSksouydyQWpUpPjYUrn1r998VpO794ECWjO8o+k58q
	xzkveeg==
X-Google-Smtp-Source: AGHT+IHYV6enzbdprLHZMQD92QaUuZlgGwTGzCSSf0HmxvgO/jp3WQcTuWxTF7EcB+yhrb6mkrn1yXRToanq
X-Received: from edvi16.prod.google.com ([2002:aa7:dd10:0:b0:5d0:27b6:2cde])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:510e:b0:5d0:8606:9ba1
 with SMTP id 4fb4d7f45d1cf-5d10cb82718mr1488954a12.24.1733222257469; Tue, 03
 Dec 2024 02:37:37 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-1-qperret@google.com>
Subject: [PATCH v2 00/18] KVM: arm64: Non-protected guest stage-2 support for pKVM
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

This is the v2 of the series adding support for non-protected guests to
pKVM. Please refer to v1 for all the context:

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

Patches based on 6.13-rc1, tested on Pixel 6 and Qemu.

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
 arch/arm64/include/asm/kvm_pgtable.h          |  42 ++-
 arch/arm64/include/asm/kvm_pkvm.h             |  28 ++
 arch/arm64/kvm/arm.c                          |  23 +-
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  38 +--
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  43 ++-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  15 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 210 +++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 312 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  14 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  56 ++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   7 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  13 +-
 arch/arm64/kvm/mmu.c                          | 109 ++++--
 arch/arm64/kvm/pkvm.c                         | 195 +++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   6 +-
 18 files changed, 987 insertions(+), 143 deletions(-)

-- 
2.47.0.338.g60cca15819-goog

