Return-Path: <SRS0=wpbN=4K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C60AC35671
	for <kvmarm@archiver.kernel.org>; Sat, 22 Feb 2020 21:31:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 224AD206EF
	for <kvmarm@archiver.kernel.org>; Sat, 22 Feb 2020 21:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 224AD206EF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 722DB4AF32;
	Sat, 22 Feb 2020 16:31:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Dbn1JI2QmbS; Sat, 22 Feb 2020 16:31:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E1F4AEC0;
	Sat, 22 Feb 2020 16:31:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17A714ACE6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Feb 2020 16:31:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pSnxKZ2jmRcJ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 22 Feb 2020 16:31:53 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A80E24AC07
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Feb 2020 16:31:53 -0500 (EST)
Received: from mail-lf1-f41.google.com ([209.85.167.41]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MtOOm-1jQzDC1MdC-00uumT for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Feb
 2020 22:31:52 +0100
Received: by mail-lf1-f41.google.com with SMTP id b15so4071579lfc.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Feb 2020 13:31:51 -0800 (PST)
X-Gm-Message-State: APjAAAUmYQX/QZRzVUGoxCdMGXhWeYHkS7XV9fTtjgUnVuOQNg3Y8fsi
 JIAocu1HnWioYTlZPXQP819rtvilyJNubyQKJMA=
X-Google-Smtp-Source: APXvYqw08WaVpwqyvapB9jwmtZ9FkkkQyrz5uYJ12nY2XRMB6nrK7EaFW5taPH3fOq3Exia34Hd+8TSqfX93FnPLHNA=
X-Received: by 2002:ac2:5f62:: with SMTP id c2mr4862268lfc.207.1582407110902; 
 Sat, 22 Feb 2020 13:31:50 -0800 (PST)
MIME-Version: 1.0
References: <20200210141324.21090-1-maz@kernel.org>
 <20200222154030.5625fa5f.takashi@yoshi.email>
In-Reply-To: <20200222154030.5625fa5f.takashi@yoshi.email>
From: Arnd Bergmann <arnd@arndb.de>
Date: Sat, 22 Feb 2020 22:31:40 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3iaDqU7RRpoL2XyempBiKN8k22rNAM7C23n8JNpPm4qw@mail.gmail.com>
Message-ID: <CAK8P3a3iaDqU7RRpoL2XyempBiKN8k22rNAM7C23n8JNpPm4qw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To: Takashi Yoshi <takashi@yoshi.email>
X-Provags-ID: V03:K1:B7leW59WFsf1YO0Lf1fgzxgOX2ow/i4slqj0vUles4qR1dNrhZP
 +j4yTSDzYA4ACrvBUc0W4OVjqEWecNq+86Xo+WJU9iYKuXL48TVtfRQlgVQj8cDQH7prOCF
 GEsFsRWszwWPi2fUfXjiNax7nIbY5MboA5tnz1CGIjq8NczCesJpyEGmsD81TO9+q5FSzOS
 LXnCZTQqFvM1ZoercdA8Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3TykgSv4Nho=:VEa9BEU29rGEWzccunJThr
 1dJ+8BG6Bo22eLqYJGXnhS25ISVpl48CG3c82yqPUjYDbj1uNpJBrDw6AqiXCX0rXV3m2+FBX
 dKNqbhByqKp/iiOk4qpAVPASGI9nfo4Bgj74E0xtEupYVS2dwu0g05j8SYoI2o6POAR+3i76K
 cMqaL2jl5AS7L9U3UYW/mIAx+TtIGwZTzu+DF62Tk86AurJ18EWScLksbuNO5smtxbes7dHxF
 HL7MOI8XyDFu+h1FMErOxguhPxweq/jHXw3gTvNhS+yMfdtOc9q6gPfT3zDAsJIKLkpB4Al7b
 6//me0GGnguJdMq6eruvkn8/qTUIiD2HtowAwEVQ980nhhAuCdB1qN3YknLbkNTCwu2sA9Xi4
 W9u4aZqBlNaVEy3atM/HInKHxXAJjn0RkbFIFlU6p6T3Do6svi6zNKyReyaZ8c4+N9nA6mIAA
 CYFIKXQvR3K4B+M8ohcN8Jtx2RzqTMhoD37wcLoyzP6UnTz3hLe9tcG7JrrOucR042itN34yk
 LSgXYKXk8xQ8SuQ1/FW5dm/AnFNXlsknz3APVq//Ob90viHA3IBhsiRKuD7ynsr/mutzd4mQT
 9D031NEME9D53TaTAtr4tJnAW6J/3XOHUVlECeA+E4OBT4M7FKi9KbEyOYFrQJ3EqVH1xdJG5
 AElwgiL2f1a1O3DoIqfnGUPfnUnefxq4QtDOavnzDTB2nn8sZYLhTnlDz2RLGnC18zLQVtK0B
 OoFZdPwkvN2po4E0LhMrzggYIOVjMWer9DKQBHkFAx2qHIgKA0HT7bKRZvRyFYrcMCXqzcMmK
 CfxWdfsOGDyh31dHCZYZ46Tdg78E4sk4M0Lm2DOAGx28Q3LL4A=
Cc: Anders Berg <anders.berg@lsi.com>, Russell King <linux@arm.linux.org.uk>,
 kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

On Sat, Feb 22, 2020 at 3:40 PM Takashi Yoshi <takashi@yoshi.email> wrote:
> On Monday, 10.02.2020, 14:13 +0000 Marc Zyngier wrote:
> > KVM/arm was merged just over 7 years ago, and has lived a very quiet
> > life so far. It mostly works if you're prepared to deal with its
> > limitations, it has been a good prototype for the arm64 version,
> > but it suffers a few problems:
> >
> > - It is incomplete (no debug support, no PMU)
> > - It hasn't followed any of the architectural evolutions
> > - It has zero users (I don't count myself here)
>
> I might not be an important user, but I have been for multiple years
> and still am a regular user of KVM/arm32 on different devices.
>
> I use KVM on my Tegra K1 Chromebook for app development and have
> multiple SBCs at home on which I run VMs on using KVM+libvirt.
>
> Sure, neither of these devices has many resources available, but they
> are working fine. I would love to keep them in service since I haven't
> found arm64-based replacements that don't require hours upon hours of
> tinkering to just get a basic OS installation running with a mainline
> kernel.
>
> As an example that they can still be of use in 2020 I'd like to point
> out that one of the SBCs is running my DNS resolver, LDAP server,
> RSS reader, IRC bouncer, and shared todo list just fine, each in their
> separate VM.

Thank you for providing an important data point to this question.

> > - It is more and more getting in the way of new arm64 developments
> >
> > So here it is: unless someone screams and shows that they rely on
> > KVM/arm to be maintained upsteam, I'll remove 32bit host support
> > form the tree.
>
> *scream*
>
> > One of the reasons that makes me confident nobody is
> > using it is that I never receive *any* bug report. Yes, it is
> > perfect.
>
> This assumption is deeply flawed. Most users (including me) are not
> subscribed to this mailing list and will never find this thread at all.
> I myself stumbled upon this discussion just by chance while I was
> browsing the web trying to find something completely unrelated.
>
> I've been using KVM on x86, ppc and arm for many years, yet I never
> felt the need to report a bug on the mailing list.
> (This is to be interpreted as a compliment to the great work the devs
> of KVM have done!)
>
> Just going by the number of bugs reported on a developers mailing list
> is not going to paint an accurate picture.
>
> I am convinced that I'm not the only one relying on KVM/arm32 in the
> mainline kernel and would ask you to please reconsider keeping arm32 in
> the mainline kernel for a few more years until adequate arm64
> replacements are available on the market and have gained proper support
> in the mainline kernel.

Can you provide some more information about how you use KVM on 32-bit
machines, to make it possible to better estimate how many others might
do the same, and how long you will need to upgrade to newer kernels for?

In particular:

- What is the smallest amount of physical RAM that you have to found to
   make a usable ARM/KVM host? Note that the 4GB configuration of the
   Tegra K1 (an rk3288) Chromebooks seems to be extremely rare in other
   devices, while most new 32-bit SBCs come with 1GB or less these days.

- How often do you update the host kernels on those 32-bit machines that
  you still use to newer releases? What is the oldest/newest you run at the
  moment?

- Are you able to move the host installation to a distribution with a long-term
  stable release cycle such as Debian, Ubuntu that gives you a ~five year
  support after a kernel release?

         Arnd
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
