Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29430C2D0BF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 16:18:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A820324650
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 16:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g8pcMqM8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A820324650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D9054A946;
	Wed, 18 Dec 2019 11:18:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VWPm75xGEhsu; Wed, 18 Dec 2019 11:18:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2DE44A610;
	Wed, 18 Dec 2019 11:18:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87FA44A4C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 11:18:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FVmotzQgY2mT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 11:18:00 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FA264A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 11:18:00 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576685880;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=y1PryEe1hkgiN96jrfgxLd4JsIip+8pRLtpoZJ1ZmPc=;
 b=g8pcMqM84ihuzUSdjUdlrO21vWYdWYI54wbX0AcJX602lH8u7u8fm7o0/8fA0Xc/8JX40S
 Pi622wSXW/DJihh/acnsw8MxPwmwYPb4EsApA9piZG2HavADCTkhScCzVhkHmdlgpIr6u7
 x79St/xISiMX0wfztkc9WBc8nCNBv0k=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-u-83NfwzMGOwM7poKch9MA-1; Wed, 18 Dec 2019 11:17:58 -0500
Received: by mail-qt1-f198.google.com with SMTP id d18so1693829qtp.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 08:17:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=P88rx9cd9kQKZ8dguxvhOHW4MjtfLZb0Tzz3Us5jasg=;
 b=QKCPyiJjDnnDoU5+Hq7J0p0a0J2iRmhqjg7ydvv2ZDSt+n7r7ibPKcB7Kob1IGIN9V
 KkKjWJnmMy+sY98zyul3IAVHeucU64iR2ENWucpoy3Ooj+dMB9S4TZTKQM5UuCE1i4lI
 uhxuosxpekmrXm7BA0H9gZGEMr3WMetTxeBoSd4CZNhq5HWjE5HJE0kIcLKvZrFDIHKm
 0xtxUyc7xvBTMJs25H9qs3vIY7VRd8Kk10A1V93XexBq+b9xgceOPjLTuvoPTRdScNa+
 nJtlwTCGY6SxoSgYy9rwgmzyN5F0TM3V4+Q5F/3HC3KGr6Qb0wBgSCgrdv1cZBQtnpat
 DU5A==
X-Gm-Message-State: APjAAAUm0E6NoAyk/l4cVA8PCJY1z6diARIYSOqw5h92bF25S5cuE4by
 6N8HsQJ01Wxbvboolwova8jqaDg/XooNwV3Vz20xVP4BAb5HgChKpqVWdgdpTfc+Jy9XMxjBQ18
 R1V1mhU9Bf37sLrJr3Y8TwIzB
X-Received: by 2002:ac8:7a70:: with SMTP id w16mr2877830qtt.154.1576685877627; 
 Wed, 18 Dec 2019 08:17:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqy4qHGhFCQSr/jP29aEubtfbaj7wEV9G/hOTID6lKw6YyGvv0dEeZDPR8BH6CrL2bXiQvdTHQ==
X-Received: by 2002:ac8:7a70:: with SMTP id w16mr2877791qtt.154.1576685877330; 
 Wed, 18 Dec 2019 08:17:57 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
 by smtp.gmail.com with ESMTPSA id o16sm769610qkj.91.2019.12.18.08.17.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Dec 2019 08:17:56 -0800 (PST)
Date: Wed, 18 Dec 2019 11:17:55 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 07/19] KVM: Explicitly free allocated-but-unused dirty
 bitmap
Message-ID: <20191218161755.GB26669@xz-x1>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-8-sean.j.christopherson@intel.com>
 <20191217222446.GK7258@xz-x1>
 <20191217225118.GF11771@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191217225118.GF11771@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: u-83NfwzMGOwM7poKch9MA-1
X-Mimecast-Spam-Score: 0
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
 kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
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

On Tue, Dec 17, 2019 at 02:51:18PM -0800, Sean Christopherson wrote:
> On Tue, Dec 17, 2019 at 05:24:46PM -0500, Peter Xu wrote:
> > On Tue, Dec 17, 2019 at 12:40:29PM -0800, Sean Christopherson wrote:
> > > Explicitly free an allocated-but-unused dirty bitmap instead of relying
> > > on kvm_free_memslot() if an error occurs in __kvm_set_memory_region().
> > > There is no longer a need to abuse kvm_free_memslot() to free arch
> > > specific resources as arch specific code is now called only after the
> > > common flow is guaranteed to succeed.  Arch code can still fail, but
> > > it's responsible for its own cleanup in that case.
> > > 
> > > Eliminating the error path's abuse of kvm_free_memslot() paves the way
> > > for simplifying kvm_free_memslot(), i.e. dropping its @dont param.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  virt/kvm/kvm_main.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index d403e93e3028..6b2261a9e139 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -1096,7 +1096,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >  
> > >  	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> > >  	if (!slots)
> > > -		goto out_free;
> > > +		goto out_bitmap;
> > >  	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
> > >  
> > >  	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> > > @@ -1144,8 +1144,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> > >  		slots = install_new_memslots(kvm, as_id, slots);
> > >  	kvfree(slots);
> > > -out_free:
> > > -	kvm_free_memslot(kvm, &new, &old);
> > > +out_bitmap:
> > > +	if (new.dirty_bitmap && !old.dirty_bitmap)
> > > +		kvm_destroy_dirty_bitmap(&new);
> > 
> > What if both the old and new have KVM_MEM_LOG_DIRTY_PAGES set?
> > kvm_free_memslot() did cover that but I see that you explicitly
> > dropped it.  Could I ask why?  Thanks,
> 
> In that case, old.dirty_bitmap == new.dirty_bitmap, i.e. shouldn't be freed
> by this error path since doing so would result in a use-after-free via the
> old memslot.
> 
> The kvm_free_memslot() logic is the same, albeit in a very twisted way.

Yes it is. :)

> 
> In __kvm_set_memory_region(), @old and @new start with the same dirty_bitmap.
> 
> 	new = old = *slot;
> 
> And @new is modified based on KVM_MEM_LOG_DIRTY_PAGES.  If LOG_DIRTY_PAGES
> is set in both @new and @old, then both the "if" and "else if" evaluate
> false, i.e. new.dirty_bitmap == old.dirty_bitmap.
> 
> 	/* Allocate/free page dirty bitmap as needed */
> 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
> 		new.dirty_bitmap = NULL;
> 	else if (!new.dirty_bitmap) {
> 		r = kvm_create_dirty_bitmap(&new);
> 		if (r)
> 			return r;
> 	}
> 
> Subbing "@free <= @new" and "@dont <= @old" in kvm_free_memslot()
> 
>   static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
> 			       struct kvm_memory_slot *dont)
>   {
> 	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
> 		kvm_destroy_dirty_bitmap(free);
> 
> 
> yeids this, since @old is obviously non-NULL
> 
> 	if (new.dirty_bitmap != old.dirty_bitmap)
> 		kvm_destroy_dirty_bitmap(&new);
> 
> The dirty_bitmap allocation logic guarantees that new.dirty_bitmap is
>   a) NULL (the "if" case")
>   b) != old.dirty_bitmap iff old.dirty_bitmap == NULL (the "else if" case)
>   c) == old.dirty_bitmap (the implicit "else" case).
> 
> kvm_free_memslot() frees @new.dirty_bitmap iff its != @old.dirty_bitmap,
> thus the explicit destroy only needs to check for (b).

Thanks for explaining with such a detail.

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
