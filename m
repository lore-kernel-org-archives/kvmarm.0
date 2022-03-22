Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A8CC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 06:51:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FAB240FC0;
	Tue, 22 Mar 2022 02:51:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CZAlD-WR9Fjr; Tue, 22 Mar 2022 02:51:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B4449EB4;
	Tue, 22 Mar 2022 02:51:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD7DA40FC0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 02:51:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E85KR5et7Goi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 02:51:24 -0400 (EDT)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com
 [209.85.166.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C788440CDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 02:51:24 -0400 (EDT)
Received: by mail-io1-f48.google.com with SMTP id c23so19217981ioi.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 23:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=IwRVisvolBhvIbGMmgKZiBoC8eUBgxbTS282wHCffvU=;
 b=OiY+oWVkFFeaf8NEOpAHS22bD1pOceEqp217C0LFOsTMrvm9y1+jTGStCvCTRHFz9z
 tUoAYyybC3oFNsg06YuwzbuO9Jm1vCKDueBB9TtZsDm5Kls7pW9Hkl6lxT9vOgrM3Veo
 vJ4q5V6CVlVbP7lN5LACckqOYs2irm5x/gGfoXuU7Oqu9ujWjJ6d+cHoj0Sif1WMSFuT
 V2zaZFQMo+azTlct+4GySePdZ3pBKpUG38kjbt71owNqCert/u1AFAnrGLakb4pHKIT8
 REyH9j7ljCeYiix8A8nPTYiPo5gYT9d0wY2PFNQq9KmbbnHh1I+eLaOMybu2N2TNaWuZ
 Txag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=IwRVisvolBhvIbGMmgKZiBoC8eUBgxbTS282wHCffvU=;
 b=1LnvWxFo5dCi73n1UBIopZsKpb7s4+oGtBYYzv5wySTxesldFAkuo9GjCvlk/Lip6J
 xFCjnxwXNS0aE1WmJ8h0Wj9b0AxbiU6/wuTwfDOeDHcytM8o1hEQ+e8aqm8w2o3kCuTh
 U/MsnbiDGsMBN6ASVRUZon16w4Hiq4tBDfhDTeWGDHOF7Fy3WWeq5YqY4rVOzC2UKFA6
 38Tf4BFkXsrSd6NPdNiUfdm8HF3ZMwWoA6hOx0x2aYdIQb6Gv4EHUGrB17+HnCQqdKQz
 qDg7ui4p9DwerNw/1l+nnosSGgkbZYMcsNp11bJ3Rtv4LL9aY40z0feG2JHlWGRrdoy1
 MkGQ==
X-Gm-Message-State: AOAM532Dq+fGNO46tzi/QKv3PbraDF+8uYkCPXNqigmpuu7gkDn59kzU
 bpk5nQ0y0rMM0FlAkX3ox3JSGA==
X-Google-Smtp-Source: ABdhPJyn5hCzHHM/nFQuU+z/DGtpGQ2QKykFc47CuExLWcMmrrNiey8EjICe7dHXffOWlIDypbL6vQ==
X-Received: by 2002:a02:3949:0:b0:321:4529:a74e with SMTP id
 w9-20020a023949000000b003214529a74emr3461979jae.243.1647931883915; 
 Mon, 21 Mar 2022 23:51:23 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 h12-20020a056e021b8c00b002c8196f2751sm4552515ili.52.2022.03.21.23.51.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 21 Mar 2022 23:51:23 -0700 (PDT)
Date: Tue, 22 Mar 2022 06:51:20 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v4 08/15] KVM: arm64: Return a value from
 check_vcpu_requests()
Message-ID: <Yjlx6JKTRbzwAE7o@google.com>
References: <20220311174001.605719-1-oupton@google.com>
 <20220311174001.605719-9-oupton@google.com>
 <CAAeT=FwmU1Ej8zc4wB15TRRH6dH9xK7621gO12ib2QjHW11=NA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FwmU1Ej8zc4wB15TRRH6dH9xK7621gO12ib2QjHW11=NA@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Mon, Mar 21, 2022 at 11:21:15PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Fri, Mar 11, 2022 at 9:41 AM Oliver Upton <oupton@google.com> wrote:
> >
> > A subsequent change to KVM will introduce a vCPU request that could
> > result in an exit to userspace. Change check_vcpu_requests() to return a
> > value and document the function. Unconditionally return 1 for now.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 7c297ddc8177..8eed0556ccaa 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
> >         preempt_enable();
> >  }
> >
> > -static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> > +/**
> > + * check_vcpu_requests - check and handle pending vCPU requests
> > + * @vcpu:      the VCPU pointer
> > + *
> > + * Return: 1 if we should enter the guest
> > + *        0 if we should exit to userspace
> > + *        <= 0 if we should exit to userspace, where the return value indicates
> > + *        an error
> 
> Nit: Shouldn't "<= 0" be "< 0" ?

It definitely should. I'll fold this in to the next spin.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
