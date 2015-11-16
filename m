From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 15/21] arm64: KVM: Add panic handling
Date: Mon, 16 Nov 2015 14:44:17 +0000
Message-ID: <5649EBC1.6030502@arm.com>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
 <1447679519-17888-16-git-send-email-marc.zyngier@arm.com>
 <20151116141629.GH20696@leverpostej> <5649E7A0.3050109@arm.com>
 <20151116143224.GK20696@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 263D349958
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 09:43:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C6DH1n5cXp-o for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 09:43:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAE5B49954
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 09:43:51 -0500 (EST)
In-Reply-To: <20151116143224.GK20696@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 16/11/15 14:32, Mark Rutland wrote:
>>>> +	/* Call panic for real */
>>>> +	while (1) {
>>>> +		unsigned long str_va = (unsigned long)__hyp_panic_string;
>>>> +
>>>> +		str_va -= HYP_PAGE_OFFSET;
>>>> +		str_va += PAGE_OFFSET;
>>>> +		__hyp_do_panic(str_va,
>>>> +			       spsr,  elr,
>>>> +			       read_sysreg(esr_el2),   read_sysreg(far_el2),
>>>> +			       read_sysreg(hpfar_el2), par,
>>>> +			       read_sysreg(tpidr_el2));
>>>> +	}
>>>> +}
>>>
>>> I think the while (1) here is confusing.
>>>
>>> Can we not jsut declare str_va at the start of the function and get rid
>>> of the loop?
>>
>> The while(1) is to prevent GCC from screaming (it otherwise believes
>> that the function actually returns, despite the __noreturn attribute).
> 
> Aha!
> 
> Perhaps a comment to that effect...?
> 
>> Or were you thinking of something else?
> 
> I just failed to derive the __noreturn problem from first principles.
> 
> Perhaps follow the __hyp_do_panic() call with an unreachable(), with the
> comment as to GCC failing to reason about the __noreturn? That would be
> less confusing than the loop, assuming that it works.

Worth giving it a try.

	M.
-- 
Jazz is not dead. It just smells funny...
