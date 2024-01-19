Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E385F55E7B
	for <kvmarm@lists.linux.dev>; Fri, 19 Jan 2024 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705684567; cv=none; b=Zgdtj6BeWcr/wnypxp7kWCOQPLxYuWIwlAofDymvgeEROzHiOLELPeZYFI9YnDTRbUtKaCEkZ3GMUmrNdQVg/juzTpYHwsK5pDoQWBug7FziAh7DRdCLerLB+mnMDLselCqP4U0XcJ/qT4SUvgZOiRyMQMbxNMo4P/v2V0GX/84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705684567; c=relaxed/simple;
	bh=jt7dOvCPCY9r7Cu73aJ/UCynKwSwXvLRA3lixD/f1bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=byjQqAjPlSVhgcdKazBcParwzjecoxZAIAXxEB+zOqfN7B1dBCXhh9uBdE+KoZyVSTZjgek2f9rAbinqq57edVynIEhE5pBuIuswWDSAv7Zaax7aSlR7t8hmJ/IoXl+OJqyTmnQYLS60xm5ZJFOWc25h/seeKItwib+84eRvwXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 755CE1042;
	Fri, 19 Jan 2024 09:16:49 -0800 (PST)
Received: from [10.1.197.60] (eglon.cambridge.arm.com [10.1.197.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50A5A3F5A1;
	Fri, 19 Jan 2024 09:16:01 -0800 (PST)
Message-ID: <f06ed418-922d-54c5-22a0-bde127146b5a@arm.com>
Date: Fri, 19 Jan 2024 17:15:59 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/4] KVM: arm64: Hide unsupported MPAM from the guest
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231207150804.3425468-1-james.morse@arm.com>
 <ZXoTG1Y4O16Cjq39@linux.dev>
From: James Morse <james.morse@arm.com>
In-Reply-To: <ZXoTG1Y4O16Cjq39@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 13/12/2023 20:24, Oliver Upton wrote:
> On Thu, Dec 07, 2023 at 03:08:00PM +0000, James Morse wrote:
>> This series fixes up a long standing bug where MPAM was accidentally exposed
>> to a guest, but the feature was not otherwise trapped or context switched.
>> This could result in KVM warning about unexpected traps, and injecting an
>> undef into the guest contradicting the ID registers.
>> This would prevent an MPAM aware kernel from booting - fortunately, there
>> aren't any of those.
>>
>> Ideally, we'd take the MPAM feature away from the ID registers, but that
>> would leave existing guests unable to migrate to a newer kernel. Instead,
>> use the writable ID registers to allow MPAM to be re-enabled - but emulate
>> it as RAZ/WI for the system registers that are trapped.

> This is certainly a reasonable approach, but TBH I'm not too terribly
> concerned about the completeness of the workaround plumbing that we need
> here. Undoubtedly what you propose is the most complete solution to the
> problem, but it is somewhat involved.

Yup, I figured having a new upper limit than the default for id registers would be needed
at some point, but maybe not today.


> So long as we don't break migration at the userspace ioctl level I'm not
> too worried. Maybe something like:
> 
>  - Ensure the reset value of ID_AA64PFR0_EL1.MPAM is 0
> 
>  - Allow userspace to write ID_AA64PFR0_EL1.MPAM as 1, *but*

>  - KVM reinterprets this as '0' behind the scenes for the final register
>    value

>  - Add the MPAM registers to the sysreg table with trap_raz_wi() as the
>    handler to avoid the unsupported sysreg printk, since it is possible
>    that older VMs may've already seen the MPAM feature.

> We've already done something similar to hide our mistakes with IMP DEF
> PMU versions in commit f90f9360c3d7 ("KVM: arm64: Rewrite IMPDEF PMU
> version as NI"), and I think MPAM may be a good candidate for something
> similar.

As there is precedent, I feel less dirty doing that!

This also solves the problem of the VMM re-writing the broken value after the vCPU has
started running, and getting a surprise error. A weird side effect of doing this would be
you can write MPAM=1 on A53 and KVM will ignore it, I don't want user-space to start
relying on that! I'll add a final-cap check so this can only be ignored on hardware that
actually has MPAM, and could have been exposed to the bug.


Thanks,

James
