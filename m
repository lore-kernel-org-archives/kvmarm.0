From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 01/25] arm64: hyp-stub: Implement HVC_RESET_VECTORS
 stub hypercall
Date: Tue, 21 Mar 2017 18:36:51 +0000
Message-ID: <8b0b5948-368f-530c-cd64-7b97dbe2312a@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
 <20170306142458.8875-2-marc.zyngier@arm.com>
 <20170321170407.GD21829@e104818-lin.cambridge.arm.com>
 <58D1620E.30001@arm.com> <0cce34c1-cb6f-0ba3-ac98-c0a0e986dc86@arm.com>
 <58D165E2.7050501@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5DE240C2E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:35:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZOmLHSKwa3YB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 14:35:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E1140C22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:35:07 -0400 (EDT)
In-Reply-To: <58D165E2.7050501@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: cdall@linaro.org, Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 17:41, James Morse wrote:
> On 21/03/17 17:37, Marc Zyngier wrote:
>> On 21/03/17 17:25, James Morse wrote:
>>> On 21/03/17 17:04, Catalin Marinas wrote:
>>>> On Mon, Mar 06, 2017 at 02:24:34PM +0000, Marc Zyngier wrote:
>>>>> Let's define a new stub hypercall that resets the HYP configuration
>>>>> to its default: hyp-stub vectors, and MMU disabled.
>>>>>
>>>>> Of course, for the hyp-stub itself, this is a trivial no-op.
>>>>> Hypervisors will have a bit more work to do.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> ---
>>>>>  arch/arm64/include/asm/virt.h |  9 +++++++++
>>>>>  arch/arm64/kernel/hyp-stub.S  | 13 ++++++++++++-
>>>>>  2 files changed, 21 insertions(+), 1 deletion(-)
>>>> [...]
>>>>> +ENTRY(__hyp_reset_vectors)
>>>>> +	str	lr, [sp, #-16]!
>>>>> +	mov	x0, #HVC_RESET_VECTORS
>>>>> +	hvc	#0
>>>>> +	ldr	lr, [sp], #16
>>>>> +	ret
>>>>> +ENDPROC(__hyp_reset_vectors)
>>>>
>>>> Why do we need to specifically preserve lr across the hvc call? Is it
>>>> corrupted by the EL2 code (if yes, are other caller-saved registers that
>>>> need preserving)? I don't see something similar in the arch/arm code.
>>>
>>> Kexec on arm64 needed a register to clobber in the hyp-stub's el1_sync code. We
>>> wanted to preserve all the registers so soft_restart() could look more like a
>>> function call.
>>
>> I don't think we need this anymore. Once we enter __cpu_soft_restart(),
>> there is no turning back. Or am I missing something else?
> 
> My recollection of the history may be wrong: but we needed to mess with esr_el2
> before we know its a soft_restart() call, at which point we didn't want to
> clobber the registers. This was the strange use of x18 in kexec.

After a bit of digging together with James, we found the guilty one.
The hyp-stub entry code uses lr (aka x30) as a scratch register to 
find out if we've made it here via a HVC instruction. This is an 
absolutely pointless test, because by definition HVC is the only way to 
get there.

I've ended up with the following patch:

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 8ccdd549f7c7..210bd6b3849d 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -55,12 +55,6 @@ ENDPROC(__hyp_stub_vectors)
 	.align 11
 
 el1_sync:
-	mrs	x30, esr_el2
-	lsr	x30, x30, #ESR_ELx_EC_SHIFT
-
-	cmp	x30, #ESR_ELx_EC_HVC64
-	b.ne	9f				// Not an HVC trap
-
 	cmp	x0, #HVC_SET_VECTORS
 	b.ne	2f
 	msr	vbar_el2, x1
@@ -120,18 +114,14 @@ ENDPROC(\label)
  */
 
 ENTRY(__hyp_set_vectors)
-	str	lr, [sp, #-16]!
 	mov	x1, x0
 	mov	x0, #HVC_SET_VECTORS
 	hvc	#0
-	ldr	lr, [sp], #16
 	ret
 ENDPROC(__hyp_set_vectors)
 
 ENTRY(__hyp_reset_vectors)
-	str	lr, [sp, #-16]!
 	mov	x0, #HVC_RESET_VECTORS
 	hvc	#0
-	ldr	lr, [sp], #16
 	ret
 ENDPROC(__hyp_reset_vectors)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 1277f81b63b7..5170ce1021da 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -32,17 +32,17 @@
 	 * Shuffle the parameters before calling the function
 	 * pointed to in x0. Assumes parameters in x[1,2,3].
 	 */
+	str	lr, [sp, #-16]!
 	mov	lr, x0
 	mov	x0, x1
 	mov	x1, x2
 	mov	x2, x3
 	blr	lr
+	ldr	lr, [sp], #16
 .endm
 
 ENTRY(__vhe_hyp_call)
-	str	lr, [sp, #-16]!
 	do_el2_call
-	ldr	lr, [sp], #16
 	/*
 	 * We used to rely on having an exception return to get
 	 * an implicit isb. In the E2H case, we don't have it anymore.

I'll split that in convenient patches and repost the series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
