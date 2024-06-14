Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F323C149015
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 03:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337167; cv=none; b=UQYaNTzYs473aCGzDPSvPintTHN1YiEwx7O/JgdRrNtZSOlP8j10AAaUGdmtfHc4zJY8jgqxmnm5OfifHb+LtZxcB7tjAuVASWu1PB0Kl4kwuHMHmy0GxKxhO8VtVxUyTDwdqgnsyPr5svN+g1t6QQGgjbDhUiAyPOKsk25WuZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337167; c=relaxed/simple;
	bh=3b6XfMno8+4n4EqZ9lxkLrX8g0WRF7mmCdlLm00FDKY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I62FSfnulCWw1qTBZoZomK7DUplzZ8985GRq8TFygSAxaTT907lYSnvrKUNT/8ricUs+fJSzsdIUJJp15tN89EzVKS8nCGFrwalOT+ftwTWL3SV5opX2DsrWwCExJZMLxKA5d0+ohbouiEGvNkoyfQkWcB49xVTqpeMDhPCVPWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4W0lcb2LsMz1SBcM;
	Fri, 14 Jun 2024 11:48:31 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 36DBD180060;
	Fri, 14 Jun 2024 11:52:39 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 14 Jun
 2024 11:52:37 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <ryabinin.a.a@gmail.com>,
	<glider@google.com>, <andreyknvl@gmail.com>, <dvyukov@google.com>,
	<vincenzo.frascino@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<mark.rutland@arm.com>, <lpieralisi@kernel.org>, <tglx@linutronix.de>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<steven.price@arm.com>, <ryan.roberts@arm.com>, <pcc@google.com>,
	<anshuman.khandual@arm.com>, <eric.auger@redhat.com>,
	<miguel.luis@oracle.com>, <shiqiliu@hust.edu.cn>, <quic_jiles@quicinc.com>,
	<rafael@kernel.org>, <sudeep.holla@arm.com>, <dwmw@amazon.co.uk>,
	<joey.gouly@arm.com>, <jeremy.linton@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<swboyd@chromium.org>, <dianders@chromium.org>,
	<shijie@os.amperecomputing.com>, <bhe@redhat.com>,
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <mhiramat@kernel.org>,
	<mcgrof@kernel.org>, <rmk+kernel@armlinux.org.uk>,
	<Jonathan.Cameron@huawei.com>, <takakura@valinux.co.jp>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <tabba@google.com>,
	<kristina.martsenko@arm.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kasan-dev@googlegroups.com>, <kvmarm@lists.linux.dev>
Subject: [PATCH v4 09/10] arm64: irqchip/gic-v3: Simplify NMI handling in IRQs disabled context
Date: Fri, 14 Jun 2024 03:44:32 +0000
Message-ID: <20240614034433.602622-10-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240614034433.602622-1-liaochang1@huawei.com>
References: <20240614034433.602622-1-liaochang1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200013.china.huawei.com (7.221.188.133)

After the recent refactoring to the exception entry code, the value of
PMR is not set to GIC_PRIO_IRQ_ON | GIC_PRIO_IRQ_I_SET unconditionally.
If kernel traps from IRQs disabled context, the PMR happens to
GIC_PRIO_IRQ_OFF, which allow only PESUDO_NMI could be acknowledged.
This patch leverage this fact to remove the unnecessary dropping of PMR
in NMI handler.

Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/kernel/entry-common.c |  4 ++--
 drivers/irqchip/irq-gic-v3.c     | 23 +----------------------
 2 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index eabfc80df6fb..fb3f5b772f57 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -531,6 +531,8 @@ static __always_inline void __el1_pnmi(struct pt_regs *regs,
 static __always_inline void __el1_irq(struct pt_regs *regs,
 				      void (*handler)(struct pt_regs *))
 {
+	local_nmi_disable();
+
 	enter_from_kernel_mode(regs);
 
 	irq_enter_rcu();
@@ -544,8 +546,6 @@ static __always_inline void __el1_irq(struct pt_regs *regs,
 static void noinstr el1_interrupt(struct pt_regs *regs,
 				  void (*handler)(struct pt_regs *))
 {
-	local_nmi_disable();
-
 	if (IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) && !interrupts_enabled(regs))
 		__el1_pnmi(regs, handler);
 	else
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index ed7d8d87768f..de869051039b 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -831,28 +831,7 @@ static void __gic_handle_irq_from_irqson(struct pt_regs *regs)
  */
 static void __gic_handle_irq_from_irqsoff(struct pt_regs *regs)
 {
-	u64 pmr;
-	u32 irqnr;
-
-	/*
-	 * We were in a context with IRQs disabled. However, the
-	 * entry code has set PMR to a value that allows any
-	 * interrupt to be acknowledged, and not just NMIs. This can
-	 * lead to surprising effects if the NMI has been retired in
-	 * the meantime, and that there is an IRQ pending. The IRQ
-	 * would then be taken in NMI context, something that nobody
-	 * wants to debug twice.
-	 *
-	 * Until we sort this, drop PMR again to a level that will
-	 * actually only allow NMIs before reading IAR, and then
-	 * restore it to what it was.
-	 */
-	pmr = gic_read_pmr();
-	gic_pmr_mask_irqs();
-	isb();
-	irqnr = gic_read_iar();
-	gic_write_pmr(pmr);
-
+	u32 irqnr = gic_read_iar();
 	__gic_handle_nmi(irqnr, regs);
 }
 
-- 
2.34.1

