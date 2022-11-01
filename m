Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66955C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  1 Nov 2022 21:07:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7FAB4BAC9;
	Tue,  1 Nov 2022 17:07:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fU0ZhfnoJiNV; Tue,  1 Nov 2022 17:07:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6654BA86;
	Tue,  1 Nov 2022 17:07:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6479C4BA86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 17:07:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zrWob2RYtO1G for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2022 17:07:35 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 624754BA7C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 17:07:35 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id l2so14697404pld.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Nov 2022 14:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=oFX3TjIuKKqYykGd6uzPpB/gicyMyYF9f2ih7JzKNRQ=;
 b=nBxrbawSkasV5OIFis4uRsM+ydVhwdbUYy7S1Z3udwJaID7FVoII4y3e2Y6NcN+RFh
 lZp3bFFxhaissiuG6SA1KtcxUPcOTyxEnfs3GW5mwTdPgGenTxv71EwIcLPnJ5aI0kQL
 dTkinmMWMPJlBd1h4MrEs6dFRGDXU5ZWycVzIeEZRmebSIxux39oV0pjFOaqEEMwW3PI
 mdWnXqnGBZe7Y4JMXHIAhJSV70YC2ZZS7M8HJAu/hH0IOh/jqS9KEtS1DxLpUlDaT2HB
 iwxcgPifN/nh2CZXcMCvRbDSp/gibhS85slcsL0bNnD/E/hPfgU1EdRvi82v6+YKObPV
 7Xzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oFX3TjIuKKqYykGd6uzPpB/gicyMyYF9f2ih7JzKNRQ=;
 b=uEW91jnA0TAqTDNTtkBk3VS7Mu7UQVdEL9xiog3beSMyjffp6iD9+BG3Sw3v83A0fr
 iWJ6vtuySz+dPsYOrcROUBA5fRCTqtDQVPEdIN/hPN4C0ELrT/zYpiOUZ3dbZvjMl6Xk
 ZkcZi7H0Z08IK9HC/iXRaCr1nXaUOamuSxyAJtJiRSzGuSveq4ylhWvOqjjyrpcutsTO
 jp92Hl1rx6n424UqhKMkAc0uPFo3D5rs5Fc/03755L6UdLQTmJvEzvvi7cI5haj5vFN/
 /mubdbekqSsdJkTN6v7UufMJxGC5qTLpohr0AKeSmUQ5QCMssxdOYcQLCB3zhdjqfnT6
 TE0w==
X-Gm-Message-State: ACrzQf1wCtgZEiMZTx2EdhdmL8Q0VRwBQPtTJdSH0XcApYIgQjvouvLo
 NxZkFdy+i5h+WtDEJVizDi3TyQ==
X-Google-Smtp-Source: AMsMyM7wcyEL7piFmVnE/Id8mKnk5QFETXWa137oLbYLhxqiM7qCfR6bO73L99JU47mjSsviqexCHw==
X-Received: by 2002:a17:90a:9bc7:b0:213:9d21:b0b0 with SMTP id
 b7-20020a17090a9bc700b002139d21b0b0mr22261185pjw.26.1667336854224; 
 Tue, 01 Nov 2022 14:07:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 q3-20020a635c03000000b00460d89df1f1sm6321288pgb.57.2022.11.01.14.07.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Nov 2022 14:07:33 -0700 (PDT)
Date: Tue, 1 Nov 2022 21:07:30 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 09/15] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <Y2GKkvMWTHfuPf4Y@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-10-oliver.upton@linux.dev>
 <Y2GBVML5MWXZE9Na@google.com> <Y2GFliAVxui9VyK2@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2GFliAVxui9VyK2@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Nov 01, 2022, Oliver Upton wrote:
> On Tue, Nov 01, 2022 at 08:28:04PM +0000, Sean Christopherson wrote:
> > On Thu, Oct 27, 2022, Oliver Upton wrote:
> > > There is no real urgency to free a stage-2 subtree that was pruned.
> > > Nonetheless, KVM does the tear down in the stage-2 fault path while
> > > holding the MMU lock.
> > > 
> 
> [ copy ]
> 
> > This is _very_ misleading.  The above paints RCU as an optimization of sorts to
> > avoid doing work while holding mmu_lock.  Freeing page tables in an RCU callback
> > is _required_ for correctness when allowing parallel page faults to remove page
> > tables, as holding mmu_lock for read in that case doesn't ensure no other CPU is
> > accessing and/or holds a reference to the to-be-freed page table.
> 
> Agree, but it is still important to reason about what is changing here
> too. Moving work out of the vCPU fault path _is_ valuable, though
> ancillary to the correctness requirements.

Sure, but that's at best a footnote.  Similar to protecting freeing, RCU isn't
the only option for moving work out of the vCPU fault path.  In fact, it's probably
one of the worst options because RCU callbacks run with soft IRQs disabled, i.e.
doing _too_ much in a RCU callback is a real problem.  If RCU weren't being used
to protect readers, deferring freeing via a workqueue, kthread, etc... would work
just as well, if not better.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
