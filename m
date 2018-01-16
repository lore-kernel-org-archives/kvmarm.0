From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls
Date: Tue, 16 Jan 2018 10:23:47 +0000
Message-ID: <20180116102347.20892-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

KVM doesn't follow the SMCCC when it comes to unimplemented calls,
and inject an UNDEF instead of returning an error. Since firmware
calls are now used for security mitigation, they are becoming more
common, and the undef is counter productive.

Instead, let's follow the SMCCC which states that -1 must be returned
to the caller when getting an unknown function number.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
This has been identified as an issue when working on the Spectre issues,
as guest have to perform HVC/SMC calls to invalidate their branch predictors,
and need to perform some form of discovery. 32bit is affected too, but the
mitigation doesn't involve firmware, so we can fix it separately.

 arch/arm64/kvm/handle_exit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 304203fa9e33..e60494f1eef9 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -45,7 +45,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	ret = kvm_psci_call(vcpu);
 	if (ret < 0) {
-		kvm_inject_undefined(vcpu);
+		vcpu_set_reg(vcpu, 0, ~0UL);
 		return 1;
 	}
 
@@ -54,7 +54,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	kvm_inject_undefined(vcpu);
+	vcpu_set_reg(vcpu, 0, ~0UL);
 	return 1;
 }
 
-- 
2.14.2
