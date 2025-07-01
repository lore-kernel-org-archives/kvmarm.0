Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B2275877
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751381072; cv=none; b=gijQ/7JEUt89XHBhbxp8chSx3DW5+1vD4eiAS58N9aJsr8RQlehlmhaLLFz9EH88FtOmjZAoZzUV8WeV6TIo45z/TWc2mKF0wlf+U/EAb5kBoJmI8a7XYFexgWTw1Vv0vmgm/rw1qOEoZWAYk5uk3iov1G4Bid3OaukQI8VfO7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751381072; c=relaxed/simple;
	bh=bR+FI6Za2/zIbjtOtb8TI450N4jEdH7JboPdnny+88A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JJ6OIejNor6r4WE5UkEBUNJuEA5AEbS8hC/KAgBgLjqy9Z4z0Y8j1B3TeBO6pfLbpFg4lGZAwkk443HgG53nWUJh/q74iwWc1WDIzMnkHhZtDwMYD1/4W9x8G8xKrZOF2CNMRNGtSQ3o5alLd4rhjgyumw0pL+FyHT6jZe3IjOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NMjUH1Pc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NMjUH1Pc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751381069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=efTfetSQvXDnyHYs6dTLcgxq7ccfUWuGzNDdGLySXso=;
	b=NMjUH1PcXku2YfPHFNxQ62+wNnGSS7URkMFVndflR14aE/f97cASIFeQxISZk6Vb+J0R9i
	jQ2CXhBx05JDv6jrGF44/4H79haJjB6LOoyk740WpBnFbirgqL6LqaJQ36gxK71XXx74eQ
	kF/MDG2wKTaBXXLRjSS+9lBYp8tSr24=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-t3EhP_HsMrePCrM53Bhddg-1; Tue, 01 Jul 2025 10:44:27 -0400
X-MC-Unique: t3EhP_HsMrePCrM53Bhddg-1
X-Mimecast-MFC-AGG-ID: t3EhP_HsMrePCrM53Bhddg_1751381067
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4536962204aso13613355e9.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Jul 2025 07:44:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751381066; x=1751985866;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=efTfetSQvXDnyHYs6dTLcgxq7ccfUWuGzNDdGLySXso=;
        b=vVCvT9Dz41Xfr6X5jGL2W0Fgy29y3w1O7xw3SihLExsRT4iLb9ubirm8mNQtClaUmd
         w+DYrzxCLZ3mI86HjISRtJKiU6vm4jOwuHYZzNQXUv44vJ8Aj5TWzTxP7sF31ofyZkbP
         TEl27w2YgS65kHaqsx0hsiLNOtkmAlmvvYqR0uZbtf3Ir10vMNSZgH5G/KLZdzX2Et3M
         1j3ZFNGQgJ04zXYHGUjz5aQhrgEtSKz1T026ygyUHK3p68GV12xuU9nN06rNwONuaPSQ
         EfFqldEnEg6c1OeWwEOuM0tQZ//NubqOGeQUC1D4IIRMNWQkKPoAr1ZOMQ9+Cly1r0lh
         FLkg==
X-Forwarded-Encrypted: i=1; AJvYcCU4B49JizRisWiP2yDPvsQHpqzDbp3h5yjh3uFFrO5gWyw0ggr8pHefp54xf8bSvwd4BEMNEZg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzsf5FRF8FLW8izvxFe3Pw9A8ILUYGZrz8rc3eCSsxVbEhTUHb+
	EnvKLS1QZ1kyWmCdIqIRlW2af0LaxgwbVA8w91R5oVsCQytUI4pQfRma35FRBaHGVhA4So1QkMQ
	/gY2okxXcbDmcrrjLdogsey1EkFbFrI1EV0ZYorTgvh94/nLQVHH4j0HNzg==
X-Gm-Gg: ASbGncuBRDADJZwVBK2yNhi+ZrMO0RObt8ykjJWQ3zPN7FGQjRlNA5C/RIzTUk8+nvJ
	Ai25Rn7ynPFV3kBi+yvOOuOQIPWjloVgJv3DD7GZ7vwXIjyK8AXtV+27uzucich2BykvcQr5yNr
	en38xpv/WnCwwtkqzzG+EOl01i9SYaGdql1dGK3b5yvhZfNW2sMf6QRyu6QaPY9wB/uKg0cHC21
	0I/As+T7FVrpHcaMMgjE98uthSOnMq+F9CbRvQpT4zPf/Jnr12zKgPAIi1Xt43IePoEjexldS1F
	AVVvMsYkkrMel1kw4nwFRHe569qtEpgAm7EeQFJvgkrY4Xw2K/Z00wHV6Dv1G4aiQU3VPVrQbPP
	0v+nDXAxgyRBDfQOwOSENyga29jxiqkRyfPn50aBVbLXjReMxbQ==
X-Received: by 2002:a05:6000:23c8:b0:3a4:eef9:818a with SMTP id ffacd0b85a97d-3a8ff51fb85mr10746959f8f.27.1751381066470;
        Tue, 01 Jul 2025 07:44:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8EffOdFk4TDMeDcgi45o1n1fl4XlGJHCw57SfIvSFRekAhPXJ1smdIyNo6k5GXpdljvAMQw==
X-Received: by 2002:a05:6000:23c8:b0:3a4:eef9:818a with SMTP id ffacd0b85a97d-3a8ff51fb85mr10746912f8f.27.1751381065847;
        Tue, 01 Jul 2025 07:44:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:7500:202e:b0f1:76d6:f9af? (p200300d82f187500202eb0f176d6f9af.dip0.t-ipconnect.de. [2003:d8:2f18:7500:202e:b0f1:76d6:f9af])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7fb20esm13693987f8f.36.2025.07.01.07.44.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 07:44:25 -0700 (PDT)
Message-ID: <0cdc7890-aade-4fa5-ad72-24cde6c7bce9@redhat.com>
Date: Tue, 1 Jul 2025 16:44:22 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>,
 Fuad Tabba <tabba@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-11-tabba@google.com> <aEyhHgwQXW4zbx-k@google.com>
 <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
 <diqzv7odjnln.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTwqOwO2zVd4zTYF7w7reTWMNjmCV6XnKux2JtPwYCAoZQ@mail.gmail.com>
 <434ab5a3-fedb-4c9e-8034-8f616b7e5e52@amd.com>
 <923b1c02-407a-4689-a047-dd94e885b103@redhat.com>
 <diqz34bg575i.fsf@ackerleytng-ctop.c.googlers.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <diqz34bg575i.fsf@ackerleytng-ctop.c.googlers.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6SdD4lqJLxIZU51lBLnY4pRifROYbwCzDI1tdVpM4bo_1751381067
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>> I support this approach.
>>
>> Agreed. Let's get this in with the changes requested by Sean applied.
>>
>> How to use GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM with
>> legacy mem attributes (-> all memory in guest_memfd private) could be
>> added later on top, once really required.
>>
>> As discussed, CoCo VMs that want to support GUEST_MEMFD_FLAG_MMAP will
>> have to disable legacy mem attributes using a new capability in stage-2.
>>
> 
> I rewatched the guest_memfd meeting on 2025-06-12.  We do want to
> support the use case where userspace wants to have mmap (e.g. to set
> mempolicy) but does not want to allow faulting into the host.
> 
> On 2025-06-12, the conclusion was that the problem will be solved once
> guest_memfd supports shareability, and that's because userspace can set
> shareability to GUEST, so the memory can't be faulted into the host.
> 
> On 2025-06-26, Sean said we want to let userspace have an extra layer of
> protection so that memory cannot be faulted in to the host, ever. IOW,
> we want to let userspace say that even if there is a stray
> private-to-shared conversion, *don't* allow faulting memory into the
> host.
> 
> The difference is the "extra layer of protection", which should remain
> in effect even if there are (stray/unexpected) private-to-shared
> conversions to guest_memfd or to KVM. Here's a direct link to the point
> in the video where Sean brought this up [1]. I'm really hoping I didn't
> misinterpret this!
> 
> Let me look ahead a little, since this involves use cases already
> brought up though I'm not sure how real they are. I just want to make
> sure that in a few patch series' time, we don't end up needing userspace
> to use a complex bunch of CAPs and FLAGs.
> 
> In this series (mmap support, V12, patch 10/18) [2], to allow
> KVM_X86_DEFAULT_VMs to use guest_memfd, I added a `fault_from_gmem()`
> helper, which is defined as follows (before the renaming Sean requested):
> 
> +static inline bool fault_from_gmem(struct kvm_page_fault *fault)
> +{
> +	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
> +}
> 
> The above is changeable, of course :). The intention is that if the
> fault is private, fault from guest_memfd. If GUEST_MEMFD_FLAG_MMAP is
> set (KVM_MEMSLOT_GMEM_ONLY will be set on the memslot), fault from
> guest_memfd.
> 
> If we defer handling GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM
> with legacy mem attributes to the future, this helper will probably
> become
> 
> -static inline bool fault_from_gmem(struct kvm_page_fault *fault)
> +static inline bool fault_from_gmem(struct kvm *kvm, struct kvm_page_fault *fault)
> +{
> -	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot);
> +	return fault->is_private || (kvm_gmem_memslot_supports_shared(fault->slot) &&
> +	                             !kvm_arch_disable_legacy_private_tracking(kvm));
> +}
> 
> And on memslot binding we check
> 
> if kvm_arch_disable_legacy_private_tracking(kvm) and not GUEST_MEMFD_FLAG_MMAP
> 	return -EINVAL;
> 
> 1. Is that what yall meant?

My understanding:

CoCo VMs will initially (stage-1) only support !GUEST_MEMFD_FLAG_MMAP.

With stage-2, CoCo VMs will support GUEST_MEMFD_FLAG_MMAP only with 
kvm_arch_disable_legacy_private_tracking().

Non-CoCo VMs will only support GUEST_MEMFD_FLAG_MMAP. (no concept of 
private)

> 
> 2. Does this kind of not satisfy the "extra layer of protection"
>     requirement (if it is a requirement)?
> 
>     A legacy CoCo VM using guest_memfd only for private memory (shared
>     memory from say, shmem) and needing to set mempolicy would
>     
>     * Set GUEST_MEMFD_FLAG_MMAP
>     * Leave KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaulted to false
>     
>     but still be able to send conversion ioctls directly to guest_memfd,
>     and then be able to fault guest_memfd memory into the host.

In that configuration, I would expect that all memory in guest_memfd is 
private and remains private.

guest_memfd without memory attributes cannot support in-place conversion.

How to achieve that might be interesting: the capability will affect 
guest_memfd behavior?

> 
> 3. Now for a use case I've heard of (feel free to tell me this will
>     never be supported or "we'll deal with it if it comes"): On a
>     non-CoCo VM, we want to use guest_memfd but not use mmap (and the
>     initial VM image will be written using write() syscall or something
>     else).
> 
>     * Set GUEST_MEMFD_FLAG_MMAP to false
>     * Leave KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaulted to false
>       (it's a non-CoCo VM, weird to do anything to do with private
>       tracking)
> 
>     And now we're stuck because fault_from_gmem() will return false all
>     the time and we can't use memory from guest_memfd.

I think I discussed that with Sean: we would have GUEST_MEMFD_FLAG_WRITE 
that will imply everything that GUEST_MEMFD_FLAG_MMAP would imply, 
except the actual mmap() support.

-- 
Cheers,

David / dhildenb

