Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4254C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 18:47:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4067E4B964;
	Fri, 25 Feb 2022 13:47:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bOsIN9qjYc5i; Fri, 25 Feb 2022 13:47:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5C34B9AC;
	Fri, 25 Feb 2022 13:47:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D83E4B9A7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 13:47:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OqRlvyO7bt91 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 13:47:06 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A65A44B9A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 13:47:06 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B4B1260018;
 Fri, 25 Feb 2022 18:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89038C340EF;
 Fri, 25 Feb 2022 18:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645814825;
 bh=GRUdGmd5015h+9qg389AvQ3eIjQ0wjGKZ2ZkuHOEtZI=;
 h=From:To:Cc:Subject:Date:From;
 b=eb2pOJKeGIvBe3KCd9EwCixqsnHRd5+uvz9nB5Y4pygSDINWsYwjUKwtrbKJ+12PI
 Rurj7t6vYG9GyfR9KgJZD6mczms4pjjsYQl4oKV9uaJMH9kBGI816wbFZiz4REEW/x
 +EXs2KGV506C3rhR8VTcu2KoQQtz5Yd0G3v2zEwZym4yH3pHJL6B7fBhVhLvzQCD/0
 xiTvmLvRWqLx4o3iZiHHiHIST3D0Bw6faOBnq6ScNxlMvnOWdpPwBbnrb/HpXVvO8H
 xQtz+FCxGhv6+QrWU6Xbk3PJ0zgAJCEkUig5ah3D+vcLjys0L+Y9ehkHsB3/f27iLC
 APgRffYsxaFEg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH] KVM: arm64: Enable Cortex-A510 erratum 2077057 by default
Date: Fri, 25 Feb 2022 18:46:58 +0000
Message-Id: <20220225184658.172527-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1001; h=from:subject;
 bh=GRUdGmd5015h+9qg389AvQ3eIjQ0wjGKZ2ZkuHOEtZI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGSPCnMcwuE9CeY85wgX6enAwxqXbj9jnAQMuQ/BF
 YaPaUnKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkjwgAKCRAk1otyXVSH0IQ9B/
 9V8IILTB7qdqnDNhZug6jfuyQPmNb60fSRqStyFcV/R9x9R0vqvkRnwYVJ55/5ozhsy57dhS/XIeXY
 29D9CepAJC7H03KB0LSP3YbW1CBbprwfxkrpyUYOciTbKoM3hSyAn32N2CO7vC5AMAOatXJyB2yC5R
 CZaKbjZhCHsFbzhkZTfwbYmpVYNVXBpmm2VGPIguWnAbjZx04h7WSNcCd93tE9Pmv/3HMKz7huYF20
 SxiF3rNAXNO4tFzTsmRaH0cL7wHzzjcIxA4C/59gQv7ZP88iun9YaIPFn05RR4ePocOyhzfsELl6sp
 aJLCbR3WNkxvFuSCbdN+qxeZguBSRB
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

The recently added configuration option for Cortex A510 erratum 2077057 does
not have a "default y" unlike other errata fixes. This appears to simply be
an oversight since the help text suggests enabling the option if unsure and
there's nothing in the commit log to suggest it is intentional.

Fixes: 1dd498e5e26ad ("KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f8e5f64fc40b..fd5f44bfa3e3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -685,6 +685,7 @@ config ARM64_ERRATUM_2051678
 
 config ARM64_ERRATUM_2077057
 	bool "Cortex-A510: 2077057: workaround software-step corrupting SPSR_EL2"
+	default y
 	help
 	  This option adds the workaround for ARM Cortex-A510 erratum 2077057.
 	  Affected Cortex-A510 may corrupt SPSR_EL2 when the a step exception is
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
