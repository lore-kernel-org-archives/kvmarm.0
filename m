From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Wed, 18 Mar 2015 15:10:30 -0400
Message-ID: <1426705833-2679-1-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4253C4918F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:04:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yCPDwEw9Jc3f for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:03:56 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC2B24918D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:03:56 -0400 (EDT)
In-Reply-To: <1426705700-2564-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a new memory region flag, KVM_MEM_UNCACHED, which
is needed by ARM. This flag informs KVM that the given memory
region is typically mapped by the guest as uncached. KVM for
ARM then maps that region as uncached for userspace as well,
in order to keep coherency.

Andrew Jones (3):
  KVM: promote KVM_MEMSLOT_INCOHERENT to uapi
  arm/arm64: KVM: decouple READONLY and UNCACHED
  arm/arm64: KVM: implement KVM_MEM_UNCACHED

 Documentation/virtual/kvm/api.txt | 16 ++++---
 arch/arm/include/asm/kvm_mmu.h    |  9 ++++
 arch/arm/include/uapi/asm/kvm.h   |  2 +
 arch/arm/kvm/arm.c                |  1 +
 arch/arm/kvm/mmu.c                | 90 ++++++++++++++++++++++++++++++++++-----
 arch/arm64/include/asm/kvm_mmu.h  |  9 ++++
 arch/arm64/include/uapi/asm/kvm.h |  2 +
 include/linux/kvm_host.h          |  1 -
 include/uapi/linux/kvm.h          |  2 +
 virt/kvm/kvm_main.c               |  7 ++-
 10 files changed, 121 insertions(+), 18 deletions(-)

-- 
1.8.3.1
