From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 01/25] arm64: hyp-stub: Implement HVC_RESET_VECTORS
 stub hypercall
Date: Tue, 21 Mar 2017 17:26:06 +0000
Message-ID: <11a10d32-700f-d969-556a-4d1748c2e92f@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
 <20170306142458.8875-2-marc.zyngier@arm.com>
 <20170321170407.GD21829@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AD2A40B5E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 13:24:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxfYFkMTgYpx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 13:24:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F55040A54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 13:24:22 -0400 (EDT)
In-Reply-To: <20170321170407.GD21829@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: cdall@linaro.org, Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 17:04, Catalin Marinas wrote:
> On Mon, Mar 06, 2017 at 02:24:34PM +0000, Marc Zyngier wrote:
>> Let's define a new stub hypercall that resets the HYP configuration
>> to its default: hyp-stub vectors, and MMU disabled.
>>
>> Of course, for the hyp-stub itself, this is a trivial no-op.
>> Hypervisors will have a bit more work to do.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/virt.h |  9 +++++++++
>>  arch/arm64/kernel/hyp-stub.S  | 13 ++++++++++++-
>>  2 files changed, 21 insertions(+), 1 deletion(-)
> [...]
>> +ENTRY(__hyp_reset_vectors)
>> +	str	lr, [sp, #-16]!
>> +	mov	x0, #HVC_RESET_VECTORS
>> +	hvc	#0
>> +	ldr	lr, [sp], #16
>> +	ret
>> +ENDPROC(__hyp_reset_vectors)
> 
> Why do we need to specifically preserve lr across the hvc call? Is it
> corrupted by the EL2 code (if yes, are other caller-saved registers that
> need preserving)? I don't see something similar in the arch/arm code.

Yeah, that's another oddity. The KVM code uses it as a temp register,
but that feels quite wrong, now that you mention it. If should be saved
there, and definitely not in the stubs.

Let me grab a hammer, and I'll set that one straight.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
