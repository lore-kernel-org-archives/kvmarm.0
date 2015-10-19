From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCHv4 18/24] arm64/kvm: Make use of the system wide safe values
Date: Mon, 19 Oct 2015 14:00:41 +0100
Message-ID: <1445259647-21541-19-git-send-email-suzuki.poulose@arm.com>
References: <1445259647-21541-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46F0340FAB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 08:58:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GbpXoz6TR21m for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2015 08:58:27 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A23C40C9D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 08:58:26 -0400 (EDT)
In-Reply-To: <1445259647-21541-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: ryan.arnold@linaro.org, ard.biesheuvel@linaro.org, aph@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, edward.nevill@linaro.org, andre.przywara@arm.com, marc.zyngier@arm.com, chirstoffer.dall@linaro.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Use the system wide safe value from the new API for safer
decisions

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/reset.c    |    2 +-
 arch/arm64/kvm/sys_regs.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 91cf535..f34745c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -53,7 +53,7 @@ static bool cpu_has_32bit_el1(void)
 {
 	u64 pfr0;
 
-	pfr0 = read_cpuid(ID_AA64PFR0_EL1);
+	pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
 	return !!(pfr0 & 0x20);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d03d3af..87a64e8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -693,13 +693,13 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_cpuid(ID_AA64DFR0_EL1);
-		u64 pfr = read_cpuid(ID_AA64PFR0_EL1);
-		u32 el3 = !!((pfr >> 12) & 0xf);
+		u64 dfr = read_system_reg(SYS_ID_AA64DFR0_EL1);
+		u64 pfr = read_system_reg(SYS_ID_AA64PFR0_EL1);
+		u32 el3 = !!cpuid_feature_extract_field(pfr, ID_AA64PFR0_EL3_SHIFT);
 
-		*vcpu_reg(vcpu, p->Rt) = ((((dfr >> 20) & 0xf) << 28) |
-					  (((dfr >> 12) & 0xf) << 24) |
-					  (((dfr >> 28) & 0xf) << 20) |
+		*vcpu_reg(vcpu, p->Rt) = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
+					  (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
+					  (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20) |
 					  (6 << 16) | (el3 << 14) | (el3 << 12));
 		return true;
 	}
-- 
1.7.9.5
