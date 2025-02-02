Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FF261FCE
	for <kvmarm@lists.linux.dev>; Sun,  2 Feb 2025 06:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738479181; cv=none; b=XThs8VfITb47UAzPR5CNVMuBQXq5oc9pG2NGG4TlMr0VbmsRjYQ09dvlZlEXYw5ovUDyuA9tXlv6dkMEx+dE//5lFc0fc4NAi8bvr8JehcZDOUrGjF1i6y0CMUmo4KamXhK4az9adSlUBtSm+yXZPxF0GYSEeq6BtkxDMJ0Pf88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738479181; c=relaxed/simple;
	bh=+XQoM2eQ5of19S1D3GwOInAKkzoHqEfVZIdX70/L1xE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uzbStG+ExYB6WcbxFnsQpO6nFmlFLCG8yb0IsT9fJErjuaYi/rg1Ef4/0U2bGdJGGVR6gMg3WOdDIkSx9PSwmpuximSa8cOx3V3kjsBCyQBqPBA5KnSN2sjKR6MdsQbaJ5mNOK9fTdJUVzJSCMYa3M+bMCR6OIgQeuKMDXEEORY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1pMLCBc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1pMLCBc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738479178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dmFZPr7vvicMrPdu+ITYGzZQ8FMqK4dGeuyKQ/HiL5g=;
	b=Q1pMLCBc0rasqGXCGTeNKk8uEBtee+GaVk+LCgZEm7d7y04QL8G+36Eo61anUtzXWqiUFy
	UJVUvqKTvRtN/oCM8qBGjBRxbJ0mM2/hv8IwlP+mNte2IGytUiWafBSqHRnhFsrtpkFJ35
	3yRVw6U/H//QwlRTUOBCPVT5/rQXSjo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-HkimpMYvOEO7tGaclHNuWw-1; Sun, 02 Feb 2025 01:52:57 -0500
X-MC-Unique: HkimpMYvOEO7tGaclHNuWw-1
X-Mimecast-MFC-AGG-ID: HkimpMYvOEO7tGaclHNuWw
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-216311faa51so59741405ad.0
        for <kvmarm@lists.linux.dev>; Sat, 01 Feb 2025 22:52:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738479176; x=1739083976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmFZPr7vvicMrPdu+ITYGzZQ8FMqK4dGeuyKQ/HiL5g=;
        b=TlgztAQahYz4mUAc4Kt040OnwHe7TIGDkhx3ziUynivMqqiHd5wOvmeCP0rGJugsCV
         UBgpG7jy59TKO8r8ePBA4Fws+IPgD+dwxJxT7KWkCeYWiw4drYbCsFeiFNysSTZJwZun
         yrJ5snBJcGPJrQ5g8Mk4n10uZ04jAF/WFiCY+M9h57vVE3VwmRfy3vL3m2K+c0TAg7ox
         kwtokT3NXMCfE6Sxee06f19O4MciG0ZerXt1uE0npUSkXo0zaYDnK28Jqlq+iHdqIDVK
         kM0qguN94wn1SADjwFdqwarHrFQzsq0EO7qttcxgWM1pZka9tG9xX7GsPwqTY2nCB1aZ
         aa0g==
X-Forwarded-Encrypted: i=1; AJvYcCUctglQcoP7hutRDIJN66U8g/VdXCO7WFp1KmOwtpPHjlYiW6uU6ipK8KS6UIUT/ylq5nK6+mo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoU5z0AnyEpZZ1NN1AayL7od73RbSoXBAyYS9d4wAk3vvNiKEV
	gBru1v48dJFpHYd7ANt2eHd8XwB3pYBz7oC20z/ROR6Vxs+foUxJMPphQA2Kiqi4MxY563p0iyK
	ROnY95KtZWPmtc3pzFsf/hYGBVMrhB5Qj99K8T/+FrJZtiRrtKezgyQ==
X-Gm-Gg: ASbGncvO0y9a0e2IS04/QXsR3e/cia3/db+CPfDjfJmUQJORjiVi0z+u6N0ylST0R8o
	WAvFoqx7n53d5PzmqzDXFwj7qxjnOwb95HzwFsGz0DG29dSvRYlGGXmAthdZfmB0zXVClQp9Dky
	iHNYiHMNfD7z37ITewK8uRqxPEzXd+M0OGtncDUZ/V+jxS+SeOePI68ysdq/YZfvyMK4IpfsWet
	zr3NSBQbG31+VirvmjLlig1qDRkxYdFrzp4fMEL41trEt2bc/egpTGG1gOxAwvFyduSS0L7ovHz
	Md+xiA==
X-Received: by 2002:a17:903:246:b0:215:b1e3:c051 with SMTP id d9443c01a7336-21de1968f37mr191228055ad.11.1738479176567;
        Sat, 01 Feb 2025 22:52:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGr8YDEgf3AQME0gtW8Rc2bNGoGwAlcqKLbbyp/bsjze7Hnub47aEwGNl8h+IYW0bDy17/2PA==
X-Received: by 2002:a17:903:246:b0:215:b1e3:c051 with SMTP id d9443c01a7336-21de1968f37mr191227855ad.11.1738479176239;
        Sat, 01 Feb 2025 22:52:56 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de3335cc9sm54443775ad.258.2025.02.01.22.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 22:52:55 -0800 (PST)
Message-ID: <82659880-f7a6-48ad-bf54-8371fc3d41d8@redhat.com>
Date: Sun, 2 Feb 2025 16:52:47 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 29/43] arm64: RME: Always use 4k pages for realms
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-30-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-30-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oumJw-QYcNALoB9O7KIuVmSpoFXDACKqt_5F57ujEZ0_1738479177
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
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
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e88714903ce5..9ede143ccef1 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1603,6 +1603,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (logging_active) {
>   		force_pte = true;
>   		vma_shift = PAGE_SHIFT;
> +	} else if (kvm_is_realm(kvm)) {
> +		// Force PTE level mappings for realms
> +		force_pte = true;
> +		vma_shift = PAGE_SHIFT;
>   	} else {
>   		vma_shift = get_vma_page_shift(vma, hva);
>   	}

Since a memory abort is specific to a vCPU instead of a VM, so vcpu_is_rec()
instead of kvm_is_realm() is more accurate for the check. Besides, it looks
duplicate to the check added by "PATCH[20/43] arm64: RME: Runtime faulting
of memory", which is as below.

        /* FIXME: We shouldn't need to disable this for realms */
        if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {
                                                                  ^^^^^^^^^^^^^^^^^
                                                                  Can be dropped now.

Thanks,
Gavin
                  


