From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 20/21] arm64: VHE: Add support for running Linux in EL2
 mode
Date: Tue, 26 Jan 2016 14:30:13 +0000
Message-ID: <56A782F5.1010109@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-21-git-send-email-marc.zyngier@arm.com>
 <56A77D0B.50002@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56A77D0B.50002@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 26/01/16 14:04, Suzuki K. Poulose wrote:
> On 25/01/16 15:53, Marc Zyngier wrote:
>> With ARMv8.1 VHE, the architecture is able to (almost) transparently
>> run the kernel at EL2, despite being written for EL1.
>>
>> This patch takes care of the "almost" part, mostly preventing the kernel
>> from dropping from EL2 to EL1, and setting up the HYP configuration.
>
>>   #ifdef CONFIG_COMPAT
>> @@ -521,6 +542,15 @@ CPU_LE(    movk    x0, #0x30d0, lsl #16    )    // Clear EE and E0E on LE systems
>>       /* Stage-2 translation */
>>       msr    vttbr_el2, xzr
>>
>> +    cbz    x2, install_el2_stub
>
> Though it is apparent, may be its worth adding a comment here that we don't drop to EL1 here ?
>
>> +
>> +    setup_vtcr x4, x5
>> +
>> +    mov    w20, #BOOT_CPU_MODE_EL2        // This CPU booted in EL2
>> +    isb
>> +    ret
>
>> +
>> +install_el2_stub:
>
> And a comment here mentioning, install the hyp stub and drops to EL1 ?

Also, the comments around el2_setup invocation still says, Drop to EL1 which may
need to be updated.

Cheers
Suzuki
