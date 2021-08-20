Return-Path: <SRS0=8enQ=NL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D4BC432BE
	for <kvmarm@archiver.kernel.org>; Fri, 20 Aug 2021 18:22:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 152B961268
	for <kvmarm@archiver.kernel.org>; Fri, 20 Aug 2021 18:22:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 152B961268
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B5404B104;
	Fri, 20 Aug 2021 14:22:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zATDKuVJkeJN; Fri, 20 Aug 2021 14:22:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B6024B10B;
	Fri, 20 Aug 2021 14:22:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 123664B0FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Aug 2021 14:22:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zc5EJ2gVQBzM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Aug 2021 14:22:51 -0400 (EDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8D4F409DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Aug 2021 14:22:50 -0400 (EDT)
Received: by mail-lf1-f46.google.com with SMTP id g13so22296265lfj.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Aug 2021 11:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zDMz36x4yKQMykOmV38uNAmEx7fWvh5K0Ht5jE7INgk=;
 b=Y9OO0b8f19YmabyG92B9Kuy1+feyypMWz7BFCyCyfsyYJj+hx3l6T09vZ+qUzq4V5K
 2SlCFAhM4pTllTgtEzfCfFLmrUw/4hU17q70A6oqFWfiZEzOzLr6VHlYrHUlBIkiplJK
 H6pYwQvTQZZeGaGfuBXSErpKKnKEV0Q/U8pU3LnW29oU+SBnMuvJ3ucmaanMUsfWi6mF
 2Btm+e9FpjNvLxzYQZdJid2UhYdOCXlBrDFNbrtYzO3RImslr6lZWxq7FAJ0wrUgF9rn
 sBEa3hNIVj7+hTW2eR9TBuwb/rSH/bBPbKsehu91kbdDr6lEsZBbt/DmRuZI7yMQ9VRH
 iZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zDMz36x4yKQMykOmV38uNAmEx7fWvh5K0Ht5jE7INgk=;
 b=uFJWtoEDfmknggDqBbHyjR14i2PeRzQn9ciigL8J7dyxpvb7Es31JLh7XP692X/wPy
 sT+9dxiZG+vMNnsf9eAXIec3NwCa9d29SDSmuQ4Q0LAqOnrEwWJgXxv8AHz6zCyvHZCz
 PkPc8L1V3gopeFLtJdyUBqjncqM+M7WCdx5pO/zbEDOK8HF8u7iif801YQSK3AnXXwz0
 ghhwq1MMbhb9+U3HSqzO3BxwkwZ3cN0PzgqJ31YhYiHD5fi6avsvc4QLNWbxXxkk4Q5X
 CwK/qthNuAgDZvvbiUr6zF3jNE1pfYELMNY5ELl9903sipG5NlRgQth6ia0aDe5ozxoa
 N72w==
X-Gm-Message-State: AOAM533/5/9j63YYxMhq8qk2OF0crffvJYKjMA4ZVI7tkpLzKL0M3rmS
 jZIEjHyr8gAaLBimmQwL6YveFFC1Jph7u4/CG8hO9A==
X-Google-Smtp-Source: ABdhPJzTvCiSF40hWim53AIx0O9SVmdquq5dpPkCWKWdqy+7H6yPirLretuTQkPUsSrtEbmbLIg+wMxDI3XaHyvGxDk=
X-Received: by 2002:ac2:5fc7:: with SMTP id q7mr15153411lfg.524.1629483769092; 
 Fri, 20 Aug 2021 11:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-2-oupton@google.com>
 <20210819182422.GA25923@fuller.cnet>
In-Reply-To: <20210819182422.GA25923@fuller.cnet>
From: Oliver Upton <oupton@google.com>
Date: Fri, 20 Aug 2021 11:22:38 -0700
Message-ID: <CAOQ_Qsin6YTUdbGaq3GChFWq_fzmXrKOUTQk7FarqL0b5GqC4g@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] KVM: x86: Fix potential race in KVM_GET_CLOCK
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Thu, Aug 19, 2021 at 11:43 AM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Mon, Aug 16, 2021 at 12:11:25AM +0000, Oliver Upton wrote:
> > Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
> > outside of the pvclock sync lock. This is problematic, as the clock
> > value written to the user may or may not actually correspond to a stable
> > TSC.
> >
> > Fix the race by populating the entire kvm_clock_data structure behind
> > the pvclock_gtod_sync_lock.
>
> Oliver,
>
> Can you please describe the race in more detail?
>
> Is it about host TSC going unstable VS parallel KVM_GET_CLOCK ?
>

Yeah, pretty much any event that causes us to set use_master_clock =
false could interleave with the KVM_GET_CLOCK ioctl. A guest could
kick its TSCs out of sync, for example, to cause this too. AFAICT, KVM
serializes the write side (pvclock_update_vm_gtod_copy()) with
pvclock_gtod_sync_lock, as it should.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
