Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A24C3526D
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:11:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A21D543C96;
	Wed, 26 Jan 2022 10:11:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uoiu1S5XKWoN; Wed, 26 Jan 2022 10:11:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E12DF40DF3;
	Wed, 26 Jan 2022 10:11:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00A4040D26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:11:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AYSPoQ3q42dV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:11:39 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABEF640E25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:11:39 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0702E61446;
 Wed, 26 Jan 2022 15:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06494C340ED;
 Wed, 26 Jan 2022 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643209898;
 bh=+7q3tm71SwRhuirdKp9GKi5rtB4x6+OdJkLWZ94Mc9g=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OywQjmwQgTzKX8O6GeH1KqcaMIOCny0KQU/4YUO8gwDpb3//7lmJLvV/8NLJxV/q5
 ag9+7/0aK1PPQwQw+Xq5D3OIi0jayb5fFonsoW9TtKo/tHy0PHC84gjC8a5UF/iORH
 peXlJIRyplOrMvBxXtxhEwAbWmeBidhr8RQ78zp98mqiXIUrNFELnlMNOjVNAsv6LK
 E41M8/VVfejSHCcSa1MH3OVBUr9CCbMoMMtRooBLAu/P7THDu+abw7NUcGqK+M6SFF
 6mRyOWhpu9uU4MDvWd5OtgwH2vvqUcEL1LpnbYyo0OdVvjNM3iSbKd7rmAqg0OnHUu
 c+LxKL/lmEy3A==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v9 01/40] arm64: Define CPACR_EL1_FPEN similarly to other
 floating point controls
Date: Wed, 26 Jan 2022 15:10:41 +0000
Message-Id: <20220126151120.3811248-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126151120.3811248-1-broonie@kernel.org>
References: <20220126151120.3811248-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1837; h=from:subject;
 bh=+7q3tm71SwRhuirdKp9GKi5rtB4x6+OdJkLWZ94Mc9g=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh8WR3xPwduzBtzQGWnI6lrwWCEEEUoE/eJxky1JgR
 ndA8iA+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYfFkdwAKCRAk1otyXVSH0LCAB/
 9hezGWJNPKVa612fhSfevbONlcnfaUMTl86av0wM0s6308x6oajAf81Y0krzoEEzYQ6LtwIqlvaT5G
 TVORg0iXIwCt6P03caZZHkg/yvIkng+f3Q6qh47RfwAwupJ9RHJ/X2q/EzCupSUuGXsys7xMPR626y
 BVvloXlj2N4k+zV34hFoplm30F2R41jfmi98W/4P+7UhpnUwOTGQhz/annLIEjw0T10PfEYCdCC3Jx
 TiA3Y87NdWakX1vv8TLwSnA+A/O9pr9Yb5uAaoZ88oIaBiXpDEbKeLaGc82T7pg+Bo9pUhhlVdvxdA
 Cb+iwT+PxVC2ctv+BMdVomSyoSHIk9
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

The base floating point, SVE and SME all have enable controls for EL0 and
EL1 in CPACR_EL1 which have a similar layout and function. Currently the
basic floating point enable FPEN is defined differently to the SVE control,
specified as a single define in kvm_arm.h rather than in sysreg.h. Move the
define to sysreg.h and provide separate EL0 and EL1 control bits so code
managing the different floating point enables can look consistent.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 1 -
 arch/arm64/include/asm/sysreg.h  | 4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 01d47c5886dc..eec790842fe2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -355,7 +355,6 @@
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
 	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
 
-#define CPACR_EL1_FPEN		(3 << 20)
 #define CPACR_EL1_TTA		(1 << 28)
 #define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN | CPACR_EL1_ZEN_EL1EN)
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 898bee0004ae..1da4c43d597d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1097,6 +1097,10 @@
 #define ZCR_ELx_LEN_SIZE	9
 #define ZCR_ELx_LEN_MASK	0x1ff
 
+#define CPACR_EL1_FPEN_EL1EN	(BIT(20)) /* enable EL1 access */
+#define CPACR_EL1_FPEN_EL0EN	(BIT(21)) /* enable EL0 access, if EL1EN set */
+#define CPACR_EL1_FPEN		(CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN)
+
 #define CPACR_EL1_ZEN_EL1EN	(BIT(16)) /* enable EL1 access */
 #define CPACR_EL1_ZEN_EL0EN	(BIT(17)) /* enable EL0 access, if EL1EN set */
 #define CPACR_EL1_ZEN		(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
