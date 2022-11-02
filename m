Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A75A7461
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667406202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5byMHFaExyjDBXydjU2vjfyJkptyvIyynTJvAWyAxJc=;
	b=K9ftRss7148fT6cuCnC6QfFmMVsFBPXt09trWXkjmAjW0aAJMC7nOKsJZy71XlKazbEvAS
	cYoJqp+1LL7XeoeS+iJKBhXazausNu57dbN3uBiu8xsGSb9DuciR7ntGr0zkHRaVOro7Y6
	67K4cwGnl/wS+FHGeh0ii2FmasOUqhs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-481-4VgQ7IHHPrqe6B1eabstCg-1; Wed, 02 Nov 2022 12:23:21 -0400
X-MC-Unique: 4VgQ7IHHPrqe6B1eabstCg-1
Received: by mail-qk1-f198.google.com with SMTP id w4-20020a05620a444400b006fa24b2f394so9350022qkp.15
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 09:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5byMHFaExyjDBXydjU2vjfyJkptyvIyynTJvAWyAxJc=;
        b=kxb5vP1c90x/hsjHXTRbS+YxnXybtIZYQ+7l+9ttp+TEslxbLWuIOYJegvrdD5NiMC
         j4ECXaNbgyUp77sGVnTAKqUHTUL/TF00jJYOSZHdIS0eeH+wG6+V4jCs9sZxX+YTKkvz
         EDCbJkL+1tOvChNXGuadIjJLIgzi63Rpzzv3o3Q50YzOG6aqaCBWS4+mM/baXv8k6bTD
         BU302DSQI44D2Tk+Pv/END0zD/Tf5E6bRlvObeKU1amQdRVL4vz+mUVyrIqMp5/F5+Ae
         e7SvhC942d0uOtjH1rcgUqGVhYBo0fWI+vEljd9vv7UOg6LAcoJLOb9G9h0PjQ96E21b
         izkQ==
X-Gm-Message-State: ACrzQf2rmZg0amzKbot0fl6yExto5Xqv2VZav6h7eJ04jk1/PFhIDD6b
	KIIw1h1GEly6muRIaTjDIeRn04DlFOS8LjT3yqKUlWiaZq9vJFIkFYSBwBnswPbJgB0scAbNVjR
	gxW7RN4EjTyP23iZb
X-Received: by 2002:a05:622a:ca:b0:3a5:24d2:9295 with SMTP id p10-20020a05622a00ca00b003a524d29295mr14748781qtw.300.1667406199192;
        Wed, 02 Nov 2022 09:23:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6EpjURP1I5j6n6rF3l05q9tySy58y2y7M9A2JRR097icY3iLQyUWI+2g5g7C6S/Ehg5hZGpQ==
X-Received: by 2002:a05:622a:ca:b0:3a5:24d2:9295 with SMTP id p10-20020a05622a00ca00b003a524d29295mr14748754qtw.300.1667406198900;
        Wed, 02 Nov 2022 09:23:18 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id s16-20020a05620a255000b006ee7923c187sm8903281qko.42.2022.11.02.09.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:23:18 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:23:16 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Gavin Shan <gshan@redhat.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, oliver.upton@linux.dev, james.morse@arm.com,
	shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KZdDAQN4889W9V@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <867d0de4b0.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221102162316.PTkeFRSkKV-WYONZcT0nyUjy3dEvgP8-_CZkn-VT3rg@z>

On Wed, Nov 02, 2022 at 03:58:43PM +0000, Marc Zyngier wrote:
> On Wed, 02 Nov 2022 14:29:26 +0000,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Tue, Nov 01, 2022 at 07:39:25PM +0000, Sean Christopherson wrote:
> > > > @@ -142,13 +144,17 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > > >  
> > > >  	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > > >  
> > > > +	if (!kvm_dirty_ring_soft_full(ring))
> > > > +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> > > > +
> > > 
> > > Marc, Peter, and/or Paolo, can you confirm that clearing the
> > > request here won't cause ordering problems?  Logically, this makes
> > > perfect sense (to me, since I suggested it), but I'm mildly
> > > concerned I'm overlooking an edge case where KVM could end up with
> > > a soft-full ring but no pending request.
> > 
> > I don't see an ordering issue here, as long as kvm_clear_request() is using
> > atomic version of bit clear, afaict that's genuine RMW and should always
> > imply a full memory barrier (on any arch?) between the soft full check and
> > the bit clear.  At least for x86 the lock prefix was applied.
> 
> No, clear_bit() is not a full barrier. It only atomic, and thus
> completely unordered (see Documentation/atomic_bitops.txt). If you
> want a full barrier, you need to use test_and_clear_bit().

Right, I mixed it up again. :(  It's genuine RMW indeed (unlike _set/_read)
but I forgot it needs to have a retval to have the memory barriers.

Quotting atomic_t.rst:

---8<---
ORDERING  (go read memory-barriers.txt first)
--------

The rule of thumb:

 - non-RMW operations are unordered;

 - RMW operations that have no return value are unordered;

 - RMW operations that have a return value are fully ordered;

 - RMW operations that are conditional are unordered on FAILURE,
   otherwise the above rules apply.
---8<---

Bit clear unordered.

> 
> > 
> > However I don't see anything stops a simple "race" to trigger like below:
> > 
> >           recycle thread                   vcpu thread
> >           --------------                   -----------
> >       if (!dirty_ring_soft_full)                                   <--- not full
> >                                         dirty_ring_push();
> >                                         if (dirty_ring_soft_full)  <--- full due to the push
> >                                             set_request(SOFT_FULL);
> >           clear_request(SOFT_FULL);                                <--- can wrongly clear the request?
> >
> 
> Hmmm, well spotted. That's another ugly effect of the recycle thread
> playing with someone else's toys.
> 
> > But I don't think that's a huge matter, as it'll just let the vcpu to have
> > one more chance to do another round of KVM_RUN.  Normally I think it means
> > there can be one more dirty GFN (perhaps there're cases that it can push >1
> > gfns for one KVM_RUN cycle?  I never figured out the details here, but
> > still..) pushed to the ring so closer to the hard limit, but we have had a
> > buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
> > that's still fine, but maybe worth a short comment here?
> > 
> > I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
> > cycle.  It would be good if there's an answer to that from anyone.
> 
> This is dangerous, and I'd rather not go there.
> 
> It is starting to look like we need the recycle thread to get out of
> the way. And to be honest:
> 
> +	if (!kvm_dirty_ring_soft_full(ring))
> +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> 
> seems rather superfluous. Only clearing the flag in the vcpu entry
> path feels much saner, and I can't see anything that would break.
> 
> Thoughts?

Sounds good here.

Might be slightly off-topic: I didn't quickly spot how do we guarantee two
threads doing KVM_RUN ioctl on the same vcpu fd concurrently.  I know
that's insane and could have corrupted things, but I just want to make sure
e.g. even a malicious guest app won't be able to trigger host warnings.

-- 
Peter Xu

