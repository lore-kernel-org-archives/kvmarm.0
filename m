Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F53EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 02:29:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC4444BAF4;
	Tue, 22 Feb 2022 21:29:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d+aaS3yZ8uHO; Tue, 22 Feb 2022 21:29:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 974014BDE0;
	Tue, 22 Feb 2022 21:29:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D215C4BDE0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 21:29:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kblV-Fy4NqP8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 21:29:51 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A34314BAF4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 21:29:51 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 39EF8B81E16;
 Wed, 23 Feb 2022 02:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7B1C340E8;
 Wed, 23 Feb 2022 02:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645583388;
 bh=pJlFBvjxuJ7foblMFzRm/Bg/OJGdmZY6qGEQYa19W1U=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=HFjbgaQDqsmWMcFR/0svz9kahFBQc0IRkPyrKj3/kTHfhoQqotHnR+wXO43z/+Aju
 O9XUpMryeD+WaOfsK4xpe9MM27b4sc6AxPaIO5y2Pgz1LeIjzTGp4eDJY6xvGFxY1t
 QnnZTP8EIf9fsUMq6nryexbhdJHSqhOYo4Zr4lc0xsC3tL4787lAHnw5vueN+910i3
 BeTG/nTnOO7SXrQzvR85ezCrkiXtizCmD9YRbGrfNr/gPBZAK9BCY7niDHyMxs3fnC
 ruoDU66FUoUsrZTFdwG0MTuzgtshmBI3h3eQks2hzV4Znxdm1fTvrUXE0FbrX0nLyV
 ABrKDhXq8F+cQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/28] KVM: arm64: vgic: Read HW interrupt
 pending state from the HW
Date: Tue, 22 Feb 2022 21:29:10 -0500
Message-Id: <20220223022929.241127-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>,
 rikard.falkeborn@gmail.com, catalin.marinas@arm.com, will@kernel.org,
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 5bfa685e62e9ba93c303a9a8db646c7228b9b570 ]

It appears that a read access to GIC[DR]_I[CS]PENDRn doesn't always
result in the pending interrupts being accurately reported if they are
mapped to a HW interrupt. This is particularily visible when acking
the timer interrupt and reading the GICR_ISPENDR1 register immediately
after, for example (the interrupt appears as not-pending while it really
is...).

This is because a HW interrupt has its 'active and pending state' kept
in the *physical* distributor, and not in the virtual one, as mandated
by the spec (this is what allows the direct deactivation). The virtual
distributor only caries the pending and active *states* (note the
plural, as these are two independent and non-overlapping states).

Fix it by reading the HW state back, either from the timer itself or
from the distributor if necessary.

Reported-by: Ricardo Koller <ricarkol@google.com>
Tested-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220208123726.3604198-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 48c6067fc5ecb..f972992682746 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -248,6 +248,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 						    IRQCHIP_STATE_PENDING,
 						    &val);
 			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+		} else if (vgic_irq_is_mapped_level(irq)) {
+			val = vgic_get_phys_line_level(irq);
 		} else {
 			val = irq_is_pending(irq);
 		}
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
