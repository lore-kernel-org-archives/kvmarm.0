Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF069C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 12:37:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ABA74B106;
	Tue,  8 Feb 2022 07:37:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HgYhwlBQpI8Z; Tue,  8 Feb 2022 07:37:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9604B0B3;
	Tue,  8 Feb 2022 07:37:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A534A531
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 07:37:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tFHipZ-N4VMr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 07:37:51 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2762449EE2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 07:37:51 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 82A39B81AEE;
 Tue,  8 Feb 2022 12:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EC3C004E1;
 Tue,  8 Feb 2022 12:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644323868;
 bh=Vdzv6/VbCUfmB9ltCSpCmrJCAknBa748GpfXsqv7SuY=;
 h=From:To:Cc:Subject:Date:From;
 b=qmuMJ8idnULy1JeLdMTOgVlGQSy4iea+9UUHi3D6DoiEFoAwTCsKJarkGnh9C8wo7
 gcj0hZDWqxCqcCNqL7X0jPIs2CSHx70b28Pl7WjXfQPXKpx3QYWWHDFRGZjv/WnhXn
 yb05l0jB8K01IncTERH7mbpugILidG2rkvR+MtOBfw5dloXjf/j7DT1qIRmGvdE6w3
 t7xVPTQRwgb/w+1CbKnl6OW9W3MowN94jibzF+H6rt8y1vcpLZ9RFA0gsLc4KGOPt0
 pgKp9oKyidHeDeU5Jt98QpteNPQu+R9TsYFC2x83S2aablvzLPxIk09kYWByQWrzLU
 t9b1sUe5dcFYw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nHPkg-006FuE-2W; Tue, 08 Feb 2022 12:37:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic: Read HW interrupt pending state from the HW
Date: Tue,  8 Feb 2022 12:37:26 +0000
Message-Id: <20220208123726.3604198-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com,
 ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 7068da080799..49837d3a3ef5 100644
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
