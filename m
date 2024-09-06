Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFB23FEC
	for <kvmarm@lists.linux.dev>; Fri,  6 Sep 2024 00:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725581517; cv=none; b=Mc0rN4thxKn93Dzulxupotfo2I7KIuWVm4tOtsvJ/NQtat0zhhRo8gaXcO44a6CCifv/aWZZu8G/Mrjyals3PVvfiq+Lk8TQ0S8UgSOFIh9qOl6mG3gHeJfmk+AUfA5JBsSHPj8YOlC2wv1Ifz4uYVl6FhW7EEI/LdAqe4ce0+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725581517; c=relaxed/simple;
	bh=WiXv8hX9YZancIkVdHpHwSwJynH9Vx0kkTy6hfFFNvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EJC54pSWaGCg7LD/P6Y69r6g5r2wN+KZvmITEabusoiqsIQRhYsi+dhzAKN9C1GzDQzNxfJyZ6a6KEEhoaG0p2u6nLFi//A/dbzjUHaCl+BXCdEHzR8kRU9xIbdwoXSLvMfMNTrV174shkyOx1E3YUsIeHYz5/YM+dcnYOjitiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KichCM/Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KichCM/Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725581514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JCf63UUAEsoVjhHUgMARlZrjCRqgXN/a16VIpsPHI30=;
	b=KichCM/ZTZ0nnHpBB8xTaQ0f4LKuQV5xCo5Y7XjYLS3ibt7nAEiyZdvRdMMSs/QA+pQOtQ
	8ZXpnTfJdHh/zdS5k40fdQMi2E5gaXWwjP80VwMtKbdb4oKEVnk+xfaaC9h9yFF4q4DAL6
	Mlgp9hf2xaEEo7z5md7+9Fpg+I+IUq4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-U8aTLmJQPhiS2OQxzx2X_g-1; Thu, 05 Sep 2024 20:11:50 -0400
X-MC-Unique: U8aTLmJQPhiS2OQxzx2X_g-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-718d6ad6105so240037b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Sep 2024 17:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725581509; x=1726186309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JCf63UUAEsoVjhHUgMARlZrjCRqgXN/a16VIpsPHI30=;
        b=dhlK+8jWb92dKHy/m71f1/cryIVFP0RV6oTy6OVfEYwrguqlSj8LGaTuetOf9WONCR
         ysVW8WXZ8ZF9dzwxFNpq7wbIfzx2afgleQYFdkeYHtP+e+u02GpgfUlVL4HB3mIPjodp
         QqwEOEKbBs0x2gGK9DYhjuVDLqvKlqe78+8zoDQBrglEhyhXN3W+8qenzlkUrHEMDLrM
         6DFHcY7qYNy7EzkA+0I1SZCUaixPp8S7rjBxKh6W5QtCrBTvQYtJaUA30ug6Z3k+OMtZ
         rLpGqyzUeohKNhP5qiolT6bq32uCnqvyO346L8a11I2oJlx1Y6z5rBPoQXWI2thEMeBM
         X7IA==
X-Forwarded-Encrypted: i=1; AJvYcCUURhGqvjC2NgP+0/xMv3y7g8spgHdAQi4VkynewlHWWXGh0uvZm8G40Qai48rVFy/HLKdCJuo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwQNhPfO9aLvQaQgSl2K+B88FJ1C/N3MsT/P5NaBxES6+z04VW
	uLRsjDIEWmy4IQXshY+etKgHlFQb2frs7pkrXMtN5NNFR+l3YX2jOYgGNyFnh+eiDM3kgG0CvLY
	dDZBBUJxPJCcxz2Sr3ZQHGCtObJglLyTHaJhgG/8va/1YllxlRKN6YQ==
X-Received: by 2002:a05:6a00:2d89:b0:717:90df:7cbb with SMTP id d2e1a72fcca58-718d5f32a78mr828864b3a.22.1725581509045;
        Thu, 05 Sep 2024 17:11:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQ1mDgKhDpSBr33m3qRjdU1KN0Ixr0d3LiEv3WDkhrTsLXZpCco0dlZ/A1QyM+Jkkdv532Jg==
X-Received: by 2002:a05:6a00:2d89:b0:717:90df:7cbb with SMTP id d2e1a72fcca58-718d5f32a78mr828823b3a.22.1725581508457;
        Thu, 05 Sep 2024 17:11:48 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718087d92ffsm535625b3a.153.2024.09.05.17.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2024 17:11:46 -0700 (PDT)
Message-ID: <fc168fe2-2b19-4930-85cf-047260aeaef0@redhat.com>
Date: Fri, 6 Sep 2024 10:11:37 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/43] arm64: RME: Add SMC definitions for calling the
 RMM
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-6-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240821153844.60084-6-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

On 8/22/24 1:38 AM, Steven Price wrote:
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0-rc1
> 
> [1] https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v3:
>   * Update to match RMM spec v1.0-rel0-rc1.
> Changes since v2:
>   * Fix specification link.
>   * Rename rec_entry->rec_enter to match spec.
>   * Fix size of pmu_ovf_status to match spec.
> ---
>   arch/arm64/include/asm/rmi_smc.h | 253 +++++++++++++++++++++++++++++++
>   1 file changed, 253 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
> 

[...]

> +
> +#define RMI_FEATURE_REGISTER_0_S2SZ		GENMASK(7, 0)
> +#define RMI_FEATURE_REGISTER_0_LPA2		BIT(8)
> +#define RMI_FEATURE_REGISTER_0_SVE_EN		BIT(9)
> +#define RMI_FEATURE_REGISTER_0_SVE_VL		GENMASK(13, 10)
> +#define RMI_FEATURE_REGISTER_0_NUM_BPS		GENMASK(19, 14)
> +#define RMI_FEATURE_REGISTER_0_NUM_WPS		GENMASK(25, 20)
> +#define RMI_FEATURE_REGISTER_0_PMU_EN		BIT(26)
> +#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS	GENMASK(31, 27)
> +#define RMI_FEATURE_REGISTER_0_HASH_SHA_256	BIT(32)
> +#define RMI_FEATURE_REGISTER_0_HASH_SHA_512	BIT(33)
> +#define RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS	GENMASK(37, 34)
> +#define RMI_FEATURE_REGISTER_0_MAX_RECS_ORDER	GENMASK(41, 38)
> +

Those definitions aren't consistent to tf-rmm at least. For example, the latest tf-rmm
has bit-28 and bit-29 for RMI_FEATURE_REGISTER_0_HASH_SHA_{256, 512}. I didn't check the
specification yet, but they need to be corrected in Linux host or tf-rmm.

   git@github.com:TF-RMM/tf-rmm.git
   head: 258b7952640b Merge "fix(tools/clang-tidy): ignore header include check" into integration

   [gshan@gshan tf-rmm]$ git grep RMI_FEATURE_REGISTER_0_HASH_SHA.*_SHIFT
   lib/smc/include/smc-rmi.h:#define RMI_FEATURE_REGISTER_0_HASH_SHA_256_SHIFT     UL(28)
   lib/smc/include/smc-rmi.h:#define RMI_FEATURE_REGISTER_0_HASH_SHA_512_SHIFT     UL(29)

Due to the inconsistent definitions, I'm unable to start a guest with the following
combination: linux-host/cca-host/v4, linux-guest/cca-guest/v5, kvmtool/cca/v2.

   # ./start_guest.sh
   Info: # lkvm run -k Image -m 256 -c 2 --name guest-152
   [  145.894085] config_realm_hash_algo: unsupported ALGO_SHA256 by rmm_feat_reg0=0x0000000034488e30
   KVM_CAP_RME(KVM_CAP_ARM_RME_CONFIG_REALM) hash_algo: Invalid argument

Thanks,
Gavin

