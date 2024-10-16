Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3061D54F4
	for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729122099; cv=none; b=FyfIgBrfeGX9dNC6hYsYRYqo43m2cdhoUJh8rcKRasfQMvLaPngstKccxndw0bq0LUQiILFZnChDqTlssWwPIW4LT8/rMXunC/YRfw56NmuWsWkJeW6wd1PWJjO44penGV8Ssk45Wuw63x1NHoSAr/ICaCmY8CiBcWqAKHH10Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729122099; c=relaxed/simple;
	bh=eNzPQge4/xuCqliNDnRNV7rkfiOtKw4cvODUZHEzwX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gv1LIez+GUnEZFgH2+dARIV0wi9KRL3Kngt8JxMV+subr6+Bn7+x4rv+zTsnDwaMOjmu2GaZtlREVdOJdh7VEuFKI920G7Q3oQIyFrqkQmLvxqOmjOd/9VNf8qK0rEiNH0twGvoYjqlYvCHTpLiTOsgpnN44LEhAYbBYz6mdDr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iNNM6W0x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iNNM6W0x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729122096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Ek4o7E5la2DRZUOjLD2G0e36jneROiJ6cZTxpxAAAs=;
	b=iNNM6W0xlD5zRjX5KdxlnnrVwhHzIDaLHDyYvkInpSBkVR/FC3FBrclWQqY0eYSbEFKwbO
	hs7C+Plz3YdVCNJBSo9nlzZ7NHqi+UzlzEB12Bol5hPXxKkis69qtNpBkp9KlYTd1DqFS9
	IfLVziyIx/pT/4uydZAsuti33D4IuFQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-tcC78ICRMYGfWRRy53-lGQ-1; Wed, 16 Oct 2024 19:41:35 -0400
X-MC-Unique: tcC78ICRMYGfWRRy53-lGQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-7ea0069a8b0so314637a12.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 16:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729122094; x=1729726894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ek4o7E5la2DRZUOjLD2G0e36jneROiJ6cZTxpxAAAs=;
        b=Y45e0mKGUyCHRu77tdbyGfQmLFwy7pndXb+qIqKeqs61kMn22inRs7xHMpoMfx5B3z
         J9gEUiUbry5K3bEVI61oBtXWBBA+x5tI551tDhEFC6xnBLn3gXWzMcPbFVh50d8IKTnl
         YSml66KFIbJl/p21ZlzKzykPVT1TGTSE7IdeaXSlxlvSNDRI57HvF3goNYKypnfNSuHS
         EFl1qHKmLWyqVsIA+UmyiL01JNHkQMIwQFXUG+sUuBQZ2obIuNSyFqrgY+M/WDVeW/Ws
         sFYW1qb/ZKAxjXdkeBk6yM+HQsmq4y6b13RWB7AO2GjctqArzzN5clDxt+l38TO0d4bJ
         05mw==
X-Forwarded-Encrypted: i=1; AJvYcCVKHy6BcHqCBeRLzz3r65PjAaWh7t/az5/lHwCgU2gVyW5LwQpicwY6zShG08bMXEyV5OlOuw4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzStptFMdrxPmk4kCmO2GDb6d+IWQlxLI0087cX98Q6l/PgpwOV
	XWbKsHg+yzo5tyY60orbPPfpei4rPWiM4ZyY3MbKq0O+tENdaHXkUHxv63OrpwpCIhk7Lzw1iPf
	FBdhLbK3V5cwD3BY6hjIgMDxp8FhlCicQhO1AfKURJVxw7GQHAhFX/Q==
X-Received: by 2002:a05:6a20:cfa5:b0:1d2:f09e:c15b with SMTP id adf61e73a8af0-1d8bcf42381mr29532423637.25.1729122094276;
        Wed, 16 Oct 2024 16:41:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpN5N9kvB+SC4TYX2A4VLiegJ8C4YmwDF7PQ74pxrkDteSuXNUwFp+4kNy0owUiu6r0yrsrQ==
X-Received: by 2002:a05:6a20:cfa5:b0:1d2:f09e:c15b with SMTP id adf61e73a8af0-1d8bcf42381mr29532390637.25.1729122093885;
        Wed, 16 Oct 2024 16:41:33 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e774d2a0csm3633351b3a.181.2024.10.16.16.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 16:41:33 -0700 (PDT)
Message-ID: <5a1c84a0-ad9f-475e-9f95-7ddc5ba018ad@redhat.com>
Date: Thu, 17 Oct 2024 09:41:27 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/7] arm64/sysreg: Convert existing MPAM sysregs and
 add the remaining entries
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-2-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241015133923.3910916-2-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 11:39 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> Move the existing MPAM system register defines from sysreg.h to
> tools/sysreg and add the remaining system registers.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/include/asm/sysreg.h |  12 ---
>   arch/arm64/tools/sysreg         | 161 ++++++++++++++++++++++++++++++++
>   2 files changed, 161 insertions(+), 12 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

