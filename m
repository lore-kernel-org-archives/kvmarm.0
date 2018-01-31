From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 25/28] KVM: arm/arm64: Fix trailing semicolon
Date: Wed, 31 Jan 2018 10:35:04 +0100
Message-ID: <20180131093507.22219-26-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Luis de Bethencourt <luisbg@kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Luis de Bethencourt <luisbg@kernel.org>

The trailing semicolon is an empty statement that does no operation.
Removing it since it doesn't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_emulate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 3d22eb87f919..9003bd19cb70 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -131,7 +131,7 @@ static inline bool mode_has_spsr(struct kvm_vcpu *vcpu)
 static inline bool vcpu_mode_priv(struct kvm_vcpu *vcpu)
 {
 	unsigned long cpsr_mode = vcpu->arch.ctxt.gp_regs.usr_regs.ARM_cpsr & MODE_MASK;
-	return cpsr_mode > USR_MODE;;
+	return cpsr_mode > USR_MODE;
 }
 
 static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
-- 
2.14.2
