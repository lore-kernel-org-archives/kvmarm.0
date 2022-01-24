Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669AAC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jan 2022 15:58:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C292F40DCB;
	Mon, 24 Jan 2022 10:58:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GJA9KhDhv-UU; Mon, 24 Jan 2022 10:58:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B67B640FB2;
	Mon, 24 Jan 2022 10:58:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CBAF40DCB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 10:58:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OCa7qOoyzbbv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 10:58:49 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B06640307
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 10:58:49 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3B5AAB810FE;
 Mon, 24 Jan 2022 15:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E032C340E5;
 Mon, 24 Jan 2022 15:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643039926;
 bh=QXQ8JfRtlbgKLaluYNOA5cd75hhBrpIfHU5/kIw2HVs=;
 h=From:To:Cc:Subject:Date:From;
 b=NN7BN2VilW9yIYf95xdZEddsTXRXWFCd4swo3b7O3f8F58fBOzUugbVooBxYr0DBA
 yrmADXbXsjwOCbOxtJkoZZNpQktPd+MMfJdSU5ClkjbE3JJ5ETPa1NdL3wPQOkIFrK
 kdSmjiaygZBQysiJS3J2qF4Kf9RYZhPoZHL+67/K25DU2N+vDQo7btG/MuzdC4ae44
 p2V1p3uwDedmtxIo58RSpnRkKA7X1VypEC/gK3+1HFnYjifzHfwJcmGh371cl1xCl6
 WFiYyVASiU4SqjFgzOk37myGPl0NzNLEQ3sP3a/uARM7aZn077Cwazta22yD84eaXi
 DCplohxBlA8qg==
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH v1 0/2] KVM: arm64: Additional documentation of the FP code
Date: Mon, 24 Jan 2022 15:57:18 +0000
Message-Id: <20220124155720.3943374-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=567; h=from:subject;
 bh=QXQ8JfRtlbgKLaluYNOA5cd75hhBrpIfHU5/kIw2HVs=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh7sxdwjS34zj0UaRImcDwXochgOPt+/jCTaoyui3R
 YZ2u02OJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe7MXQAKCRAk1otyXVSH0D4PB/
 4wFM4PixS8ThaBp80H78OS4YKJtOB7dEcjBHEoRNV7lvgFCifbZdcQLPrrx9VH9hinfkYgpQCqvLyf
 BinHuYfcMyW5Xm/bw46soFC3/ThzYs9YD6wO7wljfALoWSRqn3N8RXzgWwcEGQtRV1wTgA6uHRN7M1
 rpcVV/TwEJD5PhuzmL83LH4eCK7Cem3m8+ZMl+IrUMlYqYHdkLB5nIC9EmaRXYvKoAE5CWPrsvnKe7
 A/g91T0F8e7ubFBNpKf2RcQjshQcA7qo0gz4Yoh+ctpqL22WQfo2fEOHJeh5RC9NAipCm+ho8dwzWY
 fNqQpH4v8kUcHL/QbmwURHGDOE/XSj
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

These couple of patches add a few more comments to the floating point
code which will hopefully help the next person who comes along and tries
to figure out what is going on.

Mark Brown (2):
  KVM: arm64: Add comments for context flush and sync callbacks
  KVM: arm64: Add some more comments in kvm_hyp_handle_fpsimd()

 arch/arm64/kvm/fpsimd.c                 | 14 ++++++++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++++
 2 files changed, 14 insertions(+), 4 deletions(-)


base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
