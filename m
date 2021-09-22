Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087F5C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 09:59:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77F2261279
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 09:59:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 77F2261279
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D65934B118;
	Thu, 23 Sep 2021 05:59:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D91eYE6TeUer; Thu, 23 Sep 2021 05:59:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB9004B0E2;
	Thu, 23 Sep 2021 05:59:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0254B0C2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 19:22:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ap-Dl1yx8HOs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 19:22:41 -0400 (EDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1A0C4B08D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 19:22:40 -0400 (EDT)
Received: by mail-lf1-f49.google.com with SMTP id z24so19057761lfu.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 16:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yk3ZBWr1n5IrjSyR0cfU0vmtzd7r3a9rIjQQ1A/kKAg=;
 b=NuR7toXGRAmohK70NQ8+rh5MJHstn1edKRlUfHuMXDCyh/4jiSX3eoOPwcCQ/kXAtp
 4A7I/88gBVm0lqRdfzTaYE1wlbXdh4rYxDFyknD6AFzjhHQ6LDk1gs/io20fIR77ePDz
 YSvMW6K8/GF67iYX/JNVaqv61sdTFh0CjFsf7ejKlOW5B60MtJHTA/5T+f6QRjB+LDYp
 vKcsz5hcy0/QWSI6eM5+toi/NprVxiGknAJ5HnHUlHtg9wTym7ppshn6n+3A6u6AX66L
 kFWq49gBQ0f6w7SGqF9Ay2WKEYF6wrgy+w3CF4arSV5qy+iReJ+qj4AwhbquLWAHlmy1
 64pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yk3ZBWr1n5IrjSyR0cfU0vmtzd7r3a9rIjQQ1A/kKAg=;
 b=mbCDb8MYq7MqlzUHDPK04xYtOk33Rrxhjomg5Ogw/mkqHuV0I6gKbKLVSpIqiSI1+r
 wfgflBWL+pFewaVZmg9F4vn04WJ3A8I+fQxdq3S+0PaAEGkGP2//msgCnu0lEC7gqKhs
 VZXqZK0GZxkuAE/D+FCJDDqa8i1QSjhzPIdX/5HSMsq0UOJIEV9POYQW2FN0PXuGaf5T
 AVtaHwOn/XUzgc7JnMJrdY4UlF0pHbJ5DOO47N+OUxBMaDT38d8j1IK0FZ+aIZiPE3L1
 z1vS2AGlD/7ex9LGkl5f2wRauGXjYWffkUtc6nQ038nSEr63e+QWRKdcpPlYHh8ZT3xX
 JRtw==
X-Gm-Message-State: AOAM531RF/JX5JeJaey6DD92wVPDujUsoDsnqHzdqLcm7mnfMpZEL781
 abPiaLYu+jjuiY+a6ohrR19ZTgeTEW/r5DxaQfkM1Q==
X-Google-Smtp-Source: ABdhPJzytAbhMPWX5aemlDWfYpMTXy90obCR37PCue90R2xsux+omJEqhaIYYSOZgMm9tzBFn5bjFgmBbMT77dy0a7Q=
X-Received: by 2002:a05:6512:3f91:: with SMTP id
 x17mr1463436lfa.518.1632352959485; 
 Wed, 22 Sep 2021 16:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
 <YUtyVEpMBityBBNl@google.com> <875yusv3vm.wl-maz@kernel.org>
In-Reply-To: <875yusv3vm.wl-maz@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 22 Sep 2021 16:22:12 -0700
Message-ID: <CALzav=cuzT=u6G0TCVZUfEgAKOCKTSCDE8x2v5qc-Gd_NL-pzg@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Thu, 23 Sep 2021 05:59:13 -0400
Cc: Aaron Lewis <aaronlewis@google.com>, KVM <kvm@vger.kernel.org>,
 Venkatesh Srinivas <venkateshs@google.com>, Peter Shier <pshier@google.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
 Jim Mattson <jmattson@google.com>
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

On Wed, Sep 22, 2021 at 11:53 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 22 Sep 2021 19:13:40 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
>
> > Stepping back a bit, this is one piece of the larger issue of how to
> > modernize KVM for hyperscale usage.  BPF and tracing are great when
> > the debugger has root access to the machine and can rerun the
> > failing workload at will.  They're useless for identifying trends
> > across large numbers of machines, triaging failures after the fact,
> > debugging performance issues with workloads that the debugger
> > doesn't have direct access to, etc...
>
> Which is why I suggested the use of trace points as kernel module
> hooks to perform whatever accounting you require. This would give you
> the same level of detail this series exposes.

How would a kernel module (or BPF program) get the data to userspace?
The KVM stats interface that Jing added requires KVM to know how to
get the data when handling the read() syscall.

>
> And I'm all for adding these hooks where it matters as long as they
> are not considered ABI and don't appear in /sys/debug/tracing (in
> general, no userspace visibility).
>
> The scheduler is a interesting example of this, as it exposes all sort
> of hooks for people to look under the hood. No user of the hook? No
> overhead, no additional memory used. I may have heard that Android
> makes heavy use of this.
>
> Because I'm pretty sure that whatever stat we expose, every cloud
> vendor will want their own variant, so we may just as well put the
> matter in their own hands.

I think this can be mitigated by requiring sufficient justification
when adding a new stat to KVM. There has to be a real use-case and it
has to be explained in the changelog. If a stat has a use-case for one
cloud provider, it will likely be useful to other cloud providers as
well.

>
> I also wouldn't discount BPF as a possibility. You could perfectly
> have permanent BPF programs running from the moment you boot the
> system, and use that to generate your histograms. This isn't necessary
> a one off, debug only solution.
>
> > Logging is a similar story, e.g. using _ratelimited() printk to aid
> > debug works well when there are a very limited number of VMs and
> > there is a human that can react to arbitrary kernel messages, but
> > it's basically useless when there are 10s or 100s of VMs and taking
> > action on a kernel message requires a prior knowledge of the
> > message.
>
> I'm not sure logging is remotely the same. For a start, the kernel
> should not log anything unless something has oopsed (and yes, I still
> have some bits to clean on the arm64 side). I'm not even sure what you
> would want to log. I'd like to understand the need here, because I
> feel like I'm missing something.
>
> > I'm certainly not expecting other people to solve our challenges,
> > and I fully appreciate that there are many KVM users that don't care
> > at all about scalability, but I'm hoping we can get the community at
> > large, and especially maintainers and reviewers, to also consider
> > at-scale use cases when designing, implementing, reviewing, etc...
>
> My take is that scalability has to go with flexibility. Anything that
> gets hardcoded will quickly become a burden: I definitely regret
> adding the current KVM trace points, as they don't show what I need,
> and I can't change them as they are ABI.

This brings up a good discussion topic: To what extent are the KVM
stats themselves an ABI? I don't think this is documented anywhere.
The API itself is completely dynamic and does not hardcode a list of
stats or metadata about them. Userspace has to read stats fd to see
what's there.

Fwiw we just deleted the lpages stat without any drama.




>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
