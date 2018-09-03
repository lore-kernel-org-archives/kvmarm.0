From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PULL 0/4] KVM/ARM Fixes for v4.19
Date: Mon,  3 Sep 2018 15:45:12 +0200
Message-ID: <20180903134516.17796-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 959504A1DC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:45:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YvoUFK-S12Jc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 09:45:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4CB94A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:45:21 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Radim and Paolo,

Here is the first small round of fixes for KVM/ARM for v4.19.  The
changes include:

 - Fix a VFP corruption in 32-bit guest
 - Add missing cache invalidation for CoW pages
 - Two small cleanups

Note that I have a question out on the CoW cache issue relating to
zero-page backed PMD mappings, but if there is any additional fixes to
be done, that doesn't invalidate the current patch and we can follow up
later.

The following changes since commit 5b394b2ddf0347bef56e50c69a58773c94343ff3:

  Linux 4.19-rc1 (2018-08-26 14:11:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-fixes-for-v4.19

for you to fetch changes up to f901c848464922bdf85a3b993539d56eedd20809:

  arm64: KVM: Remove pgd_lock (2018-08-30 10:08:01 +0200)

---

Marc Zyngier (3):
  KVM: arm/arm64: Clean dcache to PoC when changing PTE due to CoW
  arm64: KVM: Only force FPEXC32_EL2.EN if trapping FPSIMD
  KVM: Remove obsolete kvm_unmap_hva notifier backend

Steven Price (1):
  arm64: KVM: Remove pgd_lock

 arch/arm/include/asm/kvm_host.h   |  1 -
 arch/arm64/include/asm/kvm_host.h |  4 +---
 arch/arm64/kvm/hyp/switch.c       |  9 ++++++---
 arch/mips/include/asm/kvm_host.h  |  1 -
 arch/mips/kvm/mmu.c               | 10 ----------
 arch/x86/include/asm/kvm_host.h   |  1 -
 arch/x86/kvm/mmu.c                |  5 -----
 virt/kvm/arm/mmu.c                | 21 ++++++++-------------
 virt/kvm/arm/trace.h              | 15 ---------------
 9 files changed, 15 insertions(+), 52 deletions(-)

-- 
2.18.0
