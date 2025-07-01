Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB121F0E4B
	for <kvmarm@lists.linux.dev>; Tue,  1 Jul 2025 06:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751352138; cv=none; b=eBrAWbLuARvJS5g4z0B/5Dei8of7E5mFQ7BBgXIAN95NHwN7GfbLOCYQYToYzGohRJBxy00uwZcecqavQdxc+1rX4ro6eysf+0zym0o3oQTt2UbRreuGhnWGDJBR6qAGRPdvmehD4NSrW0GqmfWn4X+XUrpx6pJomEZvQqFyblU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751352138; c=relaxed/simple;
	bh=K3Al7D1G7wePfIr0haOB5cZ0BREvvGzr3BvThBzFKuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lHFErhRopPe1aOwbuzj4c/Z7v1syRE4KPrTW8ERGFnUZoE+p05LEfKQTOgCn+3gj/YEzqB+npvFTc+Si92dvJ2W2NEZhrUrxgMs3LL+6O03oIXFvNhO8q65O1jzkCmofIjGX8RIHoabpKyfA3iZhFICV5vycRdgOunJyibz7A0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Is02P+Lg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Is02P+Lg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751352136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nh2uVd7pRoUTCK6irPkfWlzRluxl2PTNeAPLCnx0f8I=;
	b=Is02P+LgaAixPv2TF+Lc1hrJIHV1uiOGmEtSBWx72sLgEZe1n7rkHDPUhJF3eqLDq2uy3O
	QMrxPleZgIzvC5qtuM/rOVfQH18PHayt6VTp96UBH4NsxJgPFp2VE8tmzXOuR9HrlVX1q8
	SRaR+ocAKXCfH1NfL9sZpVup+CcsIZA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-MDOwXO6_OMSI4Lq0o1qwUQ-1; Tue, 01 Jul 2025 02:42:15 -0400
X-MC-Unique: MDOwXO6_OMSI4Lq0o1qwUQ-1
X-Mimecast-MFC-AGG-ID: MDOwXO6_OMSI4Lq0o1qwUQ_1751352134
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-23827190886so32996475ad.3
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 23:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751352134; x=1751956934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nh2uVd7pRoUTCK6irPkfWlzRluxl2PTNeAPLCnx0f8I=;
        b=dIMCHGISPzTmH2M4AyqHhMLv/nOE3yxDoEWYKji2HLfbXIruL5Y7/D0v7sCr9s54b2
         GRVCMmH5HowAR5J3u+iZ9XIRk44sjwFMo6wydZqvTDvs3A4qLc+1odBTY8oUzTu1I1xR
         CZ/Ujz7nqpLwS0bgAu6WIe3TSy+BYOIxOiU45rYhdvRWA67cemK14FEswkFBwDO5UVZm
         udXPOexqKk/IKkfkW79UH9GCA7nkVOXpQlENGt/R9VPdlxj2LUMYUwMf2Ako5i9T4da/
         2Nm2iqJuWtJjA4RDSZ5EPIgC/ItPzPrARPZcIz0IpePtmVISat7QmoB4ZdqB8VtbSSSQ
         /pKw==
X-Forwarded-Encrypted: i=1; AJvYcCUkxPu2ZTDWw3qfdid8SvSWu8pYrz63V7fxH9UCBAeo2Zwb0MFMIdMmJed7uydiS5UWadGUydo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfNwSJnIqsMPpOsUSZ1TxQsfV3hSKnLLoZR1gh5yGfxIfSqJYL
	lcjBbMjhGglgX65c0fyZKJpTiU6fbEtRdj4OGc7HLDp3x1hYu5xnlbotNJ6OCa7YctnydZiyJpw
	5QTYC6WVYR9pZVPSmGBj14ATE/rLDNFddUPHmboA29M/2O6B1xmochUL+LA==
X-Gm-Gg: ASbGncvMsiZ+kalB1MGEYjWCO9i/cqzw1vdvlYu1ek+ny5OeyQi4quJMzmVtDCL0EdH
	5HykzQfTW3gMB6eDj5nPdvh5KQOFYTyx5Js3MwLEr4602fDPLWcLiLad7nVw+R40Z9qLSLLOSeD
	MMooCBnKyRtOtQecmNx06ydFC/Rl1+OUS28+6aQ1v8AnQms5PkBcPSVqpjsHCmes2zC3NGjn7Ji
	stwnNEmsxbIwQx4PpTP8M5aT9j5m450F3AxDlAnC6Omt/JNI5S0dycsaj1CmnBWDVqiLIlWaNEQ
	Ujw/3KvcdYbIxpDSorOCD+cOz3tzdm+qNatC2XHmicCXHagXLYX0TwytGsEvVQ==
X-Received: by 2002:a17:903:1aab:b0:235:eefe:68f4 with SMTP id d9443c01a7336-23ac46066bcmr278419955ad.29.1751352134098;
        Mon, 30 Jun 2025 23:42:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHl2aE+m8eiWUtPLXKvS7q68VAQ4UGGYsv/Yl574znsMqgsWf8nwxSoY/4U5XcisW0xX3aQWQ==
X-Received: by 2002:a17:903:1aab:b0:235:eefe:68f4 with SMTP id d9443c01a7336-23ac46066bcmr278419475ad.29.1751352133719;
        Mon, 30 Jun 2025 23:42:13 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c689bsm97301335ad.224.2025.06.30.23.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 23:42:10 -0700 (PDT)
Message-ID: <5d520f90-f49d-4926-bc04-80979531aa11@redhat.com>
Date: Tue, 1 Jul 2025 16:42:01 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/43] KVM: arm64: Support timers in realm RECs
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-15-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-15-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gm88_MIdLhu8-sGxeyOCn7zGMbsyAzX_fQwTMvPOUhA_1751352134
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 
> The RMM doesn't provide a mechanism to set the counter offset, so don't
> expose KVM_CAP_COUNTER_OFFSET for a realm VM.
> 
> A later patch adds the support for propagating the timer values from the
> exit data structure and calling kvm_realm_timers_update().
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Hide KVM_CAP_COUNTER_OFFSET for realm guests.
> ---
>   arch/arm64/kvm/arch_timer.c  | 48 +++++++++++++++++++++++++++++++++---
>   arch/arm64/kvm/arm.c         |  2 +-
>   include/kvm/arm_arch_timer.h |  2 ++
>   3 files changed, 47 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

