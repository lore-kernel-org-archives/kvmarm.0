From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 10/21] arm64: entry.S: move SError handling into a
 C function for future expansion
Date: Wed, 03 Jan 2018 16:00:55 +0000
Message-ID: <5A4CFE37.3010002@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-11-james.morse@arm.com>
 <b99e7738-f8dd-26bf-a050-f970c2f8d03b@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E98AF49D14
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jan 2018 10:58:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8RZ6lwFHzpca for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jan 2018 10:58:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAC8E406D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jan 2018 10:58:43 -0500 (EST)
In-Reply-To: <b99e7738-f8dd-26bf-a050-f970c2f8d03b@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Adam Wallis <awallis@codeaurora.org>
Cc: Jonathan.Zhang@cavium.com, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, Wang Xiongfeng <wangxiongfengi2@huawei.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Adam,

On 02/01/18 21:07, Adam Wallis wrote:
> On 10/19/2017 10:57 AM, James Morse wrote:
> [..]
>>  	kernel_ventry	el1_fiq_invalid			// FIQ EL1h
>> -	kernel_ventry	el1_error_invalid		// Error EL1h
>> +	kernel_ventry	el1_error			// Error EL1h

>>  	kernel_ventry	el0_sync			// Synchronous 64-bit EL0
>>  	kernel_ventry	el0_irq				// IRQ 64-bit EL0
>>  	kernel_ventry	el0_fiq_invalid			// FIQ 64-bit EL0
>> -	kernel_ventry	el0_error_invalid		// Error 64-bit EL0
>> +	kernel_ventry	el0_error			// Error 64-bit EL0
>>  
>>  #ifdef CONFIG_COMPAT
>>  	kernel_ventry	el0_sync_compat			// Synchronous 32-bit EL0
>>  	kernel_ventry	el0_irq_compat			// IRQ 32-bit EL0
>>  	kernel_ventry	el0_fiq_invalid_compat		// FIQ 32-bit EL0
>> -	kernel_ventry	el0_error_invalid_compat	// Error 32-bit EL0
>> +	kernel_ventry	el0_error_compat		// Error 32-bit EL0
>>  #else
>>  	kernel_ventry	el0_sync_invalid		// Synchronous 32-bit EL0
>>  	kernel_ventry	el0_irq_invalid			// IRQ 32-bit EL0
>> @@ -455,10 +455,6 @@ ENDPROC(el0_error_invalid)
>>  el0_fiq_invalid_compat:
>>  	inv_entry 0, BAD_FIQ, 32
>>  ENDPROC(el0_fiq_invalid_compat)
>> -
>> -el0_error_invalid_compat:
>> -	inv_entry 0, BAD_ERROR, 32
>> -ENDPROC(el0_error_invalid_compat)
>>  #endif

> Perhaps I missed something quite obvious, but is there any reason to not also
> remove el1_error_invalid, since SError handling now jumps to el1_error?

There is still a caller for el1_error_invalid: depending on SPSel we are in
thread or handler mode, which causes exceptions to use a different entry in the
vectors. The kernel always uses handler mode, all the thread mode entries point
at their '_invalid' versions.

If we take an SError from EL1t, SPsel==0 then it uses vectors+0x180. (just cut
off the top of this diff). The el1_error change above is for EL1h, SPsel==1,
which uses vectors+0x380.


Thanks for taking a look!

James
