Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E955C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:23:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F065410FF;
	Mon,  7 Feb 2022 10:23:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U8c+zW6Efrcy; Mon,  7 Feb 2022 10:23:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F6F49ED5;
	Mon,  7 Feb 2022 10:23:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB29649EC1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:23:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 70SQSiHEw8rU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:23:15 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 358E649EC5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:23:13 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3071CB815B4;
 Mon,  7 Feb 2022 15:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA26C340F1;
 Mon,  7 Feb 2022 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247390;
 bh=+7q3tm71SwRhuirdKp9GKi5rtB4x6+OdJkLWZ94Mc9g=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nyS53HKEuwVI4z2AM0HqNItdJKhheBjv/YJ0gAx4Mq8eg5SgoBqhlFSR4NtfRToIW
 3v6zgoyFB3mxN4D0GLUNwR6B7XVuxtFvyx20s9XLE2lLv55IDkbh7Px5fSZsYIKI/y
 QWeu/PgQlqh3tSnWAyEJd2q35Zo8Ha9EmSOaqqGw0ZJFbVVVtaIlIdVGvqKaKo4dD1
 9YJAb3wDOYXPQ1BoJL0+wQ3dtGMQyNFlgUKR5wW7TvZb+w9jO8UcW5OtQh9Q9e+ywk
 9f1NEuG7Bxq1KsBuYGT9r2g/WMaWpHzHzrg0t5yKOJUcbdn4T+FSfIGCKalIKO7uR0
 /UWVpPyTdWwKQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 01/40] arm64: Define CPACR_EL1_FPEN similarly to other
 floating point controls
Date: Mon,  7 Feb 2022 15:20:30 +0000
Message-Id: <20220207152109.197566-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1837; h=from:subject;
 bh=+7q3tm71SwRhuirdKp9GKi5rtB4x6+OdJkLWZ94Mc9g=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjFxPwduzBtzQGWnI6lrwWCEEEUoE/eJxky1JgR
 ndA8iA+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE4xQAKCRAk1otyXVSH0ESYB/
 9fL6bPm0vsCLUGpStgzAe/DVjTAO7b8MUPdbPm+5fVwJSe5sqxbir3JmfSpknyuhYWj0Bk5rr6X+bN
 HYzOxooc21L3xbpQMWD4jZg0aJEjXRu3uu7YpaJbCnMFUyYvCX5Z7tE70MJY7wln+hpe2ru/es4nfO
 TiDNONxPy6AULsDFkkx5FO8fCchgefxKGylS8MCzaUMWltTN4SoDpo35aiuF2ZLnBZjBqJoYwSjU3k
 MNzeOy52eEeciwj5Qq4tbi7qHNsCEQPV9C2gNp8VXisTtHBbvQCrLk5Wy9MtuDx1wMVOS9x3W3vfhq
 DML+d+yS9iahb1YTcM+7Ah69T2gQqn
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
