Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B163B146A8E
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 03:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337148; cv=none; b=foFZOdTUmHwp2JIirvdDUJxI0Xil8+AD8k1Oj/3KPNxRJqwHNLZsn5/2qPg75XWNhEAdRiMkCV14JsU/B4gmXRwDofH6i2BPMeMaQ+UAuhDLoSiAacPbbYy/JQz2r71GB8O3HuvoIi2+lZuQ6dImuvkQw2+WsR2/wRGtWKXy23o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337148; c=relaxed/simple;
	bh=+l+Xs+IiA1YyDxWbZ+dSmTbwVXtJIns5qTnHu32rQ5I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebfllb/TMz0KM7+VaT0x221GVKIqJwUQFRBVlRma4ASOrLwuoJrZEBZ7U6/hMw4eWV7YnrqWBYRcVtnSJOZEJ17bouBGZJDulOH3iGnC5uOk5mtFlCyYj/Yp5JjOS6OrBxxgzVGH+YN9wBcjkqtOKT4sXUm6OlwSVUi4HPw5BTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W0lgN1k9Zzdb9L;
	Fri, 14 Jun 2024 11:50:56 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F080140732;
	Fri, 14 Jun 2024 11:52:24 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 14 Jun
 2024 11:52:22 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <ryabinin.a.a@gmail.com>,
	<glider@google.com>, <andreyknvl@gmail.com>, <dvyukov@google.com>,
	<vincenzo.frascino@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<mark.rutland@arm.com>, <lpieralisi@kernel.org>, <tglx@linutronix.de>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<steven.price@arm.com>, <ryan.roberts@arm.com>, <pcc@google.com>,
	<anshuman.khandual@arm.com>, <eric.auger@redhat.com>,
	<miguel.luis@oracle.com>, <shiqiliu@hust.edu.cn>, <quic_jiles@quicinc.com>,
	<rafael@kernel.org>, <sudeep.holla@arm.com>, <dwmw@amazon.co.uk>,
	<joey.gouly@arm.com>, <jeremy.linton@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<swboyd@chromium.org>, <dianders@chromium.org>,
	<shijie@os.amperecomputing.com>, <bhe@redhat.com>,
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <mhiramat@kernel.org>,
	<mcgrof@kernel.org>, <rmk+kernel@armlinux.org.uk>,
	<Jonathan.Cameron@huawei.com>, <takakura@valinux.co.jp>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <tabba@google.com>,
	<kristina.martsenko@arm.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kasan-dev@googlegroups.com>, <kvmarm@lists.linux.dev>
Subject: [PATCH v4 01/10] arm64/sysreg: Add definitions for immediate versions of MSR ALLINT
Date: Fri, 14 Jun 2024 03:44:24 +0000
Message-ID: <20240614034433.602622-2-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240614034433.602622-1-liaochang1@huawei.com>
References: <20240614034433.602622-1-liaochang1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200013.china.huawei.com (7.221.188.133)

Use existing helper in sysregs.h to generate the variant for MSR
instruction used to set the ALLINT field of PSTATE directly using
immediate.

  MSR ALLINT, #Imm1 ;used to set the value of PSTATE.ALLINT

As Mark suggested in [1], the series of PSTATE related helper names in
sysregs.h are lack of self-explanatory nature, which make it difficult
to understand their function and purpose. This patch also rename these
helper from the sytle of SET_XXX to MSR_XXX to make them discoverable.

[1] https://lore.kernel.org/all/ZjpALOdSgu-qhshR@finisterre.sirena.org.uk/

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/include/asm/mte-kasan.h |  4 ++--
 arch/arm64/include/asm/mte.h       |  2 +-
 arch/arm64/include/asm/sysreg.h    | 27 +++++++++++++++------------
 arch/arm64/include/asm/uaccess.h   |  4 ++--
 arch/arm64/kernel/cpufeature.c     |  4 ++--
 arch/arm64/kernel/entry-common.c   |  4 ++--
 arch/arm64/kernel/entry.S          |  2 +-
 arch/arm64/kernel/proton-pack.c    |  4 ++--
 arch/arm64/kernel/suspend.c        |  2 +-
 arch/arm64/kvm/hyp/entry.S         |  2 +-
 10 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
index 2e98028c1965..78e022d462e8 100644
--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -53,13 +53,13 @@ static inline bool system_uses_mte_async_or_asymm_mode(void)
  */
 static inline void mte_disable_tco(void)
 {
-	asm volatile(ALTERNATIVE("nop", SET_PSTATE_TCO(0),
+	asm volatile(ALTERNATIVE("nop", MSR_PSTATE_TCO(0),
 				 ARM64_MTE, CONFIG_KASAN_HW_TAGS));
 }
 
 static inline void mte_enable_tco(void)
 {
-	asm volatile(ALTERNATIVE("nop", SET_PSTATE_TCO(1),
+	asm volatile(ALTERNATIVE("nop", MSR_PSTATE_TCO(1),
 				 ARM64_MTE, CONFIG_KASAN_HW_TAGS));
 }
 
diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 91fbd5c8a391..e914ca1c90a0 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -174,7 +174,7 @@ static inline void mte_disable_tco_entry(struct task_struct *task)
 	 */
 	if (kasan_hw_tags_enabled() ||
 	    (task->thread.sctlr_user & (1UL << SCTLR_EL1_TCF0_SHIFT)))
-		asm volatile(SET_PSTATE_TCO(0));
+		asm volatile(MSR_PSTATE_TCO(0));
 }
 
 #ifdef CONFIG_KASAN_HW_TAGS
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index af3b206fa423..4f514bdfb1bd 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -90,24 +90,27 @@
  */
 #define pstate_field(op1, op2)		((op1) << Op1_shift | (op2) << Op2_shift)
 #define PSTATE_Imm_shift		CRm_shift
-#define SET_PSTATE(x, r)		__emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
+#define MSR_PSTATE_ENCODE(x, r)		__emit_inst(0xd500401f | PSTATE_ ## r | ((!!x) << PSTATE_Imm_shift))
 
 #define PSTATE_PAN			pstate_field(0, 4)
 #define PSTATE_UAO			pstate_field(0, 3)
 #define PSTATE_SSBS			pstate_field(3, 1)
 #define PSTATE_DIT			pstate_field(3, 2)
 #define PSTATE_TCO			pstate_field(3, 4)
-
-#define SET_PSTATE_PAN(x)		SET_PSTATE((x), PAN)
-#define SET_PSTATE_UAO(x)		SET_PSTATE((x), UAO)
-#define SET_PSTATE_SSBS(x)		SET_PSTATE((x), SSBS)
-#define SET_PSTATE_DIT(x)		SET_PSTATE((x), DIT)
-#define SET_PSTATE_TCO(x)		SET_PSTATE((x), TCO)
-
-#define set_pstate_pan(x)		asm volatile(SET_PSTATE_PAN(x))
-#define set_pstate_uao(x)		asm volatile(SET_PSTATE_UAO(x))
-#define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
-#define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
+#define PSTATE_ALLINT			pstate_field(1, 0)
+
+#define MSR_PSTATE_PAN(x)		MSR_PSTATE_ENCODE((x), PAN)
+#define MSR_PSTATE_UAO(x)		MSR_PSTATE_ENCODE((x), UAO)
+#define MSR_PSTATE_SSBS(x)		MSR_PSTATE_ENCODE((x), SSBS)
+#define MSR_PSTATE_DIT(x)		MSR_PSTATE_ENCODE((x), DIT)
+#define MSR_PSTATE_TCO(x)		MSR_PSTATE_ENCODE((x), TCO)
+#define MSR_PSTATE_ALLINT(x)		MSR_PSTATE_ENCODE((x), ALLINT)
+
+#define msr_pstate_pan(x)		asm volatile(MSR_PSTATE_PAN(x))
+#define msr_pstate_uao(x)		asm volatile(MSR_PSTATE_UAO(x))
+#define msr_pstate_ssbs(x)		asm volatile(MSR_PSTATE_SSBS(x))
+#define msr_pstate_dit(x)		asm volatile(MSR_PSTATE_DIT(x))
+#define msr_pstate_allint(x)		asm volatile(MSR_PSTATE_ALLINT(x))
 
 #define __SYS_BARRIER_INSN(CRm, op2, Rt) \
 	__emit_inst(0xd5000000 | sys_insn(0, 3, 3, (CRm), (op2)) | ((Rt) & 0x1f))
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 14be5000c5a0..34890df54e2e 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -124,13 +124,13 @@ static inline bool uaccess_ttbr0_enable(void)
 
 static inline void __uaccess_disable_hw_pan(void)
 {
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,
+	asm(ALTERNATIVE("nop", MSR_PSTATE_PAN(0), ARM64_HAS_PAN,
 			CONFIG_ARM64_PAN));
 }
 
 static inline void __uaccess_enable_hw_pan(void)
 {
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
+	asm(ALTERNATIVE("nop", MSR_PSTATE_PAN(1), ARM64_HAS_PAN,
 			CONFIG_ARM64_PAN));
 }
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 48e7029f1054..03a37a21fc99 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2151,7 +2151,7 @@ static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 	WARN_ON_ONCE(in_interrupt());
 
 	sysreg_clear_set(sctlr_el1, SCTLR_EL1_SPAN, 0);
-	set_pstate_pan(1);
+	msr_pstate_pan(1);
 }
 #endif /* CONFIG_ARM64_PAN */
 
@@ -2339,7 +2339,7 @@ static void cpu_trap_el0_impdef(const struct arm64_cpu_capabilities *__unused)
 
 static void cpu_enable_dit(const struct arm64_cpu_capabilities *__unused)
 {
-	set_pstate_dit(1);
+	msr_pstate_dit(1);
 }
 
 static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index b77a15955f28..72c2c9d033a8 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -953,9 +953,9 @@ __sdei_handler(struct pt_regs *regs, struct sdei_registered_event *arg)
 	 * clearing it when the host isn't using it, in case a VM had it set.
 	 */
 	if (system_uses_hw_pan())
-		set_pstate_pan(1);
+		msr_pstate_pan(1);
 	else if (cpu_has_pan())
-		set_pstate_pan(0);
+		msr_pstate_pan(0);
 
 	arm64_enter_nmi(regs);
 	ret = do_sdei_event(regs, arg);
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 7ef0e127b149..c568b4ff9e62 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -197,7 +197,7 @@ alternative_cb_end
 
 	.macro	kernel_entry, el, regsize = 64
 	.if	\el == 0
-	alternative_insn nop, SET_PSTATE_DIT(1), ARM64_HAS_DIT
+	alternative_insn nop, MSR_PSTATE_DIT(1), ARM64_HAS_DIT
 	.endif
 	.if	\regsize == 32
 	mov	w0, w0				// zero upper 32 bits of x0
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index baca47bd443c..735db447695a 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -552,12 +552,12 @@ static enum mitigation_state spectre_v4_enable_hw_mitigation(void)
 
 	if (spectre_v4_mitigations_off()) {
 		sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_DSSBS);
-		set_pstate_ssbs(1);
+		msr_pstate_ssbs(1);
 		return SPECTRE_VULNERABLE;
 	}
 
 	/* SCTLR_EL1.DSSBS was initialised to 0 during boot */
-	set_pstate_ssbs(0);
+	msr_pstate_ssbs(0);
 
 	/*
 	 * SSBS is self-synchronizing and is intended to affect subsequent
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index eaaff94329cd..0e79af827540 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -63,7 +63,7 @@ void notrace __cpu_suspend_exit(void)
 	 * features that might not have been set correctly.
 	 */
 	if (alternative_has_cap_unlikely(ARM64_HAS_DIT))
-		set_pstate_dit(1);
+		msr_pstate_dit(1);
 	__uaccess_enable_hw_pan();
 
 	/*
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index f3aa7738b477..e1cb3ea49140 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -113,7 +113,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 
 	add	x1, x1, #VCPU_CONTEXT
 
-	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
+	ALTERNATIVE(nop, MSR_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 
 	// Store the guest regs x2 and x3
 	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
-- 
2.34.1

