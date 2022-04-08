Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAB8C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:56:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D9F04B208;
	Fri,  8 Apr 2022 07:56:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vV5pOnKuJGLc; Fri,  8 Apr 2022 07:56:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50DA14B20D;
	Fri,  8 Apr 2022 07:56:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECCF04B1C5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:56:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TlBTtJxIxGLu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:56:04 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B50EF4B11B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:56:04 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 39DAC61BFB;
 Fri,  8 Apr 2022 11:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B6EC385AE;
 Fri,  8 Apr 2022 11:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649418963;
 bh=lRDgO0P5klCwyPINIvu+rDDyfXzYCuN2RCmsKa7DGzM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ik/RqF3XCYovsghfBQ8/aj3qhA7kSCKzcBP4c1AKSBvsrC92G/m4eIuc1L/kSV+44
 GaQwEVzdD1/mruV5Bsd5edWmWWSGOY2kfDXNVvy6XEpBMhVU50YY83MqsTgy+yJR3b
 qcTwXL/kqaz0uF4IBZUKpiJuIRs8wmQGQ69lbfxUcaisyzqtR8qDsdaQEAovhpWCkK
 pQoBog0RylGjfVS6KEneoaoSDsykcox3zz5WvqhQJa4iX8KtH6xaT5W4uGE7EPXEJ4
 C4KHM9pi/hg6yPK4dPbOV4y1mBzlJqfrWCoZNprKtRzlE32jcensZDg9JFEgluRowF
 8Nu92e7lDwZYA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 12/39] arm64/sme: Implement support for TPIDR2
Date: Fri,  8 Apr 2022 12:43:01 +0100
Message-Id: <20220408114328.1401034-13-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4314; h=from:subject;
 bh=lRDgO0P5klCwyPINIvu+rDDyfXzYCuN2RCmsKa7DGzM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/IWKLTFp13H4o5XYlRQ7XnX4p/VcHDrYmN1OKY
 f3CKpgKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAfyAAKCRAk1otyXVSH0ComB/
 wKGI/Qh78Af+QCMWNBblujo0DJIjB/9089pGrz0455pe702g2TvnduCDxgavF1monOV+WCOk6LmaLs
 9aUNRYiX0T+jZeGQ4qKKoRuolpv0ledpHWTqAF2EvmlCJKj32K2w+H7fmsFf1Y906mKfhk6FSEa6SV
 TzqU/Sqsn9APabJ1pw2u6nH+iQvYq6Toy8U802wPJJKAAK24+GQdFu5VLyn60KfkFdRhNb2mbU0Pq3
 luIBjKmeePGn+NLBpHZQPrxtRrhxCoiiwwnl4qfp4L7Jsed4M6ndtzabWNAjNc3DfLm7DZMefT96kc
 fRrLCsUKf5uwz5jvF3rD4rapPVmCV6
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The Scalable Matrix Extension introduces support for a new thread specific
data register TPIDR2 intended for use by libc. The kernel must save the
value of TPIDR2 on context switch and should ensure that all new threads
start off with a default value of 0. Add a field to the thread_struct to
store TPIDR2 and context switch it with the other thread specific data.

In case there are future extensions which also use TPIDR2 we introduce
system_supports_tpidr2() and use that rather than system_supports_sme()
for TPIDR2 handling.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  5 +++++
 arch/arm64/include/asm/processor.h  |  1 +
 arch/arm64/kernel/fpsimd.c          |  4 ++++
 arch/arm64/kernel/process.c         | 14 ++++++++++++--
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 5ddfae233ea5..14a8f3d93add 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -778,6 +778,11 @@ static __always_inline bool system_supports_fa64(void)
 		cpus_have_const_cap(ARM64_SME_FA64);
 }
 
+static __always_inline bool system_supports_tpidr2(void)
+{
+	return system_supports_sme();
+}
+
 static __always_inline bool system_supports_cnp(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_CNP) &&
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 7a57cbff8a03..849e97d418a8 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -169,6 +169,7 @@ struct thread_struct {
 	u64			mte_ctrl;
 #endif
 	u64			sctlr_user;
+	u64			tpidr2_el0;
 };
 
 static inline unsigned int thread_get_vl(struct thread_struct *thread,
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 39f44fcb9b99..231f2d85b65e 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1098,6 +1098,10 @@ void sme_kernel_enable(const struct arm64_cpu_capabilities *__always_unused p)
 	/* Allow SME in kernel */
 	write_sysreg(read_sysreg(CPACR_EL1) | CPACR_EL1_SMEN_EL1EN, CPACR_EL1);
 	isb();
+
+	/* Allow EL0 to access TPIDR2 */
+	write_sysreg(read_sysreg(SCTLR_EL1) | SCTLR_ELx_ENTP2, SCTLR_EL1);
+	isb();
 }
 
 /*
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 7fa97df55e3a..e20571f19718 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -250,6 +250,8 @@ void show_regs(struct pt_regs *regs)
 static void tls_thread_flush(void)
 {
 	write_sysreg(0, tpidr_el0);
+	if (system_supports_tpidr2())
+		write_sysreg_s(0, SYS_TPIDR2_EL0);
 
 	if (is_compat_task()) {
 		current->thread.uw.tp_value = 0;
@@ -343,6 +345,8 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 		 * out-of-sync with the saved value.
 		 */
 		*task_user_tls(p) = read_sysreg(tpidr_el0);
+		if (system_supports_tpidr2())
+			p->thread.tpidr2_el0 = read_sysreg_s(SYS_TPIDR2_EL0);
 
 		if (stack_start) {
 			if (is_compat_thread(task_thread_info(p)))
@@ -353,10 +357,12 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 
 		/*
 		 * If a TLS pointer was passed to clone, use it for the new
-		 * thread.
+		 * thread.  We also reset TPIDR2 if it's in use.
 		 */
-		if (clone_flags & CLONE_SETTLS)
+		if (clone_flags & CLONE_SETTLS) {
 			p->thread.uw.tp_value = tls;
+			p->thread.tpidr2_el0 = 0;
+		}
 	} else {
 		/*
 		 * A kthread has no context to ERET to, so ensure any buggy
@@ -387,6 +393,8 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 void tls_preserve_current_state(void)
 {
 	*task_user_tls(current) = read_sysreg(tpidr_el0);
+	if (system_supports_tpidr2() && !is_compat_task())
+		current->thread.tpidr2_el0 = read_sysreg_s(SYS_TPIDR2_EL0);
 }
 
 static void tls_thread_switch(struct task_struct *next)
@@ -399,6 +407,8 @@ static void tls_thread_switch(struct task_struct *next)
 		write_sysreg(0, tpidrro_el0);
 
 	write_sysreg(*task_user_tls(next), tpidr_el0);
+	if (system_supports_tpidr2())
+		write_sysreg_s(next->thread.tpidr2_el0, SYS_TPIDR2_EL0);
 }
 
 /*
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
