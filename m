Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF3622FDF2
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733846212; cv=none; b=q+TvHneiklQjhqVg8kfP7QRr2jaB5C8nVT/SHI/ZlJn9vB5L7sKGnoCZWKg8UiyrVuXS+iHFyXVMVzKU8gqU5/BSD2QvrrQ0V9/aDg15Pa8Beyk1IydSbD4k0vSqk0zWau+5jnjUC+ZdMrf9dw0ahIjpaQm9NcweoQFRPg20SkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733846212; c=relaxed/simple;
	bh=SzR+uX2G10Zb0oIitnBL937V9VC0oJl6Rj07zpVuMlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n+7+oCUg4GldsfgmodQSxkhh8DjQjXxBTgAukcKBjrfF2Ok8tWiFbiTFSFrv1dHZiGnXGTouDJEb7PkVFSjSXG9EmsEnGwJ/3aw2KR3iuXDhVion8yd2ZApXgGjypQKtWqRqx4YiyD0pr8A7/AIyZ3EwTX+1qB/7eNUZCTQ/W7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RvUcSeuk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RvUcSeuk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733846209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6COf3Hkk0aQA9lsD0i2AqUa4d4P/34xWsXqJ5E4hUk=;
	b=RvUcSeukDNbR4QaxVrNt90me8idF7L8YglgPMpQQIBuPAZQ+74JKNc0LoJhdZ/1Ln2ie48
	npc6Ybt1rSmIY6UMTjVsdyecwbg2j/PGxcMAovM/VG+1fnQpEqnAHsjYYqm7VEThikUMgx
	qPtDzt2iMwZAXjsq4o6sxWjuq84M8PE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-facgWMRPMMWCChOITY1WYg-1; Tue, 10 Dec 2024 10:56:48 -0500
X-MC-Unique: facgWMRPMMWCChOITY1WYg-1
X-Mimecast-MFC-AGG-ID: facgWMRPMMWCChOITY1WYg
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844b916f499so104035539f.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:56:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733846208; x=1734451008;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O6COf3Hkk0aQA9lsD0i2AqUa4d4P/34xWsXqJ5E4hUk=;
        b=tag6GJAuqtvgJQj8dnEkDhH6xCUM7bIjQQkKl/kgigJT7sq/Fo7Qc1cnYWYCsBWM0K
         8j1GhNNVuf2TIGpRedjCIv6kx6Gc+eflVLsV+hvOHgIbchJAa1Ay7W2pTWpewMRGmIdi
         BT46Xku0W4AxSISJd5/jG+dTBlNdLvp7/cSB7ir7NMhGiOFRoQxQVDEoffXDLL+ckAli
         zWDzvzqPFDHmhU6pBKAjeZeLOMTf1uS3vCJUsEXiRUgIXZdXuyBPfrJuQ4jpzTN1ILNW
         AjWD8a9oldfGkwf0srkTVcnTg3DDBKrxo3+P0Mp3D5AzMOvYMDehZv56wqKWd0ScgOfS
         5RKw==
X-Forwarded-Encrypted: i=1; AJvYcCXmaMcuUbNLEZcY/S8EKsTcuRUUQw8ClcNuW4rTQwkqhGirBXv/QRkSdIqh5/n3rFRQG/JKZ/I=@lists.linux.dev
X-Gm-Message-State: AOJu0YzviDsyMD4tAslDDCd8fMR8F8XxjlXVQU0/IYEcuru4VKPBY7Eh
	qRZzUd1859fn4q3odMz2kyyYZznVhtOBJtinXqu6hv+9IWND7so5N5lt4hP4a49W9jTTRlYF0h/
	Ms373QflAe2mBaqo2PcL8A87z9J4yxU1nZn7/Cg9j6mbK0evUK6IHKg==
X-Gm-Gg: ASbGnctOxVvRajbqYCS5S2xq5H7qXCx+Rppq9W2ooZTwGUIKfoqBZ0diGjNmrQVA05G
	5I88He18uuv63GwUWpHKHrulgPUBtDVlTKVE08esp1wi4p8s5pUYQV4hb/3f0vcDaOs0S8Kcuf7
	pGQVREC+SDOcGttA0p74/siguCAau1d77cTj5dv7PcEoq3bCpjm3zE0GaMCZyZIEbwCtQiejnDP
	a0tTcWVqyxSdS/1kZSWDmkzg0GI2/Vo2v2P8ItZxKjGsLW0557dS9w=
X-Received: by 2002:a05:6602:a108:b0:83a:943d:a280 with SMTP id ca18e2360f4ac-844b87f7863mr300002439f.1.1733846208064;
        Tue, 10 Dec 2024 07:56:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGO/en2fuAvQyTs2jHHMl4LqDZEtajqMB/Su9iQAs0bW7stQDAwQKFTzGD6u5DQDQ+uVMvWSg==
X-Received: by 2002:a05:6602:a108:b0:83a:943d:a280 with SMTP id ca18e2360f4ac-844b87f7863mr299997739f.1.1733846207687;
        Tue, 10 Dec 2024 07:56:47 -0800 (PST)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2bf67d125sm1155622173.96.2024.12.10.07.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 07:56:47 -0800 (PST)
Message-ID: <0723d890-1f90-463b-a814-9f7bb7e2200b@redhat.com>
Date: Tue, 10 Dec 2024 10:56:43 -0500
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
To: Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, ryan.roberts@arm.com, shahuang@redhat.com,
 lpieralisi@kernel.org, aniketa@nvidia.com, cjia@nvidia.com,
 kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
 acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
 danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
 dnigam@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com,
 coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
 ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
 linux-mm@kvack.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241210140739.GC15607@willie-the-truck>
 <20241210141806.GI2347147@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20241210141806.GI2347147@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a9o4LhbgpzmxV20jSGtcbQGwAJ2ucIT2Ln8-oO7hQvU_1733846208
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/10/24 9:18 AM, Jason Gunthorpe wrote:
> On Tue, Dec 10, 2024 at 02:07:40PM +0000, Will Deacon wrote:
>> On Mon, Nov 18, 2024 at 01:19:57PM +0000, ankita@nvidia.com wrote:
>>> The changes are heavily influenced by the insightful discussions between
>>> Catalin Marinas and Jason Gunthorpe [1] on v1. Many thanks for their
>>> valuable suggestions.
>>>
>>> Link: https://lore.kernel.org/lkml/20230907181459.18145-2-ankita@nvidia.com [1]
>>
>> That's a different series, no? It got merged at v9:
> 
> I was confused by this too. v1 of that series included this patch, as
> that series went along it became focused only on enabling WC
> (Normal-NC) in a VM for device MMIO and this patch for device cachable
> memory was dropped off.
> 
> There are two related things:
>   1) Device MMIO memory should be able to be Normal-NC in a VM. Already
>      merged
>   2) Device Cachable memory (ie CXL and pre-CXL coherently attached
>      memory) should be Normal Cachable in a VM, even if it doesn't have
>      struct page/etc. (this patch)
> 
> IIRC this part was dropped off because of the MTE complexity that
> Catalin raised.
> 
> Jason
> 
Jason & Catalin: Thanks for the filler for the splitting.

So, I'm not sure I read what is needed to resolve this patch.
I read Will's reply to split it further and basically along what logical lines of functionality;
is there still an MTE complexity that has to be resolved/included in the series?

IOW, I'm looking for a complete, clear (set of) statement(s) that Ankit can implement to get this (requested) series moving forward, sooner than later;
it's already been a year+ to get to this point, and I don't want further ambiguity/uncertainty to drag it out more than needed.

Thanks... Don

