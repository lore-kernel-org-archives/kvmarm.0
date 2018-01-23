From: Luis de Bethencourt <luisbg@kernel.org>
Subject: [PATCH] KVM: arm/arm64: Fix trailing semicolon
Date: Tue, 23 Jan 2018 15:11:14 +0000
Message-ID: <20180123151114.18429-1-luisbg@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Russell King <linux@armlinux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Luis de Bethencourt <luisbg@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

The trailing semicolon is an empty statement that does no operation.
Removing it since it doesn't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
---

Hi,

After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
suggested I fix it treewide [0].

Best regards 
Luis


[0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html

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
2.15.1
