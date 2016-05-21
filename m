From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 0091/1529] Fix typo
Date: Sat, 21 May 2016 13:48:41 +0200
Message-ID: <20160521114841.4077-1-andrea.gelmini@gelma.net>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: andrea.gelmini@gelma.net
Cc: trivial@kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index a494def..af93e3f 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -210,7 +210,7 @@ bool kvm_condition_valid(struct kvm_vcpu *vcpu)
  * @vcpu:	The VCPU pointer
  *
  * When exceptions occur while instructions are executed in Thumb IF-THEN
- * blocks, the ITSTATE field of the CPSR is not advanved (updated), so we have
+ * blocks, the ITSTATE field of the CPSR is not advanced (updated), so we have
  * to do this little bit of work manually. The fields map like this:
  *
  * IT[7:0] -> CPSR[26:25],CPSR[15:10]
-- 
2.8.2.534.g1f66975

