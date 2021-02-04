Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3F7C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:24:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30D9F64F4D
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30D9F64F4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB67A4B252;
	Thu,  4 Feb 2021 13:24:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GK7YlFnXeTE9; Thu,  4 Feb 2021 13:24:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9615F4B342;
	Thu,  4 Feb 2021 13:24:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4E84B303
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:24:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FXwHUc2kNpUD for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 13:24:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 622DE4B252
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:24:12 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C14564F45;
 Thu,  4 Feb 2021 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612463051;
 bh=dn4Y26xu9vyOVgTk8Xpb97T9X87MClTDWTRp/3WldJo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=uwitVKbjRGW6MhrPvbGIAjt5Wrs616/BcrBjh6KRmE00R3ZOvoqrjrliGcQ6njHrC
 vj9ZIHQX9AQv0Yk/TQh0joJrkcWCLRkfs3vc3fi2G4gZZCCCqUSYIHMNigLJhcQoF/
 TMcWQv6Me0kyb9AHBKXMLyJmYcbgrMm/7hMwYndMdIG4lQpBT8MMwQbUXg8CFRjQEa
 xld8kqfkXg8cmyd4jEwfdexlmKZ5XoHRgywfnDc4UbrJEsnBltlqHInA+tNGauoXgT
 6sxqBBtVylwFvh+Em/z/lkKk1TDJlulCpsCDOSZ/a4wiXww5NkMABkgNVxzkfoa+w0
 VQ84Fng81mg9Q==
Date: Thu, 4 Feb 2021 18:24:05 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page
 allocator
Message-ID: <20210204182404.GB21526@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-13-qperret@google.com>
 <20210202181307.GA17311@willie-the-truck>
 <YBrsep4xK1F4YRWb@google.com>
 <20210204143106.GA20792@willie-the-truck>
 <YBw6uInyY+AlE7D3@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YBw6uInyY+AlE7D3@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Feb 04, 2021 at 06:19:36PM +0000, Quentin Perret wrote:
> On Thursday 04 Feb 2021 at 14:31:08 (+0000), Will Deacon wrote:
> > Just feels a bit backwards having __find_buddy() take an order parameter,
> > yet then return a page of the wrong order! __hyp_extract_page() always
> > passes the p->order as the order,
> 
> Gotcha, so maybe this is just a naming problem. __find_buddy() is simply
> a helper to lookup/index the vmemmap, but it's perfectly possible that
> the 'destination' page that is being indexed has already been allocated,
> and split up multiple time (and so at a different order), etc ... And
> that is the caller's job to decide.
> 
> How about __lookup_potential_buddy() ? Any suggestion?

Hey, my job here is to waffle incoherently and hope that you find bugs in
your own code. Now you want me to _name_ something! Jeez...

Ok, how about __find_buddy() does what it does today but doesn't take an
order argument, whereas __find_buddy_of_order() takes the order argument
and checks the page order before returning?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
