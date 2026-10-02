Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A973E2746;
	Fri,  2 Oct 2026 06:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790921653; cv=none; b=TgTOb9KWwivqtd62DifjWNjQwgNbhFOuLs3UYgvywkrNjFUCfRGNdPGcjOmQ5c5Xw4UwP6XNJ8Rm6ZiXjnt8okItAfC4CZ+KMdfn3YSxoy4EnPAwwTRQoHraBc5uwUegSxHqYOGq9gWLCfx0eWX6WlEpkR8sCDdNFfGppHgvhrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790921653; c=relaxed/simple;
	bh=SsgMdMqkZr1vaFYa2pWzMon3Yxx21LaFdOWhNvtsxHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nGgOalSHJmw+O9LpxYbkNHPFr3tMITFrK/h/uHefJcaOfjxy/73OL6mM7chE22NiUOj3QJgc/PQPQxfjaMF+7dco5gtRCLmCD5G5CDskNae4UG6Y+BKyyiWGVJuqOGcUgdSr5FxQKZZ4Q67lv1cjarDaFUJsjASFimmg4UYkNEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kHY8wHRu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kHY8wHRu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F89E497;
	Thu,  1 Oct 2026 23:14:00 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C13A63F763;
	Thu,  1 Oct 2026 23:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790921643; bh=SsgMdMqkZr1vaFYa2pWzMon3Yxx21LaFdOWhNvtsxHI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kHY8wHRuh7AfhqfmWnl3om0ajgb5AMaYtPbLSREf67cyr9fQzKgGuW6QuNVVep6i+
	 mx+3mjbUcT9wAfk4c9eN+/NWjYGxVeLoLGD6tiQ0x02zHQvt3k+vGIAywx+gSpoOAN
	 /cTlusOHXXGyFfN625JjWdDyiYJmPux67oisSA+I=
Message-ID: <63211ffe-fbf7-490e-940a-f9028f9412f6@arm.com>
Date: Fri, 2 Oct 2026 07:13:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 00/23] KVM: arm64: CCA: Add basic plumbing for Realms
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <1ed590aa-a4bf-4980-82e1-185aee205909@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <1ed590aa-a4bf-4980-82e1-185aee205909@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01/10/2026 22:41, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 10/2/26 7:06 AM, Suzuki K Poulose wrote:
> 
> [...]
> 
>>
>> NOTE: There is a conflict with Fuad's patch to drop the WARN for 
>> unknown vm
>> ioctls, that is queued in fixes.
>>
>>    https://lore.kernel.org/all/20260914093838.1082637-1- 
>> fuad.tabba@linux.dev
>>
>> This series is comprised of (3) and (4) above.
>>
>> The integration branch has been tested with the following components:
>>
>>    tf-RMM:   main branch (commit 5e6e2acd) compliant to RMM-v2.0-beta3 
>> [4]
>>    kvmtool: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git tag:cca- 
>> kvm-v20
>>
>> [0] Arm CCA KVM Support v16 : https://lore.kernel.org/ 
>> all/20260803134403.80630-1-steven.price@arm.com
>> [1] Linux firmware RMI v22 https://git.gitlab.arm.com/linux-arm/linux- 
>> cca/ cca/cca-host/fw_rmm/v22
>> [2] Linux GPF Host  https://git.gitlab.arm.com/linux-arm/linux-cca/ 
>> cca/cca-host/host-gpf/v19
>> [3] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm- 
>> v21/integration-v3
> 
> This branch doesn't exist. I guess it's "cca/cca-host/kvm-v21/ 
> integration-v2" instead?

Thanks for flaggging. My bad, I have pushed integration-v3 branch.
Both integration-v2 and v3 have the same kvm parts, but based on
different fw-rmm (v21 and v22 respectively, will be posted today).
So, please use the v3.

Kind regards
Suzuki



> 
>> [4] https://support.arm.com/documentation/den0137/2-0bet3/
>>
> 
> Thanks,
> Gavin
> 

