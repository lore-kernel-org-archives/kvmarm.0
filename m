Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5472908
	for <kvmarm@lists.linux.dev>; Tue,  8 Nov 2022 03:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667878259;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MXx6rx2M/mmRKLLVDzilfzZ6VOr9m7fhipmi74uiKdY=;
	b=EQF1CtoIzTtgtkNPwd+PWygES/onFXlON4IefDKjlWw6ickxgXECKFZ5hJjzxlYeFuboBf
	prn1N0w7DckuHn4ex4v2W/kadAJ4YGDSyJIX4PirjxvI5JUEY8VNMhcj//GoMO6OWnQjmp
	lgUjS1gIR2lT6oKHTUOxCMnOqlDCInA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-8l4CpRFiMBWCBYuJUt0cBQ-1; Mon, 07 Nov 2022 22:30:52 -0500
X-MC-Unique: 8l4CpRFiMBWCBYuJUt0cBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FA1C101A528;
	Tue,  8 Nov 2022 03:30:51 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6422E4C819;
	Tue,  8 Nov 2022 03:30:45 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, shuah@kernel.org,
 catalin.marinas@arm.com, andrew.jones@linux.dev, ajones@ventanamicro.com,
 bgardon@google.com, dmatlack@google.com, will@kernel.org,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, pbonzini@redhat.com,
 maz@kernel.org, peterx@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com> <Y2ks0NWEEfN8bWV1@google.com>
 <1816d557-1546-f5f9-f2c3-25086c0826fa@redhat.com>
 <Y2mtKjb8qc/vqKvQ@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <cadde3d3-8e2a-0952-8b30-2d7a75acbbc0@redhat.com>
Date: Tue, 8 Nov 2022 11:30:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y2mtKjb8qc/vqKvQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Message-ID: <20221108033042.xcetwmfdE1cwqR8GmVvkCn-NZzTpRgo-iETkIoIqbEI@z>

Hi Oliver,

On 11/8/22 9:13 AM, Oliver Upton wrote:
> On Tue, Nov 08, 2022 at 08:44:52AM +0800, Gavin Shan wrote:
>> Frankly, I don't expect the capability to be disabled. Similar to KVM_CAP_DIRTY_LOG_RING
>> or KVM_CAP_DIRTY_LOG_RING_ACQ_REL, it would a one-shot capability and only enablement is
>> allowed. The disablement was suggested by Oliver without providing a clarify, even I dropped
>> it for several times. I would like to see if there is particular reason why Oliver want
>> to disable the capability.
>>
>>      kvm->dirty_ring_with_bitmap = cap->args[0];
>>
>> If Oliver agrees that the capability needn't to be disabled. The whole chunk of
>> code can be squeezed into kvm_vm_ioctl_enable_dirty_log_ring_with_bitmap() to
>> make kvm_vm_ioctl_enable_cap_generic() a bit clean, as I said above.
> 
> Sorry, I don't believe there is much use in disabling the cap, and
> really that hunk just came from lazily matching the neigbhoring caps
> when sketching out some suggestions. Oops!
> 

Ok. It doesn't really matter too much except the comments seems conflicting.
Thanks for confirming it's unnecessary to disable the capability.

>> Sean and Oliver, could you help to confirm if the changes look good to you? :)
>>
>>      static int kvm_vm_ioctl_enable_dirty_log_ring_with_bitmap(struct kvm *kvm)
> 
> This function name is ridiculously long...
> 

Yeah, It seems I tempted to make the function name as comments :)

>>      {
>>          int i, r = 0;
>>
>>          if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>>              !kvm->dirty_ring_size)
>>              return -EINVAL;
>>
>>          mutex_lock(&kvm->slots_lock);
>>
>>          /* We only allow it to set once */
>>          if (kvm->dirty_ring_with_bitmap) {
>>              r = -EINVAL;
>>              goto out_unlock;
>>          }
> 
> I don't believe this check is strictly necessary. Something similar to
> this makes sense with caps that take a numeric value (like
> KVM_CAP_DIRTY_LOG_RING), but this one is a one-way boolean.
> 

Yep, it's not required strictly since it can represent two states.

>>
>>          /*
>>           * Avoid a race between memslot creation and enabling the ring +
>>           * bitmap capability to guarantee that no memslots have been
>>           * created without a bitmap.
> 
> You'll want to pick up Sean's suggestion on the comment which, again, I
> drafted this in haste :-)
> 

Ok, no worries :)

>>           */
>>          for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>>              if (!kvm_memslots_empty(__kvm_memslots(kvm, i))) {
>>                  r = -EINVAL;
>>                  goto out_unlock;
>>              }
>>          }
> 
> I'd much prefer you take Sean's suggestion and just create a helper to
> test that all memslots are empty. You avoid the insanely long function
> name and avoid the use of a goto statement. That is to say, leave the
> rest of the implementation inline in kvm_vm_ioctl_enable_cap_generic()
> 
> static bool kvm_are_all_memslots_empty(struct kvm *kvm)
> {
> 	int i;
> 
> 	lockdep_assert_held(&kvm->slots_lock);
> 
> 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> 		if (!kvm_memslots_empty(__kvm_memslots(kvm, i)))
> 			return false;
> 	}
> 
> 	return true;
> }
> 
> static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
> 					   struct kvm_enable_cap *cap)
> {
> 	switch (cap->cap) {
> 
>       [...]
> 
> 	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
> 		int r = -EINVAL;
> 
> 		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> 		    !kvm->dirty_ring_size)
> 		    	return r;
> 
> 		mutex_lock(&kvm->slots_lock);
> 
> 		/*
> 		 * For simplicity, allow enabling ring+bitmap if and only if
> 		 * there are no memslots, e.g. to ensure all memslots allocate a
> 		 * bitmap after the capability is enabled.
> 		 */
> 		if (kvm_are_all_memslots_empty(kvm)) {
> 			kvm->dirty_ring_with_bitmap = true;
> 			r = 0;
> 		}
> 
> 		mutex_unlock(&kvm->slots_lock);
> 		return r;
> 	}
> 
> }

Ok. Lets change the chunk as Sean suggested in v9, which should be posted soon.

Thanks,
Gavin

