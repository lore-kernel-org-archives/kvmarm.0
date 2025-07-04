Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8436A156677
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 14:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751638175; cv=none; b=DWPFdJdk0iteoQ1KlkIquWDBV5/XcIEMW85Qf+68gMx/1L+YpRxV7RuFhqqzZ3zkyB+Yur98VB5cI/JB39lTyP4ujxfF2VrnaYaoUdq56I8ZbrtdG4MYzuKvLANlhjr/36gtRV4FQWmGa1dymQYSN/CFwQF9ttlb++NdbMYd0CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751638175; c=relaxed/simple;
	bh=A6RBquJ08q+b65DHW+EnJEmaNBWoi7Aak/3WJ7xL7og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RmOsubVWecUU0eosU0fIRheE8ZEYtDwLUWb/vAd01AHugJja/OP+jeKnT9N2wBHaTZ45TkFRTMbu5MaLM/gPLMQZYtR6ICknC4zL4H57Y46w1m2GI1m9Wm/36rYDPangTmTqjgNGnb2QSqZaee8uJjxP3aT6IwTaLm74ze5Ow6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ARyHvwE5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ARyHvwE5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751638172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nt7xUyaSY2bwlKzrDx5dkOnSZrDMwc3BRrdM7IQmPSg=;
	b=ARyHvwE5G5jkmUhq7NoiJgjNdYWz8tVOKtrRiLqu+O2gZqshRgztgAK0eFXNT7+7N1QxnS
	Z6Q+lHEbI+QcVWjqp3DwoB0HsoP0i4fXXihLWjzLbAGtytXRmjuab5RzuLsoR0XF6k406x
	sJ84h3mZvyt1+rUotzoXErfNtWu6ubI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-3PWrdkJkOdeTHlq7mYKNHw-1; Fri, 04 Jul 2025 10:09:31 -0400
X-MC-Unique: 3PWrdkJkOdeTHlq7mYKNHw-1
X-Mimecast-MFC-AGG-ID: 3PWrdkJkOdeTHlq7mYKNHw_1751638170
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f6ba526eso663577f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Jul 2025 07:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751638170; x=1752242970;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nt7xUyaSY2bwlKzrDx5dkOnSZrDMwc3BRrdM7IQmPSg=;
        b=nB4DgWLhpNMwFMP8y7ImtFi/V7jSXICLiqlYBLofxBVKvSj8HdgZch5LEf580Drosz
         +YfxaYMF97fSMDmrwwS3cOOhmbNFc4k/AnQqZDvme+7esPPxnT+s9gJnFR5bZzhiu3iq
         z/U1/C5x5Bnrkn3tfFPp/8U5q2CnZ3WYxN5pSzAopcAbmVnMxjPelePZr4HWDj659m7B
         avU0Tmy0ov5S+6pL7XwK7QTxVnCJhfxKvxIemN58VxfGXbv4OaTrp1BYJ5LeO972zSoJ
         EYC3AM0esG9Dy3QBpVOC+L2xqFUmlyFPcXrnpfnKzx7+4Ycbg5jIDl9rB0pGyJHAorDz
         CYEA==
X-Forwarded-Encrypted: i=1; AJvYcCX+a7PgE4iEl7QQpRHpNoduwhljXrKgWFdLBtXGpzE6hNs5zTGCMUfmPf9Zsv4pJFckA52xMKo=@lists.linux.dev
X-Gm-Message-State: AOJu0YznzklWz/n3hFpJdxAQEfbO/5eiaO4chdvpiwzqROlO2O7MwI9Z
	fonBRNKBmnsxr/cM+hLhmkhocJOoO4vlduxtR8Asg+hjI53BSC54psAL2NdEkgHGB8LV+Cj8kfL
	5t+eb0WKgYHy35rmmQYUOKhRZ9NsvdEERsLPU7I5A6wHy99mG130PYLbkwg==
X-Gm-Gg: ASbGnctD+m9/Nu5gLIhVrsW0dO4WyCkGw+s27D8bqkFj9g7pZEHe6SiL7IBBRr1Cogt
	DGb6R7nTyIFOjzQk8yknWsWRAQRdJIL1Kiapb9K7Ytact1EYOihWIuJXXN4GkIjJOIEGkkVkMho
	m42ZMQ7Ojageb+zf497o/yUPLdXAXIWaI0gppUD9S1Qeek0Jwj1VChRmPArZIyDCrWbryyd4ZIJ
	/GzA/7R2pC4J4lJ+o0dalNqWfNdP5t97/kUcP/x4t80yiUUi5MDMWsH2JKthB60+0hdQOMGGfv1
	WtFqN1XkebH4dTVVpwHmJm9AmSaA9DPeSR4DZdLuFwxgELKn43pp6oAWsV96pzgVj2zneErk9nN
	UObCRplmVBybCpqLhtzY97FCU8QCimLbAe2baEYeubaHQ228=
X-Received: by 2002:a5d:584c:0:b0:3a4:e68e:d33c with SMTP id ffacd0b85a97d-3b49661da3fmr2465482f8f.47.1751638169935;
        Fri, 04 Jul 2025 07:09:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyZaHm3cvEEMqssF8essbFIJLOElulWn/9VcRsQbLa7wt2W+gUgffDY85V2Xx5K0zPawIpyw==
X-Received: by 2002:a5d:584c:0:b0:3a4:e68e:d33c with SMTP id ffacd0b85a97d-3b49661da3fmr2465397f8f.47.1751638169344;
        Fri, 04 Jul 2025 07:09:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:5500:988:23f9:faa0:7232? (p200300d82f2c5500098823f9faa07232.dip0.t-ipconnect.de. [2003:d8:2f2c:5500:988:23f9:faa0:7232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454b16865c2sm27363175e9.19.2025.07.04.07.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 07:09:28 -0700 (PDT)
Message-ID: <9c45c671-9330-493f-9a8b-2c08062ea0f9@redhat.com>
Date: Fri, 4 Jul 2025 16:09:26 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] KVM: arm64: Block cacheable PFNMAP mapping
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org,
 ddutile@redhat.com, seanjc@google.com
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 kjaju@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
 acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
 danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com, udhoke@nvidia.com,
 dnigam@nvidia.com, alex.williamson@redhat.com, sebastianene@google.com,
 coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
 ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
 linux-mm@kvack.org, tabba@google.com, qperret@google.com,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, maobibo@loongson.cn
References: <20250621042111.3992-1-ankita@nvidia.com>
 <20250621042111.3992-4-ankita@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250621042111.3992-4-ankita@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xfBO2zgHsdS_lCTFBZay8xvrNAjtSEZ94WNKB9Pyy38_1751638170
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.06.25 06:21, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Fixes a security bug due to mismatched attributes between S1 and
> S2 mapping.
> 
> Currently, it is possible for a region to be cacheable in the userspace
> VMA, but mapped non cached in S2. This creates a potential issue where
> the VMM may sanitize cacheable memory across VMs using cacheable stores,
> ensuring it is zeroed. However, if KVM subsequently assigns this memory
> to a VM as uncached, the VM could end up accessing stale, non-zeroed data
> from a previous VM, leading to unintended data exposure. This is a security
> risk.
> 
> Block such mismatch attributes case by returning EINVAL when userspace
> try to map PFNMAP cacheable. Only allow NORMAL_NC and DEVICE_*.
> 
> CC: Oliver Upton <oliver.upton@linux.dev>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Sean Christopherson <seanjc@google.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

