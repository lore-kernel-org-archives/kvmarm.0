Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BFA5395263
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391936; cv=none; b=H3ToLxxt8a58rSuW1FWwo55/iYtpp/Iop2Zwtwc3K7yLyAxWVnwLIDwdAuY2fkHvPLHPmAn/CrjYpMqS09lazeq0rU9CkqpceeMYWDnZ3oTZlWIPa7VIyCcnvduEXzXvCqv4ce7SKxIL9/sk6FfDquXKkCkxEA/3tFfQffEzafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391936; c=relaxed/simple;
	bh=5Xa/4hMBwEDLr2+U6g5jxWbi7nnAh7Ae7M4ocHae6jA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=prcRxXYN3EZEdqBFoVRa4x5H2rN0IGx8sDYn8J/0qBKLr14yd/0DdDniTBrzewv0uwpgkIX3wvI22RZNVUIkcwrr8ENwh/Ow81UazAYRmxtQVDq4am1MiIYXZkumgQO2PIxefaByjL65ZCUMRUlEUL3c72BdEG3vgQx7mVwy2tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2587C1515;
	Wed, 14 Jan 2026 03:58:47 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D8AF3F632;
	Wed, 14 Jan 2026 03:58:52 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 06/11] arm64: micro-bench: fix timer IRQ
Date: Wed, 14 Jan 2026 11:56:58 +0000
Message-Id: <20260114115703.926685-7-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable the correct (hvtimer) IRQ when at EL2.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
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

