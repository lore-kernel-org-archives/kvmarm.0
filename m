Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF62BC46467
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 09:50:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87FB74BB8C;
	Tue,  3 Jan 2023 04:50:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 23ipOz0NyX+v; Tue,  3 Jan 2023 04:50:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2C6411D3;
	Tue,  3 Jan 2023 04:50:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF1740F30
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 04:50:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Arh5LqBrgZQj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 04:50:43 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09988411D3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 04:50:42 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF4A6122B;
 Tue,  3 Jan 2023 09:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E3DC43392;
 Tue,  3 Jan 2023 09:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672739441;
 bh=ARLfbpBM69dXDtUx7JEBSy4KWdTmviEfk9qRcpSeYPM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GdQr+NHPQAJ+Ij1jsH782ej6DuZ5M8bl5ceEdI/mosMJn2peIBgjl6D0kygQrEENF
 DsFyhme9/k7cYXWf04r1jjTRFsX0YtAEV9Or2S8q479OhNynAfZkrD1VP/ehs3h+7E
 ytfNGEs5Kl6ZreIkkH/9CCfkjLkCJveo/dgYrzWct0stsioYg6ES1HNn5vLe7GLloI
 djxp8FssKWatHN5BshdArNm0pRLOyTxq30Nyb6/V/hgoxAFcL7yOiyS0CBR62gxF4i
 OLZvTYaFHF/kAQFZRGg5aNAYcgtiRnpTN0piWe1QsED3pPvSAIfpeOX8jFFe2cnPsO
 AeJptl9eUoRNA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pCdwN-00GTcP-M8;
 Tue, 03 Jan 2023 09:50:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH 2/3] KVM: arm64: vgic: Allow registration of a non-maskable
 maintenance interrupt
Date: Tue,  3 Jan 2023 09:50:21 +0000
Message-Id: <20230103095022.3230946-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103095022.3230946-1-maz@kernel.org>
References: <20230103095022.3230946-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io, tglx@linutronix.de,
 will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 asahi@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, Sven Peter <sven@svenpeter.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>
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

Our Apple M1/M2 friends do have a per-CPU maintenance interrupt,
but no mask to make use of it in the standard Linux framework.

Given that KVM directly drives the *source* of the interrupt and
leaves the GIC interrupt always enabled, there is no harm in tolerating
such a setup. It will become useful once we enable NV on M2 HW.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index f6d4f4052555..e61d9ca01768 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -572,7 +572,7 @@ int kvm_vgic_hyp_init(void)
 	if (ret)
 		return ret;
 
-	if (!has_mask)
+	if (!has_mask && !kvm_vgic_global_state.maint_irq)
 		return 0;
 
 	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
