Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E350E1C173C
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 03:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068675; cv=none; b=OIsz4CyOqKXdZjyuoPnHX02v95RaNspgQYXkGflmhRtH9Qspw3i7w6gze7KXA6DeZWVjZWUi+fOdCorgJoIqS5DNergDyDNHYbRdee8HRfWrTzdoFepxZ077HAVUvjYLm9G0XMNo/8hGALhfrP4dughFuUvLjV2bzC6tmGXxaxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068675; c=relaxed/simple;
	bh=tZi2NdvmQc65SnA/rYIjU5Jj7gqR962wW3qNHQ5VACU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=np1ZqgpeJIlIeu55X7FiLBdM2bCGYGy1uvdXqmP5hI3NbYjuB/alWhXX2gaZxIKW7sUSkFoaCD/kFhwqully0ugY1RWe/WjvAG6gc508v7VR0IvKOHsvXqT5fL+F2nTLyHVYf/bQ84cG4WQkT91jhzPk1yA8tEl1t16xoJpT18U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DX2TzWsd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DX2TzWsd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pesLTZdr5/HKcumUkD4qePwEkxoOaQwmkc5fPPAZSRc=;
	b=DX2TzWsdWKQu2ieuKDdj8hFhtvNEMdxPl8fH8WTcJv2SWmxy7gmnqGw4XMWKH0lDtav6WU
	kcbqxR9j0+UfEn6dPjhwt+jHaRsDvLNZkgM3r4tOpxCm0W0BpEdUb/tNQyNbtFNZRc2uiQ
	vJIJRg/HIs8ogMCFVRh8sLuz8D3hNHM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-A4VGaisgNmC7DaVjCPoQEg-1; Wed, 30 Apr 2025 23:04:30 -0400
X-MC-Unique: A4VGaisgNmC7DaVjCPoQEg-1
X-Mimecast-MFC-AGG-ID: A4VGaisgNmC7DaVjCPoQEg_1746068669
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2241ae15dcbso5927665ad.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 20:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068669; x=1746673469;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pesLTZdr5/HKcumUkD4qePwEkxoOaQwmkc5fPPAZSRc=;
        b=cYMTz5iWDxlo+SGDHnkMMXRc2majXh1UznxHOVi7QXT2txyB8FFeNhtboHrWaGLqPc
         9TxOe1ke9ea61ZPQZmDe7CDm36gVOr3wiAz8gLRrhP3jGp6I7xMaTtsVNIwjb5bp8vOg
         4pzsgmmoJLcR9aDS5EYSLV0r4lKkFkpfH5Pvi5/+VtdcloEDT4S5qEIoJkh2jfdIzmft
         jTRqLbwaqpz3l2ITQWYZ3ajqqti4ZoNQAy9uSQzi2Akn6tCXnUz/uCjWvlyVOBoTjjk/
         M7dybdAifc4SR1JLdgunrOl63WCRKX/GPbl1edtC8hbzqiuVQM0+lb6pTns7PxQnOxYW
         SPnA==
X-Forwarded-Encrypted: i=1; AJvYcCWYWr1OVMD+qd0wUkI//Z8jKMPwFssDVuPmZPC8U41/OlFbOAh4G0t8S2tn96MNXDLVrmCKaIU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhllC3DnqOEApHrX1Uh/6M2/OBmn1qHa23kDRbxSL5b0Qfke2E
	Ne9gzrvBNceH99lD2ZFgDhPqOuKDcXjtCpfWy83QamJpN2lTU2gt9jt0v44KNdDRrOC5P3y4n0q
	V958m+a8FUnmpyQjUQS85mhQTziSqI9XoRuC+D33kufpVLFv54HM3YA==
X-Gm-Gg: ASbGncvjKSkGLSCNBv0oLt3GJo4HU9JzLbg+nkMFrLI0oIPU8b7+QO+sIrd86q0uL8b
	7MH90HC6jvsEet2s4VjqDr+djIS4VeQT3MhXtDSFUQPWW9RQPUBgG4WAAKm2L7kjqygpwQpg9pV
	tTvYYF8L4L+aN1H0dLjvOdk06gKM90OOFAYvETjNbOU33HS65wtVpxTPXnCjsHLRAA8HkM5iwxE
	DCxhels/gN8eUitMne0oA1iLICAiPT+rRQ7h40SQF860dcAoypZjiHcQQ3DC8OpQLvsySCtqVaJ
	3XgDML9XSbt4
X-Received: by 2002:a17:902:ce92:b0:227:e6fe:2908 with SMTP id d9443c01a7336-22df5837638mr79119305ad.48.1746068669206;
        Wed, 30 Apr 2025 20:04:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBHru6AxoF/0GFxqHSMv5iJLveZy61hLLoLevsQlDtlaYL5OE3bmqNgmfr/Tilhp0TcTxL9w==
X-Received: by 2002:a17:902:ce92:b0:227:e6fe:2908 with SMTP id d9443c01a7336-22df5837638mr79119055ad.48.1746068668908;
        Wed, 30 Apr 2025 20:04:28 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db50e7a1dsm130579985ad.140.2025.04.30.20.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:04:28 -0700 (PDT)
Message-ID: <b1ac33d6-13ed-4870-aa60-36393516d593@redhat.com>
Date: Thu, 1 May 2025 13:04:19 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 41/43] KVM: arm64: Expose support for private memory
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-42-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-42-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AhjcEGuQeAYchnd0H0GmxkTfiz79w_dCIahsbWEWUlQ_1746068669
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:42 PM, Steven Price wrote:
> Select KVM_GENERIC_PRIVATE_MEM and provide the necessary support
> functions.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Switch kvm_arch_has_private_mem() to a macro to avoid overhead of a
>     function call.
>   * Guard definitions of kvm_arch_{pre,post}_set_memory_attributes() with
>     #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES.
>   * Early out in kvm_arch_post_set_memory_attributes() if the WARN_ON
>     should trigger.
> ---
>   arch/arm64/include/asm/kvm_host.h |  6 ++++++
>   arch/arm64/kvm/Kconfig            |  1 +
>   arch/arm64/kvm/mmu.c              | 24 ++++++++++++++++++++++++
>   3 files changed, 31 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

