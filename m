Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DBDC43600
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFCA9610A5
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFCA9610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D6BF4B602;
	Thu,  1 Apr 2021 05:28:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZgJfgTRvjS8K; Thu,  1 Apr 2021 05:28:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F5FD4B634;
	Thu,  1 Apr 2021 05:28:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7376D4B503
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:22:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 10Jm0guh9YkQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 17:22:38 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3153A4B4C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:22:38 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 lr1-20020a17090b4b81b02900ea0a3f38c1so3646936pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 14:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=pXrqzXzEChtI1XfxNDISXq0z9cppP2LyACAbcjVV7bg=;
 b=PXiE5CdfJSVRzY2wAQZx9s0kr/QwU1b4znKQScxqzpI8tabgUAg4SVda6p+Sbl9XJ8
 SBgRoqUAGTlVZz7E+Yi6I70OUwxuE63QPaveGtR2bhifB+6rtU00zzhKHv9EBm/mOGzN
 axtTf1lg1vUe15bNFHV8EITJJNRmtXVeAU1fXFkWHv2T5+TW9Km9hv31+xGyNz9RNJZg
 yMQRHypkP6w+Q7LQSIUVr+KimkqklaqBn3G2feNNtJU0xZlEKop+CQjdve0cSM8ihM7k
 HG24zwAIliz3Jl1sIN7OyrjvzgKi+Qg8zzhSysSO7OjGMtFwPaqpFPvyawOeIZ21OLuK
 occA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pXrqzXzEChtI1XfxNDISXq0z9cppP2LyACAbcjVV7bg=;
 b=n5/aweoscy0VyooYOg+RfOY9mbU7jbY4Ol8JsqdX8egTXK0d+M/6GagWi13hAnB0cg
 Ic4PTobv/fkPnpBEw1MEdY3rRoeyZzCOPNL7/yZm3oqPAFY3lUF4p3Q2uVgEf6G1cTuY
 vPWZMM09pWh5DFypqKQfpZ6ny/aahnJFYa1ns7AQmhM25inI+dshq85BLphaWzG9oAFZ
 MRTaelgcTj6nDXIWjVdH+odeXn0CFtI38FE5oTHWw9zKY6tZnLEmmsLicsFCKt/YDutQ
 3tGzKCHbuLie07zmyylZnOn+nMQyZQB8RUSxjvAs01feq+yFnCBg24KiyarClKlSiRE2
 /t+g==
X-Gm-Message-State: AOAM5305RuZTaaQKzkneuYJf+XUeUrzouyEo0j9JxhbiXpAjOPR0KbBv
 +BqzNiZ+wW0RssNWxS9ZnzKFQg==
X-Google-Smtp-Source: ABdhPJxsIyLoShTQKKQWzcjkczRyz+c6fh0aTYwa65djAo2j70cBG0eZD/ja+to5RbqNzFwrtXDXaA==
X-Received: by 2002:a17:90b:4b87:: with SMTP id
 lr7mr5086802pjb.5.1617225756928; 
 Wed, 31 Mar 2021 14:22:36 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id o4sm3237010pfk.15.2021.03.31.14.22.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 Mar 2021 14:22:36 -0700 (PDT)
Date: Wed, 31 Mar 2021 21:22:32 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGToGBvdfPiCr3WA@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
 <YGTkLMAzk88wOiZm@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YGTkLMAzk88wOiZm@google.com>
X-Mailman-Approved-At: Thu, 01 Apr 2021 05:28:17 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Mar 31, 2021, Sean Christopherson wrote:
> On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> > On 31/03/21 21:47, Sean Christopherson wrote:
> > I also thought of busy waiting on down_read_trylock if the MMU notifier
> > cannot block, but that would also be invalid for the opposite reason (the
> > down_write task might be asleep, waiting for other readers to release the
> > task, and the down_read_trylock busy loop might not let that task run).
> > 
> > > And that's _already_ the worst case since notifications are currently
> > > serialized by mmu_lock.
> > 
> > But right now notifications are not a single critical section, they're two,
> > aren't they?
> 
> Ah, crud, yes.  Holding a spinlock across the entire start() ... end() would be
> bad, especially when the notifier can block since that opens up the possibility
> of the task sleeping/blocking/yielding while the spinlock is held.  Bummer.

On a related topic, any preference on whether to have an explicit "must_lock"
flag (what I posted), or derive the logic based on other params?

The helper I posted does:

	if (range->must_lock &&
	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
		goto out_unlock;

but it could be:

	if (!IS_KVM_NULL_FN(range->on_lock) && !range->may_block &&
	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
		goto out_unlock;

The generated code should be nearly identical on a modern compiler, so it's
purely a question of aesthetics.  I slightly prefer the explicit "must_lock" to
avoid spreading out the logic too much, but it also feels a bit superfluous.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
