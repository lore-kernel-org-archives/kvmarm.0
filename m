Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C306C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:11:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8170360F4C
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:11:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8170360F4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E414B118;
	Wed, 22 Sep 2021 09:11:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sWMgxKehHTci; Wed, 22 Sep 2021 09:11:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AFA14B152;
	Wed, 22 Sep 2021 09:11:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CACB6407E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 17:29:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BmiwHaBJhxKn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 17:29:54 -0400 (EDT)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F7FC4079D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 17:29:54 -0400 (EDT)
Received: by mail-pl1-f180.google.com with SMTP id j14so335289plx.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 14:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=LSn/kFygvp1Gc7LYRPSl9USN2eKVUYYqQK80C4S3HbY=;
 b=btxgeKmkbIeI+ZpOc6VlwSC4J1M0NxXCmAKO/nawCIYSv8cbGywGkAH3QCnwAqLAUI
 IOyxlnQF3u2reCho4aOS27m8AURN66z+f1gzEN4gfB+N1/w2JLIXtC4yGrRdYBUrXdWC
 Vx/SNzr0zgBg66Mt5tqVTWXtqNRo1cMW1HRk7P6/aIgQitN5dojnf/rmx3fJsNEBiKh4
 2oG4JdRFZ1cCImM5O4stFWaGUi4+BBk4LEDc8ZYoSTyQQ09FyLfXbzxkQRIwj2f3Y1ux
 qkOUO+HshbP+1GDpYX5TBWF68F9+FWvzry5+DIxEzwl/5EC5N4EFZsnTQtNpn8FiRBGK
 Np7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LSn/kFygvp1Gc7LYRPSl9USN2eKVUYYqQK80C4S3HbY=;
 b=fjtVKHc/odbA88Q30nE0s5YALYnY7V/Id35Qi7CXyMkiVJ3zVa8MpT5MaEvBZUFKBO
 KxYJLoLlz3e3Gkpezl7+zHHeplWhphMtgt0ma5LDPHwl692JgrFSttfjS0BO+q580Zaz
 yzYO8JqjHQI9vYae7F01A9SKlq+8kKRg044Gop232ft/kLd9iCkKULFbM2wTDU2P/QW2
 gVb43vWDzgZF2oNXW4rW8AfvwOyzkP0bYmIMmkNAKsruiqOE879Ne3j6vG6xsh4SlmnL
 GK++tUe/bUG0jfEzLhfHztd9k98e2DmupRC1a+s7s+KfyxP+CuGnxOi0E0+xx/EaH0hd
 y63Q==
X-Gm-Message-State: AOAM5328d+uh5HjF92FLqKDX/y3UOHrlw45XvKAeHagRJNvNKLMdEB47
 k7bj90v1VkCt5XNr/QksRpEw/Q==
X-Google-Smtp-Source: ABdhPJzMgcR9UgCsbvPuA/02v4FkJblQW9htJs47A2YRdbvRMs4AQG7O660EDIsBZdZMmGrIa23JJg==
X-Received: by 2002:a17:902:bf42:b0:13d:b79f:a893 with SMTP id
 u2-20020a170902bf4200b0013db79fa893mr8518959pls.1.1632259793364; 
 Tue, 21 Sep 2021 14:29:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id w142sm103618pfc.47.2021.09.21.14.29.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Sep 2021 14:29:52 -0700 (PDT)
Date: Tue, 21 Sep 2021 21:29:48 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 05/13] perf: Force architectures to opt-in to guest
 callbacks
Message-ID: <YUpOzFW3K3iJAoWa@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828003558.713983-6-seanjc@google.com>
 <20210828194752.GC4353@worktop.programming.kicks-ass.net>
 <8ee13a69-f2c4-2413-2d6c-b6c0a559286e@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8ee13a69-f2c4-2413-2d6c-b6c0a559286e@redhat.com>
X-Mailman-Approved-At: Wed, 22 Sep 2021 09:11:52 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Like Xu <like.xu.linux@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Sep 21, 2021, Paolo Bonzini wrote:
> On 28/08/21 21:47, Peter Zijlstra wrote:
> > > +config HAVE_GUEST_PERF_EVENTS
> > > +	bool
> > 	depends on HAVE_KVM
> 
> It won't really do anything, since Kconfig does not detects conflicts
> between select' and 'depends on' clauses.

It does throw a WARN, though the build doesn't fail.

WARNING: unmet direct dependencies detected for HAVE_GUEST_PERF_EVENTS
  Depends on [n]: HAVE_KVM [=n] && HAVE_PERF_EVENTS [=y]
  Selected by [y]:
  - ARM64 [=y]

WARNING: unmet direct dependencies detected for HAVE_GUEST_PERF_EVENTS
  Depends on [n]: HAVE_KVM [=n] && HAVE_PERF_EVENTS [=y]
  Selected by [y]:
  - ARM64 [=y]

WARNING: unmet direct dependencies detected for HAVE_GUEST_PERF_EVENTS
  Depends on [n]: HAVE_KVM [=n] && HAVE_PERF_EVENTS [=y]
  Selected by [y]:
  - ARM64 [=y]

> Rather, should the symbol be selected by KVM, instead of ARM64 and X86?

By KVM, you mean KVM in arm64 and x86, correct?  Because HAVE_GUEST_PERF_EVENTS
should not be selected for s390, PPC, or MIPS.

Oh, and Xen also uses the callbacks on x86, which means the HAVE_KVM part is
arguabably wrong, even though it's guaranteed to be true for the XEN_PV case.
I'll drop that dependency and send out a separate series to clean up the arm64
side of HAVE_KVM.

The reason I didn't bury HAVE_GUEST_PERF_EVENTS under KVM (and XEN_PV) is that
there are number of references to the callbacks throught perf and I didn't want
to create #ifdef hell.

But I think I figured out a not-awful solution.  If there are wrappers+stubs for
the guest callback users, then the new Kconfig can be selected on-demand instead
of unconditionally by arm64 and x86.  That has the added bonus of eliminating
the relevant code paths for !KVM (and !XEN_PV on x86), with or without static_call.
It also obviates the needs for __KVM_WANT_GUEST_PERF_EVENTS or whatever I called
that thing.

It more or less requires defining the static calls in generic perf, but I think
that actually ends up being good thing as it consolidates more code without
introducing more #ifdefs.  The diffstats for the static_call() conversions are
also quite nice.

 include/linux/perf_event.h | 28 ++++++----------------------
 kernel/events/core.c       | 15 +++++++++++++++
 2 files changed, 21 insertions(+), 22 deletions(-)

I'll try to get a new version out today or tomorrow.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
