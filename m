Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DAAC2BA83
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 20:39:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51B0020838
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 20:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHPFBQT7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51B0020838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF2314A536;
	Fri,  7 Feb 2020 15:39:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bbh96ttGldrM; Fri,  7 Feb 2020 15:39:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E8EE4A578;
	Fri,  7 Feb 2020 15:39:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C27E74A536
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 15:39:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id An0dTL53p3BI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 15:39:21 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FA604A4F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 15:39:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581107961;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X1l4t1zNZ8M+vg7KILfSizXL//pM0Z9deFieATlFd3k=;
 b=QHPFBQT7jojR4XE+Z18KA7Pv8mbmNksJB4obpDtL0QOzQhVhJgagBUua5/gZm7TtfPBGp/
 AnGPENjsb8z3TKCbLYQvYOTifHFE+I1yQGJcYnaDSSvTBdXOr6E1Pdv5H2C+rBKK482Nce
 0YnTu3TZ2Ap8I508WvvUGAuoO4SIqpE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237--iEmY_47O0encbyQqDKSBA-1; Fri, 07 Feb 2020 15:39:18 -0500
Received: by mail-qk1-f198.google.com with SMTP id 12so259939qkf.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 12:39:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HDJ/VjQrWMNdHQtja+MCN3Q9tHemN4hRWun5DjgIKoY=;
 b=HBMeWyVD2mjvANrBa/l41u7Kqky3F/YDZWXmZiZuwzhNNekyA3cu8GMK/NtoCrCKkc
 qMjHy+7hDd7bNrJY5FxRWYP1AvQifCqt+guk5ebHbZWX3F8LnbiIMu1jG7FYyCpdeN2Z
 Ck82TtzA8slygw2NqFD+6AcSIqDVCmaBotyfXD/vggOyxiSD9mcqw7aEz9Y/5DbhmyAq
 nPyWqaS6xaKDmrk02R9d5mHrlloTwWivCcLeMVuv1DIZ9cAPf8d6OeM4WwEMFIKw8sFJ
 WaPJW3mQrRJ3qWKaGrU2cIKBD1up+B5Xu3b8+k/FYsyt58OFy/KdHmQJIWni80KvybUU
 OMFQ==
X-Gm-Message-State: APjAAAWorTzazACQqX35i0kB9LiVSdUB7GGNukl54BtF5WZ8p6BK19Ee
 XS3WtYpLzkYOn4YLS78gGw5RhB/5HjcNGt9d0+431qtvZeyDFgi1moGxZZE7YV03oNTO2iv8x4/
 1qbNZbrQGGUttnKjG3UnVx7mJ
X-Received: by 2002:a05:620a:201d:: with SMTP id
 c29mr707087qka.91.1581107953745; 
 Fri, 07 Feb 2020 12:39:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqxQuu5qnyNVPYa+YqHICHyvrdUbVM/BEFf5AJFqCnQhpIOoL4uGjjInlTUcv67ProkOUC4n0Q==
X-Received: by 2002:a05:620a:201d:: with SMTP id
 c29mr707063qka.91.1581107953398; 
 Fri, 07 Feb 2020 12:39:13 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id h34sm2025258qtc.62.2020.02.07.12.39.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 12:39:12 -0800 (PST)
Date: Fri, 7 Feb 2020 15:39:09 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 17/19] KVM: Terminate memslot walks via used_slots
Message-ID: <20200207203909.GE720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-18-sean.j.christopherson@intel.com>
 <20200206210944.GD700495@xz-x1>
 <20200207183325.GI2401@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200207183325.GI2401@linux.intel.com>
X-MC-Unique: -iEmY_47O0encbyQqDKSBA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Fri, Feb 07, 2020 at 10:33:25AM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 04:09:44PM -0500, Peter Xu wrote:
> > On Tue, Jan 21, 2020 at 02:31:55PM -0800, Sean Christopherson wrote:
> > > @@ -9652,13 +9652,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > >  		if (IS_ERR((void *)hva))
> > >  			return PTR_ERR((void *)hva);
> > >  	} else {
> > > -		if (!slot->npages)
> > > +		if (!slot || !slot->npages)
> > >  			return 0;
> > >  
> > > -		hva = 0;
> > > +		hva = slot->userspace_addr;
> > 
> > Is this intended?
> 
> Yes.  It's possible to allow VA=0 for userspace mappings.  It's extremely
> uncommon, but possible.  Therefore "hva == 0" shouldn't be used to
> indicate an invalid slot.

Note that this is the deletion path in __x86_set_memory_region() not
allocation.  IIUC userspace_addr won't even be used in follow up code
path so it shouldn't really matter.  Or am I misunderstood somewhere?

> 
> > > +		old_npages = slot->npages;
> > >  	}
> > >  
> > > -	old = *slot;
> > >  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > >  		struct kvm_userspace_memory_region m;
> > >  
> 
> ...
> 
> > > @@ -869,63 +869,162 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
> > >  }
> > >  
> > >  /*
> > > - * Insert memslot and re-sort memslots based on their GFN,
> > > - * so binary search could be used to lookup GFN.
> > > - * Sorting algorithm takes advantage of having initially
> > > - * sorted array and known changed memslot position.
> > > + * Delete a memslot by decrementing the number of used slots and shifting all
> > > + * other entries in the array forward one spot.
> > > + */
> > > +static inline void kvm_memslot_delete(struct kvm_memslots *slots,
> > > +				      struct kvm_memory_slot *memslot)
> > > +{
> > > +	struct kvm_memory_slot *mslots = slots->memslots;
> > > +	int i;
> > > +
> > > +	if (WARN_ON(slots->id_to_index[memslot->id] == -1))
> > > +		return;
> > > +
> > > +	slots->used_slots--;
> > > +
> > > +	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
> > > +		mslots[i] = mslots[i + 1];
> > > +		slots->id_to_index[mslots[i].id] = i;
> > > +	}
> > > +	mslots[i] = *memslot;
> > > +	slots->id_to_index[memslot->id] = -1;
> > > +}
> > > +
> > > +/*
> > > + * "Insert" a new memslot by incrementing the number of used slots.  Returns
> > > + * the new slot's initial index into the memslots array.
> > > + */
> > > +static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
> > 
> > The naming here didn't help me to understand but a bit more
> > confused...
> > 
> > How about "kvm_memslot_insert_end"?  Or even unwrap it.
> 
> It's not guaranteed to be the end, as there could be multiple unused
> entries at the back of the array.  I agree the naming isn't perfect, but
> IMO it's the least crappy option and will be familiar to anyone with C++
> STL (and other languages?) experience.  Arguably it would be better to
> follow kernel naming for lists, e.g. head/tail, but there are no
> convenient adverbs for the move helpers, e.g. kvm_memslot_move_backward()
> would be kvm_memslot_move_towards_tail().
> 
> I'm very strongly opposed to unwrapping it.
> 
> The code would look like this.  Without a beefy comment, the high level
> semantics of the KVM_MR_CREATE case are not at all clear.  Adding a
> comment gets messy because putting it above the entire if-else makes it
> difficult to understand that its *only* for the CREATE case, and I hate
> having multi-line comments in if-else statements without brackets.
> 
>                 if (change == KVM_MR_CREATE)
>                         i = slots->used_slots++
>                 else
>                         i = kvm_memslot_move_backward(slots, memslot);

This is made too complicated, imho... A one-liner comment would be
clear enough to me.  :)

Please feel free to keep the original code as you wish.

> 
> > > +{
> > > +	return slots->used_slots++;
> > > +}
> > > +
> > > +/*
> > > + * Move a changed memslot backwards in the array by shifting existing slots
> > > + * with a higher GFN toward the front of the array.  Note, the changed memslot
> > > + * itself is not preserved in the array, i.e. not swapped at this time, only
> > > + * its new index into the array is tracked.  Returns the changed memslot's
> > > + * current index into the memslots array.
> > > + */
> > > +static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
> > > +					    struct kvm_memory_slot *memslot)
> > 
> > "backward" makes me feel like it's moving towards smaller index,
> > instead it's moving to bigger index.  Same applies to "forward" below.
> > I'm not sure whether I'm the only one, though...
> 
> Move forward towards the front, and backward towards the back.  In the
> languages I am familiar with, e.g. C++ STL, JavaScript, Python, and Golang,
> front==container[0] and back==container[len() - 1].

OK.

> 
> > > +{
> > > +	struct kvm_memory_slot *mslots = slots->memslots;
> > > +	int i;
> > > +
> > > +	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> > > +	    WARN_ON_ONCE(!slots->used_slots))
> > > +		return -1;
> > > +
> > > +	/*
> > > +	 * Move the target memslot backward in the array by shifting existing
> > > +	 * memslots with a higher GFN (than the target memslot) towards the
> > > +	 * front of the array.
> > > +	 */
> > > +	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
> > > +		if (memslot->base_gfn > mslots[i + 1].base_gfn)
> > > +			break;
> > > +
> > > +		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
> > 
> > Will this trigger?  Note that in __kvm_set_memory_region() we have
> > already checked overlap of memslots.
> 
> If you screw up the code it will :-)  In a perfect world, no WARN() will
> *ever* trigger.  All of the added WARN_ON_ONCE() are to help the next poor
> soul that wants to modify this code.

I normally won't keep WARN_ON if it is 100% not triggering (100% here
I mean when e.g. it is checked twice so the 1st one will definitely
trigger first).  My question is more like a pure question in case I
overlooked something.  Please also feel free to keep it if you want.

>  
> > > +
> > > +		/* Shift the next memslot forward one and update its index. */
> > > +		mslots[i] = mslots[i + 1];
> > > +		slots->id_to_index[mslots[i].id] = i;
> > > +	}
> > > +	return i;
> > > +}
> > > @@ -1104,8 +1203,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
> 
> ...
> 
> > >  	 * when the memslots are re-sorted by update_memslots().
> > >  	 */
> > >  	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> > > -	old = *tmp;
> > > -	tmp = NULL;
> > 
> > I was confused in that patch, then...
> > 
> > > +	if (tmp) {
> > > +		old = *tmp;
> > > +		tmp = NULL;
> > 
> > ... now I still don't know why it needs to set to NULL?
> 
> To make it abundantly clear that though shall not use @tmp, i.e. to force
> using the copy and not the pointer.  Note, @tmp is also reused as an
> iterator below.

OK it still feels a bit strange, say, we can comment on that if you
wants to warn the others.  The difference is probably no useless
instruction executed.  But this is also trivial, I'll leave to the
others to judge.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
