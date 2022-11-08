Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7780C17ED
	for <kvmarm@lists.linux.dev>; Tue,  8 Nov 2022 01:13:21 +0000 (UTC)
Date: Tue, 8 Nov 2022 01:13:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1667869999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j/9169q3m9O0OkTuXDJWRxkVg0HVcKzXm9AM4KmwVHc=;
	b=eA/k56Q/dJe3Cd9LXb0w6SR6rauZih9/TCrMeO4DgijQI9/Lbh6NKfSTkKm6XRsDPkQ6rt
	ArM/S5+sRqifyBjyv1CdCsz/rzdxGqPHiqNM6AkWWW3BOED0/zBZ84j7xcOYY99EDcIF8u
	RRS6IippCP9JUBHgzFV477neC1mfHHo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org,
	catalin.marinas@arm.com, andrew.jones@linux.dev,
	ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
	will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
	pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
	zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2mtKjb8qc/vqKvQ@google.com>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <Y2ks0NWEEfN8bWV1@google.com>
 <1816d557-1546-f5f9-f2c3-25086c0826fa@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1816d557-1546-f5f9-f2c3-25086c0826fa@redhat.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221108011314.BjRgjA1RHa52WTe86vQ2ZeB3UxfM36046_UnEKkCs_0@z>

On Tue, Nov 08, 2022 at 08:44:52AM +0800, Gavin Shan wrote:
> Frankly, I don't expect the capability to be disabled. Similar to KVM_CAP_DIRTY_LOG_RING
> or KVM_CAP_DIRTY_LOG_RING_ACQ_REL, it would a one-shot capability and only enablement is
> allowed. The disablement was suggested by Oliver without providing a clarify, even I dropped
> it for several times. I would like to see if there is particular reason why Oliver want
> to disable the capability.
> 
>     kvm->dirty_ring_with_bitmap = cap->args[0];
> 
> If Oliver agrees that the capability needn't to be disabled. The whole chunk of
> code can be squeezed into kvm_vm_ioctl_enable_dirty_log_ring_with_bitmap() to
> make kvm_vm_ioctl_enable_cap_generic() a bit clean, as I said above.

Sorry, I don't believe there is much use in disabling the cap, and
really that hunk just came from lazily matching the neigbhoring caps
when sketching out some suggestions. Oops!

> Sean and Oliver, could you help to confirm if the changes look good to you? :)
> 
>     static int kvm_vm_ioctl_enable_dirty_log_ring_with_bitmap(struct kvm *kvm)

This function name is ridiculously long...

>     {
>         int i, r = 0;
> 
>         if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>             !kvm->dirty_ring_size)
>             return -EINVAL;
> 
>         mutex_lock(&kvm->slots_lock);
> 
>         /* We only allow it to set once */
>         if (kvm->dirty_ring_with_bitmap) {
>             r = -EINVAL;
>             goto out_unlock;
>         }

I don't believe this check is strictly necessary. Something similar to
this makes sense with caps that take a numeric value (like
KVM_CAP_DIRTY_LOG_RING), but this one is a one-way boolean.

> 
>         /*
>          * Avoid a race between memslot creation and enabling the ring +
>          * bitmap capability to guarantee that no memslots have been
>          * created without a bitmap.

You'll want to pick up Sean's suggestion on the comment which, again, I
drafted this in haste :-)

>          */
>         for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>             if (!kvm_memslots_empty(__kvm_memslots(kvm, i))) {
>                 r = -EINVAL;
>                 goto out_unlock;
>             }
>         }

I'd much prefer you take Sean's suggestion and just create a helper to
test that all memslots are empty. You avoid the insanely long function
name and avoid the use of a goto statement. That is to say, leave the
rest of the implementation inline in kvm_vm_ioctl_enable_cap_generic()

static bool kvm_are_all_memslots_empty(struct kvm *kvm)
{
	int i;

	lockdep_assert_held(&kvm->slots_lock);

	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
		if (!kvm_memslots_empty(__kvm_memslots(kvm, i)))
			return false;
	}

	return true;
}

static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
					   struct kvm_enable_cap *cap)
{
	switch (cap->cap) {

[...]

	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
		int r = -EINVAL;

		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
		    !kvm->dirty_ring_size)
		    	return r;

		mutex_lock(&kvm->slots_lock);

		/*
		 * For simplicity, allow enabling ring+bitmap if and only if
		 * there are no memslots, e.g. to ensure all memslots allocate a
		 * bitmap after the capability is enabled.
		 */
		if (kvm_are_all_memslots_empty(kvm)) {
			kvm->dirty_ring_with_bitmap = true;
			r = 0;
		}

		mutex_unlock(&kvm->slots_lock);
		return r;
	}

Hmm?

--
Thanks,
Oliver
