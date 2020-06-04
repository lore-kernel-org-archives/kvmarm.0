Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F3AC433DF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:37:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E623D207DF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:37:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d6lkZg00"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E623D207DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BF6A4B35C;
	Thu,  4 Jun 2020 09:37:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zPOETuuG-2-1; Thu,  4 Jun 2020 09:37:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 308504B35B;
	Thu,  4 Jun 2020 09:37:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 300994B354
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:37:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AiXe9qcUT7p7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 09:37:48 -0400 (EDT)
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com
 [209.85.167.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15E824B2FC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:37:48 -0400 (EDT)
Received: by mail-oi1-f194.google.com with SMTP id a137so5097711oii.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Jun 2020 06:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VzZ6Wiac3hkSNr5jQzhWPiHZxuLwzhsmIf66iTOTCD4=;
 b=d6lkZg00g4aEpYR7gFHX3mGWaI+f6OcmuiSIr1JuUdjzHQQA+cqQJJLp4LcWq+akqu
 ktc7fZV6YkLdsqjUgI6qm7SvZdOB+9/DhHTXBAFCwLfqI7OYzUvV79+1rZvZ3QqHtj3T
 YaM7mP1rp0DNmIDKql5u/BBh/Rq0hLB+NnvFCBgJ2Xui+DBZ7WdaATemgG2S0A40eGOb
 7tEV+aLwq2iNg1nHz1dangZyL5pvFTt+4/yPwme+MHKFTV9AbpVwLS8QTelwXPjNb7WI
 vuoAQXmR6X5VcPAX3juNLHm8MuI9ABi/AG4z1lOD/pTPlmBBSNDkswED7p9NAHUWP7np
 HFXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VzZ6Wiac3hkSNr5jQzhWPiHZxuLwzhsmIf66iTOTCD4=;
 b=SHI/VtntkhMqUdbEujnBcZfCts6TSWk11ZmXMgCzW5y+DSkP4tW2jW/I9AfZgk/9d4
 kc1enRtvWQeBX8/LHOgdu9RrJntudYZctdxcDWl03Rf8ps63WYwU98RnwrqdAgXz8aCI
 3exkErKimt4P71C7Mj6t9eU28MfJ/z/k3GMHt8oTOZ9JebBMKokeoSLxxYR+pgo4fudw
 8Nbi0BNXJPN3vnm80sIrRJPoB2P2N6FA1A4oJDMhbvPa7WOl9rZ7i+kJI44R5bfZKDDQ
 CQLX77oMD0+ZR8PLMdm88slb5rLqNACVG0/4ktdTBNZC7+0/GgGLEZll4XjrP2d6sIha
 oZzg==
X-Gm-Message-State: AOAM531ZdInyQBi5IYfF2084lo8r5zda9jAzIALThhsbw44Mvu8f5Yjy
 eJBCFQtXWlrW01NEr14Aykegib2ioo57KRayCnDBLQ==
X-Google-Smtp-Source: ABdhPJw+4eNIl5O3xHQbHlFaV8UFq90vk5gPrGG4mj4ZpCRpmYt4hqvsEwKrEJWc2gN6hxxcN2wEaSkaNdOv95Vhd7I=
X-Received: by 2002:aca:5152:: with SMTP id f79mr3017830oib.146.1591277867402; 
 Thu, 04 Jun 2020 06:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200604125544.GW28566@vanye>
 <CAFEAcA-ACvx19HZBk-nusMCOkr-D3KReUJRTouL02rLEXOUanQ@mail.gmail.com>
 <20200604133221.zpqv5segdv7qwio6@kamzik.brq.redhat.com>
In-Reply-To: <20200604133221.zpqv5segdv7qwio6@kamzik.brq.redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 4 Jun 2020 14:37:36 +0100
Message-ID: <CAFEAcA8EOis7=2rderA6qi31Yuaubt=9_yWxoc82v1paPQD_rA@mail.gmail.com>
Subject: Re: kvm_target, QEMU_KVM_ARM_TARGET_GENERIC_V8 questions
To: Andrew Jones <drjones@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Leif Lindholm <leif@nuviainc.com>,
 QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, 4 Jun 2020 at 14:32, Andrew Jones <drjones@redhat.com> wrote:
> On Thu, Jun 04, 2020 at 02:10:08PM +0100, Peter Maydell wrote:
> > These explicit settings are correct, because for these CPUs
> > the kernel does have a "give me what I want in particular"
> > setting (which it will fail on the wrong h/w), and also as
> > back-compat for older kernels that predate the GENERIC_V8
> > define and only recognize the explicit "give me an A53" value.
>
> Actually, I think the failing for the wrong hardware is about all these
> older targets do. I didn't look real closely, but I think all targets
> produce the same result for the guest, which is to pass through the host
> ID registers.

Yes; it's just that originally "specify CPU exactly" was the
only interface, and there wasn't a GENERIC_V8 at all.
I actually suspect that current QEMU will no longer work
on a kernel that's so old that it lacks the GENERIC_V8 and
PREFERRED_TARGET support[*], but we don't have an explicit "we need
at least host kernel version X" requirement that we track, so
it's hard to say for certain. (If we cared enough to test we
could likely delete a bit of back-compat handling code in QEMU.)

[*] in particular I have a feeling that recent changes to the
GIC handling code in the virt board implicitly dropped handling
for ancient kernels

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
