Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C587CC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 10:21:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44DAE61373
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 10:21:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 44DAE61373
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0DCD407F1;
	Mon, 23 Aug 2021 06:21:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oWvZjcj1QyAf; Mon, 23 Aug 2021 06:21:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADE0D4B1CB;
	Mon, 23 Aug 2021 06:21:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F9B74B1AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 06:21:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id imFqLYMgqqqv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 06:21:42 -0400 (EDT)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com
 [209.85.210.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 770A4407F1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 06:21:42 -0400 (EDT)
Received: by mail-ot1-f48.google.com with SMTP id
 v33-20020a0568300921b0290517cd06302dso34948761ott.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 03:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=SIoAG5g2ZaKJiQFYiR9SaO4E6gipkwSLQl5y4hOcarA=;
 b=gQR9xHDtBAfQ7agjkTp8NRtgfMZgp2tWmaTnwwDFtYUsSn8xoqh6FWO8lKEH3dgIuS
 lkoW4/+4SJ9dv9HEpfZFner4olxP4FJAYRyQAsSO+0ymOU7G9QKsaZ8UM0CtBIZ2N+XQ
 VM7BZVS4yQiUtU8oTJ4isjKYO4sTIprNB3aeykLN+cKzcbaHjcGvRFL+YjMoHNxtLgtj
 JdZARJ3RqzKvlbg+uoY1AccFAi6C7ginCERt4SFjHQ1B0EKnYV9lH+UXtdpR3YBoNByY
 9OdmFDtiqd4UAhNw5Sr4lQQ95igvDB9B5Mht/F40M8tUtFqho0gwwnIpzRq3duSkYYTT
 b00g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=SIoAG5g2ZaKJiQFYiR9SaO4E6gipkwSLQl5y4hOcarA=;
 b=Yx+MEGB6xNWOPAvKtmGO4W9jr9+A7Ao3JVnBFKNesHpYAZvfq4+xRG2YT63DBu6kNT
 d+HfCkNuGN4dmH7kiSA2+fiDM2zdT/DyEYthvrEfsqwR+ZtNZgrQqcNwA5q4JQFjwJ7W
 JDXvUEMFeZ2/75yIugTTOpFveQignbdQYqDVmFyr4VStbWBLPXmy59QXd7If8ExVwA9n
 wZN6vP7Jbi0+6XpLtfs6p6CcjD1+WuAFQxG7LbK/erAvz+qfmluVUgBTOFnYwHilL+/2
 +ExW/9lUyiMjZTuTkamQKLJSzzF5EZ2WvUHtDcqCNMTUN1jG7X0iFRlf/3lJ0uzTmfpa
 gKFg==
X-Gm-Message-State: AOAM533RV3395GxG0+anb7cDzk+fFV5af9yKkecjjU5M92qste68/vuU
 8vRCyVzbx4NPiNGctkZ/h9SMo3IKyg45pmaE9QykIQ==
X-Google-Smtp-Source: ABdhPJxVB/BIKUm3PHO6SrY9hnhKeihrCixbwenNombX7S3W6PJqEJkNgrfQet45jdjnvWcG2w43uFrI7fLY/KRecvc=
X-Received: by 2002:a9d:309:: with SMTP id 9mr27312697otv.365.1629714101736;
 Mon, 23 Aug 2021 03:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
 <20210817081134.2918285-12-tabba@google.com>
 <87fsv6snup.wl-maz@kernel.org> <87zgtdqz77.wl-maz@kernel.org>
In-Reply-To: <87zgtdqz77.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 23 Aug 2021 11:21:05 +0100
Message-ID: <CA+EHjTwyC-ZMpKQWGPqqYGHHR+YvyG3cdaxdwJfmYYf7XbBWEw@mail.gmail.com>
Subject: Re: [PATCH v4 11/15] KVM: arm64: Guest exit handlers for nVHE hyp
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Thu, Aug 19, 2021 at 3:36 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Wed, 18 Aug 2021 17:45:50 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Tue, 17 Aug 2021 09:11:30 +0100,
> > Fuad Tabba <tabba@google.com> wrote:
> > >
> > > Add an array of pointers to handlers for various trap reasons in
> > > nVHE code.
> > >
> > > The current code selects how to fixup a guest on exit based on a
> > > series of if/else statements. Future patches will also require
> > > different handling for guest exists. Create an array of handlers
> > > to consolidate them.
> > >
> > > No functional change intended as the array isn't populated yet.
> > >
> > > Acked-by: Will Deacon <will@kernel.org>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/include/hyp/switch.h | 43 +++++++++++++++++++++++++
> > >  arch/arm64/kvm/hyp/nvhe/switch.c        | 33 +++++++++++++++++++
> > >  2 files changed, 76 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > index a0e78a6027be..5a2b89b96c67 100644
> > > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > > @@ -409,6 +409,46 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
> > >     return true;
> > >  }
> > >
> > > +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
> >
> > This returns an int...
> >
> > > +
> > > +exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
> > > +
> > > +static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
> > > +{
> > > +   return is_nvhe_hyp_code() ? kvm_get_nvhe_exit_handler(vcpu) : NULL;
> > > +}
> > > +
> > > +/*
> > > + * Allow the hypervisor to handle the exit with an exit handler if it has one.
> > > + *
> > > + * Returns true if the hypervisor handled the exit, and control should go back
> > > + * to the guest, or false if it hasn't.
> > > + */
> > > +static bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu)
> > > +{
> > > +   bool is_handled = false;
> >
> > ... which you then implicitly cast as a bool.
> >
> > > +   exit_handle_fn exit_handler = kvm_get_hyp_exit_handler(vcpu);
> > > +
> > > +   if (exit_handler) {
> > > +           /*
> > > +            * There's limited vcpu context here since it's not synced yet.
> > > +            * Ensure that relevant vcpu context that might be used by the
> > > +            * exit_handler is in sync before it's called and if handled.
> > > +            */
> > > +           *vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
> > > +           *vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
> > > +
> > > +           is_handled = exit_handler(vcpu);
> >
> > What does 'is_handled' mean here? By definition, any trap *must* be
> > handled, one way or another. By the look of it, what you really mean
> > is something like "I have updated the vcpu state and you'd better
> > reload it". Is that what it means?
> >
> > > +
> > > +           if (is_handled) {
> > > +                   write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> > > +                   write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> > > +           }
> > > +   }
> > > +
> > > +   return is_handled;
> > > +}
> >
> > All these functions really should be marked inline. Have you checked
> > how this expands on VHE? I think some compilers could be pretty
> > unhappy about the undefined symbol in kvm_get_hyp_exit_handler().
> >
> > It is also unfortunate that we get a bunch of tests for various
> > flavours of traps (FP, PAuth, page faults...), only to hit yet another
> > decoding tree. Is there a way we could use this infrastructure for
> > everything?
>
> I realised that I wasn't very forthcoming here. I've decided to put
> the code where my mouth is and pushed out a branch [1] with your first
> 10 patches, followed by my own take on this particular problem. It
> compiles, and even managed to boot a Debian guest on a nVHE box.
>
> As you can see, most of the early exit handling is now moved to
> specific handlers, unifying the handling. For the protected mode, you
> can provide your own handler array (just hack
> kvm_get_exit_handler_array() to return something else), which will do
> the right thing as long as you call into the existing handlers first.
> When it comes to the ELR/SPSR handling, it is better left to the
> individual handlers (which we already do in some cases, see how we
> skip instructions, for example).
> Please let me know what you think.

Thanks a lot for this and sorry for being late to reply. I've been travelling.

I think that your proposal looks great. All handling is consolidated
now and handling for protected VMs can just be added on top. There are
some small issues with what parameters we need (e.g., passing struct
kvm to kvm_get_exit_handler_array), but I will sort them out and
submit them in the next round.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pkvm-fixed-features
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
