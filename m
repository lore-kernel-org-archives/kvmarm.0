Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC41242D86
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767632241; cv=none; b=lUFdot1o7JBMtkJfOOmJ9IrLZIbvBDPcMIFKmqpSAJ++9RU9rMEqo4wGVRy7yeFLT1wdQvv3WiXAA6j8u9uR0q0s5lIFr0PPx2GpozkF0lSTImvqEBivYDR2sYh/d5zEimUNGk48cyxoLvDYAGxhOwC/sFX8cnyjXiC7doI4xYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767632241; c=relaxed/simple;
	bh=5smsRiMWCKU+MfoVhiEB92JKqOPKepN2wzr8tKD47wg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u0AvxhU06AIM3aq4ZPZSHwhMXELArsCHK/cDxxpTDM2gqRFVoKqXzwjSnxnUraBebTOK52tgiqFFPkYrL/jlUTUWL4XAPGc83a/6KHlFzfqNgGqBTxEwb0d/0gYiSG+6ls7Mjbz4F1dXWBgOPVP1CSJZSDFJaFw7MXKcUydptvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B61F4339;
	Mon,  5 Jan 2026 08:57:08 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B675F3F5A1;
	Mon,  5 Jan 2026 08:57:10 -0800 (PST)
Message-ID: <a984edef-10e6-4977-a939-6299e37d8ef1@arm.com>
Date: Mon, 5 Jan 2026 16:57:09 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/45] KVM: arm64: Make MPAMSM_EL1 accesses UNDEF
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-7-ben.horgan@arm.com>
 <20260105164738.0000792f@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260105164738.0000792f@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/5/26 16:47, Jonathan Cameron wrote:
> On Fri, 19 Dec 2025 18:11:08 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> The MPAMSM_EL1 controls the MPAM labeling for an SMCU, Streaming Mode
>> Compute Unit. As there is on MPAM support in kvm, make sure MPAMSM_EL1
>> accesses trigger an UNDEF.
>>
>> The range of valid configurations for the PARTID and PMG in MPAMSM_EL1 is
>> not currently specified in Arm Architectural Reference Manual but the
>> architect has confirmed that it is intended to be the same as that for the
>> cpu configuration in the MPAMy_ELx registers.
> 
> Good to know but I'm not seeing why it matters in this patch. Perhaps
> a little more on that?

Hmmm, yes. This paragraph should go with patch 11 where we start setting
MPAMSM_EL1 with the same value as MPAM0_EL1 and MPAM1_EL1.

> 
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
>> ---
>>  arch/arm64/kvm/sys_regs.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index c8fd7c6a12a1..72654ab984ee 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -3373,6 +3373,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>  
>>  	{ SYS_DESC(SYS_MPAM1_EL1), undef_access },
>>  	{ SYS_DESC(SYS_MPAM0_EL1), undef_access },
>> +	{ SYS_DESC(SYS_MPAMSM_EL1), undef_access },
>> +
>>  	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
>>  	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
>>  
> 

Thanks,

Ben

