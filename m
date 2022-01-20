Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C62C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jan 2022 19:16:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0841A4126B;
	Thu, 20 Jan 2022 14:16:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KQybvii0Rk5X; Thu, 20 Jan 2022 14:16:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBEEC49AFD;
	Thu, 20 Jan 2022 14:16:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3496443479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 14:16:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nt-sjKuoRuNL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Jan 2022 14:16:26 -0500 (EST)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com
 [209.85.219.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6AF74126B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 14:16:26 -0500 (EST)
Received: by mail-yb1-f177.google.com with SMTP id g14so20675201ybs.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 11:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=LgnhRIvXZbEoD4dNyz5NkE0CJ53Si0Wk9Up+SOzAYhA=;
 b=o0PDYUEKjpAJB9YJb3t9C+jB2PyVuPdaf4pkP7QzpQGjwttuO4V6bAkg6ZwhH+0o7n
 w6rEaAmsW34ThZTLSkfmf3+Ry8zWG5uUJWFGZsqfD68jhT+TpIg+gESR/1ui84iExdXZ
 pXIz89dINxbGyM1TkNJTcWtPU9VovT8UpDY+CfrT32NrUzsLxSCYHH+q11bvcZzt1FIt
 /m2zCZ+noC5CtDQj6TEcUJAzkGW4vAY7r5SagGWwt5ugxZktJ1VcSGmLjyp7b1yolR9l
 mjDjMhtbGrMh0uopZEljedyO2f15zEIvPAKr72Wezz6KjaeA8jirH9oBzuP99x+0pl1E
 7Izw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=LgnhRIvXZbEoD4dNyz5NkE0CJ53Si0Wk9Up+SOzAYhA=;
 b=GqAj32gmc8s0me6BHqyKwsDGYs26iiZ/u3r6rXNgxYt0vUyQICphXo/sVtjMWdPHn4
 5Uil18cDvccjWCcKmf6onlx3/7Yy0opQhXHXFo0RdrlMjDBCLVChM8gSkCs92ynjMrap
 +T2d+jaZqH48E3HBJvOh1yjk8E0L85/kcJV/UMOvsCBe6JMR6stIxVlPLGHNm0eED/1v
 6mXdAyo1vqe+QaOeXA1Af2J7SZ9FU/tAsG0yoC4RDywNm2s63X4jyxV8Q58RzMCuoB4O
 fXeFEk1RcZTk93v+Z9PndNM6soenRMBpLuTwmvLgJsjpAtF1i4IRz740ya4OQNbZeqZu
 P8LA==
X-Gm-Message-State: AOAM530fh8ks1/Arq2HYXqurO1MDDYYWHlRBFQ+4J5eMndxv1gAAETqm
 BSpiVbhADzsXSdml720uG+N8Uqqm5pLhU9Ns93Bhxg==
X-Google-Smtp-Source: ABdhPJzXKfVdVRUPzsECQCVgkK1ZzL2Rx2Ozj606e8DptRmlTQ6MsPNzGhGIZvYZBAbyNTeoXXpzxUUp4c3YgUAq71E=
X-Received: by 2002:a25:d055:: with SMTP id h82mr694673ybg.543.1642706186084; 
 Thu, 20 Jan 2022 11:16:26 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com>
 <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
 <YedWUJNnQK3HFrWC@google.com>
 <CAAeT=FyJAG1dEFLvrQ4UXrwUqBUhY0AKkjzFpyi74zCJZUEYVg@mail.gmail.com>
 <YeisZCJedWYJPLV5@google.com>
In-Reply-To: <YeisZCJedWYJPLV5@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 20 Jan 2022 11:16:15 -0800
Message-ID: <CAJHc60zhRyOad7AqtEFn-Ptro5BGVkfpB2wXWGw5EZMxOHUc=w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>
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

On Wed, Jan 19, 2022 at 4:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 18, 2022, Reiji Watanabe wrote:
> > On Tue, Jan 18, 2022 at 4:07 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Jan 14, 2022, Reiji Watanabe wrote:
> > > > The restriction, with which KVM doesn't need to worry about the changes
> > > > in the registers after KVM_RUN, could potentially protect or be useful
> > > > to protect KVM and simplify future changes/maintenance of the KVM codes
> > > > that consumes the values.
> > >
> > > That sort of protection is definitely welcome, the previously mentioned CPUID mess
> > > on x86 would have benefit greatly by KVM being restrictive in the past.  That said,
> > > hooking KVM_RUN is likely the wrong way to go about implementing any restrictions.
> > > Running a vCPU is where much of the vCPU's state is explicitly consumed, but it's
> > > all too easy for KVM to implicity/indirectly consume state via a different ioctl(),
> > > e.g. if there are side effects that are visible in other registers, than an update
> > > can also be visible to userspace via KVM_{G,S}ET_{S,}REGS, at which point disallowing
> > > modifying state after KVM_RUN but not after reading/writing regs is arbitrary and
> > > inconsitent.
> >
> > Thank you for your comments !
> > I think I understand your concern, and that's a great point.
> > That's not the case for those pseudo registers though at least for now :)
> > BTW, is this concern specific to hooking KVM_RUN ? (Wouldn't it be the
> > same for the option with "if kvm->created_vcpus > 0" ?)
>
> Not really?  The goal with created_vcpus is to avoid having inconsistent state in
> "struct kvm_vcpu" with respect to the VM as whole.  "struct kvm" obvioulsy can't
> be inconsistent with itself, e.g. even if userspace consumes some side effect,
> that's simply "the state".  Did that make sense?  Hard to explain in writing :-)
>
> > > If possible, preventing modification if kvm->created_vcpus > 0 is ideal as it's
> > > a relatively common pattern in KVM, and provides a clear boundary to userpace
> > > regarding what is/isn't allowed.
> >
> > Yes, I agree that would be better in general.  For (pseudo) registers,
>
> What exactly are these pseudo registers?  If it's something that's an immutable
> property of the (virtual) system, then it might make sense to use a separate,
> non-vCPU mechanism for setting/getting their values.  Then you can easily restrict
> the <whatever> to pre-created_vcpus, e.g. see x86's KVM_SET_IDENTITY_MAP_ADDR.
>
In general, these pseudo-registers are reserved non-architectural
register spaces, currently being used to represent KVM-as-a-firmware's
versioning across guests' migrations [1]. That is, the user-space
configures these registers for the guests to see same 'firmware'
versions before and after migrations. The model is built over the
existing KVM_GET_REG_LIST and KVM_[SET|GET]_ONE_REG APIs. Since this
series' efforts falls into the same realm, the idea was keep this
consistent with the existing model to which VMMs (such as QEMU) are
already used to.

Granted, even though these registers should technically be immutable,
there was no similar protection employed for the existing
psuedo-registers. I was wondering if that could be of any value if we
start providing one; But I guess not, since it may break the
user-space's expectations of KVM (and probably why we didn't have it
earlier).

Regards,
Raghavendra

[1]: https://github.com/torvalds/linux/blob/master/Documentation/virt/kvm/arm/psci.rst

> > I would think preventing modification if kvm->created_vcpus > 0 might
> > not be a very good option for KVM/ARM though considering usage of
> > KVM_GET_REG_LIST and KVM_{G,S}ET_ONE_REG.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
