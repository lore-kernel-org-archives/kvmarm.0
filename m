Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6007BC433E6
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:50:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A16423355
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A16423355
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9274F4B3DA;
	Thu,  7 Jan 2021 06:50:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ly0eosGgQLEV; Thu,  7 Jan 2021 06:50:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 933024B3E5;
	Thu,  7 Jan 2021 06:50:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 927EA4B3DC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:50:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z53Aul8xwyQN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 06:50:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A1144B3E5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:50:54 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AAD5323340;
 Thu,  7 Jan 2021 11:50:53 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxTM9-005p1o-EH; Thu, 07 Jan 2021 11:21:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 15/18] KVM: arm64: Fix hyp_cpu_pm_{init,
 exit} __init annotation
Date: Thu,  7 Jan 2021 11:20:58 +0000
Message-Id: <20210107112101.2297944-16-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com,
 shannon.zhao@linux.alibaba.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Qian Cai <qcai@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, kvmarm@lists.cs.columbia.edu
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

The __init annotations on hyp_cpu_pm_{init,exit} are obviously incorrect,
and the build system shouts at you if you enable DEBUG_SECTION_MISMATCH.

Nothing really bad happens as we never execute that code outside of the
init context, but we can't label the callers as __int either, as kvm_init
isn't __init itself. Oh well.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20201223120854.255347-1-maz@kernel.org
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ab782c480e9a..04c44853b103 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1568,12 +1568,12 @@ static struct notifier_block hyp_init_cpu_pm_nb = {
 	.notifier_call = hyp_init_cpu_pm_notifier,
 };
 
-static void __init hyp_cpu_pm_init(void)
+static void hyp_cpu_pm_init(void)
 {
 	if (!is_protected_kvm_enabled())
 		cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
-static void __init hyp_cpu_pm_exit(void)
+static void hyp_cpu_pm_exit(void)
 {
 	if (!is_protected_kvm_enabled())
 		cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
