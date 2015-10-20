From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 0/6] A handful of fixes for KVM/ARM for v4.3-rc7
Date: Tue, 20 Oct 2015 18:19:01 +0200
Message-ID: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 660B841CC5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 12:16:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GhCHGbrJZ32a for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Oct 2015 12:16:05 -0400 (EDT)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73D1540FA7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 12:16:05 -0400 (EDT)
Received: by lffv3 with SMTP id v3so8439909lff.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 09:18:37 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

The following changes since commit 920552b213e3dc832a874b4e7ba29ecddbab31bc:

  KVM: disable halt_poll_ns as default for s390x (2015-09-25 10:31:30 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.3-rc7

for you to fetch changes up to 0d997491f814c87310a6ad7be30a9049c7150489:

  arm/arm64: KVM: Fix disabled distributor operation (2015-10-20 18:09:13 +0200)

Sorry for sending these relatively late, but we had a situation where we
found one breakage in the timer implementation changes merged for 4.3,
then fixing that issue revealed another bug, and then that happened
again, and now we have something that looks stable.

Description of the fixes is in the tag and quoted below.

Thanks,
-Christoffer

----------------------------------------------------------------
A late round of KVM/ARM fixes for v4.3-rc7, fixing:
 - A bug where level-triggered interrupts lowered from userspace
   are still routed to the guest
 - A memory leak an a failed initialization path
 - A build error under certain configurations
 - Several timer bugs introduced with moving the timer to the active
   state handling instead of the masking trick.

----------------------------------------------------------------
Arnd Bergmann (1):
      KVM: arm: use GIC support unconditionally

Christoffer Dall (3):
      arm/arm64: KVM: Fix arch timer behavior for disabled interrupts
      arm/arm64: KVM: Clear map->active on pend/active clear
      arm/arm64: KVM: Fix disabled distributor operation

Pavel Fedin (2):
      KVM: arm/arm64: Do not inject spurious interrupts
      KVM: arm/arm64: Fix memory leak if timer initialization fails

 arch/arm/kvm/Kconfig      |  1 +
 arch/arm/kvm/arm.c        |  2 +-
 virt/kvm/arm/arch_timer.c | 19 ++++++++++
 virt/kvm/arm/vgic.c       | 95 +++++++++++++++++++++++++++--------------------
 4 files changed, 76 insertions(+), 41 deletions(-)
