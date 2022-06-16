Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDC5C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 08:53:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598C949EBB;
	Thu, 16 Jun 2022 04:53:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vPz6PQkHwgK7; Thu, 16 Jun 2022 04:53:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A589C4B08A;
	Thu, 16 Jun 2022 04:53:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F0DE4965C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 04:53:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vGnsv1HYTqB3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 04:53:29 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC56F49EBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 04:53:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 54775CE23E1;
 Thu, 16 Jun 2022 08:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2088C34114;
 Thu, 16 Jun 2022 08:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655369603;
 bh=pFsQnxa2DjpyX/4z7Qk7RS/OvZLPS/MVPEtG62duvmE=;
 h=From:To:Cc:Subject:Date:From;
 b=XSBCdmMMDMl4BJbZEqkhUGxU1QwrA7qSLluqX1cIk8k2utKGj/rIZc71GEiTtvd8W
 hXZMPmyoTtQh4VcEEzCGLPnvc1795pTCKKOvER17SZBUNjnNqZKy3GiXD6TBFyAf+z
 UgWsPzLjklBOfi5jKecCSEE3/NIVc+igt7zplb4pzWwcbx5qeQ/gYIwlvNogODZWBU
 cjfG0PtursmT3clBUGcu3ZAASjpGDy64I2jIrgzT6Xfn7V2q4kdnH2vSYhUnYeSsTa
 2Niu/5LvCVrIL4UGu5lnFbMhA9KRXHVSinN17CWVvGUShglWmPta3fXdfEr4fYKepW
 ut8tETsTgUT4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1o1lFh-0010oa-CV;
 Thu, 16 Jun 2022 09:53:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH] KVM: arm64: Add Oliver as a reviewer
Date: Thu, 16 Jun 2022 09:53:18 +0100
Message-Id: <20220616085318.1303657-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
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

Oliver Upton has agreed to help with reviewing the KVM/arm64
patches, and has been doing so for a while now, so adding him
as to the reviewer list.

Note that Oliver is using a different email address for this
purpose, rather than the one his been using for his other
contributions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a6d3bd9d2a8d..7192d1277558 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10821,6 +10821,7 @@ M:	Marc Zyngier <maz@kernel.org>
 R:	James Morse <james.morse@arm.com>
 R:	Alexandru Elisei <alexandru.elisei@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
+R:	Oliver Upton <oliver.upton@linux.dev>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.cs.columbia.edu (moderated for non-subscribers)
 S:	Maintained
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
