Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7556B19D8BE
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 03:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746070981; cv=none; b=jTtdxIk9hReorPIm750vEb4J4rQDRFI2gghjXDAuiIBDYCZ5SbF0WHju3Lt9+hPDHN1ujMZFzY5C5QHstXVdjdPti6zFjj0qHhRP8Pn2v/Q6dYZSjdhSABmT0M8Lt78xLPAeXH+NRuleoUf1jSqDxgAp1LTpXx6NoIgc552jNiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746070981; c=relaxed/simple;
	bh=rCfk93JTwE7IksYYV61B6JuTCbu+HHdPHtJEQpV6aCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IVhmNICZxq/dbkPLOZCJr7rTMnLXxzXcf+BYqnmrocWeBB7GOm3wZH62KPZyJ9F18YFlqNExLX8VYGrVk8aLjZ5tWWZMGn0x76B7urhR1ZjQP8+AJRLIVrVHsjok0Fr0cG2XJmsdfDoGIRjrqi0bcXwibxEczgKieyiH9jbN2XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKyAFHF9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKyAFHF9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746070978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JC4AbsVCdLJ1p7UYeSXewTdrjDsKeZ54RhtL8jSgmm0=;
	b=XKyAFHF9nx6GM9PE/5EOToUqSFaTdxXqVR5E/bRfighZzyGzYUiPdbqFUjozPFIUyjOC5k
	2v7FwUx5pMpUlfZzBHpx/yW4rRykPg7eg5EzRblAFCNneJ+l+Br5Sui7D0PcKA7zmmgDse
	g+Y7G5QSCm+NMjkhrt2nvW9zZJVXxtQ=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-F_Op95DIPA2AAN5jCEPWEw-1; Wed, 30 Apr 2025 23:42:56 -0400
X-MC-Unique: F_Op95DIPA2AAN5jCEPWEw-1
X-Mimecast-MFC-AGG-ID: F_Op95DIPA2AAN5jCEPWEw_1746070975
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-22403329f9eso4247925ad.3
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 20:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746070975; x=1746675775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JC4AbsVCdLJ1p7UYeSXewTdrjDsKeZ54RhtL8jSgmm0=;
        b=BalYhmSKj7tS5OypG2kSx6l9D08gfYtX0/eK8i+813J6quBoDozgSYfESGfGBc6IPo
         SCKXCKoe7RO7sEvPOl3Fc82kZoRKP74yuaICIVPoShUwEfDTjpfr0dZqVS+WvkB4rNpu
         HwXZt9BWVAJg8FLZtKMNgQwXZRasrASTEpAIaWzns7/QR5mZpJhR/RtgExdoPtNfLVSA
         r8E+M6ci/FKE8eKcsodnneCyTi8CQVxyaVinsvh0r4UbBj28hyUPYm/qERx6FSVJC1Kr
         tyU8LKCmaalWVJHoiB0XKNVjU0QnCvRMFp5VkDukj/tfh73i0rDN26HR/S1LPOzgjcow
         3RcA==
X-Forwarded-Encrypted: i=1; AJvYcCV63x25adCk18nYL8I93LXPJDP31pwSAQ8r5lY1jXICeRKmSPaCh8wnGbDiLrwh4XhmnedPuHQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoPL6jv9mX2WHS985zwavwpgVnSXNraAY4Ht/BLH8cZViAgzua
	sS30uHQR9ztFKIBvFytjUQ3GoC+q52v2kVbl/IC91EfgB2uujdLI39zyLJMhyO6EWtX7Km/cPfA
	cuHS0J8KzSZ8fE4NhG/1AKds83v6Hc0YxQnCyU1xsunK9tXy77t4Anw==
X-Gm-Gg: ASbGncsjsLClO/WOp7phKTQyXknIWnczPLQKUmONV+BhyFZXqJAUKBjWKhA39VytvRB
	PkynR760mUrAbT/yrDiqIwbcoLXMBuGS913kUErtEqD4gqHuAAn5h+vk3RVpnHlEK+5uKDS1vvD
	0yujnf7yDCBGlgVrqNz5LR/muNifIwWQJJW5CJMTwAbo/cmj+UpERAuV247HJ4Wj2Lrm1XFR9wf
	WZNlFF4mdOMfzTd0p1flTQ5voLdhgOB00AxCQGMZqDOvQctFuqjuL3goCfcqheKpnFqsNUwoXuc
	tNwLel6agyMz
X-Received: by 2002:a17:902:f548:b0:21f:4649:fd49 with SMTP id d9443c01a7336-22e0863efbfmr14694045ad.49.1746070975365;
        Wed, 30 Apr 2025 20:42:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6XeA16VOaq6zL1nFcqHpvVwTJjX64McCuJNjLU9eHJvxIX6JXOCTvpbcT/Z0Dp6bPnFYLIg==
X-Received: by 2002:a17:902:f548:b0:21f:4649:fd49 with SMTP id d9443c01a7336-22e0863efbfmr14693805ad.49.1746070975009;
        Wed, 30 Apr 2025 20:42:55 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5102b03sm130327715ad.194.2025.04.30.20.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:42:54 -0700 (PDT)
Message-ID: <f61ef14b-9a51-48c5-b88e-518461c988cb@redhat.com>
Date: Thu, 1 May 2025 13:42:46 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 36/43] arm64: RME: Initialize PMCR.N with number
 counter supported by RMM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-37-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-37-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4eVW6PmAsa-otDECtvwldTdWkz6aAT63gwwGkuR42mk_1746070975
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Provide an accurate number of available PMU counters to userspace when
> setting up a Realm.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h | 1 +
>   arch/arm64/kvm/pmu-emul.c        | 3 +++
>   arch/arm64/kvm/rme.c             | 5 +++++
>   3 files changed, 9 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

