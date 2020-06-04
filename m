Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98463C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:14:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CFCA206C3
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:14:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q0AQr8qJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CFCA206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92CA64B30B;
	Thu,  4 Jun 2020 09:14:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sYIGD+OPBDbb; Thu,  4 Jun 2020 09:14:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88A3C4B2EE;
	Thu,  4 Jun 2020 09:14:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D2124B2E6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:14:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ntZ9AXcFA3v for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 09:14:52 -0400 (EDT)
Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com
 [209.85.208.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 063BB4B2BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:14:51 -0400 (EDT)
Received: by mail-lj1-f193.google.com with SMTP id z18so7169128lji.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Jun 2020 06:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rvA0g1H8/qDSww1N+MC4xGCNWg2HV4OLYTmKhd/FSeE=;
 b=q0AQr8qJJYdYEryoPCNAux7IMp+tlMxmJK8d2WAfojVEdx/zBSwfqbianDlHM9NSb6
 TTnAylh3pcJc68OLEcoVBD2mNpEI4Xmmbt2M+cDNO/t7Eka2rAq5Rxjw9Bq7P68EA+IS
 hPzXn/9Xl8bc++l7efxsWf3L+KMv0lFOXt2z+oQt/Ok4lgMbfZ9E79tpYXFp3zxty24D
 ZLFj2n7J6xlkWlbE2KEXqdT7YYgA8Ip1nNdtUoLudEfNcrnSrbOt2wnGif8P/rUO+lAo
 8m6b9Ovk52KO1ZytcU19ej9YiLV7NyZtrFNvt5QYC6Sa5GEjtNa9egQiUT5KMKhxLysV
 d0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rvA0g1H8/qDSww1N+MC4xGCNWg2HV4OLYTmKhd/FSeE=;
 b=gdkGg7Wmzc2HRS5ZEKurFPGNV3hWNyB3BwEYsA6je8sl2gAdRW6KQfHDIojbDLHn7z
 Ya04Hf3cMkZLQozNErVw+mqQheLWF1An/wxZ7rjYBXItP5XERoTy+dhBm1j8f9Kll9OO
 pjxfL9SA29kHTkaIiJTTeyIy9tdviMldDH/T4nxsw4tCYwXLE3BgFXTkm6Aejcb9Db6h
 sN1gpFqCs2o13OhfhdMeOKAAQOqcvPL/j70l9HwzA09qMYyf5rsq1f/tTKs1qyOQPutm
 OAwQbj7FOCq0YVvVIxYRoec0s6rnf0xsyCmnuJwinIsOi857Q1zQIpBRaENEfyT/qXww
 7yiQ==
X-Gm-Message-State: AOAM530ROHJNvxO7jSrXyMA3jvqMyOAhWXVlxsHsJma9bK1kOfkZdm4N
 rY5g0FXB6LqESAgj0ezpRUJVAxJgKkbwp9d7yQ4=
X-Google-Smtp-Source: ABdhPJw3TeaEydFqJh515TquuO2xHz3YUXZRSqo14z6NxlPwg6jD65y+LsoY1qV5otXgnDY6EaEPQbqO2huA9toCWbI=
X-Received: by 2002:a2e:8490:: with SMTP id b16mr2262242ljh.325.1591276490402; 
 Thu, 04 Jun 2020 06:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAE=Ncrb80uS5wtAu6e1Gctnu8tjcBEpWd7zHJv7aHdEkipe2FQ@mail.gmail.com>
 <7d05e422cb61296fe372e0de3f1602b2@kernel.org>
In-Reply-To: <7d05e422cb61296fe372e0de3f1602b2@kernel.org>
From: Janne Karhunen <janne.karhunen@gmail.com>
Date: Thu, 4 Jun 2020 16:14:38 +0300
Message-ID: <CAE=NcrZ_JFrbimwmoCGt0Dix9A9bMDrG++_i+kJZKz_Ekw5YfQ@mail.gmail.com>
Subject: Re: randomly firing kvm_arch_timer_handler
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 4, 2020 at 3:37 PM Marc Zyngier <maz@kernel.org> wrote:

> > triggered. The guest does run, but the whine (unexpected interrupt) is
> > annoying and it seems to be hindering the performance drastically - of
> > both the host and the guest. This behavior can even lead to the host
> > watchdog biting as the firing timer prevents the progress, especially
> > during the very early boot when the guest is doing heavy paging
> > anyway.
>
> The only system I witnessed this was a Cavium TX1. It seems incredibly
> bad at retiring an interrupt that has been masked at the source.
> Which hardware is that?

Unreleased one


> > Based on the comment in the latest code the fundamental issue is that
> > the interrupt controller does not recognize the timer disable fast
> > enough on guest exit.
> >
> > Has anyone worked on a proper fix for the issue
> > for the old stable series? 5+ kernels seem to have quite a drastic
> > rework on this front. Plain 'isb' did not seem to do the trick after
> > the timer disable...
>
> ISB really has no bearing on how an interrupt gets retired from the
> redistributor. The flow we use on mainline these days makes it less
> susceptible to this kind of brokenness, but it is still possible to
> hit it.

Thanks. I'll try to see if I can backport some of that.

That said, if you remember my previous email, we got the kernel
external hypervisor going. I have multiple kernel versions running OK
(4.9 ... 5.4) under the external hypervisor. It will still need some
polishing rounds and security related work, but in general it seems to
run fine. 95%+ of the kvmarm code is intact and I suppose if this kind
of thing is of interest to others, we could present the work and
potentially some of the hooks required in the kvm code to make it all
run for others, too. The guest and the host can both be VMs and the
guests can be just untouchable holes in the host memory. Kind of like
AMD SEV, just no encryption needed.


--
Janne
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
