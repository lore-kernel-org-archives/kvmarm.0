Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC2AC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 12:20:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E924B8E2;
	Fri, 18 Nov 2022 07:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N7YhmMCqHiq8; Fri, 18 Nov 2022 07:20:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E02C4B81E;
	Fri, 18 Nov 2022 07:20:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6684B78C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 07:20:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4dM6MVr7bMvI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 07:19:59 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9E114B775
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 07:19:58 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 69F58B82382;
 Fri, 18 Nov 2022 12:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD0C433C1;
 Fri, 18 Nov 2022 12:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1668773996;
 bh=4JxZQz18/grkc1FqZWiq5Dfac3rhr+RHKptMtajtmCU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=cmOF3PFW7xBBeFULSHg5Gp+fc3p4MViAOAqdlA/ug0xCIRdSMOJtUoHGsX+QL2mpS
 bTPOQLjhB86Sys7VFp08puWia/RHlVlLM0wT4B8Z3pbW6tO4Fz3TMvX+G/EVVFOktA
 /p8qOYNZGe9OhaGAFpw2qLDgDVZBnxxjh/VFwonn2jMINr6L4q9z2m4yxiurj1gV84
 TN/Sdu7nrtBuQ+iAYXICRRY29b+eTQAyfmYsaA6wKhDK3CVuaU+64QLN3FHpRquzez
 i4wfrwiA/0x+zSp0NHZWziFGoRsP74OpUmgM2rG6XleEn2/bX78qeeKP5JFaZrL5Yr
 f4BTl7ZBDC+BQ==
Date: Fri, 18 Nov 2022 12:19:50 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 2/2] KVM: arm64: Don't acquire RCU read lock for
 exclusive table walks
Message-ID: <20221118121949.GA3697@willie-the-truck>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
 <20221116165655.2649475-3-oliver.upton@linux.dev>
 <20221117174951.GA2916@willie-the-truck>
 <Y3Z8G3aCuRzzoq5e@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3Z8G3aCuRzzoq5e@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

On Thu, Nov 17, 2022 at 06:23:23PM +0000, Oliver Upton wrote:
> On Thu, Nov 17, 2022 at 05:49:52PM +0000, Will Deacon wrote:
> > On Wed, Nov 16, 2022 at 04:56:55PM +0000, Oliver Upton wrote:
> 
> [...]
> 
> > > -static inline void kvm_pgtable_walk_begin(void) {}
> > > -static inline void kvm_pgtable_walk_end(void) {}
> > > +static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
> > > +{
> > > +	/*
> > > +	 * Due to the lack of RCU (or a similar protection scheme), only
> > > +	 * non-shared table walkers are allowed in the hypervisor.
> > > +	 */
> > > +	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
> > > +}
> > 
> > I think it would be better to propagate the error to the caller rather
> > than WARN here.
> 
> I'd really like to warn somewhere though since we're rather fscked at
> this point. Keeping that WARN close to the exceptional condition would
> help w/ debugging.
> 
> Were you envisioning bubbling the error all the way back up (i.e. early
> return from kvm_pgtable_walk())?

Yes, that's what I had in mind. WARN is fatal at EL2, so I think it's
better to fail the pgtable operation rather than bring down the entire
machine by default. Now, it _might_ be fatal anyway (e.g. if we were
handling a host stage-2 fault w/ pKVM), but the caller is in a better
position to decide the severity.

> I had really only intended these to indirect lock acquisition/release,
> so the error handling on the caller side feels weird:
> 
>   static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
>   {
>   	if (WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED))
> 		return -EPERM;
> 
> 	return 0;
>   }
> 
>   r = kvm_pgtable_walk_begin()
>   if (r)
>   	return r;
> 
>   r = _kvm_pgtable_walk();
>   kvm_pgtable_walk_end();

This doesn't look particularly weird to me (modulo dropping the WARN, or
moving it to _end()), but maybe I've lost my sense of taste.

> > Since you're rejigging things anyway, can you have this
> > function return int?
> 
> If having this is a strong motivator I can do a v4.

It's a really minor point, so I'll leave it up to you guys.

WIll
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
