Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57CDC2BA2B
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:43:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 672E720787
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="anypSvL3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 672E720787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 148964B1A1;
	Fri, 10 Apr 2020 03:43:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V31LnefQIM2Q; Fri, 10 Apr 2020 03:43:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B04F4B1B2;
	Fri, 10 Apr 2020 03:43:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 775904B14A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 23:54:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QnrIPNRi-dG3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2020 23:54:22 -0400 (EDT)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 598364B147
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 23:54:22 -0400 (EDT)
Received: by mail-pg1-f178.google.com with SMTP id k191so461100pgc.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Apr 2020 20:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MVNHl8ZYPBjPp5ynGu7XA1fsdeRM/3jDxhZmbvgU1e4=;
 b=anypSvL3upk0MAF1Tfyk00TfNL5GQZ8vevHKsiqh7UvTg+qzxoxQgnPaCbYu6PfCLn
 0sMShIkh8eJvSanxewIVo66u3WyqXIzOO+aJL5DO4/sFRre2uD4cxkKDpHXt7e6llRh7
 cje4w6NrGwPj7BWphkx+VvgAQQMnc1lw/ZmuNJ3hWuKdoAc9dfkuHVZtHBW2RWUeKOgL
 wgJdsb/6tja3gIBZIzpK4zXbBlZvP8jjYrOUgLtjVnI7WDicw9XeAPeWfU64t+IrI0Vs
 O43hIXz0W+ElOBC5urpj0WnHenSS7i4gXDbfDiE18Pi6aFgJv9+P53SNsBGyc/ZIoT9/
 jQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MVNHl8ZYPBjPp5ynGu7XA1fsdeRM/3jDxhZmbvgU1e4=;
 b=pHmQw6YVj68NQ7K/BtdEJFVJ8OONxFDq7k29fJ6OqNlS/bhWZtxg3BJCa9C9pD6PN6
 IneS/4sWb1+eJmbK6nhWvPcn4E94ENnsAGxuD1jrQji4aT7crK9XC2Jp4gaQY6eRpn0k
 2nMmXOZs0CzzeOr305X+wSaAonE+l8frmp42keKdEKOtJKNjeERwUd/hadVU4W0eLxP/
 eMQ95xQX//GMyKmCkm/TqYMBF/axSwTT4rPDsFy2sfuSDGKK2EielNPV1aQLvyVX/ZYU
 3WeHHiDj4WXnYMx8gmJeTb+WtZjbyUNOPlHgjxJECi4oa84RPDKWTEpZ7bYQalBv1n7A
 mFrg==
X-Gm-Message-State: AGi0PuZEpuIXIXJor8YQsynUfAKNw/W2F9wkS4qBHjjyqIVKm07YUvge
 K5YxtsBJwqe+WaJA9++Cjsg8GzOErcbf+kRWLCE=
X-Google-Smtp-Source: APiQypKlXMme6WN2BengKpJW9xkiTJf2OghzarDKKYx+CcWmA8FP+kGaNbHMcM4Ltr2kIJdLIudBHPwG4v3PQe/GW0A=
X-Received: by 2002:a62:6dc1:: with SMTP id i184mr3063905pfc.25.1586490861043; 
 Thu, 09 Apr 2020 20:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
In-Reply-To: <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
From: Javier Romero <xavinux@gmail.com>
Date: Fri, 10 Apr 2020 00:54:10 -0300
Message-ID: <CAEX+82Lxv=Hrc3eDfUReSXpxv174swvmbnD1fXCgpxuzB_6NbQ@mail.gmail.com>
Subject: Re: Contribution to KVM.
To: like.xu@intel.com
X-Mailman-Approved-At: Fri, 10 Apr 2020 03:43:52 -0400
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
Content-Type: multipart/mixed; boundary="===============4102120347055436862=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4102120347055436862==
Content-Type: multipart/alternative; boundary="00000000000036423505a2e7b083"

--00000000000036423505a2e7b083
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Like Xu,

Thank you for your time to answer.

Yes, I can also test KVM in an Intel platform, have a Pixelbook with a Core
i7 processor and 16 GB of RAM at disposal to start working.

Thanks for your attention.

Regards,

El vie., 10 abr. 2020 00:34, Xu, Like <like.xu@intel.com> escribi=C3=B3:

> On 2020/4/10 5:29, Javier Romero wrote:
> > Hello,
> >
> >   My name is Javier, live in Argentina and work as a cloud engineer.
> >
> > Have been working with Linux servers for the last 10 years in an
> > Internet Service Provider and I'm interested in contributing to KVM
> Welcome, I'm a newbie as well.
> > maybe with testing as a start point.
> You may try the http://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> and tools/testing/selftests/kvm in the kernel tree.
> >
> > If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at
> disposal.
> If you test KVM on Intel platforms, you will definitely get support from
> me :D.
>
> Thanks,
> Like Xu
> >
> > Thanks for your kind attention.
> >
> > Best Regards,
> >
> >
> >
> > Javier Romero
>
>

--00000000000036423505a2e7b083
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div dir=3D"auto">Hi Like Xu,</div><div dir=3D"auto"><br>=
</div><div dir=3D"auto">Thank you for your time to answer.=C2=A0</div><div =
dir=3D"auto"><br></div><div dir=3D"auto">Yes, I can also test KVM in an Int=
el platform, have a Pixelbook with a Core i7 processor and 16 GB of RAM at =
disposal to start working.</div><div dir=3D"auto"><br></div><div dir=3D"aut=
o">Thanks for your attention.</div><div dir=3D"auto"><br></div><div dir=3D"=
auto">Regards,</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">E=
l vie., 10 abr. 2020 00:34, Xu, Like &lt;<a href=3D"mailto:like.xu@intel.co=
m">like.xu@intel.com</a>&gt; escribi=C3=B3:<br></div><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">On 2020/4/10 5:29, Javier Romero wrote:<br>
&gt; Hello,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0My name is Javier, live in Argentina and work as a cloud e=
ngineer.<br>
&gt;<br>
&gt; Have been working with Linux servers for the last 10 years in an<br>
&gt; Internet Service Provider and I&#39;m interested in contributing to KV=
M<br>
Welcome, I&#39;m a newbie as well.<br>
&gt; maybe with testing as a start point.<br>
You may try the <a href=3D"http://git.kernel.org/pub/scm/virt/kvm/kvm-unit-=
tests.git" rel=3D"noreferrer noreferrer" target=3D"_blank">http://git.kerne=
l.org/pub/scm/virt/kvm/kvm-unit-tests.git</a><br>
and tools/testing/selftests/kvm in the kernel tree.<br>
&gt;<br>
&gt; If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at dis=
posal.<br>
If you test KVM on Intel platforms, you will definitely get support from me=
 :D.<br>
<br>
Thanks,<br>
Like Xu<br>
&gt;<br>
&gt; Thanks for your kind attention.<br>
&gt;<br>
&gt; Best Regards,<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; Javier Romero<br>
<br>
</blockquote></div>

--00000000000036423505a2e7b083--

--===============4102120347055436862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4102120347055436862==--
