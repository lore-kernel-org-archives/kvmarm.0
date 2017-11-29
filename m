From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH] KVM: arm64: handle the translation table walk RAS error
Date: Thu, 30 Nov 2017 04:48:44 +0800
Message-ID: <1511988524-30240-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E518749D91
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 07:40:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RQkxV+R9jpfC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Nov 2017 07:40:26 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B65349D20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 07:40:25 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, james.morse@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, gengdongjiu@huawei.com, huangshaoyu@huawei.com, wuquanming@huawei.com, linuxarm@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

For the RAS Synchronous External Abort, there are two types.
One is memory access, it will be handled by host APEI driver.
Another is translation table walk, in essence, it is hardware
memory error on stage1 or stage2 page table.

For the guest stage1 translation table error, if host APEI
driver handles it, APEI driver will unmap this page for the
stage1 page table, then switch to guest, guest reused this
page table and generate stage2 data abort, KVM deliver SIGBUS
to user space. User space inject this error to guest, when
guest handle this abort, it may also use this stage1 page
table, but it already unmap by host APEI driver, then
generate stage2 data abort again, so this will lead to dead
loop.

For the guest stage2 translation table error, if host APEI
driver handles it, it will do nothing.

So for above reasons, we directly inject this Synchronous
External Abort to guest and let guest handle it, for example,
kill the guest application or panic guest OS.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/include/asm/kvm_arm.h |  2 ++
 virt/kvm/arm/mmu.c               | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1188272..b8cb67a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -217,6 +217,8 @@
 #define FSC_SECC_TTW2	(0x1e)
 #define FSC_SECC_TTW3	(0x1f)
 
+#define FSC_SEA_TTW    FSC_SEA_TTW0
+
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b36945d..6eab82d 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1484,8 +1484,18 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_dabt_isextabt(vcpu)) {
 		/*
-		 * For RAS the host kernel may handle this abort.
-		 * There is no need to pass the error into the guest.
+		 * For RAS translation table walk abort, pass the error
+		 * into the guest.
+		 */
+		if (fault_status == FSC_SEA_TTW) {
+			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+			return 1;
+		}
+
+		/*
+		 * For RAS normal memory access abort, the host kernel may
+		 * handle this abort. There is no need to pass the error into
+		 * the guest.
 		 */
 		if (!handle_guest_sea(fault_ipa, kvm_vcpu_get_hsr(vcpu)))
 			return 1;
-- 
1.9.1
