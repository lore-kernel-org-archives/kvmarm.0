Return-Path: <SRS0=AWUd=7R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B19C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:10:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38F87206C3
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jun 2020 13:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pOumfR1H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38F87206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F81D4B22C;
	Thu,  4 Jun 2020 09:10:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7AgZXBx-ljVt; Thu,  4 Jun 2020 09:10:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D94CA4B228;
	Thu,  4 Jun 2020 09:10:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D7E84B228
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:10:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vv50vdNGsLyT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2020 09:10:20 -0400 (EDT)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BAF84B153
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2020 09:10:20 -0400 (EDT)
Received: by mail-oi1-f196.google.com with SMTP id s21so4984984oic.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Jun 2020 06:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PWjEg59kz2CoeitEapTrGuAHI86fvdYOTJhTalufixQ=;
 b=pOumfR1HLk3zksbPDnaGI5DJbg4WgBxhcTkqidpFjTtNDff2w4FJZ6Nmkw3n1RUWfw
 iky4f/s4LzebF7TienA03dWTVldL/amvlMN0iwgRdyrjpoS60HYGEoYx6a/Bz5gxPcWP
 mayiTtPw8v/woGruUAbkzI6URvNP+1WjQFwUP3HBl0W7DdwuRMIE8sfgo6oSoImhh4G7
 0eIx2OFUnlHa9W/2L6vfKBWBhLH0vDX0CvFhcRJqQy4d4xtkNYHHZjMmuWgCeOy4u5Zv
 pB/MQmn2Hbb3DHqLwU8J/u0xhoAEc+FVXB050caiikWx9oLVzZjq+tmnEdBKi9AJp6Pq
 stDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PWjEg59kz2CoeitEapTrGuAHI86fvdYOTJhTalufixQ=;
 b=sHYwdj1XbTzUMWEYjlHdXvKm9+T0v8CwNwgSMg+V6TkuVYl/KudPimvZA7gPjuw9Mo
 6Do8wWVtNmeaIionu7+jbtJQ9IYYlY/a+IiAgBPR3IBeRQh7gu8JpuzD21vB6K49cZa2
 L+1E8FhaCD/8YWTWqYvoiFQ24dgX+09r1SP21leQlDs33ls4ehz/48S6c/6y1QOPFrAD
 oRg6TRxrhVrVZyjp+7FdvUonsaszalYfrUU1DRhAPe70PEry9VB/thZyDeibRXdREAkp
 hGUsbOkXIF2KCYE5FFTCq+SS+TU6bKSYZgz8SwdFnvg5b6i/wHS195x/ynjP1pmTN0ae
 3HwA==
X-Gm-Message-State: AOAM53149VRWXd69DL7sTzmFAzOqUlozWibA9EOF7LUhQTXlCUn0lzgD
 VBV8OHSoHnMTYlczh+TeNMV7+z0tADuh56MVfQIufA==
X-Google-Smtp-Source: ABdhPJxQK0brocuY/yk5yNQAhXiKBQWL1O57vMjoG5tbK+9HVP5RNwgfK7m5WStVPn5PL8PsFRO4dxBbKMdE0Xah7Gw=
X-Received: by 2002:aca:568c:: with SMTP id k134mr2826760oib.48.1591276219324; 
 Thu, 04 Jun 2020 06:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200604125544.GW28566@vanye>
In-Reply-To: <20200604125544.GW28566@vanye>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 4 Jun 2020 14:10:08 +0100
Message-ID: <CAFEAcA-ACvx19HZBk-nusMCOkr-D3KReUJRTouL02rLEXOUanQ@mail.gmail.com>
Subject: Re: kvm_target, QEMU_KVM_ARM_TARGET_GENERIC_V8 questions
To: Leif Lindholm <leif@nuviainc.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm <qemu-arm@nongnu.org>,
 QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

[added kvm-arm to the cc list; the kernel folks tend to hang out
there, not on qemu-devel, so KVM related questions are usually
worth raising there as well.]

On Thu, 4 Jun 2020 at 13:55, Leif Lindholm <leif@nuviainc.com> wrote:
> However, while looking at this, I noticed aarch64_a72_initfn doesn't
> initialise kvm_target at all.

Yep. The kernel doesn't support "give me a CPU that looks like
a Cortex-A72".

> So, then I decided to actually test things, and found that
> (with -enable-kvm):
> - on Cortex-A53 hardware
>   - "max" kvm_target gets initialized to 4 (KVM_ARM_TARGET_CORTEX_A53)
>     by kvm_arm_get_host_cpu_features (as returned from the kernel for
>     vm_arm_create_scratch_host_vcpu)
>   - cortex-A72 fails to start with "KVM is not supported for this guest
>     CPU type"
>   (fair enough, it's later than A53)

Untested, but I assume that -cpu cortex-a53 works on the A53...

> - on Cortex-A72 hardware
>   - "max" kvm_target gets initialized to 5 (KVM_ARM_TARGET_GENERIC_V8)
>     by kvm_arm_get_host_cpu_features
>   - "cortex-A72" fails to start (umm...)

...and fails on the A72 host.

> However ... if I haven't managed to confuse myself somewhere in here
> (which is completely possible), would it be OK if I submitted a set of
> patches that:
> - add a QEMU_KVM_ARM_TARGET_GENERIC_V8 to match the kernel one
> - set kvm_target for Cortex-A72 to QEMU_KVM_ARM_TARGET_GENERIC_V8

This would be wrong -- it would mean that you could tell QEMU "give
me a guest CPU that's a Cortex-A72" and it would not error on
non-A72 hardware but not actually give a guest CPU that looks
like a Cortex-A72.

 * If what you want is "give me something that works" then that's
   -cpu host or -cpu max.

 * If what you want is "give me something that's always this kind of
   CPU regardless of the host hardware" then that's a lot of kernel
   dev work nobody's been enthusiastic enough to undertake yet
   (notably the "what do we do about CPU errata workarounds" question
   would need to be solved...)

 * If what you want is "allow me to say '-cpu cortex-a72' and have
   it work on an A72 host and not anywhere else" then I guess we could
   implement that on the QEMU side by querying the MIDR and checking
   whether it was what we expected.

>   - alternatively drop the explicit settings for A57/A53

These explicit settings are correct, because for these CPUs
the kernel does have a "give me what I want in particular"
setting (which it will fail on the wrong h/w), and also as
back-compat for older kernels that predate the GENERIC_V8
define and only recognize the explicit "give me an A53" value.

> - drop the call from aarch64_max_initfn to aarch64_a57_initfn, and
>   copy the relevant bits into the former for the !kvm case

Not sure why you care about this -- it's an implementation
detail of the TCG handling of the 'max' CPU. There's an argument
for disentangling TCG 'max' so it's not literally implemented
as "a57 plus newer stuff", granted.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
