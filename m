Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011562C9A
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 12:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751631700; cv=none; b=LPH8gYteaS12CfkV02YhcI6IeSl3W3cYgVgGboC2cefPbiBz/SF0EhlRiYyMccND0PrCbJe4grzWsKI+CMMDTyrpHLssZvv2Iuw1G5HXuK7XMeqqIICMYAtERUiN6bMwxcUWmrOnEndhZlGSCD9kcaj5JNnV5j7GDhCreNJQ5Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751631700; c=relaxed/simple;
	bh=VHMgjqRbb53kMCUcKmAl1Z7kVnTGEWXvHkowxoIxsu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mmPevyDXH0E+uXvgwib6Qu/V7GM5hjJXLVCNkjlxF4KJIAtQxzYgFKzTLssMRBDD35NRpFoQZ17H4C9uzTLcvzDnQFpHuRJ3qvvsYAN2SwQMhV3OD3aG2gbT7Ztbh4WaUePdrNuF5DYNpkagUuwSL04HNv3JC8M2WsrbHh2B+GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TalVYJ0m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TalVYJ0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751631697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fkahBsI5VNxUJE8D/bd1T6fawfYSiY+jT8womBzp5i4=;
	b=TalVYJ0mO/6Q/NZEtzIuKyCOhhqw/EO4W2uYb04ztJxx+djXU2PPOaWdJPTzgViGrIILu9
	rS6uK4xJMpKpmMzdqLjNZNcmCKAOSUxEx7rLhhwminXL5CEKf/ef+f9uEYLUdheQjkX8I9
	B05iul/nW9MMZJeHwqDM/Qm3+6Nwg9o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-zLE_k-j5MkmK5WLs5Xl92A-1; Fri, 04 Jul 2025 08:21:36 -0400
X-MC-Unique: zLE_k-j5MkmK5WLs5Xl92A-1
X-Mimecast-MFC-AGG-ID: zLE_k-j5MkmK5WLs5Xl92A_1751631696
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451d5600a54so7219875e9.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Jul 2025 05:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751631696; x=1752236496;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fkahBsI5VNxUJE8D/bd1T6fawfYSiY+jT8womBzp5i4=;
        b=RHmHOEdHy8xFEO4bYI7UTQAQqSBtlc5UDdGmFy63jJI1hkNRqN+8vvtTUJbqL+8zue
         RDE7NYKuN0MUNw9gDxGtHVEcPVA9otSS8lXW7vgw04wTwGeBnpE9P6mtJQPLwEFfUNv0
         Y3ec6LHrvn9pcBgD5DOleBWsglkLxqIHJYqD74OD4Ej8ZzdZj+73eAHd9OrcNWHU6BMc
         tmI/5nNwXtU5p7AHf4bj6AMQEZ7ee8pTjP50DKfluOsKXKb9kGFBGihiMnCpmI+KNAZy
         w+g9JOCksj2JfkqBgYbtYBlc6thM2TtH6Pf0TRCYmcd92Srm+yfvtIDJTjEm+H9DU3AU
         plug==
X-Forwarded-Encrypted: i=1; AJvYcCVZT6bwAKpLo/n2fzWp4yLNSdNd//z5ww+CqPIx6fd78BWhidqGNGwwymwJDqrrBxIN2OkJffY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz98mco3J4911MewiwDad7ItEc3blDPfGsUSEJdlwRpSfXrywMP
	ju7DrONVE+PjaQLUoy2giknOAczuAAZ9zzSb95z2x5kPMDodSD5OITmPEEzlmqGliJnMgwhx35A
	HYnwbARWO4ZTfB4/qafeI1ROSjFfJdg46x7UT+BS1W0IipWoXp4QQ3gX/cw==
X-Gm-Gg: ASbGncs4JtLEYc8Zx7fn3+wg0UqI6yxWQuaE/ShNwlb2Zd+s8EElSws+wnNUJvZpxMn
	6sxWTr33SaZMj6XrKuO6vCFbbWJv1Zev83owpBb7mVT35Dyo6hUEEO7fjM8IcGRM+YLbXO4Mt24
	d2FSgjjqlBpLq0h4HjyRFM18TQdWA6f3iSmBlbi8mk5vbrnGSvfFQSvWdsCxDrzOFNodVnimo8z
	89dQbPBl4wMaCeR5vFMyc7IOEpi9aZqnb2y91EDusGpolHcOBIprtusAZ9V7+nmyp7q2rCdH0I2
	w1gmK8q20k9FrGQExOz7rkcddHLdvUTsCB/RGHyUh0mb9a64MYAHsebFofCuLojydHSYiwHd6ct
	tm/5F7bPjAX2eJ30zFugFHAL1HnaqMwu+sje/ZeqF3zQsMhI=
X-Received: by 2002:a05:600c:8b6f:b0:44b:eb56:1d45 with SMTP id 5b1f17b1804b1-454b30b4e96mr28391895e9.15.1751631695381;
        Fri, 04 Jul 2025 05:21:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXg7u6lGXcf+dIc0GhzPq0GsACARq1xT2O67ZRsTnKiJsXkcINlfprRNMS1WIcRgYppep5HA==
X-Received: by 2002:a05:600c:8b6f:b0:44b:eb56:1d45 with SMTP id 5b1f17b1804b1-454b30b4e96mr28390995e9.15.1751631694749;
        Fri, 04 Jul 2025 05:21:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:5500:988:23f9:faa0:7232? (p200300d82f2c5500098823f9faa07232.dip0.t-ipconnect.de. [2003:d8:2f2c:5500:988:23f9:faa0:7232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bde3b9sm55238795e9.28.2025.07.04.05.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 05:21:34 -0700 (PDT)
Message-ID: <4b06b163-e1ce-4c20-b878-4593bc86bf53@redhat.com>
Date: Fri, 4 Jul 2025 14:21:32 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
To: Jason Gunthorpe <jgg@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>
Cc: Will Deacon <will@kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "shahuang@redhat.com" <shahuang@redhat.com>,
 "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
 "ddutile@redhat.com" <ddutile@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>, Aniket Agashe <aniketa@nvidia.com>,
 Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>,
 Krishnakant Jaju <kjaju@nvidia.com>,
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
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-4-ankita@nvidia.com> <aF6hamOI7YVDP1Cp@willie-the-truck>
 <SA1PR12MB7199144BBDA23C9A06DA12F9B046A@SA1PR12MB7199.namprd12.prod.outlook.com>
 <20250630122501.GQ167785@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250630122501.GQ167785@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eYMEIcgd4lJha-_Gae5oV6OjMyu5L1AIHILttLDz74A_1751631696
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.06.25 14:25, Jason Gunthorpe wrote:
> On Mon, Jun 30, 2025 at 01:56:43AM +0000, Ankit Agrawal wrote:
>>> Sorry for the drive-by comment, but I was looking at this old series from
>>> Paolo (look at the cover letter and patch 5):
>>>
>>> https://lore.kernel.org/r/20250109133817.314401-1-pbonzini@redhat.com
>>>
>>> in which he points out that the arm64 get_vma_page_shift() function
>>> incorrectly assumes that a VM_PFNMAP VMA is physically contiguous, which
>>> may not be the case if a driver calls remap_pfn_range() to mess around
>>> with mappings within the VMA. I think that implies that the optimisation
>>> in 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device
>>> MMIO") is unsound.
>>
>> Hm yeah, that does seem problematic. Perhaps we need a new
>> vma flag that could help the driver communicate to the KVM that the
>> mapping is contiguous and it can go ahead with the optimization?
>> E.g. something similar to VM_ALLOW_ANY_UNCACHED.
> 
> I think Paolo has the right direction - remove any attempts by KVM to
> expand contiguity, it should only copy the primary's PTEs and rely on
> the primary to discover contiguity. No new flags.

100%

-- 
Cheers,

David / dhildenb

