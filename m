From: Matt Evans <matt.evans@arm.com>
Subject: [PATCH] kvm: arm64: Fix EC field in inject_abt64
Date: Mon, 16 May 2016 13:54:56 +0100
Message-ID: <5739C320.6010602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The EC field of the constructed ESR is conditionally modified by ORing in
ESR_ELx_EC_DABT_LOW for a data abort.  However, ESR_ELx_EC_SHIFT is missing
from this condition.

Signed-off-by: Matt Evans <matt.evans@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: <stable@vger.kernel.org>
---
 arch/arm64/kvm/inject_fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 4d1ac81..e9e0e6d 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -162,7 +162,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 		esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
 
 	if (!is_iabt)
-		esr |= ESR_ELx_EC_DABT_LOW;
+		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
 	vcpu_sys_reg(vcpu, ESR_EL1) = esr | ESR_ELx_FSC_EXTABT;
 }
-- 
1.9.1
