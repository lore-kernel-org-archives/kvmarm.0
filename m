Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5055C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 13:47:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61F7061131
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 13:47:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 61F7061131
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E56C740839;
	Mon,  2 Aug 2021 09:47:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5jC3Qw+-pHpx; Mon,  2 Aug 2021 09:47:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCCA44A49C;
	Mon,  2 Aug 2021 09:47:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 375214A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 09:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vtIRyDI9txcx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 09:47:33 -0400 (EDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1821040617
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 09:47:33 -0400 (EDT)
Received: by mail-wm1-f48.google.com with SMTP id
 e25-20020a05600c4b99b0290253418ba0fbso17334wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 06:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ZosgW5P/FRPWGDl9IhPM3Dl11PT0YSNjES1UOYC23P4=;
 b=iSwcVNXbwMj6bVndtAFh7/bVmULdw+Y4ZH4kvjV+Mb+DxmGuikESzaj9cZHzvQhcFz
 2eSHGQSrKDRpbtKb/YrDbNUibFkKb8uFFnLk+qF8lmUt43Ukaxxq/v2lDPf36NI/ZRr1
 VXf1q8muGbwUkVEgTkW2yIhJfPzY1gVV7HEaMODfE67CUAezeMGlH1xyXDm8GyIAqTSf
 X2Ye+SXcHcjI8EFlHa5CEW/ZYQ/qXGLCRNdkqaBRZhA7vMLLuIJlJUa8IM00fF1ft3l0
 8Jrr8L8IQh/ExzlathQ0Iqs3f13X25ek8ua+hPjVzfA0RJPAWlAii6VnDph3LkL1thD0
 AatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZosgW5P/FRPWGDl9IhPM3Dl11PT0YSNjES1UOYC23P4=;
 b=R2pGmWRoRoZ2ruDVqjpxt5axSbjYXiGicEH1Bu092LLg4N0V4svYOY8AebcnyV6JF6
 m+rH+811UgIB6DlkIdkywgEfTGtbbrOIRIMkcd3lqHOEeOKmXlxWJ6sit6wO7sLecZrI
 rqPfd2GsUo1sFeHR1iW3R1llSaB+dWW25ycXvWocKxfpXUp02jTqhA/3VGVrXvlIDwmj
 IecUvzUX5oV3AMBytVvEN47FVE+q+SACFlV6N4iRpyOP8KB2jfq3kjxAnX5AtGNR9MDv
 67FU7BOkLI7qgmEe1hxPXb862/4gwUQXWoxPAF+Rf4hreS7Y7gXh+Omx9cVQ8G0Gkcve
 XG/w==
X-Gm-Message-State: AOAM531PJIDHC2ACcZJs8FyV1grLE3ICPAPIHLPlHCU0YK3SRxUafodL
 KxDkN50vFu654Tm8Eo2X86IwRw==
X-Google-Smtp-Source: ABdhPJyu3MDRDzEwimKK8eR6XfIVIZgUH41B1Kmkh8eOZJZPZLglJQmXQDBg756DblUv9SmM0jIVwQ==
X-Received: by 2002:a05:600c:2306:: with SMTP id
 6mr16843468wmo.115.1627912051856; 
 Mon, 02 Aug 2021 06:47:31 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:44fe:c9a8:c2b2:3798])
 by smtp.gmail.com with ESMTPSA id b14sm11551749wrm.43.2021.08.02.06.47.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 02 Aug 2021 06:47:31 -0700 (PDT)
Date: Mon, 2 Aug 2021 14:47:28 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/2] arm64: Move .hyp.rodata outside of the
 _sdata.._edata range
Message-ID: <YQf3cKjMa9rrGRqP@google.com>
References: <20210802123830.2195174-1-maz@kernel.org>
 <20210802123830.2195174-2-maz@kernel.org>
 <YQfu6+3uo6qlxrpv@google.com> <87mtq00yqd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87mtq00yqd.wl-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Monday 02 Aug 2021 at 14:20:42 (+0100), Marc Zyngier wrote:
> Hi Quentin,
> 
> On Mon, 02 Aug 2021 14:11:07 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Monday 02 Aug 2021 at 13:38:29 (+0100), Marc Zyngier wrote:
> > > The HYP rodata section is currently lumped together with the BSS,
> > > which isn't exactly what is expected (it gets registered with
> > > kmemleak, for example).
> > > 
> > > Move it away so that it is actually marked RO. As an added
> > > benefit, it isn't registered with kmemleak anymore.
> > 
> > 2d7bf218ca73 ("KVM: arm64: Add .hyp.data..ro_after_init ELF section")
> > states explicitly that the hyp ro_after_init section should remain RW in
> > the host as it is expected to modify it before initializing EL2. But I
> > can't seem to trigger anything with this patch applied, so I'll look
> > into this a bit more.
> 
> The switch to RO happens quite late. And if the host was to actually
> try and change things there, it would be screwed anyway (we will have
> already removed the pages from its S2).

Yes, clearly mapping rodata RO in host happens much later than I
thought, so this should indeed be fine.

> I wouldn't be surprised if this was a consequence of the way we now
> build the HYP object, and the comment in the original commit may not
> be valid anymore.

Just had a quick look and that still seems valid, at least for some
things (e.g. see how we set hyp_cpu_logical_map[] early from EL1 while
it is clearly annotated as __ro_after_init in the EL2 code).

> > 
> > > Fixes: 380e18ade4a5 ("KVM: arm64: Introduce a BSS section for use at Hyp")
> > 
> > Not sure this is the patch to blame?
> 
> My bad, this is plain wrong. I'm not sure it can be applied earlier
> though if my rambling above is correct.

By the look of it going all the way back to 2d7bf218ca73 (in David's
PSCI proxy series) should actually be correct. But not sure if that's
really going to make a difference before the patch you've mentioned
above as the kmemleak issue will only be visible once we have a host
stage-2, so no big deal.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
