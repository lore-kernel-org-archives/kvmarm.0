Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81EF53FD960;
	Tue, 15 Sep 2026 19:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789502156; cv=none; b=dsdtM5s4aoSGB61/yx9l7bus78VHmVEwenPIgqcqmFP/UihVws/87SHI+BVhd0F0oQjihMMPfEAn0A0g+iPZ8i/xhrIaPvGUzAi1hyPS6W8DsnPyBTfNZsx1yTh7/NBBkm/cSMalAXB5Y2WR6yMM0ryLD9wxFvtaS9zVp3tkaGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789502156; c=relaxed/simple;
	bh=os1BDjQW0NBjktNzzqxnXfDDyaHtfLgy26yzzeiQoDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jbev1S2oq26nDg/t1ilqaLbfXU9yZ7KuLjR2v7INhyuOOIoMylhg4CgzZZtXfJwsJ+BjOCGmAoZ7dZh8lGiaEv+x8SgP5NkrZdkch5DA0cN1p26x5Xbk+YuDoAoJLgu6dQzoL1NOPrUvWx4w6p8TIeZ3+MR+0AbXAk2PaBnipYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HSa38V7N; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HSa38V7N"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34FCE152B;
	Tue, 15 Sep 2026 12:55:50 -0700 (PDT)
Received: from [192.168.4.158] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 697A53F7B4;
	Tue, 15 Sep 2026 12:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789502153; bh=os1BDjQW0NBjktNzzqxnXfDDyaHtfLgy26yzzeiQoDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HSa38V7N4c8nhvp7rfjuBg2mwrWCDfXnjscowE1tm7LV7+wLp8nz5bQboqStLyKAg
	 6x3nzIcx+n5vvmtfbkNKAfYYmvtpilQoTdLxWtXv+eM/mL7XURFFSgICEmtQ6KOnro
	 G5KtsIMp2ne2O9lN2jsJ9G5QJyqqYKUJBajyGw7Q=
Message-ID: <6f7eef15-da58-4f7f-94ba-778772e91270@arm.com>
Date: Tue, 15 Sep 2026 20:55:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 7/7] firmware: arm_rmm: Add wrappers for Realm related
 RMI commands
Content-Language: en-GB
To: Alper Gun <alpergun@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-8-suzuki.poulose@arm.com>
 <CABpDEukTAc1m=g+rZRPPqaTwrvhUJPsFRWpFd0PxZsyWw5mR=Q@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CABpDEukTAc1m=g+rZRPPqaTwrvhUJPsFRWpFd0PxZsyWw5mR=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/09/2026 20:35, Alper Gun wrote:
> On Sat, Sep 12, 2026 at 1:37 AM Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> [...]
>> +/**
>> + * rmi_rtt_destroy() - Destroy an RTT
>> + * @rd: PA of the RD
>> + * @ipa: Base of the IPA range described by the RTT
>> + * @level: RTT level
>> + * @out_rtt: Pointer to write the PA of the RTT which was destroyed
>> + * @out_top: Pointer to write the top IPA of non-live RTT entries, from entry
>> + * at which the RTT walk terminated.
>> + *
>> + * Destroys an RTT. The RTT must be non-live, i.e. none of the entries in the
>> + * table are in ASSIGNED or TABLE state.
>> + *
>> + * Return: 0 on success, positive RMI result code or negative Linux error code.
>> + */
>> +static inline long rmi_rtt_destroy(unsigned long rd,
>> +                                  unsigned long ipa,
>> +                                  long level,
>> +                                  unsigned long *out_rtt,
>> +                                  unsigned long *out_top)
>> +{
>> +       struct arm_smccc_1_2_regs regs = {
>> +               SMC_RMI_RTT_DESTROY, rd, ipa, level
>> +       };
>> +       long ret = rmi_sro_execute(&regs);
>> +
>> +       if (ret != RMI_SUCCESS)
>> +               return ret;
>> +
>> +       if (out_rtt)
>> +               *out_rtt = regs.a1;
>> +       if (out_top)
>> +               *out_top = regs.a2;
>> +
>> +       return RMI_SUCCESS;
>> +}
> 
> Doesn't out_top (regs.a2) need to be populated on RMI_ERROR_RTT as well?
> realm_tear_down_rtt_level() checks next_addr > addr under case
> RMI_ERROR_RTT: to determine whether the RTT is missing or has child tables
> that need recursive teardown.

You're right. The out_top is valid even when we get RMI_ERROR_RTT. I
will fix it.

Cheers
Suzuki

> 
> Thanks,
> Alper

