From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/2] KVM: arm/arm64: Fix two problems with the arch timer
 introduced in v4.15-rc1
Date: Fri, 15 Dec 2017 15:16:54 +0100
Message-ID: <20171215141656.25815-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF3649D54
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 09:13:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UrGLUPV8P9Dv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 09:13:33 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 137C949D36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 09:13:33 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id r78so17835787wme.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 06:17:10 -0800 (PST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Jia He <hejianet@gmail.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The first patch solves the problem with the spurious IRQ (which is not a
problem at all and just an artifact of what Jia is writing about), and
it solves the issue of accidentally overwriting the in-memory copy of
the guest state with a disabled timer, leaving the VCPU in the weeds.

The second patch addresses addresses an issue identified when booting
with kvmtool  The reason why we didn't see it with QEMU is that QEMU is
so happy to signal its threads in the initial setup phase, that it hides
the bug.

Jia, I'd appreciate your tested-by after having applied both patches on
your platform.

Thanks,
-Christoffer

Christoffer Dall (2):
  KVM: arm/arm64: Properly handle arch-timer IRQs after
    vtimer_save_state
  KVM: arm/arm64: Fix timer enable flow

 virt/kvm/arm/arch_timer.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

-- 
2.14.2
