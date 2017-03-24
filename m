From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 05/28] arm64: KVM: Implement HVC_RESET_VECTORS stub
 hypercall in the init code
Date: Fri, 24 Mar 2017 14:45:24 +0000
Message-ID: <f2c1bc8a-4108-1540-29b4-535ea5ac428e@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-6-marc.zyngier@arm.com> <20170324143350.GB25903@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D3C240BBB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 10:43:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aU5-yuBemkJM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 10:43:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A80340A69
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 10:43:35 -0400 (EDT)
In-Reply-To: <20170324143350.GB25903@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 24/03/17 14:33, Christoffer Dall wrote:
> On Tue, Mar 21, 2017 at 07:20:35PM +0000, Marc Zyngier wrote:
>> In order to restore HYP mode to its original condition, KVM currently
>> implements __kvm_hyp_reset(). As we're moving towards a hyp-stub
>> defined API, it becomes necessary to implement HVC_RESET_VECTORS.
>>
>> This patch adds the HVC_RESET_VECTORS hypercall to the KVM init
>> code, which so far lacked any form of hypercall support.
>>
>> Reviewed-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp-init.S | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
>> index 6b29d3d9e1f2..6cf98ccd10f2 100644
>> --- a/arch/arm64/kvm/hyp-init.S
>> +++ b/arch/arm64/kvm/hyp-init.S
>> @@ -22,6 +22,7 @@
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/pgtable-hwdef.h>
>>  #include <asm/sysreg.h>
>> +#include <asm/virt.h>
>>  
>>  	.text
>>  	.pushsection	.hyp.idmap.text, "ax"
>> @@ -58,6 +59,9 @@ __invalid:
>>  	 * x2: HYP vectors
>>  	 */
>>  __do_hyp_init:
>> +	/* Check for a stub HVC call */
>> +	cmp	x0, #HVC_STUB_HCALL_NR
>> +	b.lo	__kvm_handle_stub_hvc
>>  
>>  	msr	ttbr0_el2, x0
>>  
>> @@ -119,6 +123,9 @@ __do_hyp_init:
>>  	eret
>>  ENDPROC(__kvm_hyp_init)
>>  
>> +ENTRY(__kvm_handle_stub_hvc)
>> +	cmp	x0, #HVC_RESET_VECTORS
>> +	b.ne	1f
>>  	/*
>>  	 * Reset kvm back to the hyp stub.
>>  	 */
>> @@ -133,9 +140,14 @@ ENTRY(__kvm_hyp_reset)
>>  	/* Install stub vectors */
>>  	adr_l	x0, __hyp_stub_vectors
>>  	msr	vbar_el2, x0
>> +	b	exit
>>  
>> +1:	mov	x0, #-1
> 
> nit: do we have the -1 return value documented somewhere and should we
> define it as HVC_SUB_ERR_RETURN or something like that?

Indeed, this is something that is a bit dodgy. arm64 returns
ARM_EXCEPTION_HYP_GONE, which is really a KVM exception code (and isn't
-1 either). I'll try to tighten this up a bit.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
