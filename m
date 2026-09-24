Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BE13A9DBE;
	Thu, 24 Sep 2026 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288165; cv=none; b=iz7e2zPSp3uX6qUpA4MlRpO2iq2Js+h27KACrxKg8VZ12yZxIp8jsLN7LngHk+oxfU+f+ok5gX/RE2ugdq/kK8AVcJFpSI8ahhrtalVpJVOqiFlJnewkLcpoeA852789s2CEDIckgLO+HoqrFMRG1NCODDPAwkzwxi6/LA4JzxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288165; c=relaxed/simple;
	bh=w55oFxyasq/JaOo+eWuI/wiOSjEK/BHz20zexwH7QsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RsS38oIQ9O88t0149+GjJ/pBTgwnt+XHF786PSIYUCpk9EcL3vDmBwJmDgfqfJyHxamtvSg5HD584DYzlkhmr7WXwqk5UDUlRG+eVgT2BwoPrvmgShdKPbhZZYGaKmiiqK/d7sRZ1ZrZpy3sYEfrbO+FpyVCzbxtkLiHtaq9WTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M/IB9ZOe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M/IB9ZOe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAC5F1E5E;
	Thu, 24 Sep 2026 15:15:55 -0700 (PDT)
Received: from [10.57.10.88] (unknown [10.57.10.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B9B93F86F;
	Thu, 24 Sep 2026 15:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790288159; bh=w55oFxyasq/JaOo+eWuI/wiOSjEK/BHz20zexwH7QsQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M/IB9ZOemKQDQEvic71j4jcxtkn8nKprm3yJOeOepBTucL2LNaNr4+jija45pf2Gt
	 yJvU0/cC4QCnbExWxwxkmvMeuvnvToVzhRmaJ4YlAUqJMpt6RS6gljojzVhiCRvsdB
	 W5CPqP48trn08kPjTZSYhtiSlr2uToEKU1gwDEX0=
Message-ID: <aa877f31-0ae7-4042-bab2-6a818003d26e@arm.com>
Date: Thu, 24 Sep 2026 23:15:49 +0100
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
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-2-suzuki.poulose@arm.com>
 <20260924095712.00004057@oss.qualcomm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260924095712.00004057@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/09/2026 17:57, Jonathan Cameron wrote:
> On Thu, 24 Sep 2026 14:51:55 +0100
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
>> From: Steven Price <steven.price@arm.com>
>>
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by SMC calls from the host.
>>
>> The SMC definitions are based on DEN0137[1] version 2.0-bet3
>>
>> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Hi Suzuki,
> 
> One small thing I didn't really care about but where I thought you
> said you were going to tweak things.
> 
> Either way
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

Thanks !

> 
>> +struct rec_exit {
>> +	union { /* 0x000 */
>> +		u8 exit_reason;
>> +		u8 padding0[0x100];
>> +	};
>> +	union { /* 0x100 */
>> +		struct {
>> +			u64 esr;
>> +			u64 far;
>> +			u64 hpfar;
>> +			u64 rtt_tree;
>> +		};
>> +		u8 padding1[0x100];
>> +	};
>> +	union { /* 0x200 */
>> +		u64 gprs[REC_RUN_GPRS];
>> +		u8 padding2[0x100];
>> +	};
>> +	union { /* 0x300 */
>> +		u8 padding3[0x100];
> 
> I thought plan was to fold into the padding above?
> 
> https://lore.kernel.org/all/d7ccaf22-5bde-4344-8bf0-a5a17dcac0f3@arm.com/

Yep, I missed it :facepalm:,  Apologies. I will fix it straight awy.

Cheers
Suzuki

> 
>> +	};
>> +	union { /* 0x400 */
>> +		struct {
>> +			u64 cntp_ctl;
>> +			u64 cntp_cval;
>> +			u64 cntv_ctl;
>> +			u64 cntv_cval;
>> +		};
>> +		u8 padding4[0x100];
>> +	};
> 
> 

