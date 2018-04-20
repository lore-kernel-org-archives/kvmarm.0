From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 0/8] KVM: arm64: Optimise FPSIMD context switching
Date: Fri, 20 Apr 2018 17:46:34 +0100
Message-ID: <1524242802-21163-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E764A087
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Apr 2018 12:37:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jswmcfD7TNCO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Apr 2018 12:37:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85FF049FC6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Apr 2018 12:37:36 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This is another respin of my attempt to improve FPSIMD context handling
for KVM, building on the previous RFC v3 [1].

It's not completely done yet, but it's sufficiently closer to
completeness that a it's worth people taking another look at.

The main changes since RFC v3 are:

 * Rebased to v4.17-rc1.  Please pay close attention to patch 3 which is
   where most of the pain was felt.  Note that fpsimd_enabled() is now
   gone, since vcpu->arch.fp_enabled provides the same information.  The
   diff is a little confusing to read there.

 * patches 4-6: Make sve_pffr more easliy inlinable into Hyp, along with
   some annoying header refactoring to resolve a #include cycle that is
   otherwise hard to avoid here.

 * patch 7: Add support for saving the host SVE state from hyp.

 * patch 8: Remove SVE host-side SVE flushing logic that is rendered
   unnecessary by patch 7.

Other minor changes as noted.


Some testing done on Juno and the Arm fast model (arm64), including
combinations of (non-)SVE and (non-)VHE configurations.


Blurb:

See the individual patches for detailed explanation.

Some things (still) aren't right yet:

 * The BUG_ON(system_supports_sve()) added in kvm_arch_vcpu_load_fp() by
   patch 3 and subsequently removed by patch 7 is a bisectability break
   (albeit only for people running on SVE-enabled models).  I intend to
   fix this before upstreaming, possibly via a check at VM creation time
   similar to the check added in patch 7.

 * Moving __hyp_switch_fpsimd() to the shallow exit path as requested by
   Marc Zyngier has *not* been done yet.  I will look at that next so
   that people can benchmark with and without that change.

 * task_fpsimd_save() still appears misnamed, but in lieu of having
   decided on a better name I've just exported this function from
   fpsimd.c for now.


Any comments, testing, benchmarks appreciated!

Cheers
---Dave


[1] [RFC PATCH v3 0/4] KVM: arm64: Optimise FPSIMD context switching
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-April/570740.html


Christoffer Dall (1):
  KVM: arm/arm64: Introduce kvm_arch_vcpu_run_pid_change

Dave Martin (7):
  KVM: arm64: Convert lazy FPSIMD context switch trap to C
  KVM: arm64: Optimise FPSIMD handling to reduce guest/host thrashing
  arm64/sve: Move read_zcr_features() out of cpufeature.h
  arm64/sve: Switch sve_pffr() argument from task to thread
  arm64/sve: Move sve_pffr() to fpsimd.h and make inline
  KVM: arm64: Save host SVE context as appropriate
  KVM: arm64: Remove eager host SVE state saving

 arch/arm/include/asm/kvm_host.h     |   9 ++-
 arch/arm64/Kconfig                  |   7 +++
 arch/arm64/include/asm/cpufeature.h |  29 ----------
 arch/arm64/include/asm/fpsimd.h     |  20 +++++++
 arch/arm64/include/asm/kvm_host.h   |  22 +++++---
 arch/arm64/include/asm/processor.h  |   2 +
 arch/arm64/kernel/fpsimd.c          |  87 ++++++++++++++++-------------
 arch/arm64/kernel/ptrace.c          |   1 +
 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/fpsimd.c             | 108 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/entry.S          |  57 ++++++++-----------
 arch/arm64/kvm/hyp/switch.c         |  83 +++++++++++++++++++--------
 include/linux/kvm_host.h            |   9 +++
 virt/kvm/Kconfig                    |   3 +
 virt/kvm/arm/arm.c                  |  25 ++++++++-
 virt/kvm/kvm_main.c                 |   7 ++-
 17 files changed, 332 insertions(+), 140 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd.c

-- 
2.1.4
