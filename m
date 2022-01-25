Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE215C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 00:16:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D2F49E3F;
	Mon, 24 Jan 2022 19:16:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LglSmdxj9V6O; Mon, 24 Jan 2022 19:16:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5B349E39;
	Mon, 24 Jan 2022 19:16:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 280E540DCB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:16:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8dl4m66CBKrE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 19:16:07 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8012240E64
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:16:06 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0CBF26134C;
 Tue, 25 Jan 2022 00:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF67C340EC;
 Tue, 25 Jan 2022 00:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643069765;
 bh=B/urqBimz+3K4ZCFBMO8EnKA3FRn7rrK3YpjvULX0fM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=DA0KP9wDrNiZYESl7IwDEx68Jqln/FfR68/Rswco0oYrt1cQLs46LqRu2BXq/SQLc
 +kEY5f1n4bDlfY2VkTtas84Mk6IQjUjpWNMPjogdrUnq3QnLm4U0+rY0oZp5IDKUDq
 lgOiFgiCsk5JAlLRVROxXWDKqnhwCUy3h/xLgjr9dxyoVyYWDvwUA9fmBhLQOiN4bH
 SZQLHE7c9+a8+ldXE6pj4bA34eM1ExJ984Nc+GksjV30YJShXcl/g7ZBm8GHZy1XvG
 ABXkVpyE4xn28eCE01XnejP44gZSSaTRTw7JTfe2bOtV0kPeMsOszZs/mH5gQfBlti
 WIpIbeaPykTlQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v8 11/38] arm64/sme: Implement vector length configuration
 prctl()s
Date: Tue, 25 Jan 2022 00:10:47 +0000
Message-Id: <20220125001114.193425-12-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125001114.193425-1-broonie@kernel.org>
References: <20220125001114.193425-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5677; h=from:subject;
 bh=B/urqBimz+3K4ZCFBMO8EnKA3FRn7rrK3YpjvULX0fM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh70AJ2XcqhBFxXZp1c4U9xXBU+g+VgJg0PVXp8ovU
 QJ6u6QyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe9ACQAKCRAk1otyXVSH0DJsB/
 9Sl5XPexaBQMciqUHFmgjjVEUFQ4+WCR/hJkTFgDx5y5HvHKrs4ibfig0jIs5U8OCdsNMayGEdK+x4
 11W9CnunGUCOlGBAnTSnlxPh3yQ9lZWHXAkueiJvl/8sRNdTLhruKLKSJGrcgRAxsUd7ClZeGmOTf4
 90JnXZ9Za++HzKMcqy0MXb7lk6MKonvtf/DeNAGyuIXzfcD5KBM4RQNgHYUH+0jbb419D+JL4o4WPq
 16N/Az4vJCXRV1TM6iRBFyuXzCh0J2v05xcTFkUs7EYBikdB7kdvNQbxrgHuwu7CrpbXurLPrpKfju
 Uxiq5x9GizFxfc9GcINUbsH1ZMvUGj
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

As for SVE provide a prctl() interface which allows processes to
configure their SME vector length.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h      |  4 ++++
 arch/arm64/include/asm/processor.h   |  4 +++-
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/fpsimd.c           | 32 ++++++++++++++++++++++++++++
 include/uapi/linux/prctl.h           |  9 ++++++++
 kernel/sys.c                         | 12 +++++++++++
 6 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 8cb99b6fe565..babf944e7c0c 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -288,6 +288,8 @@ static inline int sme_max_virtualisable_vl(void)
 }
 
 extern unsigned int sme_get_vl(void);
+extern int sme_set_current_vl(unsigned long arg);
+extern int sme_get_current_vl(void);
 
 #else
 
@@ -299,6 +301,8 @@ static inline void sme_setup(void) { }
 static inline unsigned int sme_get_vl(void) { return 0; }
 static inline int sme_max_vl(void) { return 0; }
 static inline int sme_max_virtualisable_vl(void) { return 0; }
+static inline int sme_set_current_vl(unsigned long arg) { return -EINVAL; }
+static inline int sme_get_current_vl(void) { return -EINVAL; }
 
 #endif /* ! CONFIG_ARM64_SME */
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index df68f0fb0ded..f2c2ebd440e2 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -354,9 +354,11 @@ extern void __init minsigstksz_setup(void);
  */
 #include <asm/fpsimd.h>
 
-/* Userspace interface for PR_SVE_{SET,GET}_VL prctl()s: */
+/* Userspace interface for PR_S[MV]E_{SET,GET}_VL prctl()s: */
 #define SVE_SET_VL(arg)	sve_set_current_vl(arg)
 #define SVE_GET_VL()	sve_get_current_vl()
+#define SME_SET_VL(arg)	sme_set_current_vl(arg)
+#define SME_GET_VL()	sme_get_current_vl()
 
 /* PR_PAC_RESET_KEYS prctl */
 #define PAC_RESET_KEYS(tsk, arg)	ptrauth_prctl_reset_keys(tsk, arg)
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index e1317b7c4525..4e6b58dcd6f9 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -82,6 +82,7 @@ int arch_dup_task_struct(struct task_struct *dst,
 #define TIF_SVE_VL_INHERIT	24	/* Inherit SVE vl_onexec across exec */
 #define TIF_SSBD		25	/* Wants SSB mitigation */
 #define TIF_TAGGED_ADDR		26	/* Allow tagged user addresses */
+#define TIF_SME_VL_INHERIT	28	/* Inherit SME vl_onexec across exec */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 841b9609342f..1edb3996f9cf 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -149,6 +149,8 @@ static unsigned int vec_vl_inherit_flag(enum vec_type type)
 	switch (type) {
 	case ARM64_VEC_SVE:
 		return TIF_SVE_VL_INHERIT;
+	case ARM64_VEC_SME:
+		return TIF_SME_VL_INHERIT;
 	default:
 		WARN_ON_ONCE(1);
 		return 0;
@@ -801,6 +803,36 @@ int sve_get_current_vl(void)
 	return vec_prctl_status(ARM64_VEC_SVE, 0);
 }
 
+#ifdef CONFIG_ARM64_SME
+/* PR_SME_SET_VL */
+int sme_set_current_vl(unsigned long arg)
+{
+	unsigned long vl, flags;
+	int ret;
+
+	vl = arg & PR_SME_VL_LEN_MASK;
+	flags = arg & ~vl;
+
+	if (!system_supports_sme() || is_compat_task())
+		return -EINVAL;
+
+	ret = vec_set_vector_length(current, ARM64_VEC_SME, vl, flags);
+	if (ret)
+		return ret;
+
+	return vec_prctl_status(ARM64_VEC_SME, flags);
+}
+
+/* PR_SME_GET_VL */
+int sme_get_current_vl(void)
+{
+	if (!system_supports_sme() || is_compat_task())
+		return -EINVAL;
+
+	return vec_prctl_status(ARM64_VEC_SME, 0);
+}
+#endif /* CONFIG_ARM64_SME */
+
 static void vec_probe_vqs(struct vl_info *info,
 			  DECLARE_BITMAP(map, SVE_VQ_MAX))
 {
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index e998764f0262..a5e06dcbba13 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -272,6 +272,15 @@ struct prctl_mm_map {
 # define PR_SCHED_CORE_SCOPE_THREAD_GROUP	1
 # define PR_SCHED_CORE_SCOPE_PROCESS_GROUP	2
 
+/* arm64 Scalable Matrix Extension controls */
+/* Flag values must be in sync with SVE versions */
+#define PR_SME_SET_VL			63	/* set task vector length */
+# define PR_SME_SET_VL_ONEXEC		(1 << 18) /* defer effect until exec */
+#define PR_SME_GET_VL			64	/* get task vector length */
+/* Bits common to PR_SME_SET_VL and PR_SME_GET_VL */
+# define PR_SME_VL_LEN_MASK		0xffff
+# define PR_SME_VL_INHERIT		(1 << 17) /* inherit across exec */
+
 #define PR_SET_VMA		0x53564d41
 # define PR_SET_VMA_ANON_NAME		0
 
diff --git a/kernel/sys.c b/kernel/sys.c
index ecc4cf019242..5cd4fffc7cd0 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -116,6 +116,12 @@
 #ifndef SVE_GET_VL
 # define SVE_GET_VL()		(-EINVAL)
 #endif
+#ifndef SME_SET_VL
+# define SME_SET_VL(a)		(-EINVAL)
+#endif
+#ifndef SME_GET_VL
+# define SME_GET_VL()		(-EINVAL)
+#endif
 #ifndef PAC_RESET_KEYS
 # define PAC_RESET_KEYS(a, b)	(-EINVAL)
 #endif
@@ -2523,6 +2529,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_SVE_GET_VL:
 		error = SVE_GET_VL();
 		break;
+	case PR_SME_SET_VL:
+		error = SME_SET_VL(arg2);
+		break;
+	case PR_SME_GET_VL:
+		error = SME_GET_VL();
+		break;
 	case PR_GET_SPECULATION_CTRL:
 		if (arg3 || arg4 || arg5)
 			return -EINVAL;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
