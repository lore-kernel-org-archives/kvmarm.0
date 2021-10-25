Return-Path: <SRS0=qWZ6=PN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087DFC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 16:59:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B32260F9B
	for <kvmarm@archiver.kernel.org>; Mon, 25 Oct 2021 16:59:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B32260F9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04ECF4B129;
	Mon, 25 Oct 2021 12:59:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mkgdh153xTsz; Mon, 25 Oct 2021 12:59:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BEAE4B135;
	Mon, 25 Oct 2021 12:59:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C88234B08D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 12:59:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nDHRGvytmY0Y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Oct 2021 12:59:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18E074B129
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Oct 2021 12:59:43 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EA52603E7;
 Mon, 25 Oct 2021 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1635181182;
 bh=6H8hFO/A50Azi8V/YTYPHUkKtU198WHr2HkH2FB4dJ8=;
 h=From:To:Cc:Subject:Date:From;
 b=at0I9LQPIRsFknc8V8zeTsmdJgyDOGhJDI9zNar1FvwaeGdqCj3IqO/YDIJSSC/vl
 0gRmaWNKMYrpPBJZNoYPa2Ax5Do6k05X9JBlF8piOEh5GU+JPU5jYBzSk0iRBLIz4Q
 geG2t5wAKTVLaiKb5/BTuXg9V3tKJQczI0FwisCKC5r7z9Pd+qvfU4Nv9QzOrI/XGe
 BXm8YsDSPy697A/8E5PqnzH69iREzBXDBZBWJFpcemcU2rEtqhxWvO5awMapr86K/O
 NJOo4eRQN2uwsuU+vLWNQ9R9x7ZCrJRayjFWeK9UbH7iPdBxfRY2BDqOJYb5SpWxfX
 Tl+w+BaRTkxYQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 01/18] KVM: arm64: Report corrupted refcount at
 EL2
Date: Mon, 25 Oct 2021 12:59:14 -0400
Message-Id: <20211025165939.1393655-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>,
 catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: Quentin Perret <qperret@google.com>

[ Upstream commit 7615c2a514788559c6684234b8fc27f3a843c2c6 ]

Some of the refcount manipulation helpers used at EL2 are instrumented
to catch a corrupted state, but not all of them are treated equally. Let's
make things more consistent by instrumenting hyp_page_ref_dec_and_test()
as well.

Acked-by: Will Deacon <will@kernel.org>
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211005090155.734578-6-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 41fc25bdfb34..da2d3c0bfb7f 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -152,6 +152,7 @@ static inline void hyp_page_ref_inc(struct hyp_page *p)
 
 static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
 {
+	BUG_ON(!p->refcount);
 	p->refcount--;
 	return (p->refcount == 0);
 }
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
