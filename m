Return-Path: <SRS0=NHQQ=I4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AD7C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 20:21:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0836F61883
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 20:21:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0836F61883
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 966E34B339;
	Tue, 30 Mar 2021 16:21:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l8nhBTskAHA8; Tue, 30 Mar 2021 16:21:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E9714B338;
	Tue, 30 Mar 2021 16:21:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 970244B326
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 15:58:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NnvwNpt+7xm1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Mar 2021 15:58:25 -0400 (EDT)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 765244B325
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 15:58:25 -0400 (EDT)
Received: by mail-pf1-f173.google.com with SMTP id g15so12902180pfq.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 12:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wTEyxuaapP4d1SHF7RcerzFayP475kgkIctZEDORCvY=;
 b=envgQwKOhZLGzYbrjTo3+nEI/ILCJz7AV2GNZ37sA4tCFJ/jO9jwiK5voJwg3r/eds
 n/zOAXzsVLcOacfLuS5VHUc/Z+MqB19zQ52tsRetZLD7hBDRRdqbtww6YeIzEisRIyMw
 UnfTrppUFQicAdk3Yb3QZQbrg/qIsNA3dGPVEIftHW0s1SOq7Hgyee3Ke9l4JB7cfcim
 WfxyAvKImmJ2KZPyBj2tHvhaebrjJjZxU5509A9Ch4WA/EkIVJwDkd6/BmVOdrShBU9j
 tfeAKC2/dsPTX8UPAidLNUSrGVz0OIl962YLH0QZ9VroDrpQvyJk5f+1O5KmnTp/LVWY
 h0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wTEyxuaapP4d1SHF7RcerzFayP475kgkIctZEDORCvY=;
 b=BUbMfew+eleK5vHebpx4PwnbbIj56O52DJ0mj0m8LOr6wNNNSO9q/C6FE7Cs9TcmHK
 KVEp0ZqK72LcP9qXGMxjrYgtvxHfa1jTxXxBNq9vHweHZZiPTpdM133hPNqSVdnA+FIs
 td+C5eB2iOgvSCta9WwPWAAJGeKbaGLdO0DbKasCLYsTVa4FWVQewSwPNY3/5fc085Nx
 +YM11ZAINIhdmDXiPm3zMaMbfrWkcQxgC6khYpQNC37PwOxDRk6ETFqW6WdqNu1JETxd
 kYv/wLOymM6NGlDp8XQE2i8cbS+NbSVoPs9PcrxzNBMCukfSc1Vbf0ZtOwZYrmawf5Va
 0FNg==
X-Gm-Message-State: AOAM530XkSqZPkdiQIeM4hsc2a8yS99ZF+B0abLx+VEg2ZsSp5Kqevkp
 Aj4wKo90pDUYPb/eAcb0m/TMIA==
X-Google-Smtp-Source: ABdhPJy/H3xYrm77zteXXmXwOlrnRIg3rQpdyEYIba7syOVncG/8FqBI2t2hNnALYH3MbklxzEVjZA==
X-Received: by 2002:a63:5361:: with SMTP id t33mr29952003pgl.439.1617134304318; 
 Tue, 30 Mar 2021 12:58:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id f16sm10723866pfj.220.2021.03.30.12.58.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 Mar 2021 12:58:23 -0700 (PDT)
Date: Tue, 30 Mar 2021 19:58:19 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
Message-ID: <YGOC2wqn5k9WkY39@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
X-Mailman-Approved-At: Tue, 30 Mar 2021 16:21:03 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
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

On Tue, Mar 30, 2021, Ben Gardon wrote:
> On Thu, Mar 25, 2021 at 7:20 PM Sean Christopherson <seanjc@google.com> wrote:
> > Patch 10 moves x86's memslot walkers into common KVM.  I chose x86 purely
> > because I could actually test it.  All architectures use nearly identical
> > code, so I don't think it actually matters in the end.
> 
> I'm still reviewing 10 and 14-18. 10 is a huge change and the diff is
> pretty hard to parse.

Ya :-/  I don't see an easy way to break it up without creating a massive diff,
e.g. it could be staged in x86 and moved to common, but I don't think that would
fundamentally change the diff.  Although I admittedly didn't spend _that_ much
time thinking about how to break it up.

> > Patches 11-13 move arm64, MIPS, and PPC to the new APIs.
> >
> > Patch 14 yanks out the old APIs.
> >
> > Patch 15 adds the mmu_lock elision, but only for unpaired notifications.
> 
> Reading through all this code and considering the changes I'm
> preparing for the TDP MMU have me wondering if it might help to have a
> more general purpose MMU lock context struct which could be embedded
> in the structs added in this patch. I'm thinking something like:
> enum kvm_mmu_lock_mode {
>     KVM_MMU_LOCK_NONE,
>     KVM_MMU_LOCK_READ,
>     KVM_MMU_LOCK_WRITE,
> };
> 
> struct kvm_mmu_lock_context {
>     enum kvm_mmu_lock_mode lock_mode;
>     bool can_block;
>     bool can_yield;

Not that it matters right now, but can_block and can_yield are the same thing.
I considered s/can_yield/can_block to make it all consistent, but that felt like
unnecessary thrash.

>     bool flush;

Drat.  This made me realize that the 'struct kvm_gfn_range' passed to arch code
isn't tagged 'const'.  I thought I had done that, but obviously not.

Anyways, what I was going to say before that realization is that the downside to
putting flush into kvm_gfn_range is that it would have to lose its 'const'
qualifier.  That's all a moot point if it's not easily constified though.

Const aside, my gut reaction is that it will probably be cleaner to keep the
flush stuff in arch code, separate from the kvm_gfn_range passed in by common
KVM.  Looping 'flush' back into the helpers is x86 specific at this point, and
AFAICT that's not likely to change any time soon.

For rwlock support, if we get to the point where kvm_age_gfn() and/or
kvm_test_age_gfn() can take mmu_lock for read, then it definitely makes sense to
track locking in kvm_gfn_range, assuming it isn't the sole entity that prevents
consifying kvm_range_range.

> };
> 
> This could yield some grossly long lines, but it would also have
> potential to unify a bunch of ad-hoc handling.
> The above struct could also fit into a single byte, so it'd be pretty
> easy to pass it around.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
