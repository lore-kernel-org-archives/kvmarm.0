Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D49C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 16:04:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0161B20771
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 16:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="rSfzLsKN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0161B20771
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 717934B29D;
	Mon, 13 Jul 2020 12:04:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ebGFRK9Y-hG8; Mon, 13 Jul 2020 12:04:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DCC74B29C;
	Mon, 13 Jul 2020 12:04:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 304D24B298
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 12:04:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bOndtj9oOCOS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 12:04:23 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30BF44B106
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 12:04:23 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id 22so75769wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 09:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=UtKxkaJZz7lB0LAd5+CS+SHA3JlOL+gjrkrjvFvbnjo=;
 b=rSfzLsKNPwm66mqXGBHYtojv7RkDT6Dfj+8VA7Y0l0JZ53DW4ZiO7uE/Fb2gazAQIV
 WqENiJx8N+wIw+mkGukgS2VLsjkhaWny/+qua18qKBiUQ/3Nqs0JHZWR6JF9udqcidhU
 RgtQ0Au7GW4jVCoaspnG4wwbXlDpZZRHeNOgZZCsNBl+zCOrj+ubFc77s44RO6PluINk
 xPEFQ2EYBIz7EauJFwwRm7DFsAujY5PUXnTtpMNMp0H7iz1LacQ2vITrOSrAqACMamH2
 kkAb/BuX8hTbOGEfOB8wKfeIlRSOSU9haqD1KU8A9fSVk/eBqZGJWJg6a6yN0YSvCrhg
 /ZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UtKxkaJZz7lB0LAd5+CS+SHA3JlOL+gjrkrjvFvbnjo=;
 b=cQfeoLhlKMIH1aIbKnr+p6ChlHU9lzr/F3VbCA+JdF+3LGMle/C7ph5GIQn7COd0Et
 qvSHkbuJ2LSPZjzSnvp2LTqUH9AJB8u3bDLS/BkjvpckbypC1ra5kPV5KNyXcO3WAlHv
 aNFk3w4CzsAne4EdqSNDW3WHDqyKMmR4ZE4OzM1SteG3vJDEuSL6JEpURGsJXUSIdW/G
 4jU+POLUiNUL5aKgSz3VDVUpKXC2lDKjLOSTPwTKFClZ9l9lp/Z8WLUZeoIL4XNlClaD
 gxHvCHl3p+cmheXg1O2xSHhRQEencmowOsNVIxhhK1oTGtZtnCc6TPiXxysX7mlk7saq
 DzIQ==
X-Gm-Message-State: AOAM530i7N8TtIbJzQlv6jjc50SGBEiDIC14Jrm4b98mth3mkOCMmYLn
 JG0bm9lPER1ypEzztZmmx9rnyA==
X-Google-Smtp-Source: ABdhPJwwvVXAYDT2cXytivxFTKR4PaDX2xKyg0A1PeKcjB5uyyHzBvP9VEcpIdNRahA/qYxGN1JvyQ==
X-Received: by 2002:a1c:4143:: with SMTP id o64mr112082wma.28.1594656262028;
 Mon, 13 Jul 2020 09:04:22 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id h23sm100946wmb.3.2020.07.13.09.04.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Jul 2020 09:04:21 -0700 (PDT)
Date: Mon, 13 Jul 2020 17:04:16 +0100
From: Andrew Scull <ascull@google.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] arm64: kvm: Remove redundant KVM_ARM64_FP_HOST flag
Message-ID: <20200713160416.GA2358670@google.com>
References: <20200707145713.287710-1-ascull@google.com>
 <20200713154002.GR10992@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200713154002.GR10992@arm.com>
Cc: maz@kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jul 13, 2020 at 04:40:02PM +0100, Dave Martin wrote:
> On Tue, Jul 07, 2020 at 03:57:13PM +0100, Andrew Scull wrote:
> > The FPSIMD registers can be in one of three states:
> >  (a) loaded with the user task's state
> >  (b) loaded with the vcpu's state
> >  (c) dirty with transient state
> > 
> > KVM_ARM64_FP_HOST identifies the case (a). When loading the vcpu state,
> > this is used to decide whether to save the current FPSIMD registers to
> > the user task.
> > 
> > However, at the point of loading the vcpu's FPSIMD state, it is known
> > that we are not in state (b). States (a) and (c) can be distinguished by
> > by checking the TIF_FOREIGN_FPSTATE bit, as was previously being done to
> > prepare the KVM_ARM64_FP_HOST flag but without the need for mirroring
> > the state.
> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> 
> Is your new series [1] intended to replace this, or do I need to look at
> both series now?

Sorry about that, should have v2'd it. The new series replaces this.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
