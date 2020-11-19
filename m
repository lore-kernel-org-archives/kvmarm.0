Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52C8C6369E
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:39:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F8262220B
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K7bWQ0Zc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F8262220B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70F294B4BE;
	Thu, 19 Nov 2020 11:39:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k8wGb6W4OSF5; Thu, 19 Nov 2020 11:39:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 739DF4B538;
	Thu, 19 Nov 2020 11:39:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAB054B53B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:39:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1U-gQAALWRgQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 11:39:54 -0500 (EST)
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com
 [209.85.218.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D97464B4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:39:53 -0500 (EST)
Received: by mail-ej1-f67.google.com with SMTP id 7so8848661ejm.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 08:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=wHCeV+0wASxa7xKuZTzPc3uHjiByPnCWQmQdnty1SfE=;
 b=K7bWQ0Zc34TB663V4lX0Qpf54I3JpW4/Qv0E3aCd2FzmNzPEhOljrgVnmphkmOB1dc
 a6SoyQVZUAEKpTTkmOmFxaWEbyIHfNU1t5s4H+FGnQfBh3yN4A0dv3Jjpn7D4gdQJdwO
 Ju3cHL9f6IDj08kfEWIO22b2kY0KCvZqLgRoc06QwAaZrdQx8LsgIRI/fXWLbGC17jXb
 HMMexFgaVR1tx6U/qzRdJJFqAt6ocD2O2c/l/aEEZF7tOOrDJWmaySSX9sKRw4Ov4wXs
 joWmgV0j3pVCynbuzQOj93EchianKE39W9JT+KbSmq6jMP9MZyZAwS+f/yKTtTxNhQj6
 GEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=wHCeV+0wASxa7xKuZTzPc3uHjiByPnCWQmQdnty1SfE=;
 b=MYZ+CNoK7n2hgnANJ0qj2nQ6DL92lraCTC50IeYNkWQ11tcnpXeceoHOWqus/Iqlkz
 IQ/L5XCn0xnCH/AvzaaM5DRtfxCreyTcp+davM7F2sZe58HSSUO1iFWTojw/tGIvp0th
 CeXbyFMwxnxSqWyS3kJ7tTA5V+wo5F/rAyWKS+AInLJyKIgma2TA5GwHzGONFD/RCyVC
 o/hb0Q3nDNwTZXYGSSE4fs7X+AzLgM8epbgUB/wJvZNbbE8uo2t0T1gm1GVs5+hU3WSq
 DgLLgeXcM0SFREUiChK9Ta77RwxxCYJ4aVRgrvjlS2mZUVjojR75hUSlgllRFe1JQNG2
 KclQ==
X-Gm-Message-State: AOAM533H6eroAh03jS+UTTnNpFZV70eMSQiZ9bb7MQPKRh0DzmhLeXzx
 v1riWWX+3oBwC80edCi36ltnkhUQxUpVe55uxgoKYA==
X-Google-Smtp-Source: ABdhPJxohkqohF8Rold75mHYphEqgvgYH008wPvAAASt8psj0r6y3aoUKE/wT9nNKiSdXCRUmbbTz2P3mxtXYvrp7Oo=
X-Received: by 2002:a17:906:af8c:: with SMTP id
 mj12mr28777718ejb.85.1605803992789; 
 Thu, 19 Nov 2020 08:39:52 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <b434977d-08d7-f753-f95c-81fc533cae0a@arm.com>
In-Reply-To: <b434977d-08d7-f753-f95c-81fc533cae0a@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 19 Nov 2020 16:39:41 +0000
Message-ID: <CAFEAcA_navHXiwJOwWas-TXdVhxY_kJjVNxHvDCY4ArizH_CQQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Steven Price <steven.price@arm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, 19 Nov 2020 at 15:57, Steven Price <steven.price@arm.com> wrote:
> On 19/11/2020 15:45, Peter Maydell wrote:
> > I'm a bit dubious about requring the VMM to map the guest memory
> > PROT_MTE unless somebody's done at least a sketch of the design
> > for how this would work on the QEMU side. Currently QEMU just
> > assumes the guest memory is guest memory and it can access it
> > without special precautions...
>
> I agree this needs some investigation - I'm hoping Haibo will be able to
> provide some feedback here as he has been looking at the QEMU support.
> However the VMM is likely going to require some significant changes to
> ensure that migration doesn't break, so either way there's work to be done.
>
> Fundamentally most memory will need a mapping with PROT_MTE just so the
> VMM can get at the tags for migration purposes, so QEMU is going to have
> to learn how to treat guest memory specially if it wants to be able to
> enable MTE for both itself and the guest.

If the only reason the VMM needs tag access is for migration it
feels like there must be a nicer way to do it than by
requiring it to map the whole of the guest address space twice
(once for normal use and once to get the tags)...

Anyway, maybe "must map PROT_MTE" is workable, but it seems
a bit premature to fix the kernel ABI as working that way
until we are at least reasonably sure that it is the right
design.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
