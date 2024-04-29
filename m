Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 475637FD
	for <kvmarm@lists.linux.dev>; Mon, 29 Apr 2024 02:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714357404; cv=none; b=rMq/B5u1LPn14hHFQ8WWS6w7zAzKN7TmwAbOjo2sAzBfbv5adDQdAvHnfkWSptp2tqaCF/23Tbk+EwnVic0klxiE0QkR5IriiWc9K2Dj/GPysloERr/mBa4MESEnjHQYFStwqHCrVjKme1DHeGrFynam3PijNLGKtyk0phxoOu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714357404; c=relaxed/simple;
	bh=FscvFKLev/pbFhBKOoUhHWN2J3QCiz+0dzat4SNZspg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IuCBeml5V9KG6yiOromtwaJgRCyX/G3Y5xXx3ldPdGPW87xnM8XRRVruVyTUqTW27spYdPJDP9aLQlQ7b0aUoEZnDA22z74uhEjNDppdQauzFgqgaMalNoSKDAnUMydc/Me4YrxNdjAhi7unB5X9rWAP3iXuDgX3lnVD+2T6YqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6C812F4;
	Sun, 28 Apr 2024 19:23:47 -0700 (PDT)
Received: from [10.162.42.72] (a077893.blr.arm.com [10.162.42.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF2BF3F73F;
	Sun, 28 Apr 2024 19:23:17 -0700 (PDT)
Message-ID: <ab6466f2-023e-4b5f-bb60-aadb9eee089a@arm.com>
Date: Mon, 29 Apr 2024 07:53:14 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: arm64: Replace custom macros with fields from
 ID_AA64PFR0_EL1
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>
References: <20240418053804.2573071-1-anshuman.khandual@arm.com>
 <20240418053804.2573071-2-anshuman.khandual@arm.com>
 <871q73rufi.wl-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <871q73rufi.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/18/24 13:09, Marc Zyngier wrote:
> + Fuad
> 
> On Thu, 18 Apr 2024 06:38:03 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> This replaces custom macros usage (i.e ID_AA64PFR0_EL1_ELx_64BIT_ONLY and
>> ID_AA64PFR0_EL1_ELx_32BIT_64BIT) and instead directly uses register fields
>> from ID_AA64PFR0_EL1 sysreg definition.
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.linux.dev
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 8 ++++----
>>  arch/arm64/kvm/hyp/nvhe/pkvm.c                 | 4 ++--
>>  arch/arm64/kvm/hyp/nvhe/sys_regs.c             | 2 +-
>>  3 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
>> index 51f043649146..0034bfffced6 100644
>> --- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
>> +++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
>> @@ -52,10 +52,10 @@
>>   *	Supported by KVM
>>   */
>>  #define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
>> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
>> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
>> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
>> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
>> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_EL0_IMP) | \
>> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_EL1_IMP) | \
>> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_EL2_IMP) | \
>> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_EL3_IMP) | \
> 
> If you are going to rework this, can we instead use something less
> verbose such as SYS_FIELD_GET()?

Just wondering, is not FIELD_PREP() and SYS_FIELD_GET() does the exact opposite thing.
The earlier builds the entire register value from various constituents, where as the
later extracts a single register field from a complete register value instead. Or did
I just misunderstood something here.

> 
> There is also a series from Fuad moving things around, and maybe
> that's the opportunity to rework this while limiting the amount of
> cosmetic churn. Not to that this fixed config stuff needs to be

I guess that might be a better place to change the code instead. Because this series
just replaces the derived register field from tools syreg, but will be happy to have
those changes here as well in a separate pre/post patch.

> reworked in order to match the runtime feature enforcement that the
> rest of KVM has adopted.

I am afraid, did not get the above. Could you please give some more details.
