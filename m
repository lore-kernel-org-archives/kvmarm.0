Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1AAC4167B
	for <kvmarm@archiver.kernel.org>; Mon, 26 Dec 2022 18:20:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 871464B76C;
	Mon, 26 Dec 2022 13:20:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X8mTiZ28uwYT; Mon, 26 Dec 2022 13:20:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF1A4BAC0;
	Mon, 26 Dec 2022 13:20:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3947B4BA9D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2022 13:20:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EvGInTkyJhSE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Dec 2022 13:20:38 -0500 (EST)
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com
 [209.85.160.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 096D14B76C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2022 13:20:37 -0500 (EST)
Received: by mail-oa1-f47.google.com with SMTP id
 586e51a60fabf-14ffd3c5b15so1721154fac.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2022 10:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=Z1BsEJ/8xOdqvzjqLWzBUnzQFlYNHqshZ1UyGS6N/rk=;
 b=cBVyWGE0jSkTkwsPWZNtuME6AOw7+8IKqOvxtPhD8AA58t/FYcLiKe9mkaxcO/rP4Z
 EpXmLN4YxKP1x2wLe7zpkCjLZZitPegtjDJNG6M5sSFH/cFIMP49FBMk9Q3BRJvAvTgK
 tTwoXGuy2R7fxaXKm8bg/1Qa6S+8Pt/Md+byLaSKYLMPGWtjThEKOCCktowsWPRYj+sX
 T14c3+0RPma926TfOnoS0NgBSU0mCVKeyvfiS7zoS1pR0aPRAXaZuCbqAMdxNjiC/xiZ
 3ZYrGSpff6whYAH4/5C1mcu+lkNhtpyc4Xvw1pnZWVQkCN2wJrT/UX468ouJjPxcvqMp
 d0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Z1BsEJ/8xOdqvzjqLWzBUnzQFlYNHqshZ1UyGS6N/rk=;
 b=fc6CLuJwQ0aZdCUQ2i7FYzjeSkfc1grytFlmx8oZvefeWDPvCAXtdzPgGOCN3oGtYm
 Lq5mJWUbJ3jVIJVa86smJoq2e0fcmpgVzPmKxaWpNsqSfR8IwabKFv3P7BULIGvju5yp
 wDHSFMUsM7AIrp5IOQIW5pormI4OZK4bOLUsYSSy+ekkRr7q0Z+1ujyr3a7yFvkYHhts
 VfPtHDII61U0WRQrm34hGs7hNPGpRJ10nJ6DuJv05jayp8/rlNpszFfi/UPM9UdDqlj6
 me13/IlF7f1QFDWt9pV1ANNcPcB947pmPxr+2Eq5sYZY84KYgoujfWygLrq0aNafPyl1
 55JA==
X-Gm-Message-State: AFqh2krpLq6GlU6srlJTpTRpI0Pva0yLiu2Rx/K9gmcjbyjfJhcy+4S0
 dhbP3KHBrRo5wOxnjrMeaCiJmEFq8huWp2DFmD4=
X-Google-Smtp-Source: AMrXdXu8Ir8nWZGvs+oX2m+6Hg9QrVYZoDvE4oRIt0417L1Arigu0arRdxEd7VQb7OWzT8dDPO/uKcm32FnUy1iHmAg=
X-Received: by 2002:a05:6870:494c:b0:14c:96f6:c16e with SMTP id
 fl12-20020a056870494c00b0014c96f6c16emr832045oab.111.1672078837314; Mon, 26
 Dec 2022 10:20:37 -0800 (PST)
MIME-Version: 1.0
References: <CAAywg7srFJg6-J0B-ny0xyx8itpbb_MoLC+07Fo56RsyyxdsAQ@mail.gmail.com>
 <873592fo38.wl-maz@kernel.org>
In-Reply-To: <873592fo38.wl-maz@kernel.org>
From: Sandeep Gupta <gupta.sandeep@gmail.com>
Date: Mon, 26 Dec 2022 23:50:26 +0530
Message-ID: <CAAywg7tZnj+CL7whMTA+HEVLJmUUVTW-R-C+t07pzC=kot=R-Q@mail.gmail.com>
Subject: Re: running openbsd on KVM running on fedora over raspberry pi 4
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============3706393750337967682=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============3706393750337967682==
Content-Type: multipart/alternative; boundary="0000000000002278b005f0bf31ce"

--0000000000002278b005f0bf31ce
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

 Thank you for taking a look. I was able to finally
run openbsd by converting the install72.img to
a qcow2 image using qemu-convert tool. After that,
install and run openbsd was standard procedure.


On Mon, Dec 26, 2022 at 4:08 PM Marc Zyngier <maz@kernel.org> wrote:

> On Fri, 23 Dec 2022 11:33:35 +0000,
> Sandeep Gupta <gupta.sandeep@gmail.com> wrote:
> >
> > I am trying to run openbsd as guest OS.
> > I am using this command to create the vm
> > ```
> >
> > virt-install --name openbsd1 --ram 2048 --vcpus 2 --disk
> >
> path=/var/lib/libvirt/images/openbsd1.qcow2,format=qcow2,bus=virtio,size=20
> >  --disk path=/tmp/install72.img --import --os-variant openbsd7.0
> > --network=default --noautoconsole
> >
> > ```
> > But, on boot the server is not picking up the openbsd boot sequence.
>
> I don't think this is directly related to KVM. I've been pretty
> successful in running OpenBSD 7.0 on a variety of hosts. Not using
> libvirt though, but directly using QEMU.
>
> One thing you may want to do is to disable ACPI by pasing -no-acpi to
> QEMU.
>
> But overall, this is a question better asked on some libvirt forum.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>

--0000000000002278b005f0bf31ce
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Marc,</div><div>=C2=A0</div><div>=C2=A0Thank you f=
or taking a look. I was able to finally <br></div><div>run openbsd by conve=
rting the install72.img to</div><div>a qcow2 image using qemu-convert tool.=
 After that,</div><div>install and run openbsd was standard procedure. <br>=
</div><div><br></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" =
class=3D"gmail_attr">On Mon, Dec 26, 2022 at 4:08 PM Marc Zyngier &lt;<a hr=
ef=3D"mailto:maz@kernel.org">maz@kernel.org</a>&gt; wrote:<br></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1p=
x solid rgb(204,204,204);padding-left:1ex">On Fri, 23 Dec 2022 11:33:35 +00=
00,<br>
Sandeep Gupta &lt;<a href=3D"mailto:gupta.sandeep@gmail.com" target=3D"_bla=
nk">gupta.sandeep@gmail.com</a>&gt; wrote:<br>
&gt; <br>
&gt; I am trying to run openbsd as guest OS.<br>
&gt; I am using this command to create the vm<br>
&gt; ```<br>
&gt; <br>
&gt; virt-install --name openbsd1 --ram 2048 --vcpus 2 --disk<br>
&gt; path=3D/var/lib/libvirt/images/openbsd1.qcow2,format=3Dqcow2,bus=3Dvir=
tio,size=3D20<br>
&gt;=C2=A0 --disk path=3D/tmp/install72.img --import --os-variant openbsd7.=
0<br>
&gt; --network=3Ddefault --noautoconsole<br>
&gt; <br>
&gt; ```<br>
&gt; But, on boot the server is not picking up the openbsd boot sequence.<b=
r>
<br>
I don&#39;t think this is directly related to KVM. I&#39;ve been pretty<br>
successful in running OpenBSD 7.0 on a variety of hosts. Not using<br>
libvirt though, but directly using QEMU.<br>
<br>
One thing you may want to do is to disable ACPI by pasing -no-acpi to<br>
QEMU.<br>
<br>
But overall, this is a question better asked on some libvirt forum.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 M.<br>
<br>
-- <br>
Without deviation from the norm, progress is not possible.<br>
</blockquote></div>

--0000000000002278b005f0bf31ce--

--===============3706393750337967682==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3706393750337967682==--
