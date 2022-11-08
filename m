Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E10A480
	for <kvmarm@lists.linux.dev>; Tue,  8 Nov 2022 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667945990;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rM9d9QcLMO4Gb1UJawRpOr7BbjkeIgjtt3r4okgE/aQ=;
	b=MdcmPnov6DCy6gm7h+a0marJyJAH18OwalNztZeoO17ZqKouvdDk3iAzaUW0LIhvfyMJyA
	Reo1xcMAXdVO0BhsjVzDGkyeCvzKQJ6v429JKimDY0WS+6pxI03XnGjXquaGke31x2n0DA
	XdU9qmemN5ZSMbh6qGFI06akSltv/O8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-eW1u_DuAMGKbU_l2DpPbjg-1; Tue, 08 Nov 2022 17:19:46 -0500
X-MC-Unique: eW1u_DuAMGKbU_l2DpPbjg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B431380673F;
	Tue,  8 Nov 2022 22:19:45 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 635324B3FC6;
	Tue,  8 Nov 2022 22:19:39 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, ajones@ventanamicro.com, bgardon@google.com,
 dmatlack@google.com, will@kernel.org, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, pbonzini@redhat.com, maz@kernel.org,
 peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
 shan.gavin@gmail.com
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com> <Y2qDCqFeL1vwqq3f@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
Date: Wed, 9 Nov 2022 06:19:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y2qDCqFeL1vwqq3f@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Message-ID: <20221108221936.lMUTtQoJBB2chAUH5YvPRnI5p2kCQJuTlxgcVim6oak@z>

Hi Sean,

On 11/9/22 12:25 AM, Sean Christopherson wrote:
> On Tue, Nov 08, 2022, Gavin Shan wrote:
>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>> index 800f9470e36b..228be1145cf3 100644
>> --- a/virt/kvm/Kconfig
>> +++ b/virt/kvm/Kconfig
>> @@ -33,6 +33,14 @@ config HAVE_KVM_DIRTY_RING_ACQ_REL
>>          bool
>>          select HAVE_KVM_DIRTY_RING
>>   
>> +# Only architectures that need to dirty memory outside of a vCPU
>> +# context should select this, advertising to userspace the
>> +# requirement to use a dirty bitmap in addition to the vCPU dirty
>> +# ring.
> 
> The Kconfig does more than advertise a feature to userspace.
> 
>   # Allow enabling both the dirty bitmap and dirty ring.  Only architectures that
>   # need to dirty memory outside of a vCPU context should select this.
> 

Agreed. The comments will be adjusted accordingly.

>> +config HAVE_KVM_DIRTY_RING_WITH_BITMAP
> 
> I think we should replace "HAVE" with "NEED".  Any architecture that supports the
> dirty ring can easily support ring+bitmap, but based on the discussion from v5[*],
> the comment above, and the fact that the bitmap will _never_ be used in the
> proposed implementation because x86 will always have a vCPU, this Kconfig should
> only be selected if the bitmap is needed to support migration.
> 
> [*] https://lore.kernel.org/all/Y0SxnoT5u7+1TCT+@google.com
> 

Both look good to me. Lets change it to CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP
then.

>> +	bool
>> +	depends on HAVE_KVM_DIRTY_RING
>> +
>>   config HAVE_KVM_EVENTFD
>>          bool
>>          select EVENTFD
>> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
>> index fecbb7d75ad2..f95cbcdd74ff 100644
>> --- a/virt/kvm/dirty_ring.c
>> +++ b/virt/kvm/dirty_ring.c
>> @@ -21,6 +21,18 @@ u32 kvm_dirty_ring_get_rsvd_entries(void)
>>   	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
>>   }
>>   
>> +bool kvm_use_dirty_bitmap(struct kvm *kvm)
>> +{
>> +	lockdep_assert_held(&kvm->slots_lock);
>> +
>> +	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
>> +}
>> +
>> +bool __weak kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
> 
> Rather than __weak, what about wrapping this with an #ifdef to effectively force
> architectures to implement the override if they need ring+bitmap?  Given that the
> bitmap will never be used if there's a running vCPU, selecting the Kconfig without
> overriding this utility can't possibly be correct.
> 
>    #ifndef CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP
>    bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
>    {
> 	return false;
>    }
>    #endif
> 

It's a good idea, which will be included to next revision :)

>> @@ -4588,6 +4608,29 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>>   			return -EINVAL;
>>   
>>   		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
>> +		int r = -EINVAL;
>> +
>> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>> +		    !kvm->dirty_ring_size)
> 
> I have no objection to disallowing userspace from disabling the combo, but I
> think it's worth requiring cap->args[0] to be '0' just in case we change our minds
> in the future.
> 

I assume you're suggesting to have non-zero value in cap->args[0] to enable the
capability.

     if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
         !kvm->dirty_ring_size || !cap->args[0])
         return r;
     
>> +			return r;
>> +
>> +		mutex_lock(&kvm->slots_lock);
>> +
>> +		/*
>> +		 * For simplicity, allow enabling ring+bitmap if and only if
>> +		 * there are no memslots, e.g. to ensure all memslots allocate
>> +		 * a bitmap after the capability is enabled.
>> +		 */
>> +		if (kvm_are_all_memslots_empty(kvm)) {
>> +			kvm->dirty_ring_with_bitmap = true;
>> +			r = 0;
>> +		}
>> +
>> +		mutex_unlock(&kvm->slots_lock);
>> +
>> +		return r;
>> +	}
>>   	default:
>>   		return kvm_vm_ioctl_enable_cap(kvm, cap);
>>   	}


Thanks,
Gavin

