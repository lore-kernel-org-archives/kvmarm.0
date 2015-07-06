From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 0/2] KVM: arm/arm64: Guest synchronous halt/resume
Date: Mon,  6 Jul 2015 14:49:54 +0200
Message-ID: <1436186996-22528-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0491057B7A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 08:38:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IpU+TnUjvp2r for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 08:38:54 -0400 (EDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06BE457A4B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 08:38:53 -0400 (EDT)
Received: by wguu7 with SMTP id u7so139563844wgu.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 05:50:20 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: pbonzini@redhat.com, alex.williamson@redhat.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series introduces the capability to synchronously exit the guest
and prevent it from being re-entered.

This functionality is requested for IRQ forwarding where we need to make
sure the guest has exited and is prevented from being rescheduled until
we complete the forwarding state change.

This series does not introduce any user of the functionality. First user
will be IRQ forwarding. The split is done to ease the review process.

can be found at:
https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc1-bypass-fwd-v2

Best Regards

Eric

History:

PATCH:
- just added __maybe_unused following Marc's advice

RFC life before:
- originally part of [RFC 00/17] ARM IRQ forward control based on IRQ
  bypass manager (https://lkml.org/lkml/2015/7/2/268) and isolated in
  this series.

Eric Auger (2):
  KVM: arm: rename pause into power_off
  kvm: arm/arm64: implement kvm_arm_[halt,resume]_guest

 arch/arm/include/asm/kvm_host.h   |  5 ++++-
 arch/arm/kvm/arm.c                | 41 +++++++++++++++++++++++++++++++++------
 arch/arm/kvm/psci.c               | 10 +++++-----
 arch/arm64/include/asm/kvm_host.h |  3 +++
 4 files changed, 47 insertions(+), 12 deletions(-)

-- 
1.9.1
