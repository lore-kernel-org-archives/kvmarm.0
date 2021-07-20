Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,SUBJ_ALL_CAPS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A776FC07E9B
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 17:00:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD76C610A7
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 17:00:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD76C610A7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=imperas.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D81E4B0DE;
	Tue, 20 Jul 2021 13:00:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1bw6oFH3PARy; Tue, 20 Jul 2021 13:00:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AE784B0BA;
	Tue, 20 Jul 2021 13:00:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E65224B0AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 13:00:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lhzr5V8aviDO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 13:00:33 -0400 (EDT)
Received: from mail.ovpworld.org (mail.ovpworld.org [217.147.89.4])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A409D4A534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 13:00:33 -0400 (EDT)
Received: from mail-lj1-f178.google.com ([209.85.208.178]:35455)
 by server.imperas.com with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <straus@imperas.com>) id 1m5t6d-0006uK-GM
 for kvmarm@lists.cs.columbia.edu; Tue, 20 Jul 2021 18:00:31 +0100
Received: by mail-lj1-f178.google.com with SMTP id t20so16171739ljd.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 10:00:32 -0700 (PDT)
X-Gm-Message-State: AOAM530L8QxKzf1F4U3+q21X4UnuqEUE7m8q86y1Zob9eIl2/+Z73t67
 9Q/D95cIkTieexbnEazUWIKy1OjQBr5T3MNsDUk=
X-Google-Smtp-Source: ABdhPJzW/5OKsWkXGKPxQ7n13q+22iC665gxuAdXF202FHEBVip4vP5/7OHZ9kKdfPH5GN5QYo1SLNkMUXl/hgZC/VA=
X-Received: by 2002:a2e:3506:: with SMTP id z6mr28447791ljz.238.1626800432229; 
 Tue, 20 Jul 2021 10:00:32 -0700 (PDT)
MIME-Version: 1.0
From: Jim Straus <straus@imperas.com>
Date: Tue, 20 Jul 2021 09:59:56 -0700
X-Gmail-Original-Message-ID: <CAC196M4x7Yzi7Z3w1DZUazuvC5u-bTxEjCznd8_dt0Zb8+3H2Q@mail.gmail.com>
Message-ID: <CAC196M4x7Yzi7Z3w1DZUazuvC5u-bTxEjCznd8_dt0Zb8+3H2Q@mail.gmail.com>
Subject: ***SPAM*** UNSUBSCRIBE
To: kvmarm@lists.cs.columbia.edu
X-AntiAbuse: This header was added to track abuse,
 please include it with any abuse report
X-AntiAbuse: Primary Hostname - server.imperas.com
X-AntiAbuse: Original Domain - lists.cs.columbia.edu
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - imperas.com
X-Get-Message-Sender-Via: server.imperas.com: authenticated_id:
 imperas@imperas.com
X-Authenticated-Sender: server.imperas.com: imperas@imperas.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
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
Content-Type: multipart/mixed; boundary="===============8043047568643546531=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8043047568643546531==
Content-Type: multipart/alternative; boundary="000000000000e231b905c790fd93"

--000000000000e231b905c790fd93
Content-Type: text/plain; charset="UTF-8"

Please unsubscribe straus@imperas.com from the kvmarm email list

-- 

=======================================================================
The information contained in this electronic mail message and any
attachments hereto is privileged
and confidential information intended only for the use of the individual or
entity named above or their
designee.  If the reader of this message is not the intended recipient, you
are hereby notified that
any dissemination, distribution or copying of this communication is
strictly prohibited.  If you have
received this communication in error please immediately notify us by
return  message or by
telephone and delete the original message from your mail system.  Thank you.
=======================================================================

--000000000000e231b905c790fd93
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Please unsubscribe <a href=3D"mailto:straus@imperas.com">s=
traus@imperas.com</a> from the kvmarm email list<br clear=3D"all"><div><br>=
</div>-- <br><div dir=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"g=
mail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><p>=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
The information contained in this electronic mail message and any attachmen=
ts hereto is privileged<br>
and confidential information intended only for the use of the individual or=
 entity named above or their<br>
designee.=C2=A0 If the reader of this message is not the intended recipient=
, you are hereby notified that<br>
any dissemination, distribution or copying of this communication is strictl=
y prohibited.=C2=A0 If you have<br>
received this communication in error please immediately notify us by return=
=C2=A0 message or by<br>
telephone and delete the original message from your mail system.=C2=A0 Than=
k you.<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</p></div></=
div></div></div></div>

--000000000000e231b905c790fd93--

--===============8043047568643546531==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8043047568643546531==--
