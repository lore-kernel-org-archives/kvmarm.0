From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/4] KVM/ARM Fixes for v4.6-rc4
Date: Fri,  8 Apr 2016 11:52:11 +0200
Message-ID: <1460109135-6612-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8121540F77
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 05:50:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xhRbFfMSApo1 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 05:50:44 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B7644053F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 05:50:44 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id 191so12747074wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 02:52:10 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here's another set of fixes for KVM/ARM for this release.  I guess this was
expected given the size of our patch queue for this merge window.

The following changes since commit 5f5560b1c5f3a80e91c6babb2da34a51943bbdec:

  arm64: KVM: Register CPU notifiers when the kernel runs at HYP (2016-03-31 10:27:28 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.6-rc4

for you to fetch changes up to 06a71a24bae57a07afee9cda6b00495347d8a448:

  arm64: KVM: unregister notifiers in hyp mode teardown path (2016-04-06 13:47:52 +0200)


Thanks,
-Christoffer

----------------------------------------------------------------
KVM/ARM Fixes for v4.6-rc4

Addresses:
 - Wrong indentation in the PMU code from the merge window
 - A long-time bug occuring with running ntpd on the host, candidate for stable
 - Properly handle (and warn about) the unsupported configuration of running on
   systems with less than 40 bits of PA space
 - More fixes to the PM and hotplug notifier stuff from the merge window

----------------------------------------------------------------
Marc Zyngier (2):
      KVM: arm/arm64: Handle forward time correction gracefully
      arm64: KVM: Warn when PARange is less than 40 bits

Sudeep Holla (1):
      arm64: KVM: unregister notifiers in hyp mode teardown path

Will Deacon (1):
      arm64: KVM: Add braces to multi-line if statement in virtual PMU code

 arch/arm/kvm/arm.c                | 13 ++++++++---
 arch/arm64/include/asm/kvm_arm.h  |  6 ++---
 arch/arm64/include/asm/kvm_asm.h  |  2 +-
 arch/arm64/include/asm/kvm_host.h |  7 +++---
 arch/arm64/kvm/hyp/s2-setup.c     | 39 +++++++++++++++++++++++++++++--
 virt/kvm/arm/arch_timer.c         | 49 +++++++++++++++++++++++++++++++--------
 virt/kvm/arm/pmu.c                |  3 ++-
 7 files changed, 95 insertions(+), 24 deletions(-)
