Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C92222962D
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736860684; cv=none; b=bZiJdOnnCBx1FcSAvpf099Bo27Jk/jCvmFGwL3ZTBTacko+C+2uWBJySp4sY1U3zER623nyaHzdh1PjJb98O5tNqt4PTrUHzsSOUPqqADuzXrC+uYWHBrob/zJNEQ0Q4eNl5w4RHPWR5NhAJ4NPj8qRNK9rErEGyow/n9Tjw8Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736860684; c=relaxed/simple;
	bh=kaYG7PHn9d0EIsUE+vAEk6v73dG3A9g7Ynssna0Ew+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tl6b7+uZ1qWsSjkNE7nQix+o4SzXfn7NixDpCL0jaxBzHe79MnSFezAwIud/E+R0Rz6i3WhSgeSooRh8kNUpYshQs7dufncNswOh48s80tUHIhpZesYMEi5WXQpAlyQiPjXwf4W/4jtNrMB0fAyt0e0Ac6TibyBeSH4RMgmsvaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eFNoo4RA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eFNoo4RA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736860682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mhAMVHxdZUTN8U+Y4DDah1/AE6s6tsqyWOrMv5JE84c=;
	b=eFNoo4RADROON9cOvYwW9Eddx/XbsF8tCBXPDJsck6PLdiojl2GCPrJMPHhPrB5KVRQnVI
	C9RVLTC4e6BQg8Vma0fdRYFJw3SEXtXJfkO/+nPbI1FlW3f69Hcx30vv2l8alw2DkH8eup
	ljvT1njUloI4v5VMMb/mcSRNk+Xs368=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-oPX8VPkwPy61-pb76IEVcA-1; Tue, 14 Jan 2025 08:17:59 -0500
X-MC-Unique: oPX8VPkwPy61-pb76IEVcA-1
X-Mimecast-MFC-AGG-ID: oPX8VPkwPy61-pb76IEVcA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4359206e1e4so18245635e9.2
        for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 05:17:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736860678; x=1737465478;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mhAMVHxdZUTN8U+Y4DDah1/AE6s6tsqyWOrMv5JE84c=;
        b=MLMVQpAunyhwGxslPT3tkIlwm8yKe64EXJjPXNiS/CCKnLZzySKWMQLZMofudxC/mM
         JFm408EL6HbxHGuLiBTswFx1m6StTlNZbuErdDwqiwnfPbzgr1MtZ08VQWXzbod7eEQT
         uZGpKrj3o8W/zOtRL2tlV12/bgihBRY9JmcMNLHYUOZ/e4LCUTwrXQfSTDKOM5f6qQvP
         pGOGfnT4n77fCGngYtncVidPveHeyLEUzQzkvfHGkh2t1gcocbr/jjY6WHMxxEHlW89W
         JTK5BzZAZyihbzvrnbsEGAugZiQapIlm1q1R+6Ff9oh+CDWN7dfYEanckXGcitNOqzKB
         /0wA==
X-Forwarded-Encrypted: i=1; AJvYcCVDd2QZdLGHwrRunU+8BPlmmBM2GDj0yIVzozeNr4jS6qNxxg5iODzVEkTcSDEQC1YrUEGR1e4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmnusKW1UFgFbqkgog4FYq0ZoAx7luBY1/VXL4TgGWE9ggoNkL
	OdROE/+Y7ek9K5bR7omCMNb9UXzvpACnmIHszfj8W3DqHjOqh4s9K3oqw2azGqMU8YwvyCCIDAj
	BJqz05oLqp1KhxriqiBKAm8ntDaPSj9kvE4BDzq8BVc5lfDSabUtcRQ==
X-Gm-Gg: ASbGncsWC/y9cr4bV1DehU3CCXmwT9eyP4cy4PQWdqmjPCo6aAe4XCJgk+XAOp9MlPb
	TGHi8i20R8zLcLjqzF/zSSw1e0trYQGW9im2TfHI+SiQDhdeIIkY8flb6YMiaMY+VYRNp3Eurpi
	ig2DIeJLN/vhDQpq93j0LhbFIOpp50us0lveaFX5O3COEed13PrVjDCr8oc1rPYZ0SVlBKljpXE
	kUsaE1hBxIbOIvhosGxP9Lify/wWmuZ6vE+7oGX5ix8PMYsTTai1w01BAxoFzLvqUui9fMO1fj6
	5fgiYFyHhFiITc7nLHiHeIc9zfW1BAxKknwYMR/RuOtQH5QaoZ7cEi+hRnF7nGDsIPj1k6crblG
	dD9QZU3hn
X-Received: by 2002:a05:600c:6b6f:b0:436:e86e:e4ab with SMTP id 5b1f17b1804b1-436e86ee529mr227298545e9.30.1736860678232;
        Tue, 14 Jan 2025 05:17:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJcuq9n+Yk207upxq1V+5PlgSayjNukFuY/KeWuSfdqDik5LQA6RM07m1vw0jUwQHHwt55ZQ==
X-Received: by 2002:a05:600c:6b6f:b0:436:e86e:e4ab with SMTP id 5b1f17b1804b1-436e86ee529mr227297075e9.30.1736860677005;
        Tue, 14 Jan 2025 05:17:57 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9dd1957sm173922065e9.16.2025.01.14.05.17.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 05:17:52 -0800 (PST)
Message-ID: <0743193c-80a0-4ef8-9cd7-cb732f3761ab@redhat.com>
Date: Tue, 14 Jan 2025 14:17:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
To: Jason Gunthorpe <jgg@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "shahuang@redhat.com" <shahuang@redhat.com>,
 "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
 Kirti Wankhede <kwankhede@nvidia.com>,
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
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
 <20250106165159.GJ5556@nvidia.com>
 <f13622a2-6955-48d0-9793-fba6cea97a60@redhat.com>
 <SA1PR12MB7199E3C81FDC017820773DE0B01C2@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250113162749.GN5556@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250113162749.GN5556@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OqbeHZejWNEf-daBUfIYl-AJvQCvu3BMhmrZcE6641M_1736860678
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13.01.25 17:27, Jason Gunthorpe wrote:
> On Fri, Jan 10, 2025 at 09:15:53PM +0000, Ankit Agrawal wrote:
>>>>>> This patch solves the problems where it is possible for the kernel to
>>>>>> have VMAs pointing at cachable memory without causing
>>>>>> pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL
>>>>>> devices. This memory is now properly marked as cachable in KVM.
>>>>>
>>>>> Does this only imply in worse performance, or does this also affect
>>>>> correctness? I suspect performance is the problem, correct?
>>>>
>>>> Correctness. Things like atomics don't work on non-cachable mappings.
>>>
>>> Hah! This needs to be highlighted in the patch description. And maybe
>>> this even implies Fixes: etc?
>>
>> Understood. I'll put that in the patch description.
>>
>>>>> Likely you assume to never end up with COW VM_PFNMAP -- I think it's
>>>>> possible when doing a MAP_PRIVATE /dev/mem mapping on systems that allow
>>>>> for mapping /dev/mem. Maybe one could just reject such cases (if KVM PFN
>>>>> lookup code not already rejects them, which might just be that case IIRC).
>>>>
>>>> At least VFIO enforces SHARED or it won't create the VMA.
>>>>
>>>> drivers/vfio/pci/vfio_pci_core.c:       if ((vma->vm_flags & VM_SHARED) == 0)
>>>
>>> That makes a lot of sense for VFIO.
>>
>> So, I suppose we don't need to check this? Specially if we only extend the
>> changes to the following case:

I would check if it is a VM_PFNMAP, and outright refuse any page if 
is_cow_mapping(vma->vm_flags) is true.

>> - type is VM_PFNMAP &&
>> - user mapping is cacheable (MT_NORMAL or MT_NORMAL_TAGGED) &&
>> - The suggested VM_FORCE_CACHED is set.
> 
> Do we really want another weirdly defined VMA flag? I'd really like to
> avoid this..

Agreed.

Can't we do a "this is a weird VM_PFNMAP thing, let's consult the VMA 
prot + whatever PFN information to find out if it is weird-device and 
how we could safely map it?"

Ideally, we'd separate this logic from the "this is a normal VMA that 
doesn't need any such special casing", and even stop playing PFN games 
on these normal VMAs completely.


How is the VFIO going to know any better if it should set
> the flag when the questions seem to be around things like MTE that
> have nothing to do with VFIO?

I assume MTE does not apply at all to VM_PFNMAP, at least 
arch_calc_vm_flag_bits() tells me that VM_MTE_ALLOWED should never get 
set there.

So for VFIO and friends with VM_PFNMAP mapping, we can completely ignore 
that maybe?

-- 
Cheers,

David / dhildenb

