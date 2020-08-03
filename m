Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA0FC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 08:42:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B75F2076C
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 08:42:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=binghamton.edu header.i=@binghamton.edu header.b="WYQqwNKJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B75F2076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=binghamton.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 860844B729;
	Tue,  4 Aug 2020 04:42:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@binghamton.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P4Ky5xo3FBLX; Tue,  4 Aug 2020 04:42:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3A84B727;
	Tue,  4 Aug 2020 04:42:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F7824B637
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 14:09:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SE+NmkJi6Atv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2020 14:09:22 -0400 (EDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41DE14B62E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 14:09:22 -0400 (EDT)
Received: by mail-wr1-f51.google.com with SMTP id r2so29986389wrs.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Aug 2020 11:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=binghamton.edu; s=google;
 h=mime-version:from:date:message-id:subject:to;
 bh=5qNRNnht0RnjsmSAL/nWkG+KZRTY7+u8KVOUczeAlTc=;
 b=WYQqwNKJmIe5NIHEnqJHcknihRqibsTajnWy53NTgZMBVI2VEN8G94OR9deOanAAgE
 /IF9wVDl+F27ZadxE5ZnkdAoe6MtD5kEfyb5kLNALcXvaA8j7m3VeNnXN8fg8L9sW+eb
 TltImBukqjlqUQN+I13iiarD0Dce+WPaESG2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=5qNRNnht0RnjsmSAL/nWkG+KZRTY7+u8KVOUczeAlTc=;
 b=YACM2wmG4xNepp9rh8n8haXyce1KJWNK09kHX0b2Y4CB2CSQN7PFS5bCicBqWKejtN
 y9sO6FYJ7+OXGdgTMfiJH3ExNBAqTW+ILpuuxL4mhExjT0r+cvA/2RevQQQ26x2vFWNM
 YLzLvItKXNv811dSsWNSRQAQ+gO0PvZqNmSiYBUhYoeOJgB8tFZFW9JygFK2JAyJHCej
 JVGIOqUn//DE94Y199299mDAfXaUBfS+yx8nLHRBZjw7zVI4EsCA9E8Gwx499Bf+DXC6
 QBHjtPp0WX7bfjW9u3Q5gUkFL74r9vLfDL9o51u3/YxfKhGfe3EDSR/d/hVMng4llmeD
 fHIA==
X-Gm-Message-State: AOAM532XYucgFqeiacH6gNSkGy6sti9MQfzmRa7E270yab1AJFiEoUOL
 M92erREqtaYHHsfjpy34zhltSbhdgQcfzinQOKPMwfEY
X-Google-Smtp-Source: ABdhPJy+c2K6ym/fkaqGViELq+IMfBG8MjtNuTneGOh4g3o3iVbLIyX4Kz38Uft0W6KO/1N3NnXYMhRLGCwQ8PP0RdA=
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr15758577wrw.70.1596478161080; 
 Mon, 03 Aug 2020 11:09:21 -0700 (PDT)
MIME-Version: 1.0
From: Roja Eswaran <reswara1@binghamton.edu>
Date: Mon, 3 Aug 2020 14:09:10 -0400
Message-ID: <CAGTfD8bTpj914KrqY4RzCXQYqxTfGjVApyZRDAV9PrRBAx6+kA@mail.gmail.com>
Subject: Regarding Direct Injection of Virtual LPI in ARMv8 GICv4
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Tue, 04 Aug 2020 04:42:06 -0400
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
Content-Type: multipart/mixed; boundary="===============0439429895901856737=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============0439429895901856737==
Content-Type: multipart/alternative; boundary="000000000000aeef3605abfd0926"

--000000000000aeef3605abfd0926
Content-Type: text/plain; charset="UTF-8"

Can we modify timer interrupts or IPI into Virtual LPI and directly inject
them in VM?

*Roja Eswaran*

*PhD Student, Operating Systems and Networks Laboratory *
*State University of New York, Binghamton *

--000000000000aeef3605abfd0926
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div dir=3D"ltr" class=3D"gmail_signature" data-smart=
mail=3D"gmail_signature"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"=
><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><h1 st=
yle=3D"margin:0px 0px 15px;color:rgb(24,24,24);padding:0px;font-size:14px;l=
ine-height:21px"><span style=3D"font-weight:normal">Can we=C2=A0modify time=
r interrupts or IPI into Virtual LPI and directly inject them in VM?</span>=
</h1></div><div dir=3D"ltr"><b><font face=3D"comic sans ms, sans-serif" col=
or=3D"#000000">Roja Eswaran</font><br></b></div><div dir=3D"ltr"><div><b><s=
pan style=3D"color:rgb(0,0,0);font-family:&quot;comic sans ms&quot;,sans-se=
rif">PhD Student, Operating Systems and Networks Laboratory=C2=A0</span><br=
></b></div><div><font face=3D"comic sans ms, sans-serif" color=3D"#000000" =
style=3D""><b>State University of New York, Binghamton=C2=A0</b><br></font>=
</div></div></div></div></div></div></div></div></div></div></div>

--000000000000aeef3605abfd0926--

--===============0439429895901856737==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0439429895901856737==--
