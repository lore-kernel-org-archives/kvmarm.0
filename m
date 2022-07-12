Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA6DCCA482
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jul 2022 08:19:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 344924BE93;
	Wed, 13 Jul 2022 04:19:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jZK8WRnbqQMU; Wed, 13 Jul 2022 04:19:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5A94BF1B;
	Wed, 13 Jul 2022 04:18:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8D8A4BDCB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 19:04:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JL6jNASGHsGH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 19:04:13 -0400 (EDT)
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com
 [209.85.160.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B110A4BDAB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 19:04:13 -0400 (EDT)
Received: by mail-oa1-f48.google.com with SMTP id
 586e51a60fabf-10c0119dd16so12142534fac.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 16:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0kilpuaWkkH1jWKZwcnpv75y3bBAyVMGJWLT8pq7Zew=;
 b=ZBE5KGyRMkxibp5iaQK1l2yLFQs3jMAWpu5gwk0mkKX4ubei8nAy3KENVxr6zAoHjv
 GxxAukLzTPcow4xb39vYwDGdcaSRPa60fmvrQz7t5M+INg1M5ckPSC915vA9q2vN94AD
 /SGqziGRgsU+lRLMnfhy3E5QN+LwNKSm54tmpu0mNnq5YnUHuf05goqCVAxNqaaAiN6B
 kCkPthpHgFI7wBZw9z3V/ubta+xmhbhQHRM/O5EcP+46woLYQpwn+fg2Dj/B6KQdkz8q
 cxYdjJT7Re3j22yGvnr+ktEYQOKJ6wkxisMXfv/a2tIwVaodgTZvM0zkiXaKA3U/CSDX
 wuPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0kilpuaWkkH1jWKZwcnpv75y3bBAyVMGJWLT8pq7Zew=;
 b=ODViJlViEFQYQiPpbl76d1UhojgaZImYzP+bcj7N6piyOyFVEZMwHpVutbaTYr1EPf
 85nUj9RrTJcUy/ysov9cTQXF8H7NUE0l4y99zATz6NNTT/xk9eGSyUzJigPXaR4/jX6Q
 Ej3Q/Q/7TI4B3XE7Lxk1oUDjJEmvYoWZqiyhOj6w1YaUSG6o6BsJtP50NCZQuAR391n1
 BuqWTZweX3sDEFQdJxJsrqC0fzAlJRT+oVs4jjdNT/YcmfZYV3K1fNH8cSQYhUl6cz3e
 g4BvVJMfqJ2ls/J6dUTJ52TJ6Lg/QAHxOKrLt5nkgoZ/WoRMEC1Q3vDlMiNBLkQJJF0t
 DTSw==
X-Gm-Message-State: AJIora82VKYy/i3GWlxDwhPsxV6lyWsPyPVWDrTRdTaV9rwZ4WYQRtw2
 +NqIxZKuRwYxb+U1wGFTLkC0ziUuBFUSj6zpUKkwKw==
X-Google-Smtp-Source: AGRyM1uYZ+G3f4X735Xr0IJWdBmvb830WjZ9bkBphZtyS8Anj7WjdMlYQpZtxJ6khjfO5cktyObZb/GpgNs5V7B3uuU=
X-Received: by 2002:a05:6870:d349:b0:f5:e9ea:5200 with SMTP id
 h9-20020a056870d34900b000f5e9ea5200mr3194460oag.235.1657667052905; Tue, 12
 Jul 2022 16:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-3-yosryahmed@google.com> <YsdLVBtl16mx3+Ot@google.com>
In-Reply-To: <YsdLVBtl16mx3+Ot@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 12 Jul 2022 16:03:37 -0700
Message-ID: <CAJD7tkZ-r7O1AD8kAUgoY0Y2RNQkBpbtmtKpq68xN4PO=fzPnw@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Wed, 13 Jul 2022 04:18:58 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>,
 Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>,
 Huang@google.com, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
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

On Thu, Jul 7, 2022 at 2:08 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > Add a helper to account pages used by KVM for page tables in memory
> > secondary pagetable stats. This function will be used by subsequent
> > patches in different archs.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  include/linux/kvm_host.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 3b40f8d68fbb1..032821d77e920 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
> >  }
> >  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
> >
> > +/*
> > + * If more than one page is being (un)accounted, @virt must be the address of
> > + * the first page of a block of pages what were allocated together (i.e
> > + * accounted together).
>
> Sorry for the belated thoughts...
>
> If you spin a v7, can you add a note to call out that mod_lruvec_page_state() is
> itself thread-safe?  Caught my eye because the TDP MMU usage happens while holding
> mmu_lock for read.
>

Sure! I will send a v7 anyway to address the comments on patch 1. Thanks!

> > + */
> > +static inline void kvm_account_pgtable_pages(void *virt, int nr)
> > +{
> > +     mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
> > +}
> > +
> >  /*
> >   * This defines how many reserved entries we want to keep before we
> >   * kick the vcpu to the userspace to avoid dirty ring full.  This
> > --
> > 2.37.0.rc0.161.g10f37bed90-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
