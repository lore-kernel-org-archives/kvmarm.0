Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77136C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 11:24:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BEF64078F;
	Tue, 19 Apr 2022 07:24:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5EjZ7HkhMXoC; Tue, 19 Apr 2022 07:24:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 064E649AFD;
	Tue, 19 Apr 2022 07:24:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D4C43C96
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:24:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kStEvNS4ucaW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 07:24:10 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C0684B190
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:24:10 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 61A43B8185D;
 Tue, 19 Apr 2022 11:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13280C385AD;
 Tue, 19 Apr 2022 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650367448;
 bh=e1FepHYyPDtYPxnE8RM2o5Ez5kqchRRRHTdF7jTJt0I=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=mM+gE/86Q+945YmfwZyzVp+MctGmqZGtqmmQ3IwgrEpja2w9dMsqlbCUF03D8Lp1C
 QVDShJoxGBK8QeOgd5QcNSVAoJ1+W4KJVTeaUfzzJM6ILvO4LBG+mSafDsXws5ldJb
 SKiLzwq+wgjH9wtyt6zA7DXBwKopEUGnE66Qt40SdhhWV8vAJoS8HecCswGSRhEbXw
 nym5IhFz6c+zNMGruOb/UH9cSX1lj+I6yT3/zZiN+DcPi214salibLEYZM4zYcSNMH
 JJApfRB5OBD1Cvgbp2aSM2ktVECK6Vclf/K3jkVwGp31OHihH5DmBa95SJ249VI6j1
 DP1vOwlSc1ORQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v14 10/39] arm64/sme: Implement sysctl to set the default
 vector length
Date: Tue, 19 Apr 2022 12:22:18 +0100
Message-Id: <20220419112247.711548-11-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1729; h=from:subject;
 bh=e1FepHYyPDtYPxnE8RM2o5Ez5kqchRRRHTdF7jTJt0I=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiXptvfNVOkYK9UDaZYdTcEoExO5R2QeomzfAMIOf2
 YYjoNkeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYl6bbwAKCRAk1otyXVSH0N64B/
 9GHiPt8w0MHlQx7BaX+GNanbWqTfMm6o5wbv/LNlBfjmdTfFpv4rONHYTwzHb9AFW42hjqF1l85OMI
 TnGNLblgr9TyDY7JESr0P7BHuSwY0d5JCqLQLXcSAr2oWtvI0sYlMsY76PgDq/6j+8E2GsHc5F4FO8
 YR8aXzQxjqi7NV7fl91iRe9HS2xvSeDXcrvHVMPcGAtH1IvWIOUh8cCsmhzWQnDvcHGOPNBM6LBzuq
 G8J18Jz7LZTEL0x8A+IO3WvowFt8X6jNRIC4p3K/GzTXu3UMzIEdm3GlJzaz9FGmbU7AkgNTJB+YYb
 rkc6HxhueNkCqIIff8cvj+WNHOfgQ+
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

As for SVE provide a sysctl which allows the default SME vector length to
be configured.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5e5fbd9cba75..754a96563f6f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -489,6 +489,30 @@ static int __init sve_sysctl_init(void)
 static int __init sve_sysctl_init(void) { return 0; }
 #endif /* ! (CONFIG_ARM64_SVE && CONFIG_SYSCTL) */
 
+#if defined(CONFIG_ARM64_SME) && defined(CONFIG_SYSCTL)
+static struct ctl_table sme_default_vl_table[] = {
+	{
+		.procname	= "sme_default_vector_length",
+		.mode		= 0644,
+		.proc_handler	= vec_proc_do_default_vl,
+		.extra1		= &vl_info[ARM64_VEC_SME],
+	},
+	{ }
+};
+
+static int __init sme_sysctl_init(void)
+{
+	if (system_supports_sme())
+		if (!register_sysctl("abi", sme_default_vl_table))
+			return -EINVAL;
+
+	return 0;
+}
+
+#else /* ! (CONFIG_ARM64_SME && CONFIG_SYSCTL) */
+static int __init sme_sysctl_init(void) { return 0; }
+#endif /* ! (CONFIG_ARM64_SME && CONFIG_SYSCTL) */
+
 #define ZREG(sve_state, vq, n) ((char *)(sve_state) +		\
 	(SVE_SIG_ZREG_OFFSET(vq, n) - SVE_SIG_REGS_OFFSET))
 
@@ -1687,6 +1711,9 @@ static int __init fpsimd_init(void)
 	if (cpu_have_named_feature(SME) && !cpu_have_named_feature(SVE))
 		pr_notice("SME is implemented but not SVE\n");
 
-	return sve_sysctl_init();
+	sve_sysctl_init();
+	sme_sysctl_init();
+
+	return 0;
 }
 core_initcall(fpsimd_init);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
