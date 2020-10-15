Return-Path: <SRS0=68gc=DW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60D8C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 10:11:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 069EF22249
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 10:11:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=binghamton.edu header.i=@binghamton.edu header.b="aalWjCDy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 069EF22249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=binghamton.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E5224B612;
	Thu, 15 Oct 2020 06:11:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@binghamton.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ty8omKPGbfI6; Thu, 15 Oct 2020 06:11:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27DD44B58C;
	Thu, 15 Oct 2020 06:11:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B38E84B2CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Oct 2020 23:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kKgMH73jYL5i for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Oct 2020 23:26:36 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 893A04B279
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Oct 2020 23:26:36 -0400 (EDT)
Received: by mail-io1-f48.google.com with SMTP id g7so2482533iov.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Oct 2020 20:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=binghamton.edu; s=google;
 h=mime-version:date:from:subject:thread-topic:message-id:to
 :content-transfer-encoding;
 bh=G3wXUBf1mn4EDTRaB2dGKXqiwyDZPgqOiyzcHY8IPjQ=;
 b=aalWjCDy5FEFuPWYSYFTh20hr2vxjjRUXjdecGjvM8VpQRLupmkctOjoWCLJRz0eRt
 t9a63myiFq1BguMj+9yCVqIYBE15Klws637h6cH//1FxmQHDkk5GMjKimWhL69kxfaGz
 7URylsqBWDOm1NuuUyQwi6nLLUoIOcJfdR4oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:date:from:subject:thread-topic
 :message-id:to:content-transfer-encoding;
 bh=G3wXUBf1mn4EDTRaB2dGKXqiwyDZPgqOiyzcHY8IPjQ=;
 b=YbF5rjgj6U48jCE2lA24wnrlz2Ihe/5kqIIw/ln2dlX4e7jUSvYdBHvZoPoniSh9qM
 HnUTDJzBQ+CF7K9Df6rgvN+dL7CZEAJiRHY8X8naJMSdlDDbchYmNOKNswP2ePrwNEXk
 R8/dU6MtI+f1EhFADInuUt/wR8lhnL3l9BaLh/FTVnkwOiiicyTmS//eEVD+Q+ew4DmX
 GSK38NPiGzEiZ6iqK0fie9V95cyIXvzYHMsyGpLSTapUqhk9pCDv87oOiv+cn+As7NDN
 i6sb5ByfZG40QACtLTD92pXtx8LQhJSV/iL+UYcevvqRR3U2Bq6EzcQCp9To6dtrnrSS
 YBsQ==
X-Gm-Message-State: AOAM532Q9aZP3wnvT1cDs5GtSMSDm4+hLvhBIAP9gkoeR5JBn6b5Z9tC
 jxmE6K+S8pzFGSjBdyWV69flE1jVxoEo7BA96G666vvTWiBeoIcXWKKySACXFAuzUb1VfAfO1hr
 aXBLyczPVfwWtQeI0WcVPWwoREOQ9ZIpohqhB+dHfuZ1CZSwOqJE3op9gy6FeSGw64+brtcCbIU
 uC/137Jf8=
X-Google-Smtp-Source: ABdhPJzubl4skqHI0j0IuNmJR7sQhhpCsXr/3GI3U5Fxmg4BYN3c06qwYq78BrhJb2LYUfWoBO81xA==
X-Received: by 2002:a02:c785:: with SMTP id n5mr2023289jao.128.1602732395639; 
 Wed, 14 Oct 2020 20:26:35 -0700 (PDT)
Received: from smtp.gmail.com ([2604:6000:dc08:8400:31c3:6277:b73b:9060])
 by smtp.gmail.com with ESMTPSA id y75sm1581358iof.36.2020.10.14.20.26.34
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 14 Oct 2020 20:26:35 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Oct 2020 23:26:34 -0400
From: Roja malarvathi <reswara1@binghamton.edu>
Subject: Regarding Timer Interrupt Latency - ARM64 Guest
Thread-Topic: Regarding Timer Interrupt Latency - ARM64 Guest
Message-ID: <56798E8F-A2D0-45CE-ABEF-6EF716103B15@hxcore.ol>
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
X-Mailman-Approved-At: Thu, 15 Oct 2020 06:11:17 -0400
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
Content-Type: multipart/mixed; boundary="===============8632712450601872449=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8632712450601872449==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns:m=3D"http://schemas.microsoft.com/of=
fice/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta ht=
tp-equiv=3DContent-Type content=3D"text/html; charset=3Dutf-8"><meta name=
=3DGenerator content=3D"Microsoft Word 15 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style></head><body lang=3DEN-US link=3Dblue vlink=3D"#954F72"><div cla=
ss=3DWordSection1><div><p class=3DMsoNormal>Hello,</p><p class=3DMsoNormal>=
First of all, Thank you so much for the help in advance. </p><p class=3DMso=
Normal>We wrote our own Kernel Level Timer Interrupt Latency test and ran o=
n ARM8.2. The Median latency value, when ran on guests is around 30 =E2=80=
=93 35 us. </p><p class=3DMsoNormal>Guest Kernel-Version: 5.9 with VHE enab=
led on Host.</p><p class=3DMsoNormal>Can anyone let me know what should be =
an expected timer interrupt latency range for Guest? </p><p class=3DMsoNorm=
al>Thanks so much again!</p></div></div></body></html>=


--===============8632712450601872449==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8632712450601872449==--
