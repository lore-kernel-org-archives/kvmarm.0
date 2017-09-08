From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/2] Fix preemption issues with kvm_arm_get_running_vcpu
Date: Fri,  8 Sep 2017 07:52:17 -0700
Message-ID: <1504882339-42520-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67ABC49C6A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 10:50:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EGCMoxnjP+UZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Sep 2017 10:50:27 -0400 (EDT)
Received: from mail-pf0-f180.google.com (mail-pf0-f180.google.com
 [209.85.192.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30B5249C5E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 10:50:26 -0400 (EDT)
Received: by mail-pf0-f180.google.com with SMTP id e199so4879706pfh.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Sep 2017 07:52:56 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, hemk976@gmail.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

These two patches slightly improves our preemption configuration when
accessing the per-CPU variables holding the currently running VCPU by
removing a redundant check and rearranging calling code from
non-preemptible context on RT systems.

I'm not entirely sure if we fix issues only affecting PREEMPT_RT in mainline
and also cc these to stable.  Looking at the git log there seems to be some
precedence for this.  If not, I'm happy to remove the cc tag and/or drop the
second patch.

Thanks,
-Christoffer

Christoffer Dall (2):
  KVM: arm/arm64: Remove redundant preemptible checks
  KVM: arm/arm64: Fix vgic_mmio_change_active with PREEMPT_RT

 virt/kvm/arm/arm.c            |  2 --
 virt/kvm/arm/vgic/vgic-mmio.c | 12 +++++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

-- 
2.7.4
