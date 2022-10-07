Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4DEC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Oct 2022 14:32:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD8E94B0B9;
	Fri,  7 Oct 2022 10:31:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hl7Lb3eDGEy9; Fri,  7 Oct 2022 10:31:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F30240159;
	Fri,  7 Oct 2022 10:31:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA5741071
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 10:31:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7IIFMd7sw8t for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Oct 2022 10:31:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1159E40FB2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 10:31:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665153115;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=HxEauzp9sdLUt/6pB/n85Z6ivdOEHoUl5EcYQVskSbw=;
 b=DOfxDk5P41Jl3c3YQoXpAbG51nlMaT6IX6y8bn0fCdgchqdNgvO2OQWDn3SrgvbsfXeXFw
 RRQhfslCooTPwOtS7bpR5cX5Nmag5/QmcdrHAkNpW0i0P+t2qyUNLG7wVqB1Te2Cp7PwHU
 siOpYvPazqoEQCUbntG73OMFPmlAQFY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-328-RcFel8eyO_WkyYQnML9Lsw-1; Fri, 07 Oct 2022 10:31:52 -0400
X-MC-Unique: RcFel8eyO_WkyYQnML9Lsw-1
Received: by mail-qv1-f72.google.com with SMTP id
 jn13-20020ad45ded000000b004b1d055fbc7so3011934qvb.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Oct 2022 07:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=HxEauzp9sdLUt/6pB/n85Z6ivdOEHoUl5EcYQVskSbw=;
 b=aAIZIpFF1XbGSwxxTRTpdGhWmybfab4Jz81JGFeeZgaZYTaWGI9fNWwEUX5418CkaD
 XZO0x5m1nocDdoi2J5noBOzY48/K3zjxDxp70CDQVrZNBLWzqHGqw30wzh96Zf4HVj/Y
 Fge/bR0h7N6Tz9LB8/tEAyxnLv+QbnF7DzgLdM+M3TDzvi7aY2YMAqHAjiz5rnq8o8q7
 BOpza63hRP2aOeyIuICrqDLpDOFnAtCGjbqwWjfbM0CUvNWanQ3CJyeg5p2eiad0d5xK
 QC8K8qhsCMRdHGSVxnqnPW/Tlb3NibEcUPGyX1vwRvXRdmU1sVeZflsIZdVCOuJkXoQZ
 nMAg==
X-Gm-Message-State: ACrzQf1EVQBE8WX5F/wk9Ub5upwfk3Bgz9op9TfKIwsDj3ffr3U+po3/
 N3GXfBQkzTzmqzYSUCXcm5veOlR45IFlkYTYG1bVYZ1t3FaUh7C7cmJITVvpI3wWwftV3wX6w8/
 RUSlBD+HrFLPi6tbtf9E0hHCo
X-Received: by 2002:a37:6942:0:b0:6cf:22d6:a887 with SMTP id
 e63-20020a376942000000b006cf22d6a887mr3863265qkc.0.1665153111879; 
 Fri, 07 Oct 2022 07:31:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7et6JpjguAseN/XDUanmE5zbkPsy7bnACNGzAbNBtnH2AIuFYJNa3uHlSqWN3/qSe+3ak+lg==
X-Received: by 2002:a37:6942:0:b0:6cf:22d6:a887 with SMTP id
 e63-20020a376942000000b006cf22d6a887mr3863243qkc.0.1665153111617; 
 Fri, 07 Oct 2022 07:31:51 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 bk5-20020a05620a1a0500b006af3f3b385csm2137607qkb.98.2022.10.07.07.31.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Oct 2022 07:31:50 -0700 (PDT)
Date: Fri, 7 Oct 2022 10:31:49 -0400
From: Peter Xu <peterx@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0A4VaSwllsSrVxT@x1n>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
MIME-Version: 1.0
In-Reply-To: <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Oct 07, 2022 at 07:38:19AM +0800, Gavin Shan wrote:
> Hi Peter,

Hi, Gavin,

> 
> On 10/7/22 4:28 AM, Peter Xu wrote:
> > On Wed, Oct 05, 2022 at 08:41:50AM +0800, Gavin Shan wrote:
> > > -8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> > > -----------------------------------------------------------
> > > +8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_ALLOW_BITMAP}
> > > +--------------------------------------------------------------
> > 
> > Shall we make it a standalone cap, just to rely on DIRTY_RING[_ACQ_REL]
> > being enabled first, instead of making the three caps at the same level?
> > 
> > E.g. we can skip creating bitmap for DIRTY_RING[_ACQ_REL] && !_ALLOW_BITMAP
> > (x86).
> > 
> 
> Both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LONG_RING_ACQ_REL are available
> to x86. So KVM_CAP_DIRTY_LONG_RING_ACQ_REL can be enabled on x86 in theory.
> However, the idea to disallow bitmap for KVM_CAP_DIRTY_LOG_RING (x86) makes
> sense to me. I think you may be suggesting something like below.
> 
> - bool struct kvm::dirty_ring_allow_bitmap
> 
> - In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
>   true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL

What I wanted to do is to decouple the ACQ_REL with ALLOW_BITMAP, so mostly
as what you suggested, except..

> 
>   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 cap, u32 size)
>   {
>     :
>     mutex_lock(&kvm->lock);
> 
>     if (kvm->created_vcpus) {
>        /* We don't allow to change this value after vcpu created */
>        r = -EINVAL;
>     } else {
>        kvm->dirty_ring_size = size;

.. here I'd not set dirty_ring_allow_bitmap at all so I'd drop below line,
instead..

>        kvm->dirty_ring_allow_bitmap = (cap == KVM_CAP_DIRTY_LOG_RING_ACQ_REL);
>        r = 0;
>     }
> 
>     mutex_unlock(&kvm->lock);
>     return r;
>   }
> - In kvm_vm_ioctl_check_extension_generic(), KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP
>   is always flase until KVM_CAP_DIRTY_LOG_RING_ACQ_REL is enabled.
> 
>   static long kvm_vm_ioctl_check_extension_generic(...)
>   {
>     :
>     case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
>         return kvm->dirty_ring_allow_bitmap ? 1 : 0;

... here we always return 1, OTOH in kvm_vm_ioctl_enable_cap_generic():

      case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
           if (kvm->dirty_ring_size)
                return -EINVAL;
           kvm->dirty_ring_allow_bitmap = true;
           return 0;

A side effect of checking dirty_ring_size is then we'll be sure to have no
vcpu created too.  Maybe we should also check no memslot created to make
sure the bitmaps are not created.

Then if the userspace wants to use the bitmap altogether with the ring, it
needs to first detect KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP and enable it
before it enables KVM_CAP_DIRTY_LOG_RING.

One trick on ALLOW_BITMAP is in mark_page_dirty_in_slot() - after we allow
!vcpu case we'll need to make sure it won't accidentally try to set bitmap
for !ALLOW_BITMAP, because in that case the bitmap pointer is NULL so
set_bit_le() will directly crash the kernel.

We could keep the old flavor of having a WARN_ON_ONCE(!vcpu &&
!ALLOW_BITMAP) then return, but since now the userspace can easily trigger
this (e.g. on ARM, a malicious userapp can have DIRTY_RING &&
!ALLOW_BITMAP, then it can simply trigger the gic ioctl to trigger host
warning), I think the better approach is we can kill the process in that
case.  Not sure whether there's anything better we can do.

>   }
> 
> - The suggested dirty_ring_exclusive() is used.
> 
> > > @@ -2060,10 +2060,6 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> > >   	unsigned long n;
> > >   	unsigned long any = 0;
> > > -	/* Dirty ring tracking is exclusive to dirty log tracking */
> > > -	if (kvm->dirty_ring_size)
> > > -		return -ENXIO;
> > 
> > Then we can also have one dirty_ring_exclusive(), with something like:
> > 
> > bool dirty_ring_exclusive(struct kvm *kvm)
> > {
> >          return kvm->dirty_ring_size && !kvm->dirty_ring_allow_bitmap;
> > }
> > 
> > Does it make sense?  Thanks,
> > 
> 
> Thanks,
> Gavin
> 

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
