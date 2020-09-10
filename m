Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A56BC43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:58:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78B6F20C09
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:58:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="C49xCjDy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78B6F20C09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B80764B364;
	Thu, 10 Sep 2020 06:58:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KfpuZ8RuXCSd; Thu, 10 Sep 2020 06:58:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6B654B3E1;
	Thu, 10 Sep 2020 06:58:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 747114B38B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:58:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Br2TyD65p-6n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 06:58:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 685E34B363
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:58:42 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8876720BED;
 Thu, 10 Sep 2020 10:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599735521;
 bh=H4fLahY09kIABG+hnBOS3jDAHJaeoNGpys/P9jWiBxc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=C49xCjDyJ0bqgrAjrHHD2OgeKxUHD8lkN731jB0aiwSO1rOp8b1zYnOFr/rOnSLw9
 1g6TJHtK9pUzHObVsFZ1z8NhhgySZ4s4Y4p9T7EhVQpIegpS4rMTwGipfjaNJue6vu
 8UVR4+RlUhKtFBan19dTCtq/3Dk9oZNnkB9gAJVU=
Date: Thu, 10 Sep 2020 11:58:36 +0100
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
Message-ID: <20200910105835.GD17887@willie-the-truck>
References: <20200907152344.12978-1-will@kernel.org>
 <4e41d4c5-1d36-fb28-880d-94235def35ed@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4e41d4c5-1d36-fb28-880d-94235def35ed@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 10, 2020 at 02:06:04PM +1000, Gavin Shan wrote:
> On 9/8/20 1:23 AM, Will Deacon wrote:
> > Here's version four of the KVM page-table rework I previously posted here:
> > 
> >    v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
> >    v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
> >    v3: https://lore.kernel.org/r/20200825093953.26493-1-will@kernel.org
> > 
> > Changes since v3 include:
> > 
> >    * Removed some more unused code from the old implementation
> >    * Renumbered KVM_PGTABLE_PROT_* to match file permissions in hex dumps
> >    * Simplified kvm_granule_shift() and removed kvm_start_level()
> >    * Only clear valid bit when invalidating a PTE, leaving phys addr intact
> >    * Fail gracefully when attempting to allocate without a memory cache
> >    * Rewrote stage2_apply_range() as a function instead of a macro
> >    * Fixed fault address rounding with hugetlbfs
> >    * Fixed permission fault handling when dirty logging is enabled
> >    * Added comments
> >    * Added reviewer tags
> > 
> > Many thanks to Alex and Gavin for their comments.
> > 
> > Will
> > 
> 
> [...]
> 
> Eventually, I'm lucky finding a machine from our pool where 16KB page
> size is supported. I tried this series (v4) on this machine, everything
> looks good as we expected:

Thanks, Gavin! I'll probably spin another version this week, just collecting
the last few comments I've had.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
