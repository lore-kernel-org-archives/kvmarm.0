From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/2] arm64: kvm: describe data or unified caches as having
 1 set and 1 way
Date: Thu, 31 Jan 2019 14:17:18 +0100
Message-ID: <20190131131718.1627-3-ard.biesheuvel@linaro.org>
References: <20190131131718.1627-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2254A3CA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:17:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 73m21J8JOUhQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 08:17:32 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2977F4A393
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:17:32 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id d15so2468984wmb.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 05:17:32 -0800 (PST)
In-Reply-To: <20190131131718.1627-1-ard.biesheuvel@linaro.org>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

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
---
 arch/arm64/include/asm/kvm_emulate.h |  3 ++-
 arch/arm64/kvm/sys_regs.c            | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 87f9c1b6387e..c450b15511b7 100644
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
index 1312aebf74e6..5882e3410acc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1188,6 +1188,21 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
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
