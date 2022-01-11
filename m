Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D85DC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 18:46:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9B204B0F7;
	Tue, 11 Jan 2022 13:46:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tjxpQJPHXKSI; Tue, 11 Jan 2022 13:46:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B48984B1ED;
	Tue, 11 Jan 2022 13:46:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BDA94B165
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 13:46:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rD0N5joU5u8U for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 13:46:51 -0500 (EST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com
 [209.85.219.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70D6D4B0F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 13:46:51 -0500 (EST)
Received: by mail-yb1-f169.google.com with SMTP id v186so40666896ybg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 10:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=aFmLILnvpHUVz7ssSaFntznd0hUHj6gSC616E6Fkf3U=;
 b=ePhCIqosOE3NORpI3w54xHfcf6puCuQ+ahHlVC9G+tLO1IGP+Wgo03UffIkLCD29C6
 k0CRMWuU19THro9DlEhGP69zZBJFVhAePULjiWgpPP2+R248Tcm165947vP0aZi3s+z3
 KJBzevL0NfgzA5F+Uc4oKmj+jYR+wZ55HEE+ti6ILLFigEbDJwP/lrOgXm0M24EPXvYm
 4dtTAQF9+cItgcqoCCoSXLydPtnIrMJF1vzL8JO2vTdoooQUT9gSNNHz/Q2miLU8T7Ag
 MZlAK/xMpFZL9y3rVVJXsoY8rl5Y5BvRXzGKK3g1FVPPKtyr0P1MbZ2vI5P2ZX9v2Gz3
 y+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=aFmLILnvpHUVz7ssSaFntznd0hUHj6gSC616E6Fkf3U=;
 b=f2xPYsIV9HEuGGZpH6K8jJlzOYdyeB2cw++yh5WihTTQRxol97WpsormbayMiqNiig
 cHe+xBtQ9DDX0SGJyMsOD+0Lxo3axMPwJjCOPTQ2+zGMTiUG/udtqvnrUu3VRIMuqq+7
 Tz84r9lQHFYeTX0lF4bF60I5ZKpZs5rjkSnHfRia8IQGmxHOWqolFyzbHMALxAsF1Bcn
 yBqzv9r+pCjTJq+jk3eXO1dJY1BzXmqAvsyUBQSXPy2Tbl61/qp9lnYksXxviKyjh0Aa
 kmX06wY6MywGrKjrNZ3i2KHYaDvkV0/k0ZnyLHgL6kFg3fOsR1JRNtQtoLlraLsB7ZJ8
 Sklg==
X-Gm-Message-State: AOAM532JwpX4KjtEm8xzKbyxZGZ2FtUsU92j7i47d2yVN2mvhJx6D1ER
 d4MB3E3jm1YvXzgAn2mrt7tNJZPeFG8QuGAiQeFDGw==
X-Google-Smtp-Source: ABdhPJy2gg0pwgufffOlXPR//NYKBRRE7YQswq8GMY6HGu/DSmziIAnClGDP4sEu6YMRCb2AJB3uhS4DQuFcC/jbDPk=
X-Received: by 2002:a25:d750:: with SMTP id o77mr7614846ybg.543.1641926810619; 
 Tue, 11 Jan 2022 10:46:50 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com>
 <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
 <Yd3AGRtkBgWSmGf2@google.com>
In-Reply-To: <Yd3AGRtkBgWSmGf2@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 11 Jan 2022 10:46:40 -0800
Message-ID: <CAJHc60w7vfHkg+9XkPw+38nZBWLLhETJj310ekM1HpQQTL_O0Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Jan 11, 2022 at 9:36 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jan 10, 2022, Raghavendra Rao Ananta wrote:
> > On Fri, Jan 7, 2022 at 5:06 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jan 04, 2022, Raghavendra Rao Ananta wrote:
> > > > +#define kvm_vm_has_started(kvm) (kvm->vm_started)
> > >
> > > Needs parantheses around (kvm), but why bother with a macro?  This is the same
> > > header that defines struct kvm.
> > >
> > No specific reason for creating a macro as such. I can remove it if it
> > feels noisy.
>
> Please do.  In the future, don't use a macro unless there's a good reason to do
> so.  Don't get me wrong, I love abusing macros, but for things like this they are
> completely inferior to
>
>   static inline bool kvm_vm_has_started(struct kvm *kvm)
>   {
>         return kvm->vm_started;
>   }
>
> because a helper function gives us type safety, doesn't suffer from concatenation
> of tokens potentially doing weird things, is easier to extend to a multi-line
> implementation, etc...
>
> An example of when it's ok to use a macro is x86's
>
>   #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
>
> which uses a macro instead of a proper function to avoid a circular dependency
> due to arch/x86/include/asm/kvm_host.h being included by include/linux/kvm_host.h
> and thus x86's implementation of kvm_arch_vcpu_memslots_id() coming before the
> definition of struct kvm_vcpu.  But that's very much an exception and done only
> because the alternatives suck more.
>
Understood. Thanks for the explanation! Will switch to an inline function.

> > > > +                      */
> > > > +                     mutex_lock(&kvm->lock);
> > >
> > > This adds unnecessary lock contention when running vCPUs.  The naive solution
> > > would be:
> > >                         if (!kvm->vm_started) {
> > >                                 ...
> > >                         }
> > >
> > Not sure if I understood the solution..
>
> In your proposed patch, KVM_RUN will take kvm->lock _every_ time.  That introduces
> unnecessary contention as it will serialize this bit of code if multiple vCPUs
> are attempting KVM_RUN.  By checking !vm_started, only the "first" KVM_RUN for a
> VM will acquire kvm->lock and thus avoid contention once the VM is up and running.
> There's still a possibility that multiple vCPUs will contend for kvm->lock on their
> first KVM_RUN, hence the quotes.  I called it "naive" because it's possible there's
> a more elegant solution depending on the use case, e.g. a lockless approach might
> work (or it might not).
>
But is it safe to read kvm->vm_started without grabbing the lock in
the first place? use atomic_t maybe for this?

> > > > +                     kvm->vm_started = true;
> > > > +                     mutex_unlock(&kvm->lock);
> > >
> > > Lastly, why is this in generic KVM?
> > >
> > The v1 of the series originally had it in the arm specific code.
> > However, I was suggested to move it to the generic code since the book
> > keeping is not arch specific and could be helpful to others too [1].
>
> I'm definitely in favor of moving/adding thing to generic KVM when it makes sense,
> but I'm skeptical in this particular case.  The code _is_ arch specific in that
> arm64 apparently needs to acquire kvm->lock when checking if a vCPU has run, e.g.
> versus a hypothetical x86 use case that might be completely ok with a lockless
> implementation.  And it's not obvious that there's a plausible, safe use case
> outside of arm64, e.g. on x86, there is very, very little that is truly shared
> across the entire VM/system, most things are per-thread/core/package in some way,
> shape, or form.  In other words, I'm a wary of providing something like this for
> x86 because odds are good that any use will be functionally incorrect.
I've been going back and forth on this. I've seen a couple of
variables declared in the generic struct and used only in the arch
code. vcpu->valid_wakeup for instance, which is used only by s390
arch. Maybe I'm looking at it the wrong way as to what can and can't
go in the generic kvm code.

Thanks,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
