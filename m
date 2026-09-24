Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A777F367B7E;
	Thu, 24 Sep 2026 22:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290167; cv=none; b=rcUjzp104oBkY7aj/cSeWvMWyCc+YM7Q1/niX/3iVuhrldtt825tvDkskQ4boETgLgH6JDa7aPfh61KwG/GiQ+nZWpQIh6ruYCsG8D8c2u8VEkmgJCPNKI29e/1dgFDMTenNKc2CZKFqHjJMrQLZqYNuLmRozIUh4J790OjNJIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290167; c=relaxed/simple;
	bh=es2JFGtR/yGRJZPfDOKoMKeZJ3W57laY+q8VEqDYDKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=czfkl0g3Kiw7ICwHTo0exAqXNKtflO+B3V3Si8VHArcDY6exkn3gACCkmipuDIpza0wtdXk+jNxCL3CR8ZyFkiV9Ywojxz19NiVqO+1V3AcXZRHDD4bjLZ6UApfydosUZcsIoUYJdeZ1kYJnx+gRzcOZ4fgWpxqpDZx66dJ6C8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EgkJpaNp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EgkJpaNp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A19B1E5E;
	Thu, 24 Sep 2026 15:49:21 -0700 (PDT)
Received: from [10.57.10.88] (unknown [10.57.10.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2E7A3F86F;
	Thu, 24 Sep 2026 15:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790290165; bh=es2JFGtR/yGRJZPfDOKoMKeZJ3W57laY+q8VEqDYDKk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EgkJpaNpSmKXCQ7tSyUqJJ7TLOE57d/HFEXpQhNyzI0wo5deOqfhQRez3T70N3pTT
	 Bix9JXOFUrFnJqAyocfD2lZW/1u7kChbRXcFip0wNl3WwyEsoQQLRce9coPL6yn+pv
	 PAC8ZXm7duNeciCJy6fg7vaGlHZ3BNokFcM/J0kU=
Message-ID: <f317970f-a114-4353-a253-174fa449dde1@arm.com>
Date: Thu, 24 Sep 2026 23:49:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
Content-Language: en-GB
To: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
 yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-2-suzuki.poulose@arm.com>
 <CAEvNRgH8Hwt6_VaFxJVvytZ4La1R7bUN2emc37_fWecF9j2-YA@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAEvNRgH8Hwt6_VaFxJVvytZ4La1R7bUN2emc37_fWecF9j2-YA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/09/2026 18:05, Ackerley Tng wrote:
> Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> 
>>
>> [...snip...]
>>
>> +
>> +/*
>> + * Note many of these fields are smaller than u64 but all fields have u64
>> + * alignment, so use u64 to ensure correct alignment.
>> + */
>> +struct rmm_config {
>> +	union { /* 0x0 */
>> +		struct {
>> +			u64 tracking_region_size;
>> +			u64 rmi_granule_size;
>> +		};
>> +		u8 sizer[SZ_4K];
>> +	};
>> +};
>> +
>> +static_assert(sizeof(struct rmm_config) == SZ_4K);

...

>> +struct realm_params {
>> +	union { /* 0x0 */
>> +		struct {
>> +			u64 flags0;
>> +			u64 s2sz;
>> +			u64 sve_vl;
>> +			u64 num_bps;
>> +			u64 num_wps;
>> +			u64 pmu_num_ctrs;
>> +			u64 hash_algo;
>> +			u64 num_aux_planes;
>> +		};
>> +		u8 padding0[0x400];
> 
> The union + sizer concept is cool. Technically this one isn't a padding,
> it's also a sizer? (same for the other structs below.

Yep, you're right. I have changed all in the file to sizer.

> 
>> +	};

...

>> +};
>> +
>> +static_assert(sizeof(struct realm_params) == SZ_4K);
>> +
> 
> Does declaring this struct as packed matter? I guess the static_assert()
> has the same effect.
> 

I guess it doesn't, the fields are naturally aligned for the offset.
That said, I have added static_assert() for starting offsets for a
a group of related fields to match the spec.

e.g;

static_assert(offsetof(struct realm_params, rpv) == 0x400);
static_assert(offsetof(struct realm_params, rtt_base) == 0x808);
static_assert(offsetof(struct realm_params, aux_rtt_base) == 0xf80);



Thanks for the review !

Suzuki

>>
>> [...snip...]
>>

