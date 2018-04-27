From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: vgic-v2: Fix proxying of cpuif access
Date: Fri, 27 Apr 2018 15:51:02 +0100
Message-ID: <20180427145102.5645-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA6749F7E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Apr 2018 10:42:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U+4bx5aS3Pjx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Apr 2018 10:41:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62C4D4070F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Apr 2018 10:41:39 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Proxying the cpuif accesses at EL2 makes use of vcpu_data_guest_to_host
and co, which check the endianness, which call into vcpu_read_sys_reg...
which isn't mapped at EL2 (it was inlined before, and got moved OoL
with the VHE optimizations).

The result is of course a nice panic. Let's add some specialized
cruft to keep the broken platforms that require this hack alive.
I'd rather kill BE support, but hey, just in case...

Fixes: d47533dab9f5 ("KVM: arm64: Introduce framework for accessing deferred sysregs")
Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 33 ++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 86801b6055d6..b83a669b26ac 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -23,6 +23,30 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+static bool __hyp_text __is_be(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_mode_is_32bit(vcpu))
+		return !!(read_sysreg_el2(spsr) & COMPAT_PSR_E_BIT);
+
+	return !!(read_sysreg(SCTLR_EL1) & SCTLR_ELx_EE);
+}
+
+static u32 __hyp_text __host_to_guest_u32(struct kvm_vcpu *vcpu, u32 data)
+{
+	if (__is_be(vcpu))
+		return cpu_to_be32(data);
+
+	return cpu_to_le32(data);
+}
+
+static u32 __hyp_text __guest_to_host_u32(struct kvm_vcpu *vcpu, u32 data)
+{
+	if (__is_be(vcpu))
+		return be32_to_cpu(data);
+
+	return le32_to_cpu(data);
+}
+
 /*
  * __vgic_v2_perform_cpuif_access -- perform a GICV access on behalf of the
  *				     guest.
@@ -64,14 +88,11 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-		u32 data = vcpu_data_guest_to_host(vcpu,
-						   vcpu_get_reg(vcpu, rd),
-						   sizeof(u32));
+		u32 data = __guest_to_host_u32(vcpu, vcpu_get_reg(vcpu, rd));
 		writel_relaxed(data, addr);
 	} else {
-		u32 data = readl_relaxed(addr);
-		vcpu_set_reg(vcpu, rd, vcpu_data_host_to_guest(vcpu, data,
-							       sizeof(u32)));
+		u32 data = __host_to_guest_u32(vcpu, readl_relaxed(addr));
+		vcpu_set_reg(vcpu, rd, data);
 	}
 
 	return 1;
-- 
2.14.2
