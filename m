Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B3CC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:34:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EFA14B944;
	Fri, 25 Feb 2022 12:34:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5-3nqDoD3xAE; Fri, 25 Feb 2022 12:34:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 306394B926;
	Fri, 25 Feb 2022 12:34:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04FC74B903
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:34:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fFGJKqJAOUvz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:34:28 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9159D4B8FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:34:28 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9CA40B832D0;
 Fri, 25 Feb 2022 17:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5D4C340F2;
 Fri, 25 Feb 2022 17:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810466;
 bh=1rW+DjbgDDP0eK0YLP4YBFKqDMlxMfehDYvf3EMjT2c=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bIvtluYU1PTkDcZNUe/H1Uprqz6dhVlF20NlgK+zShfTXiHAQbYfGJWSDMzreaUIG
 FZrGRqx3qRmJS9Ve0EDikrih6jfagajTBSF8y0U2mZCMGfHOowdIfF+Hz7YF0ulGro
 1ijJkJNLTBKqIphnkSvohsAqixOjujqxmKGY5xZjQ6zhnuCIWEU//jrrORkLEILrv6
 DrCu6LiW8JMyi3KCbPww82wK94Cow/FFqEPb63W8kak+6OQSDcQDMDTs2HAvCd5ciK
 cuRFRO2dZLQetp5Go+BW0D9Xn/WBjAA9eR3Z1SJnEPdGKEocEj91RYuR4UkBSqZjyp
 gE8ijw6D4Riow==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 01/40] arm64: Define CPACR_EL1_FPEN similarly to other
 floating point controls
Date: Fri, 25 Feb 2022 16:58:44 +0000
Message-Id: <20220225165923.1474372-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1890; h=from:subject;
 bh=1rW+DjbgDDP0eK0YLP4YBFKqDMlxMfehDYvf3EMjT2c=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrK3ol6n47DnZcklSUPNCUa5Toff4g6eJvMivSu
 PHqVgbqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkKygAKCRAk1otyXVSH0GviB/
 9TJE9IpJqCTfpKUsbUfMhsiSIw7ArknMUMIDzgxIEtGkNFm9mj3E1OX8HhGgEqgQCFF9J/kAShwOVS
 YONcymLELZZbsPLdOWV+Gq8rIVIfOXh2wlvyT00Zun89QeRXHCjU0O4Ko/G3ixblcO7K+6eeceiaTB
 bR40+7aWNovM0+7c49FoROWyvAzzO6StJStcCHPRXB6i1rM03/e7Qh/0/tzjJqIr66o9AGZixtHOzB
 BBoCWlxo01xQdVb0CXtvPhezrRplms+EXgN6iwkaVZSDK6c2qF1YDKn5JZIav7T/+le4iP9zvwraG1
 nZ/ZeRmypCgNUUDOyqV5Bxdhj4fPcI
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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
