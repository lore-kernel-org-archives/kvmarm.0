Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE23C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 09:57:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27D4D4086D;
	Tue,  8 Feb 2022 04:57:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z3wmQvFUeHRj; Tue,  8 Feb 2022 04:57:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 750E94B11E;
	Tue,  8 Feb 2022 04:57:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AC7A4B11A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 04:57:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S4c+cgUCVF91 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 04:57:00 -0500 (EST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63E4A4086D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 04:57:00 -0500 (EST)
Received: by mail-lf1-f48.google.com with SMTP id i17so6158919lfg.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Feb 2022 01:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xnDB24LQeAUZkcfN3wL+FHV/aKMR05Pb76EsfKgOtQs=;
 b=gvGqrcbMb8DtdN8ZXcz6prSV4SyBxVL8iaSXK7eBe0hV86JPh8TEGaBs9LeBjH394n
 JV5aBERcpIRWYYa6clmXFDkBsubhJVVJXzuUPZt7JtaDR+AcLQ74PLG74djh/U6ThE9F
 jYLME7ZdZfWKpgrV+VImN+2PQV0ucGeZ80w1uSkw089d/t3KRCTq41dyBqhBLwUg08Y+
 oFdo8CrrtiCXONlgKD+p0PBpktOXX9dbD5ax6mo9/6Hk50Eh3BsT6JiVSEF2I2T7Agvt
 DGIRHYiSRdYJMcE9MSwtJaWRukyds/9cMoCgWlB0nnL/HMht3xIjt98uC6O9o9xEKRbe
 1vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xnDB24LQeAUZkcfN3wL+FHV/aKMR05Pb76EsfKgOtQs=;
 b=f5oDz6VIy4wTneLr49rZXGc5MaD8CyOdWc/O0xlc6kjvgzeNPtc9csOn2HN+BZ6ZSX
 adsj+7ao0A9VSdSEuzGU9OwSTfGiAOJpLX4rzveGXc8DBSxYWc71wY8BfHVQeOS1EdTs
 1OgylsShHgV+A3o0DwSYzZtOZcCl/aBmYfxEcxhxFFSG5rhTJ3HXtFFExw/UXjIdHZ2K
 nd5fb5TE8IlHEdMceguFeSxjx8WrZ0Yjjh7Ww1niJ/Evj3jvQ5MyBGU8fBgFswYc9erH
 NNY1Kvtb+DynSyZApCjmIWcLZgf4Fbi7kJZnOonhHJ6fvHYxRa5sW4lPO3hUrAZ1rNdo
 2qKw==
X-Gm-Message-State: AOAM5329vq91OwQ844+VQasdk6gagIMk9nqUHhyN6iZad4GaUV18irhW
 JjtlTll39JcaRG0jpaJKkZsniQ9iZT0Ubh21ng/Q0Q==
X-Google-Smtp-Source: ABdhPJxaGa+pLWFNUpDY6o6qT/j3Mq2c5YYfreeyurnEZrGUe6/lYOJubaJ+/Um6tzeBm0PoCUWy/A+7MB2iwbKR5iU=
X-Received: by 2002:a05:6512:3181:: with SMTP id
 i1mr2552749lfe.286.1644314218724; 
 Tue, 08 Feb 2022 01:56:58 -0800 (PST)
MIME-Version: 1.0
References: <YSVhV+UIMY12u2PW@google.com> <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org> <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org> <YSfiN3Xq1vUzHeap@google.com>
 <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
 <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org>
 <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org>
 <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
 <CAJHc60wp4uCVQhigNrNxF3pPd_8RPHXQvK+gf7rSxCRfH6KwFg@mail.gmail.com>
 <875yq88app.wl-maz@kernel.org>
 <CAOQ_QshL2MCc8-vkYRTDhtZXug20OnMg=qedhSGDrp_VUnX+5g@mail.gmail.com>
 <878ruld72v.wl-maz@kernel.org>
In-Reply-To: <878ruld72v.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Tue, 8 Feb 2022 01:56:47 -0800
Message-ID: <CAOQ_QshwtTknXrpLkHbKj119=wVHvch0tHJURfrvia6Syy3tjg@mail.gmail.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, pshier@google.com, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Tue, Feb 8, 2022 at 1:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > > KVM currently restricts the vcpu features to be unified across vcpus,
> > > but that's only an implementation choice.
> >
> > But that implementation choice has become ABI, no? How could support
> > for asymmetry be added without requiring userspace opt-in or breaking
> > existing VMMs that depend on feature unification?
>
> Of course, you'd need some sort of advertising of this new behaviour.
>
> One thing I would like to add to the current state of thing is an
> indication of whether the effects of a sysreg being written from
> userspace are global or local to a vcpu. You'd need a new capability,
> and an extra flag added to the encoding of each register.

Ah. I think that is a much more reasonable fit then. VMMs unaware of
this can continue to migrate new bits (albeit at the cost of
potentially higher lock contention for the per-VM stuff), and those
that do can reap the benefits of writing such attributes exactly once.

[...]

> > > A device means yet another configuration and migration API. Don't you
> > > think we have enough of those? The complexity of KVM/arm64 userspace
> > > API is already insane, and extremely fragile. Adding to it will be a
> > > validation nightmare (it already is, and I don't see anyone actively
> > > helping with it).
> >
> > It seems equally fragile to introduce VM-wide serialization to vCPU
> > UAPI that we know is in the live migration critical path for _any_
> > VMM. Without requiring userspace changes for all the new widgets under
> > discussion we're effectively forcing VMMs to do something suboptimal.
>
> I'm perfectly happy with suboptimal to start with, and find ways to
> make it better once we have a clear path forward. I just don't want to
> conflate the two.

Fair. My initial concern was that it didn't seem as though there was
much room for growth/improvement with the one reg UAPI, but your
suggestion definitely provides a ramp out to handle VM state once per
VM.

Thanks for following up :)

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
