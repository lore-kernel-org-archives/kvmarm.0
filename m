Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A89149EC63;
	Fri, 25 Sep 2026 15:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349837; cv=none; b=O9SleeZCes9BWyVLRN1tWU1o/9+fy5Ji85rkCntyigCQg8uiah1NKQVZ2+ZkkC67b/PRJfqjeDeD5vzNnnRHrykviISt7fngIgLKGMrZjClOSGZvuY3vW+U3XOeTWZ9I7gGstaoHLjzMXFg1W7sPrAEF5Ifr3JzxcVUstd/eSEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349837; c=relaxed/simple;
	bh=//y9dPhjHq/ujPCrO92ZhJvyqsgBfC/qyzgIoS31GyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0rDBMRaXJvaZcR2oih8a31NriavEC6062zEDRM4erOoD89elahJi5Z5oIpcCHDuSDs4s+MMmsx+2svASPYwKpztQQDwpB7TcHWf2zHGKglYBS946rekeacLJN2TzyFVxGxNs2lc4wCxvtnkYrHvbeZXZ3c5vtic9voiDDl64wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hiPkvze6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hiPkvze6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E24B1688;
	Fri, 25 Sep 2026 08:23:51 -0700 (PDT)
Received: from [10.57.10.17] (unknown [10.57.10.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 863F73F882;
	Fri, 25 Sep 2026 08:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790349834; bh=//y9dPhjHq/ujPCrO92ZhJvyqsgBfC/qyzgIoS31GyY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hiPkvze6xWnuXgjf7isAW+6ZYs+8hiozwT76bIXaPIMZqQDQFSopSgQ6Ul8qjMvDN
	 1dn7ziLWqkMm5w1VMB5N5WKNtRd5RVjl7Wmcv+VRFKuQCVGYi7yYBkALg4o1GccVnq
	 VNXBzkBnu5Ats955xS9i5iq3lPWyOYFAmdJTS9MI=
Message-ID: <f7662116-ef8e-4f97-90a4-07173236617b@arm.com>
Date: Fri, 25 Sep 2026 16:23:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 2/7] firmware: arm_rmm: Check for RMI support at init
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
 <20260924135201.850038-3-suzuki.poulose@arm.com> <arZQCiF3iqp9eCsy@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arZQCiF3iqp9eCsy@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/09/2026 11:42, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 02:51:56PM +0100, Suzuki K Poulose wrote:
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 32102c3912fa7..e8b29983b0021 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -293,6 +293,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
>>   static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
>>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),
> 
> I think we end up exposing this to (any) guest unless we mask it out in
> sanitise_id_aa64dfr0_el1(). Do the guests care about the RME version? I

Valid point. I personally don't think this matters. The FEAT_RME alone
is not useful or harmful. I could mask it in KVM as a safe bet.

Cheers
Suzuki

> don't think they should, especially the non-realm ones. For nested it's
> masked away already (limit_nv_id_reg()).
> 

