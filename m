Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372E6D51D
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667833184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jy1W2Zwe6he4HbJK9B8iLKMm4sMa6WQweJz7/7vvFfM=;
	b=Cj9T/g/eQZJXGagPOEh1tyANa+cA5PrZbeCrxyW/Nt4pd/eTq/L5OqvZr5Tn9xbSmwB+1I
	IqccVPg8NdknDD78RoPSSvfkluPCs6nznWIxUq6QVfibleDHTc8tNSVUrwz9uRLwC5vcuK
	ZApVf2mGB0AXdGLCcH6a7+Z8clGUF6g=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-360-8s9bmjZyOTCKADgTLPmX-g-1; Mon, 07 Nov 2022 09:59:43 -0500
X-MC-Unique: 8s9bmjZyOTCKADgTLPmX-g-1
Received: by mail-qt1-f197.google.com with SMTP id f4-20020a05622a114400b003a57f828277so3241235qty.22
        for <kvmarm@lists.linux.dev>; Mon, 07 Nov 2022 06:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jy1W2Zwe6he4HbJK9B8iLKMm4sMa6WQweJz7/7vvFfM=;
        b=0V0hvliJB+BM7vNBgIYfnkpaWxVm5C/RAb7WB8YqvYDTySazdqGAAQt4UJFDCDW35u
         ntszx5/x88lqpamfaW1OXDzkk4IsFlvBMgMHYUQS9hWgxhlwxFQ3m4KN65SVCuVmWm4F
         joOEnLfPsDssOJQ8WdvTNsWm+4bu6Oe9l0C072dzKDzVFNP29aMGW7n7lU+1kDQWNIll
         VEVjO3mNn6TOtsiEB2H4a36q0N8oSsgoRSJy6SzpRXWTeUMqgcyyw/sU4azXt1Hum+Sm
         RhbvqIOrPyBmjO4tCbFm5nkD5pU9LrWHxsqy01xEQG2+i0HSGe+EvA4HrwSZyz89lYLd
         vWTA==
X-Gm-Message-State: ACrzQf0i00uXfjyU/UQ1CMBHheNP2MKbdYEHr4cJFaDl+n9nnJVsNLBf
	UjFyPxqAmtZsB1S7lwxy9Qtk5xUT76A++OMbJcPF4EIHIjv/k75KLALLygfKwJw7yyobS/qyBiK
	BxfNjWOaX+kSGamrH
X-Received: by 2002:a05:620a:4713:b0:6fa:330c:fb05 with SMTP id bs19-20020a05620a471300b006fa330cfb05mr734573qkb.73.1667833183466;
        Mon, 07 Nov 2022 06:59:43 -0800 (PST)
X-Google-Smtp-Source: AMsMyM65yBkuWsX7foV0D07w/+0OUFO1k03g8uWqP5eTrlq70LuV1+/X8Nl2aCAIrOhqBUEvgBBIiQ==
X-Received: by 2002:a05:620a:4713:b0:6fa:330c:fb05 with SMTP id bs19-20020a05620a471300b006fa330cfb05mr734561qkb.73.1667833183175;
        Mon, 07 Nov 2022 06:59:43 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id g10-20020a05620a40ca00b006f3e6933bacsm7057304qko.113.2022.11.07.06.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 06:59:42 -0800 (PST)
Date: Mon, 7 Nov 2022 09:59:41 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org,
	catalin.marinas@arm.com, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
	will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2kdXTn6X3O08sFv@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org>
 <Y2ffRYoqlQOxgVtk@x1n>
 <87iljrg7vd.wl-maz@kernel.org>
 <Y2gh4x4MD8BJvogH@x1n>
 <867d07qfvk.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <867d07qfvk.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221107145941.sz9kKIBeSuzcyRyaoE6oAG5rVDnComTaWlNV7aIHrCE@z>

On Mon, Nov 07, 2022 at 09:21:35AM +0000, Marc Zyngier wrote:
> On Sun, 06 Nov 2022 21:06:43 +0000,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Sun, Nov 06, 2022 at 08:12:22PM +0000, Marc Zyngier wrote:
> > > Hi Peter,
> > > 
> > > On Sun, 06 Nov 2022 16:22:29 +0000,
> > > Peter Xu <peterx@redhat.com> wrote:
> > > > 
> > > > Hi, Marc,
> > > > 
> > > > On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
> > > > > > +Note that the bitmap here is only a backup of the ring structure, and
> > > > > > +normally should only contain a very small amount of dirty pages, which
> > > > > 
> > > > > I don't think we can claim this. It is whatever amount of memory is
> > > > > dirtied outside of a vcpu context, and we shouldn't make any claim
> > > > > regarding the number of dirty pages.
> > > > 
> > > > The thing is the current with-bitmap design assumes that the two logs are
> > > > collected in different windows of migration, while the dirty log is only
> > > > collected after the VM is stopped.  So collecting dirty bitmap and sending
> > > > the dirty pages within the bitmap will be part of the VM downtime.
> > > > 
> > > > It will stop to make sense if the dirty bitmap can contain a large portion
> > > > of the guest memory, because then it'll be simpler to just stop the VM,
> > > > transfer pages, and restart on dest node without any tracking mechanism.
> > > 
> > > Oh, I absolutely agree that the whole vcpu dirty ring makes zero sense
> > > in general. It only makes sense if the source of the dirty pages is
> > > limited to the vcpus, which is literally a corner case. Look at any
> > > real machine, and you'll quickly realise that this isn't the case, and
> > > that DMA *is* a huge source of dirty pages.
> > > 
> > > Here, we're just lucky enough not to have much DMA tracking yet. Once
> > > that happens (and I have it from people doing the actual work that it
> > > *is* happening), you'll realise that the dirty ring story is of very
> > > limited use. So I'd rather drop anything quantitative here, as this is
> > > likely to be wrong.
> > 
> > Is it a must that arm64 needs to track device DMAs using the same dirty
> > tracking interface rather than VFIO or any other interface?
> 
> What does it change? At the end of the day, you want a list of dirty
> pages. How you obtain it is irrelevant.
> 
> > It's
> > definitely not the case for x86, but if it's true for arm64, then could the
> > DMA be spread across all the guest pages?  If it's also true, I really
> > don't know how this will work..
> 
> Of course, all pages can be the target of DMA. It works the same way
> it works for the ITS: you sync the state, you obtain the dirty bits,
> you move on.
> 
> And mimicking what x86 does is really not my concern (if you still
> think that arm64 is just another flavour of x86, stay tuned!  ;-).

I didn't mean so, I should probably stop mentioning x86. :)

I had some sense already from the topics in past few years of kvm forum.
Yeah I'll be looking forward to anything more coming.

> 
> > 
> > We're only syncing the dirty bitmap once right now with the protocol.  If
> > that can cover most of the guest mem, it's same as non-live.  If we sync it
> > periodically, then it's the same as enabling dirty-log alone and the rings
> > are useless.
> 
> I'm glad that you finally accept it: the ring *ARE* useless in the
> general sense. Only limited, CPU-only workloads can make any use of
> the current design. This probably covers a large proportion of what
> the cloud vendors do, but this doesn't work for general situations
> where you have a stream of dirty pages originating outside of the
> CPUs.

The ring itself is really not the thing to blame, IMHO it's a good attempt
to try out de-coupling guest size in regard of dirty tracking from kvm.  It
may not be perfect, but it may still service some of the goals, e.g., at
least it allows the user app to detect per-vcpu information and also since
there's the ring full events we can do something more than before like the
vcpu throttling that China Telecom does with the ring structures.

But I agree it's not a generic enough solution.  Hopefully it'll still
cover some use cases so it's not completely not making sense.

Thanks,

-- 
Peter Xu

