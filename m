Return-Path: <SRS0=ypkC=LK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A078DC48BE6
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 12:08:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37ADB61245
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 12:08:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37ADB61245
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF7194B0A5;
	Wed, 16 Jun 2021 08:08:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3bCb2AFCUpAa; Wed, 16 Jun 2021 08:08:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DAC74B09E;
	Wed, 16 Jun 2021 08:08:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 571D04AEDC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 06:53:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ZMDFllld2fR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jun 2021 06:53:29 -0400 (EDT)
Received: from smtp-fw-4101.amazon.com (smtp-fw-4101.amazon.com [72.21.198.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A4694A19E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 06:53:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
 t=1623840809; x=1655376809;
 h=message-id:from:to:cc:date:in-reply-to:references:
 mime-version:content-transfer-encoding:subject;
 bh=pbee6tL8WFnoKVsCEcKvLOf70eO8JG4bQmkXlAHMbnQ=;
 b=iyLBuV7MVaxBzh53rqub2si0Ol7J4SM0Mn1IARXktJWZdAffW/DIVDGt
 +Sdhe5ddV8xk/QBhOVMAHvma9Phsr9X7jtAGKx7EUR0zuZGepnKq3FZXL
 lL/S3oS4F1WACPIJYnzoMSKGO28U+bC4nKGiKRQ3ZlnnoF+5EH1TTpPGU Q=;
X-IronPort-AV: E=Sophos;i="5.83,277,1616457600"; d="scan'208";a="114625335"
Subject: Re: KVM: arm64: pmu: Reset sample period on overflow handling
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.6])
 by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 16 Jun 2021 10:52:50 +0000
Received: from EX13D39EUC002.ant.amazon.com
 (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
 by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS
 id 040ABA28F6; Wed, 16 Jun 2021 10:52:49 +0000 (UTC)
Received: from freeip.amazon.com (10.43.162.228) by
 EX13D39EUC002.ant.amazon.com (10.43.164.187) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 16 Jun 2021 10:52:46 +0000
Message-ID: <094d40a0e7f5389ce5a13d96b96d4b7588c71d74.camel@amazon.de>
From: Aman Priyadarshi <apeureka@amazon.de>
To: Marc Zyngier <maz@kernel.org>
Date: Wed, 16 Jun 2021 12:52:42 +0200
In-Reply-To: <87lf7am77t.wl-maz@kernel.org>
References: <322843db2f986f418d4175ca9c10e0904aa81d7a.camel@amazon.de>
 <87lf7bhxcf.wl-maz@kernel.org>
 <131663dbe335646ac952c55d6271022a42fa382f.camel@amazon.de>
 <87lf7am77t.wl-maz@kernel.org>
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-Originating-IP: [10.43.162.228]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
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

On Wed, 2021-06-16 at 11:31 +0100, Marc Zyngier wrote:
> 
> Hi Aman,
> 
> On Wed, 16 Jun 2021 10:17:28 +0100,
> Aman Priyadarshi <apeureka@amazon.de> wrote:
> > 
> > Hi Marc,
> > 
> > On Tue, 2021-06-15 at 18:05 +0100, Marc Zyngier wrote:
> > > 
> > > Can you reproduce the issue with vanilla guest kernels? It'd be
> > > interesting to understand what makes it work on the guest side. Can
> > > you please bisect it?
> > > 
> > 
> > yes, I was able to narrow it down to the commit 0cbb058be904 ("arm64:
> > perf:
> > Disable PMU while processing counter overflows"), which fixes the
> > problem
> > on the guest side.
> 
> Which is 3cce50dfec4a5b0414c974190940f47dd32c6dee in mainline. This
> doesn't seem to have ever been backported before 4.18. So I don't know
> why your 4.15 kernel was correctly behaving, but it could be that the
> distro had randomly picked up the correct patch!

Yes. https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1836117

> 
> You may want to backport it to 4.14.y and let Greg know about that.
> 

Ack.

> > 
> > I _think_, I understand the problem now. Please correct me if I am
> > wrong.
> > 
> > commit 30d97754b2d1 ("KVM: arm/arm64: Re-create event when setting
> > counter
> > value") adds a new code path for perf event when counter value is set,
> > therefore kvm would generate more events than before. Without this
> > change,
> > we have a lot less events, thus reducing the chances of guest messing
> > things up.
> 
> Without this fix, we don't communicate the new guest sample period to
> the host's perf counter, and depending on what the guest wrote (and
> the previous value), it can go one way or the other.
> 
> > On the other side, commit 8c3252c06516 ("KVM: arm64: pmu: Reset sample
> > period on overflow handling") resets the sample period to the max
> > value,
> > thus reducing the number of overflow events to guest to an optimal
> > value
> > (note, number of interrupts actually handled by guest would remain same
> > in
> > either case). Less number of overflow interrupts to the guest, reduces
> > the
> > chance of guest making up for any left over overflow event that it did
> > not
> > see earlier.
> 
> This fix is the natural complement of the previous one. We need to
> emulate the actual overflow, and prevent perf from doing its thing on
> the host (reloading from the previously provided value). So we reset
> the period to the value that perf did observe on taking the physical
> interrupt.
> 
> Together, these two patches provide a more correct PMU emulation.
> 
> The guest patch fixes prevents additional overflow being observed due
> while the guest is reprogramming its counters and observe a moving
> target. Note that the host itself needs that initial fix to correctly
> emulate the PMU! ;-)
> 
> It is pretty hard to picture exactly *what* happens when you are
> missing any of these 3 patches. Both the kernel and KVM were buggy at
> some point, and you need all three patches to ensure something
> correct.
> 

Thanks for the explanation!

Regards,
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
