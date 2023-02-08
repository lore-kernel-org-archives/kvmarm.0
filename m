Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A542560
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 12:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675858607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rjMSi9ok1TzHSDU3w1PUUtKMgZdBUc/PnFmrcylWMYk=;
	b=bet4sFlqM40Wfry7PK0RhW7M2a60+f7rn2UJC6oRdRBbXys+BzmJyOgWa+U8envzKDJeht
	x48ymDk/B7DNZULggwCiH6ri55QX8GVjX7Ura54f4hCamBTTm5t6qSmVvBmVB2C8J6sb4E
	L6Rv9rq2dXm1Li1X7tIKIgDK4E0sZo8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-156-zz9LmwzkO3eFWwDy7fE8XA-1; Wed, 08 Feb 2023 07:16:43 -0500
X-MC-Unique: zz9LmwzkO3eFWwDy7fE8XA-1
Received: by mail-qv1-f70.google.com with SMTP id l6-20020ad44446000000b00537721bfd2dso9650823qvt.11
        for <kvmarm@lists.linux.dev>; Wed, 08 Feb 2023 04:16:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjMSi9ok1TzHSDU3w1PUUtKMgZdBUc/PnFmrcylWMYk=;
        b=bY52Os5rt65hzlHHDWkQJ4Xj8QsDfjvKDEBQnHh5U/+4vzUdXFt+JyfDN+KKcHT+0+
         hlgsnU7nJTY+6ACUTN299kLDo8v+C1UnZaDPJ1OmVc796t8aGkrwiFpsEm5xpFBuhW69
         CpxhiLrzvCV8MgIKb8TY3XNb9xPeMIl4jgUCfWMfrQKcVDfP7mBLU9g9dU2cNI+7iNsL
         VKUfZwlwLoMdtDPaW+DrLZNwOmi/7D/pLfMiC22B2s1UI5qGplbIrKDy/vMoJGKLHf8l
         gNmxoAHiTS5Iok3opoV8SqULfX+di1rWhXsIId+XJl+WgQkmYdKV5vUcDN1qErycSb6X
         X1Cg==
X-Gm-Message-State: AO0yUKXcXBsmV1nRK9hpQK4iFf5KFQwIi+aOa+XfGpPAoIkcXvrt2E0Y
	v8fy5gW3jmt13QUFFrSmuXeyTG9RRdBXtaUsZeGby8ATt7vYsTjhJcBFTwmmiGSPDUrNEbTeJ4G
	8oFdd2ccCrs0trsGP
X-Received: by 2002:a05:6214:2348:b0:56b:ef8e:18ec with SMTP id hu8-20020a056214234800b0056bef8e18ecmr12324935qvb.12.1675858603328;
        Wed, 08 Feb 2023 04:16:43 -0800 (PST)
X-Google-Smtp-Source: AK7set9NZULWqTl2Mcke9STbzAhWv2Gmx/BViB8dl8z0WU3BjxNZZ22NA4XHXc1de+u8uoed8iFu9Q==
X-Received: by 2002:a05:6214:2348:b0:56b:ef8e:18ec with SMTP id hu8-20020a056214234800b0056bef8e18ecmr12324890qvb.12.1675858603023;
        Wed, 08 Feb 2023 04:16:43 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-253.web.vodafone.de. [109.43.177.253])
        by smtp.gmail.com with ESMTPSA id 22-20020ac85616000000b003b630456b8fsm11264751qtr.89.2023.02.08.04.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 04:16:42 -0800 (PST)
Message-ID: <ac8073a3-868f-a923-4cb8-fda4785e7484@redhat.com>
Date: Wed, 8 Feb 2023 13:16:38 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Steven Price <steven.price@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, linuxppc-dev@lists.ozlabs.org,
 Eric Auger <eric.auger@redhat.com>
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-7-thuth@redhat.com>
 <c6e605fe-f251-d8b6-64ed-bd1e17e79512@redhat.com>
 <7b32d58b-846f-b8d7-165b-9f505e5f00f0@redhat.com>
 <d0b3a1e7-0864-f169-cdea-60ad95951b3f@redhat.com> <87zg9oleyb.fsf@redhat.com>
 <ce11001e-dbe5-8694-71a5-841f4d614456@arm.com>
From: Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Change return type of
 kvm_vm_ioctl_mte_copy_tags() to "int"
In-Reply-To: <ce11001e-dbe5-8694-71a5-841f4d614456@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/02/2023 12.51, Steven Price wrote:
> On 08/02/2023 08:49, Cornelia Huck wrote:
>> On Wed, Feb 08 2023, Gavin Shan <gshan@redhat.com> wrote:
>>
>>> On 2/7/23 9:09 PM, Thomas Huth wrote:
>>>> Oh, drat, I thought I had checked all return statements ... this must have fallen through the cracks, sorry!
>>>>
>>>> Anyway, this is already a problem now: The function is called from kvm_arch_vm_ioctl() (which still returns a long), which in turn is called from kvm_vm_ioctl() in virt/kvm/kvm_main.c. And that functions stores the return value in an "int r" variable. So the upper bits are already lost there.
> 
> Sorry about that, I was caught out by kvm_arch_vm_ioctl() returning long...

That's why I'm trying to fix that return type mess with my series, to avoid 
such problems in the future :-)

>>>> Also, how is this supposed to work from user space? The normal "ioctl()" libc function just returns an "int" ? Is this ioctl already used in a userspace application somewhere? ... at least in QEMU, I didn't spot it yet...
>>>>
>>
>> We will need it in QEMU to implement migration with MTE (the current
>> proposal simply adds a migration blocker when MTE is enabled, as there
>> are various other things that need to be figured out for this to work.)
>> But maybe other VMMs already use it (and have been lucky because they
>> always dealt with shorter lengths?)
>>
>>>
>>> The ioctl command KVM_ARM_MTE_COPY_TAGS was merged recently and not used
>>> by QEMU yet. I think struct kvm_arm_copy_mte_tags::length needs to be
>>> '__u32' instead of '__u64' in order to standardize the return value.
>>> Something like below. Documentation/virt/kvm/api.rst::section-4.130
>>> needs update accordingly.
>>>
>>>      struct kvm_arm_copy_mte_tags {
>>>           __u64 guest_ipa;
>>>           __u32 pad;
>>>           __u32 length;
>>>           void __user *addr;
>>>           __u64 flags;
>>>           __u64 reserved[2];
>>>     };
>>
>> Can we do this in a more compatible way, as we are dealing with an API?
>> Like returning -EINVAL if length is too big?
>>
> 
> I agree the simplest fix for the problem is simply to reject any
> lengths>INT_MAX:
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index cf4c495a4321..94aed7ce85c4 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1032,6 +1032,13 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>   	if (copy_tags->flags & ~KVM_ARM_TAGS_FROM_GUEST)
>   		return -EINVAL;
> 
> +	/*
> +	 * ioctl returns int, so lengths above INT_MAX cannot be
> +	 * represented in the return value
> +	 */
> +	if (length > INT_MAX)
> +		return -EINVAL;
> +
>   	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
>   		return -EINVAL;
> 
> This could also be fixed in a useable way by including a new flag which
> returns the length in an output field of the ioctl structure. I'm
> guessing a 2GB limit would be annoying to work around.

I agree that checking for length > INT_MAX is likely the best thing to do 
here right now. I'll add that in v2 of my series.

But actually, this might even be a good thing from another point of view (so 
I'm not sure whether your idea with the flag should really be pursued): The 
code here takes a mutex and then runs a while loop that depends on the 
length - which could cause the lock to be held for a rather long time if 
length is a 64-bit value. Forcing the user space to limit the length here 
could help to avoid taking the lock for too long.

  Thomas

