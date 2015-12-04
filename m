From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/ARM fixes for 4.4-rc4
Date: Fri,  4 Dec 2015 17:17:15 +0000
Message-ID: <1449249440-28878-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 967B649914
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 12:15:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UFxNvCcKk6Qm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2015 12:15:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2F2413E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2015 12:15:54 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

This pull request contains a number of fixes for 4.4-rc4 (or -rc5 if
we already missed the boat).

The first part is a very nice catch from Pavel, who noticed that we
were not dealing very well (if at all) with the aliasing between two
registers.

The last patch from Ard is a fix for a fix that was merged in
-rc3. Hopefully we got it right this time.

Please pull!

       M.

The following changes since commit fbb4574ce9a37e15a9872860bf202f2be5bdf6c4:

  arm64: kvm: report original PAR_EL1 upon panic (2015-11-24 18:20:58 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.4-rc4

for you to fetch changes up to 0de58f852875a0f0dcfb120bb8433e4e73c7803b:

  ARM/arm64: KVM: correct PTE uncachedness check (2015-12-04 16:30:17 +0000)

----------------------------------------------------------------
KVM/ARM fixes for v4.4-rc4

- A series of fixes to deal with the aliasing between the sp and xzr register
- A fix for the cache flush fix that went in -rc3

----------------------------------------------------------------
Ard Biesheuvel (1):
      ARM/arm64: KVM: correct PTE uncachedness check

Pavel Fedin (4):
      arm64: KVM: Correctly handle zero register during MMIO
      arm64: KVM: Remove const from struct sys_reg_params
      arm64: KVM: Correctly handle zero register in system register accesses
      arm64: KVM: Get rid of old vcpu_reg()

 arch/arm/include/asm/kvm_emulate.h   |  12 ++++
 arch/arm/kvm/mmio.c                  |   5 +-
 arch/arm/kvm/mmu.c                   |   4 +-
 arch/arm/kvm/psci.c                  |  20 +++---
 arch/arm64/include/asm/kvm_emulate.h |  18 +++--
 arch/arm64/kvm/handle_exit.c         |   2 +-
 arch/arm64/kvm/sys_regs.c            | 123 +++++++++++++++++------------------
 arch/arm64/kvm/sys_regs.h            |   8 +--
 arch/arm64/kvm/sys_regs_generic_v8.c |   4 +-
 9 files changed, 107 insertions(+), 89 deletions(-)
