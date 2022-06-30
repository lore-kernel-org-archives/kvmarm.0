Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0859C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:58:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 191B84B499;
	Thu, 30 Jun 2022 09:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eyzbJyaOKLuW; Thu, 30 Jun 2022 09:58:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDAA64B498;
	Thu, 30 Jun 2022 09:58:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E2D24B498
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sAbKLJcmk8h7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:58:00 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAB214B32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:00 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 13F48620E4;
 Thu, 30 Jun 2022 13:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CD8C34115;
 Thu, 30 Jun 2022 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597477;
 bh=EmIexi1QObKgcY5NSLTUwRxnbbq8QcNM35kJH7r6kog=;
 h=From:To:Cc:Subject:Date:From;
 b=gwD/VFOti3HVCG3sv26GAdib8zxowDim9r5Hsgi8VjGDkqQjM223ZVFiUvIdAm+U8
 emwIv/DXD4n50fKJpc5H7vc9vkDHLIq4gvXoaqLuzt5Bjn563zMkXltiR1z6GuGJNP
 O/InJj9812Or+GtAWsCDoYW5zVna91Mok7MVBSGErs1K5laZvGwm43SsbhGiS/lByy
 RUdbuAmeujfMGm5W1R1fW7GGCyU7in3irEafqxhl7+vRZuX7PlmV9pm9+4qZBBMKkE
 mTxw7IMEyjGKNAwmzNBfFIK27scazKdFkF5V2OhZZYCHNtOLpL6iZqlHDx7+C1IsBg
 Kqxty3W6ToRUA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 00/24] KVM: arm64: Introduce pKVM shadow state at EL2
Date: Thu, 30 Jun 2022 14:57:23 +0100
Message-Id: <20220630135747.26983-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi everyone,

This series has been extracted from the pKVM base support series (aka
"pKVM mega-patch") previously posted here:

  https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/

Unlike that more comprehensive series, this one is fairly fundamental
and does not introduce any new ABI commitments, leaving questions
involving the management of guest private memory and the creation of
protected VMs for future work. Instead, this series extends the pKVM EL2
code so that it can dynamically instantiate and manage VM shadow
structures without the host being able to access them directly. These
shadow structures consist of a shadow VM, a set of shadow vCPUs and the
stage-2 page-table and the pages used to hold them are returned to the
host when the VM is destroyed.

The last patch is marked as RFC because, although it plumbs in the
shadow state, it is woefully inefficient and copies to/from the host
state on every vCPU run. Without the last patch, the new structures are
unused but we move considerably closer to isolating guests from the
host.

The series is based on Marc's rework of the flags
(kvm-arm64/burn-the-flags).

Feedback welcome.

Cheers,

Will, Quentin, Fuad and Marc

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>

Cc: kernel-team@android.com
Cc: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org

--->8

Fuad Tabba (3):
  KVM: arm64: Add hyp_spinlock_t static initializer
  KVM: arm64: Introduce shadow VM state at EL2
  KVM: arm64: Instantiate VM shadow data from EL1

Quentin Perret (15):
  KVM: arm64: Move hyp refcount manipulation helpers
  KVM: arm64: Allow non-coalescable pages in a hyp_pool
  KVM: arm64: Add flags to struct hyp_page
  KVM: arm64: Back hyp_vmemmap for all of memory
  KVM: arm64: Make hyp stage-1 refcnt correct on the whole range
  KVM: arm64: Implement do_donate() helper for donating memory
  KVM: arm64: Prevent the donation of no-map pages
  KVM: arm64: Add helpers to pin memory shared with hyp
  KVM: arm64: Add pcpu fixmap infrastructure at EL2
  KVM: arm64: Add generic hyp_memcache helpers
  KVM: arm64: Instantiate guest stage-2 page-tables at EL2
  KVM: arm64: Return guest memory from EL2 via dedicated teardown
    memcache
  KVM: arm64: Unmap kvm_arm_hyp_percpu_base from the host
  KVM: arm64: Explicitly map kvm_vgic_global_state at EL2
  KVM: arm64: Don't map host sections in pkvm

Will Deacon (6):
  KVM: arm64: Unify identifiers used to distinguish host and hypervisor
  KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
  KVM: arm64: Initialise hyp symbols regardless of pKVM
  KVM: arm64: Provide I-cache invalidation by VA at EL2
  KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
  KVM: arm64: Use the shadow vCPU structure in handle___kvm_vcpu_run()

 arch/arm64/include/asm/kvm_asm.h              |   6 +-
 arch/arm64/include/asm/kvm_host.h             |  65 +++
 arch/arm64/include/asm/kvm_hyp.h              |   3 +
 arch/arm64/include/asm/kvm_pgtable.h          |   8 +
 arch/arm64/include/asm/kvm_pkvm.h             |  38 ++
 arch/arm64/kernel/image-vars.h                |  15 -
 arch/arm64/kvm/arm.c                          |  40 +-
 arch/arm64/kvm/hyp/hyp-constants.c            |   3 +
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  19 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  26 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  70 +++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  10 +-
 arch/arm64/kvm/hyp/nvhe/cache.S               |  11 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 105 +++-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 456 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 136 +++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  42 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 438 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  96 ++--
 arch/arm64/kvm/hyp/pgtable.c                  |   9 +
 arch/arm64/kvm/mmu.c                          |  26 +
 arch/arm64/kvm/pkvm.c                         | 121 ++++-
 25 files changed, 1625 insertions(+), 144 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
