Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA23CCA473
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 07:21:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC6D4C07D;
	Wed,  6 Jul 2022 03:21:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@quicinc.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zai7iavQ3ZjC; Wed,  6 Jul 2022 03:21:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 029FB4C06D;
	Wed,  6 Jul 2022 03:21:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C69804BFA5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2022 12:57:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nplJKHXku7+u for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jul 2022 12:57:26 -0400 (EDT)
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com
 [199.106.114.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 860FC4BF97
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2022 12:57:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
 t=1657040246; x=1688576246;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=gy7zdpSIRmyfnnx+9IyNxg2E2VUlmif7PnWPjxZ65OU=;
 b=pGzEfJo0wcm6uhukDdamu6P38ySoUO8zwuDnPkv2wTn75PFrXzV8BJR1
 gjKE5fK3L2vs3k3ov+lIzYufddsJnziFZQpXmYyIG9wJZOPRI9F5dBdZW
 +ne22clXED32TPnSHHyunR/RjLSmkgOYRlLH8QYWYGbSI4eUq1cXxKyFr k=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
 by alexa-out-sd-02.qualcomm.com with ESMTP; 05 Jul 2022 09:57:25 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
 by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jul 2022 09:57:25 -0700
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 5 Jul 2022 09:57:24 -0700
Received: from debian-BULLSEYE-live-builder-AMD64 (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 5 Jul 2022 09:57:24 -0700
Date: Tue, 5 Jul 2022 09:57:22 -0700
From: Calvin Owens <quic_calvinow@quicinc.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [RFC PATCH v5 15/38] perf: arm_spe_pmu: Move struct arm_spe_pmu
 to a separate header file
Message-ID: <YsRtcvxyufSCoIE5@debian-BULLSEYE-live-builder-AMD64>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-16-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211117153842.302159-16-alexandru.elisei@arm.com>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-Mailman-Approved-At: Wed, 06 Jul 2022 03:21:23 -0400
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Alexandru,

I've been taking a look at this series, it needs a little tweak to
build successfully as a module which I've appended below.

Cheers,
Calvin

On Wed, Nov 17, 2021 at 03:38:19PM +0000, Alexandru Elisei wrote:
> KVM will soon want to make use of struct arm_spe_pmu, move it to a separate
> header where it will be easily accessible. This is a straightforward move
> and functionality should not be impacted.
>
> CC: Will Deacon <will@kernel.org>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---

<snip>

> +++ b/include/linux/perf/arm_spe_pmu.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Split from from drivers/perf/arm_spe_pmu.c.
> + *
> + *  Copyright (C) 2021 ARM Limited
> + */
> +
> +#ifndef __ARM_SPE_PMU_H__
> +#define __ARM_SPE_PMU_H__
> +
> +#include <linux/cpumask.h>
> +#include <linux/perf_event.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_ARM_SPE_PMU

Here, we need to use the IS_ENABLED() macro for the ARM_SPE_PMU=m case.

Signed-off-by: Calvin Owens <calvinow@qti.qualcomm.com>
---
 include/linux/perf/arm_spe_pmu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
index 505a8867daad..b643e5e7a766 100644
--- a/include/linux/perf/arm_spe_pmu.h
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -13,7 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 
-#ifdef CONFIG_ARM_SPE_PMU
+#if IS_ENABLED(CONFIG_ARM_SPE_PMU)
 
 struct arm_spe_pmu {
 	struct pmu				pmu;
@@ -50,6 +50,6 @@ void kvm_host_spe_init(struct arm_spe_pmu *spe_pmu);
 #define kvm_host_spe_init(x)	do { } while(0)
 #endif
 
-#endif /* CONFIG_ARM_SPE_PMU */
+#endif /* IS_ENABLED(CONFIG_ARM_SPE_PMU) */
 
 #endif /* __ARM_SPE_PMU_H__ */
-- 
2.30.2
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
