From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 03/27] KVM: arm64: Make kvm_condition_valid32() accessible from EL2
Date: Fri,  9 Jun 2017 12:49:32 +0100
Message-ID: <20170609114956.25963-4-marc.zyngier@arm.com>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170609114956.25963-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to trap CP15 accesses and handle them at EL2, we
need to evaluate whether or not the condition flags are valid,
as an implementation is allowed to trap despite the condition
not being met.

Tagging the function as __hyp_text allows this. We still rely on
the cc_map array to be mapped at EL2 by virtue of being "const",
and the linker to only emit relative references.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/aarch32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 528af4b2d09e..79c7c357804b 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -60,7 +60,7 @@ static const unsigned short cc_map[16] = {
 /*
  * Check if a trapped instruction should have been executed or not.
  */
-bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
+bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
 {
 	unsigned long cpsr;
 	u32 cpsr_cond;
-- 
2.11.0
