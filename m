Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE93C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 11:25:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA3494B20F;
	Tue, 19 Apr 2022 07:25:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9KTSDfaBeM+i; Tue, 19 Apr 2022 07:25:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3D4249AF7;
	Tue, 19 Apr 2022 07:25:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E59E049AF7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:25:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xnbk4cd-6ZAA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 07:25:01 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3611840FF0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:25:00 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 522E5B81100;
 Tue, 19 Apr 2022 11:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E9FC385A5;
 Tue, 19 Apr 2022 11:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650367497;
 bh=hKEqxVq3qIYNyJ3Q5Mx9hTOo2XjAx/mVC4NFmLZ1diw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OtdXNzNGNqIEpXHSfEQAcoqLQA0OwnOcKDqUUOsEK30/CwM/vmZM55bFDdRdVgate
 FIqnXzaLYHO6Uh/guVYztKPCO4PoqTKx2JhLdMpBbS6Z1tLMM0hbc3QuItEsnaseMe
 idZi3Dogm7SVDh0YiZO3vJoAm/SXLVXOmusumws0EHuPEYhE4R4sMl4b/iGu8eAo5P
 MJs8hrCwE4uSP4+NNdguB3ju4hmOmvFdK+gTlOqPq//zvOFbIFS0wxW/GmN+CXD7Vz
 shVizrxaqmq6xGDR0qxFzz78MiqeGSTYCUEE+jaE6SaR0mBG7h5gF5iCU4zwMAeIfA
 ultWbR4Ehl4tg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v14 22/39] arm64/sme: Disable streaming mode and ZA when
 flushing CPU state
Date: Tue, 19 Apr 2022 12:22:30 +0100
Message-Id: <20220419112247.711548-23-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1184; h=from:subject;
 bh=hKEqxVq3qIYNyJ3Q5Mx9hTOo2XjAx/mVC4NFmLZ1diw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiXpt5bayPRAObOqjq+ZBzKh1FKgvLLGsBQ3TgiJDo
 PC1NiqOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYl6beQAKCRAk1otyXVSH0HsjB/
 99t6AWS0KoiDaWwA1DqLBTFqSSLoaO0NK6a/uwv+HSzr8GMop4VZ4Jx+wxMhIFhR3ZQTNnGhdadvR+
 33Ozd+ypw9AO57hbRuNZX1/Vt9Au6jm3irZzve/q5nrjy86I4wnyl114GsOwjTUaB+g2Zn2tSPoDLo
 2YuS73oV0vFDm3aTswWCgxcF+SA10fDBiIotXrR8ADPZA2DotX58GxC19jFaNdhHC7qLzbNw+biCAu
 RiUjOMub4MO3jeWg+ooKKn6TWhVv8tg5k7G5GlwDpO1sVhoErSG6LXOq7ZR/90i/ZVPSZCewptyPfy
 Xl3RcId+7mqhbe5HN2xu31t7cvmNnF
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
