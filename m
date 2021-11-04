Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8AAC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 14:29:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3090661053
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 14:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3090661053
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DFBE4B192;
	Thu,  4 Nov 2021 10:29:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bryvindThva0; Thu,  4 Nov 2021 10:29:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E92184B188;
	Thu,  4 Nov 2021 10:29:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 855E04B168
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 05:11:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZsV+jolPzme8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 05:11:08 -0400 (EDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
 [209.85.208.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3DD94B135
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 05:11:07 -0400 (EDT)
Received: by mail-lj1-f176.google.com with SMTP id g3so8352915ljm.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 02:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ip4jIKzplcPRjOqExcXRBQqPqAPXrq235jk6EqfK8sA=;
 b=Ajj9xGu0eMeaOm/pl+F3O4w34Y56ucIS1YivaQBUsztCkIODJSzEomzA8LyYwWDhIv
 gL4GafSII/OrRNlmeVnclC/zVYk+T//wrPlyD/ksgrxvgeA82um0lcBr8G4qDc3xCJsQ
 HpK4IiT/8yrDHY95CZO0fe4r0yALgFqeTpFBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ip4jIKzplcPRjOqExcXRBQqPqAPXrq235jk6EqfK8sA=;
 b=wsevPuIGE4YkqBwRGsKvIp/oPfhxfEdkF6h6WkAYAeQOI62bFwk940AV/2WC1zVjQe
 UiRagJXA9vVeFJoKdOU/ULGZ5onyVCKUat3hK1NS/o6aKQaf35cr9KTR+sPvVvUVKjm+
 rZXkEDr4SeM+WCbdmDiLkOZ2kO6sKKX9h2UJ7RyDWKfyzd6g/AgoxqComrPJ+LAE+p86
 uPbaN/AbQyBI0SFTxhJmnVx6t7TB4kLQczNVOeSqjZgKvABRD8bQ2yaSVq5ZzDmSr1fP
 4nqwXv523YVAwjqDzc37ojyVYI7LlgakTWbO5/uTQdqbGV9lUToEL5UP6xdpN2ItGLK8
 AZyw==
X-Gm-Message-State: AOAM530hDsLKja9fKv4DCLl7TjOowOXebDg/7yWQbjMuT3OHgC0qGfCz
 cZ/XezV+dxU4KVcVuCNuRvLYfIOlrSZ63mus1JWHlA==
X-Google-Smtp-Source: ABdhPJy8fhKodASuD5SKo5rDH8OmLdPRdEwIa15ljtPKQs6a7cExLx0VBmUmWvEB+7WHB09t29utQs4L5T2n+YQsf8E=
X-Received: by 2002:a2e:b5d2:: with SMTP id g18mr18870481ljn.282.1636017066544; 
 Thu, 04 Nov 2021 02:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211020120431.776494-1-hikalium@chromium.org>
 <874k9bdcrk.wl-maz@kernel.org>
In-Reply-To: <874k9bdcrk.wl-maz@kernel.org>
From: Hikaru Nishida <hikalium@chromium.org>
Date: Thu, 4 Nov 2021 18:10:55 +0900
Message-ID: <CACTzKb+vVU0Ymh2Nx5B6kSydBsJ6AgrbQMF39RFvqoHpvL_riw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/5] x86/kvm: Virtual suspend time injection support
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Thu, 04 Nov 2021 10:29:12 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 senozhatsky@google.com, will@kernel.org, Ingo Molnar <mingo@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Jonathan Corbet <corbet@lwn.net>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, mlevitsk@redhat.com,
 Ingo Molnar <mingo@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
 suleiman@google.com, linux@roeck-us.net, John Stultz <john.stultz@linaro.org>,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, dme@dme.org,
 Lai Jiangshan <laijs@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Andy Lutomirski <luto@kernel.org>, tglx@linutronix.de,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Stephen Boyd <sboyd@kernel.org>,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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

Hi Marc,

Thanks for the comments! (Sorry for the late reply)

On Wed, Oct 20, 2021 at 10:52 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Hikaru,
>
> On Wed, 20 Oct 2021 13:04:25 +0100,
> Hikaru Nishida <hikalium@chromium.org> wrote:
> >
> >
> > Hi,
> >
> > This patch series adds virtual suspend time injection support to KVM.
> > It is an updated version of the following series:
> > v2:
> > https://lore.kernel.org/kvm/20210806100710.2425336-1-hikalium@chromium.org/
> > v1:
> > https://lore.kernel.org/kvm/20210426090644.2218834-1-hikalium@chromium.org/
> >
> > Please take a look again.
> >
> > To kvm/arm64 folks:
> > I'm going to implement this mechanism to ARM64 as well but not
> > sure which function should be used to make an IRQ (like kvm_apic_set_irq
> > in x86) and if it is okay to use kvm_gfn_to_hva_cache /
> > kvm_write_guest_cached for sharing the suspend duration.
>
> Before we discuss interrupt injection, I want to understand what this
> is doing, and how this is doing it. And more precisely, I want to find
> out how you solve the various problems described by Thomas here [1].

The problems described by Thomas in the thread was:
- User space or kernel space can observe the stale timestamp before
the adjustment
  - Moving CLOCK_MONOTONIC forward will trigger all sorts of timeouts,
watchdogs, etc...
- The last attempt to make CLOCK_MONOTONIC behave like CLOCK_BOOTTIME
was reverted within 3 weeks. a3ed0e4393d6 ("Revert: Unify
CLOCK_MONOTONIC and CLOCK_BOOTTIME")
  - CLOCK_MONOTONIC correctness (stops during the suspend) should be maintained.

I agree with the points above. And, the current CLOCK_MONOTONIC
behavior in the KVM guest is not aligned with the statements above.
(it advances during the host's suspension.)
This causes the problems described above (triggering watchdog
timeouts, etc...) so my patches are going to fix this by 2 steps
roughly:
1. Stopping the guest's clocks during the host's suspension
2. Adjusting CLOCK_BOOTTIME later
This will make the clocks behave like the host does, not making
CLOCK_MONOTONIC behave like CLOCK_BOOTTIME.

First one is a bit tricky since the guest can use a timestamp counter
in each CPUs (TSC in x86) and we need to adjust it without stale
values are observed by the guest kernel to prevent rewinding of
CLOCK_MONOTONIC (which is our top priority to make the kernel happy).
To achieve this, my patch adjusts TSCs (and a kvm-clock) before the
first vcpu runs of each vcpus after the resume.

Second one is relatively safe: since jumping CLOCK_BOOTTIME forward
can happen even before my patches when suspend/resume happens, and
that will not break the monotonicity of the clocks, we can do that
through IRQ.

[1] shows the flow of the adjustment logic, and [2] shows how the
clocks behave in the guest and the host before/after my patches.
The numbers on each step in [1] corresponds to the timing shown in [2].
The left side of [2] is showing the behavior of the clocks before the
patches, and the right side shows after the patches. Also, upper
charts show the guest clocks, and bottom charts are host clocks.

Before the patches(left side), CLOCK_MONOTONIC seems to be jumped from
the guest's perspective after the host's suspension. As Thomas says,
large jumps of CLOCK_MONOTONIC may lead to watchdog timeouts and other
bad things that we want to avoid.
With the patches(right side), both clocks will be adjusted (t=4,5) as
if they are stopped during the suspension. This adjustment is done by
the host side and invisible to the guest since it is done before the
first vcpu run after the resume. After that, CLOCK_BOOTTIME will be
adjusted from the guest side, triggered by the IRQ sent from the host.

[1]: https://hikalium.com/files/kvm_virt_suspend_time_seq.png
[2]: https://hikalium.com/files/kvm_virt_suspend_time_clocks.png


>
> Assuming you solve these, you should model the guest memory access
> similarly to what we do for stolen time. As for injecting an
> interrupt, why can't this be a userspace thing?

Since CLOCK_BOOTTIME is calculated by adding a gap
(tk->monotonic_to_boot) to CLOCK_MONOTONIC, and there are no way to
change the value from the outside of the guest kernel, we should
implement some mechanism in the kernel to adjust it.
(Actually, I tried to add a sysfs interface to modify the gap [3], but
I learned that that is not a good idea...)

[3]: https://lore.kernel.org/lkml/87eehoax14.fsf@nanos.tec.linutronix.de/

Thank you,

Hikaru Nishida

>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/all/871r557jls.ffs@tglx
>
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
