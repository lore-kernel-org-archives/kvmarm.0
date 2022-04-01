Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A96C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 14:28:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E596D4B20F;
	Fri,  1 Apr 2022 10:28:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9JOtORph62Ta; Fri,  1 Apr 2022 10:28:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BE74A10E;
	Fri,  1 Apr 2022 10:28:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E491049F56
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:28:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iuWMauRXsTG2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 10:28:33 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B286549F1C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:28:33 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 7A97CB824FD;
 Fri,  1 Apr 2022 14:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CA4C340EE;
 Fri,  1 Apr 2022 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1648823311;
 bh=c8TjKPcrOluaxY+tbry9iwgrFV68Q5NpjoOYMtInmwk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GqZh6BUbvZ2LKV+wjfWfoxh2gm48W97CS8iT5af1wCn1Z8Hnm+VLW5Bka3X6kBvdx
 P7U+lt6Gkr/U8AR/tMnEA1CrznHoWfBEh5nIwElC9TdlPmDkAVKQToTww2IW/6qXBb
 A59TdTMT+MRa+sMdQAYM3kEDUPZXH62J5gYD3jxizebf/+x/qHJjkdW5MYVABoiyCL
 Qfews+SOZAw5Tbjnm8wNsNavjjJ0Hd2sAve4EyieLVJDqGMNjyOmBOsJmLPLJoBKP/
 7ID4u94rcYe9MQqkBFq5MtFUyYXCfat5QtXAtdpPxIvMh9JKYSSRErYTnZkpLYsYCq
 WroAbj9gFgFdg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 052/149] kvm: selftests: aarch64: fix assert in
 gicv3_access_reg
Date: Fri,  1 Apr 2022 10:23:59 -0400
Message-Id: <20220401142536.1948161-52-sashal@kernel.org>
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

[ Upstream commit cc94d47ce16d4147d546e47c8248e8bd12ba5fe5 ]

The val argument in gicv3_access_reg can have any value when used for a
read, not necessarily 0.  Fix the assert by checking val only for
writes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-2-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 00f613c0583c..e4945fe66620 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 	uint32_t cpu_or_dist;
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
-	GUEST_ASSERT(*val < (1U << bits_per_field));
+	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
 	/* Some registers like IROUTER are 64 bit long. Those are currently not
 	 * supported by readl nor writel, so just asserting here until then.
 	 */
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
