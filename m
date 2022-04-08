Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131ABC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:55:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FB0F49ED2;
	Fri,  8 Apr 2022 07:55:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w1+1KSBOHXYK; Fri,  8 Apr 2022 07:55:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9144B0E6;
	Fri,  8 Apr 2022 07:55:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C37AE49F1F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:55:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4s8KYlgxVTEx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:55:20 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A711849F17
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:55:20 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 05C3561FB9;
 Fri,  8 Apr 2022 11:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0003C385A3;
 Fri,  8 Apr 2022 11:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649418919;
 bh=8vVvI2qZ+WS2PpGgoEgf6Xhiefrm6qpFKgw1EK5Sp1U=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PamkjOArE7Hjmvtu1JTEDwf5RctFxUkbu8fG1c7cs/NzCdzncx6jYmbKz0oNq/bMQ
 l3Y25/bJVvl67JKoYpsAQyH2uEtuavVKLUbuzXmD272ktYqLBDZve+s+vkJerMhz+b
 uRqrhhsaG4sx7PV3qPR1fa3BeU9LcOae4vNd6eeKH+uF3LmisJeBnqcexjovdkzUKe
 azQwHReylglhcG3kDutxDmwbzQiOtkxKYF+1N2tG9CI6gEXogLpbcKksVT64fIL5cV
 a+Kv0w6qmXUGGn3sHyYiGdB3GtOiPAl/UQIgJMsXuU+hu+A755bGZ/xusLv1lTJqkZ
 HVHlpr1TErJXw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 01/39] kselftest/arm64: Fix comment for
 ptrace_sve_get_fpsimd_data()
Date: Fri,  8 Apr 2022 12:42:50 +0100
Message-Id: <20220408114328.1401034-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=947; h=from:subject;
 bh=8vVvI2qZ+WS2PpGgoEgf6Xhiefrm6qpFKgw1EK5Sp1U=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/AO+w0M52wR5OGcu7Rb9aMmx7Vhd+DLVQSaszX
 8TQxkxaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAfwAAKCRAk1otyXVSH0J2LCA
 CCqlEjQHYoX0n5bMsXo5P5DZoy4aNDOPbCF8VG7ypPKWb5Ntx+M9y7VC7/9rNKriVtd8+vSLtkN1OH
 E6zyLBCraR10kCE93iy6HvLDQ8HHpbdOf6pPyHlv9jMvjFE75R0Zforkew0QOXVDnTqAmX2XvrbmND
 oyoPF3bvjyr2BkD/ILcVZkD152EvSpbxJOFTNnHBRjK/1mCU81Z+7ES0jHc9CIi/YX/MPDn+0sJLVZ
 IDgNcadfA1JruyDMXYH84oAFt+2PjooFmrMi4PvWte+LV0j4VnOhW87dr3szMNiOex5fT+U/DKaCZD
 H/U3r8bPG7VlHOT1bv0LLhef0OKTgX
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

The comment for ptrace_sve_get_fpsimd_data() doesn't describe what the test
does at all, fix that.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/arm64/fp/sve-ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/arm64/fp/sve-ptrace.c b/tools/testing/selftests/arm64/fp/sve-ptrace.c
index 4c418b2021e0..7682798adbba 100644
--- a/tools/testing/selftests/arm64/fp/sve-ptrace.c
+++ b/tools/testing/selftests/arm64/fp/sve-ptrace.c
@@ -395,7 +395,7 @@ static void ptrace_set_sve_get_sve_data(pid_t child,
 	free(write_buf);
 }
 
-/* Validate attempting to set SVE data and read SVE data */
+/* Validate attempting to set SVE data and read it via the FPSIMD regset */
 static void ptrace_set_sve_get_fpsimd_data(pid_t child,
 					   const struct vec_type *type,
 					   unsigned int vl)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
