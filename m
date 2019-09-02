Return-Path: <SRS0=BSul=W5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302DDC3A59E
	for <kvmarm@archiver.kernel.org>; Mon,  2 Sep 2019 13:12:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBFC920820
	for <kvmarm@archiver.kernel.org>; Mon,  2 Sep 2019 13:12:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tk1C7tNA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBFC920820
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37C004A4A3;
	Mon,  2 Sep 2019 09:12:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id htHaBZkihI3w; Mon,  2 Sep 2019 09:12:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1448B4A4CD;
	Mon,  2 Sep 2019 09:12:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24CC74A4CD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Sep 2019 09:12:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aaAspIs09K+v for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Sep 2019 09:12:50 -0400 (EDT)
Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com
 [209.85.208.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D91924A4A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Sep 2019 09:12:49 -0400 (EDT)
Received: by mail-lj1-f194.google.com with SMTP id j16so6658108ljg.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Sep 2019 06:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:from:date:message-id:subject:to:cc;
 bh=NzNhTv97ocb1btJLZ5/87Ps57YM4E7GBGFrOG0ccvdg=;
 b=tk1C7tNAQOEIJhsKAEuMfab3D+xc5360NO1T6Mxe5hzICP1T4KIju8j9c5PK2LBIe9
 2b5vhYYRfQ2oQ8YMo8vevXHLaOH+tOA2V3+DjJRc1Dpj2WGtVt7n43xrmZyc0pOjpWRM
 /ilrx4myqtNdMRl4v/bq3GJ9tvZF0mCjwFZpzKMMkpA1HzLW1I9qrR3ho2a13mQBGXs0
 NZBclRhTBl6EuxviPHsiUJgrFi4iZO3IFlKCoUPFOlKYPhf5psO4sV3QQUiqGJ2Fvt3u
 0vDHZ9jCIRLBfLCADGjxnuwxv9e4suFXsR6UXf12l3iYK7lrB9AwlgXNKmiM4PNxv8mK
 yyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
 bh=NzNhTv97ocb1btJLZ5/87Ps57YM4E7GBGFrOG0ccvdg=;
 b=gnBFCRxR0OR0Y++dXC24B+8m+5Dm6PcpPzYEI0Zl1HPNwCVpXlMvrce02zVJ5e4t8M
 5pdPS9EnBKmrfC7FHJXuhWoKsiCzD8b+w50P1ulHRv4Cw4+yMHg2hWB0U0NMQUKQ7LNx
 45xaMEoJxgmfeUU4ioGMlJy6rBSSNOP4fg4bviduv2gAzeQzFY4aG+Y3DYC59sJTPs4P
 OfsH0ETwfb5kMoqID1mKs7gUjHWtdpxAtUgcnjOaOOhTYy1uU4Ea759fWoyy8t0queh8
 jaGghJ2fod6effszJmXxeC2/nwogXpn35LgvqopU5pfUABLaQyvTeok5fiwe7OeNXwxG
 HxKQ==
X-Gm-Message-State: APjAAAUVJ0jqLSunqNNkIobP8D8561ZKzgH4l61EVx3N1owR33BnaDud
 QX4KKibD941wvxPbVnMdhVf01w6eV1bCY+EaoqKLXbNM
X-Google-Smtp-Source: APXvYqxjisWh55e6KwUFixArUP+hNnkMGsTziZOIvhQGmBkrLI2tTkMlJrRUunL2xgDeWn+QUgW3BcvXtvrEQ86TOdw=
X-Received: by 2002:a2e:819:: with SMTP id 25mr16309859lji.142.1567429968229; 
 Mon, 02 Sep 2019 06:12:48 -0700 (PDT)
MIME-Version: 1.0
From: Turritopsis Dohrnii Teo En Ming <teo.en.ming.smartphone@gmail.com>
Date: Mon, 2 Sep 2019 21:12:34 +0800
Message-ID: <CA+5xKD631kijzXTwsa1LWqz6eL_3wJA73bwAnQHFDYei5E+e2g@mail.gmail.com>
Subject: Singapore Citizen Mr. Teo En Ming's Refugee Seeking Attempts, In The
 Search of a Substantially Better Life
To: kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Subject: Singapore Citizen Mr. Teo En Ming's Refugee Seeking Attempts,
In The Search of a Substantially Better Life

In reverse chronological order:

[1] Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday

Photo #1: At the building of the National Immigration Agency, Ministry
of the Interior, Taipei, Taiwan, 5th August 2019

Photo #2: Queue ticket no. 515 at the National Immigration Agency,
Ministry of the Interior, Taipei, Taiwan, 5th August 2019

Photo #3: Submission of documents/petition to the National Immigration
Agency, Ministry of the Interior, Taipei, Taiwan, 5th August 2019

Photos #4 and #5: Acknowledgement of Receipt (no. 03142) for the
submission of documents/petition from the National Immigration Agency,
Ministry of the Interior, Taipei, Taiwan, 5th August 2019, 10:00 AM

References:

(a) Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday (Blogspot blog)

Link: https://tdtemcerts.blogspot.sg/2019/08/petition-to-government-of-taiwan-for.html

(b) Petition to the Government of Taiwan for Refugee Status, 5th
August 2019 Monday (Wordpress blog)

Link: https://tdtemcerts.wordpress.com/2019/08/23/petition-to-the-government-of-taiwan-for-refugee-status/

[2] Application for Refugee Status at the United Nations Refugee
Agency, Bangkok, Thailand, 21st March 2017 Tuesday

References:

(a) [YOUTUBE] Vlog: The Road to Application for Refugee Status at the
United Nations High Commissioner for Refugees, Bangkok

Link: https://www.youtube.com/watch?v=utpuAa1eUNI

YouTube video Published on March 22nd, 2017

Views as at 31st August 2019: 593

YouTube Channel: Turritopsis Dohrnii Teo En Ming
Subscribers as at 31st August 2019: 2815
Link: https://www.youtube.com/channel/UC__F2hzlqNEEGx-IXxQi3hA





-----BEGIN EMAIL SIGNATURE-----

The Gospel for all Targeted Individuals (TIs):

[The New York Times] Microwave Weapons Are Prime Suspect in Ills of
U.S. Embassy Workers

Link: https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microwave.html

********************************************************************************************

Singaporean Mr. Turritopsis Dohrnii Teo En Ming's Academic
Qualifications as at 14 Feb 2019

[1] https://tdtemcerts.wordpress.com/

[2] https://tdtemcerts.blogspot.sg/

[3] https://www.scribd.com/user/270125049/Teo-En-Ming

-----END EMAIL SIGNATURE-----
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
