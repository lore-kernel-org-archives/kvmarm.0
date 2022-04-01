Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27028C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 14:28:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C54DC4B120;
	Fri,  1 Apr 2022 10:28:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cc29+FBgBJGo; Fri,  1 Apr 2022 10:28:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 963714B26B;
	Fri,  1 Apr 2022 10:28:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D0184B12C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:28:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X1aqBwwwc+Hx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 10:28:41 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46EDB4B2A8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:28:41 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id C4AC461CAE;
 Fri,  1 Apr 2022 14:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B31DC2BBE4;
 Fri,  1 Apr 2022 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1648823320;
 bh=fnYaDxJ7uaS/SP7Ui3FGqO635IVj63CD0EGocJ9Mak8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=QrWWR30Aec1Hrbu5U4bxnxvQRrwX63FeyYxROo+F62Vwt3Sj7RnN5hLwK2HslKDrI
 riEp3JEUbc0TzPHqfJVhqsUSZu71yVvuMpPpkXnY1jfUHWGDsZVsBx+Gf6hz4GC/OR
 dolgr26vfKfWz2VOQMGJrusyjmSOojpx1q4FfgH+6lL1oQ63fgcnAOhQlGPuA7dVA7
 NX1Uwl/mc/pqpLbI0l2bLZNPPHKM/hUPA1q13ec+yRNUcrTJDBaSgXcvIqmEQu61bq
 2h5KTvqFZJWSzzSeIO/oaED3g/NDvpuUHxRNbnJmfVBC0sefoV9RZYzR1Z206SVPt2
 7G/Ruz8ZlK29A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 056/149] kvm: selftests: aarch64: use a tighter
 assert in vgic_poke_irq()
Date: Fri,  1 Apr 2022 10:24:03 -0400
Message-Id: <20220401142536.1948161-56-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kselftest@vger.kernel.org,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
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

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit b53de63a89244c196d8a2ea76b6754e3fdb4b626 ]

vgic_poke_irq() checks that the attr argument passed to the vgic device
ioctl is sane. Make this check tighter by moving it to after the last
attr update.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-6-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/aarch64/vgic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 7c876ccf9294..5d45046c1b80 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -140,9 +140,6 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 	uint64_t val;
 	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
 
-	/* Check that the addr part of the attr is within 32 bits. */
-	assert(attr <= KVM_DEV_ARM_VGIC_OFFSET_MASK);
-
 	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
 					  : KVM_DEV_ARM_VGIC_GRP_DIST_REGS;
 
@@ -152,6 +149,9 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 		attr += SZ_64K;
 	}
 
+	/* Check that the addr part of the attr is within 32 bits. */
+	assert((attr & ~KVM_DEV_ARM_VGIC_OFFSET_MASK) == 0);
+
 	/*
 	 * All calls will succeed, even with invalid intid's, as long as the
 	 * addr part of the attr is within 32 bits (checked above). An invalid
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
