Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD133C4169
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 08:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781512084; cv=none; b=jTJ9wNaEr0gS9vYKPvYsKvfe0druNTszNb2MaqDn9R1KhCpu5oJG6c6kTmhSsv3psFjk8NY1MkTH1a44Olc3PX90tiFO+6OzUN9CMqkDVQvoq2X1sTc6dhVRZvnup9Usfwoyu0pltvFzNXaSdQYxg7CdoIi0R9tIKfj8sWNiYTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781512084; c=relaxed/simple;
	bh=gfGduFrELxB1Sp5ZZf5aSCZiDd13gs/myAbd/xXnlCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uojUyhhB1AzgcerUklv2iENIhNvxoB/VBG2kNr8Ax+H4tQ8By1LrfjGHKdnsSznjbeSitD6eln4Te1a5+Eb4zL1VJQw8Lm1jUoUrQkeLvJK9paOSiWkeEnfGQ7uCS96B1wj25cX+AWuU+JKdsHw7R7dDQbd2ZmfJ3tvhd64/Pb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e3A04UWL; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e3A04UWL"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-68b90fc6a1dso5918643a12.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 01:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781512080; x=1782116880; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nACpjvzcAjptbYO/D+EZnxCKpAsH5nEmPSKqPy+CCm8=;
        b=e3A04UWL4qU1VV5oxntxceF2chJIkfFnSeGpRjI8DCNyVnQyE2P3x2mJNP2Pi7GMqm
         yGTJ4vBjX2BdS8yCJFxkqy4jqQULSNMmoOliW1Ww8T1UmNnfLSiEUgQ139W26UlRWEJ/
         aPB0Rqo/8t7sIkw5oQKPzGLb3AgRSzk0qWr9qJH/fuKVwR1BGpc9STvZL9hrh4Msz6im
         AmgNEQ0JPrJIbP6tqslAYwXUntm3kuZqmrLqPIGL4eOljHONvGBCPMDqYO46TpMG5bpv
         Xx0ZKrADa8s0kvZUeOYxeAWqMeh68V8sWAuE9mpg4MOYx5U+7Ij2RHU//Xb+bzmWbqL9
         cURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781512080; x=1782116880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nACpjvzcAjptbYO/D+EZnxCKpAsH5nEmPSKqPy+CCm8=;
        b=bB0ilNz0zKMu0m3waYoXlIFSF4kBcVT6PfB8jJZL0ZnBDpNeI8515kLa6hVsqjUWDd
         kl/opYZFk4Z67jZfy06QQSnRjp8xGrexHgoHMKpoHbR/SD+pShO2oQRqO1o4vEo9gazp
         FySw/AKu79lRlDoto7dvB0CTu/yafhD7a8UPeEVJfzrSUF37uYVaYSrGD6tO1M9Jlszq
         f5azHOmzO2gEpPSLrSDYF7H6aV+8ymetY1FvUGMSi8mCW7MM/aqO5u8WBu8WusHxkwS4
         MtVvHdXu8+30Fl/6m8W94FeYodL5vv8jNed1Cc7ZJQA8UffwOZLdFhf+7JhoteAsB/8w
         zCnw==
X-Forwarded-Encrypted: i=1; AFNElJ/rU7LXMP1vRTgnIA0g67RWxmgv9hw3kMitF+9n4KSSjMUl5NYLzRmFjkF1dDWtx+Xg1U0mJCc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBhlfrTIwIkOsrt9IwXsz2pyssr6AgKcG817erA1f85xy+z0nD
	aFVftqOgwZk+qMKOV8m2QFFAfzRu3V/+OuYXdpfhoEyJ4NN/c0B7lIEWaNiV+Bvuug==
X-Gm-Gg: Acq92OETqbW8C8O0TYjyaeOnuoKkRTNDbhDlJ8rJo1MS9G+2OPRJehQjoS0LuoznsGl
	c8L1H9izXS9knOrjYCW8251dzkdSbeVj4fsZl4qTuhLsLAWONE1PsQiB2ruYwVWk9Hl5USkuU0Q
	xpIbx/w71HajMoaz63/RXRI7PdBCWNYsEgXgl8WSds8VzWY9IzynUVEcYCvbRjLmGpV5xhvEgxW
	6cFAXeK7Y2VCmcF6EpDwGVBMbXnu9TYjCm95ri6T7YKbMBlhJU8+jFoUUGeo6slkmChulweZHf0
	LhMzwtLwl+NyhrXa+yAJKNcpvzJ2Q++Ii2kYFSwwXYe75fa89AvlwUl4LAONaorxYExI4WtrpaX
	uamgcqG+q99f7F6S1B1lJ451Pp+sqyXF8pwpwUeMJSthpV8WuoSR1XRBw1sQvZ54h099Vz/D/es
	Vt2Xvw4nLMiwxasOHDlhsLwKa8TK/JOCIm+ToHJgqu+V8Xlf1HCgTi/o9199fgGYmTrWo=
X-Received: by 2002:a17:907:9493:b0:bef:87ca:aec3 with SMTP id a640c23a62f3a-bfde279852bmr603924966b.9.1781512079604;
        Mon, 15 Jun 2026 01:27:59 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb4423439sm416285666b.2.2026.06.15.01.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 01:27:58 -0700 (PDT)
Date: Mon, 15 Jun 2026 09:27:54 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, rostedt@goodmis.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qerret@google.com
Subject: Re: [PATCH v1 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
Message-ID: <ai-3ii1BtOPP25zZ@google.com>
References: <20260612142245.1015744-1-vdonnefort@google.com>
 <CA+EHjTxditViT-yd+y-DZ8zM7dATVEpe8qWNGbugq6sL7KN+uw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxditViT-yd+y-DZ8zM7dATVEpe8qWNGbugq6sL7KN+uw@mail.gmail.com>

On Sun, Jun 14, 2026 at 01:57:56PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > Hi all,
> >
> > This series adds a hypervisor event "hyp_printk" which enables
> > developers to log pretty much anything into the hypervisor tracing
> > buffer, just like the kernel function trace_printk().
> >
> > This enables rich logging from the hypervisor, while leaving all the
> > string parsing burden to the kernel. This has been the main way of
> > debugging pKVM in Android.
> 
> I tested the series on v7.1-rc7 under QEMU (cortex-a53 CPU, pKVM nVHE):
> - Booted a host under pKVM with a non-protected kvmtool guest (npVM)
> and a protected kvmtool guest (pVM).
> - Functional test: added a temporary trace_hyp_printk() call site in
> handle___kvm_vcpu_run() with 0-arg, 1-arg, and 2-arg calls. Mounted
> tracefs, enabled the hyp_printk event, ran a kvmtool guest to trigger
> vcpu_run, read the trace buffer. All expected entries appeared with
> correctly formatted output.

Thanks for the testing!

> 
> One question: kvm_hyp_trace_init() returns early when
> is_kernel_in_hyp_mode() is true. On VHE-capable hardware, pKVM uses
> hVHE. So it seams that the entire hyp tracing subsystem (not just
> hyp_printk) is non-functional in hVHE mode. Is hVHE support
> intentionally deferred?

You got me scared for a moment but I did try hVHE and it seems alright:

  [    5.369985] kvm [1]: Protected hVHE mode initialized successfully

  $ ls /sys/kernel/tracing/remotes/hypervisor/

is_kernel_in_hyp_mode() just checks if the kernel is running at EL2 which it
shouldn't in the hVHE case?

> 
> Cheers,
> /fuad
> 
> >
> > Even though not strictly related to trace_hyp_printk, I have added the
> > following two patches:
> >
> >   * KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
> >
> >     This one mainly intends to support one of the new features I have
> >     posted here [1], which allows to enable tracing as early as
> >     possible. I have added it here to limit cross-posting.
> >
> >   * KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
> >
> >     This one is just a cleanup.
> >
> > [1] https://lore.kernel.org/all/20260605163825.1762953-1-vdonnefort@google.com/
> >
> > Vincent Donnefort (4):
> >   KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
> >   KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
> >   tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
> >   KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp
> >
> >  arch/arm64/include/asm/kvm_asm.h              |  4 +-
> >  arch/arm64/include/asm/kvm_hypevents.h        | 14 ++++
> >  arch/arm64/include/asm/kvm_hyptrace.h         |  8 +++
> >  arch/arm64/kernel/image-vars.h                |  1 +
> >  arch/arm64/kernel/vmlinux.lds.S               |  4 ++
> >  .../define_hypevents.h}                       |  0
> >  .../kvm/hyp/include/nvhe/define_events.h      |  2 -
> >  arch/arm64/kvm/hyp/include/nvhe/trace.h       | 65 +++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  2 +-
> >  arch/arm64/kvm/hyp_trace.c                    | 60 ++++++++++++++++-
> >  include/trace/define_remote_events.h          | 19 +++++-
> >  12 files changed, 176 insertions(+), 9 deletions(-)
> >  rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)
> >
> >
> > base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
