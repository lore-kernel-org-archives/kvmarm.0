From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 18/21] KVM: arm64: Handle RAS SErrors from EL1 on guest exit
Date: Thu, 19 Oct 2017 15:58:04 +0100
Message-ID: <20171019145807.23251-19-james.morse@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC33049D4C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FpK3yMSBHAOZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 10:59:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5C0449D15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:38 -0400 (EDT)
In-Reply-To: <20171019145807.23251-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We expect to have firmware-first handling of RAS SErrors, with errors
notified via an APEI method. For systems without firmware-first, add
some minimal handling to KVM.

There are two ways KVM can take an SError due to a guest, either may be a
RAS error: we exit the guest due to an SError routed to EL2 by HCR_EL2.AMO,
or we take an SError from EL2 when we unmask PSTATE.A from __guest_exit.

For SError that interrupt a guest and are routed to EL2 the existing
behaviour is to inject an impdef SError into the guest.

Add code to handle RAS SError based on the ESR. For uncontained errors
arm64_is_blocking_ras_serror() will panic(), these errors compromise
the host too. All other error types are contained: For the 'blocking'
errors the vCPU can't make progress, so we inject a virtual SError.
We ignore contained errors where we can make progress as if we're lucky,
we may not hit them again.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/handle_exit.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 7debb74843a0..345fdbba6c2e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -28,12 +28,19 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_psci.h>
+#include <asm/traps.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
 typedef int (*exit_handle_fn)(struct kvm_vcpu *, struct kvm_run *);
 
+static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u32 esr)
+{
+	if (!arm64_is_ras_serror(esr) || arm64_blocking_ras_serror(NULL, esr))
+		kvm_inject_vabt(vcpu);
+}
+
 static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int ret;
@@ -211,7 +218,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case ARM_EXCEPTION_IRQ:
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
-		kvm_inject_vabt(vcpu);
+		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_hsr(vcpu));
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		/*
-- 
2.13.3
