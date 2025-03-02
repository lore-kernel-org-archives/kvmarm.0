Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F63F1EF0A3
	for <kvmarm@lists.linux.dev>; Sun,  2 Mar 2025 23:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740958605; cv=none; b=mEPO38aTMauT9elZxV0g77NmirJtv2FF9JM3F5l8uOhET6NAkFPWfVpxxNHq4tNirDa9jbT0ZrDoJ5IT+wtnGVRWGS5UUjacoWD26nWxllmP1Kd3Jlx5lWa2mcuTrhf0/HT1wihg6w9DYoY3rPcAPNEDsxMFdbSUJRRcMrzGUAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740958605; c=relaxed/simple;
	bh=elajwP5GiY+wTmstqYMZ4mmIAKlxv9c19P2Zh3OLnNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ah8UZjCjgIlPjlBzYzz5xDqGFyDO2DxOAcoFblu+dsXbFirj0NkPwwVVaX/RYhuLdW+fd+myFYt+R8/iTmfy+ZrVV0IS4Uw0npklY0QOPfKMmg2+7JJsKTDjBJ9pSpPmdgHGdDK3Ek/qMkZNCK6QKGMxb/vwbA8iBSfaQwLX3bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=innMVJgE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="innMVJgE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740958602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ejh1GDPAKVllO6gllmhAfMEyCPmPMUvWgSEqENGci+A=;
	b=innMVJgE6Bwaxso7+ONQ9QOwjwNdebEK3KhX4/tC14IPzwYvYaTsxlq6rYPxFPN4paXj8z
	FAhcUlW1i+y9yTdiQlDyOPLtxfG11at0EIBaVwpg0hA67QZJEgs6EaqYIijZ7iupIV4AGN
	wyiEUzkcAuimm8EGgSrx8Ml9NZYloo4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-cUbunsq1MGu68Dp1QEs54A-1; Sun, 02 Mar 2025 18:36:31 -0500
X-MC-Unique: cUbunsq1MGu68Dp1QEs54A-1
X-Mimecast-MFC-AGG-ID: cUbunsq1MGu68Dp1QEs54A_1740958590
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-22334230880so51247935ad.1
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 15:36:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740958590; x=1741563390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ejh1GDPAKVllO6gllmhAfMEyCPmPMUvWgSEqENGci+A=;
        b=Y/NrFafzOjlh8WonmNdgvkGWzusfnDb5MyzguhfAW3bDwk0v1Hq/6jeTj0GfxYs4B/
         r6iwDzk09yqQC9FyB9H0ZVqzCRMhjRLu8zj+ENiEunqsfxzs/fEJi9UfyHMUlAix2vQX
         6asPE/bwGQprFlKYhkxMUe3S+Kx+UvsoDFj6qfgTXiczWBaATBPZmoSMHAGFBK8eP6PC
         qe/oQEYZ+4h4N+FxRgMaxgMM5+Sapcj2QsJdRAmkwQwSo4abREuvRVTrzQxEKFCCkaWr
         XHKxphjdelw61/jPbTHJWkF6cY1R/cnJ5cGNEFNlvu/Y8d/ptWl6rrYa4d+zVA744k19
         fYmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXiTIGt65yokCiK3o+CRziXWYALY2PBlKoxnBMiLBpVVAoKhVSBeJuWpn474vWgTNHB2Tn7iA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOSwTDbTgE09D2EHGsQvfwOcuOOw5Gsjz3911ZbiOsIgj+hDik
	RZ7L61wZS3EC0Tq9wriERpN/v2rFRRmnVH9YXwGDdVKAoc9490lzoadSDdko2QhuPBP+UNgnm8I
	ZT6OjAm9QjS6UB9EbaTza1QY+oRkvQaWSZ9g7z30lhlvDRpDzxoTNfQ==
X-Gm-Gg: ASbGncvt0ZLO0dwDBfCJOtMSlAwkWrBucVdJw85NfjlKej992OkW+rDPOgrhTl1Juh2
	tGEpbYABpeAfBr5lFeuQ91l+egmucCxnqRmwy5sbtLlxJ6WH4e1aU5Xbf+Gls2PvEGXZ/c/i94J
	0g/h6cJDvMmSWVpr4kS5iRzXSK6vC4R7kUVdJPS6JqyO90uEPNpMxXVsu7WPddfilX0fjNm0H5Q
	IH7uNUqYCsu9/2Uq4K5a0I2AZp7Oz3gssnbIeRxWU4z5+y2ZN5Lf3UO4CkUxXanQ36qt9XIcrQP
	8Wd9jZ8wExrD6QLLtQ==
X-Received: by 2002:a17:902:d48c:b0:21a:8300:b9ce with SMTP id d9443c01a7336-2236926a62emr202778605ad.49.1740958590127;
        Sun, 02 Mar 2025 15:36:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEddAUa+nONgsuM9Tynj/Y7d+u/KE8b7znylUvPdW2+N+R2Tk2a3TFLdpAdjVAFLYlLTeS4vg==
X-Received: by 2002:a17:902:d48c:b0:21a:8300:b9ce with SMTP id d9443c01a7336-2236926a62emr202778335ad.49.1740958589841;
        Sun, 02 Mar 2025 15:36:29 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501fbd47sm65995365ad.67.2025.03.02.15.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 15:36:28 -0800 (PST)
Message-ID: <8bf9ba6c-a8b2-42aa-9802-8e968bec1cd5@redhat.com>
Date: Mon, 3 Mar 2025 09:36:20 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/45] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20250213161426.102987-2-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-2-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KpiZCukTzrM96iQOqmWX6q7XDbzK4oT3SMWUDZPuxvU_1740958590
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add flags to "struct kvm_gfn_range" to let notifier events target only
> shared and only private mappings, and write up the existing mmu_notifier
> events to be shared-only (private memory is never associated with a
> userspace virtual address, i.e. can't be reached via mmu_notifiers).
> 
> Add two flags so that KVM can handle the three possibilities (shared,
> private, and shared+private) without needing something like a tri-state
> enum.
> 
> Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   include/linux/kvm_host.h | 2 ++
>   virt/kvm/kvm_main.c      | 7 +++++++
>   2 files changed, 9 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3cb9a32a6330..0de1e485452c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -266,6 +266,8 @@ struct kvm_gfn_range {
>   	gfn_t end;
>   	union kvm_mmu_notifier_arg arg;
>   	enum kvm_gfn_range_filter attr_filter;
> +	bool only_private;
> +	bool only_shared;
>   	bool may_block;
>   };

The added members (only_private and only_shared) looks duplicated to the
member of attr_filter, which can be set to KVM_FILTER_SHARED, KVM_FILTER_PRIVATE,
or both of them. More details can be found from the following commit where
attr_filter was by dca6c88532322 ("KVM: Add member to struct kvm_gfn_range
to indicate private/shared").

I'm guessing Sean's suggestion was given before dca6c88532322 showed up.

>   bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index faf10671eed2..4f0136094fac 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -593,6 +593,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>   			 * the second or later invocation of the handler).
>   			 */
>   			gfn_range.arg = range->arg;
> +
> +			/*
> +			 * HVA-based notifications aren't relevant to private
> +			 * mappings as they don't have a userspace mapping.
> +			 */
> +			gfn_range.only_private = false;
> +			gfn_range.only_shared = true;
>   			gfn_range.may_block = range->may_block;
>   			/*
>   			 * HVA-based notifications aren't relevant to private

Thanks,
Gavin

