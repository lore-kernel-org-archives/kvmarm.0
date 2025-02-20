Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5941FAC4C
	for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060857; cv=none; b=rJZ5X0VGh6fpecCi9t8MwW/asxnDwRU12M31k1Qzdg9EGCIDcn8xBl7M5vWKGrCWnIzIkwBpNFG875mgPSR9DhyUEKio+ShXN4tT37Ectvnv02lRuNOSwrylfJENCSeHqpNOMd/RnqBV0DP6RQcI9osof6N815kJwLPBLH7X19U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060857; c=relaxed/simple;
	bh=rDD0jeK/FcB4BgVzf8PzomA+p3S4UOW3YEX+uNBZgvM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VuJdYBgw83a+diu8ZwPpfDnM+zBQGCwhrAUm5yfW2Svfj633ou0POWeGUc8TUuWBRngvb+IOkdUk/xh4dZeJUMUdZLevY6WLXhpBcVBA1NVAxuLlqo2R2pvy1iT2+spP+Nog9MCfusEskm5kpiu2sBUewjqqF9aHTvhWmR9jtEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 843DB22EE;
	Thu, 20 Feb 2025 06:14:32 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B8F23F59E;
	Thu, 20 Feb 2025 06:14:12 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	drjones@redhat.com,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v1 3/7] arm64: micro-bench: fix timer IRQ
Date: Thu, 20 Feb 2025 14:13:50 +0000
Message-Id: <20250220141354.2565567-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250220141354.2565567-1-joey.gouly@arm.com>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable the correct (hvtimer) IRQ when at EL2.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/micro-bench.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 22408955..f47c5fc1 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -42,7 +42,7 @@ static void gic_irq_handler(struct pt_regs *regs)
 	irq_received = true;
 	gic_write_eoir(irqstat);
 
-	if (irqstat == TIMER_VTIMER_IRQ) {
+	if (irqstat == TIMER_VTIMER_IRQ || irqstat == TIMER_HVTIMER_IRQ) {
 		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
 			     cntv_ctl_el0);
 		isb();
@@ -215,7 +215,11 @@ static bool timer_prep(void)
 	install_irq_handler(EL1H_IRQ, gic_irq_handler);
 	local_irq_enable();
 
-	gic_enable_irq(TIMER_VTIMER_IRQ);
+	if (current_level() == CurrentEL_EL1)
+		gic_enable_irq(TIMER_VTIMER_IRQ);
+	else
+		gic_enable_irq(TIMER_HVTIMER_IRQ);
+
 	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
 	isb();
 
-- 
2.25.1

