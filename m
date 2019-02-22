From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 17/27] arm64: KVM: Describe data or unified caches as having 1
 set and 1 way
Date: Fri, 22 Feb 2019 16:25:55 +0000
Message-ID: <20190222162605.5054-18-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F2F4A320
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cFSXvZBUCDao for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:28:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92AA54A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:27 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

On SMP ARM systems, cache maintenance by set/way should only ever be
done in the context of onlining or offlining CPUs, which is typically
done by bare metal firmware and never in a virtual machine. For this
reason, we trap set/way cache maintenance operations and replace them
with conditional flushing of the entire guest address space.

Due to this trapping, the set/way arguments passed into the set/way
ops are completely ignored, and thus irrelevant. This also means that
the set/way geometry is equally irrelevant, and we can simply report
it as 1 set and 1 way, so that legacy 32-bit ARM system software (i.e.,
the kind that only receives odd fixes) doesn't take a performance hit
due to the trapping when iterating over the cachelines.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  3 ++-
 arch/arm64/kvm/sys_regs.c            | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9acccb1e3746..d3842791e1c4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -78,7 +78,8 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID3;
 
-	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE))
+	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
+	    vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID2;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 45a07cfc57ed..81a342679e60 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1186,6 +1186,21 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	csselr = vcpu_read_sys_reg(vcpu, CSSELR_EL1);
 	p->regval = get_ccsidr(csselr);
+
+	/*
+	 * Guests should not be doing cache operations by set/way at all, and
+	 * for this reason, we trap them and attempt to infer the intent, so
+	 * that we can flush the entire guest's address space at the appropriate
+	 * time.
+	 * To prevent this trapping from causing performance problems, let's
+	 * expose the geometry of all data and unified caches (which are
+	 * guaranteed to be PIPT and thus non-aliasing) as 1 set and 1 way.
+	 * [If guests should attempt to infer aliasing properties from the
+	 * geometry (which is not permitted by the architecture), they would
+	 * only do so for virtually indexed caches.]
+	 */
+	if (!(csselr & 1)) // data or unified cache
+		p->regval &= ~GENMASK(27, 3);
 	return true;
 }
 
-- 
2.20.1
