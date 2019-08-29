Return-Path: <SRS0=G53S=WZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5A6C3A59F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Aug 2019 10:19:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E070322CF5
	for <kvmarm@archiver.kernel.org>; Thu, 29 Aug 2019 10:19:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E070322CF5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47C884A582;
	Thu, 29 Aug 2019 06:19:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hrmvPac7Ta0R; Thu, 29 Aug 2019 06:19:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 214AF4A56E;
	Thu, 29 Aug 2019 06:19:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D154A563
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Aug 2019 06:19:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mEJOyYvJmR6d for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Aug 2019 06:19:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3BFF4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Aug 2019 06:19:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D4B628;
 Thu, 29 Aug 2019 03:19:45 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93D073F59C;
 Thu, 29 Aug 2019 03:19:44 -0700 (PDT)
Date: Thu, 29 Aug 2019 11:19:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 04/16] arm/arm64: selftest: Add
 prefetch abort test
Message-ID: <20190829101942.GC44575@lakrids.cambridge.arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
 <20190828140925.GC41023@lakrids.cambridge.arm.com>
 <e6b8a3c9-2e11-c806-da5b-8b66d8f63ce3@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e6b8a3c9-2e11-c806-da5b-8b66d8f63ce3@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: maz@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, andre.przywara@arm.com
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

On Thu, Aug 29, 2019 at 09:18:35AM +0100, Alexandru Elisei wrote:
> On 8/28/19 3:09 PM, Mark Rutland wrote:
> > On Wed, Aug 28, 2019 at 02:38:19PM +0100, Alexandru Elisei wrote:
> >> +	/*
> >> +	 * AArch64 treats all regions writable at EL0 as PXN.
> > I didn't think that was the case, and I can't find wording to that
> > effect in the ARM ARM (looking at ARM DDI 0487E.a). Where is that
> > stated?
> 
> It's in ARM DDI 0487E.a, table D5-33, footnote c: "Not executable, because
> AArch64 execution treats all regions writable at EL0 as being PXN". I'll update
> the comment to include the quote.

Interesting; I was not aware of that particular behaviour. Thanks
for the pointer!

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
