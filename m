Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1C1C3DA7D
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 12:40:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A7874BA99;
	Tue,  3 Jan 2023 07:40:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VmNinHMY509E; Tue,  3 Jan 2023 07:39:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B389B4BB66;
	Tue,  3 Jan 2023 07:39:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F8504BAAF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 07:39:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zn8hOs69ClE1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 07:39:55 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 207694BA99
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 07:39:55 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6E6ED612FD;
 Tue,  3 Jan 2023 12:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC687C433EF;
 Tue,  3 Jan 2023 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672749593;
 bh=DayNbxlWjObga1POZwVWqqYGle8SgTc7y5WtKCXJ8Kk=;
 h=From:To:Cc:Subject:Date:From;
 b=pFznceRPvQwrVmtkaU2N0VC7FOdFtQcVmxwsuNM27APSsZ3m0qnTkFE20g0Kdl/n1
 TKB+ov5+JEOV8CFxYJMwpZgzen2Y3auZtGylKQgOwT6J85e6fSg0wu2sBIoNT+SQWg
 UHAEb9LIvNNjpcknbyx1yvBUiRD8XZ3d2qzBsnesyAAq+xucW900XbC1oHfSdArM0N
 mkqc1X097W7kJnZptxALipe18TQygVqhTbSPJ1tzYHkcAez7A+fKvCWL/HJyzVqCaG
 U4BTlQwEpPvctLIjFREp82eyvhg+d2Sqs2kpsZ423YBW4rVSYHcBthoRKuPlEBxEpx
 SNXqSXZIkSYNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pCga7-00GVQe-I3;
 Tue, 03 Jan 2023 12:39:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH] MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
Date: Tue,  3 Jan 2023 12:39:33 +0000
Message-Id: <20230103123933.3234865-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 oliver.upton@linux.dev, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

Zenghui has been around for quite some time, and has been instrumental
in reviewing the GICv4/4.1 KVM support. I'm delighted that he's agreed
to help with the patch review in a more official capacity!

Cc: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f61eb221415b..551544d877a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11359,6 +11359,7 @@ R:	James Morse <james.morse@arm.com>
 R:	Alexandru Elisei <alexandru.elisei@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Oliver Upton <oliver.upton@linux.dev>
+R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev
 L:	kvmarm@lists.cs.columbia.edu (deprecated, moderated for non-subscribers)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
