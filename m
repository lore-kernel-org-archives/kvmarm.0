Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB93188733
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 19:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729278187; cv=none; b=t3KRQ/PebOyLKHti0y0cqzLWv+/Ubm1munL/2Xjymh3RIWFxq0/jLc3Rsu/eQf+dnc1OrQbTACBAsM4SJhCZNH678VylN/p06IMQEToKJ/voj+ztWgZt01kLISXvHCz07MOKLzMhgX0DpNXkLca0uvi1+CoOCdZLvZpdMB4b2ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729278187; c=relaxed/simple;
	bh=4l6CWUJywlwgCO/NWDGDD18NHmJbkNZ1RHEMdsE35tE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oaJGKpbnsQcJAepUE7r6/Z0hXF4mw2rFjSaViOmjCnji+0I5mtwMXaOMjeWNQwF0AtYLeMCfSPaZo3nEGCXG4FqorLvK4dz2g0n2+70zjx7U6MQ3vrHey0VKORQOX7m182Xee9xl5k3h69c8XpuyKaf622fnJ5ytvOQOpXz/1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZ1Qdqhu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZ1Qdqhu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729278184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tQo0YZbGyY7iAxtTmd2kJH9mWaUUkaRIkAcsfKHjMog=;
	b=LZ1Qdqhu5vxuEMEx5IBcLlakU3o0KrOW7f4j4P2vOf0nEl12qB9F8fbitlk6HpktguaIZA
	Z41wrJZqPjO+dPgQc86DiNQwICBpFuJqE77xgAH03hEYIIa9/DhpWm+qh2WyJyoTjroUy0
	Ly57AlMymWlI0/tsW3XE3RWEor/I8fk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-VE7vUhigOB-PAVD3XJd3RQ-1; Fri, 18 Oct 2024 15:03:03 -0400
X-MC-Unique: VE7vUhigOB-PAVD3XJd3RQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43125f45783so15137715e9.2
        for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 12:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729278182; x=1729882982;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tQo0YZbGyY7iAxtTmd2kJH9mWaUUkaRIkAcsfKHjMog=;
        b=X+I2nLgmIYqyN3/eZB8m7rJPCOnhuXmN3w9Xc723IBrnfhE4SfQ+/tP5KVD7HlQFcV
         DRH1TKLvz2jjG2XxmdhNbgEkcdhWG5r9DZyrVNvVV7yn77ysRmLXyUEh+U73XbjxAWlh
         FGn8xcZm2+JTfmU0wVSQMAaDyzSerkNRScxQAxbt+s5VPXAZTk2xIVCtYerbRynOi9dZ
         7loDys/XbuSz/TbTQy99ZQoDsZD078zfy5d1fHG6r2nbqh8AlWFwT2ta2dzWphVCSt/v
         hb0Dsoe0CBnOhqQcMKGdA/IU3Decdy0y8GoKxKQkfUHPN017Los75Rk7zVwMwo+kyT2H
         OTkA==
X-Forwarded-Encrypted: i=1; AJvYcCWHwK1KxO9evi1bXYAoVgb+bLCVArsHFELjAsqUZ/MrHclBMoNCx0xb5aSB52kxTouU1qEPcIw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyihSMRTxrxgl0+OjLDne7WhAnbr8Kj4JSsUdMPs+zb2A53G2FB
	B6yI4xaQtv8/UQBWBFWyrvw0kaZLrKAcgR9wEQe0iizQeasKw7bKswxWPVbXvGVkKCqYOjoe/Le
	WV0Zwsu2YwM2txAubj20cZAsDhvFxl/dKbS+Mlijcv3yKh+fe+6nC4A==
X-Received: by 2002:a05:600c:3b1e:b0:431:52f5:f48d with SMTP id 5b1f17b1804b1-431616a3c10mr25470935e9.31.1729278181655;
        Fri, 18 Oct 2024 12:03:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTQPTC6nkjtDBSk2oFHjpd3s2qenJuf8l/y/7eNuLAyXn19BjKJ3qT8knSzs8zqbNN4Gj/4Q==
X-Received: by 2002:a05:600c:3b1e:b0:431:52f5:f48d with SMTP id 5b1f17b1804b1-431616a3c10mr25470635e9.31.1729278181131;
        Fri, 18 Oct 2024 12:03:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:2400:68a3:92e0:906f:b69d? (p200300cbc707240068a392e0906fb69d.dip0.t-ipconnect.de. [2003:cb:c707:2400:68a3:92e0:906f:b69d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ecf0ed24esm2580691f8f.82.2024.10.18.12.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2024 12:03:00 -0700 (PDT)
Message-ID: <7fc46791-3f1a-40a0-a939-bc7a90b7e7ed@redhat.com>
Date: Fri, 18 Oct 2024 21:02:59 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] support for mm-local memory allocations and use
 it
From: David Hildenbrand <david@redhat.com>
To: Fares Mehanna <faresx@amazon.de>
Cc: akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de,
 bhelgaas@google.com, broonie@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com, javierm@redhat.com, jean-philippe@linaro.org,
 joey.gouly@arm.com, kristina.martsenko@arm.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mark.rutland@arm.com, maz@kernel.org, mediou@amazon.de,
 nh-open-source@amazon.com, oliver.upton@linux.dev, ptosi@google.com,
 rdunlap@infradead.org, rkagan@amazon.de, rppt@kernel.org,
 shikemeng@huaweicloud.com, suzuki.poulose@arm.com, tabba@google.com,
 will@kernel.org, yuzenghui@huawei.com
References: <63d112d8-62d0-4e95-81f0-3031f990abc4@redhat.com>
 <20241011142547.24447-1-faresx@amazon.de>
 <5f9ba14a-909b-4b49-b1de-3dc98b31aee0@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <5f9ba14a-909b-4b49-b1de-3dc98b31aee0@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18.10.24 20:52, David Hildenbrand wrote:
> On 11.10.24 16:25, Fares Mehanna wrote:
>>>>
>>>>
>>>>> On 11. Oct 2024, at 14:36, Mediouni, Mohamed <mediou@amazon.de> wrote:
>>>>>
>>>>>
>>>>>
>>>>>> On 11. Oct 2024, at 14:04, David Hildenbrand <david@redhat.com> wrote:
>>>>>>
>>>>>> On 10.10.24 17:52, Fares Mehanna wrote:
>>>>>>>>> In a series posted a few years ago [1], a proposal was put forward to allow the
>>>>>>>>> kernel to allocate memory local to a mm and thus push it out of reach for
>>>>>>>>> current and future speculation-based cross-process attacks.  We still believe
>>>>>>>>> this is a nice thing to have.
>>>>>>>>>
>>>>>>>>> However, in the time passed since that post Linux mm has grown quite a few new
>>>>>>>>> goodies, so we'd like to explore possibilities to implement this functionality
>>>>>>>>> with less effort and churn leveraging the now available facilities.
>>>>>>>>>
>>>>>>>>> An RFC was posted few months back [2] to show the proof of concept and a simple
>>>>>>>>> test driver.
>>>>>>>>>
>>>>>>>>> In this RFC, we're using the same approach of implementing mm-local allocations
>>>>>>>>> piggy-backing on memfd_secret(), using regular user addresses but pinning the
>>>>>>>>> pages and flipping the user/supervisor flag on the respective PTEs to make them
>>>>>>>>> directly accessible from kernel.
>>>>>>>>> In addition to that we are submitting 5 patches to use the secret memory to hide
>>>>>>>>> the vCPU gp-regs and fp-regs on arm64 VHE systems.
>>>>>>>>
>>>>>>>> I'm a bit lost on what exactly we want to achieve. The point where we
>>>>>>>> start flipping user/supervisor flags confuses me :)
>>>>>>>>
>>>>>>>> With secretmem, you'd get memory allocated that
>>>>>>>> (a) Is accessible by user space -- mapped into user space.
>>>>>>>> (b) Is inaccessible by kernel space -- not mapped into the direct map
>>>>>>>> (c) GUP will fail, but copy_from / copy_to user will work.
>>>>>>>>
>>>>>>>>
>>>>>>>> Another way, without secretmem, would be to consider these "secrets"
>>>>>>>> kernel allocations that can be mapped into user space using mmap() of a
>>>>>>>> special fd. That is, they wouldn't have their origin in secretmem, but
>>>>>>>> in KVM as a kernel allocation. It could be achieved by using VM_MIXEDMAP
>>>>>>>> with vm_insert_pages(), manually removing them from the directmap.
>>>>>>>>
>>>>>>>> But, I am not sure who is supposed to access what. Let's explore the
>>>>>>>> requirements. I assume we want:
>>>>>>>>
>>>>>>>> (a) Pages accessible by user space -- mapped into user space.
>>>>>>>> (b) Pages inaccessible by kernel space -- not mapped into the direct map
>>>>>>>> (c) GUP to fail (no direct map).
>>>>>>>> (d) copy_from / copy_to user to fail?
>>>>>>>>
>>>>>>>> And on top of that, some way to access these pages on demand from kernel
>>>>>>>> space? (temporary CPU-local mapping?)
>>>>>>>>
>>>>>>>> Or how would the kernel make use of these allocations?
>>>>>>>>
>>>>>>>> -- 
>>>>>>>> Cheers,
>>>>>>>>
>>>>>>>> David / dhildenb
>>>>>>> Hi David,
>>>>>>
>>>>>> Hi Fares!
>>>>>>
>>>>>>> Thanks for taking a look at the patches!
>>>>>>> We're trying to allocate a kernel memory that is accessible to the kernel but
>>>>>>> only when the context of the process is loaded.
>>>>>>> So this is a kernel memory that is not needed to operate the kernel itself, it
>>>>>>> is to store & process data on behalf of a process. The requirement for this
>>>>>>> memory is that it would never be touched unless the process is scheduled on this
>>>>>>> core. otherwise any other access will crash the kernel.
>>>>>>> So this memory should only be directly readable and writable by the kernel, but
>>>>>>> only when the process context is loaded. The memory shouldn't be readable or
>>>>>>> writable by the owner process at all.
>>>>>>> This is basically done by removing those pages from kernel linear address and
>>>>>>> attaching them only in the process mm_struct. So during context switching the
>>>>>>> kernel loses access to the secret memory scheduled out and gain access to the
>>>>>>> new process secret memory.
>>>>>>> This generally protects against speculation attacks, and if other process managed
>>>>>>> to trick the kernel to leak data from memory. In this case the kernel will crash
>>>>>>> if it tries to access other processes secret memory.
>>>>>>> Since this memory is special in the sense that it is kernel memory but only make
>>>>>>> sense in the term of the owner process, I tried in this patch series to explore
>>>>>>> the possibility of reusing memfd_secret() to allocate this memory in user virtual
>>>>>>> address space, manage it in a VMA, flipping the permissions while keeping the
>>>>>>> control of the mapping exclusively with the kernel.
>>>>>>> Right now it is:
>>>>>>> (a) Pages not accessible by user space -- even though they are mapped into user
>>>>>>>       space, the PTEs are marked for kernel usage.
>>>>>>
>>>>>> Ah, that is the detail I was missing, now I see what you are trying to achieve, thanks!
>>>>>>
>>>>>> It is a bit architecture specific, because ... imagine architectures that have separate kernel+user space page table hierarchies, and not a simple PTE flag
>>> to change access permissions between kernel/user space.
>>>>>>
>>>>>> IIRC s390 is one such architecture that uses separate page tables for the user-space + kernel-space portions.
>>>>>>
>>>>>>> (b) Pages accessible by kernel space -- even though they are not mapped into the
>>>>>>>       direct map, the PTEs in uvaddr are marked for kernel usage.
>>>>>>> (c) copy_from / copy_to user won't fail -- because it is in the user range, but
>>>>>>>       this can be fixed by allocating specific range in user vaddr to this feature
>>>>>>>       and check against this range there.
>>>>>>> (d) The secret memory vaddr is guessable by the owner process -- that can also
>>>>>>>       be fixed by allocating bigger chunk of user vaddr for this feature and
>>>>>>>       randomly placing the secret memory there.
>>>>>>> (e) Mapping is off-limits to the owner process by marking the VMA as locked,
>>>>>>>       sealed and special.
>>>>>>
>>>>>> Okay, so in this RFC you are jumping through quite some hoops to have a kernel allocation unmapped from the direct map but mapped into a per-process page
>>> table only accessible by kernel space. :)
>>>>>>
>>>>>> So you really don't want this mapped into user space at all (consequently, no GUP, no access, no copy_from_user ...). In this RFC it's mapped but turned
>>> inaccessible by flipping the "kernel vs. user" switch.
>>>>>>
>>>>>>> Other alternative (that was implemented in the first submission) is to track those
>>>>>>> allocations in a non-shared kernel PGD per process, then handle creating, forking
>>>>>>> and context-switching this PGD.
>>>>>>
>>>>>> That sounds like a better approach. So we would remove the pages from the shared kernel direct map and map them into a separate kernel-portion in the per-MM
>>> page tables?
>>>>>>
>>>>>> Can you envision that would also work with architectures like s390x? I assume we would not only need the per-MM user space page table hierarchy, but also a
>>> per-MM kernel space page table hierarchy, into which we also map the common/shared-among-all-processes kernel space page tables (e.g., directmap).
>>>>> Yes, that’s also applicable to arm64. There’s currently no separate per-mm user space page hierarchy there.
>>>> typo, read kernel
>>>
>>>
>>> Okay, thanks. So going into that direction makes more sense.
>>>
>>> I do wonder if we really have to deal with fork() ... if the primary
>>> users don't really have meaning in the forked child (e.g., just like
>>> fork() with KVM IIRC) we might just get away by "losing" these
>>> allocations in the child process.
>>>
>>> Happy to learn why fork() must be supported.
>>
>> It really depends on the use cases of the kernel secret allocation, but in my
>> mind a troubling scenario:
>> 1. Process A had a resource X.
>> 2. Kernel decided to keep some data related to resource X in process A secret
>>      memory.
>> 3. Process A decided to fork, now process B share the resource X.
>> 4. Process B started using resource X. <-- This will crash the kernel as the
>>      used kernel page table on process B has no mapping for the secret memory used
>>      in resource X.
>>
>> I haven't tried to trigger this crash myself though.
>>
> 
> Right, and if we can rule out any users that are supposed to work after
> fork(), we can just disregard that in the first version.
> 
> I never played with this, but let's assume you make use of these
> mm-local allocations in KVM context.
> 
> What would happens if you fork() with a KVM fd and try accessing that fd
> from the other process using ioctls? I recall that KVM will not be
> "duplicated".
> 
> What would happen if you send that fd over to a completely different
> process and try accessing that fd from the other process using ioctls?

Stumbling over Documentation/virtual/kvm/api.txt:

"In general file descriptors can be migrated among processes by means
of fork() and the SCM_RIGHTS facility of unix domain socket.  These
kinds of tricks are explicitly not supported by kvm.  While they will
not cause harm to the host, their actual behavior is not guaranteed by
the API.  See "General description" for details on the ioctl usage
model that is supported by KVM.

It is important to note that althought VM ioctls may only be issued from
the process that created the VM, a VM's lifecycle is associated with its
file descriptor, not its creator (process).  In other words, the VM and
its resources, *including the associated address space*, are not freed
until the last reference to the VM's file descriptor has been released.
For example, if fork() is issued after ioctl(KVM_CREATE_VM), the VM will
not be freed until both the parent (original) process and its child have
put their references to the VM's file descriptor.

Because a VM's resources are not freed until the last reference to its
file descriptor is released, creating additional references to a VM via
via fork(), dup(), etc... without careful consideration is strongly
discouraged and may have unwanted side effects, e.g. memory allocated
by and on behalf of the VM's process may not be freed/unaccounted when
the VM is shut down.
"

The "may only be issued" doesn't make it clear if that is actively enforced.

But staring at kvm_vcpu_ioctl():

	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
		return -EIO;

So with KVM it would likely work to *not* care about mm-local memory 
allocations during fork().

But of course, what I am getting at is: if we would have some fd that 
uses an mm-local allocation, and it could be accessed (ioctl) from 
another active MM, we would likely be in trouble ... and not only fork() 
is the problem.

We should really not try handling fork() and instead restrict the use 
cases where this can be used.

-- 
Cheers,

David / dhildenb

