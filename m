Return-Path: <SRS0=ypkC=LK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A67C48BE5
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 12:08:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A08861351
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 12:08:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A08861351
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63EFA4B0B1;
	Wed, 16 Jun 2021 08:08:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y8z1BB17EhNf; Wed, 16 Jun 2021 08:08:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F9ED4B092;
	Wed, 16 Jun 2021 08:08:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C110A4A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 05:17:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dhIitfIdgN6A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jun 2021 05:17:44 -0400 (EDT)
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com
 [99.78.197.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD40B40895
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 05:17:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
 t=1623835065; x=1655371065;
 h=message-id:subject:from:to:cc:date:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=r+ZKwNeW5+Ab+uKUwYJ3MzcAyLyTzZ/8NFhKVY+sNA8=;
 b=cjfmb/Id2WBuwFzhPsQ4RBjDhjZDlufaNUxB6tOEoc5mwZ4YwD4bhvoy
 T6V7XQ2vrLd7e0yVXUiZiscF23LJ7+8MahkNmLVx3S7NlBr51hbg5KylH
 yt49QbalUIRfl8mCjfL+8wzk0Vz1JiIQ6drB+AszeBwHO7N9Z12jCq5sI k=;
X-IronPort-AV: E=Sophos;i="5.83,277,1616457600"; 
   d="scan'208";a="6906837"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO
 email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.25.36.210])
 by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP;
 16 Jun 2021 09:17:36 +0000
Received: from EX13D39EUC002.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
 by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS
 id C78C6A0499; Wed, 16 Jun 2021 09:17:35 +0000 (UTC)
Received: from freeip.amazon.com (10.43.161.201) by
 EX13D39EUC002.ant.amazon.com (10.43.164.187) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 16 Jun 2021 09:17:32 +0000
Message-ID: <131663dbe335646ac952c55d6271022a42fa382f.camel@amazon.de>
Subject: Re: KVM: arm64: pmu: Reset sample period on overflow handling
From: Aman Priyadarshi <apeureka@amazon.de>
To: Marc Zyngier <maz@kernel.org>
Date: Wed, 16 Jun 2021 11:17:28 +0200
In-Reply-To: <87lf7bhxcf.wl-maz@kernel.org>
References: <322843db2f986f418d4175ca9c10e0904aa81d7a.camel@amazon.de>
 <87lf7bhxcf.wl-maz@kernel.org>
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-Originating-IP: [10.43.161.201]
X-ClientProxiedBy: EX13D27UWB003.ant.amazon.com (10.43.161.195) To
 EX13D39EUC002.ant.amazon.com (10.43.164.187)
X-Mailman-Approved-At: Wed, 16 Jun 2021 08:08:55 -0400
Cc: Alexander Graf <graf@amazon.com>, kvmarm@lists.cs.columbia.edu, Ali
 Saidi <alisaidi@amazon.com>
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

Hi Marc,

On Tue, 2021-06-15 at 18:05 +0100, Marc Zyngier wrote:
> 
> Can you reproduce the issue with vanilla guest kernels? It'd be
> interesting to understand what makes it work on the guest side. Can
> you please bisect it?
> 

yes, I was able to narrow it down to the commit 0cbb058be904 ("arm64: perf:
Disable PMU while processing counter overflows"), which fixes the problem
on the guest side.

I _think_, I understand the problem now. Please correct me if I am wrong.

commit 30d97754b2d1 ("KVM: arm/arm64: Re-create event when setting counter
value") adds a new code path for perf event when counter value is set,
therefore kvm would generate more events than before. Without this change,
we have a lot less events, thus reducing the chances of guest messing
things up.

On the other side, commit 8c3252c06516 ("KVM: arm64: pmu: Reset sample
period on overflow handling") resets the sample period to the max value,
thus reducing the number of overflow events to guest to an optimal value
(note, number of interrupts actually handled by guest would remain same in
either case). Less number of overflow interrupts to the guest, reduces the
chance of guest making up for any left over overflow event that it did not
see earlier.

Thanks,
Aman Priyadarshi





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
