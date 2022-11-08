Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8AEC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Nov 2022 22:19:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F7954B875;
	Tue,  8 Nov 2022 17:19:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FEoC6qLvzxiO; Tue,  8 Nov 2022 17:19:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCCFD4B877;
	Tue,  8 Nov 2022 17:19:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD1A04B850
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 17:19:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QuZdPVW-k1tj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Nov 2022 17:19:50 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 644E04B803
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Nov 2022 17:19:50 -0500 (EST)
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
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B431380673F;
 Tue,  8 Nov 2022 22:19:45 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 635324B3FC6;
 Tue,  8 Nov 2022 22:19:39 +0000 (UTC)
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
To: Sean Christopherson <seanjc@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com> <Y2qDCqFeL1vwqq3f@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <49217b8f-ce53-c41b-98aa-ced34cd079cc@redhat.com>
Date: Wed, 9 Nov 2022 06:19:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2qDCqFeL1vwqq3f@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Cc: maz@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
