Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEB8C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 00:15:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5BA84086C;
	Mon, 24 Jan 2022 19:15:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 88tvYzIfXSiI; Mon, 24 Jan 2022 19:15:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD52949E21;
	Mon, 24 Jan 2022 19:15:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EBFC4086C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:15:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bqe-yilhCihg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 19:15:34 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB6D849DF6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:15:33 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id EED5FB811A3;
 Tue, 25 Jan 2022 00:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59995C340E7;
 Tue, 25 Jan 2022 00:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643069730;
 bh=3sonF+yHE0fhlKD09DOEsXzDPxYrP95z6ruAnvpEJGM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=MeUL/uRg+N8qGiQYYtiPz7kCxVupfk7Z6X0zH+TBJd4qidU6s1HGk0lDqGTNQzxRI
 Riw7e0nHlM9zKocG7QHaMZAyKWLWnS4mSHIfZiu6eCYP1byNJSlxDmxP0YaVLB1JLf
 XG1zmq2DBQVWuSaQsYE9w7EKIHDoF+9sFxq+O3vwSL5+1ge80AnzodOTBgaWRdZYQs
 99SCiivx2Adel+QgiipPszfOxSE7Zwbpq+KkXEu70AYWZl1aGAtwHni7SrY44yOGgS
 HSXIQjsrTOeFZ28TEA3lcn7H93P9DmXgLRH6LkDrxL5vdt0rbkdqesYqwmQ6CmC5Zd
 ZYp4HDqS3OH+Q==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v8 02/38] arm64: Add feature detection for fine grained traps
Date: Tue, 25 Jan 2022 00:10:38 +0000
Message-Id: <20220125001114.193425-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125001114.193425-1-broonie@kernel.org>
References: <20220125001114.193425-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1329; h=from:subject;
 bh=3sonF+yHE0fhlKD09DOEsXzDPxYrP95z6ruAnvpEJGM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh70AC//2QjAgtLKpaHN3VkL1TidYgxM2zCB5+nShw
 WJsna3aJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe9AAgAKCRAk1otyXVSH0NSMB/
 91vAjavGUrRIbSfB7NNYbejpWkY43ECBQHx+Kx1eooW4hgntBfKG6S182Oc689gzr7dhXdILY5I0C1
 yYWTnJapu/KZnD18q178dDoijFOdHG33jOlPcEnU0CfCqE9wluRB+nYui6wjjngrg+g/99yXxYajuC
 I3B+Acl1NfSoEHYwcrr6PPWp5zqIUN3ZEufYMH9KIm3mBMpRL62QkWxZkD2dQ3+mYSBbkYR+vpcAmo
 N/6l1DM9/PgLIQsyLAtSx+lW6FrgwrXhjavAFeam0K4ocvtNnHbM1q7AR6aJQ1r7l2mWprhv/9VDpI
 /njnDCAr0h4TkbOE7RB/RPcX3ZX6Il
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

Some of the traps for nVHE SME support are provided as fine grained traps
so add detection of fine grained traps in order to allow us to guard usage.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 11 +++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d9f09e40aaf6..ec060db1dcf0 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2400,6 +2400,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Fine Grained Traps",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_FGT,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR0_FGT_SHIFT,
+		.field_width = 4,
+		.min_field_value = 1,
+		.matches = has_cpuid_feature,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 870c39537dd0..b3ada80aa48d 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -20,6 +20,7 @@ HAS_DCPOP
 HAS_E0PD
 HAS_ECV
 HAS_EPAN
+HAS_FGT
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH
 HAS_GENERIC_AUTH_IMP_DEF
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
