From: James Morse <james.morse@arm.com>
Subject: [PATCH v3 09/20] KVM: arm/arm64: mask/unmask daif around VHE guests
Date: Thu,  5 Oct 2017 20:18:01 +0100
Message-ID: <20171005191812.5678-10-james.morse@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F52149D14
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p+4W6-j-DA4i for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 15:20:04 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF90840DBF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:04 -0400 (EDT)
In-Reply-To: <20171005191812.5678-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Non-VHE systems take an exception to EL2 in order to world-switch into the
guest. When returning from the guest KVM implicitly restores the DAIF
flags when it returns to the kernel at EL1.

With VHE none of this exception-level jumping happens, so KVMs
world-switch code is exposed to the host kernel's DAIF values, and KVM
spills the guest-exit DAIF values back into the host kernel.
On entry to a guest we have Debug and SError exceptions unmasked, KVM
has switched VBAR but isn't prepared to handle these. On guest exit
Debug exceptions are left disabled once we return to the host and will
stay this way until we enter user space.

Add a helper to mask/unmask DAIF around VHE guests. The unmask can only
happen after the hosts VBAR value has been synchronised by the isb in
__vhe_hyp_call (via kvm_call_hyp()). Masking could be as late as
setting KVMs VBAR value, but is kept here for symmetry.

Signed-off-by: James Morse <james.morse@arm.com>

---
Give me a kick if you want this reworked as a fix (which will then
conflict with this series), or a backportable version.

 arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
 virt/kvm/arm/arm.c                |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e923b58606e2..d3eb79a9ed6b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/kvm_types.h>
 #include <asm/cpufeature.h>
+#include <asm/daifflags.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
@@ -384,4 +385,13 @@ static inline void __cpu_init_stage2(void)
 		  "PARange is %d bits, unsupported configuration!", parange);
 }
 
+static inline void kvm_arm_vhe_guest_enter(void)
+{
+	local_mask_daif();
+}
+
+static inline void kvm_arm_vhe_guest_exit(void)
+{
+	local_restore_daif(DAIF_PROCCTX_NOIRQ);
+}
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b9f68e4add71..665529924b34 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -698,9 +698,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		trace_kvm_entry(*vcpu_pc(vcpu));
 		guest_enter_irqoff();
+		if (has_vhe())
+			kvm_arm_vhe_guest_enter();
 
 		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
 
+		if (has_vhe())
+			kvm_arm_vhe_guest_exit();
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 		/*
-- 
2.13.3
