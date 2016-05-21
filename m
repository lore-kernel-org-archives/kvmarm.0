From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 0093/1529] Fix typo
Date: Sat, 21 May 2016 13:48:52 +0200
Message-ID: <20160521114852.4176-1-andrea.gelmini@gelma.net>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: andrea.gelmini@gelma.net
Cc: trivial@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm/kvm/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
index 0048b5a..4b5e802 100644
--- a/arch/arm/kvm/reset.c
+++ b/arch/arm/kvm/reset.c
@@ -52,7 +52,7 @@ static const struct kvm_irq_level cortexa_vtimer_irq = {
  * @vcpu: The VCPU pointer
  *
  * This function finds the right table above and sets the registers on the
- * virtual CPU struct to their architectually defined reset values.
+ * virtual CPU struct to their architecturally defined reset values.
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
-- 
2.8.2.534.g1f66975

