Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AC51DA0E3
	for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 17:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732641052; cv=none; b=kpd09mOaP1FdLkaIaOPKn6iQKNcVpz+cON8OvVubMSeeB3QHwULZy8o4kWnmPq4YDlbSn0d4M5EM/ixwWm7imKgBfBDPMewr/2hTxSvbkCyqO1VEbG2PfMD56Hm4SrTT84nCdOgkFXYB/eX5mGB5MXxu+LCmnRE0mYwLIJaOhus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732641052; c=relaxed/simple;
	bh=ZyGBNBNeIbh195o6EdpIawljBTKhqraCODqJVGMKWF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NoPUNN42gF5E1tTDnck4p+2AAyPNrkpinCCeAPmp13CtQusGxuIBOGQ2SgVKoDhDPdlBcKKTHpwWGjuFAp3J5tm9izWnoBNy1+0Re7Bj0CxHYiyUcFQ0+gNwMr24XQC5RMykJ17fv0AjwDAnPnqi1XjMkD1II47RK4ZMY6RO50M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TO64gHFF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TO64gHFF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732641049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pg1WH4/I0jZVgF7EzjYgTyBHdR/uKOZ3f0DDPVvbwns=;
	b=TO64gHFFVF3WZ2Hy3LkLojzMAoMVIL7FzKP9qgL2OywrTH9ehwgNqMYUG9pgW8ysJ41nCs
	tCWMZ+l3W/7HC2N57mO4Iuh+FkOz+r9/FpUQCqqBOa2Gfn4+aIEijZ/BOVfywJcEf0OBOi
	Ne5nKc7DMj37nFBa5wuHZG9Cgq9hwas=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-LdwEn9fbNnyzbrXfCjrQUw-1; Tue, 26 Nov 2024 12:10:48 -0500
X-MC-Unique: LdwEn9fbNnyzbrXfCjrQUw-1
X-Mimecast-MFC-AGG-ID: LdwEn9fbNnyzbrXfCjrQUw
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-843eb4505e7so34739139f.0
        for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 09:10:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732641047; x=1733245847;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pg1WH4/I0jZVgF7EzjYgTyBHdR/uKOZ3f0DDPVvbwns=;
        b=FllKQ6NQUgdM3X7+Eo2hpBvtC9OYBjmXkXQgml6AnvY/RlbAxmNSGtJkonFPJ1FUvG
         m52acZ+ValNwlD6jXf7QojHbPmN4kAbJbf0AFeJt+1MkxmRVbFzJeZ1TcE1ksGMyipQ1
         jcEMhEugLh/d43BgcTovYbIL81ZrlcROGLoXSs6c258kBvssu2e4K8UFHJXXN8K3HAW0
         vUb2VopHcEN31/xVcNKY4C05fXDuEFVm2OPV03aNR3dLhgGsOk0LGm+HnsTAGPKgCcDe
         D8mZLQ14mptVGdM5CHUpIfz5g/Vwhm5q4N9Y4iRf/LlxepL2rMKznSAL/lAH1KRfIL/E
         ZyVA==
X-Forwarded-Encrypted: i=1; AJvYcCWFXqtCNa0UTXhqffLUmfZ/qQacItP1GugBnLwZU3jNmNfatWlyJ3C1RL6A2eOBt8MSbycvcQE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdKCaZznfyQGCaS8vAPtaEvvLKL6AhKg3Xm6A592d7gnPLWpSq
	d3Qzl7rmGDxi3TQsY6ZGiZa9pE4Hpl67V0fNks4gd3OGLEaiaRTDWgMoGD1sfBz47wJovgtTw9M
	gMYKt83YpFsVwYsl24IY1PVnL99ERs/NqyhgKHFnbt4FVdGc2glwlQQ==
X-Gm-Gg: ASbGnctz8M2AriWdLuHyrJkB37KWRCGqURa8lqNCIsDZ3h8r9RVpvFoX887CFlvpp26
	j/B18a9JhZmk00QnlA4SCyGD1cHlCibI+g8a8ydQlgByTjNRozvvGn/cMK1qQ6+MCYPgh68LWkJ
	LeJckUKNCqPWVOyBUxMF5hjFx+lfU4XlGZWC7Ogn3LZ8WHRJlfP7aKHJM3RdVgykyy45xGpJpwf
	maDS/sw+iQqdH786bPrDmE0RqSFgOI+r0x5vx+sgjt2A6sSspw=
X-Received: by 2002:a05:6e02:16ce:b0:3a7:8a39:269e with SMTP id e9e14a558f8ab-3a79aeea927mr188257485ab.18.1732641047516;
        Tue, 26 Nov 2024 09:10:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6K6UNamiK6O/nxV7SHYbjCV/fiYY963jqY0jKdci5faeUGnSMsVF/gMvDkGoJTCkuUhR9iw==
X-Received: by 2002:a05:6e02:16ce:b0:3a7:8a39:269e with SMTP id e9e14a558f8ab-3a79aeea927mr188256395ab.18.1732641046931;
        Tue, 26 Nov 2024 09:10:46 -0800 (PST)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e1efbcaa5bsm1792326173.78.2024.11.26.09.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 09:10:46 -0800 (PST)
Message-ID: <07252361-8886-4284-bdba-55c3fe728831@redhat.com>
Date: Tue, 26 Nov 2024 12:10:24 -0500
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com,
 mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com,
 alex.williamson@redhat.com, sebastianene@google.com, coltonlewis@google.com,
 kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20241118131958.4609-1-ankita@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20241118131958.4609-1-ankita@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MUzY9Hw9eBcEnMP7lUTQXiDiKSwRrItyeYOr5Rdhnog_1732641048
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

My email client says this patch: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
   is part of a thread for this titled patchPATCH.  Is it?

The description has similarities to above description, but some adds, some drops.

So, could you clean these two up into (a) a series, or (b) single, separate PATCH's?

Thanks.

- Don

On 11/18/24 8:19 AM, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Grace based platforms such as Grace Hopper/Blackwell Superchips have
> CPU accessible cache coherent GPU memory. The current KVM code
> prevents such memory to be mapped Normal cacheable and the patch aims
> to solve this use case.
> 
> Today KVM forces the memory to either NORMAL or DEVICE_nGnRE
> based on pfn_is_map_memory() and ignores the per-VMA flags that
> indicates the memory attributes. This means there is no way for
> a VM to get cachable IO memory (like from a CXL or pre-CXL device).
> In both cases the memory will be forced to be DEVICE_nGnRE and the
> VM's memory attributes will be ignored.
> 
> The pfn_is_map_memory() is thus restrictive and allows only for
> the memory that is added to the kernel to be marked as cacheable.
> In most cases the code needs to know if there is a struct page, or
> if the memory is in the kernel map and pfn_valid() is an appropriate
> API for this. Extend the umbrella with pfn_valid() to include memory
> with no struct pages for consideration to be mapped cacheable in
> stage 2. A !pfn_valid() implies that the memory is unsafe to be mapped
> as cacheable.
> 
> Also take care of the following two cases that are unsafe to be mapped
> as cacheable:
> 1. The VMA pgprot may have VM_IO set alongwith MT_NORMAL or MT_NORMAL_TAGGED.
>     Although unexpected and wrong, presence of such configuration cannot
>     be ruled out.
> 2. Configurations where VM_MTE_ALLOWED is not set and KVM_CAP_ARM_MTE
>     is enabled. Otherwise a malicious guest can enable MTE at stage 1
>     without the hypervisor being able to tell. This could cause external
>     aborts.
> 
> The GPU memory such as on the Grace Hopper systems is interchangeable
> with DDR memory and retains its properties. Executable faults should thus
> be allowed on the memory determined as Normal cacheable.
> 
> Note when FWB is not enabled, the kernel expects to trivially do
> cache management by flushing the memory by linearly converting a
> kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). This is
> only possibile for struct page backed memory. Do not allow non-struct
> page memory to be cachable without FWB.
> 
> The changes are heavily influenced by the insightful discussions between
> Catalin Marinas and Jason Gunthorpe [1] on v1. Many thanks for their
> valuable suggestions.
> 
> Applied over next-20241117 and tested on the Grace Hopper and
> Grace Blackwell platforms by booting up VM and running several CUDA
> workloads. This has not been tested on MTE enabled hardware. If
> someone can give it a try, it will be very helpful.
> 
> v1 -> v2
> 1. Removed kvm_is_device_pfn() as a determiner for device type memory
>     determination. Instead using pfn_valid()
> 2. Added handling for MTE.
> 3. Minor cleanup.
> 
> Link: https://lore.kernel.org/lkml/20230907181459.18145-2-ankita@nvidia.com [1]
> 
> Ankit Agrawal (1):
>    KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
> 
>   arch/arm64/include/asm/kvm_pgtable.h |   8 +++
>   arch/arm64/kvm/hyp/pgtable.c         |   2 +-
>   arch/arm64/kvm/mmu.c                 | 101 +++++++++++++++++++++------
>   3 files changed, 87 insertions(+), 24 deletions(-)
> 

