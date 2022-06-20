Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B02C43334
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:42:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBFFA4B2B4;
	Mon, 20 Jun 2022 08:42:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 44RTGvjZDhDw; Mon, 20 Jun 2022 08:42:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B71334B297;
	Mon, 20 Jun 2022 08:42:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8522A4B309
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N9T1gwXHyP2J for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:42:36 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2DB1E4B2E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:36 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6108EB81145;
 Mon, 20 Jun 2022 12:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA372C341CA;
 Mon, 20 Jun 2022 12:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655728954;
 bh=Rw9wVvsE2kpCeEUGQn68+uLCTU5z1rcjDq4JHU6LKc8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eNeq0kkEYH7TJZ8zLKlj/a2/+Ev28Y6oEcKJ3euNTRIb8jBtI5gbsRAlkotXsQbVo
 gqYf28AmR9C5lkiTBgUgD5Gq6hAsGNBWU87yYKh2KepGg5vlDA4UfcsX6neevSxV53
 RmdX2zXdydbwxr3yMxt3w4LNOAQR4PTNQu9u+juMJnWtuJqrnVXgaXDBnV6sob4HrT
 kQ77mM7xk+b2arYqIAB8hxo7sjqsdlrnJOc4GGsUBUMK17VaX7ZaJe767Y1vLjbpnR
 2AjMkFqr7ouFkYApJmJMO25SaH0OxnY3weaxv9GM6R5mk4EgwBPhSSwO3lH4qd3dhX
 hxd6nK6H2f9rw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 7/7] arm64/sve: Don't zero non-FPSIMD register state on
 syscall by default
Date: Mon, 20 Jun 2022 13:41:58 +0100
Message-Id: <20220620124158.482039-8-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620124158.482039-1-broonie@kernel.org>
References: <20220620124158.482039-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3184; h=from:subject;
 bh=Rw9wVvsE2kpCeEUGQn68+uLCTU5z1rcjDq4JHU6LKc8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBisGsT4RK6r29PFf8FCFRiWLw1veVNB9BYLpWoPWa/
 TWKTdZGJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYrBrEwAKCRAk1otyXVSH0ESiB/
 9xeFdwFiH9gRYkxu07cLT5mgKi5ZAtPpi+q4uAq6XruvjbrCOaSbNf52MCX4IeLeUZNjnlgbpw9z39
 9gj1u99giEY99RxOFs8SCe0owKV0kcb8G8EcXyqDNZXtXJv2SJzuVt49EvpPdXMgwRg+gY29hx2zDe
 JOBZjDx8huAz54mi0vOn8KMyup2jnd5hf3b8SfGmwaMQYYTJSMXMm0R/6Y5bTTJ/5jYijRrFFEs8fQ
 d0zZYj4Jhz72TxmhDi0MtGyMehAbHa295alZzWPqGK524a9mrZPXo4ad62TDC5CPhLK+BpTOd12jun
 0RVDbs/1LIs1Wdjr/8+L6uKyddM8Pf
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Mark Brown <broonie@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The documented syscall ABI specifies that the SVE state not shared with
FPSIMD is undefined after a syscall. Currently we implement this by
always flushing this register state to zero, ensuring consistent
behaviour but introducing some overhead in the case where we can return
directly to userspace without otherwise needing to update the register
state. Take advantage of the flexibility offered by the documented ABI
and instead leave the SVE registers untouched in the case where can
return directly to userspace.

Since this is a user visible change a new sysctl abi.sve_syscall_clear_regs
is provided which will restore the current behaviour of flushing the
unshared register state unconditionally when enabled. This can be
enabled for testing or to work around problems with applications that
have been relying on the current flushing behaviour.

The sysctl is disabled by default since it is anticipated that the risk
of disruption to userspace is low. As well as being within the
documented ABI this new behaviour mirrors the standard function call ABI
for SVE in the AAPCS which should mean that compiler generated code is
unlikely to rely on the current behaviour, the main risk is from hand
coded assembly which directly invokes syscalls. The new behaviour is
also what is currently implemented by qemu user mode emulation.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/syscall.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 69b4c06f2e39..29ef3d65cf12 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -158,6 +158,40 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	syscall_trace_exit(regs);
 }
 
+
+static unsigned int sve_syscall_regs_clear;
+
+#ifdef CONFIG_ARM64_SVE
+/*
+ * Global sysctl to control if we force the SVE register state not
+ * shared with FPSIMD to be cleared on every syscall. If this is not
+ * enabled then we will leave the state unchanged unless we need to
+ * reload from memory (eg, after a context switch).
+ */
+
+static struct ctl_table sve_syscall_sysctl_table[] = {
+	{
+		.procname	= "sve_syscall_clear_regs",
+		.mode		= 0644,
+		.data		= &sve_syscall_regs_clear,
+		.maxlen		= sizeof(int),
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{ }
+};
+
+static int __init sve_syscall_sysctl_init(void)
+{
+	if (!register_sysctl("abi", sve_syscall_sysctl_table))
+		return -EINVAL;
+	return 0;
+}
+
+core_initcall(sve_syscall_sysctl_init);
+#endif	/* CONFIG_ARM64_SVE */
+
 /*
  * As per the ABI exit SME streaming mode and clear the SVE state not
  * shared with FPSIMD on syscall entry.
@@ -183,7 +217,7 @@ static inline void fp_user_discard(void)
 	if (!system_supports_sve())
 		return;
 
-	if (test_thread_flag(TIF_SVE)) {
+	if (sve_syscall_regs_clear && test_thread_flag(TIF_SVE)) {
 		unsigned int sve_vq_minus_one;
 
 		sve_vq_minus_one = sve_vq_from_vl(task_get_sve_vl(current)) - 1;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
