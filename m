Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980E222ACF7
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748526999; cv=none; b=nJi/Cd2YNJeNNNA5mG0vnG9PFLDWTtruPHKTrYxE+RVGM264P9Azhb/tGE8neKBt2FkvDRK3D1On7NcU7N0Qrla2xI5DTW/xjgYLjixihXhS5oVwDQt3vlGhiKVSkPX06Ql9mnReRzwKLU/PN5kS9o/esX2aktMJoJ0P3zQClCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748526999; c=relaxed/simple;
	bh=5fTJLd7EhK852DeJrAtN+i7rSWq49oDKwQIhCpklYvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JBrH31Cful/0FFhOMeos/GSkOjeZOUzrduQ0vBODO1SjSiagTrzK97rJLVWVqiAEd7HxZbI3ZYXtX6gsdLqrbVZ+ZEu+gIm3jv0bVfn8EHzkliZTgcFSu2p62/vQ9y5wsn2eoLqOyy2PB+0ugChbvLDd8CfBkpZFGttUctR+TTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7714C2454;
	Thu, 29 May 2025 06:56:21 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A24F43F673;
	Thu, 29 May 2025 06:56:36 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v2 5/9] arm64: micro-bench: fix timer IRQ
Date: Thu, 29 May 2025 14:55:53 +0100
Message-Id: <20250529135557.2439500-6-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250529135557.2439500-1-joey.gouly@arm.com>
References: <20250529135557.2439500-1-joey.gouly@arm.com>
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

