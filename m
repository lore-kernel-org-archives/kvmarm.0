Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21BAC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:35:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97E414B816;
	Fri, 25 Feb 2022 12:35:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PCnp6RZhW5Mi; Fri, 25 Feb 2022 12:35:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E9CD4B90F;
	Fri, 25 Feb 2022 12:35:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 308C04B816
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:35:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IP3-2mlBEvOY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:35:20 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41C2F4B92A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:35:19 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 5BD3DB832CD;
 Fri, 25 Feb 2022 17:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A071BC340F1;
 Fri, 25 Feb 2022 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810517;
 bh=xFJbO60Y87wetNKXjsBQlBwHNrwc/50YX2kYkfKn+18=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=J1yaH9IMFtaZxeSSxw7+TO2Oav+hFwUFqTZtUQ+g0KTIKgSXcurqaw+vMNUfc3j7O
 hE1mnoMhT9tRFCmaCO/N1a6/jnOv0TBSo8z9226V4nqhKDkG6S+zOAmm7g/FC+itiI
 fGOxO2jjRnBj10n1pWe7N9J6xoVNvXfjULDOTbcoi6jRpfsU+nZIW6ki0QrJ56Mj3/
 ayGE0vgt+yglT5Sg1XOMad77+Zh3CT8ADcAVm4z2oZyiiIUhEJilAuAocKwHtTPkH9
 dg/E3luewF/6ZhxUbfIu/3LNXVWY35ojpdLq3hTpoITunPlmI8jZsT58HjaL+BcZV/
 TSysM8WNHfhbg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 14/40] arm64/sme: Implement support for TPIDR2
Date: Fri, 25 Feb 2022 16:58:57 +0000
Message-Id: <20220225165923.1474372-15-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4314; h=from:subject;
 bh=xFJbO60Y87wetNKXjsBQlBwHNrwc/50YX2kYkfKn+18=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrV7c8dRRTNQiWLuBOgs3tkR3U3W9w61VRTv1Cv
 Ox4f5VOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkK1QAKCRAk1otyXVSH0OguB/
 4yLiV5dlQWxOr9AHHkNhDvp3zzqVzmi2w4d9dbzr+67kXduRHK2t+q55tIwL7bkCqTWIVfrZSls2Q+
 5hjn3ZAGbVzwAxc/hSOjA6FSvPuzRSxiX3AWnNQNYNYA3Rf5gMD/DdW9+aECJ35RGuJgfk7Qi7DKBi
 8hrAGxUP8qL0LyZYzNEfxUaMd0eiRBs4fwW60lsGuAEmBOGzKzP/d2esCtbDgF3ebNcUW38cjJri4s
 70fvZ/mBaHiq7IhTTsmAFLlKBPub6W+mqoHjiMDGQTbgnupKD8GaYXBXmEj5ajwDYHS7clZAueqcpT
 qRR5ebywMniI/LylrWlSq3FLg6+F55
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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
index 9d36035acce3..12252352d2ee 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -747,6 +747,11 @@ static __always_inline bool system_supports_fa64(void)
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
index f2c2ebd440e2..008a1767ebff 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -168,6 +168,7 @@ struct thread_struct {
 	u64			mte_ctrl;
 #endif
 	u64			sctlr_user;
+	u64			tpidr2_el0;
 };
 
 static inline unsigned int thread_get_vl(struct thread_struct *thread,
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 1edb3996f9cf..40ef89120774 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1092,6 +1092,10 @@ void sme_kernel_enable(const struct arm64_cpu_capabilities *__always_unused p)
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
index 5369e649fa79..e69a3dcdb0d9 100644
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
