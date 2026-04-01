Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3C854739
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 02:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775009941; cv=none; b=OtdAsffjSHV7ukWeStQt/rnqzs4aai4XIfWDzH/ROCLsZiZWBarJh/Ues+KNbC0NYc6VdB2KbZGiy1/KbBx+N5cW/o21DQR1AJVUSybQE7tBijhwmzsO0tgqpjbyMvXr20StGawl2F89BlHlNviIgxF2jkW035x7v+OloJXfYyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775009941; c=relaxed/simple;
	bh=OAYHliIlM+bHFdWsU9AAJuB9TaySU2rcmCJ1sAPfzcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qd95jiRo1GnXhjUPGI88GdGnAoPzZB5D7yRbt6E9gH6GlpDUOzDTJJ8H9NuLiryb4h/Hcs0FoJZsQBeOv34Wq/I5Ften2DgBLesjvGi9Uls8JBt59OI13vGh4lTakxMtRqQNivQvSMknSh1Z4IjIdelEtyZ+2MYq/W1EzbeE9E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kEaO0BkH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kEaO0BkH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B14C3161;
	Tue, 31 Mar 2026 19:18:46 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26B7B3F7D8;
	Tue, 31 Mar 2026 19:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775009932; bh=OAYHliIlM+bHFdWsU9AAJuB9TaySU2rcmCJ1sAPfzcs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kEaO0BkH5h6mtyaUhm0lermJN5ONxSpVxxPfEr2vd+1uHxyeVJu3GRkBBxv5X4hYQ
	 8z0e2XYlHPjjv/0gCxrEU4R8EcFjHqgv3TS9QRPNlBvYqzjxpZBl3UjNaxYDvi/gZf
	 SBq6sZiMoqttAH5a2gyapB8uPgMlnqU08Zyev6e8=
Message-ID: <7694e707-9249-40ee-a053-404bc3e1b734@arm.com>
Date: Wed, 1 Apr 2026 07:48:46 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/30] KVM: arm64: Hoist MTE validation check out of
 MMU lock path
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-13-maz@kernel.org>
 <8bd2b649-01b5-44f4-a034-c202e226e97c@arm.com> <865x6b4zwh.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <865x6b4zwh.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 31/03/26 11:58 PM, Marc Zyngier wrote:
> On Tue, 31 Mar 2026 07:57:48 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> On 27/03/26 5:06 PM, Marc Zyngier wrote:
>>> From: Fuad Tabba <tabba@google.com>
>>>
>>> Simplify the non-cacheable attributes assignment by using a ternary
>>> operator. Additionally, hoist the MTE validation check (mte_allowed) out
>>> of kvm_s2_fault_map() and into kvm_s2_fault_compute_prot(). This allows
>>> us to fail faster and avoid acquiring the KVM MMU lock unnecessarily
>>> when the VMM introduces a disallowed VMA for an MTE-enabled guest.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/kvm/mmu.c | 28 ++++++++++++----------------
>>>  1 file changed, 12 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 0c71e3a9af8b0..ee2a548999b1b 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1870,18 +1870,21 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
>>>  	if (fault->exec_fault)
>>>  		fault->prot |= KVM_PGTABLE_PROT_X;
>>>  
>>> -	if (fault->s2_force_noncacheable) {
>>> -		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
>>> -			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
>>> -		else
>>> -			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
>>> -	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
>>> +	if (fault->s2_force_noncacheable)
>>> +		fault->prot |= (fault->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
>>> +			       KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
>>> +	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
>>>  		fault->prot |= KVM_PGTABLE_PROT_X;
>>> -	}
>>
>> Is not the existing code block bit more cleaner though ?
> 
> What is wrong with this? Are you stating a matter of personal taste ?
> > Ternary operators are great at making things more readable by reducing
> the amount of nesting, and I'm all in favour of anything that makes
> this $%^&*( code easier to parse.
> 
> Or are you pointing out a technical issue?

There is no technical issue here. Just that the existing code block
appeared bit easier to read but as you mentioned earlier that is
probably subjective. Never mind and please feel free to ignore this
comment.
