Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDACC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 19:45:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CEA660FD7
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 19:45:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9CEA660FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D69B4B0A0;
	Thu,  2 Sep 2021 15:45:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sSkgHTzNOdoo; Thu,  2 Sep 2021 15:45:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 217B14B0A3;
	Thu,  2 Sep 2021 15:45:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D2B4B0A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 15:45:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qdJcm+gIH1Ux for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 15:45:17 -0400 (EDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
 [209.85.167.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0453E4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 15:45:16 -0400 (EDT)
Received: by mail-lf1-f54.google.com with SMTP id k13so6806263lfv.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 12:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Hc2gcVksXzTr1IYZOTogrbXgKL8dWeh0/s29AyPzQmQ=;
 b=nGK4NeA6yxLc1weyQpFYZMrqUi3ivy+2UO+yNScnEseijwiIq21vEMLnYigeNN2xqm
 Yi6Qc1ylsTv2t0Iuok58JzuIduweJpCeJ1pmjZvwXXCKwnNoUWaG/dkE1v0p+ZLG3Mfp
 e1baudwOsKlH/fDwgBAxp8lf9bh/JLcEa+uruQgVKVdY99FIiVYvNBH4rqYDZtFR82al
 JY38xlhEi0kshEEl7eBwj3LgbiqJBijkOpZh9ODqFwQVPDHpDsnX+AeNlaVsFgqUYTap
 ypGZlUzgHzB52a8WMmkq6tkBQpthITzwz5WNifkBD0MTR7pdWkk4JU+w1ROT5lyTkSgK
 Yzew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Hc2gcVksXzTr1IYZOTogrbXgKL8dWeh0/s29AyPzQmQ=;
 b=jJMuWKVLK8eNelZ/oLY/NbZBfixPU5XN2zk+FEbojPLw8cWk+38ufcJ0O74Vzqc5T9
 f/nQXFAfB3zCYDisxBsSSlGirMv+uBu/tMvyvocjK6ZSXvGChHmbpAeLoZn4EJBWPS1w
 W+jC1kHFWSPOMW43xio/+VXrWRmaU1SSrQBXpB0qgqGf2RDt7ybN3zUDm19ixtfej/1w
 SqsTufAkBi3xFfhBIJdEyzX1VBvPSAumyrAxW60OlXOWMtkjbSrnEwxjEddkpzHKaS/u
 OLoCF4tZwkhhcnxsrOOyqUf7QJ3jAR8pGEJe3SEvlVuIYFhLEBEXpxFvkzU5eM8Gp60S
 3Png==
X-Gm-Message-State: AOAM531Kf6TzkZj0jm6XX6G0f1lia7Gr+Z6YNNQEIbOR/Y0976Xg6V15
 WH0F6CT1XO0FSf25ePiRGtedg7GyKDoP/L6qOHJP3Q==
X-Google-Smtp-Source: ABdhPJxs82rjOaFEEVNEFjggRcMRuAgzhuR+/VhLAeGrIKZ+wPbbkII2xn5iYSx51JVsk55zn+AngBAngaE4OnGx1lU=
X-Received: by 2002:a05:6512:1107:: with SMTP id
 l7mr3883353lfg.80.1630611915246; 
 Thu, 02 Sep 2021 12:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
 <YTEkuXQ1cNhPoqP1@google.com>
In-Reply-To: <YTEkuXQ1cNhPoqP1@google.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 2 Sep 2021 12:45:02 -0700
Message-ID: <CAOQ_QshZCNACJy2f-jJL=U8+NROp1DoM3KXcN_3z5kE4h2JY7Q@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] KVM: x86: Add idempotent controls for migrating
 system counter state
To: Sean Christopherson <seanjc@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Thu, Sep 2, 2021 at 12:23 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Aug 16, 2021, Oliver Upton wrote:
> > Applies cleanly to kvm/queue.
> >
> > Parent commit: a3e0b8bd99ab ("KVM: MMU: change tracepoints arguments to kvm_page_fault")
>
> This needs a rebase, patch 2 and presumably patch 3 conflict with commit
> 77fcbe823f00 ("KVM: x86: Prevent 'hv_clock->system_time' from going negative in
> kvm_guest_time_update()").

Thanks for the heads up! I've been hands-off with this series for a
bit, as I saw Paolo was playing around with it to fold it with his
pvclock locking changes (branch kvm/paolo). I'll pick up your
suggestions and get another series out with Paolo's additions.

--
Thanks,
Oliver

> > v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com
> >
> > v6 -> v7:
> >  - Separated x86, arm64, and selftests into different series
> >  - Rebased on top of kvm/queue
> >
> > Oliver Upton (6):
> >   KVM: x86: Fix potential race in KVM_GET_CLOCK
> >   KVM: x86: Create helper methods for KVM_{GET,SET}_CLOCK ioctls
> >   KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
> >   KVM: x86: Take the pvclock sync lock behind the tsc_write_lock
> >   KVM: x86: Refactor tsc synchronization code
> >   KVM: x86: Expose TSC offset controls to userspace
> >
> >  Documentation/virt/kvm/api.rst          |  42 ++-
> >  Documentation/virt/kvm/devices/vcpu.rst |  57 ++++
> >  Documentation/virt/kvm/locking.rst      |  11 +
> >  arch/x86/include/asm/kvm_host.h         |   4 +
> >  arch/x86/include/uapi/asm/kvm.h         |   4 +
> >  arch/x86/kvm/x86.c                      | 362 +++++++++++++++++-------
> >  include/uapi/linux/kvm.h                |   7 +-
> >  7 files changed, 378 insertions(+), 109 deletions(-)
> >
> > --
> > 2.33.0.rc1.237.g0d66db33f3-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
