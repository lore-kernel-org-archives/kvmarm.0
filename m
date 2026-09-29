Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E511651DDFC;
	Tue, 29 Sep 2026 12:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790684162; cv=none; b=egFe6MImHvZBTK+bqXGMQOAAl3m5yjRcWr0MVFytfl7VAeyMpACHY02qRcrFSDiv1YnLlS2Y3KlGPmDL8kaIeTGZ+pNwnGzPeuVehwPt8+S/yURQ0sxVLNEMZutQ+LwRs5GoK+bAzpztBaF8l6FXkeZCb6bfcJhGZli8o44DUGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790684162; c=relaxed/simple;
	bh=SzxPLnpzbm4Ir0vMlYp80TqFCuEZ1W6xvmkpxL/9kpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hfq5XcRfFG64G7ZB5FwrktA1kehfPr0dKdg668ZCOHC8+ZhgN2bVS1QZCkXXhujCiZm2O0WS27cgt0u3Eg0k2ZgYOytcIJtBusYGVwmN4ajTr9QHBuhnud99QcfwKz1dr43hxQizgkXFbZKX5TKnwD9nNxx6Fcy82zTB+jttCYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NIiT3/7h; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NIiT3/7h"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FC492F;
	Tue, 29 Sep 2026 05:15:54 -0700 (PDT)
Received: from [10.57.12.116] (unknown [10.57.12.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35FE13F86F;
	Tue, 29 Sep 2026 05:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790684157; bh=SzxPLnpzbm4Ir0vMlYp80TqFCuEZ1W6xvmkpxL/9kpQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NIiT3/7hjkCIhjmRdAjzF7PuTM9EdvbtwDwovpFg065izKOxLv6GMvuTbWH359u2U
	 c6uMoLkpmL6XMfvuraVDMyhsADR+UooRXj4TBe3ppiwcUz1SLMUOxGdRM7YXgVBAab
	 LSV632zZUYtpgtMg67N5qXviT7Qlo2eNYW8rqyGw=
Message-ID: <3610ef9d-6e0c-4e20-a6b9-1f11bf6031e6@arm.com>
Date: Tue, 29 Sep 2026 13:15:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
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
 <20260924135201.850038-7-suzuki.poulose@arm.com> <aruaeLI76_kcvIhp@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aruaeLI76_kcvIhp@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/09/2026 12:01, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 02:52:00PM +0100, Suzuki K Poulose wrote:
>> +/*
>> + * Make sure the area is tracked by RMM at FINE granularity.
>> + * We do not support changing the tracking yet.
>> + */
>> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
>> +{
>> +	while (start < end) {
>> +		unsigned long ret, category, state, next;
>> +
>> +		ret = rmi_granule_tracking_get(start, end, &category, &state, &next);
>> +		if (ret != RMI_SUCCESS)
>> +			return -ENOMEM;
>> +
>> +		if (WARN_ON(next <= start))
>> +			return -ENXIO;
>> +
>> +		if (state != RMI_TRACKING_FINE ||
>> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
>> +			/* TODO: Set granule tracking in this case */
>> +			pr_err("Granule tracking for region isn't fine/conventional: %llx-%lx\n",
>> +			       start, next);
>> +			return -ENODEV;
>> +		}
>> +		start = next;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * rmi_gpt_info - Query the GPT info for the given PAR.
>> + * @start: Base of the physical address region
>> + * @end: Top of the physical address region
>> + * @out_top: Top of the physical address region for which
>> + *		the GPT @out_gpt_par_state is valid
>> + * @out_gpt_par_state: State of the GPT covered by [start, out_top)
>> + */
>> +static long rmi_gpt_info(unsigned long start, unsigned long end,
>> +			 unsigned long *out_top,
>> +			 unsigned long *out_gpt_par_state)
>> +{
>> +	struct arm_smccc_1_2_regs regs = {
>> +		SMC_RMI_GPT_INFO, start, end,
>> +	};
>> +
>> +	rmi_smccc_invoke(&regs);
>> +	if (regs.a0 != RMI_SUCCESS)
>> +		return regs.a0;
>> +
>> +	if (out_top)
>> +		*out_top = regs.a1;
>> +	if (out_gpt_par_state)
>> +		*out_gpt_par_state = regs.a2;
>> +
>> +	return RMI_SUCCESS;
>> +}
>> +
>> +/*
>> + * We do not support creating L1 GPTs yet. So, make sure that
>> + * all the regions are managed by the firmware.
>> + */
>> +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, phys_addr_t end)
>> +{
>> +	unsigned long l0gpt_sz;
>> +	unsigned long next, par_state;
>> +
>> +	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
>> +					  rmi_feat_reg(1)));
>> +	start = ALIGN_DOWN(start, l0gpt_sz);
>> +	end = ALIGN(end, l0gpt_sz);
>> +
>> +	while (start < end) {
>> +		long ret = rmi_gpt_info(start, end, &next, &par_state);
>> +
>> +		if (ret != RMI_SUCCESS)
>> +			return -ENOMEM;
> 
> Nit: what does -ENOMEM actually mean here? Was there any allocation?
> Maybe -ENXIO is better suited, as the one below. Also, is it useful to
> print something like we do further down?
> 
> Same comment for rmi_verify_memory_tracking().
> 
>> +		if (WARN_ON(next <= start))
>> +			return -ENXIO;
>> +
>> +		if (par_state != RMI_GPT_PAR_PLAT) {
>> +			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
>> +				start, next);
>> +			return -ENOMEM;
> 
> Nit: in v18, Gavin suggested returning -ENODEV here (the hunk he
> proposed). I think it makes more sense and it matches the -ENODEV in
> rmi_verify_memory_tracking().

Ack, I have incorporated both suggestions.

Suzuki

> 

