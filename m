From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2 2/3] arm64: KVM: Support Common Not Private translations
Date: Wed, 11 Oct 2017 13:19:54 +0100
Message-ID: <1507724395-13735-3-git-send-email-vladimir.murzin@arm.com>
References: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94EBA49D6D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 08:19:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id clfQOD1VCWn9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 08:19:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A922549D39
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 08:19:32 -0400 (EDT)
In-Reply-To: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kbuild-all@01.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We rely on cpufeature framework to detect and enable CNP so for KVM we
need to patch hyp to set CNP bit just before TTBR0_EL2 gets written.
For the guest it is enough to update VTTBR_EL2 with CNP bit just
before it gets scheduled.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/kvm/hyp-init.S   | 4 ++++
 arch/arm64/kvm/hyp/switch.c | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 3f96155..4fd31b3 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -63,6 +63,10 @@ __do_hyp_init:
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.lo	__kvm_handle_stub_hvc
 
+alternative_if ARM64_HAS_CNP
+	orr	x0, x0, #TTBR_CNP_BIT
+alternative_else_nop_endif
+
 	msr	ttbr0_el2, x0
 
 	mrs	x4, tcr_el1
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 945e79c..a1f3bf2 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -150,7 +150,11 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	u64 val = kvm->arch.vttbr;
+
+	if (system_supports_cnp())
+		val |= TTBR_CNP_BIT;
+	write_sysreg(val, vttbr_el2);
 }
 
 static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
-- 
2.0.0
