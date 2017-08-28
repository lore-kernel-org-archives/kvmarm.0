From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v6 5/7] arm64: kvm: route synchronous external abort
 exceptions to el2
Date: Mon, 28 Aug 2017 18:38:19 +0800
Message-ID: <1503916701-13516-6-git-send-email-gengdongjiu@huawei.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 150AC49C39
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 06:17:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kJ+kiELY95LQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Aug 2017 06:17:22 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B6F140D16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 06:17:20 -0400 (EDT)
In-Reply-To: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
Cc: zhengqiang10@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linuxarm@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

ARMv8.2 adds a new bit HCR_EL2.TEA which controls to
route synchronous external aborts to EL2, and adds a
trap control bit HCR_EL2.TERR which controls to
trap all Non-secure EL1&0 error record accesses to EL2.

This patch enables the two bits for the guest OS.
when an synchronous abort is generated in the guest OS,
it will trap to EL3 firmware, EL3 firmware will check the
HCR_EL2.TEA value to decide to jump to hypervisor or host
OS. Enabling HCR_EL2.TERR makes error record access
from guest trap to EL2.

change since v5:
1. modify some patch description

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 2 ++
 arch/arm64/include/asm/kvm_emulate.h | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 61d694c2eae5..1188272003c4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,8 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_TEA		(UL(1) << 37)
+#define HCR_TERR	(UL(1) << 36)
 #define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
 #define HCR_CD		(UL(1) << 32)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fe39e6841326..47983db27de2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -47,6 +47,13 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
 	if (is_kernel_in_hyp_mode())
 		vcpu->arch.hcr_el2 |= HCR_E2H;
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
+
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 }
-- 
2.14.1
