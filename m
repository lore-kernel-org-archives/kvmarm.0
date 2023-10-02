Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BF9883E
	for <kvmarm@lists.linux.dev>; Mon,  2 Oct 2023 14:06:47 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18D4CC15;
	Mon,  2 Oct 2023 07:07:25 -0700 (PDT)
Received: from [10.57.66.29] (unknown [10.57.66.29])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E30873F762;
	Mon,  2 Oct 2023 07:06:43 -0700 (PDT)
Message-ID: <0f99fa65-c8c1-5d5c-d9b0-5436b7592656@arm.com>
Date: Mon, 2 Oct 2023 15:06:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 1/2] KVM: arm64: Add handler for MOPS exceptions
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Vladimir Murzin <vladimir.murzin@arm.com>,
 Colton Lewis <coltonlewis@google.com>, linux-kernel@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>
References: <20230922112508.1774352-1-kristina.martsenko@arm.com>
 <20230922112508.1774352-2-kristina.martsenko@arm.com>
 <87sf734ofv.wl-maz@kernel.org> <9f731870-ed36-d2e4-378b-f7fbf338ebd6@arm.com>
 <ZRPnpHwiRhrYwfSM@linux.dev> <87h6ndmixh.wl-maz@kernel.org>
From: Kristina Martsenko <kristina.martsenko@arm.com>
In-Reply-To: <87h6ndmixh.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/09/2023 10:23, Marc Zyngier wrote:
> On Wed, 27 Sep 2023 09:28:20 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
>>
>> On Mon, Sep 25, 2023 at 04:16:06PM +0100, Kristina Martsenko wrote:
>>
>> [...]
>>
>>>> What is the rationale for advancing the state machine? Shouldn't we
>>>> instead return to the guest and immediately get the SS exception,
>>>> which in turn gets reported to userspace? Is it because we rollback
>>>> the PC to a previous instruction?
>>>
>>> Yes, because we rollback the PC to the prologue instruction. We advance the
>>> state machine so that the SS exception is taken immediately upon returning to
>>> the guest at the prologue instruction. If we didn't advance it then we would
>>> return to the guest, execute the prologue instruction, and then take the SS
>>> exception on the middle instruction. Which would be surprising as userspace
>>> would see the middle and epilogue instructions executed multiple times but not
>>> the prologue.
>>
>> I agree with Kristina that taking the SS exception on the prologue is
>> likely the best course of action. Especially since it matches the
>> behavior of single-stepping an EL0 MOPS sequence with an intervening CPU
>> migration.
>>
>> This behavior might throw an EL1 that single-steps itself for a loop,
>> but I think it is impossible for a hypervisor to hide the consequences
>> of vCPU migration with MOPS in the first place.
>>
>> Marc, I'm guessing you were most concerned about the former case where
>> the VMM was debugging the guest. Is there something you're concerned
>> about I missed?
> 
> My concern is not only the VMM, but any userspace that perform
> single-stepping. Imagine the debugger tracks PC by itself, and simply
> increments it by 4 on a non-branch, non-fault instruction.
> 
> Move the vcpu or the userspace around, rewind PC, and now the debugger
> is out of whack with what is executing. While I agree that there is
> not much a hypervisor can do about that, I'm a bit worried that we are
> going to break existing SW with this.
> 
> Now the obvious solution is "don't do that"...

If the debugger can handle the PC changing on branching or faulting
instructions, then why can't it handle it on MOPS instructions? Wouldn't
such a debugger need to be updated any time the architecture adds new
branching or faulting instructions? What's different here?

Confused,
Kristina
