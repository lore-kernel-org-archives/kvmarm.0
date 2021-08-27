Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145A0C4320A
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B020260FD9
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B020260FD9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6298B4B110;
	Fri, 27 Aug 2021 03:50:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wh71aFoEFxdt; Fri, 27 Aug 2021 03:50:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2164B1B1;
	Fri, 27 Aug 2021 03:49:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F0F4B0BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 22:25:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wKNzufgmsdgA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 22:25:11 -0400 (EDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
 [209.85.219.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7BF44B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 22:25:11 -0400 (EDT)
Received: by mail-yb1-f176.google.com with SMTP id f15so9750949ybg.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 19:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:from:date:message-id:subject:to;
 bh=Ez0QuZfqPi364ZTnSyPQwxGiZzk3IGyz0UYBuahrwHs=;
 b=YIrGGdlNA/kTisnkjKUvYTX9hsFhzJH3UhTjNrctrlxjTFODwUPbwQvq4kY70LS8BW
 oLs0DOrgQYMWipNIVSfJQRKKWAAVRQj2H4RzxC+PCSi2QF74RJoBFD5RLJTZ8xIPb4ce
 RMWSNN/+T06LPJKdjB2RHx1sPYLnerMkUXqgEaKAbxVbXUH/wFT13rAigmvjyCXCYM5g
 oFLmJCmVN8GViegZ8KUcK/qhPnSe+NECDt3UhNtcLllO1Ql5BXj9IQZlllNO3xs33iY+
 Y6DWLeUb2lBWIKjj7tZlAMBxavIZ54TZNccHTT+92mLxm0rXbHU8je2j/2fDNy1kgHM2
 G1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=Ez0QuZfqPi364ZTnSyPQwxGiZzk3IGyz0UYBuahrwHs=;
 b=W/eK5csSDT7uvYBp3MMo3IPrPqAsGjeUOMbvoxN5Yu1F5iUhyCJHrPmqxl+MdIbUPK
 76tkTCU23PKf7KBBrlBxNTxDZeiWvQqpOfggUPrq/7SFCd6A19gzlam26iXdsow/iCpK
 wu2ft9zIqCRZXW9PdBaQR7678IbZVt0P2V8ah2mtDdmzzJIknjnxx+eRtEATEfZSJ+J8
 ObCfP+dUdFpCiJS3mnnFhy/f19lNYBDnyMCIR1GEAPZrMwQ0GA1AN4ifsQSwq1vB9ayw
 e+ESal0OQZO3lxoXrX3D22QZqI5rowbOmA/yv7rXsvM8UaOPxJ10YioUTQrUgjwL++wK
 QSvQ==
X-Gm-Message-State: AOAM530VUbJwcmiBZVyXxROeLm+otmrIXl9b/LUI3X6gKjM6gNj1TUKO
 lVbDTK2sRGg/wuKTUzU3fchnLNVGL+bFbp+lD1xR+gnBQ2k=
X-Google-Smtp-Source: ABdhPJwRx0dAQfDlrtKbq66YkaCqV7OKoHel+N6Jwr+hDe1m1Ozi5vspHCB+ErZ2+UFyx5sVnW7S+gHNAVVa2BndRf4=
X-Received: by 2002:a25:b948:: with SMTP id s8mr2244214ybm.281.1630031110915; 
 Thu, 26 Aug 2021 19:25:10 -0700 (PDT)
MIME-Version: 1.0
From: aaditya singh <aaditya99983@gmail.com>
Date: Fri, 27 Aug 2021 07:55:00 +0530
Message-ID: <CAKy_CfD3gYk4ErTP=PaGScj06onymhQ8mosQY1=NDARC+HOpbQ@mail.gmail.com>
Subject: Is there any KVM-enabled kernel for android i can find ?
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Fri, 27 Aug 2021 03:49:31 -0400
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
Content-Type: multipart/mixed; boundary="===============0305366621873074136=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============0305366621873074136==
Content-Type: multipart/alternative; boundary="00000000000056cb7605ca8131c7"

--00000000000056cb7605ca8131c7
Content-Type: text/plain; charset="UTF-8"

Hi,
I'm Aaditya, a student at NYU, currently i was working on putting
kvm-enabled android kernel for our project and was wondering if you guys
can help with, would be grateful if you can share the instructions on how
to install kvm-enabled kernels ?
Thanking you
Aaditya

-- 

Warm Regards,
Aaditya Kumar Singh

*IIT Kharagpur | Adobe Inc*+91 7478076555 | *aaditya99983@gmail.com
<aaditya99983@gmail.com> *| *LinkedIn*
<https://www.linkedin.com/in/aaditya99/>

--00000000000056cb7605ca8131c7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,=C2=A0<div>I&#39;m Aaditya, a student at NYU, currently=
 i was working on putting kvm-enabled android kernel for our project and wa=
s wondering if you guys can help with, would be grateful if you can share t=
he instructions on how to install kvm-enabled kernels ?</div><div>Thanking =
you</div><div>Aaditya=C2=A0</div><div><div><div><br></div>-- <br><div dir=
=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div =
dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"lt=
r"><div><div dir=3D"ltr"><div dir=3D"ltr"><br></div><div dir=3D"ltr"><font =
color=3D"#000000"><span style=3D"font-family:arial,helvetica,sans-serif;fon=
t-size:small">Warm Regards,<br></span><span style=3D"font-family:arial,helv=
etica,sans-serif;font-size:small">Aaditya Kumar Singh</span><font style=3D"=
font-family:arial,helvetica,sans-serif;font-size:small">=C2=A0<br></font><b=
 style=3D"font-family:arial,helvetica,sans-serif;font-size:small">IIT Khara=
gpur | Adobe Inc<br></b><span style=3D"font-family:arial,helvetica,sans-ser=
if;font-size:small;background-position:initial initial;background-repeat:in=
itial initial">+91 7478076555 |=C2=A0</span><span style=3D"font-family:aria=
l,helvetica,sans-serif;font-size:small"><b><a href=3D"mailto:aaditya99983@g=
mail.com" target=3D"_blank">aaditya99983@gmail.com</a>=C2=A0</b><span style=
=3D"background-image:initial;background-position:initial;background-repeat:=
initial">|=C2=A0</span><a href=3D"https://www.linkedin.com/in/aaditya99/" t=
arget=3D"_blank"><b>LinkedIn</b></a></span><br></font><div><br></div></div>=
</div></div></div></div></div></div></div></div></div></div></div></div></d=
iv>

--00000000000056cb7605ca8131c7--

--===============0305366621873074136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0305366621873074136==--
