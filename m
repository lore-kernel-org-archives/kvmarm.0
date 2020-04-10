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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DF2C2BB55
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:43:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE76620787
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 07:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0zKh1py"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE76620787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46C6A4B1D6;
	Fri, 10 Apr 2020 03:43:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cz5KLXZRJgK2; Fri, 10 Apr 2020 03:43:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20BA74B1B6;
	Fri, 10 Apr 2020 03:43:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D75E4B14A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 23:56:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gUSNamXbWqo6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2020 23:56:40 -0400 (EDT)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7690B4B147
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 23:56:40 -0400 (EDT)
Received: by mail-pl1-f175.google.com with SMTP id t4so263286plq.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Apr 2020 20:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=LUBOPzfAetNSR8BCew1KrCqC64hkQ/+V5xFI4/AtUZY=;
 b=k0zKh1py7ez2vEXKKqFmXos7LMRP21xyPQbes8Xgww9YP+xnA3UJtkuQNp+bm62RqE
 ajtLmJp8l3ATV2eghEarvxJ7rxPgWfA2tbr/LjwjScG7hvtE8G9Ya+mYQeO51spLzN68
 tsNIvgrEedV6YMrMYnmrXAsBl5Q7fqCi96IebYqBleQ5oNENi2HsSF6kxSrZBYEnimUn
 yfIYEXK3IWLMVB/ytRUztiW7NQkWw1CT0We0SwoC8CR9RO0lamRR09VRg8+Ors8MzBk0
 OKUer9MQlNrjsDHqNZDsjbZMPci3BNZSdvCT00MpCl5q4AEUa1hcR1kbEwO8o+eAvv0D
 JbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=LUBOPzfAetNSR8BCew1KrCqC64hkQ/+V5xFI4/AtUZY=;
 b=uhlnHRxXeMBT0zeLyioeJQUtRMcMD/9B3AzdeZAU1M7z0Ifn7K5UjTXJJ4unMEJ1rE
 /ZYAS3azeM952J47ae9yV+1Ezd6rSOIE+XIdAxylYDaoHeEMrp9Kjht4e/wZhu2ZLOqS
 7LxEdgj832eVGx+u1u29C8Rubkr51Fi9AMROlaNpgDrJeabhFzDmPUZaX900XfNZLLqC
 ZnrB8y/ndeCwQo/LLj4eFytPS8q5Bw1cHbA1AdLkX8ZGxrwglqXKuL8hLsMzyDVxjvTn
 ijDoAGXJbuI/wX5usCEhcY4nP3R/9doCjFboyEVgy0cIt6hdRYp7d6KFwY8qXO2tV/DZ
 wPXQ==
X-Gm-Message-State: AGi0Pub6wxuSZQpTbupRJZW5+vS1xV/hRklXwIOEgJKWocfVJwsjX8IL
 RBNDbL3hN2UeCvqXYlLKpCk+jwgSEdbX9ijQ07s=
X-Google-Smtp-Source: APiQypIgi9AV+0GlesE4hTiVUswHLA/3j/OYr0SAls811CE+zAB/EuHn35RgNCKCGFEgQQxZw4inzFBE3Eqv2GNi6Y8=
X-Received: by 2002:a17:90a:aa95:: with SMTP id
 l21mr3149898pjq.4.1586490999508; 
 Thu, 09 Apr 2020 20:56:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
In-Reply-To: <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
From: Javier Romero <xavinux@gmail.com>
Date: Fri, 10 Apr 2020 00:56:28 -0300
Message-ID: <CAEX+82LXHgxm5dfj11couvG=SsTAb4dgYCirtyqZozJbD6dj9w@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4121390091194531756=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4121390091194531756==
Content-Type: multipart/alternative; boundary="00000000000077113005a2e7b869"

--00000000000077113005a2e7b869
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

--00000000000077113005a2e7b869
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div dir=3D"auto" style=3D""><div dir=3D"auto" style=3D""=
><font face=3D"sans-serif"><span style=3D"font-size:12.8px">Hi Like Xu,</sp=
an></font></div><div dir=3D"auto" style=3D""><font face=3D"sans-serif"><spa=
n style=3D"font-size:12.8px"><br></span></font></div><div dir=3D"auto" styl=
e=3D""><font face=3D"sans-serif"><span style=3D"font-size:12.8px">Thank you=
 for your time to answer.=C2=A0</span></font></div><div dir=3D"auto" style=
=3D""><font face=3D"sans-serif"><span style=3D"font-size:12.8px"><br></span=
></font></div><div dir=3D"auto" style=3D""><font face=3D"sans-serif"><span =
style=3D"font-size:12.8px">Yes, I can also test KVM in an Intel platform, h=
ave a Pixelbook with a Core i7 processor and 16 GB of RAM at disposal to st=
art working.</span></font></div><div dir=3D"auto" style=3D""><font face=3D"=
sans-serif"><span style=3D"font-size:12.8px"><br></span></font></div><div d=
ir=3D"auto" style=3D""><font face=3D"sans-serif"><span style=3D"font-size:1=
2.8px">Thanks for your attention.</span></font></div><div dir=3D"auto" styl=
e=3D""><font face=3D"sans-serif"><span style=3D"font-size:12.8px"><br></spa=
n></font></div><div dir=3D"auto" style=3D""><font face=3D"sans-serif"><span=
 style=3D"font-size:12.8px">Regards,</span></font></div></div></div><br><di=
v class=3D"gmail_quote"><div dir=3D"ltr">El vie., 10 abr. 2020 00:34, Xu, L=
ike &lt;<a href=3D"mailto:like.xu@intel.com">like.xu@intel.com</a>&gt; escr=
ibi=C3=B3:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">On 2020/4/10 5:29, Javie=
r Romero wrote:<br>
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

--00000000000077113005a2e7b869--

--===============4121390091194531756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4121390091194531756==--
