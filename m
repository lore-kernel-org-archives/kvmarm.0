Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004F52F2B
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 16:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5370C433EF;
	Wed,  1 Feb 2023 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675269673;
	bh=a8VOca+QniEvdF4EQd1Ik351xx1oiB6pY475DXdYSN8=;
	h=From:To:Cc:Subject:Date:From;
	b=OfNVYOrWxOGHDtsqZOcRnqPwxHF2VscNbFwjzYDqZmhGgd2FprCtmi8BGwd1jWnd6
	 mpUUtSQPicyd6TrqiJduPebaWXRPiK82T5Zb2p7kPKz7j4rNm1S2FHK4SNmyN6RpO4
	 7V/ZQQE3I/KzL6XqiA899torX/pMu4C4uwG6CtWEthBCZ4BE5yNJ5Hbq95h+3jbjco
	 +x7wFsvR5R6wMACnkiiMy3A+kBu8wuuF/N2549cQmGew2KvwjFEAq25g4mkh600ZDE
	 OJK1EcXKBsJo9eEg9YsxyMzkXn5TJ4Wb08YrWtNWdBKOQY4o3BebV5lelP+62Uw2F7
	 BX9v+Wxlo5sjg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pNGAZ-006ZnZ-Bz;
	Wed, 01 Feb 2023 16:41:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Hector Martin <marcan@marcan.st>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] irqchip/apple-aic: Correctly map the vgic maintenance interrupt
Date: Wed,  1 Feb 2023 16:40:56 +0000
Message-Id: <20230201164056.669509-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, marcan@marcan.st, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently allocate the vgic maintenance interrupt by calling into
the low-level irqdomain code. Not only this is unnecessary, but this
is also pretty wrong: we end-up skipping a bunch of irqdesc state
setup

A simple "cat /proc/interrupt" shows how wrong we are, as the
interrupt appears as "Edge" instead of "Level".

Instead, just call the standard irq_create_fwspec_mapping(), which
is the right tool for the job. Duh.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---

Notes:
    This applies to Oliver's kvm-arm64/apple-vgic-mi branch.

 drivers/irqchip/irq-apple-aic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index 09fd52d91e45..76ee7c5e7b7e 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -1201,9 +1201,7 @@ static int __init aic_of_ic_init(struct device_node *node, struct device_node *p
 			},
 		};
 
-		vgic_info.maint_irq = irq_domain_alloc_irqs(irqc->hw_domain,
-							    1, NUMA_NO_NODE,
-							    &mi);
+		vgic_info.maint_irq = irq_create_fwspec_mapping(&mi);
 		WARN_ON(!vgic_info.maint_irq);
 	}
 
-- 
2.34.1

