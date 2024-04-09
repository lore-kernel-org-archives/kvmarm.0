Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC0135894
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712626210; cv=none; b=Z9cqC6o5kEOkxCChJsKBorczHmu4Pd9obA+pY0Th4EyCz47Wp0ComvDenxb2tk8mlg0j5SLlNp/yp9z/hWWH0Bk63qMycdfSuGyFW9hHDybmeszhovDCaRjrsI5hXIMTmL0K6vQ+lqG3SCFMFPP385VfdPuN3k0qK1xsQwhOCvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712626210; c=relaxed/simple;
	bh=MuHFOgP+VINNMeVH16+DixeNsqv/i9paZgGXoPbFS4c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAZVveoEerqCvVNrBpCVxrJu0sNXwmBwtdHqRuBabQZ5w62JD91R5JLaEUHMr9PSCIRxkRVU5v0nNWU2M6wBmtSg65i2TaCI+hEmMhBsS/vkmjOUc3pvAabXpmZFlxPmvTkMKbEx7hm1U1gwNuDUVPm0ua9SujKgoE+TczowlbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VD7c04CDRzwRfS;
	Tue,  9 Apr 2024 09:27:12 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 0FA9F14059C;
	Tue,  9 Apr 2024 09:30:06 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Tue, 9 Apr
 2024 09:30:04 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <mark.rutland@arm.com>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<anshuman.khandual@arm.com>, <miguel.luis@oracle.com>, <joey.gouly@arm.com>,
	<ryan.roberts@arm.com>, <jeremy.linton@arm.com>, <liwei391@huawei.com>,
	<daniel.thompson@linaro.org>, <sumit.garg@linaro.org>,
	<kristina.martsenko@arm.com>, <jpoimboe@kernel.org>, <ericchancf@google.com>,
	<robh@kernel.org>, <scott@os.amperecomputing.com>,
	<songshuaishuai@tinylab.org>, <shijie@os.amperecomputing.com>,
	<bhe@redhat.com>, <akpm@linux-foundation.org>, <thunder.leizhen@huawei.com>,
	<horms@kernel.org>, <rmk+kernel@armlinux.org.uk>, <takakura@valinux.co.jp>,
	<dianders@chromium.org>, <swboyd@chromium.org>, <frederic@kernel.org>,
	<reijiw@google.com>, <akihiko.odaki@daynix.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH 9/9] irqchip/gic-v3: Improve the maintainability of NMI masking in GIC driver
Date: Tue, 9 Apr 2024 01:23:44 +0000
Message-ID: <20240409012344.3194724-10-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240409012344.3194724-1-liaochang1@huawei.com>
References: <20240409012344.3194724-1-liaochang1@huawei.com>
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

It has a better maintainability to use the local_nmi_enable() in GIC
driver to unmask NMI and keep regular IRQ and FIQ maskable, instead of
writing raw value into DAIF, PMR and ALLINT directly.

Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/include/asm/daifflags.h | 13 +++++++++++++
 drivers/irqchip/irq-gic-v3.c       |  6 ++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index b831def08bb3..1196eb85aa8d 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -330,4 +330,17 @@ static inline void local_errnmi_enable(void)
 	irqflags.fields.allint = 0;
 	local_allint_restore(irqflags);
 }
+
+/*
+ * local_nmi_enable - Enable NMI with or without superpriority.
+ */
+static inline void local_nmi_enable(void)
+{
+	arch_irqflags_t irqflags;
+
+	irqflags.fields.daif = read_sysreg(daif);
+	irqflags.fields.pmr = GIC_PRIO_IRQOFF;
+	irqflags.fields.allint = 0;
+	local_allint_restore(irqflags);
+}
 #endif
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 6fb276504bcc..ed7d8d87768f 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -33,6 +33,7 @@
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
 #include <asm/virt.h>
+#include <asm/daifflags.h>
 
 #include "irq-gic-common.h"
 
@@ -813,10 +814,7 @@ static void __gic_handle_irq_from_irqson(struct pt_regs *regs)
 		nmi_exit();
 	}
 
-	if (gic_prio_masking_enabled()) {
-		gic_pmr_mask_irqs();
-		gic_arch_enable_irqs();
-	}
+	local_nmi_enable();
 
 	if (!is_nmi)
 		__gic_handle_irq(irqnr, regs);
-- 
2.34.1

