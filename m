From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH] KVM: arm64: fix ptrauth ID register masking logic
Date: Wed,  1 May 2019 17:10:08 +0100
Message-ID: <20190501161008.31498-1-kristina.martsenko@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Murray <andrew.murray@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When a VCPU doesn't have pointer auth, we want to hide all four pointer
auth ID register fields from the guest, not just one of them.

Fixes: 384b40caa8af ("KVM: arm/arm64: Context-switch ptrauth registers")
Reported-by: Andrew Murray <andrew.murray@arm.com>
Fsck-up-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d02643bc601..857b226bcdde 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1088,10 +1088,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
 	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
-		val &= ~(0xfUL << ID_AA64ISAR1_APA_SHIFT) |
-			(0xfUL << ID_AA64ISAR1_API_SHIFT) |
-			(0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
-			(0xfUL << ID_AA64ISAR1_GPI_SHIFT);
+		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
+			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
+			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
+			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
 	}
 
 	return val;
-- 
2.11.0
