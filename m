Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167A91F543F
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 06:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741069449; cv=none; b=dK4q1gKFdsQ2R6WvY2S7y9l+pEnLl9jvJASeUhuO3zU/Zp2aEeOX7reDwMtXZY3tHaHAYOy4R+VgZ5vPJfK1KFbJc5OtMDrT+m3E5L7BMqCoklAYr6MzjUgdtN47+FgvLJzOsE7RXHBtbpaRL1/pyJtmYABY1BqM3oIDmF0N3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741069449; c=relaxed/simple;
	bh=0EYT/5igMmD/qVvWdRKvGmdh6E8JzSaWldlA7WO1ROk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+13MRidFlr0E+FK1teLXGRn+ZVXwh8+6AdNhSmNHsZ0hJ4hfabannoMlRzk7DUUedpwo6bts0w2On7N+CD3xv+pwrWMTU/1+2S6ej/ICyBkRKan9Kp5bxXWhpvOhJpNY1lZMpWYoB96PrM3B/46XCda8+FZ+3Bv3YrC77tpL+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKQ817bQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKQ817bQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741069447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UUEeo/X+MxYcAZNwznFspnaWG5EWN4eG0J5QKgSy/vw=;
	b=UKQ817bQmOirGpdpjXAXJ8cg3JjKdRSNhf1Tgpzaq6EcT9aQObqFNwv269Tg3MVhRfofRU
	4nxXykIz05Oh5CAz/shXjVDirs5EseJnPD2PJhj+mHyFxATrmeP+4QaGuwQ2O2lT1Tb4Mt
	T1FDL+Plo5MRotwf3XKy6l4f5U9PG48=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-3PUg8LQGNuysLpg6cb3EUw-1; Tue, 04 Mar 2025 01:24:02 -0500
X-MC-Unique: 3PUg8LQGNuysLpg6cb3EUw-1
X-Mimecast-MFC-AGG-ID: 3PUg8LQGNuysLpg6cb3EUw_1741069441
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-22366bcf24bso74092575ad.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 22:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741069441; x=1741674241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUEeo/X+MxYcAZNwznFspnaWG5EWN4eG0J5QKgSy/vw=;
        b=BX+2QlFYMDGKb2+0Wo1Y4s82M59gPXr/+2BXECkKYmOO1NdCoMPHDnf50bteOHJgqb
         E6Beu7blSLIjjwdWy7+oTMPzt3mSgFjR7E2rGci/TDJBl3B4ganpPLN/BfXVCAq/Sd99
         zajRx/eFvvcHHg3rbmsiy9PDlgi7u9iBFIxphA7vegqu41YWIAsM/OMYXM53tFdw8Uey
         tSty0hmgsDDmCmteQEaf7pGorshQxcRwd5WlgxdZ3Ju4xt4LqkmLtyX0XMPQ2on3HEUD
         Ek/FgeMl3rgF4om0EThy8ca9zSvihZ7m7MVSXNfpy+gxFtRYYBnDBBM+IZ33tP/aAL+J
         jBsw==
X-Forwarded-Encrypted: i=1; AJvYcCUvQyHspGxF4+rufb3IdvgZIR8tL4z0e6yrj4U9lEi/LDWBs4UYl4oCphb6EGD85oWDTRL1JJY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpakALLTAnZjMPrq3IubTv8+ZSShY08xdKNWrwT3CksO7kFezR
	/xWNAUlLHQUGB/4VfnhkRMlH38S5w6zwvPJU+hbFBlEYMS1uBWPjQlCp6iL7Gce8PjW99BkPqjs
	CzAdeesgShUTuzW+oIqUC3iHKJa5z1QedPshjKe6fd1lMv/0dHcDlZw==
X-Gm-Gg: ASbGncskwV0OfZzPDGn7zZm2boXldut6LR9OSJ3pyf8nv5h9xUj8tgplEe3RvSwVal2
	qpUMjbBPMQJQpWDCB3AQ4LrUlS19FziOWfvqdo/f97lMigHA3ES9alzDZtLY4zATqUAlBVGGZ6c
	ZS4XfcjwsEDMfBJ02dHmO//7mCHPRasz8cyBF/j/lldyJK9IJDwUrv4VYq8LxyJi8Fc+fA8M0EF
	PK2YIaD5GLKZNl7i4H4asATDcTw6gme8qKaxgorbPyHfBUi+/IBaqww2FPYTuNyvKEztAhGGNtP
	ZQTagmn894NIUPtvfA==
X-Received: by 2002:a17:902:ec92:b0:21f:6ce6:7243 with SMTP id d9443c01a7336-2236922454fmr215973785ad.51.1741069441084;
        Mon, 03 Mar 2025 22:24:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGeWcLcszVzswCV3IlHec2C4u9Iv8biEcHW4AvArM9d+exFu3qcTvk3+Js7kBLoNIjChH7Sog==
X-Received: by 2002:a17:902:ec92:b0:21f:6ce6:7243 with SMTP id d9443c01a7336-2236922454fmr215973585ad.51.1741069440784;
        Mon, 03 Mar 2025 22:24:00 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d323bsm87972535ad.3.2025.03.03.22.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 22:24:00 -0800 (PST)
Message-ID: <9d32bfed-31f2-49ad-ae43-87e60957ad74@redhat.com>
Date: Tue, 4 Mar 2025 16:23:52 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 30/45] arm64: RME: Always use 4k pages for realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-31-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-31-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EbqfTWfD8EKWMdvfqVZ0mxEJhhTgjVG8Vxew63HVOjQ_1741069441
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> Always split up huge pages to avoid problems managing huge pages. There
> are two issues currently:
> 
> 1. The uABI for the VMM allows populating memory on 4k boundaries even
>     if the underlying allocator (e.g. hugetlbfs) is using a larger page
>     size. Using a memfd for private allocations will push this issue onto
>     the VMM as it will need to respect the granularity of the allocator.
> 
> 2. The guest is able to request arbitrary ranges to be remapped as
>     shared. Again with a memfd approach it will be up to the VMM to deal
>     with the complexity and either overmap (need the huge mapping and add
>     an additional 'overlapping' shared mapping) or reject the request as
>     invalid due to the use of a huge page allocator.
> 
> For now just break everything down to 4k pages in the RMM controlled
> stage 2.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 

The change log looks confusing to me. Currently, there are 3 classes of stage2 faults,
handled by their corresponding handlers like below.

stage2 fault in the private space: private_memslot_fault()
stage2 fault in the MMIO space:    io_mem_abort()
stage2 fault in the shared space:  user_mem_abort()

Only the stage2 fault in the private space needs to allocate a 4KB page from guest-memfd.
This patch is changing user_mem_abort(), which is all about the stage2 fault in the shared
space, where a guest-memfd isn't involved. The only intersection between the private/shared
space is the stage2 page table. I'm guessing we want to have enforced 4KB page is due to
the shared stage2 page table by the private/shared space, or I'm wrong.

What I'm understanding from the change log: it's something to be improved in future due to
only 4KB pages can be supported by guest-memfd. Please correct me if I'm wrong.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 994e71cfb358..8c656a0ef4e9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1641,6 +1641,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (logging_active || is_protected_kvm_enabled()) {
>   		force_pte = true;
>   		vma_shift = PAGE_SHIFT;
> +	} else if (vcpu_is_rec(vcpu)) {
> +		// Force PTE level mappings for realms
> +		force_pte = true;
> +		vma_shift = PAGE_SHIFT;
>   	} else {
>   		vma_shift = get_vma_page_shift(vma, hva);
>   	}

Thanks,
Gavin

