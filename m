Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D7FC43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 17:25:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D9A74B3B5;
	Thu,  9 Jun 2022 13:25:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zYm8GUrERldM; Thu,  9 Jun 2022 13:24:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4551C4B354;
	Thu,  9 Jun 2022 13:24:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE3304B354
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 13:24:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sB3CzP0Wldd7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 13:24:56 -0400 (EDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com
 [209.85.210.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE7A54B34A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 13:24:56 -0400 (EDT)
Received: by mail-ot1-f42.google.com with SMTP id
 a21-20020a9d4715000000b0060bfaac6899so9052176otf.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jun 2022 10:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=+BsytC55p1uk/DN+lXBnGi/b/CJPb11S2aPURFUdMH0=;
 b=F8G+2xSU9+LS3+gruh9t36AQRGmeTGGZwcPMINt+vREwjujSNCz/ecGqPTwcUD8vvt
 jRBhFRZzDP1RABS+N+QfHvMZ3CAkzeDKvpbhNwmimc18igatudjVbYiXGbn1qRzkpNH/
 gLPvwqioZYlQTzIPZomlvO3B+28kQrKtxHhR9eP6NbHuBEZF7U1/DiLS1O9rqssCnU8E
 4LdIfiEnkFAogcyP+Z6dncM5AhychyWQ1P7ed4zQTHWngKTuUqdx7A/4Lf1Ekqmx+UwD
 B9VFqX8rD3e7ftJG2nf0rCIbT7KM+M4hxEoKpK0/JadEFZd92dPT9UUQvmUaXju0riLp
 bTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=+BsytC55p1uk/DN+lXBnGi/b/CJPb11S2aPURFUdMH0=;
 b=4PVtM4cSWll8bZv9n1W+XwUBJjfKoXoJ5ZRNZTqDH2kWPIFjIkI+V72WJRSu3Gk8oT
 9pXFyK7fnGeHKRx7PidZv6UaTz2BVPNVcD7euDKhn71wZ/j6rKvQAniJuCt8VZzpmDLd
 dKXVadrXS5Mbh/VCXFZcfS/OOFOJfi1VJLZMCSD3dWVhS/Ql/w0jnsoYOyNsrYRzSsV0
 uTjc7kwFSNC8r4zj+ZoTbOWg80xRuHDGC+nsDtZglweCcyH2u0dXoTdOj2OhP7oqXUmH
 jnWWEzy6JHiLETZ46kw01UyBf6GwK4xAgPdSxvhKo0ucbqo5MCWc+jvap/VQKe70K3KW
 iSnQ==
X-Gm-Message-State: AOAM531yqUZh0ikDjLvEXB/XNKTt+Sc/e0eYG0uX4bs9VqTZOtpHfSZL
 4p7TDhddOxwv/yIa6afErPWLpBJEOrw4ldDhtf2PLA==
X-Google-Smtp-Source: ABdhPJzAEY5Siu4Rp3xtx8yNN6n6u1qCejxChcZ1iqiG3vgy9D5BfpAY23LvF8c70/yvWTQMW4NGmd1YgUyK/PP+AZ8=
X-Received: by 2002:a05:6830:2a01:b0:606:d153:1ba0 with SMTP id
 y1-20020a0568302a0100b00606d1531ba0mr17837813otu.35.1654795495703; Thu, 09
 Jun 2022 10:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-7-maz@kernel.org>
 <CAAeT=FzXWDfkR5ck0vpiRLKi0nU9e5Ua=yg=3Rj--Gq+aBaVUg@mail.gmail.com>
 <87fske46tp.wl-maz@kernel.org>
In-Reply-To: <87fske46tp.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 9 Jun 2022 10:24:39 -0700
Message-ID: <CAAeT=FxH_rK9HT+-QLkbH9hn0LhObwCCTrbdqt0x--BgqtaK_g@mail.gmail.com>
Subject: Re: [PATCH 06/18] KVM: arm64: Add three sets of flags to the vcpu
 state
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Jun 9, 2022 at 12:47 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 09 Jun 2022 07:10:14 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > It so appears that each of the vcpu flags is really belonging to
> > > one of three categories:
> > >
> > > - a configuration flag, set once and for all
> > > - an input flag generated by the kernel for the hypervisor to use
> > > - a state flag that is only for the kernel's own bookkeeping
> > >
> > > As we are going to split all the existing flags into these three
> > > sets, introduce all three in one go.
> > >
> > > No functional change other than a bit of bloat...
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 5eb6791df608..c9dd0d4e22f2 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -338,6 +338,15 @@ struct kvm_vcpu_arch {
> > >         /* Miscellaneous vcpu state flags */
> > >         u64 flags;
> > >
> > > +       /* Configuration flags */
> > > +       u64 cflags;
> > > +
> > > +       /* Input flags to the hypervisor code */
> > > +       u64 iflags;
> > > +
> > > +       /* State flags, unused by the hypervisor code */
> > > +       u64 sflags;
> >
> > Although I think VCPU_SVE_FINALIZED could be considered "state" rather
> > than "configuration", I assume the reason why it is handled by cflags
> > in the following patches is because VCPU_SVE_FINALIZED is set once
> > for all. If my assumption is correct, it would be clearer to add
> > "set once and for all" in the comment for cflags.
>
> Yes, that's indeed the reason for this categorisation. In general,
> these flags are, as you put it, set once and for all extremely early
> (before the vcpu can run), and are never cleared. I'll update the
> comment accordingly.
>
> > Also, if we end up using VCPU_SVE_FINALIZED in hypervisor code later,
> > then should it be handled by iflags instead of cflags ?
>
> That'd be my expectation if they ended up changing state at some
> point. My view is that the cflags are immutable once the vcpu has
> run, and flags that can change state over the life if the vcpu
> shouldn't be in that category.
>
> >
> > My understanding of how those flags should be used is as follows.
> > Is my understanding correct ?
> >
> >  iflags: flags that are used by hypervisor code
>
> Yes. Crucially, they are used as an input to the hypervisor code: it
> either consumes these flags (INCREMENT_PC, PENDING_EXCEPTION), or
> consult them to decide what to do.
>
> >  cflags: flags that are set once for all and unused by hypervisor code
>
> Yes.

Thank you so much for the clarification.

I've just realized that GUEST_HAS_PTRAUTH (cflags) is used by
hypervisor code (kvm_hyp_handle_ptrauth and get_pvm_id_aa64isar{1,2}).
Shouldn't GUEST_HAS_PTRAUTH be handled as iflags ?
Or, in choosing one of these three for a flag, is immutability (once
the vcpu has run) the highest priority, followed by whether or not
it is used by hypervisor code ?

>
> >  sflags: flags that could be set/cleared more than once and unused
> >          by hypervisor code
>
> Yes. They are really bookkeeping flags for the kernel code.
>
> I'll try to incorporate some of that in the comments before reposting
> the series.

Thank you, that would be great since I was a bit concerned that
those flags might get mixed up in the future.

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
