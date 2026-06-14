Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2572323C4E9
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 12:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781441918; cv=pass; b=jtobRwp/QSEF4+ibUm89FO8ToEDYfLb473y8VrAyrsH6KLk2iSb+jQfAyUdsV9R8X3nEuZR3bIgzIl8FBa4t3tgt7MLLO3Y5RiJ7v/+djj+4uP2zQSGczGVCTanj1alv4G/GeVr0mcu/LmXkvj2oku9wVKGSKak3nYHsLcXZ62U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781441918; c=relaxed/simple;
	bh=X9IOLQYqpbaTlV6dGXLSe4xn/xUdsqY8KxHeVo/ylUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=btA+fOBXMFL3Ule/vgLh9dqtAONsj66fB8KicfzOV/BVPrX968CVieC5jeitkgP4u59XGgdG513LWt0shqrE/W3Uy3KBIIVEVpbzlc7TrVsN39JBg+UKijUPoYJ5bcW5D1amuw5LrWcCCMpwWe9NFYrGxzoGZkmNJ7JFE+H8rGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hlMAa+c6; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hlMAa+c6"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5177d1ff061so511881cf.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 05:58:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781441916; cv=none;
        d=google.com; s=arc-20240605;
        b=CguVdvj6qH13C/eri3MQP0mS3TkGQCwcrkGoE/X+vHGQYHhvVkfCanvZXw2DafLpRf
         KCCNqWC5U8ZL77508Asq7BUqXNMdGhrqExv1z37K6/omkzByPBEDPqPfypxCuUFbXf+5
         G4GaY6buHZB9/X9KsNYnnqtCJ96zaL98nVpU6ESmykmsAgsZEpNrrFLWhnNGtw5Hj//D
         dM2vRiyOLpYFWbS7//QxMcDXWEuhxB8yrgAwu4SDy9C2qhZO3D3oEu/9vedo4P/LC5B+
         eD6yMH6XdvUhI3REGgs7Ot3y7Pd6LGPxlku+WFv6PhrIwDdLadvFAUcMGr0SgLckjp5H
         cZ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=raqXDfwkMXRUmW6TDGJbWsdyb8Rm1C9Uy9ah47adkoY=;
        fh=PSVbd6QS+Kk2VvBJtjd4HZA2a8C+oPuZiroj/GJTE54=;
        b=HRIHHpqQW4+Z/niCDmgZh/LsQPEIXuijK+I19y4rLlooCQE6b7Fel5/GGWi4DKM5Ma
         JHeAUXCDVo67d1rSHwMSPNMaFxH9L/UGxQsZnTX/ai3auwMAlhUyreXpNfZ1GnZSd+EP
         XCvxK6u8r8sPqUkHXpkzhnkNUNA4SoQaGW1sjp2T9fcvZiBBYU0uPXcQNs9Mi9unRm+Z
         6OaDILgj780Vif5cwFFeyD+XAuO2jMwcHRoXQ+p6E3QtrlLfSeF0qPgJln+/YHvZRJVt
         pQXQ25rCFmQZEGf5vAl+5IV99eXKIWtzmf5NCWVNj992p8GuDrCcr5ECN09U4TVWcgBf
         godw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781441916; x=1782046716; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=raqXDfwkMXRUmW6TDGJbWsdyb8Rm1C9Uy9ah47adkoY=;
        b=hlMAa+c69RjvQnfsxDfUxntBEFdRzoVpAqqNgUSPl00BpUAUN19Yu+QOaaka213oSr
         IShFJLPiKlodaJHYvUsAguh8M0nx8CuGT+d5/6HWlS5TQJG+n+enzhwAWF1qeus19TfE
         wJw+MgmfWAjzqossqS77NG18+AhGUKgqjQT2+l15jakAWi25ld+Osvt9+x38CgoTmwRA
         xHR8Rk5hVjhtxZFnExhDyDCTq7YvJq6Fziyd8Wc4AU1IS/tp/TRSWNd9kEAt7NvUfCcE
         zTENkybqVk+kb4Y0DWWxo9XqprHjZJ/D0xWZvVlnJ0yAoFvfLCb83SFwC3QuhT9vHbrd
         iZLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781441916; x=1782046716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=raqXDfwkMXRUmW6TDGJbWsdyb8Rm1C9Uy9ah47adkoY=;
        b=HIYHnICQpMTl2+d80N5lHwwA61y21oLUHf7mqED9w8so8ZLv25aT5wTZXG//hC14xG
         9ALS10DYcw9fNwT7mIdMURmXgYb8/ldHtTjHKZm2b0dPpFlWLFl1YM7nL6DdBQJOEJFU
         0k/r2dRxvzasHZ8yNi31HTU5G5bSem4tWw8cT1+dgB9hGgVxZi6kKq9P1Fl0nj9LzXlS
         xhLbRd8p5o5EmTV1MLEI/gbGxld1ZmAqtLW62yQ4JFAzwvZvI1xvKMGefVI4B37QLjxp
         ZqbKkRwEgLrErZdaHxSpRRFOlWi28eILIWO5+EQ6P9ZA9E/p+Gm1P9+q5uBPHX2i4rdP
         Vbow==
X-Forwarded-Encrypted: i=1; AFNElJ8pwm6N0XVFntxTx9k4CzEg8UYRYxycdXomprhGsGRR1WPHP0kRPU3rsmbePvR0BrLBIwdHyRU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxiMwbAIcF6nHAZpyviuLOIDsXTF97aXCETtQeFOTn/XCdDvnOi
	52C5qzjO601Ijm8LrR8S3IhTEnIYF1TOjWAQaI/nUGgODdZc+VBjf3uyMPzcrQNkWjVC4ku+d3E
	06YsGWFHan4dtuvL7XQh+xp4FaIbT0ZuWEiUiChAu
X-Gm-Gg: Acq92OEiZis49vtMYU7+5dycfnQrF4B1Hd2lRG0ccGCdebXf4NEen+x2TKt0Wfs+uBp
	qBdru2vgxJ1Jsd7g4JQwBMz9YfiqoCzc8jEXYS0BSzC1SeCcN9CzO9xAhewQZoP5HlqmGdpRq7B
	DIr83fICateVqxUVNttXOircoLHR6+F0O3mOYCUU7ff3iiqDN/LF3zkfRx+WPtUx2Ky5JUFyZyl
	/qN5567nJI4CRGUpl0KYMuoVviE0FA8O2WisYndXg+bQuePkCC1qxZuZvoFoYZ8Om/c+kyqSKIO
	uUcm5WvD
X-Received: by 2002:a05:622a:16:b0:516:4f62:85eb with SMTP id
 d75a77b69052e-51954a90335mr11763881cf.22.1781441914933; Sun, 14 Jun 2026
 05:58:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com>
In-Reply-To: <20260612142245.1015744-1-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 14 Jun 2026 13:57:56 +0100
X-Gm-Features: AVVi8CdMUSvMeQIM4Hqjh1XZ6PUpczBd7rfGCO8vFiVuNomXp3ysnwWL4HQmk6A
Message-ID: <CA+EHjTxditViT-yd+y-DZ8zM7dATVEpe8qWNGbugq6sL7KN+uw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, qerret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Hi all,
>
> This series adds a hypervisor event "hyp_printk" which enables
> developers to log pretty much anything into the hypervisor tracing
> buffer, just like the kernel function trace_printk().
>
> This enables rich logging from the hypervisor, while leaving all the
> string parsing burden to the kernel. This has been the main way of
> debugging pKVM in Android.

I tested the series on v7.1-rc7 under QEMU (cortex-a53 CPU, pKVM nVHE):
- Booted a host under pKVM with a non-protected kvmtool guest (npVM)
and a protected kvmtool guest (pVM).
- Functional test: added a temporary trace_hyp_printk() call site in
handle___kvm_vcpu_run() with 0-arg, 1-arg, and 2-arg calls. Mounted
tracefs, enabled the hyp_printk event, ran a kvmtool guest to trigger
vcpu_run, read the trace buffer. All expected entries appeared with
correctly formatted output.

One question: kvm_hyp_trace_init() returns early when
is_kernel_in_hyp_mode() is true. On VHE-capable hardware, pKVM uses
hVHE. So it seams that the entire hyp tracing subsystem (not just
hyp_printk) is non-functional in hVHE mode. Is hVHE support
intentionally deferred?

Cheers,
/fuad

>
> Even though not strictly related to trace_hyp_printk, I have added the
> following two patches:
>
>   * KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
>
>     This one mainly intends to support one of the new features I have
>     posted here [1], which allows to enable tracing as early as
>     possible. I have added it here to limit cross-posting.
>
>   * KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
>
>     This one is just a cleanup.
>
> [1] https://lore.kernel.org/all/20260605163825.1762953-1-vdonnefort@google.com/
>
> Vincent Donnefort (4):
>   KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
>   KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
>   tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
>   KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
>
>  arch/arm64/include/asm/kvm_asm.h              |  4 +-
>  arch/arm64/include/asm/kvm_hypevents.h        | 14 ++++
>  arch/arm64/include/asm/kvm_hyptrace.h         |  8 +++
>  arch/arm64/kernel/image-vars.h                |  1 +
>  arch/arm64/kernel/vmlinux.lds.S               |  4 ++
>  .../define_hypevents.h}                       |  0
>  .../kvm/hyp/include/nvhe/define_events.h      |  2 -
>  arch/arm64/kvm/hyp/include/nvhe/trace.h       | 65 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  2 +-
>  arch/arm64/kvm/hyp_trace.c                    | 60 ++++++++++++++++-
>  include/trace/define_remote_events.h          | 19 +++++-
>  12 files changed, 176 insertions(+), 9 deletions(-)
>  rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)
>
>
> base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
> --
> 2.54.0.1136.gdb2ca164c4-goog
>
