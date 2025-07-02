Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6997B289E39
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751475184; cv=none; b=Pk5rlFf0VSoLi5JF0nI+O4gcqzj8c3MBd3HTayWlxjfYyXp1kjIAzNf9tKSVfJtVtOL+HWdxwrlsf165s7vLocSFg7FO+nZVETO4lIfSfm+gcfpXEoi6nA+Qqu2uTrXP4OUrhFAj+VSt74GOcVDMYOtLTgrKp3V+fsP+N6SjLCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751475184; c=relaxed/simple;
	bh=eYBPhk4sV4GO/PBkfuhrYLwaeqNoDsM3graeutBFqgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pChcZvGXBBJY9k2nsBf6COTXuV9fABt/CaJGcyZ9KP8uUgjw8tDYXDM4MYeh1ita23s6MZMHJTfDmtjSFqJa2UtUxQpwSuO+KLkJqqhMm+el3UQWHWgJOnL/IopRuQlSzdKefpexCA7TbqzGSm4k/ENHeX16418Nv+lafRnXnbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AmF5GzXV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AmF5GzXV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751475181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BYPE9kAm4n5JaaAj3WmzYSVaYGMobSZ1mvZBnXOb9Jo=;
	b=AmF5GzXV+0X/pMaLKu4boIUsFImSJD5HnJpRmiA19IvJ2hKJuLiIHCO6FlxiqQRz9sAGjP
	B/Mp1iU16B21dZ0ooi3yhVmdQIQLCfqGAEWisz2KV5UeDNtoe3HDGu7KGBp0i3lK2vf6LN
	5P7Lm/y0HY3tKv9uxN7vO31VLA9LSSo=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-zRogW451Mj6WHI7JjkK_Xg-1; Wed, 02 Jul 2025 12:52:58 -0400
X-MC-Unique: zRogW451Mj6WHI7JjkK_Xg-1
X-Mimecast-MFC-AGG-ID: zRogW451Mj6WHI7JjkK_Xg_1751475177
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2eb1763cb08so4147055fac.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Jul 2025 09:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751475177; x=1752079977;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BYPE9kAm4n5JaaAj3WmzYSVaYGMobSZ1mvZBnXOb9Jo=;
        b=ZnlvBtH1f0tHOM7heTLHYRK/5wjoXvLj4naOcxB0jveilgl6ykRJKiIdXAz0xLnuWZ
         HD5lFxN61Tg4LGkBA6b+XWYFCAEO4T3Pz3x94mXdB6gUOo2NZ7wjB54wiSKNwTh9paVC
         3krZ74Ek/tcAcxlIwEdgsXOMA+4pguhdscgUOnNpXF2il7NrBytUXrphfGiWHhRzhCo7
         BqxIY5R7U9GCzYsQXpAwiwhvkfhKHS79Dwq0IsVChX+zkbykThRpzZfMTen7fU4OL0/z
         iXHET6m0xKpbaMV9iGunhzIlgNGPUFF/yhTHoor9t/MgXSLH00WVtNMtW3IpJG91etGK
         LT9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLp73ydXgN7adxyhXQ/bOwHstYcDFgj3WonPqP4pmIJyGz7WQbLQedUDFQUagaghONOn/CVgw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw39FEoX7QESftjt9ZGWaRHyfU7CjEY8qvq1+Fh0nJw3jjCCXpW
	EaPaBZtPTiEbYMY4sxg6rDJbsxvenENXzSPZRJ1OhyQ+kW28JL1ewKnr2HSNwTkL0HCIn21eb0U
	kPaKbUakQve5lySvnUj553zipx9EDt1OjLGtikjyUujUXjX43AQqeMCDaBA==
X-Gm-Gg: ASbGncuuCdrgdGIAYljjRlF2P79mhHtAA23N4d7BoH2NSSF9Rtx2lNMezR4AIYwLq0x
	/VJ1tUBOPBDL2PuMcZTorm+fB290c0t5D2gNM4kbnwip7BN5rZYGbcSgLqIj+Y/FmzNFNKC1wPC
	TTWGbYO/tuGJ1G95Pgos77ITHifZNQ0uodheDIOsUho+VSRKy0pfxCrN0Bk5PooMLrOuHMM190F
	nG8tMZEyC0caobTkE53FJmdzj2ftoUM3rJr9F9/S5v5aO4H0evk0zA3VrhDoihQ0XBFl5MtvAos
	bOF981UUnorplZvZpKuaoKA=
X-Received: by 2002:a05:6870:c18c:b0:2ea:6ec5:f182 with SMTP id 586e51a60fabf-2f76cb4ee23mr82925fac.38.1751475177345;
        Wed, 02 Jul 2025 09:52:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8xhPj4vbeCO6BR/7uWOvOuQ5ERydvemFdCvd/3yMMwrMEKbwcC+0fs0OrYA1xZmzNSwVtTg==
X-Received: by 2002:a05:6870:c18c:b0:2ea:6ec5:f182 with SMTP id 586e51a60fabf-2f76cb4ee23mr82872fac.38.1751475176870;
        Wed, 02 Jul 2025 09:52:56 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73afafee51bsm2562567a34.10.2025.07.02.09.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 09:52:56 -0700 (PDT)
Message-ID: <1a14ee0a-04af-407d-89a5-5222ee6da9c7@redhat.com>
Date: Wed, 2 Jul 2025 12:51:06 -0400
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/6] KVM: arm64: Map GPU device memory as cacheable
To: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "shahuang@redhat.com" <shahuang@redhat.com>,
 "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Dan Williams <danw@nvidia.com>, Zhi Wang <zhiw@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, Uday Dhoke <udhoke@nvidia.com>,
 Dheeraj Nigam <dnigam@nvidia.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "sebastianene@google.com" <sebastianene@google.com>,
 "coltonlewis@google.com" <coltonlewis@google.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
 <ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "tabba@google.com" <tabba@google.com>,
 "qperret@google.com" <qperret@google.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <SA1PR12MB7199F8346F2CA802E9F3965DB040A@SA1PR12MB7199.namprd12.prod.outlook.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <SA1PR12MB7199F8346F2CA802E9F3965DB040A@SA1PR12MB7199.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JYsR7JTXGihaquS6m_3gYeSh1Pn-WoPPdnNyKi_ubzk_1751475177
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/2/25 5:33 AM, Ankit Agrawal wrote:
>> Grace based platforms such as Grace Hopper/Blackwell Superchips have
>> CPU accessible cache coherent GPU memory. The GPU device memory is
>> essentially a DDR memory and retains properties such as cacheability,
>> unaligned accesses, atomics and handling of executable faults. This
>> requires the device memory to be mapped as NORMAL in stage-2.
>>
>> Today KVM forces the memory to either NORMAL or DEVICE_nGnRE depending
>> on whether the memory region is added to the kernel. The KVM code is
>> thus restrictive and prevents device memory that is not added to the
>> kernel to be marked as cacheable. The patch aims to solve this.
>>
>> A cachebility check is made by consulting the VMA pgprot value. If
>> the pgprot mapping type is cacheable, it is considered safe to be
>> mapped cacheable as the KVM S2 will have the same Normal memory type
>> as the VMA has in the S1 and KVM has no additional responsibility
>> for safety.
>>
>> Note when FWB (Force Write Back) is not enabled, the kernel expects to
>> trivially do cache management by flushing the memory by linearly
>> converting a kvm_pte to phys_addr to a KVA. The cache management thus
>> relies on memory being mapped. Since the GPU device memory is not kernel
>> mapped, exit when the FWB is not supported. Similarly, ARM64_HAS_CACHE_DIC
>> allows KVM to avoid flushing the icache and turns icache_inval_pou() into
>> a NOP. So the cacheable PFNMAP is made contingent on these two hardware
>> features.
>>
>> The ability to safely do the cacheable mapping of PFNMAP is exposed
>> through a KVM capability for userspace consumption.
>>
>> The changes are heavily influenced by the discussions among
>> maintainers Marc Zyngier and Oliver Upton besides Jason Gunthorpe,
>> Catalin Marinas, David Hildenbrand, Sean Christopherson [1]. Many
>> thanks for their valuable suggestions.
>>
>> Applied over next-20250610 and tested on the Grace Blackwell
>> platform by booting up VM, loading NVIDIA module [2] and running
>> nvidia-smi in the VM.
>>
>> To run CUDA workloads, there is a dependency on the IOMMUFD and the
>> Nested Page Table patches being worked on separately by Nicolin Chen.
>> (nicolinc@nvidia.com). NVIDIA has provided git repositories which
>> includes all the requisite kernel [3] and Qemu [4] patches in case
>> one wants to try.
>>
>> v8 -> v9
>> 1. Included MIXEDMAP to also be considered for cacheable mapping.
>> (Jason Gunthorpe).
>> 2. Minor text nits (Jason Gunthorpe).
> 
> Humble reminder for review.
> 

Apologies for the delay, I had some issues getting a Grace-Hopper to test on,
and a VM that needed to be adjusted(bigger file system) to run the 12.9.1 CUDA install script.

Anyhow, able to assign a G-H GPU to a VM under qemu-kvm, and in the
guest, successfully perform an 'nvidia-smi'.  Previously, without this patch
series in the host, the nvida-smi command would fail and hang the guest.
(qemu-kvm was qemu-10.0 -based)

If anyone wants more details, or want more tests run, feel free to ask;
I can probably keep the system for another day or two, but I'll have to
give it up by this Friday.

Tested-by: Donald Dutile <ddutile@redhat.com>

