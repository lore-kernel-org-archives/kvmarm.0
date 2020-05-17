Return-Path: <SRS0=26+9=67=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.4 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD1AC433DF
	for <kvmarm@archiver.kernel.org>; Sun, 17 May 2020 09:11:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 890C920735
	for <kvmarm@archiver.kernel.org>; Sun, 17 May 2020 09:11:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=binghamton.edu header.i=@binghamton.edu header.b="eWcDCim8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 890C920735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=binghamton.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9FB4B0F8;
	Sun, 17 May 2020 05:11:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@binghamton.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V8OpyVbFwJ-M; Sun, 17 May 2020 05:11:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB6244B0D1;
	Sun, 17 May 2020 05:11:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B76624B0D2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 May 2020 22:29:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cI+CFWmC7mDb for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 May 2020 22:29:21 -0400 (EDT)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A360F4B0C6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 May 2020 22:29:21 -0400 (EDT)
Received: by mail-qv1-f50.google.com with SMTP id x13so3116991qvr.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 May 2020 19:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=binghamton.edu; s=google;
 h=mime-version:from:date:message-id:subject:to;
 bh=t8+bVCK/80nJOcW1T5M5NNa1gQkv33PROUQcHNxSetM=;
 b=eWcDCim8bAUCL6Hdl4AGt1fBPwvnSiPKOrvHTQAH+vTgKp9Slis8mq5pfurzV2CflS
 yGmeUwL+xWpvK3356baoUmG2C+ZtGWur0/7yWSOeBxggHrcpQmPiUa0YXjs7ZOSgt4rG
 1QQGVgtbpXeujfZzZIielR4wnO73LdSfS//6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=t8+bVCK/80nJOcW1T5M5NNa1gQkv33PROUQcHNxSetM=;
 b=Ul3G/Ki1HcZaGD+xm8Jgelfoxdg1ZCQsos/Qg207NWsCV+u3rLgbl8cAMi0jc/HVIK
 LQ0N/i1YUmgAS0ksV9UxscaPwqTZLsw2f90GxVeWRoOr85n0vhznCD1wxL6nQes0txlC
 JmgT9RbwhHPl9Y4dw6xfDc9rkZhZAY8OxKs/2k+Kw7d8kRSHkXEybTnUSoJtgtQ009bf
 2ND0IIsqGfDhQpnPwcz88Sbre3jUCtqYueCLy136WRXMHoimR8qU3PipdKHpRoPaOXfj
 QGX3bx+Aiu49BVwh0tf6Yk+WcDy42e1BYfbyWdxX9IYa+DYvQM30m/Ypo+RRXOXzaDfn
 2ovw==
X-Gm-Message-State: AOAM531dxBnU0AQoNQ0N/ykXLdE6oosUfuOaAL7GtYkw33lTir2sJ+pJ
 9c7EtvI1fRV+w7ZKUdcZLnX9q+h4x0hlXOGK7843ltot
X-Google-Smtp-Source: ABdhPJzMe64IhtwB+pQMF9hwrI7aQY0dBva7IIsHVaQROoByiIBor7Kx8QcCsQcP6+nLUJ0yko+08wjECj4Cppuz10s=
X-Received: by 2002:a0c:f1cb:: with SMTP id u11mr10201465qvl.10.1589682560922; 
 Sat, 16 May 2020 19:29:20 -0700 (PDT)
MIME-Version: 1.0
From: Roja Eswaran <reswara1@binghamton.edu>
Date: Sat, 16 May 2020 22:29:11 -0400
Message-ID: <CAGTfD8aY-oJ2J8+EYziHt1Ugy84kK8CU_mwfc0QYkVCMjnjgtw@mail.gmail.com>
Subject: Performance of VM is better than Host
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Sun, 17 May 2020 05:11:14 -0400
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
Content-Type: multipart/mixed; boundary="===============6647010521056207745=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============6647010521056207745==
Content-Type: multipart/alternative; boundary="00000000000059940205a5ced0f3"

--00000000000059940205a5ced0f3
Content-Type: text/plain; charset="UTF-8"

Hello,

I virtualized Raspi-4 and ran *sysbench  - Memory* on bare metal and the VM.
The performance of VM is better than Host (Increase by 11%)
-> Both host and VM has the same OS
-> No Background Processes are running when sysbench is executed
-> Turned off Transparent huge pages in VM before booting
Yet getting the same performance difference.
Please let me know, What I am missing here

Thank you so much for your valuable time.





*Roja Eswaran*
*Master's in Computer Science*
*Research Assistant - OSNET*

--00000000000059940205a5ced0f3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>I virtualized Raspi-4 and ran <b=
><i>sysbench=C2=A0 - Memory</i></b> on bare metal and the VM.</div><div>The=
 performance of VM is better than Host (Increase by 11%)</div><div>-&gt; Bo=
th host and VM has the same OS</div><div>-&gt; No Background Processes=C2=
=A0are running when sysbench is executed</div><div>-&gt; Turned off Transpa=
rent huge pages in VM before booting</div><div>Yet getting the same perform=
ance=C2=A0difference.</div><div>Please let me know, What I am missing here<=
/div><div><br></div><div>Thank you so much for your valuable time.</div><di=
v><br></div><div><br></div><div><br></div><div><br clear=3D"all"><div><div =
dir=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><d=
iv dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr"><div dir=3D"ltr"=
><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><h1 style=3D"margin:0px=
 0px 15px;color:rgb(24,24,24);padding:0px;font-size:14px;line-height:21px">=
<br></h1></div><div dir=3D"ltr"><b><font face=3D"comic sans ms, sans-serif"=
 color=3D"#000000">Roja Eswaran</font></b><br></div><div dir=3D"ltr"><div><=
b><font face=3D"comic sans ms, sans-serif" color=3D"#000000">Master&#39;s i=
n Computer Science</font></b></div><div><b><font face=3D"comic sans ms, san=
s-serif" color=3D"#000000">Research Assistant - OSNET</font></b></div><div>=
<b><font face=3D"comic sans ms, sans-serif" color=3D"#000000"><br></font></=
b></div></div></div></div></div></div></div></div></div></div></div></div><=
/div></div>

--00000000000059940205a5ced0f3--

--===============6647010521056207745==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6647010521056207745==--
