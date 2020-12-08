Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3A0C4361B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 09:51:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04B7E23A84
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 09:51:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04B7E23A84
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3737C4B1C1;
	Tue,  8 Dec 2020 04:51:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qBv2HSGZ-J6P; Tue,  8 Dec 2020 04:51:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1C0E4B0F5;
	Tue,  8 Dec 2020 04:51:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 640D34B0D9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 04:51:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UWAJHEcteLqY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 04:51:36 -0500 (EST)
Received: from mail-il1-f195.google.com (mail-il1-f195.google.com
 [209.85.166.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7498C4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 04:51:36 -0500 (EST)
Received: by mail-il1-f195.google.com with SMTP id j12so7817226ilk.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 01:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=lICLkvZe3ToayMLnSKCmLUo/K0jAtkBksOUim1ibfBY=;
 b=VN5ue7ud1agT4R98hMSjewuu2LrhcoCORuoWMvUQhM7WIE3bjCyU1RI+UgBzBQJvSa
 DeJL9Vj1lqwp73sDe7qAZCQGzPaV38h3Ak992sNOyFdK9N7Dm3uDnwV9u6kk0wf5oLPB
 uO9PIK/I6Z6GNd0ccNasHlSEBZ2nO8mOiEDhptmjoIfoInncgQvQccrrwtJUCDzYB30P
 Cy88O7m1MgujhOWND/z3r645zM41SRjSULqc4yb+GHroCLcQnzvhXbpI+hCbEMx3n4TS
 sc2KpyZHMAx+YZQUcK9AZRa23RmwmxNGJ+uTYKUKf5/xrlbqSZ0h5j00nmz/ND5XE8Ei
 fmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=lICLkvZe3ToayMLnSKCmLUo/K0jAtkBksOUim1ibfBY=;
 b=j50m9t1pLdotLBgPn5D1vY5MatvMTpPfwVdRcOcGsp5RLSUZoOF9kSOPr8KaqD9s2y
 Q8ylgvH4+rxp6iYa7yoaIOQGrUPiKpZ0wz9UzbXDyauvtsYAMkf0xUQbLrpRP/s6zhUA
 Z6DsNgXYVKX+Ej8QWS+PoM33Ct37VvqtyCfH08tbyGmlQr9dasli+Va9OjhOoaKsqekx
 Leng4n9qPBJc0f2r2gquugjBoxZ6QFd0GkaLTzR+EXu2MnKMUR52EoQHFBrIdlQps0ti
 YgVZ7alek/TYtuLxIhMYbnckVBntSRogz5s4liC/tEp2lCfoJFLJrecghNKdpHB6NrWY
 lQEg==
X-Gm-Message-State: AOAM533+YrfPNhrZTnZe3MxRXzVI+MpEXcdZM67wsM0boj7IFHc1bYtL
 uMlpIjFhGEU9k56ydTLiNTuAx+pDactJWTqB/++W
X-Google-Smtp-Source: ABdhPJwGCf1kaRkx/7nAHZDQ/wyyZFTaySkgpZz9i3yxGq+ecwqhoNO47BJ7xfQcGlhhOsqN9O7eP92qE6AOnkqP+v4=
X-Received: by 2002:a92:b6c3:: with SMTP id m64mr15859393ill.23.1607421095680; 
 Tue, 08 Dec 2020 01:51:35 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
In-Reply-To: <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Tue, 8 Dec 2020 17:51:24 +0800
Message-ID: <CAJc+Z1FRJR5LHw-xZvPpeYF6+v+ZOcLt99X41xOMAbFmB2DJ2A@mail.gmail.com>
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

On Mon, 7 Dec 2020 at 22:48, Steven Price <steven.price@arm.com> wrote:
>
> On 04/12/2020 08:25, Haibo Xu wrote:
> > On Fri, 20 Nov 2020 at 17:51, Steven Price <steven.price@arm.com> wrote:
> >>
> >> On 19/11/2020 19:11, Marc Zyngier wrote:
> >>> On 2020-11-19 18:42, Andrew Jones wrote:
> >>>> On Thu, Nov 19, 2020 at 03:45:40PM +0000, Peter Maydell wrote:
> >>>>> On Thu, 19 Nov 2020 at 15:39, Steven Price <steven.price@arm.com> wrote:
> >>>>>> This series adds support for Arm's Memory Tagging Extension (MTE) to
> >>>>>> KVM, allowing KVM guests to make use of it. This builds on the
> >>>>> existing
> >>>>>> user space support already in v5.10-rc1, see [1] for an overview.
> >>>>>
> >>>>>> The change to require the VMM to map all guest memory PROT_MTE is
> >>>>>> significant as it means that the VMM has to deal with the MTE tags
> >>>>> even
> >>>>>> if it doesn't care about them (e.g. for virtual devices or if the VMM
> >>>>>> doesn't support migration). Also unfortunately because the VMM can
> >>>>>> change the memory layout at any time the check for PROT_MTE/VM_MTE has
> >>>>>> to be done very late (at the point of faulting pages into stage 2).
> >>>>>
> >>>>> I'm a bit dubious about requring the VMM to map the guest memory
> >>>>> PROT_MTE unless somebody's done at least a sketch of the design
> >>>>> for how this would work on the QEMU side. Currently QEMU just
> >>>>> assumes the guest memory is guest memory and it can access it
> >>>>> without special precautions...
> >>>>>
> >>>>
> >>>> There are two statements being made here:
> >>>>
> >>>> 1) Requiring the use of PROT_MTE when mapping guest memory may not fit
> >>>>     QEMU well.
> >>>>
> >>>> 2) New KVM features should be accompanied with supporting QEMU code in
> >>>>     order to prove that the APIs make sense.
> >>>>
> >>>> I strongly agree with (2). While kvmtool supports some quick testing, it
> >>>> doesn't support migration. We must test all new features with a migration
> >>>> supporting VMM.
> >>>>
> >>>> I'm not sure about (1). I don't feel like it should be a major problem,
> >>>> but (2).
> >>
> >> (1) seems to be contentious whichever way we go. Either PROT_MTE isn't
> >> required in which case it's easy to accidentally screw up migration, or
> >> it is required in which case it's difficult to handle normal guest
> >> memory from the VMM. I get the impression that probably I should go back
> >> to the previous approach - sorry for the distraction with this change.
> >>
> >> (2) isn't something I'm trying to skip, but I'm limited in what I can do
> >> myself so would appreciate help here. Haibo is looking into this.
> >>
> >
> > Hi Steven,
> >
> > Sorry for the later reply!
> >
> > I have finished the POC for the MTE migration support with the assumption
> > that all the memory is mapped with PROT_MTE. But I got stuck in the test
> > with a FVP setup. Previously, I successfully compiled a test case to verify
> > the basic function of MTE in a guest. But these days, the re-compiled test
> > can't be executed by the guest(very weird). The short plan to verify
> > the migration
> > is to set the MTE tags on one page in the guest, and try to dump the migrated
> > memory contents.
>
> Hi Haibo,
>
> Sounds like you are making good progress - thanks for the update. Have
> you thought about how the PROT_MTE mappings might work if QEMU itself
> were to use MTE? My worry is that we end up with MTE in a guest
> preventing QEMU from using MTE itself (because of the PROT_MTE
> mappings). I'm hoping QEMU can wrap its use of guest memory in a
> sequence which disables tag checking (something similar will be needed
> for the "protected VM" use case anyway), but this isn't something I've
> looked into.

As far as I can see, to map all the guest memory with PROT_MTE in VMM
is a little weird, and lots of APIs have to be changed to include this flag.
IMHO, it would be better if the KVM can provide new APIs to load/store the
guest memory tag which may make it easier to enable the Qemu migration
support.

>
> > I will update the status later next week!
>
> Great, I look forward to hearing how it goes.
>
> Thanks,
>
> Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
