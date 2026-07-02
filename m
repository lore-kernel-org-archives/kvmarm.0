Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2FF30BF69;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008183; cv=none; b=jncVS+avDeKEsUChnzSo+qKOe+76p45w6Mqf/sZ3p0fPy0lZVAf/0l3JlrfLRYBHn6KvIYFs7LNjT629k1oWruuRRt4YXS1iLBsYTe8i8yW1jeO/yqjeoEUOhoWDS+eEXlv8lwz6RQg+pmQSdfy8J9IUP1oXQNJMXn0/cjGVtO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008183; c=relaxed/simple;
	bh=ktfMDVv/zf4wx9P3PlLF0g2ZkKSUV7t7QN9U9DDIIks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9NF1CWrOp2YCzlFHEEkyHFcH1fQOREaCH+O4it7nayhpoXmki4085fI44adpA9P+qCwnRQUX5nvnz2dKN5BK6I9UJLn6aOX+3w29KiFFtroKOsT/h7TlMwKlrAz2A/lBMqbM4+MDtNfWi7pdTpt84QfCQMW5pTqUojXejh/VYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JeH9J8Vf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JeH9J8Vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8D81F00ACA;
	Thu,  2 Jul 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008181;
	bh=t1T8tI1HpNI3+MyL1Fhd8AJJnZ30lviFe7dz5NPPVnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeH9J8Vf4EzNKpEHWiWmDrwZsD+Zf31V7EnbgyuOouvHMEsHJDLSNzRT0IxTMDZXx
	 7hwz2hDN8LOLmR69B7BI6OpkMVNEjxq0Evdt06D5WULXrI7smZvperJBn15x9kheVh
	 8l2dSEK/ogls0LYBXdfkSrh32IvA+j/gvJWPIEwxqawtc09FgLbgEOrmzcLIkN9d1Z
	 ac92kO6NynfLVdCR4f2UqrHC1kiHcuEit2CuNEalDfx/rI7jL+tqyIf4AXfwTrlSYP
	 X96rXzQ9Hzq1QAfb0nKqBcVPzga7BU6XQmxf7I9xBxFNTBu2xULG10arFP3f9W0xBD
	 7/BR11WunsGQA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsR-00000000ojd-1NmS;
	Thu, 02 Jul 2026 16:02:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 06/28] KVM: arm64: Classify CPTR_EL2 as a SR_LOC_SPECIAL register
Date: Thu,  2 Jul 2026 17:02:26 +0100
Message-ID: <20260702160248.1377250-7-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It may not be obvious unless you look at it closely, but CPTR_EL2
is treated very differently from other registers. It is one the
registers that, despite looking very similar between EL1 and EL2
when E2H==1, have RES0 bits that get in the way.

Make it clear that CPTR_EL2 is odd by classifying it as SR_LOC_SPECIAL,
just like CNTHCTL_EL2 (and for the same reasons). This makes it
possible to use vcpu_read_sys_reg() with it, and will be necessary
once we support FEAT_NV2P1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/kvm/sys_regs.c            | 20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c7..9831166695186 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -617,7 +617,7 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
  */
 static inline u64 vcpu_sanitised_cptr_el2(const struct kvm_vcpu *vcpu)
 {
-	u64 cptr = __vcpu_sys_reg(vcpu, CPTR_EL2);
+	u64 cptr = vcpu_read_sys_reg(vcpu, CPTR_EL2);
 
 	if (!vcpu_el2_e2h_is_set(vcpu))
 		cptr = translate_cptr_el2_to_cpacr_el1(cptr);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5d5c579d45790..6b47d936efb32 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -183,8 +183,6 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
 	switch (reg) {
 		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
 				  translate_sctlr_el2_to_sctlr_el1	     );
-		MAPPED_EL2_SYSREG(CPTR_EL2,    CPACR_EL1,
-				  translate_cptr_el2_to_cpacr_el1	     );
 		MAPPED_EL2_SYSREG(TTBR0_EL2,   TTBR0_EL1,
 				  translate_ttbr0_el2_to_ttbr0_el1	     );
 		MAPPED_EL2_SYSREG(TTBR1_EL2,   TTBR1_EL1,   NULL	     );
@@ -210,6 +208,19 @@ static void locate_register(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg,
 		loc->loc = ((is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu)) ?
 			    SR_LOC_SPECIAL : SR_LOC_MEMORY);
 		break;
+	case CPTR_EL2:
+		/*
+		 * CPTR_EL2 is just as special, and needs a certain amount
+		 * of handholding. It always lives in memory, due to being
+		 * heavily trapped thanks to CPACR_EL1.TCPAC being RES0.
+		 * FEAT_NV2p1 fixes this.
+		 */
+		locate_mapped_el2_register(vcpu, CPTR_EL2, CPACR_EL1,
+					   translate_cptr_el2_to_cpacr_el1,
+					   loc);
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			loc->loc = SR_LOC_SPECIAL;
+		break;
 	default:
 		loc->loc = locate_direct_register(vcpu, reg);
 	}
@@ -314,6 +325,8 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 			val &= CNTKCTL_VALID_BITS;
 			val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
 			return val;
+		case CPTR_EL2:
+			return __vcpu_sys_reg(vcpu, reg);
 		default:
 			WARN_ON_ONCE(1);
 		}
@@ -359,6 +372,9 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
 			 */
 			write_sysreg_el1(val, SYS_CNTKCTL);
 			break;
+		case CPTR_EL2:
+			write_sysreg_el1(val, SYS_CPACR);
+			break;
 		default:
 			WARN_ON_ONCE(1);
 		}
-- 
2.47.3

