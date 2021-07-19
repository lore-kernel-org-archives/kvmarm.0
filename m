Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744B0C12002
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 13:32:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE87661006
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 13:32:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE87661006
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1E44020A;
	Mon, 19 Jul 2021 09:32:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ylej3tKpE4Cr; Mon, 19 Jul 2021 09:32:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37C1740463;
	Mon, 19 Jul 2021 09:32:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5612406DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:32:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H8rMVnPuaxZI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 09:32:15 -0400 (EDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC0F14020A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:32:15 -0400 (EDT)
Received: by mail-wm1-f51.google.com with SMTP id c17so3320140wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=e+7w0DILOdROevsETjkyzSOUy+VWGNhHDOlUAzj7VhU=;
 b=Ph0oVZBQZWDgTvH3+Q60TivzYxq/EWsXd41TTstiMh3CZ3iKOU2e+qg7m36V23hlGu
 Rk6Js9o4z83GYzvt/FvwvBeisUojOCPTZd5QMlhAmiva/qZIzft7AUnDFYptkQkBF4gJ
 qqCXXlEwYtMjrLc6XHGv7oE+4mNCzUpTME5gxefXghyIaUzLFWfyU7kVPpA2+GpBhl+K
 1gf60PNupu9PenlLG28WQbgLGUYzGAZ3qXty5Hn7Y3F7vOVgYwdCq/oyJ+b0+ZwOcz1l
 jjvkoxnRJ/rDUkLNHUvORoQ55Tpg6NjXO1dJ5Ca3ugDYdHfbqxmgowt6ipRXVeC94vJZ
 tuxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=e+7w0DILOdROevsETjkyzSOUy+VWGNhHDOlUAzj7VhU=;
 b=IDiOQDKfLshce0gMN+rIs4GIHAdo+1bt0q/0FzsiWj/VZphsebTd9jZUDgBVSGmoqq
 8yzt3vR7K90mn8IT0sutKo+nzplldhDPKfPnucD2XP7qkSwfpfDORCfCueD1Em8yfKVi
 EqdV/OHxl9DOpOrgumqSpnq50gv+GrBeR6ZHilh3SY12LVyyyGr551TwMFiItxpmUQws
 AS/Z8TDqNwx3ulwppMh9f64OOUm04lmY/Jw3UMiijU6fxGXBXnLTRX6SI48gO85arZGr
 BmE8VX/CfSHABfjZKCGUteJ/nBruD91CIH4bjoh2KBrhn8jR0Dzg3d5ophBgOuaV+U44
 kueQ==
X-Gm-Message-State: AOAM5319Q+peQq8eTI57X+EEpb8qadMd3ZDqyA+V/ptQsZHmbPnvFueD
 1yhxnoP3DHnq1aUDVE7Yvz8SeA==
X-Google-Smtp-Source: ABdhPJxD0sq1Omt7X50ZoMJy9SEY47bAIcfJMuUmV8iseFr7tGbOTs9v5GyO/p3WxY358ATqNVhqWA==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr26551985wmj.144.1626701534460; 
 Mon, 19 Jul 2021 06:32:14 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id t16sm7778118wmj.16.2021.07.19.06.32.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Jul 2021 06:32:13 -0700 (PDT)
Date: Mon, 19 Jul 2021 14:32:10 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/14] KVM: arm64: Continue stage-2 map when re-creating
 mappings
Message-ID: <YPV+2jQ/Q/ie14Fn@google.com>
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-4-qperret@google.com>
 <87lf62jy9z.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87lf62jy9z.wl-maz@kernel.org>
Cc: kernel-team@android.com, qwandor@google.com, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
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

On Monday 19 Jul 2021 at 13:14:48 (+0100), Marc Zyngier wrote:
> On Mon, 19 Jul 2021 11:47:24 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > The stage-2 map walkers currently return -EAGAIN when re-creating
> > identical mappings or only changing access permissions. This allows to
> > optimize mapping pages for concurrent (v)CPUs faulting on the same
> > page.
> > 
> > While this works as expected when touching one page-table leaf at a
> > time, this can lead to difficult situations when mapping larger ranges.
> > Indeed, a large map operation can fail in the middle if an existing
> > mapping is found in the range, even if it has compatible attributes,
> > hence leaving only half of the range mapped.
> 
> I'm curious of when this can happen. We normally map a single leaf at
> a time, and we don't have a way to map multiple leaves at once: we
> either use the VMA base size or try to upgrade it to a THP, but the
> result is always a single leaf entry. What changed?

Nothing _yet_ :-)

The 'share' hypercall introduced near the end of the series allows to
share multiple physically contiguous pages in one go -- this is mostly
to allow sharing data-structures that are larger than a page.

So if one of the pages happens to be already mapped by the time the
hypercall is issued, mapping the range with the right SW bits becomes
difficult as kvm_pgtable_stage2_map() will fail halfway through, which
is tricky to handle.

This patch shouldn't change anything for existing users that only map
things that are nicely aligned at block/page granularity, but should
make the life of new users easier, so that seemed like a win.

> > To avoid having to deal with such failures in the caller, don't
> > interrupt the map operation when hitting existing PTEs, but make sure to
> > still return -EAGAIN so that user_mem_abort() can mark the page dirty
> > when needed.
> 
> I don't follow you here: if you return -EAGAIN for a writable mapping,
> we don't account for the page to be dirty on the assumption that
> nothing has been mapped. But if there is a way to map more than a
> single entry and to get -EAGAIN at the same time, then we're bound to
> lose data on page eviction.
> 
> Can you shed some light on this?

Sure. For guests, hitting the -EAGAIN case means we've lost the race
with another vCPU that faulted the same page. In this case the other
vCPU either mapped the page RO, which means that our vCPU will then get
a permission fault next time we run it which will lead to the page being
marked dirty, or the other vCPU mapped the page RW in which case it
already marked the page dirty for us and we can safely re-enter the
guest without doing anything else.

So what I meant by "still return -EAGAIN so that user_mem_abort() can
mark the page dirty when needed" is "make sure to mark the page dirty
only when necessary: if winning the race and marking the page RW, or
in the permission fault path". That is, by keeping the -EAGAIN I want to
make sure we don't mark the page dirty twice. (This might fine, but this
would be new behaviour, and it was not clear that would scale well to
many vCPUs faulting the same page).

I see how this wording can be highly confusing though, I'll and re-word
for the next version.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
