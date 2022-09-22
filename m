Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED977C6FA8B
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 21:38:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4151743479;
	Thu, 22 Sep 2022 17:38:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Boj3zJbbkqo; Thu, 22 Sep 2022 17:38:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFDC24B278;
	Thu, 22 Sep 2022 17:38:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ADD64B0B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 17:38:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y6KjslDl6pHS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 17:38:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 167D343479
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 17:38:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663882719;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5JPX9T3GffPiHLyk9fM4X6AeVbPQqd4lfCm5aE7/aWU=;
 b=PzTD1CsgeBqiRU2GjWGTDZ85VD98loVDW0rBbEhQz9d/Vw34F4m9jOUY5fwbKhXlLpurUa
 2W1lBkCP9DrFb/RNO18q8qnkP05xfjefsmKkSUyaQcYLBoiJEkns8F6hABpip6SvARyDwp
 ynkxkxHxLR0jYyo0GHXXKUoXlEtG0dk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-sSbqAipIMuOXc8EKfXB74Q-1; Thu, 22 Sep 2022 17:38:36 -0400
X-MC-Unique: sSbqAipIMuOXc8EKfXB74Q-1
Received: by mail-qt1-f199.google.com with SMTP id
 g21-20020ac87d15000000b0035bb6f08778so7289463qtb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 14:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=5JPX9T3GffPiHLyk9fM4X6AeVbPQqd4lfCm5aE7/aWU=;
 b=Sit/m6XGtazU0LIhVoXo5VMrjKc9KY59Ul+gjJdKALE1T3zAd+g8CTcDz/EhPsYkxL
 WlKnoyktUjA+vCQwq5WBq2U5QXO7DAWyVUmr8m+maAKEuSnUSWVbCu955VzfvrxoguJE
 HUSERBkkIvWcyEpjqjrZJY9dWchXlBAPBTgq2KAAGDnB0KqXwDrJEzo97/Ovci68bM+Z
 z0BxJG+JENREzEdJKLreYZPT5G/uhOpElIRiiNUTP39BLaGg96xKqSnAfjt8ZBTSrgyu
 OyI27txixxE+vPog3HUltqhzRzknEL+OgjB2p2fhgfvLcmXlqxLQCkVOGiVRHoAwTuKM
 7F8g==
X-Gm-Message-State: ACrzQf1h5SOsz3Swkv31hDvvjT3ZF/eRfqLL5DFKzwQUA3e+1pLRzNtx
 KGJXFHFKHPJJHU0p4PCW4m33LWwXgqpnnuhxK1pqj2ngxH1ekgcRUYROFsneLDLpr97SE1jpjFR
 XEZQ6fnGtZYRD3CgIDkEQm9/s
X-Received: by 2002:a05:620a:4310:b0:6ac:f9df:178d with SMTP id
 u16-20020a05620a431000b006acf9df178dmr3774139qko.773.1663882716041; 
 Thu, 22 Sep 2022 14:38:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4qBEL/j/DDcPndb3DepYOWe7ejxJsC+h3kQ6awmPMWBQWkJ+uc6sTX86CekI2Kuv9RnfMq2g==
X-Received: by 2002:a05:620a:4310:b0:6ac:f9df:178d with SMTP id
 u16-20020a05620a431000b006acf9df178dmr3774128qko.773.1663882715822; 
 Thu, 22 Sep 2022 14:38:35 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
 by smtp.gmail.com with ESMTPSA id
 cp4-20020a05622a420400b0035cdd7a42d0sm3969804qtb.22.2022.09.22.14.38.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Sep 2022 14:38:35 -0700 (PDT)
Date: Thu, 22 Sep 2022 17:38:33 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/6] KVM: Use acquire/release semantics when accessing
 dirty ring GFN state
Message-ID: <YyzV2Q/PZHPFMD6y@xz-m1.local>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-2-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220922170133.2617189-2-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

Marc,

On Thu, Sep 22, 2022 at 06:01:28PM +0100, Marc Zyngier wrote:
> The current implementation of the dirty ring has an implicit requirement
> that stores to the dirty ring from userspace must be:
> 
> - be ordered with one another
> 
> - visible from another CPU executing a ring reset
> 
> While these implicit requirements work well for x86 (and any other
> TSO-like architecture), they do not work for more relaxed architectures
> such as arm64 where stores to different addresses can be freely
> reordered, and loads from these addresses not observing writes from
> another CPU unless the required barriers (or acquire/release semantics)
> are used.
> 
> In order to start fixing this, upgrade the ring reset accesses:
> 
> - the kvm_dirty_gfn_harvested() helper now uses acquire semantics
>   so it is ordered after all previous writes, including that from
>   userspace
> 
> - the kvm_dirty_gfn_set_invalid() helper now uses release semantics
>   so that the next_slot and next_offset reads don't drift past
>   the entry invalidation
> 
> This is only a partial fix as the userspace side also need upgrading.

Paolo has one fix 4802bf910e ("KVM: dirty ring: add missing memory
barrier", 2022-09-01) which has already landed.

I think the other one to reset it was lost too.  I just posted a patch.

https://lore.kernel.org/qemu-devel/20220922213522.68861-1-peterx@redhat.com/
(link still not yet available so far, but should be)

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/dirty_ring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index f4c2a6eb1666..784bed80221d 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -79,12 +79,12 @@ static inline void kvm_dirty_gfn_set_invalid(struct kvm_dirty_gfn *gfn)
>  
>  static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
>  {
> -	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
> +	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_DIRTY);

IIUC you meant kvm_dirty_gfn_set_invalid as the comment says?

kvm_dirty_gfn_set_dirtied() has been guarded by smp_wmb() and AFAICT that's
already safe.  Otherwise looks good to me.

Thanks,

>  }
>  
>  static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>  {
> -	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
> +	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
>  }
>  
>  int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> -- 
> 2.34.1
> 

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
