Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C866C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 16:45:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60D322075E
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 16:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="SbbHMC13"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60D322075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9561B4B2EE;
	Thu, 10 Sep 2020 12:45:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D0z1xavmPQrW; Thu, 10 Sep 2020 12:45:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A13D4B2D7;
	Thu, 10 Sep 2020 12:45:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B481E4B2D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 12:45:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yftP+xfBY2dW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 12:45:49 -0400 (EDT)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com
 [207.171.190.10])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 938FD4B2CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 12:45:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1599756349; x=1631292349;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=9ENEb+OWsMgLP7SddzClIgFi508ntq+tzSER6yva+Q4=;
 b=SbbHMC13/PUO/X3wkR2v8FxEgpeCfj6H/DJyVAbwPsqeZGvyf788kOGs
 i9ovkf/1z1srxSPNkATCDADHyVHb8A0fUF3nTA+QFj6Hts8TZHgB0HM3m
 CMp2QGbURvU7NiNrJeue3K50NO4V8CGkIyuxruy2Og13eblfds11ek4KP Q=;
X-IronPort-AV: E=Sophos;i="5.76,413,1592870400"; d="scan'208";a="73955160"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO
 email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
 by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP;
 10 Sep 2020 16:42:59 +0000
Received: from EX13MTAUWC002.ant.amazon.com
 (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
 by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS
 id 80B89A240F; Thu, 10 Sep 2020 16:42:56 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 16:42:53 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 16:42:51 +0000
From: Alexander Graf <graf@amazon.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [PATCH v3] KVM: arm64: Preserve PMCR immutable values across reset
Date: Thu, 10 Sep 2020 18:42:43 +0200
Message-ID: <20200910164243.29253-1-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D40UWA004.ant.amazon.com (10.43.160.36) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>
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

We allow user space to set the PMCR register to any value. However,
when time comes for a vcpu reset (for example on PSCI online), PMCR
is reset to the hardware capabilities.

I would like to explicitly expose different PMU capabilities (number
of supported event counters) to the guest than hardware supports.
Ideally across vcpu resets.

So this patch adopts the reset path to only populate the immutable
PMCR register bits from hardware when they were not initialized
previously. This effectively means that on a normal reset, only the
guest settable fields are reset, while on vcpu creation the register
gets populated from hardware like before.

With this in place and a change in user space to invoke SET_ONE_REG
on the PMCR for every vcpu, I can reliably set the PMU event counter
number to arbitrary values.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/arm64/kvm/sys_regs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 20ab2a7d37ca..28f67550db7f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -663,7 +663,14 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr, val;
 
-	pmcr = read_sysreg(pmcr_el0);
+	/*
+	 * If we already received PMCR from a previous ONE_REG call,
+	 * maintain its immutable flags
+	 */
+	pmcr = __vcpu_sys_reg(vcpu, r->reg);
+	if (!__vcpu_sys_reg(vcpu, r->reg))
+		pmcr = read_sysreg(pmcr_el0);
+
 	/*
 	 * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
 	 * except PMCR.E resetting to zero.
-- 
2.16.4




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
