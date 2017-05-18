From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 10/13] kvm: arm/arm64: Force reading uncached stage2 PGD
Date: Thu, 18 May 2017 11:47:19 +0200
Message-ID: <20170518094722.9926-11-cdall@linaro.org>
References: <20170518094722.9926-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA1E40C74
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RfQYeY8JqBXf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 May 2017 05:44:17 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DEAA40B8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 05:44:16 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id 70so40081037wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 May 2017 02:47:48 -0700 (PDT)
In-Reply-To: <20170518094722.9926-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Make sure we don't use a cached value of the KVM stage2 PGD while
resetting the PGD.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 909a1a7..704e35f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -837,7 +837,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
 		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
-		pgd = kvm->arch.pgd;
+		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 	}
 	spin_unlock(&kvm->mmu_lock);
-- 
2.9.0
