Return-Path: <SRS0=r53t=FP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A2FC4361B
	for <kvmarm@archiver.kernel.org>; Fri, 11 Dec 2020 09:34:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A99B23F34
	for <kvmarm@archiver.kernel.org>; Fri, 11 Dec 2020 09:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A99B23F34
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 787EA4B29E;
	Fri, 11 Dec 2020 04:34:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2ueC6Vez08q6; Fri, 11 Dec 2020 04:34:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F39534B281;
	Fri, 11 Dec 2020 04:34:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 911354B273
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 04:34:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYPSyeB6jsxZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Dec 2020 04:34:35 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4862B4B267
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 04:34:35 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id w206so4295924wma.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 01:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5QQ72igs5Cq7RXBQftsVNnYL8BXMf0c4vZdsSi9iD6M=;
 b=ZbEyYIsT/WsA8D/qEVLOi8WoMHEZQG+J1GHGY1nKG8ojW4A4kbYb1BZyVKg3bZzFXm
 fpcQ7+i1S5ixpOztTywXdrE6+VC90jztUX/HKFDDLwQa6m8iXsXC6oDBcSvuriVJ5v6e
 ZV6Hxu7P5Yzj8VoqkhqJjMifBhxRYc9ZbaAdCM+D/jxAcl0jZAI5i+cqh/hRCqo3Xuhp
 XK98kFXYjXbfvjXfUB/rN8NDmCtESjTaSYGOJigP/WJdnR9vDm8igGYqFQk6KvgI7kk7
 caIWe4L1SBkGqYGj4lTPZErXDKgNbDV9l5WDn5nC0SexXEqgDRE+bg+aKHzvA1qLPyPw
 F8tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5QQ72igs5Cq7RXBQftsVNnYL8BXMf0c4vZdsSi9iD6M=;
 b=pyRMNiy49tjgJ+2kGyE9g3PuRNNv+H9+5T510dmOsTUsE2iEbkFfAZEDPZzIKzLJNj
 HHt/TII8uTFuHytufS8lvI6+1RgcE6mx+yNWg251Ij1AmTI2km6vo+28JoxGKWTd4ubq
 /44x5f6LNMVzEkkwrvpVwFqwfkWysyo/AGrqJux5GjlmNhCJ14kQsXWgbWae8EaALO5t
 hBWVNFKfWJfjyhlPzy4w4FEgfN2riS8iLhgFey49ga1mokakw23lsx1NS8e96R7aFOKj
 4eiN2sWSsKQI/hTNVf8W/435yzRE7xUA1PyObRzjnhkZjM13gab/J0bGKBbDa8SkQ6yL
 4hRQ==
X-Gm-Message-State: AOAM531cFSylJ9wxFEpfsH3WzQMsmZWTuM34MIYLdw6I3IqIz7IhoMSZ
 J9GbDz2OOiq0yukvDKL8oFYL2g==
X-Google-Smtp-Source: ABdhPJxonejdt+TKQH5LoBQQzj9Xf9glLgQrvjTCz41n2F3sIkw98JLxxTja92T7/i70saMzZSW1ig==
X-Received: by 2002:a1c:7c19:: with SMTP id x25mr12370270wmc.145.1607679274075; 
 Fri, 11 Dec 2020 01:34:34 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id i16sm12616554wrx.89.2020.12.11.01.34.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 11 Dec 2020 01:34:33 -0800 (PST)
Date: Fri, 11 Dec 2020 09:34:30 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
Message-ID: <X9M9JuK5DIWzgdyQ@google.com>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
 <20200817020310.GA1210848@jagdpanzerIV.localdomain>
 <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
 <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
 <20200911085841.GB562@jagdpanzerIV.localdomain>
 <CAJWu+oq26OK1-7Ze2pb5xpRJ-tS9wtXOdGFrYpHq+fhkyGhjkA@mail.gmail.com>
 <fdc35e25f2bc2cdfa0849a84802eafd6@kernel.org>
 <CAJWu+ooy=r=G+AnyriQDA9_4CJqfO6hkf=c8heV8HV+yNea_PQ@mail.gmail.com>
 <78091359dab0d8decfc452f7c5c25971@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <78091359dab0d8decfc452f7c5c25971@kernel.org>
Cc: Joel Fernandes <joelaf@google.com>, LKML <linux-kernel@vger.kernel.org>,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

On Thursday 10 Dec 2020 at 08:45:22 (+0000), Marc Zyngier wrote:
> On 2020-12-10 01:39, Joel Fernandes wrote:
> 
> [...]
> 
> > > Quentin and I have discussed potential ways of improving guest
> > > scheduling
> > > on terminally broken systems (otherwise known as big-little), in the
> > > form of a capacity request from the guest to the host. I'm not really
> > > keen on the host exposing its own capacity, as that doesn't tell the
> > > host what the guest actually needs.
> > 
> > I am not sure how a capacity request could work well. It seems the
> > cost of a repeated hypercall could be prohibitive. In this case, a
> > lighter approach might be for KVM to restrict vCPU threads to run on
> > certain types of cores, and pass the capacity information to the guest
> > at guest's boot time.
> 
> That seems like a very narrow use case. If you actually pin vcpus to
> physical CPU classes, DT is the right place to put things, because
> it is completely static. This is effectively creating a virtual
> big-little, which is in my opinion a userspace job.

+1, all you should need for this is to have the VMM pin the vCPUS and
set capacity-dmips-mhz in the guest DT accordingly. And if you're
worried about sharing the runqueue with host tasks, could you vacate the
host CPUs using cpusets or such?

The last difficult bit is how to drive DVFS. I suppose Marc's suggestion
to relay capacity requests from the guest would help with that.

> > This would be a one-time cost to pay. And then,
> > then the guest scheduler can handle the scheduling appropriately
> > without any more hypercalls. Thoughts?
> 
> Anything that is a one-off belongs to firmware configuration, IMO.
> 
> The case I'm concerned with is when vcpus are allowed to roam across
> the system, and hit random physical CPUs because the host has no idea
> of the workload the guest deals with (specially as the AMU counters
> are either absent or unusable on any available core).
> 
> The cost of a hypercall really depends on where you terminate it.
> If it is a shallow exit, that's only a few hundred cycles on any half
> baked CPU. Go all the way to userspace, and the host scheduler is the
> limit. But the frequency of that hypercall obviously matters too.
> 
> How often do you expect the capacity request to fire? Probably not
> on each and every time slice, right?
> 
> Quentin, can you shed some light on this?

Assuming that we change the 'capacity request' (aka uclamp.min of the
vCPU) every time the guest makes a frequency request, then the answer
very much is 'it depends on the workload'. Yes there is an overhead, but
I think it is hard to say how bad that would be before we give it a go.
It's unfortunately not uncommon to have painfully slow frequency changes
on real hardware, so this may be just fine. And there may be ways we
can mitigate this too (with rate limiting and such), so all in all it is
worth a try.

Also as per the above, this still would help even if the VMM pins vCPUs
and such, so these two things can live and complement each other I
think.

Now, for the patch originally under discussion here, no objection from
me in principle, it looks like a nice improvement to the stolen time
stuff and I can see how that could help some use-cases, so +1 from me.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
