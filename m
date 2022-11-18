Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB0FC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 17:12:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 572704B9F4;
	Fri, 18 Nov 2022 12:12:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CG-kbewwkHG0; Fri, 18 Nov 2022 12:12:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECC794B9DA;
	Fri, 18 Nov 2022 12:12:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E184B9D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 12:12:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D8DxBLvpotWj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 12:12:54 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70B2D4B9AE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 12:12:54 -0500 (EST)
Date: Fri, 18 Nov 2022 17:12:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668791573;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SZClopAzQZuqTFUhQclgWoQ7jvZ2RLe6Z0cHJygex2I=;
 b=pg/shj4QLtOPw9mnu1T7TalbMSXwxOcCnj7v/lwgEdv806cCTaPHYBQp6Opzx3ysZ426ld
 DVpCO70x+BsZLC91lzrJs3+nwF6okrCjLrt/kHK5dZrd1YXpLoqguwoaUTXwDJxJRY2BTa
 8h35XCtgTiFFx+RnZHLmSg2kD79h+lM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 2/2] KVM: arm64: Don't acquire RCU read lock for
 exclusive table walks
Message-ID: <Y3e9EXICIfgw4nSz@google.com>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
 <20221116165655.2649475-3-oliver.upton@linux.dev>
 <20221117174951.GA2916@willie-the-truck>
 <Y3Z8G3aCuRzzoq5e@google.com>
 <20221118121949.GA3697@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221118121949.GA3697@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org,
 Marek Szyprowski <m.szyprowski@samsung.com>
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

On Fri, Nov 18, 2022 at 12:19:50PM +0000, Will Deacon wrote:
> On Thu, Nov 17, 2022 at 06:23:23PM +0000, Oliver Upton wrote:
> > On Thu, Nov 17, 2022 at 05:49:52PM +0000, Will Deacon wrote:
> > > On Wed, Nov 16, 2022 at 04:56:55PM +0000, Oliver Upton wrote:
> > 
> > [...]
> > 
> > > > -static inline void kvm_pgtable_walk_begin(void) {}
> > > > -static inline void kvm_pgtable_walk_end(void) {}
> > > > +static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
> > > > +{
> > > > +	/*
> > > > +	 * Due to the lack of RCU (or a similar protection scheme), only
> > > > +	 * non-shared table walkers are allowed in the hypervisor.
> > > > +	 */
> > > > +	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
> > > > +}
> > > 
> > > I think it would be better to propagate the error to the caller rather
> > > than WARN here.
> > 
> > I'd really like to warn somewhere though since we're rather fscked at
> > this point. Keeping that WARN close to the exceptional condition would
> > help w/ debugging.
> > 
> > Were you envisioning bubbling the error all the way back up (i.e. early
> > return from kvm_pgtable_walk())?
> 
> Yes, that's what I had in mind. WARN is fatal at EL2, so I think it's
> better to fail the pgtable operation rather than bring down the entire
> machine by default.

Duh, I forgot WARNs really do go boom at EL2. Yeah, in that case it'd be
best to let the caller clean up the mess.

> > If having this is a strong motivator I can do a v4.
> 
> It's a really minor point, so I'll leave it up to you guys.

Sold (sorry I wasn't following before). v4 on the way.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
