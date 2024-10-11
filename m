Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25179213EC2
	for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 12:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728648259; cv=none; b=Xu0eMEcPMjeZtsbjk4L/rRXZ4cPF9Zb/vx7wZQzB9VAgYuerMQEyJ8e1JpDIo5QYZS5CXYcQtYu+I4KM/QXJGL87GvN6jcr/xiPbyrYCjEod3faBe846jOvHory9lu03nA/jvrdUZQTL+NZ7A6xpjD4Ybh1hO52A9Uz480eeblA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728648259; c=relaxed/simple;
	bh=TjHiK5Q8bt/Ap+8QEjbvgZEqTB+88VHjVFDoY+3cp4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dLq8KYL0JcRAAuSu3Voq2yhXU4QaqW+UttHqfZSe2cw+6ZmlARcHFUtjdF1+mbeZznPVtlQel20vLpXmFFLH2j+r5ohMtmtcLfuRx0WlrEFvaocsQJRLRP8BNB7ZiWK6XGqkbyb3Mdl1HVLW3ORM/Vt+ULtnavQeXydJNgOT9NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K8tibi1y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K8tibi1y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728648257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FO3wGe3DmoLaqjoe9vy/0KU63s1XIaxHSw75zzKrsAU=;
	b=K8tibi1yaUwx+cx2hBMzZ4EV+9ilyoUToxFAhSEuS+EhYhfwyrxNqwvubJnpqW8wknNQlA
	Pt3BxYImrR4cSORZmhycya2PPXyS5Bme/Z3quV7OV6VLh/VeVPlbxyJlDGLTuGYg4bOULv
	L6iF58+U1PNbwW3UP8M+sTN5bseD70M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-Eq0Rkl4-PKWFpLuuj95xsQ-1; Fri, 11 Oct 2024 08:04:16 -0400
X-MC-Unique: Eq0Rkl4-PKWFpLuuj95xsQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42f8ceb8783so13961065e9.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Oct 2024 05:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728648255; x=1729253055;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FO3wGe3DmoLaqjoe9vy/0KU63s1XIaxHSw75zzKrsAU=;
        b=B0JkmnvI6g9vOPV+oWZKsdWKKx2oFsiB9hdrJ0j3WIex0MNho7OMwZZURiRZnEA20A
         vorb+dwebQ+Z3NhRrz87wDA/zHHc8BG+LJeUQRyne4otDyqAdXG6pFeIWNxzEduABDID
         vdOovZcA5OWZgprTgQSZ4nsF7mLyn1d6AY+saxsPqaPY723QSOyP8AN0HQC3QiwpVubu
         5dVHEq7EC4OeM0FhVNBjc1QuGcN34cZYbCQaEEtuaQnyoNWeLoo10xjaCoZRKJtxHEfe
         bL1vopxOsRX/mwX/OkcsQt9zYyP1SNGcPAmtdY4U/l3USutThTd85ee4S1cs7xLV19Po
         yDRg==
X-Forwarded-Encrypted: i=1; AJvYcCW7gz7clWVBqPi/KZROnBlg0jVP8780E1Gc8C7AgCyexm6N8ieqNOsI4iR+yRKU0MJXDocoOHU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqXol/aTC0gL+TgasQjobKIA0I7s6ax5jLQDK0yYtrVy1Y3Kgg
	wN+i3ANsGmdWe7Cha+1GvaqLacsX3ooPJBIAH8LHUaLDNnM44lWynPoDMnYUoUfnaUFARlgMX2e
	AiRtRb9X/BAOokIFf8Fc+vnQTaPdFOb0oMLPVu/bEZ7SAnDz/oE0XIQ==
X-Received: by 2002:a05:600c:3511:b0:42c:b9a5:ebbc with SMTP id 5b1f17b1804b1-4311deeb82dmr21643985e9.16.1728648254799;
        Fri, 11 Oct 2024 05:04:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlfeuB8nAlpWFkyqq3l/5/SNTAJcIc1UAzpRPAo08aEFan2Um3o0PxMTwj+3rcUfvZ1UZNXw==
X-Received: by 2002:a05:600c:3511:b0:42c:b9a5:ebbc with SMTP id 5b1f17b1804b1-4311deeb82dmr21643685e9.16.1728648254344;
        Fri, 11 Oct 2024 05:04:14 -0700 (PDT)
Received: from ?IPV6:2003:cb:c749:9100:c078:eec6:f2f4:dd3b? (p200300cbc7499100c078eec6f2f4dd3b.dip0.t-ipconnect.de. [2003:cb:c749:9100:c078:eec6:f2f4:dd3b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431183062b5sm40328805e9.26.2024.10.11.05.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 05:04:13 -0700 (PDT)
Message-ID: <465ce78b-d023-40e6-b066-5e4a01e266b6@redhat.com>
Date: Fri, 11 Oct 2024 14:04:12 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] support for mm-local memory allocations and use
 it
To: Fares Mehanna <faresx@amazon.de>
Cc: akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de,
 bhelgaas@google.com, broonie@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com, javierm@redhat.com, jean-philippe@linaro.org,
 joey.gouly@arm.com, kristina.martsenko@arm.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mark.rutland@arm.com, maz@kernel.org,
 nh-open-source@amazon.com, oliver.upton@linux.dev, ptosi@google.com,
 rdunlap@infradead.org, rkagan@amazon.de, rppt@kernel.org,
 shikemeng@huaweicloud.com, suzuki.poulose@arm.com, tabba@google.com,
 will@kernel.org, yuzenghui@huawei.com
References: <813b9bcb-afde-40b6-a604-cdb71b4b6d7a@redhat.com>
 <20241010155210.13321-1-faresx@amazon.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241010155210.13321-1-faresx@amazon.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.10.24 17:52, Fares Mehanna wrote:
>>> In a series posted a few years ago [1], a proposal was put forward to allow the
>>> kernel to allocate memory local to a mm and thus push it out of reach for
>>> current and future speculation-based cross-process attacks.  We still believe
>>> this is a nice thing to have.
>>>
>>> However, in the time passed since that post Linux mm has grown quite a few new
>>> goodies, so we'd like to explore possibilities to implement this functionality
>>> with less effort and churn leveraging the now available facilities.
>>>
>>> An RFC was posted few months back [2] to show the proof of concept and a simple
>>> test driver.
>>>
>>> In this RFC, we're using the same approach of implementing mm-local allocations
>>> piggy-backing on memfd_secret(), using regular user addresses but pinning the
>>> pages and flipping the user/supervisor flag on the respective PTEs to make them
>>> directly accessible from kernel.
>>> In addition to that we are submitting 5 patches to use the secret memory to hide
>>> the vCPU gp-regs and fp-regs on arm64 VHE systems.
>>
>> I'm a bit lost on what exactly we want to achieve. The point where we
>> start flipping user/supervisor flags confuses me :)
>>
>> With secretmem, you'd get memory allocated that
>> (a) Is accessible by user space -- mapped into user space.
>> (b) Is inaccessible by kernel space -- not mapped into the direct map
>> (c) GUP will fail, but copy_from / copy_to user will work.
>>
>>
>> Another way, without secretmem, would be to consider these "secrets"
>> kernel allocations that can be mapped into user space using mmap() of a
>> special fd. That is, they wouldn't have their origin in secretmem, but
>> in KVM as a kernel allocation. It could be achieved by using VM_MIXEDMAP
>> with vm_insert_pages(), manually removing them from the directmap.
>>
>> But, I am not sure who is supposed to access what. Let's explore the
>> requirements. I assume we want:
>>
>> (a) Pages accessible by user space -- mapped into user space.
>> (b) Pages inaccessible by kernel space -- not mapped into the direct map
>> (c) GUP to fail (no direct map).
>> (d) copy_from / copy_to user to fail?
>>
>> And on top of that, some way to access these pages on demand from kernel
>> space? (temporary CPU-local mapping?)
>>
>> Or how would the kernel make use of these allocations?
>>
>> -- 
>> Cheers,
>>
>> David / dhildenb
> 
> Hi David,

Hi Fares!

> 
> Thanks for taking a look at the patches!
> 
> We're trying to allocate a kernel memory that is accessible to the kernel but
> only when the context of the process is loaded.
> 
> So this is a kernel memory that is not needed to operate the kernel itself, it
> is to store & process data on behalf of a process. The requirement for this
> memory is that it would never be touched unless the process is scheduled on this
> core. otherwise any other access will crash the kernel.
> 
> So this memory should only be directly readable and writable by the kernel, but
> only when the process context is loaded. The memory shouldn't be readable or
> writable by the owner process at all.
> 
> This is basically done by removing those pages from kernel linear address and
> attaching them only in the process mm_struct. So during context switching the
> kernel loses access to the secret memory scheduled out and gain access to the
> new process secret memory.
> 
> This generally protects against speculation attacks, and if other process managed
> to trick the kernel to leak data from memory. In this case the kernel will crash
> if it tries to access other processes secret memory.
> 
> Since this memory is special in the sense that it is kernel memory but only make
> sense in the term of the owner process, I tried in this patch series to explore
> the possibility of reusing memfd_secret() to allocate this memory in user virtual
> address space, manage it in a VMA, flipping the permissions while keeping the
> control of the mapping exclusively with the kernel.
> 
> Right now it is:
> (a) Pages not accessible by user space -- even though they are mapped into user
>      space, the PTEs are marked for kernel usage.

Ah, that is the detail I was missing, now I see what you are trying to 
achieve, thanks!

It is a bit architecture specific, because ... imagine architectures 
that have separate kernel+user space page table hierarchies, and not a 
simple PTE flag to change access permissions between kernel/user space.

IIRC s390 is one such architecture that uses separate page tables for 
the user-space + kernel-space portions.

> (b) Pages accessible by kernel space -- even though they are not mapped into the
>      direct map, the PTEs in uvaddr are marked for kernel usage.
> (c) copy_from / copy_to user won't fail -- because it is in the user range, but
>      this can be fixed by allocating specific range in user vaddr to this feature
>      and check against this range there.
> (d) The secret memory vaddr is guessable by the owner process -- that can also
>      be fixed by allocating bigger chunk of user vaddr for this feature and
>      randomly placing the secret memory there.
> (e) Mapping is off-limits to the owner process by marking the VMA as locked,
>      sealed and special.

Okay, so in this RFC you are jumping through quite some hoops to have a 
kernel allocation unmapped from the direct map but mapped into a 
per-process page table only accessible by kernel space. :)

So you really don't want this mapped into user space at all 
(consequently, no GUP, no access, no copy_from_user ...). In this RFC 
it's mapped but turned inaccessible by flipping the "kernel vs. user" 
switch.

> 
> Other alternative (that was implemented in the first submission) is to track those
> allocations in a non-shared kernel PGD per process, then handle creating, forking
> and context-switching this PGD.

That sounds like a better approach. So we would remove the pages from 
the shared kernel direct map and map them into a separate kernel-portion 
in the per-MM page tables?

Can you envision that would also work with architectures like s390x? I 
assume we would not only need the per-MM user space page table 
hierarchy, but also a per-MM kernel space page table hierarchy, into 
which we also map the common/shared-among-all-processes kernel space 
page tables (e.g., directmap).

> 
> What I like about the memfd_secret() approach is the simplicity and being arch
> agnostic, what I don't like is the increased attack surface by using VMAs to
> track those allocations.

Yes, but memfd_secret() was really design for user space to hold 
secrets. But I can see how you came to this solution.

> 
> I'm thinking of working on a PoC to implement the first approach of using a
> non-shared kernel PGD for secret memory allocations on arm64. This includes
> adding kernel page table per process where all PGDs are shared but one which
> will be used for secret allocations mapping. And handle the fork & context
> switching (TTBR1 switching(?)) correctly for the secret memory PGD.
> 
> What do you think? I'd really appreciate opinions and possible ways forward.

Naive question: does arm64 rather resemble the s390x model or the x86-64 
model?

-- 
Cheers,

David / dhildenb

