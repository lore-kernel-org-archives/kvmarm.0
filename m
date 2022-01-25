Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E30C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 00:16:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A012149B12;
	Mon, 24 Jan 2022 19:16:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GMTYDmLndD4O; Mon, 24 Jan 2022 19:16:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9FFF49DFF;
	Mon, 24 Jan 2022 19:16:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E481140B85
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:16:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2SiiWYmE6Von for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 19:16:03 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C86BA49AFD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:16:03 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E0243B815E0;
 Tue, 25 Jan 2022 00:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40610C340E7;
 Tue, 25 Jan 2022 00:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643069761;
 bh=IpbUE1LUP1+wV97Or602iA0h2YoCGBZmK9vzxYxrIfM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=HNsyHz3XIn0qik+Ak/q4XnAvFlyTxR5cjgufRYPmTd4QCAqfUPUgF9oYHPUkZFeIG
 bQXmXw0whHb8rB3MJVg809nNzkRUJxLepSWkow0WJm8afUFe5JDuhK6iZw0YGUMOBj
 OmXw7IvX1+wjXMD+Y1hUX8cn5YCpn9KeVCCUzNynJgLDfoLJWh+VpmHYWfBpcc2ljC
 0I2xMTGncc0irZBJ4PuvEP35N1wK1KbaH5LQuKdDCDXhvJBHftQBZjnh0Njp1Kle3S
 Q6Tof9/Sdw4nM5yGVu5f0yXpf+FZHtDiJYBciID9U+u3Y08uQTIJz+xQSPhbAghZ1E
 q1t8Ze0vlkMXA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v8 10/38] arm64/sme: Implement sysctl to set the default
 vector length
Date: Tue, 25 Jan 2022 00:10:46 +0000
Message-Id: <20220125001114.193425-11-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125001114.193425-1-broonie@kernel.org>
References: <20220125001114.193425-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1673; h=from:subject;
 bh=IpbUE1LUP1+wV97Or602iA0h2YoCGBZmK9vzxYxrIfM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh70AJFgJn/lc8qyFbpsUtXlg3lgi4N72n7+sKm+k1
 dP+cSUGJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe9ACQAKCRAk1otyXVSH0LmcB/
 0XEndfFhFnPc9ukDndbHEkcdsYuIuaO9EE8pTzRCW8uq/WSN69mXCJdyu5YSm2wcgfPgwwKovZuGGg
 dmBTQ9Vtb7QEU3nAnRTNP47CH6yZ2tTnHZ4KUdDRiLJxhhOiZkUFpygLIr/uTDthfBvV5eAQi/gcEw
 B5q9bhVjxk+lp/ippXXOd4FQv4W16Hgngmiz+/XGaT3DP5nZ++BWSHnqiWoZd4tewFl7YBSTJB5vOJ
 UAF8MeMEbDmeRMBBgAVOyDDvheAC6yu7z0OHtVbJor62zqu1Iiu6/nqYHyYzoe9mWRedauX4rAqPHt
 nMwkABpNBbWjPH3p5/XY3sILfvxakv
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
