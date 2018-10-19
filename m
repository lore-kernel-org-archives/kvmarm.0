From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 20/26] KVM: arm64: Drop __cpu_init_stage2 on the VHE path
Date: Fri, 19 Oct 2018 13:58:55 +0100
Message-ID: <20181019125901.185478-21-marc.zyngier@arm.com>
References: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 699244A2E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Sh-dXVdfYlS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 09:00:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A96B4A2F3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:17 -0400 (EDT)
In-Reply-To: <20181019125901.185478-1-marc.zyngier@arm.com>
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
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

__cpu_init_stage2 doesn't do anything anymore on arm64, and is
totally non-sensical if running VHE (as VHE is 64bit only).

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arm.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 91c464c9cd21..4ce99bb223bc 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1310,16 +1310,10 @@ static void cpu_hyp_reinit(void)
 {
 	cpu_hyp_reset();
 
-	if (is_kernel_in_hyp_mode()) {
-		/*
-		 * __cpu_init_stage2() is safe to call even if the PM
-		 * event was cancelled before the CPU was reset.
-		 */
-		__cpu_init_stage2();
+	if (is_kernel_in_hyp_mode())
 		kvm_timer_init_vhe();
-	} else {
+	else
 		cpu_init_hyp_mode(NULL);
-	}
 
 	if (vgic_present)
 		kvm_vgic_init_cpu_hardware();
-- 
2.19.1
