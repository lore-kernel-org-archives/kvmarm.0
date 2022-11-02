Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B007C43217
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:23:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA014B95B;
	Wed,  2 Nov 2022 12:23:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rKDRc0zeHGgT; Wed,  2 Nov 2022 12:23:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92E4E4B962;
	Wed,  2 Nov 2022 12:23:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6264B95B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:23:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bdpiu5jgmm-h for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 12:23:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3742E4B95A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:23:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667406200;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5byMHFaExyjDBXydjU2vjfyJkptyvIyynTJvAWyAxJc=;
 b=DdYoU46mosBTy9xZVhbLcrXfMTN3YbXAdo4hWgnkjqAGRB/tgQJLKGv3Z7xKTqE59D20sy
 oLpRhZ2RIXPIJHAwBF6ZWfm9Tcqkpm84wpKBN8J0SmEUIPZ5qgF8iqVEWFVygaQgjDlxbu
 2qtvpjMoEg5fR2U+dKZsrX6557ZlnfY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-81-ZtM9r9BGPQO5IKvD3vDacg-1; Wed, 02 Nov 2022 12:23:19 -0400
X-MC-Unique: ZtM9r9BGPQO5IKvD3vDacg-1
Received: by mail-qk1-f198.google.com with SMTP id
 bq13-20020a05620a468d00b006fa5a75759aso2381820qkb.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 09:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=5byMHFaExyjDBXydjU2vjfyJkptyvIyynTJvAWyAxJc=;
 b=hxivlTJRBuUKsmnaz4+xtUPRx1BNBn9fSTQjS/0l4HziS3mIznkzCG/mCazInGLoLB
 DOVicfxviklIosyc1xCFlmWvK+x7e6JCjmheqERSYTQhkAPW2fjYDpNxdvFdCcjYDNBd
 WM+GSL6fxfUC4tdjyzDr6LK3XLhWN2aXLq6tn5i77ZznpNtaQgZKkv+TsInCF0w4QPmx
 Fo3o8kzAVo47YfXH6UPAdUz1Lz8MyMl8yZJO0YnmP1xuf4UUGkHPTUZ4DXEN79053BV9
 Z8T9Qc0PLTe56fT21S/W1Cpch6RCgHwpMYGb87B2IQN/REad1hLJHWvipqPPAOM1Cizk
 f5PQ==
X-Gm-Message-State: ACrzQf2JUAQwDPzJ0uxdvG+tULbbU+rsbIe9zBXAswOhT0b8g7afEV6+
 g4+/SHRwr98an/MY0Q9UGroK/mDtjukt84HjJQg0KuO6mf8w0lkEflELUx4rHQ/qfi0Jay229qS
 lb9H4XENRIz9UasTMMG4Oq0KG
X-Received: by 2002:a05:622a:ca:b0:3a5:24d2:9295 with SMTP id
 p10-20020a05622a00ca00b003a524d29295mr14748780qtw.300.1667406199189; 
 Wed, 02 Nov 2022 09:23:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6EpjURP1I5j6n6rF3l05q9tySy58y2y7M9A2JRR097icY3iLQyUWI+2g5g7C6S/Ehg5hZGpQ==
X-Received: by 2002:a05:622a:ca:b0:3a5:24d2:9295 with SMTP id
 p10-20020a05622a00ca00b003a524d29295mr14748754qtw.300.1667406198900; 
 Wed, 02 Nov 2022 09:23:18 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 s16-20020a05620a255000b006ee7923c187sm8903281qko.42.2022.11.02.09.23.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 09:23:18 -0700 (PDT)
Date: Wed, 2 Nov 2022 12:23:16 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2KZdDAQN4889W9V@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com> <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <867d0de4b0.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: shuah@kernel.org, kvm@vger.kernel.org, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
