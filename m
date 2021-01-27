Return-Path: <SRS0=cUgw=G6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215CFC433E9
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 09:56:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E95720731
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 09:56:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E95720731
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE8A04B1D9;
	Wed, 27 Jan 2021 04:56:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g5pbA0VJkGtf; Wed, 27 Jan 2021 04:56:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACC0A4B1F5;
	Wed, 27 Jan 2021 04:56:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F3D04B1BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 19:04:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ebRuAmztgVJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 19:04:42 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C7974B180
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 19:04:42 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id u11so20645plg.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 16:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ehN8g8luuF2BKLiZYDz35HTGbUgrzlwEK0VyDMRc1bE=;
 b=u+tGmLtats3b8HsEfxKVQgMK0GXcYfxMRPArDpxJoYSxVOHzNMkczWTT9UKc+iuL5c
 1i80Ybhtd+JjjT+hrlRpf+r1Oti1xkqj1SSUkApAb7iuqNc0hAkpN+PYw76+kF30zXuT
 xKNeJ0v6+/QBYk7eVYWEZTsCW8IasRNlBF9OpHVGxlio9+VdQohz9RpJPqPxKapSecTH
 XpaQaL94Nfi9thSv44/gpO6nt2eB1Ocr0Vtnc3sPmSduLvYB3U07MvoJrdF3T7Y1+n08
 NfLW9PKtYmJe5bubHPO75UGFwYTmQBwPme6NriQsLx5/PJNyd+X6U36wepGK/wdj+iNS
 wuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ehN8g8luuF2BKLiZYDz35HTGbUgrzlwEK0VyDMRc1bE=;
 b=JEC86fiElnlZXymvDoF7VqP4638dQDupBSxmJF6uU1PTdIX5NQtC4zzIN2FMRLum4Y
 s2GrJQP5DwnlSYyHTUPVjxHvbglg/fpfzjkdtBbq66BEUn4nF82zTwQbtC3smAzdSTRv
 D33IBk/KENyX3zmqg3wBOnJARScn7O75s0ykFMmLqsdJCt6TobfBkfa8lYmqNCDv8rm7
 nV4YN6MnZuvnR+EPHFP8p5gjbr+nulRn7EIr3vohKd0IyhvrUffKVJ2pRJuvLMUsitnU
 IWmzYERL8t2LYlMmZnmAIMeVM0lDEwJfqGEExhzJlLYYr/vcPMcKeDxPFh3kTI2Y41FH
 Hy7w==
X-Gm-Message-State: AOAM533/BXliwqOKE4CoO/9se1kP8Iy9TidJ87JeV4uv6rO6vXAuO8+S
 L4vAuyvtRAX/vqH4SBWLjrZrAQ==
X-Google-Smtp-Source: ABdhPJzzbvfi/5tp5Y0OvbgmuXAJ+a6Aqpa1MNl1ySc5Qa2syXhxmjS34UST5dEuL1LWwufhbGgubw==
X-Received: by 2002:a17:90b:4a09:: with SMTP id
 kk9mr2478013pjb.15.1611705881203; 
 Tue, 26 Jan 2021 16:04:41 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 by smtp.gmail.com with ESMTPSA id y4sm75088pji.34.2021.01.26.16.04.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jan 2021 16:04:40 -0800 (PST)
Date: Tue, 26 Jan 2021 16:04:33 -0800
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH] KVM: x86/mmu: consider the hva in mmu_notifer retry
Message-ID: <YBCuEaxZu0MuD3MW@google.com>
References: <20210125064234.2078146-1-stevensd@google.com>
 <YA8PXCEVukW0UzC5@google.com>
 <CAD=HUj5YMtSJY6ZO9TRXHDEfWRM1o3Lrm7nkz=G2VJ_oZ-c5mw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAD=HUj5YMtSJY6ZO9TRXHDEfWRM1o3Lrm7nkz=G2VJ_oZ-c5mw@mail.gmail.com>
X-Mailman-Approved-At: Wed, 27 Jan 2021 04:56:41 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, open list <linux-kernel@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, Jan 26, 2021, David Stevens wrote:
> > This needs a comment to explicitly state that 'count > 1' cannot be done at
> > this time.  My initial thought is that it would be more intuitive to check for
> > 'count > 1' here, but that would potentially check the wrong wrange when count
> > goes from 2->1.  The comment about persistence in invalidate_range_start() is a
> > good hint, but I think it's worth being explicit to avoid bad "cleanup" in the
> > future.
> >
> > > +     if (unlikely(kvm->mmu_notifier_count)) {
> > > +             if (kvm->mmu_notifier_range_start <= hva &&
> > > +                 hva < kvm->mmu_notifier_range_end)
> 
> I'm not sure I understand what you're suggesting here. How exactly
> would 'count > 1' be used incorrectly here? I'm fine with adding a
> comment, but I'm not sure what the comment needs to clarify.

There's no guarantee that the remaining in-progress invalidation when the count
goes from 2->1 is the same invalidation call that set range_start/range_end.

E.g. given two invalidations, A and B, the order of calls could be:

  kvm_mmu_notifier_invalidate_range_start(A)
  kvm_mmu_notifier_invalidate_range_start(B)
  kvm_mmu_notifier_invalidate_range_end(A)
  kvm_mmu_notifier_invalidate_range_end(B) <-- ???

or

  kvm_mmu_notifier_invalidate_range_start(A)
  kvm_mmu_notifier_invalidate_range_start(B)
  kvm_mmu_notifier_invalidate_range_end(B)
  kvm_mmu_notifier_invalidate_range_end(A) <-- ???

In the first case, "A" is in-progress when the count goes 2->1, in the second
case "B" is still in-progress.  Checking for "count > 1" in the consumer instead
of handling it in the producer (as you did) would lead to the consumer checking
against the wrong range.  I don't see a way to solve that without adding some
amount of history, which I agree is unnecessary.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
