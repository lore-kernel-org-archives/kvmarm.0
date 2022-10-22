Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293D57C
	for <kvmarm@lists.linux.dev>; Sat, 22 Oct 2022 00:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666397854;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fi75UPk8tWEWlK3sUS1lCpXUc1ok9RQzENDyCGsA+M0=;
	b=gaLGrEVMWtpgrheaqexLB/5eZLcQP4dxp8ZLEcoaMOaVRWeOahz/7BRY9P32/eh90+zejh
	iNPY8Z5/GGpv4LFU7ZTqz+QpvDpWjzShykbPdEh21nR3j9e3Awj0KyKAapeZ/zpNHEKe4+
	r6Fy47Tm+1U8+PfHL2kXwBane2vPwGA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-m7MjTqczNK2im7q9WOPOvA-1; Fri, 21 Oct 2022 20:17:31 -0400
X-MC-Unique: m7MjTqczNK2im7q9WOPOvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F27CC3C01C12;
	Sat, 22 Oct 2022 00:16:44 +0000 (UTC)
Received: from [10.64.54.99] (vpn2-54-99.bne.redhat.com [10.64.54.99])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E79F22166B2C;
	Sat, 22 Oct 2022 00:16:29 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org, will@kernel.org,
 catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
 andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, oliver.upton@linux.dev, shan.gavin@gmail.com
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-2-gshan@redhat.com> <Y1HO46UCyhc9M6nM@google.com>
 <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
 <Y1K5/MN9o7tEvYu5@google.com>
 <85d15a4a-bbae-c5e6-f6dc-1d972d07dafb@redhat.com>
 <Y1Mvwq5PJ0gxC+47@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <3862fc65-d3bf-21af-2fe3-61f55da96aa1@redhat.com>
Date: Sat, 22 Oct 2022 08:16:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y1Mvwq5PJ0gxC+47@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Message-ID: <20221022001626.KgXuK-Eaw_bCYdxUg7moWDIRzHfAhY89FbGfa6j5E-M@z>

Hi Sean,

On 10/22/22 7:48 AM, Sean Christopherson wrote:
> On Sat, Oct 22, 2022, Gavin Shan wrote:
>>>> When dirty ring becomes full, the VCPU can't handle any operations, which will
>>>> bring more dirty pages.
>>>
>>> Right, but there's a buffer of 64 entries on top of what the CPU can buffer (VMX's
>>> PML can buffer 512 entries).  Hence the "soft full".  If x86 is already on the
>>> edge of exhausting that buffer, i.e. can fill 64 entries while handling requests,
>>> than we need to increase the buffer provided by the soft limit because sooner or
>>> later KVM will be able to fill 65 entries, at which point errors will occur
>>> regardless of when the "soft full" request is processed.
>>>
>>> In other words, we can take advantage of the fact that the soft-limit buffer needs
>>> to be quite conservative.
>>>
>>
>> Right, there are extra 64 entries in the ring between soft full and hard full.
>> Another 512 entries are reserved when PML is enabled. However, the other requests,
>> who produce dirty pages, are producers to the ring. We can't just have the assumption
>> that those producers will need less than 64 entries.
> 
> But we're already assuming those producers will need less than 65 entries.  My point
> is that if one (or even five) extra entries pushes KVM over the limit, then the
> buffer provided by the soft limit needs to be jacked up regardless of when the
> request is processed.
> 
> Hmm, but I suppose it's possible there's a pathological emulator path that can push
> double digit entries, and servicing the request right away ensures that requests
> have the full 64 entry buffer to play with.
> 
> So yeah, I agree, move it below the DEAD check, but keep it above most everything
> else.
> 

Ok, Thanks for double confirm on this. I will move the check after READ in next
revision.

>>>>> Would it make sense to clear the request in kvm_dirty_ring_reset()?  I don't care
>>>>> about the overhead of having to re-check the request, the goal would be to help
>>>>> document what causes the request to go away.
>>>>>
>>>>> E.g. modify kvm_dirty_ring_reset() to take @vcpu and then do:
>>>>>
>>>>> 	if (!kvm_dirty_ring_soft_full(ring))
>>>>> 		kvm_clear_request(KVM_REQ_RING_SOFT_FULL, vcpu);
>>>>>
>>>>
>>>> It's reasonable to clear KVM_REQ_DIRTY_RING_SOFT_FULL when the ring is reseted.
>>>> @vcpu can be achieved by container_of(..., ring).
>>>
>>> Using container_of() is silly, there's literally one caller that does:
>>>
>>> 	kvm_for_each_vcpu(i, vcpu, kvm)
>>> 		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
>>>
>>
>> May I ask why it's silly by using container_of()?
> 
> Because container_of() is inherently dangerous, e.g. if it's used on a pointer that
> isn't contained by the expected type, the code will compile cleanly but explode
> at runtime.  That's unlikely to happen in this case, e.g. doesn't look like we'll
> be adding a ring to "struct kvm", but if someone wanted to add a per-VM ring,
> taking the vCPU makes it very obvious that pushing to a ring _requires_ a vCPU,
> and enforces that requirement at compile time.
> 
> In other words, it's preferable to avoid container_of() unless using it solves a
> real problem that doesn't have a better alternative.
> 
> In these cases, passing in the vCPU is most definitely a better alternative as
> each of the functions in question has a sole caller that has easy access to the
> container (vCPU), i.e. it's a trivial change.
> 

Right, container_of() can't ensure consistence and full sanity check by itself.
It's reasonable to avoid using it if possible. Thanks for the details and
explanation.

>> In order to avoid using container_of(), kvm_dirty_ring_push() also need
>> @vcpu.
> 
> Yep, that one should be changed too.
> 

Ok.

>> So lets change those two functions to something like below. Please
>> double-check if they looks good to you?
>>
>>    void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset);
>>    int kvm_dirty_ring_reset(struct kvm_vcpu *vcpu);
> 
> Yep, looks good.
> 

Ok, Thanks for your confirm.

Thanks,
Gavin

