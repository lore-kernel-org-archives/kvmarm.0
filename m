Return-Path: <SRS0=kHGs=7P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,TVD_SPACE_RATIO,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D182C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jun 2020 07:53:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E1BF206A2
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jun 2020 07:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEMvocqB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E1BF206A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 535A44B1E2;
	Tue,  2 Jun 2020 03:53:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x++JMcODHIKL; Tue,  2 Jun 2020 03:53:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9CF4B1A5;
	Tue,  2 Jun 2020 03:53:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 636B84B18D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2020 02:19:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GLR2JIkZ0z96 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jun 2020 02:19:01 -0400 (EDT)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3416D4B08C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2020 02:19:01 -0400 (EDT)
Received: by mail-qt1-f174.google.com with SMTP id y1so9769967qtv.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Jun 2020 23:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:from:date:message-id:subject:to;
 bh=dBhWGBisxfa1raeM1guw9xlVWqydEL4cHPADAnOG63g=;
 b=TEMvocqBPGJ7LiT71ol0I4XMs7Daenb/RW4KmBHUUQtNGqgi+80C3TRmMVadBPHXXd
 BiwzqPMO5rGGVMZ2hA8/wzKT9tvqFrRIf1XLHamL9KqemkBoM0U2CVaOwIVij0/xBmTa
 HyNue8Res1oD2VwgkbO0m1ZqClJhxxZS9LlLH5Pq/5ojKA42dG7/WjHiOgqyeZd3WC7d
 Qd7tvLktDfxEmE1A/JJ2fGRK1tV2GtApRPIPU6a/wiITcd9mz1GwPZgVOM7KENh/Lp/x
 MR9lxe3Luzk6lCNIjHswnLyCGMzTn3u9ao8wjzjXfCwfRy3FJfTV/sIt8TdE2J+mqvos
 Qeuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=dBhWGBisxfa1raeM1guw9xlVWqydEL4cHPADAnOG63g=;
 b=IrG4+R+PiCfvQu2Cm2wA62F5d/NNAHUT23EmuQMtDv6rN0k9tq4/tToak2cgGGYQwT
 mO1jckKuG4PRpRlVEvn4byizyzGW2EQ7fBrlUUKWgfAPHXiovrskaeiLS8DihgHlKTUS
 UhGe39cbFCwIOvYeT1nMscebweAYooUkG9BI4g42jQ1BQffVUQVF//Rm0XfcULb/JVqL
 zRCIzmzCRFTenUOng04T/484dMOzzqPakZEXqbF8XO9bQUGHKsJyWs58V2idgFGKJ5ut
 gzjgKvGyvvtqt8ejwYufxu/4wOVdJkdK9LGfjlf82a9pxBYGGrcrHGSwk1O2PvhAirp1
 +qZg==
X-Gm-Message-State: AOAM533b0tNTe18TM7HRFWhTDHkmtNagI2SAYEFUGHJrXXslbXILmyUS
 buGKuCrttiBuJvyjZbmKYr/UIRH/pFB/oxMUKhzi5jPG
X-Google-Smtp-Source: ABdhPJzcYVQUaBvCJrlqFWyeKN1Y1cF/ZFaUQ6YKLNNFZiuKkZf5QqhDbRIfmD0kFk3eH2WGZshIb/hTXr/ZZCT7i5s=
X-Received: by 2002:ac8:551a:: with SMTP id j26mr26222387qtq.237.1591078740504; 
 Mon, 01 Jun 2020 23:19:00 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?w5HDtMOYYg==?= <domlolpls8@gmail.com>
Date: Tue, 2 Jun 2020 14:18:49 +0800
Message-ID: <CAKUrxgmRVOVc6rzc6fxq8Efh_ixfnD_CETSd=Ayycu4Tii_XjQ@mail.gmail.com>
Subject: test
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Tue, 02 Jun 2020 03:53:06 -0400
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
Content-Type: multipart/mixed; boundary="===============4182435370478338085=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4182435370478338085==
Content-Type: multipart/alternative; boundary="00000000000023350805a713e329"

--00000000000023350805a713e329
Content-Type: text/plain; charset="UTF-8"

test

--00000000000023350805a713e329
Content-Type: text/html; charset="UTF-8"

<div dir="ltr">test</div>

--00000000000023350805a713e329--

--===============4182435370478338085==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4182435370478338085==--
