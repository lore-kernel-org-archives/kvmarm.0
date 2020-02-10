Return-Path: <SRS0=nwVD=36=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFADC352A3
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 15:55:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53D3520714
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 15:55:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53D3520714
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C776C4AC07;
	Mon, 10 Feb 2020 10:55:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sKIKbJvIXhIl; Mon, 10 Feb 2020 10:55:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C36014A500;
	Mon, 10 Feb 2020 10:55:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC0EA4A500
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 10:55:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G-xIN1pAryrH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Feb 2020 10:55:11 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E58F4A4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 10:55:11 -0500 (EST)
Received: from mail-qv1-f44.google.com ([209.85.219.44]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mgefy-1jiBeM0h80-00h2aq for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb
 2020 16:55:10 +0100
Received: by mail-qv1-f44.google.com with SMTP id p2so3374417qvo.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 07:55:09 -0800 (PST)
X-Gm-Message-State: APjAAAVQfGHtMFh2xKhfECXPciN1hQr3W59pDDG+JfRbL0PqblRDNei+
 E/5yeSlU1fLVK4mr6/3MVPyss8zY8ruP6vOAwA4=
X-Google-Smtp-Source: APXvYqzD4gF79za8QjGnOdvdxMye/9gCcsvE1sbWfcQ/2Iho40EJZiFepFIPJyPs4Sj+zYmpLY+XdCjR8myFcnfghrI=
X-Received: by 2002:a0c:f9c7:: with SMTP id j7mr10699586qvo.222.1581350108754; 
 Mon, 10 Feb 2020 07:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20200210141324.21090-1-maz@kernel.org>
 <CAOesGMhHkez-5vxwWuzXc2Rm=dYYWjMX9C8AewVy9GDWuZcwMw@mail.gmail.com>
In-Reply-To: <CAOesGMhHkez-5vxwWuzXc2Rm=dYYWjMX9C8AewVy9GDWuZcwMw@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 10 Feb 2020 16:54:52 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1pi3yBVMdXQyZsm_NFLn=UrVRgQ2O5b3-RmF9JTi5z7A@mail.gmail.com>
Message-ID: <CAK8P3a1pi3yBVMdXQyZsm_NFLn=UrVRgQ2O5b3-RmF9JTi5z7A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To: Olof Johansson <olof@lixom.net>
X-Provags-ID: V03:K1:IS9W+P21wmJQXqktES9f8w0QZuq1ROF3Jv6ZI98hU/1Wr6EZqh7
 h8zKxi/t0HvFVKy951epP/balt8VMOQSQmYM4SE1MWFK8CwJ19NFiSdT3CRmpYpYx8gA6PH
 UlJwXV2nA9TVH+TavhphvfC3mTLDxluELkXbKwZIzmH4LAy5TzHG6M5+o/Vnw2rQ8dCRd7F
 eV9qZ/82nKZOKvGlRIX2A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YZ6YyeguxZ4=:Wfc2Yznkj2hbyDbLdaTGI/
 vL27+dZ5PCdz8fq+c48mn+jq15N12AaWtcBAUYSP6DVomUrQe/C4rHcQIwGzLwDKrQJ9Ztd+Q
 0fKDvVOQR1dAIJrqepyVtg/kqpu8EAAHBAYsMYCAyVp4gAobNPcRf1PqrfO2s5Sd0go01nH/N
 eqJ8CB6HrwHdEGDFzy/WzT82bbu0VrHJrhe7yPv08bzllUy5aJq6U5WjjKkglcVJrM3xh55rX
 0899188iT5OGbRTg1iI3t+M8cxvQgzxwCrau+1dy/dmwTV7H3eVarn98xKLWR38q/ixuYsT4Z
 FHxkt0qkX5VaIhZba/yS80++HN96hxjtt28kZhi/xfMMgJ0QPTvPTXsvDjDSIw+zDFtoXROmU
 Y246wWyla1DyUmneKA4z7FQ9i5FgJe/MUMHk9avxnfbFOM0wRlwDqHZBkEBEzDryvABc5Hut6
 MwbneP+qn3A7A3inF8LhAuAnLJYChQa622Ve8fgKc8G1EQEkIgp5TWUoSO5uJ7t5eEbnPael2
 Cm+Upi0pk/6U0uPj9EHXcplxDUKIHVRNQB151ZKT6PbGDxSBvWYWZn5QrniEFjPgj+w+xQzLr
 bBB6VFfP7doTF7YcIrog/ec7qCZkbU4a6FSQ6M6oc5BBqtM0o2WB5f5LL/IkqPkHJsPyqagoL
 t46VfLTBXyCJxNhyC30LyK3U2hBmi3gCoiRmypm0XnDH8nkBcTBHIOl7UiD3Pa4m0BqYGdROi
 QFGF2eFA6UIuSV+dNfVC99Gz4jsQZvLk9MiU6Dw8JLwUz/9lbks9A6mE+P1hHKs0ILi6/R/9W
 HjdiMMsVENuHomw5vaO5E+So5h4rxeZRcWY877BaZx6+Mxv0Lw=
Cc: Anders Berg <anders.berg@lsi.com>, Russell King <linux@arm.linux.org.uk>,
 kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
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

On Mon, Feb 10, 2020 at 4:32 PM Olof Johansson <olof@lixom.net> wrote:
> On Mon, Feb 10, 2020 at 3:13 PM Marc Zyngier <maz@kernel.org> wrote:
> >
> > KVM/arm was merged just over 7 years ago, and has lived a very quiet
> > life so far. It mostly works if you're prepared to deal with its
> > limitations, it has been a good prototype for the arm64 version,
> > but it suffers a few problems:
> >
> > - It is incomplete (no debug support, no PMU)
> > - It hasn't followed any of the architectural evolutions
> > - It has zero users (I don't count myself here)
> > - It is more and more getting in the way of new arm64 developments
> >
> > So here it is: unless someone screams and shows that they rely on
> > KVM/arm to be maintained upsteam, I'll remove 32bit host support
> > form the tree. One of the reasons that makes me confident nobody is
> > using it is that I never receive *any* bug report. Yes, it is perfect.
> > But if you depend on KVM/arm being available in mainline, please shout.
> >
> > To reiterate: 32bit guest support for arm64 stays, of course. Only
> > 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
> > arm64, and cleanup all the now unnecessary abstractions.

I think this makes a lot of sense: we are seeing fewer new 32-bit
systems that have enough RAM to be a usable virtualization host,
as most new boards with more than 1GB of RAM typically pick 64-bit
SoCs, and on less than 1GB it gets awfully tight to do anything useful.

> Since I'm generally happy to drop legacy code that has no users, with
> the "if there are any significant users that speak up, I'll revoke my
> support" caveat:
>
> Acked-by: Olof Johansson <olof@lixom.net>

Same here

Acked-by: Arnd Bergmann <arnd@arndb.de>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
