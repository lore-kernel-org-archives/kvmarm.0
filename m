Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5642712FB34
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 03:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729654178; cv=none; b=OHgegOjKnGbQJjisaS1AnsLsxR67FxoKITQ3ubx/abw17w0n5pUeWQj1eQiTmoR5tDWnTd0NCwIRWxmrWrEezSYvJqEMfUqp81ktR71kIkv9Ra3zy7b+K29+zMsf8+IGI8jqdQwUHt1cPk21VOWHdKnD0C5P3MEU+YBGotCMev0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729654178; c=relaxed/simple;
	bh=+6Fpco6V5O5W5cKFQk4z7cMXSUa3B3pMKCtFO1yDXmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JqntK7iLmkp6NJq/UALoUh8km/NMJjsmElykeY3xmCl5PrIb7VevlvAvBQxWRjF14GJjV2qjedUe0Li/5OQgdQEQJ731MgQGQajIP7/ToyXByADkeaYS2p5V/aWUAFI4cCoxLv3XCuFdFIJdHjwYBjhcfNpxCM289W2FEst2MBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QqF39cjY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QqF39cjY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729654175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BxnxAqHSQi/PSdbsWFTBVvnXn1V933dFV5xw+gHP+cE=;
	b=QqF39cjYDzuPfMCsHWiowAs2fW1B3sI6OT/MWbONUNInFzhZIPlwytNpAGEhYnwJQ21Lp5
	W5kGc1+CET6NG5C+2n8/TLYhc5qcFaasRFyKJHhKd9mUqEvF2d05L26Batmpc6aQIdvmK2
	BEDk4EK6lOUodqrOm4iXH72ZvX1RSkY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-vZdBRUxZMdWZ1aWZ_omrvg-1; Tue, 22 Oct 2024 23:29:33 -0400
X-MC-Unique: vZdBRUxZMdWZ1aWZ_omrvg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-20d417fc584so82384785ad.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 20:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729654172; x=1730258972;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BxnxAqHSQi/PSdbsWFTBVvnXn1V933dFV5xw+gHP+cE=;
        b=Gr1P+PaWw/70K134/WTZgRMlP7EiJC4M7ol2dyJAR9g934dfouhIUd3Gn0Q8GBzYBQ
         U9pkbaANLuhHiZIZawYyQOLYO1DIf/nlc2BAbFznrIZv/wRJJgFjWHZvLG6jj+ongeXK
         jRMAMugVq3npZ7gYgvhJ7jCymNw4hcs7J3BOLkRwB1pcAv69EVdLrbdGQGR97jVSTDiW
         kh3m40HC/4uLhBu+Vr82FlIBV+rmdQEos6U0uYNu4D5Ypy6s+ZUgfcxjQAIiUy3Tmbmf
         QUGs0pfblzSZ7a1j2/SaWwFzrrNwtsO3mu03UyZEEzacARmfPNV2y7GWRTqKTowtPsBb
         06qg==
X-Forwarded-Encrypted: i=1; AJvYcCWuOFP8O0y62K8XZ93kOx8PGmpeQ36PQToW5+8OOEp0deRxnvdxjHq1XE3QwwfogsJ/qpafVjI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxGScLmfJvvk2JZmfwAsLMXnuAv0WSxOtMZLnX9XftNcEeySd6
	m2zwq50tCbT/ahe1nyG+WAE+bh5xeYv1ojfodRY4MK0tfonpbPnIEySUALzS7Zp1XsYmARQspjX
	BWFqljAOJdC8zuawM3n7HFdGqsoxg5BRiFWDAP/sVr0cs7Qq4qk6lqQ==
X-Received: by 2002:a17:903:2341:b0:20b:c17f:9dad with SMTP id d9443c01a7336-20fa9ec370amr16333825ad.53.1729654172466;
        Tue, 22 Oct 2024 20:29:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/KUd89Pt2YvF/xk5+quJmm3qmrZIAqXkpVnz5dgxwgUq57HEfxmUaUue1V2fl4MBr5OEe5A==
X-Received: by 2002:a17:903:2341:b0:20b:c17f:9dad with SMTP id d9443c01a7336-20fa9ec370amr16333565ad.53.1729654172128;
        Tue, 22 Oct 2024 20:29:32 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0cf95sm49357305ad.70.2024.10.22.20.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 20:29:31 -0700 (PDT)
Message-ID: <ceda1171-04a3-4e81-86c5-ba5c1ec31c81@redhat.com>
Date: Wed, 23 Oct 2024 13:29:21 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
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
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-11-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241017131434.40935-11-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 11:14 PM, Steven Price wrote:
> From: Sami Mujawar <sami.mujawar@arm.com>
> 
> Introduce an arm-cca-guest driver that registers with
> the configfs-tsm module to provide user interfaces for
> retrieving an attestation token.
> 
> When a new report is requested the arm-cca-guest driver
> invokes the appropriate RSI interfaces to query an
> attestation token.
> 
> The steps to retrieve an attestation token are as follows:
>    1. Mount the configfs filesystem if not already mounted
>       mount -t configfs none /sys/kernel/config
>    2. Generate an attestation token
>       report=/sys/kernel/config/tsm/report/report0
>       mkdir $report
>       dd if=/dev/urandom bs=64 count=1 > $report/inblob
>       hexdump -C $report/outblob
>       rmdir $report
> 
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Avoid get_cpu() and instead make the init attestation call using
>     smp_call_function_single(). Improve comments to explain the logic.
>   * Minor code reorgnisation and comment cleanup following Gavin's review
>     (thanks!)
> ---
>   drivers/virt/coco/Kconfig                     |   2 +
>   drivers/virt/coco/Makefile                    |   1 +
>   drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>   drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>   .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 224 ++++++++++++++++++
>   5 files changed, 240 insertions(+)
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>   create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

