From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 0/6] flush/invalidate on entry/exit
Date: Fri,  6 Mar 2015 13:52:27 -0500
Message-ID: <1425667953-3566-1-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9BC647FCB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T38IAarf0ef8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:46:34 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C611A47FAC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:34 -0500 (EST)
In-Reply-To: <1425667780-3449-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Userspace flags memory regions as incoherent and kvm flushes/
invalidates those regions on entry/exit from userspace.

 Result before patch 6/6: restores coherency, waaaaay toooo sloooooow
 Result with patch 6/6: fast again - well, we removed the code...

Andrew Jones (6):
  kvm: promote KVM_MEMSLOT_INCOHERENT to uapi
  KVM: Introduce incoherent cache maintenance API
  KVM: ARM: change __coherent_cache_guest_page interface
  KVM: ARM: extend __coherent_cache_guest_page
  KVM: ARM: implement kvm_*_incoherent_memory_regions
  KVM: ARM: no need for kvm_arch_flush_incoherent

 arch/arm/include/asm/kvm_mmu.h    | 12 +++----
 arch/arm/include/uapi/asm/kvm.h   |  1 +
 arch/arm/kvm/arm.c                |  4 +++
 arch/arm/kvm/mmu.c                | 72 +++++++++++++++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_mmu.h  | 12 ++++---
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 include/linux/kvm_host.h          | 15 +++++++-
 include/uapi/linux/kvm.h          |  1 +
 virt/kvm/kvm_main.c               | 45 +++++++++++++++++++++++-
 9 files changed, 147 insertions(+), 16 deletions(-)

-- 
1.8.3.1
