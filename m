Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AB0C2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:55:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68C5821D6C
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="KhzzCsW8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68C5821D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9FFC4B292;
	Fri, 17 Apr 2020 09:55:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i2mvzNZHRobT; Fri, 17 Apr 2020 09:55:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D38474B27D;
	Fri, 17 Apr 2020 09:55:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2D9A4B270
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:55:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QGolX1uNWIzW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 09:55:02 -0400 (EDT)
Received: from mail-lf1-f66.google.com (mail-lf1-f66.google.com
 [209.85.167.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E7A94B18E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:55:02 -0400 (EDT)
Received: by mail-lf1-f66.google.com with SMTP id w145so1872446lff.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 06:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=7AmCzHziUNQjZKx/GvRDLlovtwxps0R41sZXYTBltWo=;
 b=KhzzCsW89wuZH4XBOiK/TZJ5YVwP21aa8wjCMikz8yuELhgoJKFMD4xUVgUFFQmXAd
 PKSXoERg96lKfzxvbjxnBg3STfSGnV6UgGeOMJQ9rBJl2QACOYVD7jv31vDz3pvbRncb
 9pQPmmsqGPVxw9rBwBCf3qVCmIphYx2Dp/5jSLTn1qBBGpSaIi91Qxt8iJF5fejPb49m
 Vy7QQcrVtFxMlG+9Axc0E324ikb4WczdFI3QsBTH3/TPNvEr9rLxwc2Y10f6tI1BJuZL
 sJEpkgasrNWdq83nOxyUNaeb5wHJNa5zsso9BM0rggnHEwJmgWTBekHDDCLHmPd67+Ny
 Rx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=7AmCzHziUNQjZKx/GvRDLlovtwxps0R41sZXYTBltWo=;
 b=Y+4DrAwc548Nt8/bh0TGEgh1Ojtue+KTQ0fsCgjKdo5Fdyu4vMtilh/arPcy/Ezk68
 LINQ/lMBrYbh9N47/I5au1OPLhUqMPa7VQ2v5sa7uzOV+CP/OYtCqU+4g2IU5nATfKbP
 eeyO/j91Vq8aZ4vz2uQc+OIgPeALJ0KJioizvJ5Spx+loHvsvtc+4AKOpXKvRJTd/0g8
 ZCqlmJ4zHZPIHMbLI+LtV9mFV7THzl+loAac+2U6JkDbOGDfzmk/dNhaJp1NpTXZJOqQ
 Nj5obQ0j3uY+Z0YC9Z+LRoXJHz+5X5udtJG2Z14wNOqZHYN18sAAdcsJTCZqljsOBCX8
 q53Q==
X-Gm-Message-State: AGi0PuYOAaypwmrBDhixiFoTU7Rtn4062MvdeMlY5yfvczH6XW+jtv1T
 wt3GDVkt998LoFwr9FTGmpQ57Wk4/TCF6MOHJbr4gQ==
X-Google-Smtp-Source: APiQypKxt49oWNGHv4Ehehb9p6eJecpAtwGk+7fddRZHgIrI5oQWFbyzBKavAE3w0VQw5awX56Navc9x+UvWLX0VYS4=
X-Received: by 2002:a19:c385:: with SMTP id t127mr2149601lff.117.1587131701036; 
 Fri, 17 Apr 2020 06:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200417085522.150701-1-tabba@google.com>
 <50eb0bea7691f2430e4dfa72a1a22a73@kernel.org>
In-Reply-To: <50eb0bea7691f2430e4dfa72a1a22a73@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 17 Apr 2020 14:54:25 +0100
Message-ID: <CA+EHjTzucz9Dv=OUt8FgJBPaSu_35cE1e4Vtquhc7_OkKPiy=g@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: arm64: Tidy up arch Kconfig and Makefiles
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============4640943089137602819=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4640943089137602819==
Content-Type: multipart/alternative; boundary="00000000000040ded605a37ce5cf"

--00000000000040ded605a37ce5cf
Content-Type: text/plain; charset="UTF-8"

Thanks for the review Marc.  I'll post v2 shortly.

Cheers,
/fuad

On Fri, Apr 17, 2020 at 10:29 AM Marc Zyngier <maz@kernel.org> wrote:

> Hi Fuad,
>
> Thanks for this.
>
> On 2020-04-17 09:55, Fuad Tabba wrote:
> > Hi,
> >
> > This small patch series tidies up the arm64 KVM build system by
> > rejigging config options, removing some redundant help text, and
> > consolidating some of the Makefile rules.
> >
> > The changes are cosmetic, but it seemed worthwhile to send this out
> > for consideration.
>
> Happy to take these patches for 5.8. Could you please rebase them on top
> of [1], which moves all of the (now arm64-specific) code where it
> belongs?
>
> Cheers,
>
>          M.
>
> [1]
>
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/welcome-home
> --
> Jazz is not dead. It just smells funny...
>

--00000000000040ded605a37ce5cf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for the review Marc.=C2=A0 I&#39;ll post v2 shortly=
.<div><br></div><div>Cheers,</div><div>/fuad</div></div><br><div class=3D"g=
mail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Apr 17, 2020 at 1=
0:29 AM Marc Zyngier &lt;<a href=3D"mailto:maz@kernel.org">maz@kernel.org</=
a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi=
 Fuad,<br>
<br>
Thanks for this.<br>
<br>
On 2020-04-17 09:55, Fuad Tabba wrote:<br>
&gt; Hi,<br>
&gt; <br>
&gt; This small patch series tidies up the arm64 KVM build system by<br>
&gt; rejigging config options, removing some redundant help text, and<br>
&gt; consolidating some of the Makefile rules.<br>
&gt; <br>
&gt; The changes are cosmetic, but it seemed worthwhile to send this out<br=
>
&gt; for consideration.<br>
<br>
Happy to take these patches for 5.8. Could you please rebase them on top<br=
>
of [1], which moves all of the (now arm64-specific) code where it <br>
belongs?<br>
<br>
Cheers,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0M.<br>
<br>
[1] <br>
<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platform=
s.git/log/?h=3Dkvm-arm64/welcome-home" rel=3D"noreferrer" target=3D"_blank"=
>https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/=
?h=3Dkvm-arm64/welcome-home</a><br>
-- <br>
Jazz is not dead. It just smells funny...<br>
</blockquote></div>

--00000000000040ded605a37ce5cf--

--===============4640943089137602819==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4640943089137602819==--
