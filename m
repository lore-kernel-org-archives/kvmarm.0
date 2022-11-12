Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D30184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F384C433D7;
	Sat, 12 Nov 2022 15:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266293;
	bh=n2cI2Ryl/K/Hs+xrWGQoTkD5IBBhNXw75Kv5kwvMdWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/hVpOltuDPiYePlUwip2Nfkn1iq5MOPmMh6wi/IIZ+bQPguv0tYJBbUoxB0+A27D
	 rDb8KDARC0iwIFx8D9YJjrXBWYgx2iweHR1hxJxXCq9ZUBr6pfxN1xSONZcDlbI40K
	 C9O+o+t2IxUglLO8OAwp6TrQTrULAEi6UA198XJNpK+MV7HK0keOp8ampyJfBKorEa
	 DK6r7am+QPbapL9OjyVeYmeqyHo6s91ULrmrLW6ChKGe/WWUwdB7wnSzcwgbblAE3Y
	 QS9BB4R8uIU85NLUdpkoy0ST+sszOwQwdh8j0PzXplxkOtaTrzGMHPbgwtyGMwl161
	 54QdK+dl8anTg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 10/14] arm64/nmi: Manage masking for superpriority interrupts along with DAIF
Date: Sat, 12 Nov 2022 15:17:04 +0000
Message-Id: <20221112151708.175147-11-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3997; i=broonie@kernel.org; h=from:subject; bh=n2cI2Ryl/K/Hs+xrWGQoTkD5IBBhNXw75Kv5kwvMdWQ=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jvNhEWyWb+I8gtv1BvP6iwP9rPCXkQUSj4TjI2 67sB5+WJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+47wAKCRAk1otyXVSH0DoeB/ 0cu+7D2eO1FlLwWz4eRBj+q5XeE92P2X6d7RyZtGIu4h5ZTIpmHfbqe49u7mx1Z/s2eY5tFsDCqDSO k4q75p7uoL1/gMzrUktGRqigECIMaGiC8I/jiavBORmt0M2X3oK9FWzWWU+zdNMEkiBOxE+ubWO1Se PPV8BUbPFZSVbejp2Fgn9ubDiPjdPwYNZ+sWCZAkWOWvbN5uNBNUkxdz/P9bjKNBm0ET8HmpOjDcyc 4IuAUrxTxdtO2cVw5S6dKNJhEkJz95M9bui/KGhEwBU3+zYNsDCi9OW7pnzj3AzDuRnLItHyMq81p4 OYOEha7oiTH9TzJSmIZ9xQTWx9i5xv
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

As we do for pseudo NMIs add code to our DAIF management which keeps
superpriority interrupts unmasked when we have asynchronous exceptions
enabled. Since superpriority interrupts are not masked through DAIF like
pseduo NMIs are we also need to modify the assembler macros for managing
DAIF to ensure that the masking is done in the assembly code. At present
users of the assembly macros always mask pseudo NMIs.

There is a difference to the actual handling between pseudo NMIs
and superpriority interrupts in the assembly save_and_disable_irq and
restore_irq macros, these cover both interrupts and FIQs using DAIF
without regard for the use of pseudo NMIs so also mask those but are not
updated here to mask superpriority interrupts. Given the names it is not
clear that the behaviour with pseudo NMIs is particularly intentional,
and in any case these macros are only used in the implementation of
alternatives for software PAN while hardware PAN has been mandatory
since v8.1 so it is not anticipated that practical systems with support
for FEAT_NMI will ever execute the affected code.

This should be a conservative set of masked regions, we may be able to
relax this in future, but this should represent a good starting point.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 11 +++++++++++
 arch/arm64/include/asm/daifflags.h | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 88d9779a83c0..e85a7e9af9ae 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -52,19 +52,30 @@ alternative_else_nop_endif
 
 	.macro save_and_disable_daif, flags
 	mrs	\flags, daif
+        disable_allint
 	msr	daifset, #0xf
 	.endm
 
 	.macro disable_daif
+        disable_allint
 	msr	daifset, #0xf
 	.endm
 
 	.macro enable_daif
 	msr	daifclr, #0xf
+	enable_allint
 	.endm
 
 	.macro	restore_daif, flags:req
 	msr	daif, \flags
+#ifdef CONFIG_ARM64_NMI
+alternative_if ARM64_HAS_NMI
+	/* If async exceptions are unmasked we can take NMIs */
+	tbnz	\flags, #8, 2004f
+	msr_s	SYS_ALLINT_CLR, xzr
+2004:
+alternative_else_nop_endif
+#endif
 	.endm
 
 	/* IRQ/FIQ are the lowest priority flags, unconditionally unmask the rest. */
diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index b3bed2004342..fda73976068f 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -10,6 +10,7 @@
 #include <asm/arch_gicv3.h>
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
+#include <asm/nmi.h>
 #include <asm/ptrace.h>
 
 #define DAIF_PROCCTX		0
@@ -35,6 +36,9 @@ static inline void local_daif_mask(void)
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
 
+	if (system_uses_nmi())
+		_allint_set();
+
 	trace_hardirqs_off();
 }
 
@@ -50,6 +54,12 @@ static inline unsigned long local_daif_save_flags(void)
 			flags |= PSR_I_BIT | PSR_F_BIT;
 	}
 
+	if (system_uses_nmi()) {
+		/* If IRQs are masked with ALLINT, reflect in in the flags */
+		if (read_sysreg_s(SYS_ALLINT) & ALLINT_ALLINT)
+			flags |= PSR_I_BIT | PSR_F_BIT;
+	}
+
 	return flags;
 }
 
@@ -114,6 +124,10 @@ static inline void local_daif_restore(unsigned long flags)
 		gic_write_pmr(pmr);
 	}
 
+	/* If we can take asynchronous errors we can take NMIs */
+	if (system_uses_nmi() && !(flags & PSR_A_BIT))
+		_allint_clear();
+
 	write_sysreg(flags, daif);
 
 	if (irq_disabled)
@@ -131,6 +145,10 @@ static inline void local_daif_inherit(struct pt_regs *regs)
 	if (interrupts_enabled(regs))
 		trace_hardirqs_on();
 
+	/* If we can take asynchronous errors we can take NMIs */
+	if (system_uses_nmi() && !(flags & PSR_A_BIT))
+		_allint_clear();
+
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(regs->pmr_save);
 
-- 
2.30.2

