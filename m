Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44243C47083
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 08:52:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E0EAF61418
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 08:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0EAF61418
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C154B0FE;
	Fri,  4 Jun 2021 04:52:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nYo+IPqge16G; Fri,  4 Jun 2021 04:51:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F214E4B10B;
	Fri,  4 Jun 2021 04:51:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A060C4B0DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 20:39:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pkJb9lf5203a for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 20:39:38 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 731DB4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 20:39:38 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id x10so3781084plg.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Jun 2021 17:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hsyO5EEm3dG2GUVsZApwZQUFiUjt1oJTpcTgXFZNdfs=;
 b=BlYNVPE305FbxEUMO5lSCEn5LG3JutO1Lg3tWns9s0oCrpDQwG+i6qmuM/hisKYpP+
 y5qZfeRJIC4++esHrRYMFwklEwa2AsIP8FI2G+izcydAmHDQpIvGWGtM265YiTqVep0S
 1wPk4/uTSpfKNxeIwC0sNPU2Zfv4gAByw74Ls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hsyO5EEm3dG2GUVsZApwZQUFiUjt1oJTpcTgXFZNdfs=;
 b=Li/kjiZqIQ6uEAUIdpiB6Lb4JAarbWG8y8QUnpKHaWl9oADfyKJF3tqLIR7TsMrFRj
 49HvOepeDROveBv6aYhz903a/flUM0SLN7+T/+RVXKUhJaOBto7qP5dOmqHGTyXW2JOu
 KkFhU84/CemSaz17ZcU/agw0Yc4TZtr1/aCqnpWZvTaYgcX22edpZexyv607WYeKhU8B
 dpqSpuS1UAIuLR5S28j1nn3oKfIgOMAu6OVm8e4Rbtxtk6mpVMXuMvs1SoG/NOhFzTVH
 rRqJf8G2RTFfFEoJan5QMicwnZdEnzwTu6O2yRqRl29dyP3Phhw5hdUD+3bhR2D2l8eE
 Tt6w==
X-Gm-Message-State: AOAM532YQ96siEg0kSM+QyD4CCjXw3bAKbgrG7tVkbfFRkX1pLGToIdW
 7nstCiYx1bSwHQo4JC6wIde81w==
X-Google-Smtp-Source: ABdhPJwUR3L1tC9qXtsxtXxpLe8tNcJAE3/COLahbUTOQi2i1KnLOCdr6jBvw3P/Ytpi3HasD6ls1Q==
X-Received: by 2002:a17:90a:7345:: with SMTP id
 j5mr13827315pjs.64.1622767177417; 
 Thu, 03 Jun 2021 17:39:37 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:36b:f5b6:c380:9ccf])
 by smtp.gmail.com with ESMTPSA id j16sm3074017pjn.55.2021.06.03.17.39.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Jun 2021 17:39:36 -0700 (PDT)
Date: Fri, 4 Jun 2021 09:39:29 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
Message-ID: <YLl2QeoziEVHvRAO@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <YLkRB3qxjrXB99He@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YLkRB3qxjrXB99He@hirez.programming.kicks-ass.net>
X-Mailman-Approved-At: Fri, 04 Jun 2021 04:51:53 -0400
Cc: Suleiman Souhlal <suleiman@google.com>, linux-s390@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
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

On (21/06/03 19:27), Peter Zijlstra wrote:
> On Fri, Jun 04, 2021 at 01:43:15AM +0900, Sergey Senozhatsky wrote:
[..]
> >  
> > +void kvm_arch_pm_notifier(struct kvm *kvm)
> > +{
> > +}
> > +
> >  long kvm_arch_vm_ioctl(struct file *filp,
> >  		       unsigned int ioctl, unsigned long arg)
> >  {
> 
> What looks like you wants a __weak function.

True. Thanks for the suggestion.

I thought about it, but I recalled that tglx had  __strong opinions
on __weak functions.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
