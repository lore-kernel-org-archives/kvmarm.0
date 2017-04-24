From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/2] kvm: Fixes for race conditions
Date: Mon, 24 Apr 2017 11:10:22 +0100
Message-ID: <1493028624-29837-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7647B4104A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 06:09:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XKAkN5w7Eq1h for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Apr 2017 06:09:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F0340DFB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 06:09:25 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andreyknvl@google.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu


The two patches here fixes race conditions in the KVM hypervisor code
dealing with the shadow MMU.

The first one applies to core KVM code where mmu_notifier->ops.release()
could be called twice with one instance possibily accessing a free'd KVM
instance. Reported here :

 http://lkml.kernel.org/r/CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com

The second patch is specific to arm/arm64 stage2 PGD, where there are issues
with modifications to the PGD pointer outside the mmu_lock, leading to crashes.
Reported here :
 http://lkml.kernel.org/r/febea966-3767-21ff-3c40-1a76d1399138@suse.de


Suzuki K Poulose (2):
  kvm: Fix mmu_notifier release race
  kvm: arm/arm64: Fix race in resetting stage2 PGD

 arch/arm/kvm/mmu.c       | 14 +++++++-----
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 59 ++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 61 insertions(+), 13 deletions(-)

-- 
2.7.4
