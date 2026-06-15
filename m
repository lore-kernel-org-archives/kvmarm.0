Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A0E27456
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 08:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781512281; cv=pass; b=X/KbZ11cB0iCuQDgVm8VgIGqpoij++vOlskOueSlwXtQxpirb65ahUDMgO3JmdMNPuNtr3UvFHoCwYT7tZk4s9dNArRimFmbLCzryfGd1op2jtsXncv2Bpzub5ERCjQi9PUPKKDvrPY5p7KlymXU14zgmh9JtEDA1RE8peImiK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781512281; c=relaxed/simple;
	bh=5IP8bvPpog1YppbO/dOuTzBrC0yjCRCsk+vSlFN/Hmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W3H39sUCui9hhJXFsPim7RM9oLYUw+TgN0xWEYL4xNLVes2Rxf/knIEnratInsDUIfrKEaihIHZLZfrBotoBW+/jr4PWhCZg8Qwl6n/JdCWXGdGfk7J32y/jfCt45UGaMnlIbU7p0q3IZxvW8I1oGzsx3R1IG1sNoG5Wl8nn66U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EbFtUyFN; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EbFtUyFN"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51765331535so860171cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 01:31:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781512278; cv=none;
        d=google.com; s=arc-20240605;
        b=XSECYb0AenvN1Qd34ugYXqP4Nn7ehJdVnAeBzuqZq67/+nmZtsZns6Th+JEiBjN5ee
         34YGKWHOPf0o36ZYs6QgUwktlsmikXegoE66o954ySHFTz82jyw7+tCfXeditAKWx6yC
         ccc7Tk+5x1+e9UVR9HJklCjO/+g4rGQpaR1tKZRpJosp4eHXlWRZSsYY8UFhig8xGo6w
         RteMOE9qHr/MmVbtxzWXOHVcDpDspLE9yjZkrBMAGddGOOwn1CGOMY4y8svOrl2onEYd
         /i2QeluHwOfk2g3faAMabA3ks2eu5WC7OT/twS0ZRZ4+LPp1ZI+fbSbyzbNfrZAbOKXk
         K8sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Lf5oSAywwuaj5Fh57ugeWpBI7UCwJcYNfPkenTc12XM=;
        fh=DqHJT908aFdzwLO+RmjEvRyWj0C05zrjO8uiDPyLjuw=;
        b=PiTiNAWMALvrHu7YRpoA2dTPi2lR7bLquVoP+PLlrqAJ5J1j84fFg6B/GY4miy87o+
         xcz+6t7tBZoBcOgDSWJwRAppyhxWfG/Ts2JcIvZByW5Mk6PkakYC45aMtYJxRvhCgB2g
         /wqE3OHrllDMJKRq+RyiK79QHgKdbVxNGSb6IORR//EZhXM+rXqSt0A1J4yBVbDEJ2nj
         AKYVKOhX93VHogiiCKbD43bxSOdRsKy64+f+a3Kk2NSGfU81IShdyqqRV8xdPzSoDZTt
         rdUvSLMH1Ul1GwYl7y+QexHWPjTZ1ZY+MnNPdlKgmlP0rM5J9mVFaItpxO5s6rsgzVqx
         2OVQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781512278; x=1782117078; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lf5oSAywwuaj5Fh57ugeWpBI7UCwJcYNfPkenTc12XM=;
        b=EbFtUyFNePD5UGUu9aIh3VeFi99EduODqf33z7mmhtjBYK8wIr3MotIwTwvS3Xr1kg
         /O4ux0+oOt0j/XDdFt1mb6kEXlxFnZGbkxb6UEjWum/Fjj+52zp3jemJS/wcG7cl6bbh
         cYKVt5iBhcMDAUrNWWdMiQZp5LcFwQPp8YjVs+2vyMIHHexy9BERl0PHlfEuOIPquJpN
         nEPdXsBX1oBTq5S4/irjheRjeWrK1F0aU/468tp0ScvoTn4sY1vV4ZnXBGwyJdLqm1Op
         eQVMDJdNvh2NW8vRjQ6O3/SD6fK11Fmakb+yZVSD3+9cfkmooZOr8PnlLGpT3cfWvFGZ
         gttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781512278; x=1782117078;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lf5oSAywwuaj5Fh57ugeWpBI7UCwJcYNfPkenTc12XM=;
        b=E+nEkfY+VjI7qTkzHKDL/TcRaqWFO5hZ4VlYUX6yFR5dceBUxngfPrp8QQmBOLhkhh
         tyElbcnt7IIol4KPXAUs1umgDiXbtf4mIqd3RZQpsEbwGHBPZBzVd+mYtYhUx+F3v4JQ
         z8Ac4j7O491VZRz9W1Xi0WrB2fgNu2w1DCUecsPIRbNmQc5VcEFk18kjYBfzwJoS9Or2
         MXqOstyDKhaxdp/z+SYs7+Gn5QDJbWsrJCXYcFrYxi/8tq5YHArFiCHF2kgKXEjNzBSE
         fE1iPQWYsHc9oqefvLPCCH9dBCJKXqAM9Z8Zpdg+Wj+LLhNtM71XAaSsDwL28Fm+sYNR
         ohnw==
X-Forwarded-Encrypted: i=1; AFNElJ85+XR7AMpqcp4TFfo8Uph5C9e5WoDEbespDKTsXTyZx4hOKsDG0uIcYeECrFJShKpSunsqNR8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw53YR5omwuZW7n2bUzNlZjxmR//J8ICgjuLbNOVE/nQhp7lev9
	U+Wc1wygZgTZGQfXHa9F1wHcOAA0pIITXoGNB8oL2l5yYJDEU0BAlnbd0itYJ5d/QpFBKBe5pow
	xboyLqJN110TVP509hVbg0o1VBzD4VIG8g5w5uYbg
X-Gm-Gg: Acq92OGRq2b78MWCXpkm6vMUT0j+SHSqPIAJBnxKUfvrqBP4BrWYqus1Ngz9kmdJQ6l
	ufHzgSiU0cMA9j2wjJIAr5xCXkQ2p7WOLFCISqGqQvNSjQDIxrl63PVxZ8PXd2rQQsnnFvxsD5C
	OWxlQFsR9qB7VhLoarNsE2uWVYe4prbiNwEcHaqzeqxxg5XuUtX4kIHxv7+YLYEioeJ+s+zw4G/
	nyRJqGd8jiTT059s+nU1Kyvg9yk+X1xpuXozd1R6bDcimfwBnjHuvkPm8EtB6x7PGSfSsyK43+P
	op3Qqcn0
X-Received: by 2002:a05:622a:259b:b0:517:99ea:ab7e with SMTP id
 d75a77b69052e-51954aa0119mr15764481cf.24.1781512277927; Mon, 15 Jun 2026
 01:31:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com>
 <CA+EHjTxditViT-yd+y-DZ8zM7dATVEpe8qWNGbugq6sL7KN+uw@mail.gmail.com> <ai-3ii1BtOPP25zZ@google.com>
In-Reply-To: <ai-3ii1BtOPP25zZ@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 09:30:40 +0100
X-Gm-Features: AVVi8CfOdOmbcJCI28yG7LXzWPtT8_aBQIv2i0hFe5aIhj1Gi5TsHAY_jSZdybc
Message-ID: <CA+EHjTxG8dK8o7GmoH9hg1p0h5W7H8EnNt1ZwRRXQcNad7R1pw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, qerret@google.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 09:28, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Sun, Jun 14, 2026 at 01:57:56PM +0100, Fuad Tabba wrote:
> > Hi Vincent,
> >
> > On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
> > >
> > > Hi all,
> > >
> > > This series adds a hypervisor event "hyp_printk" which enables
> > > developers to log pretty much anything into the hypervisor tracing
> > > buffer, just like the kernel function trace_printk().
> > >
> > > This enables rich logging from the hypervisor, while leaving all the
> > > string parsing burden to the kernel. This has been the main way of
> > > debugging pKVM in Android.
> >
> > I tested the series on v7.1-rc7 under QEMU (cortex-a53 CPU, pKVM nVHE):
> > - Booted a host under pKVM with a non-protected kvmtool guest (npVM)
> > and a protected kvmtool guest (pVM).
> > - Functional test: added a temporary trace_hyp_printk() call site in
> > handle___kvm_vcpu_run() with 0-arg, 1-arg, and 2-arg calls. Mounted
> > tracefs, enabled the hyp_printk event, ran a kvmtool guest to trigger
> > vcpu_run, read the trace buffer. All expected entries appeared with
> > correctly formatted output.
>
> Thanks for the testing!
>
> >
> > One question: kvm_hyp_trace_init() returns early when
> > is_kernel_in_hyp_mode() is true. On VHE-capable hardware, pKVM uses
> > hVHE. So it seams that the entire hyp tracing subsystem (not just
> > hyp_printk) is non-functional in hVHE mode. Is hVHE support
> > intentionally deferred?
>
> You got me scared for a moment but I did try hVHE and it seems alright:
>
>   [    5.369985] kvm [1]: Protected hVHE mode initialized successfully
>
>   $ ls /sys/kernel/tracing/remotes/hypervisor/
>
> is_kernel_in_hyp_mode() just checks if the kernel is running at EL2 which it
> shouldn't in the hVHE case?

I'll try again and report back, must be user error.

/fuad

>
> >
> > Cheers,
> > /fuad
> >
> > >
> > > Even though not strictly related to trace_hyp_printk, I have added the
> > > following two patches:
> > >
> > >   * KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
> > >
> > >     This one mainly intends to support one of the new features I have
> > >     posted here [1], which allows to enable tracing as early as
> > >     possible. I have added it here to limit cross-posting.
> > >
> > >   * KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
> > >
> > >     This one is just a cleanup.
> > >
> > > [1] https://lore.kernel.org/all/20260605163825.1762953-1-vdonnefort@google.com/
> > >
> > > Vincent Donnefort (4):
> > >   KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
> > >   KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
> > >   tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
> > >   KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
> > >
> > >  arch/arm64/include/asm/kvm_asm.h              |  4 +-
> > >  arch/arm64/include/asm/kvm_hypevents.h        | 14 ++++
> > >  arch/arm64/include/asm/kvm_hyptrace.h         |  8 +++
> > >  arch/arm64/kernel/image-vars.h                |  1 +
> > >  arch/arm64/kernel/vmlinux.lds.S               |  4 ++
> > >  .../define_hypevents.h}                       |  0
> > >  .../kvm/hyp/include/nvhe/define_events.h      |  2 -
> > >  arch/arm64/kvm/hyp/include/nvhe/trace.h       | 65 +++++++++++++++++++
> > >  arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  2 +-
> > >  arch/arm64/kvm/hyp_trace.c                    | 60 ++++++++++++++++-
> > >  include/trace/define_remote_events.h          | 19 +++++-
> > >  12 files changed, 176 insertions(+), 9 deletions(-)
> > >  rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)
> > >
> > >
> > > base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
> > > --
> > > 2.54.0.1136.gdb2ca164c4-goog
> > >
