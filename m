Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A68AC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 18:05:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD5C661A2F
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 18:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BD5C661A2F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1739C4B099;
	Thu, 30 Sep 2021 14:05:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id es9+iEdXnTem; Thu, 30 Sep 2021 14:05:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CEDC4B0B6;
	Thu, 30 Sep 2021 14:05:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A28004A3BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 14:05:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mWQ7dGnQBbui for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 14:05:53 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3949549F5F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 14:05:53 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id oj16so1493154pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 11:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=YuOwAQkWjXznFXi6rLlMpeEj3pgnoZUS9VAR7tSyz6I=;
 b=YrTTbAhpXtued6yk9uC6PVSQ+GtYLJbkKmrVpJPwt3QklBL2b+uNE8TXilaT/DYofo
 5Ie58IWMhHlTNlQUvr7bSKpZ4Aa9nSPeW3uWcc/UuVk0lQbxlk3eJ11vqlcKtW19ePN7
 lchqwiACnk5e+wUAyBPi+5vGCjBm/OxlsGLpIycw3GkLAK09z9PlzZoJEmx1oQEM6dV1
 19E/sIT5irQ0E7EzW6WXQe0lQ1D3N+hdvAy2L6Bgmic7wWu17g+KtGSqKjf5bqbqS3w5
 XlqGr/D7HrR5xosTtqV7kalARiXpUXKIvqeCM3brW1ojq5kJl3g06KI6uzgAPbnqOKXS
 KkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=YuOwAQkWjXznFXi6rLlMpeEj3pgnoZUS9VAR7tSyz6I=;
 b=eE9m5XPx5E/Rda1yEhUf9Xf+24J8dMRaglczE0nSFaCukMsspisl4MUmbVSe+yHUYa
 OCt5Z1axFkXuHn+oRDlG1GYJzKl5QczXCbFBFwFp1gtaTX8ohGuPU6ZcuB8fS0oMnUGB
 xGsXYSBrRfuyOc94VLHeXmk3e7nyuYYSKJc0x/5lie76cf26eFV69nUiBnKqjsmQRU1g
 vP1il/iu+2pAd2JxG2PgiLsnZizhhR813EQvdTuv0+Gcs1m+RwGd5LuisIDR9QkhE6LA
 PMtm20J0qIUlfj4QnNAMl4uMXSqADXciK9covgOjUQyIH7OgMxlGnbrydhYc/ffSCVbm
 rkhA==
X-Gm-Message-State: AOAM532CFr9jI2XF6o7WWVTcxsaoIRuSk03U5CNCtrfRmS67KunbYSUs
 1HzKNyd6Wx0nMZ3R1E0q/xdu4A==
X-Google-Smtp-Source: ABdhPJwHSsswlwCvX1kziArEs9ci87GuqE1qECOm/i/AFl04pgRGM/ROFtbputz8GVgxVVVUBnO7CA==
X-Received: by 2002:a17:902:868d:b0:13d:dfa7:f3f2 with SMTP id
 g13-20020a170902868d00b0013ddfa7f3f2mr5590566plo.30.1633025151825; 
 Thu, 30 Sep 2021 11:05:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id n66sm3845886pfd.21.2021.09.30.11.05.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 11:05:51 -0700 (PDT)
Date: Thu, 30 Sep 2021 18:05:47 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
Message-ID: <YVX8e6GdLhhkoZh3@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
 <YUtyVEpMBityBBNl@google.com> <875yusv3vm.wl-maz@kernel.org>
 <CALzav=cuzT=u6G0TCVZUfEgAKOCKTSCDE8x2v5qc-Gd_NL-pzg@mail.gmail.com>
 <87zgrurwgq.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zgrurwgq.wl-maz@kernel.org>
Cc: Aaron Lewis <aaronlewis@google.com>, KVM <kvm@vger.kernel.org>,
 Venkatesh Srinivas <venkateshs@google.com>, Peter Shier <pshier@google.com>,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, Jim Mattson <jmattson@google.com>
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

On Thu, Sep 30, 2021, Marc Zyngier wrote:
> On Thu, 23 Sep 2021 00:22:12 +0100, David Matlack <dmatlack@google.com> wrote:
> > 
> > On Wed, Sep 22, 2021 at 11:53 AM Marc Zyngier <maz@kernel.org> wrote:
> > > And I'm all for adding these hooks where it matters as long as they
> > > are not considered ABI and don't appear in /sys/debug/tracing (in
> > > general, no userspace visibility).

On our side (GCP), we very much want these to be ABI so that upgrading the
kernel/KVM doesn't break the userspace collection of stats.

> > > The scheduler is a interesting example of this, as it exposes all sort
> > > of hooks for people to look under the hood. No user of the hook? No
> > > overhead, no additional memory used. I may have heard that Android
> > > makes heavy use of this.
> > >
> > > Because I'm pretty sure that whatever stat we expose, every cloud
> > > vendor will want their own variant, so we may just as well put the
> > > matter in their own hands.
> > 
> > I think this can be mitigated by requiring sufficient justification
> > when adding a new stat to KVM. There has to be a real use-case and it
> > has to be explained in the changelog. If a stat has a use-case for one
> > cloud provider, it will likely be useful to other cloud providers as
> > well.
> 
> My (limited) personal experience is significantly different. The
> diversity of setups make the set of relevant stats pretty hard to
> guess (there isn't much in common if you use KVM to strictly partition
> a system vs oversubscribing it).

To some extent that's true for GCP and x86[*].  I think our position can be
succinctly described as a shotgun approach; we don't know exactly which stats will
be useful when, so grab as many as we can within reason.  As mentioned earlier,
burning 8kb+ of stats per vCPU is perfectly ok for our use cases because it's more
or less negligible compared to the amount of memory assigned to VMs.

This is why I think we should explore an approach that allows for enabling/disabling
groups of stats at compile time. 

[*] For x86 specifically, I think it's a bit easier to predict which stats are
    useful because KVM x86 is responsible for a smaller set of functionality compared
    to arm64, e.g. nearly everything at the system/platform level is handled by
    userspace, and so there are natural exit points to userspace for many of the
    intersesting touch points.  The places where we need stats are where userspace
    doesn't have any visibility into what KVM is doing.

> > > I also wouldn't discount BPF as a possibility. You could perfectly
> > > have permanent BPF programs running from the moment you boot the
> > > system, and use that to generate your histograms. This isn't necessary
> > > a one off, debug only solution.
> > >
> > > > Logging is a similar story, e.g. using _ratelimited() printk to aid
> > > > debug works well when there are a very limited number of VMs and
> > > > there is a human that can react to arbitrary kernel messages, but
> > > > it's basically useless when there are 10s or 100s of VMs and taking
> > > > action on a kernel message requires a prior knowledge of the
> > > > message.
> > >
> > > I'm not sure logging is remotely the same. For a start, the kernel
> > > should not log anything unless something has oopsed (and yes, I still
> > > have some bits to clean on the arm64 side). I'm not even sure what you
> > > would want to log. I'd like to understand the need here, because I
> > > feel like I'm missing something.

I think we're generally on the same page: kernel logging bad.  x86 has historically
used printks to "alert" userspace to notable behavior, e.g. when KVM knowingly
emulates an instruction incorrectly, or when the guest crashes.  The incorrect
instruction emulation isn't all that interesting since we're well aware of KVM's
shortcomings, but guest crashes are an instance where "logging" _to userspace_ is
very desirable, e.g. so that we can identify trends that may be due to bugs in
the host, or to provide the customer with additional data to help them figure out
what's wrong on their end.

"logging" in quotes because it doesn't necessarily have to be traditional logging,
e.g. for the crash cases, KVM already exits to userspace so the "hook" is there,
what's lacking is a way for KVM to dump additional information about the crash.

I brought up logging here purely to highlight that KVM, at least on the x86 side,
lacks infrastructure for running at scale, likely because it hasn't been needed in
the past.

> > > > I'm certainly not expecting other people to solve our challenges,
> > > > and I fully appreciate that there are many KVM users that don't care
> > > > at all about scalability, but I'm hoping we can get the community at
> > > > large, and especially maintainers and reviewers, to also consider
> > > > at-scale use cases when designing, implementing, reviewing, etc...
> > >
> > > My take is that scalability has to go with flexibility. Anything that
> > > gets hardcoded will quickly become a burden: I definitely regret
> > > adding the current KVM trace points, as they don't show what I need,
> > > and I can't change them as they are ABI.
> > 
> > This brings up a good discussion topic: To what extent are the KVM
> > stats themselves an ABI? I don't think this is documented anywhere.
> > The API itself is completely dynamic and does not hardcode a list of
> > stats or metadata about them. Userspace has to read stats fd to see
> > what's there.
> > 
> > Fwiw we just deleted the lpages stat without any drama.
> 
> Maybe the new discoverable interface makes dropping some stats
> easier. But it still remains that what is useless for someone has the
> potential of being crucial for someone else. I wouldn't be surprised
> if someone would ask for this stat back once they upgrade to a recent
> host kernel, probably in a couple of years from now.

lpages is bad example, it wasn't deleted so much as it was replaced by stats for
each page size (4kb, 2mb, 1gb).

I don't think x86 has any (recent) examples of a stat being truly dropped (though
there definitely some that IMO are quite useless).
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
