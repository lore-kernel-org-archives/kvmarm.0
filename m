From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/14] arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening
 support
Date: Fri, 26 Jan 2018 14:28:43 +0000
Message-ID: <20180126142847.31240-11-marc.zyngier@arm.com>
References: <20180126142847.31240-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6838B49DE1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jan 2018 09:23:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DcK0kyr3w0he for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jan 2018 09:23:54 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9004249E1C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jan 2018 09:23:53 -0500 (EST)
In-Reply-To: <20180126142847.31240-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

A new feature of SMCCC 1.1 is that it offers firmware-based CPU
workarounds. In particular, SMCCC_ARCH_WORKAROUND_1 provides
BP hardening for CVE-2017-5715.

If the host has some mitigation for this issue, report that
we deal with it using SMCCC_ARCH_WORKAROUND_1, as we apply the
host workaround on every guest exit.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/arm-smccc.h |  5 +++++
 virt/kvm/arm/psci.c       | 17 +++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index dc68aa5a7261..e1ef944ef1da 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -73,6 +73,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 1)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_1					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x8000)
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index a021b62ed762..5677d16abc71 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -407,14 +407,27 @@ static int kvm_psci_call(struct kvm_vcpu *vcpu)
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
-	u32 val;
+	u32 val, feature;
 
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		val = ARM_SMCCC_VERSION_1_1;
 		break;
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
-		val = -1;	/* Nothing supported yet */
+		feature = smccc_get_arg1(vcpu);
+		switch(feature) {
+#ifdef CONFIG_ARM64
+		case ARM_SMCCC_ARCH_WORKAROUND_1:
+			if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR))
+				val = 0;
+			else
+				val = -1;
+			break;
+#endif
+		default:
+			val = -1;
+			break;
+		}
 		break;
 	default:
 		return kvm_psci_call(vcpu);
-- 
2.14.2
