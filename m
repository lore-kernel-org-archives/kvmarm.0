From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 04/16] arm/arm64: KVM: Add PSCI_VERSION helper
Date: Mon, 29 Jan 2018 17:45:47 +0000
Message-ID: <20180129174559.1866-5-marc.zyngier@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180129174559.1866-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>, Robin Murphy <robin.murphy@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to trigger a PSCI version explosion, it doesn't
hurt to introduce a PSCI_VERSION helper that is going to be
used everywhere.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_psci.h | 5 +++--
 virt/kvm/arm/psci.c    | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 2042bb909474..3a408c846c09 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -18,8 +18,9 @@
 #ifndef __KVM_ARM_PSCI_H__
 #define __KVM_ARM_PSCI_H__
 
-#define KVM_ARM_PSCI_0_1	1
-#define KVM_ARM_PSCI_0_2	2
+#define PSCI_VERSION(x,y)	((((x) & 0x7fff) << 16) | ((y) & 0xffff))
+#define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
+#define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
 
 int kvm_psci_version(struct kvm_vcpu *vcpu);
 int kvm_psci_call(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index b322e46fd142..c00bb324e14e 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -222,7 +222,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		 * Bits[31:16] = Major Version = 0
 		 * Bits[15:0] = Minor Version = 2
 		 */
-		val = 2;
+		val = KVM_ARM_PSCI_0_2;
 		break;
 	case PSCI_0_2_FN_CPU_SUSPEND:
 	case PSCI_0_2_FN64_CPU_SUSPEND:
-- 
2.14.2
