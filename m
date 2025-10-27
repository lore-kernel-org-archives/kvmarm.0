Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FF02367D3
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 01:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761527653; cv=none; b=EU94jgN6X2fcR6G4GiaP3UJboxS/Ppg13EAClOKd5TWtHTgxG8VZmhnB5S9JHEWpK89TF4A+SA6iiOpu60lfNlNmsfE8VpXqKosqkDKRYSAvn/RJFboECdhkhsXPbBIaxHyw2f51T8Xhs2SuvN9yN36di+EwGL4thdcqRWMnP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761527653; c=relaxed/simple;
	bh=9ZDNs8sqkigD3yuqMV8N34wMSfxo33xTGPQNY/sykRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VJxqwFMN1bAprMoKWZxZ8iyp5HAIoWL5/GXc5a2dyeD9QKjZfkGo+RGf9/OQR2V2D0VuFIncF9OBY+2DdwSsFg9+vkhkNBDxShbdppvW6g01zTrePUASFdZdDR89A0DaaDo9bbE9bU7bUjNgfaTzaXLzNK9ZdM7jMglaEXFhtgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A346113E;
	Sun, 26 Oct 2025 18:14:03 -0700 (PDT)
Received: from [10.163.70.164] (unknown [10.163.70.164])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 86CEA3F673;
	Sun, 26 Oct 2025 18:14:08 -0700 (PDT)
Message-ID: <d4d2086b-8fd1-4e52-8e5d-24b2447335f7@arm.com>
Date: Mon, 27 Oct 2025 06:44:05 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] arm64/mm: Add remaining TLBI_XXX_MASK macros
To: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
References: <20251024040207.137480-1-anshuman.khandual@arm.com>
 <20251024040207.137480-3-anshuman.khandual@arm.com>
 <95ee2490-6904-4a24-93db-411c489bd2b4@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <95ee2490-6904-4a24-93db-411c489bd2b4@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/10/25 2:26 PM, Ben Horgan wrote:
> Hi Anshuman,
> 
> On 10/24/25 05:02, Anshuman Khandual wrote:
>> Add remaining TLBI_XXX_MASK macros and replace current open encoded fields.
>> While here replace hard coded page size based shifts but with derived ones
>> via ilog2() thus adding some required context.
>>
>> TLBI_TTL_MASK has been split into separate TLBI_TTL_MASK and TLBI_TG_MASK
>> as appropriate because currently it simultaneously contains both page size
>> and translation table level information. KVM on arm64 has been updated to
>> accommodate these changes to TLBI_TTL_MASK.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kvmarm@lists.linux.dev
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/tlbflush.h | 26 ++++++++++++++++++--------
>>  arch/arm64/kvm/nested.c           |  8 +++++---
>>  2 files changed, 23 insertions(+), 11 deletions(-)
>>
> The code looks correct to me, no functional changes. I however, don't
> have any experience with this code and so don't know whether the split
> of TTL into TG and TTL is a good idea or not and if the kvm naming is

TLBI_TTL field contains both encoded page size and also page table
level information. This split in the mask makes the code much clear
and explicit.
> best to stay the same or be updated to match this.
This proposed patch keeps the KVM code churn to the minimum while
also adapting to the mask split as necessary. But further changes
to KVM if required can be done subsequently later.
