From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 11/26] KVM: arm64: Extend reset_unknown() to handle mixed
 RES0/UNKNOWN registers
Date: Mon, 18 Feb 2019 19:52:24 +0000
Message-ID: <1550519559-15915-12-git-send-email-Dave.Martin@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06AD34A450
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 14:54:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j6pGolDVM4m4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 14:54:26 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B19864A43D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 14:54:23 -0500 (EST)
In-Reply-To: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The reset_unknown() system register helper initialises a guest
register to a distinctive junk value on vcpu reset, to help expose
and debug deficient register initialisation within the guest.

Some registers such as the SVE control register ZCR_EL1 contain a
mixture of UNKNOWN fields and RES0 bits.  For these,
reset_unknown() does not work at present, since it sets all bits to
junk values instead of just the wanted bits.

There is no need to craft another special helper just for that,
since reset_unknown() almost does the appropriate thing anyway.
This patch takes advantage of the unused val field in struct
sys_reg_desc to specify a mask of bits that should be initialised
to zero instead of junk.

All existing users of reset_unknown() do not (and should not)
define a value for val, so they will implicitly set it to zero,
resulting in all bits being made UNKNOWN by this function: thus,
this patch makes no functional change for currently defined
registers.

Future patches will make use of non-zero val.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/sys_regs.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 3b1bc7f..174ffc0 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -56,7 +56,12 @@ struct sys_reg_desc {
 	/* Index into sys_reg[], or 0 if we don't need to save it. */
 	int reg;
 
-	/* Value (usually reset value) */
+	/*
+	 * Value (usually reset value)
+	 * For reset_unknown, each bit set to 1 in val is treated as
+	 * RES0 in the register: the corresponding register bit is
+	 * reset to 0 instead of "unknown".
+	 */
 	u64 val;
 
 	/* Custom get/set_user functions, fallback to generic if NULL */
@@ -92,7 +97,9 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
 {
 	BUG_ON(!r->reg);
 	BUG_ON(r->reg >= NR_SYS_REGS);
-	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
+
+	/* If non-zero, r->val specifies which register bits are RES0: */
+	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL & ~r->val;
 }
 
 static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-- 
2.1.4
