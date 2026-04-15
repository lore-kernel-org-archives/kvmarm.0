Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8285537D11F
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254184; cv=none; b=cD3suxsU92DTaMWg/cXGN8ZcRQjzXMeDnTXxdW4T2zu8gT3+HBVnCEkz6WUqfgoOSJ/UheZTI3FjYKDs4Y7PEMF6fQzpN+LWVLxRSAiKtGajiulBnHBtUyFz4MfgDlAVNxe/3fA3I4Rz3ucvxHEb5tnQAJZWPX/+E2+IKEDmPl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254184; c=relaxed/simple;
	bh=IXwtASoWr0Rh5sMg1W1zwBg/xgjbLHcI6sW2VMPX6cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=by6440DZNg1j00kxhW52BQfkse6T+4hZ9SRllr8BtJC5pwbJKazi0N7ittbNlKtJwlZnWfUGnYMOCwKPl7MX8ny+rKo8D0CfAhHLdZ/yoySVNsbRmD9ruEUC22qDHsVBMl3+Ec7mrSm9i78yjiIRNHxY+amohYEqeGUkcd3XGjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sHtPq55U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sHtPq55U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60099C2BCB4;
	Wed, 15 Apr 2026 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254184;
	bh=IXwtASoWr0Rh5sMg1W1zwBg/xgjbLHcI6sW2VMPX6cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHtPq55UjzdF6ukDT91Gl8m0uRYcXOQ//O1LYM5YuFQPNhL21cES1CPkWqYLTpBo9
	 QAQsvHGNLLF4XBl9IfRVuISbtgj3sK88o5I5KJCxUeD64Uj6A6gVUakkmYW01/uNW+
	 a4/quDcRVrg4hzi8eADrnKRYfH0oAPtEv7hXGDIyFVe1tk/GvNV9UIOuR9Koo0U3pb
	 d51RgsJsCAnVEOpH7R2qhHirtuLjZk+0ZLE1qsqBgb/VLkXCSgd1ITVtP3ATxemuXE
	 9pKTob7V6keaiDdsty1I9AsM5U2j0r78hTxiP1NG/Qda8yt+0cVUVJJxktDaGGG5T0
	 +3lZ8pP7k6kIg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyr0-0000000Bqsi-2X3c;
	Wed, 15 Apr 2026 11:56:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 17/18] irqchip/gic-v5: Immediately exec priority drop following activate
Date: Wed, 15 Apr 2026 12:55:58 +0100
Message-ID: <20260415115559.2227718-18-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Sascha Bischoff <sascha.bischoff@arm.com>

With GICv5 an interrupt of equal or lower priority cannot be signalled
until there has been a priority drop. This is done via the GIC CDEOI
system instruction. Once this has been executed, the hardware is able
to signal the next interrupt if there is one.

As all interrupts are programmed to have the same priority, no new
interrupts can be signalled until the priority drop has happened. This
can cause issues when, for example, an interrupt remains active while
a long running process takes place, such as when injecting a physical
interrupt into a guest VM in software.

The GICv5 driver has so far done the priority drop as part of
irq_eoi(), i.e., at the same time as deactivating the interrupt. This
means that any long running process (or VM) could block incoming
interrupts, effectively causing a denial of service for all other
interrupts.

Rather than doing the EOI as part of irq_eoi() (which the name would
suggest would be a good place for it), move it to happen immediately
after acknowledging an interrupt in the main GICv5 interrupt
handler. The deactivation of interrupts (GIC CDDI) remains implemented
as part of irq_eoi(), which means that the same interrupt cannot be
signalled a second time until deactivated by software.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 6b0903be8ebfd..58e457d4c1476 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -218,17 +218,13 @@ static void gicv5_hwirq_eoi(u32 hwirq_id, u8 hwirq_type)
 	       FIELD_PREP(GICV5_GIC_CDDI_TYPE_MASK, hwirq_type);
 
 	gic_insn(cddi, CDDI);
-
-	gic_insn(0, CDEOI);
 }
 
 static void gicv5_ppi_irq_eoi(struct irq_data *d)
 {
 	/* Skip deactivate for forwarded PPI interrupts */
-	if (irqd_is_forwarded_to_vcpu(d)) {
-		gic_insn(0, CDEOI);
+	if (irqd_is_forwarded_to_vcpu(d))
 		return;
-	}
 
 	gicv5_hwirq_eoi(d->hwirq, GICV5_HWIRQ_TYPE_PPI);
 }
@@ -963,6 +959,13 @@ static void __exception_irq_entry gicv5_handle_irq(struct pt_regs *regs)
 	 */
 	isb();
 
+	/*
+	 * Ensure that we can receive the next interrupts in the event that we
+	 * have a long running handler or directly enter a guest by doing the
+	 * priority drop immediately.
+	 */
+	gic_insn(0, CDEOI);
+
 	hwirq = FIELD_GET(GICV5_HWIRQ_INTID, ia);
 
 	handle_irq_per_domain(hwirq);
-- 
2.47.3

