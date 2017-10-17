From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v7 3/4] arm64: kvm: Set Virtual SError Exception Syndrome for
 guest
Date: Tue, 17 Oct 2017 22:14:48 +0800
Message-ID: <1508249689-10350-4-git-send-email-gengdongjiu@huawei.com>
References: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0CF949D2C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 09:49:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y4G2kTRsexjS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 09:49:09 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 853EA49D19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 09:49:07 -0400 (EDT)
In-Reply-To: <1508249689-10350-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, gengdongjiu@huawei.com, wuquanming@huawei.com, kristina.martsenko@arm.com, mingo@kernel.org, punit.agrawal@arm.com, stephen.boyd@linaro.org, kamensky@cisco.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

RAS Extension add a VSESR_EL2 register which can provides
the syndrome value reported to software on taking a virtual
SError interrupt exception. This patch supports to specify
this Syndrome.

In the RAS Extensions we can not set all-zero syndrome value
for SError, which means 'RAS error: Uncategorized' instead of
'no valid ISS'. So set it to IMPLEMENTATION DEFINED syndrome
by default.

we also need to support userspace to specify a valid syndrome
value, Because in some case, the recovery is driven by userspace.
This patch can support that serspace can specify it.

In the guest/host world switch, restore this value to VSESR_EL2
only when HCR_EL2.VSE is set. This value no need to be saved
because it is stale vale when guest exit.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Quanming Wu <wuquanming@huawei.com>
[Set an impdef ESR for Virtual-SError]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
 arch/arm64/include/asm/kvm_host.h    |  1 +
 arch/arm64/include/asm/sysreg.h      |  3 +++
 arch/arm64/include/asm/system_misc.h |  1 -
 arch/arm64/kvm/guest.c               | 11 ++++++++++-
 arch/arm64/kvm/hyp/switch.c          | 15 +++++++++++++++
 arch/arm64/kvm/inject_fault.c        | 13 ++++++++++++-
 7 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 47983db..74213bd 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -155,6 +155,16 @@ static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.esr_el2;
 }
 
+static inline u32 kvm_vcpu_get_vsesr(const struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.fault.vsesr_el2;
+}
+
+static inline void kvm_vcpu_set_vsesr(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	vcpu->arch.fault.vsesr_el2 = val;
+}
+
 static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 {
 	u32 esr = kvm_vcpu_get_hsr(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dd4cb25..1a0c07e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -88,6 +88,7 @@ struct kvm_vcpu_fault_info {
 	u32 esr_el2;		/* Hyp Syndrom Register */
 	u64 far_el2;		/* Hyp Fault Address Register */
 	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
+	u32 vsesr_el2;          /* Virtual SError Exception Syndrome Register */
 };
 
 /*
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index bd11ca0..e6c7fb8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -86,6 +86,9 @@
 #define REG_PSTATE_PAN_IMM		sys_reg(0, 0, 4, 0, 4)
 #define REG_PSTATE_UAO_IMM		sys_reg(0, 0, 4, 0, 3)
 
+/* virtual SError exception syndrome register in armv8.2 */
+#define REG_VSESR_EL2                  sys_reg(3, 4, 5, 2, 3)
+
 #define SET_PSTATE_PAN(x) __emit_inst(0xd5000000 | REG_PSTATE_PAN_IMM |	\
 				      (!!x)<<8 | 0x1f)
 #define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
index 07aa8e3..e70cb61 100644
--- a/arch/arm64/include/asm/system_misc.h
+++ b/arch/arm64/include/asm/system_misc.h
@@ -57,7 +57,6 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 })
 
 int handle_guest_sea(phys_addr_t addr, unsigned int esr);
-
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __ASM_SYSTEM_MISC_H */
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 0a08b05..a9acbfd 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -279,7 +279,16 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 int kvm_arm_set_sei_esr(struct kvm_vcpu *vcpu, u64 *syndrome)
 {
-	return -EINVAL;
+	u64 reg = *syndrome;
+
+	/* inject virtual system Error or asynchronous abort */
+	kvm_inject_vabt(vcpu);
+
+	if (reg)
+		/* set vsesr_el2[24:0] with value that user space specified */
+		kvm_vcpu_set_vsesr(vcpu, reg & ESR_ELx_ISS_MASK);
+
+	return 0;
 }
 
 int __attribute_const__ kvm_target_cpu(void)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c6f17c7..7c0915e 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -67,6 +67,14 @@ static hyp_alternate_select(__activate_traps_arch,
 			    __activate_traps_nvhe, __activate_traps_vhe,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
+static void __hyp_text __sysreg_set_vsesr(struct kvm_vcpu *vcpu)
+{
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) &&
+		(vcpu->arch.hcr_el2 & HCR_VSE))
+		write_sysreg_s(vcpu->arch.fault.vsesr_el2, REG_VSESR_EL2);
+}
+
+
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
@@ -86,6 +94,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 	write_sysreg(val, hcr_el2);
+
+	/*
+	 * If the virtual SError interrupt is taken to EL1 using AArch64,
+	 * then VSESR_EL2 provides the syndrome value reported in ESR_EL1.
+	 */
+	__sysreg_set_vsesr(vcpu);
+
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 	/*
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index da6a8cf..2457222 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -232,14 +232,25 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 		inject_undef64(vcpu);
 }
 
+static void pend_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
+{
+	kvm_vcpu_set_vsesr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+}
+
 /**
  * kvm_inject_vabt - inject an async abort / SError into the guest
  * @vcpu: The VCPU to receive the exception
  *
  * It is assumed that this code is called from the VCPU thread and that the
  * VCPU therefore is not currently executing guest code.
+ *
+ * Systems with the RAS Extensions specify an imp-def ESR (ISV/IDS = 1) with
+ * the remaining ISS all-zeros so that this error is not interpreted as an
+ * uncatagorized RAS error. Without the RAS Extensions we can't specify an ESR
+ * value, so the CPU generates an imp-def value.
  */
 void kvm_inject_vabt(struct kvm_vcpu *vcpu)
 {
-	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
+	pend_guest_serror(vcpu, ESR_ELx_ISV);
 }
-- 
2.10.1
