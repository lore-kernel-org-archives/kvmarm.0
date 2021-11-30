Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD74DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 00:56:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F0D4B1D3;
	Mon, 29 Nov 2021 19:56:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cxoPGUR59ovC; Mon, 29 Nov 2021 19:56:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F8EA4B1D4;
	Mon, 29 Nov 2021 19:56:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8252A4B1D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 19:56:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r7Kf8jej6vFj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 19:56:31 -0500 (EST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
 [209.85.219.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2E0E4B1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 19:56:31 -0500 (EST)
Received: by mail-yb1-f176.google.com with SMTP id d10so14589881ybn.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 16:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=UOe8xLQUrobMoVj2LWKph442G97MrEyMo1+66bK4AnQ=;
 b=FT/MMfw3Z54vvePSuoBM82z5aYziyJ/hw+1SBgZU0yVtGaJTzrybhgYZmrNnzFLo3S
 h1ZNfSAv80YX1nI8h2BzJ48K6jO1aRltwcZ11HlMyGTcRag/Z9NBeVIq0daLl0K4riY/
 73HMHtbeHN/Vi5qzYZaqp/YJ0aEYH1BiJ5ZF1yfQMhS9jY98+TmbeawNL5wWIDsBnWKH
 Kna9CLaKtQzBWsoNu+J1/qLfzlwM3mD7rlWp2yguoQm56fd/Y3jDBWDlsTjjxoLmdYfa
 ilfHm9gsyDYyzPYKguEaD6464dliwN9f8XdpIrxK/gp9bH27kGvA89yQATDVWbYTrAeD
 IBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=UOe8xLQUrobMoVj2LWKph442G97MrEyMo1+66bK4AnQ=;
 b=1qdYlUW4ZB8tPG/hZZy4kEFgO/82XzvlC7LNtW9kcD20F/yzuTzDFJFKqiFAMYRLaS
 0Uo9Ni19CWry/Ze6B2Iyy3g86YfB2j172w1F/iytb9TflYEEiZt7R2NVGBHsfku1aRyL
 5wr71j8757dSj5UQZQxOAvnXJWmn0ncP6//u2LMK6sFz6gnYqozx70o85oHoOtnOrqJA
 cKUYUiybrQGwKTx/7JQOeGloLJmE/RpEwadG6l7EL8kwBwXAv95ly4WE9PuwqwFQiIQW
 O81BANWJykU8pPDkTcHIuUJfX928EvE0h1eDInnYQOPZkcVpTy6F0qHa8G2y0moU5f/m
 NwKg==
X-Gm-Message-State: AOAM5339+1458bKj+VRuHXY5pDLIIR3TNZHWGYOlOCzHZrxhQYb3Z9C3
 unTD5NFxu9meZIvCEgEP6C2Zl+OU7k5gEThYHTkQ5g==
X-Google-Smtp-Source: ABdhPJzuNwYyFAs0/QDKiUFukkaFiCuy93y83TOBorW284YUYtixvHwu36tKkxWMLJVFO1mfNh44B4UeZy/NUZD8/V4=
X-Received: by 2002:a25:86c4:: with SMTP id y4mr39744643ybm.144.1638233790998; 
 Mon, 29 Nov 2021 16:56:30 -0800 (PST)
MIME-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-5-rananta@google.com>
 <87wnl0cdfn.wl-maz@kernel.org>
 <CAJHc60ydffBkqqb6xyObiK-66psaPODsOo0DpLFv7thx=zHjZw@mail.gmail.com>
 <20211127172720.zte6wfdguoyi3gd6@gator.home>
In-Reply-To: <20211127172720.zte6wfdguoyi3gd6@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 29 Nov 2021 16:56:19 -0800
Message-ID: <CAJHc60x=Egb=vRu1JHNK6f1ep+t+gDSKxJyfH88-w=v9pwsRsQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Sat, Nov 27, 2021 at 9:27 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Tue, Nov 23, 2021 at 10:34:23AM -0800, Raghavendra Rao Ananta wrote:
> > On Mon, Nov 22, 2021 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
> > > I keep being baffled by this. Why should we track the VMM accesses or
> > > the VMM writeback? This logic doesn't seem to bring anything useful as
> > > far as I can tell. All we need to ensure is that what is written to
> > > the pseudo-register is an acceptable subset of the previous value, and
> > > I cannot see why this can't be done at write-time.
> > >
> > > If you want to hide this behind a capability, fine (although my guts
> > > feeling is that we don't need that either). But I really want to be
> > > convinced about all this tracking.
> > >
> > The tracking of each owner register is necessary here to safe-guard
> > the possibility that the user-space may not be aware of a newly
> > introduced register, and hence, hasn't accessed it. If it had at least
> > read the register, but not write-back, we assume that the user-space
> > is happy with the configuration. But the fact that the register has
> > not even been read would state that user-space is unaware of the
> > existence of this new register. In such a case, if we don't sanitize
> > (clear all the bits) this register, the features will be exposed
> > unconditionally to the guest.
> >
> > The capability is introduced here to make sure that this new
> > infrastructure is backward compatible with old VMMs. If the VMMs don't
> > enable this capability, they are probably unaware of this, and this
> > will work as it always has- expose new services to the guest
> > unconditionally as and when they are introduced.
>
> Hi Raghavendra,
>
> I don't think we need a CAP that has to be enabled or to make any
> assumptions or policy decisions in the kernel. I think we just need to
> provide a bit more information to the VMM when it checks if KVM has the
> CAP. If KVM would tell the VMM how may pseudo registers there are, which
> can be done with the return value of the CAP, then the VMM code could be
> something like this
>
>   r = check_cap(KVM_CAP_ARM_HVC_FW_REG_BMAP);
>   if (r) {
>     num_regs = r;
>
>     for (idx = 0; idx < num_regs; ++idx) {
>       reg = hvc_fw_reg(idx);
>
>       if (idx > vmm_last_known_idx) {
>         ...
>       } else {
>         ...
>       }
>     }
>   }
>
> With this, the VMM is free to decide if it wants to clear all registers
> greater than the last index it was aware of or if it wants to let those
> registers just get exposed to the guest without knowing what's getting
> exposed. Along with documenting that by default everything gets exposed
> by KVM, which is the backwards compatible thing to do, then the VMM has
> been warned and given everything it needs to manage its guests.
>
Hi Andrew,

Thanks for your comments and suggestions!

I like the idea of sharing info via a read of the CAP, and not having
to explicitly sanitize/clear the registers before the guest begins to
run.
However the handshake is done over an API doc, which is a little
concerning. The user-space must remember and explicitly clear any new
register that it doesn't want to expose to the guest, while the
current approach does this automatically.
Any bug in VMM's implementation could be risky and unintentionally
expose features to the guest. What do you think?

> Another thing that might be nice is giving userspace control of how many
> pseudo registers show up in get-reg-list. In order to migrate from a host
> with a more recent KVM to a host with an older KVM[*] we should only
> expose the number of pseudo registers that the older host is aware of.
> The VMM would zero these registers out anyway, in order to be compatible
> for migration, but that's not enough when they also show up in the list
> (at least not with QEMU that aborts migration when the destination
> expects less registers than what get-reg-list provides)
>
> [*] This isn't a great idea, but it'd be nice if we can make it work,
> because users may want to rollback upgrades or, after migrating to a
> host with a newer kernel, they may want to migrate back to where they
> started.
>
Good point. But IIUC, if the user-space is able to communicate the
info that it's expecting a certain get-reg-list, do you think it can
handle it at its end too, rather than relying on the kernel to send a
list back?

My assumption was that VMM would statically maintain a known set of
registers that it wants to work with and are to be modified by hand,
rather than relying on get-reg-list. This could be the least common
set of registers that are present in all the host kernels (higher or
lower versions) of the migration fleet. This config doesn't change
even with get-reg-list declaring a new register as the features
exposed by it could still be untested. Although, migrating to a host
with a missing register shouldn't be possible in this setting, but if
it encounters the scenario, it should be able to avoid migration to
the host (similar to QEMU).

Please correct me if you think it's a false assumption to proceed with.

Regards,
Raghavendra

> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
