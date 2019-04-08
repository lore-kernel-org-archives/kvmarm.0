Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930E1C10F13
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 14:22:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 202AE21473
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 14:22:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 202AE21473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80BD44A389;
	Mon,  8 Apr 2019 10:22:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id av1JJh72091k; Mon,  8 Apr 2019 10:22:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 092694A418;
	Mon,  8 Apr 2019 10:22:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A93B4A389
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 10:22:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A9StIjFll4-R for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 10:22:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A46B34A321
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 10:22:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E832C15BF;
 Mon,  8 Apr 2019 07:22:44 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3F153F557;
 Mon,  8 Apr 2019 07:22:42 -0700 (PDT)
Date: Mon, 8 Apr 2019 15:22:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH V2] KVM: ARM: Remove pgtable page standard functions from
 stage-2 page tables
Message-ID: <20190408142212.GA4331@fuggles.cambridge.arm.com>
References: <3be0b7e0-2ef8-babb-88c9-d229e0fdd220@arm.com>
 <1552397145-10665-1-git-send-email-anshuman.khandual@arm.com>
 <20190401161638.GB22092@fuggles.cambridge.arm.com>
 <20190401183425.GA106130@google.com>
 <20190402090349.GA25936@fuggles.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190402090349.GA25936@fuggles.cambridge.arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408142238.HH9DDmGEsMdVcHWN_r9KtO3GSZzrgc767zAlMeATYIw@z>

On Tue, Apr 02, 2019 at 10:04:30AM +0100, Will Deacon wrote:
> On Mon, Apr 01, 2019 at 12:34:25PM -0600, Yu Zhao wrote:
> > On Mon, Apr 01, 2019 at 05:16:38PM +0100, Will Deacon wrote:
> > > [+KVM/ARM folks, since I can't take this without an Ack in place from them]
> > > 
> > > My understanding is that this patch is intended to replace patch 3/4 in
> > > this series:
> > > 
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2019-March/638083.html
> > 
> > Yes, and sorry for the confusion. I could send an updated series once
> > this patch is merged. Thanks.
> 
> That's alright, I think I'm on top of it (but I'll ask you to check whatever
> I end up merging). Just wanted to make it easy for the kvm folks to dive in
> with no context!

Ok, I've pushed this out onto a temporary branch before I merge it into
-next:

https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=pgtable-ctors

Please can you confirm that it looks ok?

Thanks,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
