Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31C53B6356
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781513867; cv=pass; b=DQOt2aeGyKKrwsprBhaPhTg1RstQvYl59PtMy0Iy9RW839XLPnTjHBgttEI0U/UVzb/XYgGhSR5mrGqyfe993731C8dlcBqdvHAlIqTxxM010oHN+wdwinUFgPt7uoWyWLIO21Lv3qVvEYfZxsz9fIvZIjAeWn8Ya5vlSXWIFVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781513867; c=relaxed/simple;
	bh=0stTS7KDPhGBCNH/7HvnS7eZ8Wjl6FSVE9WFjlAnpYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D2eEjXZW2SCTEXVSeZUazp+SZ6EVzh/hemQoFXeGjbqWpzlz65vJyG+b72XrN77C9WNCiuSbilfM2S+bi11Mk9AiZqGped/WySbWXUGol/9uaoKtnWE3bCs52GeOZNrK2dGTcoOY3cpeMg8As/Rh52FHW5hp9Y+AoqpTDNKTBOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hUnOvSdo; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hUnOvSdo"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5177d1ff061so9801cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 01:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781513865; cv=none;
        d=google.com; s=arc-20240605;
        b=kik/lS1WWiS5b5K5XansGRGP0o0w6hLLFZrJQj0nQ6gqzsQQxrM8z9Ber/dr4pBTXv
         8hA8mfED5fVLLQ6fhRr2v3YnB4CQ6yBCg0nzZsnT6OX//X4IKoIAt8vs/GGaTtH7D+Mf
         TRdh7ZDWMelQCqNfQY8oWkNu5EuJZa7g1irM6oB5vvQfSZDIrWrAHG2Rre5IP/jZX6Ha
         AzJlW8XpbyzlqhXxMHvsCG2UQw4+KMQcGerB9Fi7UgBo7jPi/UnQvZ96HSU4/5225M3K
         47GxdhHYkbU6YOaHBHBG9g0eK2SbhZy2NLqQTcPgXhnPxiiy5YOCw/2J4u5lkZFn6lc6
         KCnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=w0YvRC2XyG3/0ftsAtYxtYAMsDCEsoQr81DmullkijE=;
        fh=c2IL97v0JZXGhO36KSm9mxMPdnEIk4dnVZSb5n2vi+0=;
        b=MO5Uh7vteGT3b/uyiT6TRkPCD5sYMr0NUrRl6DX2a7niI5MAteTlCUhalMfMxc6wlz
         rztN/cl43GstuhR5ChZ+3jvUWMoGBRIVidzI3jSkUghv77ptHbnf46N7oIHqJoUKRoY9
         8ONzItid98clzWxjULpDP7xo3slfI7j0BmUYJtqr6NwWNGdKsuVC/YQKSNWKz9g92nmw
         aHJGT//Hua+86Y5hUBlQ1pIX5Iy7bbTw31Aboy2Yiq3GB2OUm29qvpVphHKzjb+DcMzh
         QFal4jAapSs5EqcbX6w/Q+S9k8436CuWpEsXK/zlZa8w4Ychd6NjZwdNQbXTfPZO876C
         rWKA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781513865; x=1782118665; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w0YvRC2XyG3/0ftsAtYxtYAMsDCEsoQr81DmullkijE=;
        b=hUnOvSdoN3SG75byUsJmkhAu5/iuGzGzSvuemZutxHP9f2GXT5ILSo6FoL2Z+vVCbc
         fUD0gTHPRC0PVGoPbu1dk90UbwxP7ZP3LIQfgIdAg4AA5DpY4RwgodDG2BrzKIwmTzxj
         xNaxXvegR0wRVJ7BsxQJlfJxuFk+pNJpvZ7lKVifnmqo8qDnyr4Poopd2H5cVVlmobLF
         5thj0jaUWkO0Dc+SAMyxBkHbqyjNLZaS45GTknn7lKR7lHQsZ3lxDY0cQLDBp1ayBfOt
         bFmclpCiNWxVWxylQ4J7ePfaEpU9r7ZVrQAUoRWQK7WqyzTAOVEJlOhRNutuDTkfurbV
         xjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781513865; x=1782118665;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w0YvRC2XyG3/0ftsAtYxtYAMsDCEsoQr81DmullkijE=;
        b=fmYo9cyNkugw0rIyVZSV9R6whzrxyy09WG58VDalU/VQOtyLZR3PSDF9bRrGtPGnpA
         GFSwVHMgusLzM/eB2mhO2Avwv8+36ddQA8P9QF7UxohUFWyTVskThzjnPAkxzAxFKgJ7
         vxeGIli+a35mAzeS/Vo68zqQ0Vc5Gz7pSrzLCosBhc1cCYgYA/1uh5GP0/Z9v5oxw4bR
         F2WgE/HotGNP2FfEz5RJJgApDC2ZOv8X08R1y5LFHXuDzXIFwzBArQSRNezbJINLTQTH
         KgfLEsuH8HBWv55+EhkWdH3PvmYa+XbSz3OgRLrnruX9fNPhxx4KwCpioDzXbno1+9M3
         OxDg==
X-Forwarded-Encrypted: i=1; AFNElJ89vhVvDAGu7aHaODr4Bs3R3LPR1KRwDhWdArhfUDiVySTWx1IKh4syNAD1QVmG90qUGFBv5Z4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWfvjPuOFE0JVlqUyakVEHZULcitnh/D7ADmOYpwyj9FC4NVzo
	2El8R8N3/Rr7j3TcwpSUKuD717+O4C3MYQJip5UL4/fB1fxmiGnb6I/RKJTgsYiBRYsojNhoW11
	I57D9TlRgYVrwQbxzJLb6UpP4+qwylJRGY3I1qbOM
X-Gm-Gg: Acq92OHT36ZpmEcMzS/yJj25GCniIjT871Sn8CihOrTHAMRdsr2HZP8zSY//vmRGQB3
	iS15wnyUBssQ6J/iHdVaMUwosbuyM5zNGfng9PkgfIvAn5qv577SFQadH/u0QELH04mgu7NknTL
	8Oo9E1zkszTF4i43+4R8T6Re4FrvAYX+MGkBRGdgXr7UxQhSAcCbby8k/Kui8TASkqiaSVXJIHH
	cmKD0uXso+ipNtZ4VovpwauXy7FHcfaXVIUMqSEr6ldixT7idBuzdtVQkVmFWPuhAKpPBZ3uPgs
	p/w0AGT1kIPgJv3nquI=
X-Received: by 2002:a05:622a:4a16:b0:516:3def:1cf4 with SMTP id
 d75a77b69052e-51955e0312dmr16071311cf.1.1781513864113; Mon, 15 Jun 2026
 01:57:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com>
 <CA+EHjTxditViT-yd+y-DZ8zM7dATVEpe8qWNGbugq6sL7KN+uw@mail.gmail.com>
 <ai-3ii1BtOPP25zZ@google.com> <CA+EHjTxG8dK8o7GmoH9hg1p0h5W7H8EnNt1ZwRRXQcNad7R1pw@mail.gmail.com>
In-Reply-To: <CA+EHjTxG8dK8o7GmoH9hg1p0h5W7H8EnNt1ZwRRXQcNad7R1pw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 09:57:00 +0100
X-Gm-Features: AVVi8CfkmZN27j_F1CgpJ6v5jI0GcIRXaBXtp0X3wAEEeteL-dHCDhXfvrkFdCU
Message-ID: <CA+EHjTyh5nTFVyEZLNgkNYCQp1a2g0B-o6W-m5FsVZd1X0MZhg@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, qerret@google.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 09:30, Fuad Tabba <tabba@google.com> wrote:
>
> On Mon, 15 Jun 2026 at 09:28, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > On Sun, Jun 14, 2026 at 01:57:56PM +0100, Fuad Tabba wrote:
> > > Hi Vincent,
> > >
> > > On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
> > > >
> > > > Hi all,
> > > >
> > > > This series adds a hypervisor event "hyp_printk" which enables
> > > > developers to log pretty much anything into the hypervisor tracing
> > > > buffer, just like the kernel function trace_printk().
> > > >
> > > > This enables rich logging from the hypervisor, while leaving all the
> > > > string parsing burden to the kernel. This has been the main way of
> > > > debugging pKVM in Android.
> > >
> > > I tested the series on v7.1-rc7 under QEMU (cortex-a53 CPU, pKVM nVHE):
> > > - Booted a host under pKVM with a non-protected kvmtool guest (npVM)
> > > and a protected kvmtool guest (pVM).
> > > - Functional test: added a temporary trace_hyp_printk() call site in
> > > handle___kvm_vcpu_run() with 0-arg, 1-arg, and 2-arg calls. Mounted
> > > tracefs, enabled the hyp_printk event, ran a kvmtool guest to trigger
> > > vcpu_run, read the trace buffer. All expected entries appeared with
> > > correctly formatted output.
> >
> > Thanks for the testing!
> >
> > >
> > > One question: kvm_hyp_trace_init() returns early when
> > > is_kernel_in_hyp_mode() is true. On VHE-capable hardware, pKVM uses
> > > hVHE. So it seams that the entire hyp tracing subsystem (not just
> > > hyp_printk) is non-functional in hVHE mode. Is hVHE support
> > > intentionally deferred?
> >
> > You got me scared for a moment but I did try hVHE and it seems alright:
> >
> >   [    5.369985] kvm [1]: Protected hVHE mode initialized successfully
> >
> >   $ ls /sys/kernel/tracing/remotes/hypervisor/
> >
> > is_kernel_in_hyp_mode() just checks if the kernel is running at EL2 which it
> > shouldn't in the hVHE case?
>
> I'll try again and report back, must be user error.

Confirmed, user error. I must have messed something up with the hVHE test.

My Tested-by for the series covers that now too.

Sorry for the noise.
/fuad
>
> /fuad
>
> >
> > >
> > > Cheers,
> > > /fuad
> > >
> > > >
> > > > Even though not strictly related to trace_hyp_printk, I have added the
> > > > following two patches:
> > > >
> > > >   * KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
> > > >
> > > >     This one mainly intends to support one of the new features I have
> > > >     posted here [1], which allows to enable tracing as early as
> > > >     possible. I have added it here to limit cross-posting.
> > > >
> > > >   * KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
> > > >
> > > >     This one is just a cleanup.
> > > >
> > > > [1] https://lore.kernel.org/all/20260605163825.1762953-1-vdonnefort@google.com/
> > > >
> > > > Vincent Donnefort (4):
> > > >   KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
> > > >   KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
> > > >   tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
> > > >   KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
> > > >
> > > >  arch/arm64/include/asm/kvm_asm.h              |  4 +-
> > > >  arch/arm64/include/asm/kvm_hypevents.h        | 14 ++++
> > > >  arch/arm64/include/asm/kvm_hyptrace.h         |  8 +++
> > > >  arch/arm64/kernel/image-vars.h                |  1 +
> > > >  arch/arm64/kernel/vmlinux.lds.S               |  4 ++
> > > >  .../define_hypevents.h}                       |  0
> > > >  .../kvm/hyp/include/nvhe/define_events.h      |  2 -
> > > >  arch/arm64/kvm/hyp/include/nvhe/trace.h       | 65 +++++++++++++++++++
> > > >  arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
> > > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  2 +-
> > > >  arch/arm64/kvm/hyp_trace.c                    | 60 ++++++++++++++++-
> > > >  include/trace/define_remote_events.h          | 19 +++++-
> > > >  12 files changed, 176 insertions(+), 9 deletions(-)
> > > >  rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)
> > > >
> > > >
> > > > base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
> > > > --
> > > > 2.54.0.1136.gdb2ca164c4-goog
> > > >
