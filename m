Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9753BBCA
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 06:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713164083; cv=none; b=ogcvrhek66nyE07zSkzKqbJq0vpHL+sVVRxkkJh5Xr2TruyAH648wu6DZIXFcrRoZZfXeecLGQApC+JnSUjWx+pQM3tDQgPwvHJA8PkU3SI7ZjHYnXE8MU3EQhEChfqoJq2s6wJVNERYjT5GboCfBVtvGJOgXYnjVkHqzTSeJ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713164083; c=relaxed/simple;
	bh=L8BIW94zJz6w7DHCRiCf2wXwkrC31h4lsroI1eHffbU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nX5hDPa9XiL/KhGzS/nfWBFe2KQCBpDMLaBhuJtQY2fP9SsilzaGu5LLiq61sO+7dir5xV6fAd7KJ2o3v+rZbRJKO6piDrpprACfT0k515bcXUusUUcc97HEOs0nzO1YzJiLcoVoy+JRb+b45l87lEX0FJ0+m402huPtosh6GvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VHyYv5H45zYdgf;
	Mon, 15 Apr 2024 14:53:39 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C60F1400CD;
	Mon, 15 Apr 2024 14:54:40 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Mon, 15 Apr
 2024 14:54:28 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <james.morse@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <tglx@linutronix.de>, <mark.rutland@arm.com>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<anshuman.khandual@arm.com>, <miguel.luis@oracle.com>, <joey.gouly@arm.com>,
	<ryan.roberts@arm.com>, <jeremy.linton@arm.com>, <ericchancf@google.com>,
	<kristina.martsenko@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<shijie@os.amperecomputing.com>, <akpm@linux-foundation.org>,
	<bhe@redhat.com>, <horms@kernel.org>, <mhiramat@kernel.org>,
	<rmk+kernel@armlinux.org.uk>, <shahuang@redhat.com>,
	<takakura@valinux.co.jp>, <dianders@chromium.org>, <swboyd@chromium.org>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <reijiw@google.com>,
	<akihiko.odaki@daynix.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v3 8/8] arm64: kprobe: Keep NMI maskabled while kprobe is stepping xol
Date: Mon, 15 Apr 2024 06:47:58 +0000
Message-ID: <20240415064758.3250209-9-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240415064758.3250209-1-liaochang1@huawei.com>
References: <20240415064758.3250209-1-liaochang1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200013.china.huawei.com (7.221.188.133)

Keeping NMI maskable while executing instruction out of line, otherwise,
add kprobe on the functions invoken while handling NMI will cause kprobe
reenter bug and kernel panic.

Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/include/asm/daifflags.h | 2 ++
 arch/arm64/kernel/probes/kprobes.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 1196eb85aa8d..60fd3b25fd73 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -17,6 +17,8 @@
 #define DAIF_PROCCTX_NOIRQ	(PSR_I_BIT | PSR_F_BIT)
 #define DAIF_ERRCTX		(PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
 #define DAIF_MASK		(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+#define DAIF_ALLINT_MASK	\
+	(system_uses_nmi() ? (ALLINT_ALLINT | DAIF_MASK) : (DAIF_MASK))
 
 /*
  * For Arm64 processor support Armv8.8 or later, kernel supports three types
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 327855a11df2..e8c2b993bbb8 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -187,13 +187,13 @@ static void __kprobes kprobes_save_local_irqflag(struct kprobe_ctlblk *kcb,
 						struct pt_regs *regs)
 {
 	kcb->saved_irqflag = regs->pstate & DAIF_MASK;
-	regs->pstate |= DAIF_MASK;
+	regs->pstate |= DAIF_ALLINT_MASK;
 }
 
 static void __kprobes kprobes_restore_local_irqflag(struct kprobe_ctlblk *kcb,
 						struct pt_regs *regs)
 {
-	regs->pstate &= ~DAIF_MASK;
+	regs->pstate &= ~DAIF_ALLINT_MASK;
 	regs->pstate |= kcb->saved_irqflag;
 }
 
-- 
2.34.1

