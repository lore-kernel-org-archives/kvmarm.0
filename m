Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC67DC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 17:56:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D9FA64DEC
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 17:56:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D9FA64DEC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 714B74B3FD;
	Fri,  5 Feb 2021 12:56:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gqDDnYy7zbon; Fri,  5 Feb 2021 12:56:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBB7D4B401;
	Fri,  5 Feb 2021 12:56:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A89534B3FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 12:56:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kNLCmy3OfcNd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 12:56:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA7034B3B1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 12:56:10 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FCEA64DE8;
 Fri,  5 Feb 2021 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612547769;
 bh=tIx6Mq/q5bP075IBZ2ir3cjgV11ktDBdIgJkvpvVC3M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=jTlgNtQ+Yw6PFVByGmHUzsyUYEpwKsJzsW+GNjtotiY8po0ywRgaiSjr1GuAsoMeR
 x+IR75GE7rrnakWiqzHBh0pNtil4DAStD/4cngKoM8MO8fypTdchG7tV9bDrEbIa7w
 f+b2Dm1Os9T7y+9ksGSx1SvohGbjRLeJxGbwH/96VBf/O8XGlMhJBW1NOYn1/w3SKb
 K83RbvvvM+XTwui5PkYnwUF+bft7iDfOSasn/J2V40uzD7vOP11AIQO3w8HrcHl7Yl
 QibMDqZEl9DdxiYCusF7CLgyazJvBPi+SAVwgsOQPH9kauUz65mCbKNapKpxju4iyo
 JNCM2nQUL+HXw==
Date: Fri, 5 Feb 2021 17:56:02 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 16/26] KVM: arm64: Prepare Hyp memory protection
Message-ID: <20210205175602.GG22665@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-17-qperret@google.com>
 <20210203143709.GA18907@willie-the-truck>
 <YBvQrHdbiNTSLQq6@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YBvQrHdbiNTSLQq6@google.com>
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

On Thu, Feb 04, 2021 at 10:47:08AM +0000, Quentin Perret wrote:
> On Wednesday 03 Feb 2021 at 14:37:10 (+0000), Will Deacon wrote:
> > On Fri, Jan 08, 2021 at 12:15:14PM +0000, Quentin Perret wrote:
> > > +static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
> > > +{
> > > +	unsigned long total = 0, i;
> > > +
> > > +	/* Provision the worst case scenario with 4 levels of page-table */
> > > +	for (i = 0; i < 4; i++) {
> > 
> > Looks like you want KVM_PGTABLE_MAX_LEVELS, so maybe move that into a
> > header?
> 
> Will do.
> 
> > 
> > > +		nr_pages = DIV_ROUND_UP(nr_pages, PTRS_PER_PTE);
> > > +		total += nr_pages;
> > > +	}
> > 
> > ... that said, I'm not sure this needs to iterate at all. What exactly are
> > you trying to compute?
> 
> I'm trying to figure out how many pages I will need to construct a
> page-table covering nr_pages contiguous pages. The first iteration tells
> me how many level 0 pages I need to cover nr_pages, the second iteration
> how many level 1 pages I need to cover the level 0 pages, and so on...

Ah, you iterate from leaves back to the root. Got it, thanks.

> I might be doing this naively though. Got a better idea?

I thought I did, but I ended up with something based on a geometric series
and it looks terrible to code-up in C without, err, iterating like you do.

So yeah, ignore me :)

> > > +
> > > +	return total;
> > > +}
> > > +
> > > +static inline unsigned long hyp_s1_pgtable_size(void)
> > > +{
> > > +	struct hyp_memblock_region *reg;
> > > +	unsigned long nr_pages, res = 0;
> > > +	int i;
> > > +
> > > +	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
> > > +		return 0;
> > 
> > It's a bit grotty having this be signed. Why do we need to encode the error
> > case differently from the 0 case?
> 
> Here specifically we don't, but it is needed in early_init_dt_add_memory_hyp()
> to distinguish the overflow case from the first memblock being added.

Fair enough, but if you figure out a way for hyp_memblock_nr to be unsigned,
I think that would be preferable.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
