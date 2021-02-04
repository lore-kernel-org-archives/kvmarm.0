Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E050CC433E6
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 17:49:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 295B964F59
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 17:49:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 295B964F59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 928394B33F;
	Thu,  4 Feb 2021 12:49:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uNXYJAZXbWi4; Thu,  4 Feb 2021 12:48:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6155E4B334;
	Thu,  4 Feb 2021 12:48:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E08D4B331
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 12:48:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L56xL-+UdcXm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 12:48:57 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F4664B330
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 12:48:57 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 639A164F41;
 Thu,  4 Feb 2021 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612460936;
 bh=BE4sTc2vQLpAqcnSed7nO8BgiaDvc3jDuHi/BhMHhuw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=BJdPmR0qx04Q0OC8F92po0hMHhrRiWvCaxDONmHEOoUlPgCayFyD25VcKG9WAE5Ab
 dsuh0qli7OfmSqeEkwH0tHklTV6xlGGaJICNA3Bf4Kc2zQEzKSlwDMjJP4OtHhT/Az
 unbkjzC/50L2YixQX7un0SEMXdb+1hbaD3m5rjR8iUXk/Rs81QPavwoAn0+TmUUQgq
 c51he+0ZCZ/l4W+Onfm4pbnVfVAQCatI6xGIqlmqFEpLCjf0/tx9tOt5qOom6lDmNU
 wSXrZoHUHqE8XQVhWEcCQKWNWBHNhIaLyoHPM4WHK/OO4PWoWHpW1XZpP+9r6IK6Aq
 jy0+RUjalzziw==
Date: Thu, 4 Feb 2021 17:48:49 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page
 allocator
Message-ID: <20210204174849.GA21303@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-13-qperret@google.com>
 <20210202181307.GA17311@willie-the-truck>
 <YBrsep4xK1F4YRWb@google.com>
 <20210204143106.GA20792@willie-the-truck>
 <YBwKRM3uHDMC9S0U@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YBwKRM3uHDMC9S0U@google.com>
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

On Thu, Feb 04, 2021 at 02:52:52PM +0000, Quentin Perret wrote:
> On Thursday 04 Feb 2021 at 14:31:08 (+0000), Will Deacon wrote:
> > On Wed, Feb 03, 2021 at 06:33:30PM +0000, Quentin Perret wrote:
> > > On Tuesday 02 Feb 2021 at 18:13:08 (+0000), Will Deacon wrote:
> > > > On Fri, Jan 08, 2021 at 12:15:10PM +0000, Quentin Perret wrote:
> > > > > + *   __find_buddy(pool, page 0, order 0) => page 1
> > > > > + *   __find_buddy(pool, page 0, order 1) => page 2
> > > > > + *   __find_buddy(pool, page 1, order 0) => page 0
> > > > > + *   __find_buddy(pool, page 2, order 0) => page 3
> > > > > + */
> > > > > +static struct hyp_page *__find_buddy(struct hyp_pool *pool, struct hyp_page *p,
> > > > > +				     unsigned int order)
> > > > > +{
> > > > > +	phys_addr_t addr = hyp_page_to_phys(p);
> > > > > +
> > > > > +	addr ^= (PAGE_SIZE << order);
> > > > > +	if (addr < pool->range_start || addr >= pool->range_end)
> > > > > +		return NULL;
> > > > 
> > > > Are these range checks only needed because the pool isn't required to be
> > > > an exact power-of-2 pages in size? If so, maybe it would be more
> > > > straightforward to limit the max order on a per-pool basis depending upon
> > > > its size?
> > > 
> > > More importantly, it is because pages outside of the pool are not
> > > guaranteed to be covered by the hyp_vmemmap, so I really need to make
> > > sure I don't dereference them.
> > 
> > Wouldn't having a per-pool max order help with that?
> 
> The issue is, I have no alignment guarantees for the pools, so I may end
> up with max_order = 0 ...

Yeah, so you would still need the range tracking, but it would at least help
to reduce HYP_MAX_ORDER failed searches each time. Still, we can always do
that later.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
