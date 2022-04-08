Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AF0C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:56:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12B714B21A;
	Fri,  8 Apr 2022 07:56:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ME0XUDxpMhR; Fri,  8 Apr 2022 07:56:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 021CF4B1E0;
	Fri,  8 Apr 2022 07:56:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C13F24B159
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:55:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HVYYa3r4EntE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:55:56 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A87149EDF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:55:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D3D7C61BFB;
 Fri,  8 Apr 2022 11:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7D0C385AB;
 Fri,  8 Apr 2022 11:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649418955;
 bh=e1FepHYyPDtYPxnE8RM2o5Ez5kqchRRRHTdF7jTJt0I=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EJuOOJNlQmWW7AOqkCe8rXHBe2sHVh2sMn8EPUCtg0PERV6JL0OvlOJaEL/IoiuPH
 Ya1rA/X5R7dNGSzbzYO0yW+mzM3ikVelvdoqwqY/+0w62bKr3+FB/3LK7F+q0i+9Sx
 VNPfMKb/5kYyqZd1WzSd9KneIlu8TiXe0PzM/gmw7ioVMCgwy5KyLHDTblRb4s2/6n
 BkZG42eJhLi+7jOFUCTiVWWRrzK6yKrHwBhqTuEhU30Mtz7j8pfCxzKVigRbWzgral
 t0IxmRUSP6CuLlLp+gs/Nys9qdtqekt6fcf/CbsZwD+J4GKdCu4r4Tj8iSRypVzexI
 v/J/QnCvv7ZwQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 10/39] arm64/sme: Implement sysctl to set the default
 vector length
Date: Fri,  8 Apr 2022 12:42:59 +0100
Message-Id: <20220408114328.1401034-11-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1729; h=from:subject;
 bh=e1FepHYyPDtYPxnE8RM2o5Ez5kqchRRRHTdF7jTJt0I=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/HfNVOkYK9UDaZYdTcEoExO5R2QeomzfAMIOf2
 YYjoNkeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAfxwAKCRAk1otyXVSH0Nw9B/
 9KbxxwlOlP/quQ4bhW9MWa+r94EK45MCgb3CEEdqU0O5rMg3OSLB1JDcm0ZdYiKHkraHuy+P+pOcgZ
 9vabyuqmOdp1oa51OX5Fo9bm2o+4mVzFmV4A+vagmqOUS0pkZ9BSJbbpmXT/zl3SNq1PKppuPIyTO2
 HYW8cpxGJrNCgqDAbh+jep8MvOr0Kv69FTr4hYHoA9nr2au4EOgBw2nXr9j9P4Om6V2WLZKTWId6VA
 +50WUAWh1uOd2GiXqmokOnj7klUZ7ez1SgDjaHozB/V9CG28dAF09s2LyZbxJjhQ0HgCfqxgyRxHxL
 PXjTxOQFUnk+tm5EyLi3PqZSsbgl4q
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
