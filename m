Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5B2912
	for <kvmarm@lists.linux.dev>; Wed,  2 Nov 2022 14:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667399372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ps9cbOxn8myNQkKIEtCMET8fcnuAnpf2+gT/tQF2P5Q=;
	b=V67i33ud27R9qgMVFmMtF3uxltamfrgq3QEg1jFSZUPMZYQKMeXHj5kb6ERKROPL4C7XOq
	kZbq0C2eUxChtdDIuU2GYqniXT8LWY5sh76mkNbirjoBAsGTlllJgxk9934freiCKpxRr8
	MPiLxxI57kboqLZG9u7GyqUxc9yNVsw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-sey7rR1SPj6ye091iuONMA-1; Wed, 02 Nov 2022 10:29:29 -0400
X-MC-Unique: sey7rR1SPj6ye091iuONMA-1
Received: by mail-qv1-f69.google.com with SMTP id b2-20020a0cfe62000000b004bbfb15297dso4943041qvv.19
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 07:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ps9cbOxn8myNQkKIEtCMET8fcnuAnpf2+gT/tQF2P5Q=;
        b=ImdW0FTnR82/wIegIq7VnYzoRGmSXXXeQ7AWpOTQQ85K+ZOXQNRTCXwEDMzMSJt5Jl
         bOXtPv/NDoQgp6If9Tz4yE1PdAXbe0ugRFIvoH+gCNMg1WfxeFv5VZmyl/DDu6BwSCMr
         cgl2jiVgq7tVYGzlW0Pmy3us7eGWPxS5R5+dvXt+37CPDZ9H7wzpIo70YpYiaRtLFweJ
         Ir0fTxoRPvlyqqb8KQHWTAr7qYopVWPgUOs0BgqDAK2ZzCPS7NqMx/hxUukW6DEF1Q/V
         o1MB8RA1xhCLutiyVHIZQQ6bkJnfY+w5MwqZyfMnZq3OC4E2ZRKA8b7u3pRYSiCmtAvF
         TWIQ==
X-Gm-Message-State: ACrzQf0yM2DOiuvsQMkqPsQXsNlRgTU/mEajbTiQxfikaxX7McyYmBtR
	4YNmrXWj2cqyWLbnHC3HreqRET9ve/5xw/YCbJw0Ris6lmu6p526kpPdR+6itjCam3r2h7uVtNM
	Xg9uqb2gqRypcoZ1H
X-Received: by 2002:a05:620a:f82:b0:6f9:d795:3f10 with SMTP id b2-20020a05620a0f8200b006f9d7953f10mr17162265qkn.675.1667399369235;
        Wed, 02 Nov 2022 07:29:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HQSoT03q9RYt45NNK062Snoc6XJiiqn2B5bpIZKFd3P+Iejj5f4Pza1S6pf/FRJShrYUf4w==
X-Received: by 2002:a05:620a:f82:b0:6f9:d795:3f10 with SMTP id b2-20020a05620a0f8200b006f9d7953f10mr17162243qkn.675.1667399368917;
        Wed, 02 Nov 2022 07:29:28 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id ez5-20020a05622a4c8500b0039c37a7914csm6626967qtb.23.2022.11.02.07.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 07:29:28 -0700 (PDT)
Date: Wed, 2 Nov 2022 10:29:26 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
	andrew.jones@linux.dev, ajones@ventanamicro.com, maz@kernel.org,
	bgardon@google.com, catalin.marinas@arm.com, dmatlack@google.com,
	will@kernel.org, pbonzini@redhat.com, oliver.upton@linux.dev,
	james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2J+xhBYhqBI81f7@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y2F17Y7YG5Z9XnOJ@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Message-ID: <20221102142926.v_2e-vr2mI3OeCjHWXpD1NhrikfiDj6A7-Z-FwgAI2o@z>

On Tue, Nov 01, 2022 at 07:39:25PM +0000, Sean Christopherson wrote:
> > @@ -142,13 +144,17 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> >  
> >  	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> >  
> > +	if (!kvm_dirty_ring_soft_full(ring))
> > +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> > +
> 
> Marc, Peter, and/or Paolo, can you confirm that clearing the request here won't
> cause ordering problems?  Logically, this makes perfect sense (to me, since I
> suggested it), but I'm mildly concerned I'm overlooking an edge case where KVM
> could end up with a soft-full ring but no pending request.

I don't see an ordering issue here, as long as kvm_clear_request() is using
atomic version of bit clear, afaict that's genuine RMW and should always
imply a full memory barrier (on any arch?) between the soft full check and
the bit clear.  At least for x86 the lock prefix was applied.

However I don't see anything stops a simple "race" to trigger like below:

          recycle thread                   vcpu thread
          --------------                   -----------
      if (!dirty_ring_soft_full)                                   <--- not full
                                        dirty_ring_push();
                                        if (dirty_ring_soft_full)  <--- full due to the push
                                            set_request(SOFT_FULL);
          clear_request(SOFT_FULL);                                <--- can wrongly clear the request?

But I don't think that's a huge matter, as it'll just let the vcpu to have
one more chance to do another round of KVM_RUN.  Normally I think it means
there can be one more dirty GFN (perhaps there're cases that it can push >1
gfns for one KVM_RUN cycle?  I never figured out the details here, but
still..) pushed to the ring so closer to the hard limit, but we have had a
buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
that's still fine, but maybe worth a short comment here?

I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
cycle.  It would be good if there's an answer to that from anyone.

-- 
Peter Xu

