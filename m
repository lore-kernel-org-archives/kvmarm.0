Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A861D7E4C
	for <kvmarm@lists.linux.dev>; Sun,  2 Mar 2025 23:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740958802; cv=none; b=Dhjk46XUdEY3LCZIH9p5GTG8kmzbnbdFblnGg4QLlfewqVjTfZktaAQdW5Xos/IwP1C1LBWWKYaLw/P18tsKfq5aHv9HrJEIQFVlb66N4yGo/bp3WgriS49PZRomKj5nLa+vytAs1EGRR5lwSQcWnWnoUBEdxoAyaC8IMr82a5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740958802; c=relaxed/simple;
	bh=D9aHcBSNUOKIFyFQgdytxMHadQ9miqe4zl49cgpQmPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GAx/qE0kHS8kltHG/XzwIrrHxN0VJcKKtHTzwNWy8Ph6t5H2g/YU8RuRsg1FVtfTXTgbRYPCylYbVv3ab+i7wIoPXoT9FcdXzyZKZS89OINYKTIh1g154MVh/LR40Hf4LkinFEvCxHJxFWSpRNOHgJNoAjBSkcYMyZ2oUkIfWjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iuabLiq2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iuabLiq2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740958799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GBo5+OYmEobg6wfjqU2wwAFpXo5iLmkJqiW1kfdikek=;
	b=iuabLiq2qxSFRJZPWwrVRJPTeBt5cyb+xkfpk7H7lP+nnoS9ZSnWac2xw7JEguMKm29gJt
	VABr5oMminyL8vGl4aG6hM6cn+XRG665QxDe/+PcKOWL/gY4mqzSVYMVAPcrgOcfJUAgc2
	j8zA9GudyNKv7CzrJVT5veffB478bmY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-Zs4tVwWYNqyenwNUWaHu9g-1; Sun, 02 Mar 2025 18:39:53 -0500
X-MC-Unique: Zs4tVwWYNqyenwNUWaHu9g-1
X-Mimecast-MFC-AGG-ID: Zs4tVwWYNqyenwNUWaHu9g_1740958792
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2234c09241fso113975785ad.2
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 15:39:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740958792; x=1741563592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBo5+OYmEobg6wfjqU2wwAFpXo5iLmkJqiW1kfdikek=;
        b=PE/XmvJ5mKQ5p/NhknlIdLk/tS5fb3DJfT2JlOl2UOp0XYUanR2HVvarezfmmyRNgI
         1Tta1cgN8tLhX0GDUDMle8bMCcgZL8Tc6+zE06G3PVpq0XTSBDW85ZNkH3BgpeKRtDI+
         nRvethj2ayVp63NmXTXkEmzzSM73tnwAYiCq1o5Jv0k8q185UcRTnD9RUijJpFWf2fGY
         2u4Pvq0uEC1VhfBgapj63iuL0g8PUEhQXWnqO909/++nZgm8EpA5OUCgT7h1l0vioBGM
         CC43piXc1bAyvxubrobQ30zjgj6LCUF775ekETMUFwot7/WXkDXYqdI3AgxS/cFK2GER
         8omQ==
X-Forwarded-Encrypted: i=1; AJvYcCW582Etvdisqt4REXkCGaOP/lDf3702zGzSq/FPOewM0O6ALWUvjo4z0sPfptHC3+05C3PLGhY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzgc6DJNi2EO4bEdQqBP33iINiw9slx5+eTXoRvJUDsZaegBuOx
	fpFD+Moj13celfwP7rt5zQyaiDsmQAkWa50NOJrwm7cvxk7O+QKI+V4DlWjEKx8dRafWtjdXOkT
	5Xd+hM5ip9jwp5Di5YJygIHgGg3k7aI+7pOHVuuWprXNEe9SL1tYKC3sLbOHCMA==
X-Gm-Gg: ASbGncv+z8V0alts88zkfnXb+oKEqrtGxwN+XkaN57zOiI8mBk4uYMRwhqxdkvMm8T2
	iUyvhHOpQXa+3piIabHKwWbqZHwarCSkVtnZ9/24CAtCPP15PJJxDw+h2hjYPv1WeHJWDRwODl3
	BFAqvols6fstq0lMxQP45joJiftcOnHY7o2ZKjlhKmBcW+xjdNHzdn8GnHCROfbfqUDktskFMST
	YxCVBjKPXCvbox+pqy81fUcl1tDHNYKuFrHfFs6+JqoDuDDJ7CqTzl96iB94zWVo7Gbh6b88L+x
	TUl941s+PutW6wJu2Q==
X-Received: by 2002:a17:903:32c8:b0:220:be86:a421 with SMTP id d9443c01a7336-22369258505mr198701905ad.38.1740958791836;
        Sun, 02 Mar 2025 15:39:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtWQhLEYN86O3XnJuZetDZhwrb65+Q6vvyxqpw4uBVTdAA/3YJ21/tM+WdLRJLHGH6Np0Auw==
X-Received: by 2002:a17:903:32c8:b0:220:be86:a421 with SMTP id d9443c01a7336-22369258505mr198701625ad.38.1740958791506;
        Sun, 02 Mar 2025 15:39:51 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d26acsm66078035ad.9.2025.03.02.15.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 15:39:50 -0800 (PST)
Message-ID: <a7077902-4286-4b3d-913a-20083ff260f4@redhat.com>
Date: Mon, 3 Mar 2025 09:39:43 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/45] kvm: arm64: Include kvm_emulate.h in
 kvm/arm_psci.h
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-3-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-3-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sxss5i-cyqejQpXJQLAlUdzaMwTSoktREN5S4x7sc6E_1740958792
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/14/25 2:13 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Fix a potential build error (like below, when asm/kvm_emulate.h gets
> included after the kvm/arm_psci.h) by including the missing header file
> in kvm/arm_psci.h:
> 
> ./include/kvm/arm_psci.h: In function ‘kvm_psci_version’:
> ./include/kvm/arm_psci.h:29:13: error: implicit declaration of function
>     ‘vcpu_has_feature’; did you mean ‘cpu_have_feature’? [-Werror=implicit-function-declaration]
>     29 |         if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
> 	         |             ^~~~~~~~~~~~~~~~
> 			       |             cpu_have_feature
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   include/kvm/arm_psci.h | 2 ++
>   1 file changed, 2 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

