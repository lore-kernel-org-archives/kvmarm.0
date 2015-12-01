From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 0/3] Add support for handling IRQs in userspace
Date: Tue, 01 Dec 2015 13:19:42 +0300
Message-ID: <cover.1448965024.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F604998D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 05:18:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q-yNsIc066W8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 05:18:29 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AEA9498C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 05:18:29 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYO00ARGCP2IU50@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 01 Dec 2015 10:19:50 +0000 (GMT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch series introduces ability to handle IRQs in userspace. This is
currently necessary for ARM KVM in order to be able to use virtual CP15
timer without in-kernel irqchip. This allows to use KVM on machines with
either broken vGIC or custom interrupt controller, like Raspberry Pi 2.

The API is designed to be as much architecture-agnostic is possible.
Currently it actually supports only a single IRQ, but it can be easily
extended to accomodate more.

Pavel Fedin (3):
  KVM: Introduce KVM_EXIT_IRQ
  KVM: Documentation: Document KVM_EXIT_IRQ
  KVM: arm/arm64: Decouple virtual timer from vGIC

 Documentation/virtual/kvm/api.txt | 14 ++++++++++++++
 arch/arm/kvm/arm.c                | 14 +++++++-------
 include/linux/kvm_host.h          |  7 +++++++
 include/uapi/linux/kvm.h          |  3 +++
 virt/kvm/arm/arch_timer.c         | 23 +++++++++++++----------
 5 files changed, 44 insertions(+), 17 deletions(-)

-- 
2.4.4
