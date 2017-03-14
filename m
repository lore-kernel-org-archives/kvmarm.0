From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/3]  kvm: arm/arm64: Fixes for use after free problems
Date: Tue, 14 Mar 2017 14:52:31 +0000
Message-ID: <1489503154-20705-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C008A40296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 10:51:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9hDRgn8ldDLS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Mar 2017 10:51:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D297F40284
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Mar 2017 10:51:55 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, andreyknvl@google.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This series contains potential fixes for problems reported by [0] & [1].

[0] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-March/492944.html
[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-March/492943.html


Marc Zyngier (2):
  kvm: arm/arm64: Take mmap_sem in stage2_unmap_vm
  kvm: arm/arm64: Take mmap_sem in kvm_arch_prepare_memory_region

Suzuki K Poulose (1):
  kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd

 arch/arm/kvm/mmu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

-- 
2.7.4
