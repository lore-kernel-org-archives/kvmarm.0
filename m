Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63061C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:36:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E3AA4965C;
	Fri, 25 Feb 2022 12:36:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bjTMh1ZrxA9V; Fri, 25 Feb 2022 12:36:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E627949EDE;
	Fri, 25 Feb 2022 12:36:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4AC649EDE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:36:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wS6D2tz2r3-P for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:35:58 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2397A4B9C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:35:57 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7D56061DCC;
 Fri, 25 Feb 2022 17:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81457C340FF;
 Fri, 25 Feb 2022 17:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810555;
 bh=bDRizLqcB/rg4bPthhre+I4xVGpZjdYARITX+zdN5ac=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kHc1QsP66RPrqEZ5PTTRbaz0BMSN6JLOhmwTFEiy5onD0S9+zGHF7pNnk9POluZP0
 AoMw3Cy8uSX1sIYp/ea57oBhx2+T9WZLCwK3KpKq4lG5Y26HXpXgd/qi2ZxcR2jWJ4
 5Hxwj8ocK/y5A/lp/PEeVIb94yvGHn9/sS12mDFOna4UdGSqyBti3Zfoe4f4aE4l25
 Ksi3OOBdTto4To4UG1p6dxG5dix9GzQe1KSu2Te9437zic9Nbrp50NhCClgo2zg7dR
 JisLXJUmQuTqDn6aasybz+6FlDITGHrhV2JhixgMf6lafhD62HFQzNfXFCskd1XgeS
 hAh3H/NIHt7tA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 24/40] arm64/sme: Disable streaming mode and ZA when
 flushing CPU state
Date: Fri, 25 Feb 2022 16:59:07 +0000
Message-Id: <20220225165923.1474372-25-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1184; h=from:subject;
 bh=bDRizLqcB/rg4bPthhre+I4xVGpZjdYARITX+zdN5ac=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhiRJrrsXE5s3y+/xqHLil0u5l6zytMnUKFhv9r/IRJtdEXwm
 fBWdjMYsDIxcDLJiiixrn2WsSg+X2Dr/0fxXMINYmUCmMHBxCsBEdH+z/2bzb/v9WXeFbmm0gMhrq+
 1c92o0WGqZ/td9rUthU18yX+STK6fdhCzNgtdOs54aRSbEqiuvmWpVfHqOisqqy6pvN627cIdn1kWW
 A+Lvvzq0phamtP58NmMeU+CXpbPnLRVTmaL3OvvH3Jvh94tyiqVtVeYo+0/c+9qkt8An3vYi7+Qln9
 k6H6arT+1l8Njku2EN+8OXX3hOi0+z/FzwyMKJl8UiIUJkt/B0nYREJ4cA21spLuwaW5sfRZ/hC+My
 +eqV6pRr7eqjkbpFV6xvqZJPw6nZr1bGPrM4/0tz5vxgiyWPN8z/w2MTwp/geKPpYeCVmsOGATkcHn
 rmC+5d564O/3hAqYJ75uyfQiavAQ==
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
index 2e931373b361..d21d16bb03a8 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1742,6 +1742,15 @@ static void fpsimd_flush_cpu_state(void)
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
