From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/2] arm/arm64: KVM: Fix arthictected timer issues
Date: Fri,  4 Sep 2015 16:24:37 +0200
Message-ID: <1441376679-8341-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0464412EF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 10:22:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JEAgiKJm3h2b for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2015 10:22:47 -0400 (EDT)
Received: from mail-la0-f43.google.com (mail-la0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DB1C412D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 10:22:47 -0400 (EDT)
Received: by laeb10 with SMTP id b10so14785913lae.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Sep 2015 07:23:12 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

These two patches fix two separate issues with the architected timer and
the corresponding interrupt injection to VMs on KVM/ARM.

The first patch fixes an issue introduced with the active timer state
switching series recently merged for v4.3, which could cause a guest to
loop without progress if another VCPU is run on the same physical CPU
and preempts the original VCPU while the guest is running the ISR for
the timer interrupt.

The second patch resets the architected timer's control register to zero
on system reset, ensuring that interrupts are not injected when a system
resets.  This fixes a long-standing issue with UEFI, where soft reset
initiated from within UEFI prevented the system from booting again.

Christoffer Dall (2):
  arm/arm64: KVM: vgic: Move active state handling to flush_hwstate
  arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0

 virt/kvm/arm/arch_timer.c |  8 ++++++++
 virt/kvm/arm/vgic.c       | 42 ++++++++++++++++++++++++++----------------
 2 files changed, 34 insertions(+), 16 deletions(-)

-- 
2.1.2.330.g565301e.dirty
