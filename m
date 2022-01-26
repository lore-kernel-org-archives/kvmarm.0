Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CFFC63684
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:31:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4F0A4A104;
	Wed, 26 Jan 2022 10:31:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GXrmuqF4nugh; Wed, 26 Jan 2022 10:31:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8D4149ED4;
	Wed, 26 Jan 2022 10:31:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9683D49F41
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:31:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g9A+hXKRsIqn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:31:54 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A0CF49F2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:31:53 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7E89A6189F;
 Wed, 26 Jan 2022 15:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89914C340ED;
 Wed, 26 Jan 2022 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643211112;
 bh=+stvVyRnz2H4xbnaEtKWfcp0/IPDCeyODbC6Y5cXcCY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oRPuKNGHCwnZ1VSUSqealiseudJoqlb+/8nsHVWbGZbQrwPtNcAFQGW71I3UwX2Az
 rzfCmxqS0rEuRtShv+CSZoDJFfAypiBqdMeMnBihZQxF5d9yVBv+2vVt4kCzW6Lrks
 uJCUF4AcTEZFincKuPi7tfNQYiWF6IxLFljy7H1T6BCSfUSRal2IruPaNVFyncCj/d
 66ASS390FFxe72z1rlXYWF6QULikvrmRKNFuM+DEJa6yagO0WKxjulS+YAV5HG0sQA
 V2FRpxJ23WgIfLTHgdJjAEdp2ZgPdWYhJHlnUzSYduZnqQIIiF9aliQH+8vLcJzbJ6
 3PbxG2ZySUkfg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v10 23/39] arm64/sme: Disable streaming mode and ZA when
 flushing CPU state
Date: Wed, 26 Jan 2022 15:27:33 +0000
Message-Id: <20220126152749.233712-24-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126152749.233712-1-broonie@kernel.org>
References: <20220126152749.233712-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1128; h=from:subject;
 bh=+stvVyRnz2H4xbnaEtKWfcp0/IPDCeyODbC6Y5cXcCY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh8WhnZjkrllyw3wrZv65gkzLMq7K6hvi8wR5NerZM
 dVGlefyJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYfFoZwAKCRAk1otyXVSH0LFTCA
 CFRAzSN/vje9nUUCsi+wm2PdjWcOfGt3sY+Ukajpn0zlb9gPmFHavfmNRwhTc/7H8WyXcePT3n39/+
 1yWEo92lRkfsCFtfBj3ge6s8kIMR4ualZ9Zm14cj4oyx7DVrV+dQJVbdM+FFlJqWTMTvqfFmHKBWXe
 o65DjGa4dSHKR3HP7OytWo0AS4UPdapfbm1miFw6BM7VI0aey+lxela6rEx+ldTtkVl4IyU5PUPrDF
 nJjOCCiwl0gng9F2k8yXKE+DYOGsoxb/aWSC5uJYqh4he1fw5lqm3NqIkutYy5piivH61cO2INTXWZ
 v23Iq3O7CgRbHLrjxF5BUSwqInqxYP
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
