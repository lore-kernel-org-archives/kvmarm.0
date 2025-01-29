Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB161DA4E
	for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 04:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738123686; cv=none; b=IuUKuZucnuSzQChD+kQiExVlVQZ/OjuY1ESy46r6/Ct37v6hfocsc9nXYPSsr5c5IXJZfshbyE/bVddvpffgDCgXUeF9wnCqbEwQLTOQRtmDG3tM6erILbCKLesSy583q6LrHsrJoiMPZZa8WPkW6mdSh+YeyxEUu3Is+uekSFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738123686; c=relaxed/simple;
	bh=CsAeFJeoQweV080X+SOo03x6K4oJXpfbYalIrjSAXhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MUZis1Qq5gFOof2f7JgiCEp/U/n/7sWHgThqMqWWjsgfsRQH2oIgiYITtaq2FkR0wikTQUwuzZDv5metFO+NeDeNcYXvlIlC2JhZwkG2fq9ZsAuCBpn8TGMraD9ZO9xgq2cyO16t/ZEHPK1li7hcxldcOxEfXv0YY2sPqXVYUMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDq+KGmu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDq+KGmu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738123682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++vP7Pzm+0U/vbuzpGurQDME6fn3ZbIwZpBgDGBaFV0=;
	b=cDq+KGmuqLNeAHcmuQKXgmemTzj6i7s9oaokuT4PqzJaaZA0Tb7i69sbIZNyQTtkVnPCmF
	DUnxitFsma+f9WBOoRDLXJSOZcOWIOX8UHNARw9hGfFdCRGqNdS+yytys9ecMgMDGJjgom
	Hsvfm3JLFf98Q1Ojq7d9aZFGHcOs0Tg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-ENeUBq1hM22cTxVH3KmM9A-1; Tue, 28 Jan 2025 23:08:01 -0500
X-MC-Unique: ENeUBq1hM22cTxVH3KmM9A-1
X-Mimecast-MFC-AGG-ID: ENeUBq1hM22cTxVH3KmM9A
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-21640607349so147281665ad.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 20:08:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738123680; x=1738728480;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++vP7Pzm+0U/vbuzpGurQDME6fn3ZbIwZpBgDGBaFV0=;
        b=ChK3vZbSMREg8yRYnIHFu4AO7ub/kIm0/15jTHDSJM84CEfEfxa8SSCKjfiMjQ+Zys
         x23p1ilQlIzPrTNk/Ajo2Ffp0mUMGHgCCBg7I4CRhbfrXMGjjC4Vh/cxxawKiWmK8R5C
         B9QD1XnmGYQRmt/9U4zWzPOtmlMk+9QdDTtjRJGE69Au9B5/AveQtSS12U476iN4ZiRv
         l8P7WoZTJFFfwi+gjBeBZYgQOHlk2VyT8O3WedzOdDA2WlGBuDmsY74QmYQhsodFOx/C
         N9kRkZg9h2MPSsQTaKAW0JW6I2T2Onh/ugz9RhESJ3q8b9CDcZFuO6GThP8XicG848UZ
         zGyA==
X-Forwarded-Encrypted: i=1; AJvYcCWj/xMLstHjmX5Wn7RuXuOwE0tpHUF2OWp3S68ukHDj/zXsFwRKwgQbcyNuyWqcm9aNGhBniqQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbXVsn7TMx9ewfxwNA2bw1dsAmLTJbo/skogvIpe4pmPG1gWJP
	kMzlKRml3Sor0cDjj+GRZNVtSWALdxKiFI44R+xSP4lMrSBr/RgWZiUvbk8fwfFzKXa3RWDJo7a
	TodYOEwMMuYp//E+x3zbHux3aBAdz5M9JqBshUDpzn6XouAMrG7T9sA==
X-Gm-Gg: ASbGncswXX+y0Tr/PmDEviZXKyXFannYZfMwS6uuc9esNj9Mnpm5yoKgBFQKkolxL3l
	BRPP18wa98tft3OGoHB1l8AdtUBx91x9jP5Z124iOeYhYlbT9ASSjKEGgXlQgFj5troHgcpApYP
	beRMru5Yvj+5+uEkQuB0Bn70anmUDLOwrGYQBN+V5IHhS37CYyhZk5IyxM50+a9Jjn5gwCBrYjN
	U/5vccKeeF50jtTDsLXL9eoc1MfbolpBiy4T7sqXuwE3LGeUCWYufBZ8/HskcoKAiKLU09395z7
	mgOv2w==
X-Received: by 2002:a17:902:ce01:b0:215:3a42:dc17 with SMTP id d9443c01a7336-21dd7c4c298mr26327455ad.7.1738123680330;
        Tue, 28 Jan 2025 20:08:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQIoq8D2QaYFpzEq5kL3xdCHIiITAzdgGLjBLAtD4+BnGQNR/G88wzSm8jyqJiShrpZVo+NA==
X-Received: by 2002:a17:902:ce01:b0:215:3a42:dc17 with SMTP id d9443c01a7336-21dd7c4c298mr26327115ad.7.1738123680051;
        Tue, 28 Jan 2025 20:08:00 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da41415e9sm90098135ad.116.2025.01.28.20.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 20:07:59 -0800 (PST)
Message-ID: <a580d287-2fb0-4e9d-adbb-57e4dbf25765@redhat.com>
Date: Wed, 29 Jan 2025 14:07:51 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/43] arm64: kvm: Allow passing machine type in KVM
 creation
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
 <20241212155610.76522-11-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-11-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EGZ1pOtrLo4nEYI5I0DsnmSOxztjLoI8bud-HWgBZ2o_1738123680
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c     | 17 +++++++++++++++++
>   arch/arm64/kvm/mmu.c     |  3 ---
>   include/uapi/linux/kvm.h | 19 +++++++++++++++----
>   3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c505ec61180a..73016e1e0067 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -207,6 +207,23 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	mutex_unlock(&kvm->lock);
>   #endif
>   
> +	if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
> +		return -EINVAL;
> +
> +	switch (type & KVM_VM_TYPE_ARM_MASK) {
> +	case KVM_VM_TYPE_ARM_NORMAL:
> +		break;
> +	case KVM_VM_TYPE_ARM_REALM:
> +		kvm->arch.is_realm = true;
> +		if (!kvm_is_realm(kvm)) {
> +			/* Realm support unavailable */
> +			return -EINVAL;
> +		}
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
>   	kvm_init_nested(kvm);
>   
>   	ret = kvm_share_hyp(kvm, kvm + 1);

Corresponding to comments for PATCH[6], the block of the code can be modified
to avoid using kvm_is_realm() here. In this way, kvm_is_realm() can be simplifed
as I commented for PATCH[6].

	case KVM_VM_TYPE_ARM_REALM:
		if (static_branch_unlikely(&kvm_rme_is_available))
			return -EPERM;	/* -EPERM may be more suitable than -EINVAL */

		kvm->arch.is_realm = true;
		break;

Thanks,
Gavin

