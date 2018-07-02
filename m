From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH RESEND v6 0/2] support exception state migration and set
 VSESR_EL2 by user space
Date: Mon, 2 Jul 2018 21:43:04 +0800
Message-ID: <1530538986-4024-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE2449FAC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Jul 2018 09:30:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oVO0Whmb5x7U for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Jul 2018 09:30:59 -0400 (EDT)
Received: from huawei.com (unknown [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0466E4070F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Jul 2018 09:30:59 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: rkrcmar@redhat.com, corbet@lwn.net, james.morse@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: linuxarm@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

This series patch is separated from https://www.spinics.net/lists/kvm/msg168917.html

1. Detect whether KVM can set set guest SError syndrome
2. Support to Set VSESR_EL2 and inject SError by user space.
3. Support live migration to keep SError pending state and VSESR_EL2 value

The user space patch is here: https://www.mail-archive.com/qemu-devel@nongnu.org/msg539534.html
BTW: The user space patch is needed to rebase


Dongjiu Geng (2):
  arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
  arm64: KVM: export the capability to set guest SError syndrome

 Documentation/virtual/kvm/api.txt    | 44 ++++++++++++++++++++++++++++++----
 arch/arm64/include/asm/kvm_emulate.h |  5 ++++
 arch/arm64/include/asm/kvm_host.h    |  7 ++++++
 arch/arm64/include/uapi/asm/kvm.h    | 13 ++++++++++
 arch/arm64/kvm/guest.c               | 46 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/inject_fault.c        |  6 ++---
 arch/arm64/kvm/reset.c               |  4 ++++
 include/uapi/linux/kvm.h             |  1 +
 virt/kvm/arm/arm.c                   | 21 ++++++++++++++++
 9 files changed, 140 insertions(+), 7 deletions(-)

-- 
2.7.4
