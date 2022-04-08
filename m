Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF231C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:56:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B4C4B1BF;
	Fri,  8 Apr 2022 07:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SiVOopHoobkE; Fri,  8 Apr 2022 07:56:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4E4B4B14C;
	Fri,  8 Apr 2022 07:56:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83C004B1BF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:56:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FswMZ90Ptzfh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:56:46 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B48EF4B26A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:56:44 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 174BF62067;
 Fri,  8 Apr 2022 11:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E5EC385A9;
 Fri,  8 Apr 2022 11:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649419003;
 bh=hKEqxVq3qIYNyJ3Q5Mx9hTOo2XjAx/mVC4NFmLZ1diw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SbZMRzpf8Te2GqAxWyjJ4p9AyUdTgvMBvxTqlCOch7C0mESZk9C8Tvll/cD/OwLJV
 a58obC4M0dWEBil8SprmomlsVt7GES2hrc6XSAT9x0T37rLsNDfrPXLjbg+vH243Ib
 NRE01/gbZbSh/IbPcb54QZXzs8fTEYCfsr3G+5F3nZaPWsHiJl/BgaAXiJG5T5jZ9y
 4L4goHxFWF9VY6hTi/Etb2Pmpm9z6OauKlQ88WQ3IwKuktGT7b2aG2L1eyDJXzfaRr
 sAucKpTbF/5LBS+EiWc8tJxfMhX2XWBo5dafsskHXwM6eIDwWXfcesGorMi8Qz+PNO
 jPl06ZR899S9g==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 22/39] arm64/sme: Disable streaming mode and ZA when
 flushing CPU state
Date: Fri,  8 Apr 2022 12:43:11 +0100
Message-Id: <20220408114328.1401034-23-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1184; h=from:subject;
 bh=hKEqxVq3qIYNyJ3Q5Mx9hTOo2XjAx/mVC4NFmLZ1diw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/QbayPRAObOqjq+ZBzKh1FKgvLLGsBQ3TgiJDo
 PC1NiqOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAf0AAKCRAk1otyXVSH0PZUB/
 9sow+wd3rU879zNb/GBVbvo9TsEmWORj7qVQs8QWG+WXCgghi0kb4VQRsffML91gmX/X9CUH05T7rb
 6qfXtjDJske9cv6IOh5vnb5P4stAJNeq937A5L0+edmNQteMyTsPAMqFyLGsY91YcUqvDEfNk/fOw1
 DmS9GUCRz9Zia3EsEhzVq+b9OKDtyDL8PU0fOl9BEeGEvbCH13XdSWwGIo55o7E9Ur5EyCLN/p7Jj9
 welMKPF7nFWiYHpepkDvWdI0Xq1ZI75cn2i1L/GKnSUVnca0G0Sn3M9417FEYT7uXSUPMm64pTDv88
 FJCe8oAsJgqNDoKK3kg27OSFkcgVRC
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

Both streaming mode and ZA may increase power consumption when they are
enabled and streaming mode makes many FPSIMD and SVE instructions undefined
which will cause problems for any kernel mode floating point so disable
both when we flush the CPU state. This covers both kernel_neon_begin() and
idle and after flushing the state a reload is always required anyway.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 94f06e9d37cf..9592cdd7d635 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1759,6 +1759,15 @@ static void fpsimd_flush_cpu_state(void)
 {
 	WARN_ON(!system_supports_fpsimd());
 	__this_cpu_write(fpsimd_last_state.st, NULL);
+
+	/*
+	 * Leaving streaming mode enabled will cause issues for any kernel
+	 * NEON and leaving streaming mode or ZA enabled may increase power
+	 * consumption.
+	 */
+	if (system_supports_sme())
+		sme_smstop();
+
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
 }
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
