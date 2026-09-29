Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB0A51DB14;
	Tue, 29 Sep 2026 12:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790684112; cv=none; b=Whh/9nzYoQBqDnFkkuIk4Azb8PLGEYD7QUNSeGaQC25TCSjhEfypMNY3PpVLg1Vhl8IGPIHrawlCAI0cuZxFsdayK83ia/yIuUBAUvzhlbo/KIEzwlxdZ+dGoDIYmCJ76ex2wB5ZAOELDOX4aenp1rcPiNKfIIby650IabkdUnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790684112; c=relaxed/simple;
	bh=fKf+MQsHsTqBw9S5I/sRTtOpEHY+jJc4iJgimZH5RsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uOoy/xiAdTLu7cVKF7A655/rdlBH2LehJiSePXUJsgDMRwKUwBmH1f9ObRdc/uOQtvK+0qCBu5XeDW9xQdnByOjbJoatq5v8loYr4TYkvJI8+eKqHAf03j/oMXCQh3npE9HwecCZM52gMasblVVpeQCF/CfN56s4f0oWxQNqzIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HITdtAq7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HITdtAq7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5ACD51476;
	Tue, 29 Sep 2026 05:15:06 -0700 (PDT)
Received: from [10.57.12.116] (unknown [10.57.12.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AED7C3F86F;
	Tue, 29 Sep 2026 05:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790684109; bh=fKf+MQsHsTqBw9S5I/sRTtOpEHY+jJc4iJgimZH5RsE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HITdtAq75oNRx3Z63AmHRvFNEG8MwjXFTdQtZ3bjgWz/LK4LCf4OIkGmWMsCOo1Ts
	 JJOmZHqnkldvAiQ1u+nMzemAH7XOOQKCu2EZYx0gsnynacSO5dkak55hXOU92mhwbu
	 +a0kGk+dH0m1Cda4aM9JU+UuS26n1xynIZCw2vPI=
Message-ID: <cabdfbaf-92dd-4873-9993-c65f6f55f913@arm.com>
Date: Tue, 29 Sep 2026 13:15:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 7/7] firmware: arm_rmm: Add wrappers for Realm related
 RMI commands
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-8-suzuki.poulose@arm.com> <arZhdzjoOejKdAvp@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arZhdzjoOejKdAvp@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/09/2026 12:56, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 02:52:01PM +0100, Suzuki K Poulose wrote:
>> + * rmi_rec_create() - Create a REC
>> + * @rd: PA of the RD
>> + * @rec: PA of the target REC
>> + * @params: PA of REC parameters
>> + * @sro: Allocated SRO context to be used
>> + *
>> + * Create a REC using the parameters specified in the struct rec_params pointed
>> + * to by @params.
>> + *
>> + * Return: 0 on success, positive RMI result code or negative Linux error code
>> + */
>> +static inline long rmi_rec_create(unsigned long rd,
>> +				  unsigned long rec,
>> +				  unsigned long params,
>> +				  struct rmi_sro_state *sro)
>> +{
>> +	long ret;
>> +
>> +	sro->addr_count = 0;
>> +	sro->regs = (struct arm_smccc_1_2_regs) {
>> +		SMC_RMI_REC_CREATE, rd, rec, params
>> +	};
>> +	ret = rmi_sro_memxfer_execute(sro, GFP_KERNEL);
>> +	rmi_sro_free(sro);
>> +
>> +	return ret;
>> +}
> 
> Nit: isn't this just open-coding rmi_sro_memxfer_cmd()?

Ack, fixed.

Suzuki

> 

