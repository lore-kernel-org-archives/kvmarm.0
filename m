Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C15B46D2DD;
	Mon, 28 Sep 2026 08:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582733; cv=none; b=j27vsfPxAmpZ3kjPrviMz6P8Y32O8QS/HnvVxtyeQuXU/bB5ihAiDUSllCeSibUjHNqGPvNLtqZA7gsQmVk5o1zjDfyXj/TmkgowXmrWSzMMU5RPsDECphy+LFHZ0k3xyBdRx9qUzUaYXrzLwNCAl/AdjQiXS3eekdzBEmqLfRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582733; c=relaxed/simple;
	bh=ZoYd2sdPRi7PYnEG0IlvFGd13KoF/WZCPDZleG3Y+cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VrpNlQxPWhc4DnAGOIsvvf5OVKsiTC1sKp0Jth2SwwEGgNq61UeCUabXa4KfqWYXMZ3e9u+aM08xzRIPN5+xkSdfFhbRA++UXkMv49YXrQCYx8dgdEMUUIvxnmtCx12Vf9sf4SfKsDRqrPu2ohEWLKwlZIzUuyFhAA9FTeeWdsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GZFpwPFl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GZFpwPFl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72046169E;
	Mon, 28 Sep 2026 01:05:24 -0700 (PDT)
Received: from [10.57.12.79] (unknown [10.57.12.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 949CB3F86F;
	Mon, 28 Sep 2026 01:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790582727; bh=ZoYd2sdPRi7PYnEG0IlvFGd13KoF/WZCPDZleG3Y+cw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GZFpwPFl7ovI3rDNT/2mn4+w0i4sXv4nTmdNKJvdtEoZbukSO66jtaCM+F9CsbXdb
	 ZQvnQ+cf9fHw3YVxkeX+xcls+suLYnK7BcC2DCPEW+ZevQmsUlgnB7EwYSwF+Huj6z
	 s6cD2Zr1h9Xg0ltB6Jac4THbkfTIu9l/lUMJZmoE=
Message-ID: <88bd2049-d25b-4767-81f8-83c99749fd11@arm.com>
Date: Mon, 28 Sep 2026 09:05:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 2/7] firmware: arm_rmm: Check for RMI support at init
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-3-suzuki.poulose@arm.com> <arZQCiF3iqp9eCsy@arm.com>
 <f7662116-ef8e-4f97-90a4-07173236617b@arm.com> <87v77r2ga5.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <87v77r2ga5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/09/2026 10:29, Marc Zyngier wrote:
> On Fri, 25 Sep 2026 16:23:49 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On 25/09/2026 11:42, Catalin Marinas wrote:
>>> On Thu, Sep 24, 2026 at 02:51:56PM +0100, Suzuki K Poulose wrote:
>>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>>> index 32102c3912fa7..e8b29983b0021 100644
>>>> --- a/arch/arm64/kernel/cpufeature.c
>>>> +++ b/arch/arm64/kernel/cpufeature.c
>>>> @@ -293,6 +293,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
>>>>    static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>>>>    	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
>>>>    	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),
>>>
>>> I think we end up exposing this to (any) guest unless we mask it out in
>>> sanitise_id_aa64dfr0_el1(). Do the guests care about the RME version? I
>>
>> Valid point. I personally don't think this matters. The FEAT_RME alone
>> is not useful or harmful. I could mask it in KVM as a safe bet.
> 
> Is there *any* case where the guest (realm or not) should know it is
> running on RME enabled HW? I can perfectly imagine that someone would

We don't do that for Linux Guests at least. The Realms rely on the 
presence of RSI ABI.

Cheers
Suzuki


> implement something looking like CCA on non-RME systems.


> 
> 	M.
> 

