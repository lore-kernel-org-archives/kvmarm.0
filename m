Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AEB2C17AE
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 14:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745935803; cv=none; b=AJot1dJ2cNGUuZ0MyiD8XQMEe0/ARXum0k9j/SB3Oh2ZMAEiZBeFTezPDAjSAVwWwa+sPmWC9RnQ3ZCdLta/1/wfsrv64GTnLOGR7b5FiLVsHc9OSWghxJgZXyw/MEGNYgG8gI93nUOBoG4PrJbp02qxmdgVoUNsvEvoJlrS9kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745935803; c=relaxed/simple;
	bh=7ilE6Mulu69YDl0t29ldX0rUe0mYNOb23tG+PTX5YIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oks/gCneL71P5R15FNOPkP9YEuF9gmv0rnOkZAYfDxP4yWaV90gqVmHjDq4ah8jOkNKtAVV7zGSKlLu1gNFhapQfkyhfOZaKA18UDtJryBG4nicFwTQxmo8XeFTENk7EmdyXFq6aTkerW9CMUWaIuRp3WeLu/NvvwnU20OOkxHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00A291515;
	Tue, 29 Apr 2025 07:09:51 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5E293F66E;
	Tue, 29 Apr 2025 07:09:55 -0700 (PDT)
Message-ID: <69211539-5ffa-45ad-bd19-25e8bcd6eccc@arm.com>
Date: Tue, 29 Apr 2025 15:09:54 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 24/42] KVM: arm64: Unconditionally configure fine-grain
 traps
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-25-maz@kernel.org>
 <363383a2-c05e-458c-82b7-acc6e5d73939@arm.com> <86h627hyby.wl-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <86h627hyby.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 14:49, Marc Zyngier wrote:
> On Tue, 29 Apr 2025 14:08:27 +0100,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>>    -	__deactivate_fgt(hctxt, vcpu, kvm, HFGRTR_EL2);
>>> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>> Don't we need to continue considering the ampere errata here? Or, at
>> least worth a mention in the commit message.
> 
> The FGT registers are always context switched, so whatever was saved
> *before* the workaround was applied in __activate_traps_hfgxtr() is
> blindly restored...
> 
>>> -		write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
> 
> ... and this write always happens.
Thanks for the explanation. I now agree this code is correct.
> 
> 	M.
> 

Thanks,

Ben

