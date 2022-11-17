Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64816C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 18:23:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D79434B8B0;
	Thu, 17 Nov 2022 13:23:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bne7PMmJdfSJ; Thu, 17 Nov 2022 13:23:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97BA04B897;
	Thu, 17 Nov 2022 13:23:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AD5A4B7B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 13:23:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6NoUp-5cq65v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 13:23:28 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B56D14B79B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 13:23:28 -0500 (EST)
Date: Thu, 17 Nov 2022 18:23:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668709407;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=IwFVbORM3lkiyGr/+WKBEIKDDUjLVlji+1Do7NRWw78=;
 b=EPyAipG0Y0uPsli1k4NCyXaG1sfwgMAXa1UEGeItlrHceWFfKnGKSK3iyCq3wzRd3DAXf7
 fI3727AVsagQ3/4GUDaNBDmMWcj1o723mEYNDHciLRGE/FuJmJkXW/hDR44vfmraH8cu2c
 n24UNBnI5YYa/xXMwJpR42PArIHvi2Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 2/2] KVM: arm64: Don't acquire RCU read lock for
 exclusive table walks
Message-ID: <Y3Z8G3aCuRzzoq5e@google.com>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
 <20221116165655.2649475-3-oliver.upton@linux.dev>
 <20221117174951.GA2916@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221117174951.GA2916@willie-the-truck>
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

Hi Will,

Thanks for having a look.

On Thu, Nov 17, 2022 at 05:49:52PM +0000, Will Deacon wrote:
> On Wed, Nov 16, 2022 at 04:56:55PM +0000, Oliver Upton wrote:

[...]

> > -static inline void kvm_pgtable_walk_begin(void) {}
> > -static inline void kvm_pgtable_walk_end(void) {}
> > +static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
> > +{
> > +	/*
> > +	 * Due to the lack of RCU (or a similar protection scheme), only
> > +	 * non-shared table walkers are allowed in the hypervisor.
> > +	 */
> > +	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
> > +}
> 
> I think it would be better to propagate the error to the caller rather
> than WARN here.

I'd really like to warn somewhere though since we're rather fscked at
this point. Keeping that WARN close to the exceptional condition would
help w/ debugging.

Were you envisioning bubbling the error all the way back up (i.e. early
return from kvm_pgtable_walk())?

I had really only intended these to indirect lock acquisition/release,
so the error handling on the caller side feels weird:

  static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
  {
  	if (WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED))
		return -EPERM;

	return 0;
  }

  r = kvm_pgtable_walk_begin()
  if (r)
  	return r;

  r = _kvm_pgtable_walk();
  kvm_pgtable_walk_end();

> Since you're rejigging things anyway, can you have this
> function return int?

If having this is a strong motivator I can do a v4.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
