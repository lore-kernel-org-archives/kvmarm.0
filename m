Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410C5C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 08:36:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFE626128B
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 08:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AFE626128B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1517C4B261;
	Mon, 18 Oct 2021 04:36:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d941zS4E+ETB; Mon, 18 Oct 2021 04:36:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF7914B232;
	Mon, 18 Oct 2021 04:36:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81DD44B203
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 04:36:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mr422JE5vppM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 04:36:18 -0400 (EDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com
 [209.85.208.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDB864B1DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 04:36:17 -0400 (EDT)
Received: by mail-lj1-f182.google.com with SMTP id n7so7562730ljp.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 01:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=EoXdSFZ2pWjyOqFZVZiXZp4IU9fivGu/Ii9IWHEyAYw=;
 b=f90owP7m1umx8Q3hYaIYOjEIkEa7sJDtcj0+OvBzzbeLGVchsCMrRljX0qyF3eVUki
 ayYfeYfVl9vnzVV7p6/txZQLmuTpoPo8Klqu1O2lfSo1rkvPo/35Ch8XqUkh+WZ72P3/
 tulDzYpbtHFKcpu3oqrVGCnv8xpBcu1ZLiYKSd4vHED9+e4AlvJVe2VkfofFwa3khrR8
 /ypHxsvsr7RQ96epD8fE0loF2GKBHI+Z5TIhZqqroYkDaz0l6QjElhjaJRLHO/YohWTx
 4cbuJA2M0tSPf2/dlEee4a5uAOPiqNAs8/0PBMnO2x1GF7pBte/aCUE22/wY6NZa4Gqg
 ch0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=EoXdSFZ2pWjyOqFZVZiXZp4IU9fivGu/Ii9IWHEyAYw=;
 b=A9kmFNsD4/uMrls+gIUCF6H3sf6ciRbqjBq7FwbAakFD6f/+kAwGj6ub9hAd8jw8T0
 QfeaL6g4Yp4qYOdwbP91Nl+nqAydugZcegWdZqW7I04UYSxAgfvcgqriqoCJcadmCJgV
 79fi1CuTqdMe0/Rmda1EyakQx+0CoiuUCVmgVt4NiIe9pWhhG3jm1EntTkokMiOX7bee
 f/aFQcXZs33/nanXgf9cxlFDRr9yOSa1Rzet231UdrDeNuKtzcHQo4x1PNp3NSpeZdo4
 bqNlMjvuqLSHS/YjDFuNx5CJod3uo16s+QZV9uiROwKQCDjdch8V9bxNR2VWj6GNppNt
 FSAQ==
X-Gm-Message-State: AOAM5312Cd3qwl0Toj0gw6C9iR3r4mRM9iHfSS0uZd7Y0R7vl9WJgdAY
 SXh6CJ9YnKMHBVT+Akcp1Ri4IFxOoQEaJm8SxqYtyzDNivY=
X-Google-Smtp-Source: ABdhPJw15BVKZdZ9tCCbXF2Nbupg96jaCeFSlJsAD7ezXXa/rq6GHLuMPPIq8du0cQhqBhVXRYahQV1mw7K6qDtT6hk=
X-Received: by 2002:a05:651c:38c:: with SMTP id
 e12mr30498303ljp.292.1634546176573; 
 Mon, 18 Oct 2021 01:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAFLP=uDhb8Zq5pAnTbvXi_OU047Uw3WRkw2YJsYNEsCkdHzkJQ@mail.gmail.com>
 <877decvf9x.wl-maz@kernel.org>
In-Reply-To: <877decvf9x.wl-maz@kernel.org>
From: Chenxu Wang <irakatz51@gmail.com>
Date: Mon, 18 Oct 2021 16:36:05 +0800
Message-ID: <CAFLP=uDY-Eh6gvA2UvAtd=u1wa61tg9TAmdnqiJGZE+Yan8PpA@mail.gmail.com>
Subject: Re: Problems about Stage-2 translation
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
Content-Type: multipart/mixed; boundary="===============8592303103008781069=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8592303103008781069==
Content-Type: multipart/alternative; boundary="0000000000003945e005ce9c7064"

--0000000000003945e005ce9c7064
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

Thanks for your help. I studied the kvm_handle_guest_abort() handler, and
basically know the reason for "return 0".
But I still cannot solve the mapping problem.

I want to find a function or APIs, whose input parameters are (1) region
base IPA and size (2) mapped PA in Host (if IPA=3DPA, it could be better) (=
3)
R/W/X attributes.
Then, when I call the func(IPA start, IPA end, PA start, attr), I can get
the map.

Where should I follow? Should I follow the "translation fault path" again?
Or create the mapping function by myself?

Sincerely,
Wang

Marc Zyngier <maz@kernel.org> =E4=BA=8E2021=E5=B9=B410=E6=9C=8817=E6=97=A5=
=E5=91=A8=E6=97=A5 =E4=B8=8A=E5=8D=885:19=E5=86=99=E9=81=93=EF=BC=9A

> On Sat, 16 Oct 2021 13:21:01 +0100,
> Chenxu Wang <irakatz51@gmail.com> wrote:
> >
> > Hi all,
> >
> > I am facing two problems with the Stage-2 translation in KVM.
> >
> > (1)
> > I reserve a memory region (e.g., 0xa000_0000 ~ 0xa020_0000) from DRAM
> space
> > of HostOS, and fill it with some values. Then ask a GuestVM to access
> this
> > region.
> >
> > void __iomem *region=3Dioremap(0xa0000000, 0x1000);
> > uint32_t val=3Dioread32(region);
> >
> > But I get value 0, which is not the expected value.
>
> It is the expected behaviour.
>
> > I guess the reason is that the Stage-2 translation of the GuestVM does
> not
> > map the reserved region, but it should return a translation fault, rath=
er
> > than 0. So I feel confused, could you provide some helpful explanation?
>
> Why should the guest see a translation fault? After all, the whole
> point of KVM is to transparently handle the translation fault and map
> a page on demand.
>
> > (2)
> > I consider mapping a region with the Stage-2 translation. I find that K=
VM
> > create the stage-2 table with kvm_alloc_stage2_pgd(). But I could not
> find
> > a function that can "arbitrarily add a stage-2 mapping to the physical
> > address in HostOS" when the VM is activated.
> >
> > Could you provide such functions?
>
> Follow the translation fault path in KVM, and you will find what you
> are asking for.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>

--0000000000003945e005ce9c7064
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Marc,<div><br></div><div>Thanks for your help. I studie=
d the=C2=A0kvm_handle_guest_abort() handler, and basically know the reason =
for &quot;return 0&quot;.</div><div>But I still cannot solve the mapping pr=
oblem.=C2=A0<br></div><div><br></div><div>I want to find a function or APIs=
, whose input parameters are (1) region base IPA and size (2) mapped PA in =
Host (if IPA=3DPA, it could be better) (3) R/W/X attributes.</div><div>Then=
, when I call the func(IPA start, IPA end, PA start, attr), I can get the m=
ap.</div><div><br></div><div>Where should I follow? Should I follow the &qu=
ot;translation fault path&quot; again? Or create the mapping function by my=
self?</div><div><br></div><div>Sincerely,</div><div>Wang</div></div><br><di=
v class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">Marc Zyngier =
&lt;<a href=3D"mailto:maz@kernel.org">maz@kernel.org</a>&gt; =E4=BA=8E2021=
=E5=B9=B410=E6=9C=8817=E6=97=A5=E5=91=A8=E6=97=A5 =E4=B8=8A=E5=8D=885:19=E5=
=86=99=E9=81=93=EF=BC=9A<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">On Sat, 16 Oct 2021 13:21:01 +0100,<br>
Chenxu Wang &lt;<a href=3D"mailto:irakatz51@gmail.com" target=3D"_blank">ir=
akatz51@gmail.com</a>&gt; wrote:<br>
&gt; <br>
&gt; Hi all,<br>
&gt; <br>
&gt; I am facing two problems with the Stage-2 translation in KVM.<br>
&gt; <br>
&gt; (1)<br>
&gt; I reserve a memory region (e.g., 0xa000_0000 ~ 0xa020_0000) from DRAM =
space<br>
&gt; of HostOS, and fill it with some values. Then ask a GuestVM to access =
this<br>
&gt; region.<br>
&gt; <br>
&gt; void __iomem *region=3Dioremap(0xa0000000, 0x1000);<br>
&gt; uint32_t val=3Dioread32(region);<br>
&gt; <br>
&gt; But I get value 0, which is not the expected value.<br>
<br>
It is the expected behaviour.<br>
<br>
&gt; I guess the reason is that the Stage-2 translation of the GuestVM does=
 not<br>
&gt; map the reserved region, but it should return a translation fault, rat=
her<br>
&gt; than 0. So I feel confused, could you provide some helpful explanation=
?<br>
<br>
Why should the guest see a translation fault? After all, the whole<br>
point of KVM is to transparently handle the translation fault and map<br>
a page on demand.<br>
<br>
&gt; (2)<br>
&gt; I consider mapping a region with the Stage-2 translation. I find that =
KVM<br>
&gt; create the stage-2 table with kvm_alloc_stage2_pgd(). But I could not =
find<br>
&gt; a function that can &quot;arbitrarily add a stage-2 mapping to the phy=
sical<br>
&gt; address in HostOS&quot; when the VM is activated.<br>
&gt; <br>
&gt; Could you provide such functions?<br>
<br>
Follow the translation fault path in KVM, and you will find what you<br>
are asking for.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 M.<br>
<br>
-- <br>
Without deviation from the norm, progress is not possible.<br>
</blockquote></div>

--0000000000003945e005ce9c7064--

--===============8592303103008781069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8592303103008781069==--
