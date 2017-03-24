From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 19/28] ARM: KVM: Allow the main HYP code to use the
 init hyp stub implementation
Date: Fri, 24 Mar 2017 15:01:23 +0000
Message-ID: <00380529-bee2-ba10-548d-319bc4fa5c1b@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-20-marc.zyngier@arm.com> <20170324143432.GD25903@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170324143432.GD25903@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 24/03/17 14:34, Christoffer Dall wrote:
> On Tue, Mar 21, 2017 at 07:20:49PM +0000, Marc Zyngier wrote:
>> We now have a full hyp-stub implementation in the KVM init code,
>> but the main KVM code only supports HVC_GET_VECTORS, which is not
>> enough.
>>
>> Instead of reinventing the wheel, let's reuse the init implementation
>> by branching to the idmap page when called with a hyp-stub hypercall.
>>
>> Tested-by: Keerthy <j-keerthy@ti.com>
>> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/kvm/hyp/hyp-entry.S | 29 ++++++++++++++++++++++++-----
>>  1 file changed, 24 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
>> index 1f8db7d21fc5..a35baa81fd23 100644
>> --- a/arch/arm/kvm/hyp/hyp-entry.S
>> +++ b/arch/arm/kvm/hyp/hyp-entry.S
>> @@ -126,11 +126,30 @@ hyp_hvc:
>>  	 */
>>  	pop	{r0, r1, r2}
>>  
>> -	/* Check for __hyp_get_vectors */
>> -	cmp	r0, #HVC_GET_VECTORS
>> -	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
>> -	beq	1f
>> +	/*
>> +	 * Check if we have a kernel function, which is guaranteed to be
>> +	 * bigger than the maximum hyp stub hypercall
>> +	 */
>> +	cmp	r0, #HVC_STUB_HCALL_NR
>> +	bhs	1f
>>  
>> +	/*
>> +	 * Not a kernel function, treat it as a stub hypercall.
>> +	 * Compute the physical address for __kvm_handle_stub_hvc
>> +	 * (as the code lives in the idmaped page) and branch there.
>> +	 * We hijack ip (r12) as a tmp register.
>> +	 */
> 
> How can we just clobber r12 and be sure we don't corrupt the caller?

r12 (aka ip) is allowed to be clobbered by the linker (used by inserted
code veneers, for example). Given that this is a standalone object, we
can safely assume that r12 has been saved if it was used by the caller.

Here is what the PCS says:

"Register r12 (IP) may be used by a linker as a scratch register between
a routine and any subroutine it calls (for details, see
§5.3.1.1, Use of IP by the linker). It can also be used within a routine
to hold intermediate values between subroutine calls."

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
