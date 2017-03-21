From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 01/25] arm64: hyp-stub: Implement HVC_RESET_VECTORS
 stub hypercall
Date: Tue, 21 Mar 2017 17:41:54 +0000
Message-ID: <58D165E2.7050501@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
 <20170306142458.8875-2-marc.zyngier@arm.com>
 <20170321170407.GD21829@e104818-lin.cambridge.arm.com>
 <58D1620E.30001@arm.com> <0cce34c1-cb6f-0ba3-ac98-c0a0e986dc86@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79DE240A14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 13:40:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LJD-2WAHPi5J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 13:40:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8169040C07
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 13:40:25 -0400 (EDT)
In-Reply-To: <0cce34c1-cb6f-0ba3-ac98-c0a0e986dc86@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: cdall@linaro.org, Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 17:37, Marc Zyngier wrote:
> On 21/03/17 17:25, James Morse wrote:
>> On 21/03/17 17:04, Catalin Marinas wrote:
>>> On Mon, Mar 06, 2017 at 02:24:34PM +0000, Marc Zyngier wrote:
>>>> Let's define a new stub hypercall that resets the HYP configuration
>>>> to its default: hyp-stub vectors, and MMU disabled.
>>>>
>>>> Of course, for the hyp-stub itself, this is a trivial no-op.
>>>> Hypervisors will have a bit more work to do.
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  arch/arm64/include/asm/virt.h |  9 +++++++++
>>>>  arch/arm64/kernel/hyp-stub.S  | 13 ++++++++++++-
>>>>  2 files changed, 21 insertions(+), 1 deletion(-)
>>> [...]
>>>> +ENTRY(__hyp_reset_vectors)
>>>> +	str	lr, [sp, #-16]!
>>>> +	mov	x0, #HVC_RESET_VECTORS
>>>> +	hvc	#0
>>>> +	ldr	lr, [sp], #16
>>>> +	ret
>>>> +ENDPROC(__hyp_reset_vectors)
>>>
>>> Why do we need to specifically preserve lr across the hvc call? Is it
>>> corrupted by the EL2 code (if yes, are other caller-saved registers that
>>> need preserving)? I don't see something similar in the arch/arm code.
>>
>> Kexec on arm64 needed a register to clobber in the hyp-stub's el1_sync code. We
>> wanted to preserve all the registers so soft_restart() could look more like a
>> function call.
> 
> I don't think we need this anymore. Once we enter __cpu_soft_restart(),
> there is no turning back. Or am I missing something else?

My recollection of the history may be wrong: but we needed to mess with esr_el2
before we know its a soft_restart() call, at which point we didn't want to
clobber the registers. This was the strange use of x18 in kexec.


James
