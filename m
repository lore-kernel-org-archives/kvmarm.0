Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD88C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:35:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE0BF4B904;
	Fri, 25 Feb 2022 12:35:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ajf56erU-Cn1; Fri, 25 Feb 2022 12:35:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16A534B9B5;
	Fri, 25 Feb 2022 12:35:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A40E64B85C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:35:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X5oGstxwsD-X for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:35:10 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 595304B8BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:35:10 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DCC4361DC3;
 Fri, 25 Feb 2022 17:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC84BC36AE9;
 Fri, 25 Feb 2022 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810509;
 bh=63WLTNdGExIQX5YPFJnvYTPc1abM1BlKePo1Mbbun/I=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=D+iJEWBIi8sCmDeS5J278O/Pkge9XmVD8wITXNtIuUxcNq2U04MMRfz8VQ449c6LM
 Ldu4KARrDkcLTutZjh3hxbYme2BcI49TqCGPScXjdie1QPK9BqMVtH0m39S+xZY2Jl
 +L0IVcpG/nwKG80qg7DqA9eQoWD0r1Yor1HNIyiHxL9LDksDJrDePOg9HhozMCsHZl
 9pT50VZ4nnRRMjsh84E8Uy4odocWpG+tySYC6ViJYo1aesqZqHWEYcbSTTHF9k8tc8
 3MPobV65b1dJhh3cK/W+zvjvrdrQSjTv1neSgMA9kl7Ce8B8tw+5xa21B8ig5/smTh
 4VlR+w8wxQOjg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 12/40] arm64/sme: Implement sysctl to set the default
 vector length
Date: Fri, 25 Feb 2022 16:58:55 +0000
Message-Id: <20220225165923.1474372-13-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1729; h=from:subject;
 bh=63WLTNdGExIQX5YPFJnvYTPc1abM1BlKePo1Mbbun/I=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrTjC8hD1eoKysYwTLKxyL2XncHCPgcwYLEKW4S
 gOXSpayJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkK0wAKCRAk1otyXVSH0GzPB/
 4wjaEoCOe68KBlmFOAMhqptA1bjr6CrO/cxWyrR6QPMOi6rTkdKS/q9kJzmUIXcqX56ydgjCdi5yFb
 kF8g4xdVbNd/hRyBqQLjtA0RBobaMEcnNQn5m2LHHLAhioFZECYqSURnVVxNgLXCsKhVrDJDGq3a32
 XqKP/aEaX3VKZGBIxBi/Xn/0o8tprjJXYS8YTNtKS+77JPv6rWwCLZ/rNXf6fYlcc4OdvbBNw+kMQu
 cgMGb2XqbvU6klzgH7PX0mP5CN4NNwQMUH+7UO/0iF0ZDZyHdQL1ao2tQ20zhUTPq6frrIGVTQHiXe
 TQ9rtAMexasoJatT2z6/iLJLQmn7id
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

As for SVE provide a sysctl which allows the default SME vector length to
be configured.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 3fb2167f8af7..841b9609342f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -483,6 +483,30 @@ static int __init sve_sysctl_init(void)
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
 
@@ -1681,6 +1705,9 @@ static int __init fpsimd_init(void)
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
