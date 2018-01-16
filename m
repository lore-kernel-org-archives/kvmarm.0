From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL v2 3/3] arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC calls
Date: Tue, 16 Jan 2018 18:02:33 +0100
Message-ID: <20180116170233.7085-4-christoffer.dall@linaro.org>
References: <20180116170233.7085-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180116170233.7085-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

KVM doesn't follow the SMCCC when it comes to unimplemented calls,
and inject an UNDEF instead of returning an error. Since firmware
calls are now used for security mitigation, they are becoming more
common, and the undef is counter productive.

Instead, let's follow the SMCCC which states that -1 must be returned
to the caller when getting an unknown function number.

Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
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
