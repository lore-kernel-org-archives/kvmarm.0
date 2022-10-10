Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33946C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 10 Oct 2022 23:49:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9829C4B621;
	Mon, 10 Oct 2022 19:49:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G78vXaBDo5FI; Mon, 10 Oct 2022 19:49:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB2164B27C;
	Mon, 10 Oct 2022 19:49:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9094B25E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 19:49:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SSvCnu7UFNse for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 19:49:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3DE54B25A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 19:49:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665445759;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ECL7l2qNjN7HZ8FHjWdy2QLrc8mqWYLOaevH3XZ/d1Y=;
 b=dsKaRHjPmB3oFakCjIR566YRxtbsUsOKB//0xmKNh0NlVOVWjCIbvkeFATqMxX4q1+h7I4
 i7krwIKEBYxsfKPX9xbGpcX7jhjHm+Qj0UWgk6tmuO2ybeAPwWjDmmedt4EYxl2B1jgz61
 1mgFENWy8cxV5q/poBoyPDrKDEb3LbE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-377-Veq4Ha3qM32u6zg9_9_MCw-1; Mon, 10 Oct 2022 19:49:18 -0400
X-MC-Unique: Veq4Ha3qM32u6zg9_9_MCw-1
Received: by mail-qv1-f70.google.com with SMTP id
 oo12-20020a056214450c00b004b31d8eda36so5285460qvb.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 16:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ECL7l2qNjN7HZ8FHjWdy2QLrc8mqWYLOaevH3XZ/d1Y=;
 b=Win0i53cPXymsJHNr+03HawItmNxlyzR10wsMc1QWh7m6h3XNUlNJe3QshJ5vt4fMD
 GiilGjMuVXenIXL+Fm4W25nUlFML6rELun81nXQRbG11F/3btoxdGH8I+a9Qbl44/zZh
 dSOYtAtvXScZT4SwfH7GmbsApyWz1kovEGJq/WjhntAo8mcIORVCLJv30n+jaDxswkno
 CmpTWcoOuPoWC9tBJqwZlQSSRMHmOqM0VGyAEbUpK88CZJkB2n/COlyn621LJdox8Ahu
 66HOLjnxJ99bAZls3mNj7kVYThiksBoC3UTdYpPHlM8rzgdpmSBNzUjxR6wAgl8yX3F2
 SaLA==
X-Gm-Message-State: ACrzQf1dQism5bYpsolfIdI1GWwtBLO+PYdIyV3XCPWswhpGfEGMnpqv
 85ZHrzWAj0/qdNi0eKU/EaMaWDY+jMYDrw8BOUiAzxaE6rOrVfohoKFRvrP/r/Lpqtwaba+atvO
 dQqxsTirM7LwigxPgP5ClmA2J
X-Received: by 2002:a05:620a:1a14:b0:6ce:a65b:8e6 with SMTP id
 bk20-20020a05620a1a1400b006cea65b08e6mr14491813qkb.145.1665445758022; 
 Mon, 10 Oct 2022 16:49:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4u7xyfHg/ZkZ+m9QVEZ+j8MKikQ4pUkG/ui28WrCvU0zvQtEPFYNMQZpHrCEw8JskM1BVf8g==
X-Received: by 2002:a05:620a:1a14:b0:6ce:a65b:8e6 with SMTP id
 bk20-20020a05620a1a1400b006cea65b08e6mr14491800qkb.145.1665445757739; 
 Mon, 10 Oct 2022 16:49:17 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
 by smtp.gmail.com with ESMTPSA id
 s4-20020a05620a254400b006bbc09af9f5sm11266252qko.101.2022.10.10.16.49.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 10 Oct 2022 16:49:17 -0700 (PDT)
Date: Mon, 10 Oct 2022 19:49:15 -0400
From: Peter Xu <peterx@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0SvexjbHN78XVcq@xz-m1.local>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n> <Y0SoX2/E828mbxuf@google.com>
MIME-Version: 1.0
In-Reply-To: <Y0SoX2/E828mbxuf@google.com>
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

On Mon, Oct 10, 2022 at 11:18:55PM +0000, Oliver Upton wrote:
> On Fri, Oct 07, 2022 at 10:31:49AM -0400, Peter Xu wrote:
> 
> [...]
> 
> > > - In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
> > >   true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL
> > 
> > What I wanted to do is to decouple the ACQ_REL with ALLOW_BITMAP, so mostly
> > as what you suggested, except..
> 
> +1
> 
> > > 
> > >   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 cap, u32 size)
> > >   {
> > >     :
> > >     mutex_lock(&kvm->lock);
> > > 
> > >     if (kvm->created_vcpus) {
> > >        /* We don't allow to change this value after vcpu created */
> > >        r = -EINVAL;
> > >     } else {
> > >        kvm->dirty_ring_size = size;
> > 
> > .. here I'd not set dirty_ring_allow_bitmap at all so I'd drop below line,
> > instead..
> > 
> > >        kvm->dirty_ring_allow_bitmap = (cap == KVM_CAP_DIRTY_LOG_RING_ACQ_REL);
> > >        r = 0;
> > >     }
> > > 
> > >     mutex_unlock(&kvm->lock);
> > >     return r;
> > >   }
> > > - In kvm_vm_ioctl_check_extension_generic(), KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP
> > >   is always flase until KVM_CAP_DIRTY_LOG_RING_ACQ_REL is enabled.
> > > 
> > >   static long kvm_vm_ioctl_check_extension_generic(...)
> > >   {
> > >     :
> > >     case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
> > >         return kvm->dirty_ring_allow_bitmap ? 1 : 0;
> > 
> > ... here we always return 1, OTOH in kvm_vm_ioctl_enable_cap_generic():
> > 
> >       case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
> >            if (kvm->dirty_ring_size)
> >                 return -EINVAL;
> >            kvm->dirty_ring_allow_bitmap = true;
> >            return 0;
> > 
> > A side effect of checking dirty_ring_size is then we'll be sure to have no
> > vcpu created too.  Maybe we should also check no memslot created to make
> > sure the bitmaps are not created.
> 
> I'm not sure I follow... What prevents userspace from creating a vCPU
> between enabling the two caps?

Enabling of dirty ring requires no vcpu created, so as to make sure all the
vcpus will have the ring structures allocated as long as ring enabled for
the vm.  Done in kvm_vm_ioctl_enable_dirty_log_ring():

	if (kvm->created_vcpus) {
		/* We don't allow to change this value after vcpu created */
		r = -EINVAL;
	} else {
		kvm->dirty_ring_size = size;
		r = 0;
	}

Then if we have KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP checking
dirty_ring_size first then we make sure we need to configure both
ALLOW_BITMAP and DIRTY_RING before any vcpu creation.

> 
> > Then if the userspace wants to use the bitmap altogether with the ring, it
> > needs to first detect KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP and enable it
> > before it enables KVM_CAP_DIRTY_LOG_RING.
> > 
> > One trick on ALLOW_BITMAP is in mark_page_dirty_in_slot() - after we allow
> > !vcpu case we'll need to make sure it won't accidentally try to set bitmap
> > for !ALLOW_BITMAP, because in that case the bitmap pointer is NULL so
> > set_bit_le() will directly crash the kernel.
> > 
> > We could keep the old flavor of having a WARN_ON_ONCE(!vcpu &&
> > !ALLOW_BITMAP) then return, but since now the userspace can easily trigger
> > this (e.g. on ARM, a malicious userapp can have DIRTY_RING &&
> > !ALLOW_BITMAP, then it can simply trigger the gic ioctl to trigger host
> > warning), I think the better approach is we can kill the process in that
> > case.  Not sure whether there's anything better we can do.
> 
> I don't believe !ALLOW_BITMAP && DIRTY_RING is a valid configuration for
> arm64 given the fact that we'll dirty memory outside of a vCPU context.

Yes it's not, but after Gavin's current series it'll be possible, IOW a
malicious app can leverage this to trigger host warning, which is IMHO not
wanted.

> 
> Could ALLOW_BITMAP be a requirement of DIRTY_RING, thereby making
> userspace fail fast? Otherwise (at least on arm64) your VM is DOA on the
> target. With that the old WARN() could be preserved, as you suggest.

It's just that x86 doesn't need the bitmap, so it'll be a pure waste there
otherwise.  It's not only about the memory that will be wasted (that's
guest mem size / 32k), but also the sync() process for x86 will be all
zeros and totally meaningless - note that the sync() of bitmap will be part
of VM downtime in this case (we need to sync() after turning VM off), so it
will make x86 downtime larger but without any benefit.

> On
> top of that there would no longer be a need to test for memslot creation
> when userspace attempts to enable KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
