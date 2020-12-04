Return-Path: <SRS0=T6xz=FI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7733CC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 08:25:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B827E225A9
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 08:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B827E225A9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC2994B2C7;
	Fri,  4 Dec 2020 03:25:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oLBEu01AfYJ5; Fri,  4 Dec 2020 03:25:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACDBD4B2B7;
	Fri,  4 Dec 2020 03:25:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E6BC4B2B7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 03:25:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lXAIIsfvX-Ht for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2020 03:25:45 -0500 (EST)
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com
 [209.85.166.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F65B4B290
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 03:25:45 -0500 (EST)
Received: by mail-il1-f196.google.com with SMTP id y9so4498932ilb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Dec 2020 00:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=A/TF5i4Gpjq2x74Bg7OwEl9WA0OZL7YpdQhrSnvWrv4=;
 b=OPghMrWVhw0KraiEKIxFNUIiv9v/utgcP8RFjVVwweLxyG1yQ6badbCjfRCz8Yn/a/
 K8XVmn2OQhZVNM/SPJ+hSXWZPcprNliCA96iA5H2YTPIkSI+To7TM+ncl5TP3TLFQX8G
 ZgyS/WCmMszzpdtiErIxepqQziNv5JIAYG1rIbw4pbI4WfU1rAqOLmjgWZqpx5vJTa6C
 NaCQl1EMRJIjPVMh/VbKRSzmsgnPEodsCDY7OKRg+vGNisWXYhlGsvL4LeZwcSTERFjc
 2tbQdvxblnTk0ocqfgkRuM1uVsz9zq0P9UhaxwMq8TufgrPltfbvWaovagbC7sd3OSd+
 MThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=A/TF5i4Gpjq2x74Bg7OwEl9WA0OZL7YpdQhrSnvWrv4=;
 b=KCKlFL4siZ8WvJcq3VwvCYPPfYnqNICAdh3myqbOFh2efQr1Vz1GO0VBP6dmhu/1SJ
 mG7191oUIa4VwogFg9GCxELK3LZu2P+EaKXlzSlaEoqbo1RDdMP7l4I8VgXxjeOlF0NJ
 r60mjelK8ygktxwVWEQW5a0XCiWDlW+FUkxNs6TyFv3zyQ6w3oTsZncjJ8Kikhq8pk3H
 zNqQGcC5Wgs5nfQJ/5QP+upVQLNv/QQgE6GN+0x+LHps4YRjstmu6hSuF6ztYt/RWkJ/
 Th0vyn3D5Q6Wvf2NFudwnlrLjcVgHw9gy3YkDe27QrFakd8LbBzsrU/VW50insAgw0pV
 Tl8g==
X-Gm-Message-State: AOAM5331AWJn2jrlux9cP5kdi5z3UdhXZAFrSXWTjgpjvMzcQVt3PDOC
 GUDlyPiFh/xzLjwr1wFTL69A+jFUrpY90KQFiIDs
X-Google-Smtp-Source: ABdhPJxOUP7ZPr/TNKGDu7k4ned1HHOOyRF1U5Rs11h7us/dHdLm0ThGcpAs0FZbo8LMkEqfsiU+DKkBEQh37fbmq7w=
X-Received: by 2002:a92:98db:: with SMTP id a88mr4401294ill.106.1607070344665; 
 Fri, 04 Dec 2020 00:25:44 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
In-Reply-To: <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Fri, 4 Dec 2020 16:25:33 +0800
Message-ID: <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Steven Price <steven.price@arm.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Juan Quintela <quintela@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Dave Martin <Dave.Martin@arm.com>
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

On Fri, 20 Nov 2020 at 17:51, Steven Price <steven.price@arm.com> wrote:
>
> On 19/11/2020 19:11, Marc Zyngier wrote:
> > On 2020-11-19 18:42, Andrew Jones wrote:
> >> On Thu, Nov 19, 2020 at 03:45:40PM +0000, Peter Maydell wrote:
> >>> On Thu, 19 Nov 2020 at 15:39, Steven Price <steven.price@arm.com> wrote:
> >>> > This series adds support for Arm's Memory Tagging Extension (MTE) to
> >>> > KVM, allowing KVM guests to make use of it. This builds on the
> >>> existing
> >>> > user space support already in v5.10-rc1, see [1] for an overview.
> >>>
> >>> > The change to require the VMM to map all guest memory PROT_MTE is
> >>> > significant as it means that the VMM has to deal with the MTE tags
> >>> even
> >>> > if it doesn't care about them (e.g. for virtual devices or if the VMM
> >>> > doesn't support migration). Also unfortunately because the VMM can
> >>> > change the memory layout at any time the check for PROT_MTE/VM_MTE has
> >>> > to be done very late (at the point of faulting pages into stage 2).
> >>>
> >>> I'm a bit dubious about requring the VMM to map the guest memory
> >>> PROT_MTE unless somebody's done at least a sketch of the design
> >>> for how this would work on the QEMU side. Currently QEMU just
> >>> assumes the guest memory is guest memory and it can access it
> >>> without special precautions...
> >>>
> >>
> >> There are two statements being made here:
> >>
> >> 1) Requiring the use of PROT_MTE when mapping guest memory may not fit
> >>    QEMU well.
> >>
> >> 2) New KVM features should be accompanied with supporting QEMU code in
> >>    order to prove that the APIs make sense.
> >>
> >> I strongly agree with (2). While kvmtool supports some quick testing, it
> >> doesn't support migration. We must test all new features with a migration
> >> supporting VMM.
> >>
> >> I'm not sure about (1). I don't feel like it should be a major problem,
> >> but (2).
>
> (1) seems to be contentious whichever way we go. Either PROT_MTE isn't
> required in which case it's easy to accidentally screw up migration, or
> it is required in which case it's difficult to handle normal guest
> memory from the VMM. I get the impression that probably I should go back
> to the previous approach - sorry for the distraction with this change.
>
> (2) isn't something I'm trying to skip, but I'm limited in what I can do
> myself so would appreciate help here. Haibo is looking into this.
>

Hi Steven,

Sorry for the later reply!

I have finished the POC for the MTE migration support with the assumption
that all the memory is mapped with PROT_MTE. But I got stuck in the test
with a FVP setup. Previously, I successfully compiled a test case to verify
the basic function of MTE in a guest. But these days, the re-compiled test
can't be executed by the guest(very weird). The short plan to verify
the migration
is to set the MTE tags on one page in the guest, and try to dump the migrated
memory contents.

I will update the status later next week!

Regards,
Haibo

> >>
> >> I'd be happy to help with the QEMU prototype, but preferably when there's
> >> hardware available. Has all the current MTE testing just been done on
> >> simulators? And, if so, are there regression tests regularly running on
> >> the simulators too? And can they test migration? If hardware doesn't
> >> show up quickly and simulators aren't used for regression tests, then
> >> all this code will start rotting from day one.
>
> As Marc says, hardware isn't available. Testing is either via the Arm
> FVP model (that I've been using for most of my testing) or QEMU full
> system emulation.
>
> >
> > While I agree with the sentiment, the reality is pretty bleak.
> >
> > I'm pretty sure nobody will ever run a migration on emulation. I also doubt
> > there is much overlap between MTE users and migration users, unfortunately.
> >
> > No HW is available today, and when it becomes available, it will be in
> > the form of a closed system on which QEMU doesn't run, either because
> > we are locked out of EL2 (as usual), or because migration is not part of
> > the use case (like KVM on Android, for example).
> >
> > So we can wait another two (five?) years until general purpose HW becomes
> > available, or we start merging what we can test today. I'm inclined to
> > do the latter.
> >
> > And I think it is absolutely fine for QEMU to say "no MTE support with KVM"
> > (we can remove all userspace visibility, except for the capability).
>
> What I'm trying to achieve is a situation where KVM+MTE without
> migration works and we leave ourselves a clear path where migration can
> be added. With hindsight I think this version of the series was a wrong
> turn - if we return to not requiring PROT_MTE then we have the following
> two potential options to explore for migration in the future:
>
>   * The VMM can choose to enable PROT_MTE if it needs to, and if desired
> we can add a flag to enforce this in the kernel.
>
>   * If needed a new kernel interface can be provided to fetch/set tags
> from guest memory which isn't mapped PROT_MTE.
>
> Does this sound reasonable?
>
> I'll clean up the set_pte_at() change and post a v6 later today.
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
