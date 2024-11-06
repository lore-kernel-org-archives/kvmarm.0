Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636131D54D1;
	Wed,  6 Nov 2024 08:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882666; cv=none; b=Kptd3h0mBsOqYbTfzMQm8a4Sfaa8Bjk0mnSp51+Az0zfrlX5hgHtL9YX+OcVl2iUDeH28MfGBd5qDr6930sqletLdGcJpuLg5dtGShg26WxwQSCpRubQws8keq4qDqT0YaAVqGW3JGv2rROy0LzWyOLGFE/flo/N7tzCN5Mk9Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882666; c=relaxed/simple;
	bh=epVEU2AYAhlpV2xVETpPhEIE78lqpbGzb/PrPhs7GSM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DlXKkZh5ElPT/0JIv6cP0dICSeTqUzMfn6kbQ/8FHktUIzPhhyZZFnxIb/A6NTIKXDtad82p4DrnMgmi5A8dm1yNE2GstFl4NhyfH79FyV4Vq+veJXR2AQ6v19i8QJWWouGsSRUDWtxS1+F00Jx5UA/jnVnramyrF2Vw9UzYxb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgMe4KmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgMe4KmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E91CC4CECD;
	Wed,  6 Nov 2024 08:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730882666;
	bh=epVEU2AYAhlpV2xVETpPhEIE78lqpbGzb/PrPhs7GSM=;
	h=From:To:Cc:Subject:Date:From;
	b=sgMe4KmOH7KJ1IcKn+B9Q79s6G9NZe5vOEBlKBzaiZHzZeOK0+NotQ+v2nOORZdpA
	 46AIMqkYAd2Tmt+NDDGwIgyv++GFm6xhc9geukIkjFPthX+nxH5EtcezUywjY7Wkti
	 mpq2aRs1pxyUMnJoJNpnM/3B0xt/Fk7FGC4WPflxBD6VVjNQiAa5+ga4GQNChoER6F
	 mgoIr5qxqLTFZwexUfgLZuvjLAIJ80KrX9GZbHetq6TtgkucijjkI8WN8eMGu91C2f
	 0KuhZQ6jvGo8Go5MpOzXYlgK09OYNZVczVQDGlBGLE743vpGiPNlSF+QH4ZrRfiBvV
	 P8mFZzxa+0Zfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t8beJ-00AHp5-UJ;
	Wed, 06 Nov 2024 08:44:24 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Christoffer Dall <christoffer.dall@arm.com>,
	stable@vger.kernel.org
Subject: [PATCH] irqchip/gic-v3: Force propagation of the active state with a read-back
Date: Wed,  6 Nov 2024 08:44:18 +0000
Message-Id: <20241106084418.3794612-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tglx@linutronix.de, christoffer.dall@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Christoffer reports that on some implementations, writing to
GICR_ISACTIVER0 (and similar GICD registers) can race badly
with a guest issuing a deactivation of that interrupt via the
system register interface.

There are multiple reasons to this:

- we use an early write-acknoledgement memory type (nGnRE), meaning
  that the write may only have made it as far as some interconnect
  by the time the store is considered "done"

- the GIC itself is allowed to buffer the write until it decides to
  take it into account (as long as it is in finite time)

The effects are that the activation may not have taken effect by the
time we enter the guest, forcing an immediate exit, or that a guest
deactivation occurs before the interrupt is active, doing nothing.

In order to guarantee that the write to the ISACTIVER register has
taken effect, read back from it, forcing the interconnect to propagate
the write, and the GIC to process the write before returning the read.

Reported-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/irqchip/irq-gic-v3.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index ce87205e3e823..8b6159f4cdafa 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -524,6 +524,13 @@ static int gic_irq_set_irqchip_state(struct irq_data *d,
 	}
 
 	gic_poke_irq(d, reg);
+
+	/*
+	 * Force read-back to guarantee that the active state has taken
+	 * effect, and won't race with a guest-driven deactivation.
+	 */
+	if (reg == GICD_ISACTIVER)
+		gic_peek_irq(d, reg);
 	return 0;
 }
 
-- 
2.39.2

