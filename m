Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900B4C47409
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:26:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4886A21734
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 13:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTWZtgAx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4886A21734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 016004AE96;
	Thu, 30 Jan 2020 08:26:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wqBLB83CEOrR; Thu, 30 Jan 2020 08:26:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C511C4AEB4;
	Thu, 30 Jan 2020 08:26:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3CE4ACF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:26:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IwFJ84ekLCZQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 08:26:16 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F2A44AEBE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 08:26:15 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3CF9B2082E;
 Thu, 30 Jan 2020 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580390774;
 bh=NYzjf0zBc57FKJJDgjapRNI+QmFi9nWATVOeClefQhI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hTWZtgAxp7FMLlcdTrGI/LKfpXKipOUfJpGXB02hvdZ77W0WNUO2ADsSPPgQRrUv6
 KCAqdxCo+Yo9qxT9NRUmKLX6wRESDUWF3XJiHbhUiwK3n3mGOgcQzXO/gJD57zJmAG
 0ydZmR5Scq/GMzKHDIUZjTqoWBwrTu8cmogcgsgY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1ix9pk-002BmW-Jg; Thu, 30 Jan 2020 13:26:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 05/23] KVM: ARM: Call hyp_cpu_pm_exit at the right place
Date: Thu, 30 Jan 2020 13:25:40 +0000
Message-Id: <20200130132558.10201-6-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org,
 christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com,
 wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org,
 mark.rutland@arm.com, rmk+kernel@armlinux.org.uk,
 shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org,
 yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 YueHaibing <yuehaibing@huawei.com>, Steven Price <steven.price@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 Russell King <rmk+kernel@armlinux.org.uk>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Andrew Murray <andrew.murray@arm.com>
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

From: Shannon Zhao <shannon.zhao@linux.alibaba.com>

It doesn't needs to call hyp_cpu_pm_exit() in init_hyp_mode() when some
error occurs. hyp_cpu_pm_exit() only needs to be called in
kvm_arch_init() if init_subsystems() fails. So move hyp_cpu_pm_exit()
out from teardown_hyp_mode() and call it directly in kvm_arch_init().

Signed-off-by: Shannon Zhao <shannon.zhao@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1575272531-3204-1-git-send-email-shannon.zhao@linux.alibaba.com
---
 virt/kvm/arm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 8de4daf25097..b5d57ed6443c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1537,7 +1537,6 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu)
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
-	hyp_cpu_pm_exit();
 }
 
 /**
@@ -1751,6 +1750,7 @@ int kvm_arch_init(void *opaque)
 	return 0;
 
 out_hyp:
+	hyp_cpu_pm_exit();
 	if (!in_hyp_mode)
 		teardown_hyp_mode();
 out_err:
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
