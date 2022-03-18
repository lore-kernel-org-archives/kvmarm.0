Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF22C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 20:50:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6382E49ED7;
	Fri, 18 Mar 2022 16:50:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gd28vUBQC8FJ; Fri, 18 Mar 2022 16:49:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 337D949E22;
	Fri, 18 Mar 2022 16:49:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B1649E22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 16:49:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HW3YD5ZCC-0R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 16:49:56 -0400 (EDT)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1FEB49E1E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 16:49:56 -0400 (EDT)
Received: by mail-pf1-f172.google.com with SMTP id s42so10548087pfg.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 13:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gVt42dxY4XsYu/jUnlir9efYggk8x5Y2GQzM+hfTO0k=;
 b=k10ba2fpj/c86GaX7N8Q7y3gQyhyTL6ewYQwX/YP0t/9Z34PrZE96qXzdfGpcdthiS
 NQxg0LecShV2c/uY8P+90xyytrg0TR2/TQ9HIzdeh8YpCfloNqmklSYkSAo44Q3SoLdz
 rKmjJXB+xFFFoNhi2pDmbsjEmwycBgLlLbwBvnA07SgFdWllwzgBJWkQiHooqMR3BMom
 IvJDtLiRaEqpqz/urNIYKmswtAss8hDSHO2LWabY94/H2k+kaZaafcv/rOLiBj9rvU6/
 ySeUIFJyOeWy+ifjD0szlU1kcz081O/3QmCwVPjofFF8DBgAZ6Ln+8jTKvOZLLVihJ/2
 laog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gVt42dxY4XsYu/jUnlir9efYggk8x5Y2GQzM+hfTO0k=;
 b=QJkiOPrQxnuFd9Dvg6Qdx/fbXVLaiyZErljnLvfaIAapPrKCOq+fSJW/0WlbqgRAd5
 j3PTCSOZcg5E87rapVf6L3I5fCZGFVhEtVWqQ3EbMVP5yodjpAWps9SWEycHC/flQA9k
 1SXFhalyOZdijunXPpT8asrAAVrpu4cPTrfD9ZIdZJaeuCRYLrTm7EQAKgcJGMpxgNST
 lau7Fqy43sAevfShBAD0NAHKani6umptU6nbi084OFWYMUD/HD5MDJ/sgHmPkzjf/3cO
 tZnmXmslM6uht/KbSdpnmc/sn2vxD/9MCDK5eVmxEa/PmUBSBtMZQXg2YzWRkBuaQYUR
 SIJA==
X-Gm-Message-State: AOAM5322pdFyQR6i2++szVeCC2tdrZCrpMpDtzrLVkD3pzFSyJSe+Y+g
 QgOoq7Abzl252je/3nfGC7VcMQ==
X-Google-Smtp-Source: ABdhPJwKkLD/f/nrBS6pOWuLQuqgkqO2xZayA6Y4KD/plr9meROqwO0LF93z8SiHNPs+tMyvI6IvXw==
X-Received: by 2002:a63:121f:0:b0:382:2513:df9e with SMTP id
 h31-20020a63121f000000b003822513df9emr5338133pgl.269.1647636595399; 
 Fri, 18 Mar 2022 13:49:55 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 f10-20020a056a00228a00b004f769b40bd6sm10952592pfe.103.2022.03.18.13.49.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Mar 2022 13:49:54 -0700 (PDT)
Date: Fri, 18 Mar 2022 13:49:51 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
Message-ID: <YjTwb0+3MPfK62qb@google.com>
References: <20220317045127.124602-1-ricarkol@google.com>
 <20220317045127.124602-3-ricarkol@google.com>
 <YjLY5y+KObV0AR9g@google.com>
 <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Mar 17, 2022 at 08:52:38AM +0000, Marc Zyngier wrote:
> On 2022-03-17 06:44, Oliver Upton wrote:
> > On Wed, Mar 16, 2022 at 09:51:26PM -0700, Ricardo Koller wrote:
> > > Add an arch_timer edge-cases selftest. For now, just add some basic
> > > sanity checks, and some stress conditions (like waiting for the timers
> > > while re-scheduling the vcpu). The next commit will add the actual
> > > edge
> > > case tests.
> > > 
> > > This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
> > > interrupts for suspended vCPU".
> > > 
> > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > > Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> 
> [...]
> 
> > > +		asm volatile("wfi\n"
> > > +			     "msr daifclr, #2\n"
> > > +			     /* handle IRQ */
> > 
> > I believe an isb is owed here (DDI0487G.b D1.13.4). Annoyingly, I am
> > having a hard time finding the same language in the H.a revision of the
> > manual :-/

Got it, adding it. Saw that there is a similar pattern in the kernel and
it has an ISB in the middle.

> 
> D1.3.6 probably is what you are looking for.
> 
> "Context synchronization event" is the key phrase to remember
> when grepping through the ARM ARM. And yes, the new layout is
> a nightmare (as if we really needed an additional 2800 pages...).
> 
> > 
> > > +			     "msr daifset, #2\n"
> > > +			     : : : "memory");
> > > +	}
> > > +}
> 
> [...]
> 
> > > +	/* tval should keep down-counting from 0 to -1. */
> > > +	SET_COUNTER(DEF_CNT, test_args.timer);
> > > +	timer_set_tval(test_args.timer, 0);
> > > +	if (use_sched)
> > > +		USERSPACE_SCHEDULE();
> > > +	/* We just need 1 cycle to pass. */
> > > +	isb();
> > 
> > Somewhat paranoid, but:
> > 
> > If the CPU retires the ISB much more quickly than the counter ticks, its
> > possible that you could observe an invalid TVAL even with a valid
> > implementation.
> 
> Worse than that:
> 
> - ISB doesn't need to take any time at all. It just needs to ensure
>   that everything is synchronised. Depending on how the CPU is built,
>   this can come for free.
> 
> - There is no relation between the counter ticks and CPU cycles.

Good point.

> 
> > What if you spin waiting for CNT to increment before the assertion? Then
> > you for sureknow (and can tell by reading the test) that the
> > implementation is broken.
> 
> That's basically the only way to implement this. You can't rely
> on any other event.

The next commit fixes this (by spinning on the counter). Will move it
here.

> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...

Thank you both for the review.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
