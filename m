Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C13C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 00:16:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7554441003;
	Mon, 24 Jan 2022 19:16:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z3wnzeql5jef; Mon, 24 Jan 2022 19:16:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD8D749E43;
	Mon, 24 Jan 2022 19:16:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22FEA49EE4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:16:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nVltv51ovljT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 19:16:49 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2481549ED6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 19:16:49 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id ADD9E61541;
 Tue, 25 Jan 2022 00:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B056BC340E9;
 Tue, 25 Jan 2022 00:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643069808;
 bh=+stvVyRnz2H4xbnaEtKWfcp0/IPDCeyODbC6Y5cXcCY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=C8wbOYozrg4+ovKqrWnHq18dFa0bz71bu8Rr/6/ewc58V43gHblWYO25/Zn7FB57v
 xubMD6JJHVgn3VvtrRhwWg7zvLqw5dTL59NWQFEPCmonHw7qSJ8H2nwPcq2a2KGu5w
 CXTMeCc17fNBNw/eYs3h4OUF6Q3Q72n5DthiAl5E6wO9X07Ix4gq3THDXmbp8gsLzM
 3Wb6/eEdOUCOWqrN6eIVsP3hZdmqN/8xgofETXtVellDBvX+nWqhlGVplYyFH3WvBf
 zmSMQUnpSUvUUK8rMwLkWi+UG0ZrDhn6Z3u6RYH3JlbhPYZ4DCjxKG3qW2bF9ptIw4
 aeVPuNh3Xy0Xw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v8 22/38] arm64/sme: Disable streaming mode and ZA when
 flushing CPU state
Date: Tue, 25 Jan 2022 00:10:58 +0000
Message-Id: <20220125001114.193425-23-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125001114.193425-1-broonie@kernel.org>
References: <20220125001114.193425-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1128; h=from:subject;
 bh=+stvVyRnz2H4xbnaEtKWfcp0/IPDCeyODbC6Y5cXcCY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh70ASZjkrllyw3wrZv65gkzLMq7K6hvi8wR5NerZM
 dVGlefyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe9AEgAKCRAk1otyXVSH0NbyB/
 0aSvLUKYmoq6mFoAyvpGc/oT3Cs8OYVjbNPgjDw2ExcuHRbslUM2Mr0KL3jFfhvee4XeVMl6fVdWZI
 qr658iRh7kGFTUU5UE1J2hqhfohsDh8EC7a2+S+ZtcAe/r/ZiuJcqDkykG2UFXWHj1npykI9B0/ybx
 q1KkfrLoGwkFQq8Qtgl3b93K1iOrmi8x76b7aRvmIWQIwDoEXTF5GOuSpRACciWM4n1Y4cn6X9s71n
 RmgmsUeY+jswAhlV+8Yk5JRxyHjS+ibi0+kDGF0PbS1KpMhTa0+3R6w0ZrX3XP1IuU63+JgCi2qfNe
 7JzsueypROn3Znfz+GdLab96n/x3mG
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
---
 arch/arm64/kernel/fpsimd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 8b111b7f2006..e00d3a9e919c 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1762,6 +1762,15 @@ static void fpsimd_flush_cpu_state(void)
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
