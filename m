Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B92F1E2607
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 05:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745991746; cv=none; b=fbJWe2YblizChjHdb2gpNkbcUjA4XDmF19gLkmU0cC7oo/ohxEmJuCfoxFw/u2D04rV0MfTze/fHQszb2RdWCpLkzdYBefN2ZjTijm3sxpdpa45ODhyONxrxjGvwGy5EGEQNF4269s9NYzhCNkSaOe89lIclq4+tVP/MQhGwDiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745991746; c=relaxed/simple;
	bh=kQ/EbrrxqEhr5fwZayWRqCdok/5KGxi81DpciRkA6xY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A3DR7BkykJIpyRdE98hgMa2hdH1zjcs5y1b+uoiOa8Q1n8s//irsKlxrS0X3hsFyN4LlJfqPdP/C5Kw0fkD0qapTJEGUD/vh3tUIeOdC8WXWxikp/g468OBcC9AxQtgPmv8PEQ4WQgtamlVx15JTit1RqJFTtPBiRBD94u6/CQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NWxczcFl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NWxczcFl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745991743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7I5yDc+vjNEcqE9R+YmZ5CGoORcg69x/77QunGRnchU=;
	b=NWxczcFleEqLWof7rKJwd1S26k05poN15hlRTRwnQiAlhjU2uFGQcUTGu9fVcgZ6390Dyp
	yTmB5LAlOPY93NJfp9EgEjN8WARE/Rvk7NgJOOpCr4UdOrC9V9sl3gKR5weMmQmxnU1Qmt
	uwVCCQ1V6D3Ksa5mKeBbWkjubLFRCtA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-Sk3Px1QyOM-gW6_z7q5xRg-1; Wed, 30 Apr 2025 01:42:21 -0400
X-MC-Unique: Sk3Px1QyOM-gW6_z7q5xRg-1
X-Mimecast-MFC-AGG-ID: Sk3Px1QyOM-gW6_z7q5xRg_1745991739
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3087a703066so6547502a91.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 22:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745991739; x=1746596539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7I5yDc+vjNEcqE9R+YmZ5CGoORcg69x/77QunGRnchU=;
        b=likYiEffqaC7NWNTewnWz1qxv+e6ueKxoRovbMR1j1Nc+s+fbt6QINHbwdtsTVFXno
         t+ZKwqfrrL6a1ZgpaEmRq0NoXv/N7ff2eE0ejND5KGIoWvdrX1aiCQHuptWQItCHcdl3
         I01D50FmsNt4u7Vf4wT2WWCTe7ITh5QUlR5qNTOuOAt392MT1cTpmh8jw/V3yRQXePFN
         cTR1mPgrKu4cgVzMS7TwOJQIK+uITuGYvXun6R6NPsUSvSF/oyaC5Yq6iP0b9ktNV6OJ
         wtWA2JSvWdD5dOfATNSHqPaUFfs8q5pVWDMNt/paSeMdKQfq8NNoSFkELHhDcyVERdqP
         /BzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSYCyb/vNc3LBELzK2fRc+ZMtLh3bu5D0K9NnRCVs7xJZxNYXwNvA7kXmwiDJok6zbVnXAiwI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLNo3YoUWK3o43KQjJdK3LYb9H3qiF27O6HgAJkeJHLl/pxHnM
	BM60AegO+jAj/Z9Y1jJBm+zSU6nH6sbJJH9l2XxEBrfxY81yHEIleQj2b8pK9qqIiFqiG43uYCU
	YmTYL2/gsVyApLh7k0XZy68PxDmYQk26isjzIYIGPmLmHr2h/+Y8CaA==
X-Gm-Gg: ASbGnctAF4SHngaHagAtUbz3EBaxa/3lOKhVR8QAV+1Yg38dgRNwdiia1efsiPbqteQ
	DNOggQyo8spdVDmtFjd8WuCV7zGQMYXCdZt2yyTc1PlF0rDRj4TC+1JKkvvkndinDKcgN7vS5Hi
	uDodgsy8m5Xoy6yLfclA3KaAisDrbgLCdDGfjvP9Xha/ycTOeYTZJZJ/YSF8vEytiyHayx8TUKR
	1+c6MwOFmESCOH8hxxqsEd2sJBDrJ5/GTWPCX6VFpiUKrScFnuogHAWAM1Y90aqx/6j2QZh0kvy
	cZd20IHuUkWO
X-Received: by 2002:a17:90b:3d84:b0:309:f5c6:4c5c with SMTP id 98e67ed59e1d1-30a34450c14mr2039782a91.25.1745991739022;
        Tue, 29 Apr 2025 22:42:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/2rRziMqV7exhtrwhKlwQtmufkCV9nFsAwejZ6czk2oG8bIJh878e13vez0tndZIUCamZFg==
X-Received: by 2002:a17:90b:3d84:b0:309:f5c6:4c5c with SMTP id 98e67ed59e1d1-30a34450c14mr2039752a91.25.1745991738750;
        Tue, 29 Apr 2025 22:42:18 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a60882sm624669a91.45.2025.04.29.22.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 22:42:18 -0700 (PDT)
Message-ID: <a045f5a3-d637-45b0-b109-394e8ad0f409@redhat.com>
Date: Wed, 30 Apr 2025 15:42:09 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/43] kvm: arm64: Don't expose debug capabilities for
 realm guests
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-9-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-9-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 69WbC0ZLlRBN_8W4YJMSgiIC9PyxS1PZzWWdex28vA4_1745991739
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> RMM v1.0 provides no mechanism for the host to perform debug operations
> on the guest. So don't expose KVM_CAP_SET_GUEST_DEBUG and report 0
> breakpoints and 0 watch points.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Remove the helper functions and inline the kvm_is_realm() check with
>     a ternary operator.
>   * Rewrite the commit message to explain this patch.
> ---
>   arch/arm64/kvm/arm.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

