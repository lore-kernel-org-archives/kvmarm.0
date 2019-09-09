Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E61C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 12:33:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED97D20863
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 12:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DPcZzXq0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED97D20863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 629854A554;
	Mon,  9 Sep 2019 08:33:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cW1rIONncq27; Mon,  9 Sep 2019 08:33:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E12B4A4EB;
	Mon,  9 Sep 2019 08:33:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C2DA4A4EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 08:32:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6AFVHr+sJSaL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 08:32:58 -0400 (EDT)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A6DD4A4EA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 08:32:58 -0400 (EDT)
Received: by mail-oi1-f196.google.com with SMTP id z6so4807824oix.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Sep 2019 05:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=IIxHAy0QnMK1JeOi+9yFV5EQe5jacPRZgTyfcGLGtzw=;
 b=DPcZzXq0Fi8SYQC9n8cOe3Cgnc8n/fEiHxy+vnuJ9rC0l9KMr6wtq3XVugUCEZazO7
 8I/07g0aZrLtKD5N0FV1pDp7SUW/9I9S6zRNt92x/XBzNTc5EDV0+skY1huQyAg80Y01
 XTFUAnG2bmUEtMMAGtjdZLIaXPdnca+YYTKtuU4kPJpcMPDuy8pDoLzUabG1kjthryct
 9Zk9D89b4opo9mVMMgmVSlIjR1aU2kKbaWD6tTolfllWbpFI+NGpVQ1iXb6/s9LZYlUl
 G+H42UXEeS7/MYvhx41VHd7Qw8orLUsEpgZHpPSnzsYRggcU6oh3vvHf8NmoPKl7xHbQ
 DU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=IIxHAy0QnMK1JeOi+9yFV5EQe5jacPRZgTyfcGLGtzw=;
 b=iynehzo3aGHqfBOWiAA9mvm0w62EkUCK5m9YJZ7otHfILxHw6PMtJCORlUySRQVcXs
 hpTotTePOHZyKhjE4NCPu2AH6vi1k/8qx/UY97LF6mkPT/4Kp+6zec39iyyuyzWoI/bW
 VC2EXEi1vHhmgsCmaVx/D5RR9tSLK7ELC9OL4A2tjsfu84x7TOFB9fNWDOxyvK6yk4qP
 11z7PkJOFpE0Wa5WObJF8b6hHjW9rCZSvLdYYolGjgMBpnW5w1IBFVOcYm4YdNTw8gsp
 ncQ0I9osPOiJY+f5M83Y+sYzqeo9Q7FuhuMyVn0jurWRmb6TlHV/cc0t5l3OWbLaVWTP
 zfjg==
X-Gm-Message-State: APjAAAXs3rktm2vphI97UcTTLniwzFA8GCywTTlcs5odBKg54ZiJ1/J0
 MJGkLMjewz2KhWoFmmNfObBQ1Tq9kz0w0/rjyp/MbQ==
X-Google-Smtp-Source: APXvYqzB2IrJ3RRb0qlkq03of3InYNWVtBic1CpwBCxnfwEyJO1lx6vl3XeAkPqh/hnlOU4hQKAVlTIVJsgpGKbumBg=
X-Received: by 2002:aca:50d8:: with SMTP id e207mr16226748oib.48.1568032377654; 
 Mon, 09 Sep 2019 05:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190909121337.27287-1-christoffer.dall@arm.com>
 <20190909121337.27287-3-christoffer.dall@arm.com>
In-Reply-To: <20190909121337.27287-3-christoffer.dall@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 9 Sep 2019 13:32:46 +0100
Message-ID: <CAFEAcA8WcQNJV27q5WJ-SMhOyjFZyh1Pz7H7duK6zW1wiAvqKQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: Allow user injection of external data
 aborts
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Mon, 9 Sep 2019 at 13:13, Christoffer Dall <christoffer.dall@arm.com> wrote:
>
> In some scenarios, such as buggy guest or incorrect configuration of the
> VMM and firmware description data, userspace will detect a memory access
> to a portion of the IPA, which is not mapped to any MMIO region.
>
> For this purpose, the appropriate action is to inject an external abort
> to the guest.  The kernel already has functionality to inject an
> external abort, but we need to wire up a signal from user space that
> lets user space tell the kernel to do this.
>
> It turns out, we already have the set event functionality which we can
> perfectly reuse for this.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  Documentation/virt/kvm/api.txt    | 15 ++++++++++++++-
>  arch/arm/include/uapi/asm/kvm.h   |  3 ++-
>  arch/arm/kvm/guest.c              |  3 +++
>  arch/arm64/include/uapi/asm/kvm.h |  3 ++-
>  arch/arm64/kvm/guest.c            |  3 +++
>  arch/arm64/kvm/inject_fault.c     |  4 ++--
>  include/uapi/linux/kvm.h          |  1 +
>  virt/kvm/arm/arm.c                |  1 +
>  8 files changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 02501333f746..edd6cdc470ca 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -955,6 +955,8 @@ The following bits are defined in the flags field:
>
>  ARM/ARM64:
>
> +User space may need to inject several types of events to the guest.
> +
>  If the guest accesses a device that is being emulated by the host kernel in
>  such a way that a real device would generate a physical SError, KVM may make
>  a virtual SError pending for that VCPU. This system error interrupt remains
> @@ -989,12 +991,23 @@ Specifying exception.has_esr on a system that does not support it will return
>  -EINVAL. Setting anything other than the lower 24bits of exception.serror_esr
>  will return -EINVAL.
>
> +If the guest performed an access to I/O memory which could not be handled by
> +user space, for example because of missing instruction syndrome decode
> +information or because there is no device mapped at the accessed IPA, then
> +user space can ask the kernel to inject an external abort using the address
> +from the exiting fault on the VCPU. It is a programming error to set
> +ext_dabt_pending at the same time as any of the serror fields, or to set
> +ext_dabt_pending on an exit which was not either KVM_EXIT_MMIO or
> +KVM_EXIT_ARM_NISV. This feature is only available if the system supports
> +KVM_CAP_ARM_INJECT_EXT_DABT;
> +
>  struct kvm_vcpu_events {
>         struct {
>                 __u8 serror_pending;
>                 __u8 serror_has_esr;
> +               __u8 ext_dabt_pending;
>                 /* Align it to 8 bytes */
> -               __u8 pad[6];
> +               __u8 pad[5];
>                 __u64 serror_esr;
>         } exception;
>         __u32 reserved[12];

This API seems to be missing support for userspace to specify
whether the ESR_ELx for the guest should have the EA bit set
(and more generally other syndrome/fault status bits). I think
if we have an API for "KVM_EXIT_MMIO but the access failed"
then it should either (a) be architecture agnostic, since
pretty much any architecture might have a concept of "access
gave some bus-error-type failure" and it would be nice if userspace
didn't have to special case them all in arch-specific code,
or (b) have the same flexibility for specifying exactly what
kind of fault as the architecture does. This sort of seems to
fall between two stools. (My ideal for KVM_EXIT_MMIO faults
would be a generic API which included space for optional
arch-specific info, which for Arm would pretty much just be
the EA bit.)

As and when we support nested virtualization, any suggestions
on how this API would extend to support userspace saying
"deliver fault to guest EL1" vs "deliver fault to guest EL2" ?

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
