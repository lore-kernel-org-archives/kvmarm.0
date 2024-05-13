Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CE814600F
	for <kvmarm@lists.linux.dev>; Mon, 13 May 2024 05:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715578136; cv=none; b=AXsce7wfadxhu+cTCqXZz0FVKlEyfto3zcPkV04WlZknCMQXLvFvrqcEqhz8fJvvZ7PxK/WTPi53fDktRcB0EDpZLxIdEsYbZtUn9qrScFoAX7g/4vCXUHEAn8M8/wthTrW+0vTSRReHsIvdsvIJL+9HrcXz0SSQHMAnSLIe75Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715578136; c=relaxed/simple;
	bh=VLqQIw9DxsfdiVNjqe2D3rzPWsmGB7eOKlY0suFaJa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cnBxROaW+hy73dLbNW3+RNM0NpaTFUDoLvGPX1f0se2t+tBm87Z1Pjsh604abddqbBz0dQRtqGanN3l+xLipXP+X/gXTZ48YiU+yMKRpiDPbI9a8MKEw5IeMLfdTh+G+3ltx2Z5VwVcjXQ4QX+2HYHrD66KbjTbj2IwFEELcfnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA4871007;
	Sun, 12 May 2024 22:29:13 -0700 (PDT)
Received: from [10.163.38.21] (unknown [10.163.38.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 254D13F762;
	Sun, 12 May 2024 22:28:44 -0700 (PDT)
Message-ID: <d571fb6c-a497-4710-bf10-0efb6a1d21fb@arm.com>
Date: Mon, 13 May 2024 10:58:53 +0530
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
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
References: <20240418053804.2573071-1-anshuman.khandual@arm.com>
 <20240418053804.2573071-2-anshuman.khandual@arm.com>
 <871q73rufi.wl-maz@kernel.org> <ab6466f2-023e-4b5f-bb60-aadb9eee089a@arm.com>
 <Zj5i2x8Sh95YIfeq@J2N7QTR9R3>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <Zj5i2x8Sh95YIfeq@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/10/24 23:39, Mark Rutland wrote:
> On Mon, Apr 29, 2024 at 07:53:14AM +0530, Anshuman Khandual wrote:
>> On 4/18/24 13:09, Marc Zyngier wrote:
>>> On Thu, 18 Apr 2024 06:38:03 +0100,
>>> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>>>  #define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
>>>> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
>>>> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
>>>> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
>>>> -	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
>>>> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_EL0_IMP) | \
>>>> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_EL1_IMP) | \
>>>> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_EL2_IMP) | \
>>>> +	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_EL3_IMP) | \
>>>
>>> If you are going to rework this, can we instead use something less
>>> verbose such as SYS_FIELD_GET()?
>>
>> Just wondering, is not FIELD_PREP() and SYS_FIELD_GET() does the exact opposite thing.
>> The earlier builds the entire register value from various constituents, where as the
>> later extracts a single register field from a complete register value instead. Or did
>> I just misunderstood something here.
>  
> He means use one of the SYS_FIELD_*() helpers, e.g. SYS_FIELD_PREP_ENUM(), with
> which this can be:
> 
> #define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
>         SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL0, IMP) | \
>         SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL1, IMP) | \
>         SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL2, IMP) | \
>         SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, EL3, IMP) | \
>         SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, RAS, IMP) \
>         )
> 
> ... which is far less verbose, and much easier to read.

Got it, this makes sense, will fold in the above changes and respin
after the merge window. Thanks for the clarification.
