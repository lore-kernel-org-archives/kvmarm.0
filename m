Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250F1C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 12:21:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9558A2082E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 12:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Fl5lUKNJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9558A2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B484B4EB;
	Thu, 30 Jul 2020 08:21:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rWHWyhqqV+ti; Thu, 30 Jul 2020 08:21:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB5404B4DE;
	Thu, 30 Jul 2020 08:21:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7620C4B246
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 05:44:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7pJfb2FehP3x for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 05:44:55 -0400 (EDT)
Received: from smtp-fw-4101.amazon.com (smtp-fw-4101.amazon.com [72.21.198.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CB224B220
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 05:44:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1596102295; x=1627638295;
 h=from:to:cc:subject:date:message-id:mime-version;
 bh=yS8mB8k1qRFT2l/VsyZ2ew82E3uftJGYIBk/EhMUB+U=;
 b=Fl5lUKNJ3098Ie+yce7XxL9yfXsqGAXQpGHAwLGiPPfeJesViH1RvWa2
 KzBkE/X0v4dQ7xZJTFekoIJeVPmz6+JM/BXymkO9EgbxlM51jDWHc1C+P
 PL2ax23y2hqTltnyq6/T+e8tn/+f5BL024a+mTJjcxUZ2UafXFvL+kpR2 E=;
IronPort-SDR: CNk0xcG7ruz5shy5cGY4vfa2ZvAScrDvqnMExmPxQqHBcsX6Cy4H74gs+egxCgIkZa0eG1uVKb
 JMObEUP2Y+fA==
X-IronPort-AV: E=Sophos;i="5.75,414,1589241600"; d="scan'208";a="45130693"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.6])
 by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP;
 30 Jul 2020 09:44:54 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
 by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS
 id D50C8A25A6; Thu, 30 Jul 2020 09:44:51 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 09:44:51 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.85) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 09:44:49 +0000
From: Alexander Graf <graf@amazon.com>
To: <kvm@vger.kernel.org>
Subject: [PATCH] KVM: arm: Add trace name for ARM_NISV
Date: Thu, 30 Jul 2020 11:44:41 +0200
Message-ID: <20200730094441.18231-1-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
X-Mailman-Approved-At: Thu, 30 Jul 2020 08:21:43 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu
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

Commit c726200dd106d ("KVM: arm/arm64: Allow reporting non-ISV data aborts
to userspace") introduced a mechanism to deflect MMIO traffic the kernel
can not handle to user space. For that, it introduced a new exit reason.

However, it did not update the trace point array that gives human readable
names to these exit reasons inside the trace log.

Let's fix that up after the fact, so that trace logs are pretty even when
we get user space MMIO traps on ARM.

Fixes: c726200dd106d ("KVM: arm/arm64: Allow reporting non-ISV data aborts to userspace")
Signed-off-by: Alexander Graf <graf@amazon.com>
---
 include/trace/events/kvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 2c735a3e6613..9417a34aad08 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -17,7 +17,7 @@
 	ERSN(NMI), ERSN(INTERNAL_ERROR), ERSN(OSI), ERSN(PAPR_HCALL),	\
 	ERSN(S390_UCONTROL), ERSN(WATCHDOG), ERSN(S390_TSCH), ERSN(EPR),\
 	ERSN(SYSTEM_EVENT), ERSN(S390_STSI), ERSN(IOAPIC_EOI),          \
-	ERSN(HYPERV)
+	ERSN(HYPERV), ERSN(ARM_NISV)
 
 TRACE_EVENT(kvm_userspace_exit,
 	    TP_PROTO(__u32 reason, int errno),
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
