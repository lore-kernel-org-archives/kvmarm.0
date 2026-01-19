Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25D926D4F7
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768837636; cv=none; b=Utl8u3BToPM1lliayQo/LBdEvSAhQxrjTSIU9sF5sFiYfurNW1jLBVYtChHKqUFF9gGZVPlXVLJeJmxUgNEc6OWSVPx78f8MvCyEacKAdrasM699/G1Ajm422IUqXlJo9Q60MXNeloIu+PEsC9yyPZhagSgL8tKa0uSIRio0Nzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768837636; c=relaxed/simple;
	bh=6BWds6VcmhM8rrmg/2Uz4DjMpaoIhYlomG7kJ5pFMD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qwnEi+XxwAKQ52UPcAnf9l2oXWOk295rW4OfK3p6BOZhwA3Uy568JuuEcoy09bXcrx4gg/WTSvCVG4Tprh5q5EYxoC0WJbJMXy121Y/yIQqAkKUlPdms7wf8uLLpFmbFA42kbDXAGiffThOCryXm/hPnwaJ73CpRndwP0HZZRME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0554FEC;
	Mon, 19 Jan 2026 07:47:07 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F3963F694;
	Mon, 19 Jan 2026 07:47:09 -0800 (PST)
Message-ID: <e0be8ced-4bfe-437a-ae4d-9b4dcc15d100@arm.com>
Date: Mon, 19 Jan 2026 15:47:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/47] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, will@kernel.org,
 corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-12-ben.horgan@arm.com> <aWk8aZafbtXx5bPu@arm.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aWk8aZafbtXx5bPu@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Catalin,

On 1/15/26 19:13, Catalin Marinas wrote:
> On Mon, Jan 12, 2026 at 04:58:38PM +0000, Ben Horgan wrote:
>> +static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
>> +					    u16 partid_d, u16 partid_i,
>> +					    u8 pmg_d, u8 pmg_i)
>> +{
>> +#ifdef CONFIG_ARM64_MPAM
>> +	u64 regval = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
>> +
>> +	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
>> +#endif
>> +}
> 
> Isn't this function, together with mpam_thread_switch(), in an enclosing
> #ifdef already?

Yes, I'll remove the inner #ifdef.

Thanks,

Ben

