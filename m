Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EB2C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 17:37:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 007996113E
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 17:37:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 007996113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 332824B2EA;
	Fri,  2 Apr 2021 13:37:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6PRveEH3nU+E; Fri,  2 Apr 2021 13:37:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33C344B354;
	Fri,  2 Apr 2021 13:37:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D9244AED4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 10:59:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uqysWzE12MP9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 10:59:24 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02F3A4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 10:59:23 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id c204so3378pfc.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 07:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hrWlBAMIox9uyp5vA/6pgwPUQG03jLxXChap4JWk798=;
 b=Wis80br4QxI0udXSM5bgb12ub29OxkCYgsG+Q5MaHbKjRYNZTxX2dKGqJxK+5x27Ec
 bCjK5MvvUurkyJh+2dVl5bUVlOF+S5kkzM86t1vFaJEMUN3T8Kr2U41JVg3ikRq9VsY9
 bmvTxU20lmUiRhm6QGV5OSagHM6CMIS3zcbQPID23xudkFfFOfaNfDFrfAAV9MBGBCbG
 4fo9i95YmINHH5yrkVF5nSKywYI/L+Mv9lKQ9OfuRtFbwYvD08rHo26eFSvgUFwVqUjF
 9D9+2OjiT3WWi7P0x9fBHYTDN17PeeBVM5FGjv80+DwDvYvLLhKy7ATI6OvoR6zd0tW3
 xYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hrWlBAMIox9uyp5vA/6pgwPUQG03jLxXChap4JWk798=;
 b=TNwM0baLOYRZB6fulXPzVBP/Apg3BqYmCaG8cbVGf6qIS1EaFxFrVpMkv+5GjmlpbI
 2MmN9Mt4zZBMDKrUesMnTjT2+ov9IX8sQYqLizk4XrKQdGTTnr24WnY0dR50sQ7lARJD
 5/bPcnaboBoKj1uq9+TXq9uPo4UR6msP/xmSSwowUT33K9v++Qy18DZphZkAgAMUC0A/
 W2gp5tGkKpfbhfTYYzhhgYZ71+5zTJDiRP/Sk19SAIMJ6WNnC3QGHKIN0fdz9kXrmd+W
 kWEO2m9sOn3wcqxu7WA0hmE+GZoTp9WN+sWvOg4VNuvVlbSaGx2mmEQVacvwHqVcKeIv
 EmtQ==
X-Gm-Message-State: AOAM5323hxROi0NIwfcVc2AzAIF2Loj+Ee0SAkHuZLxOVH7aYb9Ko7pp
 9BNTPFn7MDaQqV8lvGlZfjrXyw==
X-Google-Smtp-Source: ABdhPJwt/NANo8uiyFDGCSZL9IUa09CiSHlR3SZWQT4n9NqXGj8DMBBrtVhreCbJVQp+DfbrA8SQSg==
X-Received: by 2002:a62:7708:0:b029:1ee:f656:51d5 with SMTP id
 s8-20020a6277080000b02901eef65651d5mr12750775pfc.59.1617375562873; 
 Fri, 02 Apr 2021 07:59:22 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id b186sm8540014pfb.170.2021.04.02.07.59.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 02 Apr 2021 07:59:22 -0700 (PDT)
Date: Fri, 2 Apr 2021 14:59:18 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGcxRmzbEr3kPsWE@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-10-seanjc@google.com>
 <417bd6b5-b7d0-ed22-adae-02150cdbfebe@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <417bd6b5-b7d0-ed22-adae-02150cdbfebe@redhat.com>
X-Mailman-Approved-At: Fri, 02 Apr 2021 13:37:03 -0400
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

On Fri, Apr 02, 2021, Paolo Bonzini wrote:
> On 02/04/21 02:56, Sean Christopherson wrote:
> > Avoid taking mmu_lock for unrelated .invalidate_range_{start,end}()
> > notifications.  Because mmu_notifier_count must be modified while holding
> > mmu_lock for write, and must always be paired across start->end to stay
> > balanced, lock elision must happen in both or none.  To meet that
> > requirement, add a rwsem to prevent memslot updates across range_start()
> > and range_end().
> > 
> > Use a rwsem instead of a rwlock since most notifiers _allow_ blocking,
> > and the lock will be endl across the entire start() ... end() sequence.
> > If anything in the sequence sleeps, including the caller or a different
> > notifier, holding the spinlock would be disastrous.
> > 
> > For notifiers that _disallow_ blocking, e.g. OOM reaping, simply go down
> > the slow path of unconditionally acquiring mmu_lock.  The sane
> > alternative would be to try to acquire the lock and force the notifier
> > to retry on failure.  But since OOM is currently the _only_ scenario
> > where blocking is disallowed attempting to optimize a guest that has been
> > marked for death is pointless.
> > 
> > Unconditionally define and use mmu_notifier_slots_lock in the memslots
> > code, purely to avoid more #ifdefs.  The overhead of acquiring the lock
> > is negligible when the lock is uncontested, which will always be the case
> > when the MMU notifiers are not used.
> > 
> > Note, technically flag-only memslot updates could be allowed in parallel,
> > but stalling a memslot update for a relatively short amount of time is
> > not a scalability issue, and this is all more than complex enough.
> 
> Proposal for the locking documentation:

Argh, sorry!  Looks great, I owe you.

> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index b21a34c34a21..3e4ad7de36cb 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -16,6 +16,13 @@ The acquisition orders for mutexes are as follows:
>  - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
>    them together is quite rare.
> +- The kvm->mmu_notifier_slots_lock rwsem ensures that pairs of
> +  invalidate_range_start() and invalidate_range_end() callbacks
> +  use the same memslots array.  kvm->slots_lock is taken outside the
> +  write-side critical section of kvm->mmu_notifier_slots_lock, so
> +  MMU notifiers must not take kvm->slots_lock.  No other write-side
> +  critical sections should be added.
> +
>  On x86, vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock.
>  Everything else is a leaf: no other lock is taken inside the critical
> 
> Paolo
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
