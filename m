From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 7/9] arm64: KVM: Do not corrupt registers on failed
 64bit CP read
Date: Tue, 28 Mar 2017 14:24:54 +0100
Message-ID: <3a34a883-5c08-3a73-0b4a-f3830e6e8b08@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
 <20170327160345.12402-8-marc.zyngier@arm.com> <20170328124600.GG31156@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4B5840B40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:22:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WbZumZjLpT3K for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 09:22:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20D3C40966
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 09:22:57 -0400 (EDT)
In-Reply-To: <20170328124600.GG31156@cbox>
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
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 28/03/17 13:46, Christoffer Dall wrote:
> On Mon, Mar 27, 2017 at 05:03:43PM +0100, Marc Zyngier wrote:
>> If we fail to emulate a mrrc instruction, we:
>> 1) deliver an exception,
>> 2) spit a nastygram on the console,
>> 3) write back some garbage to Rt/Rt2
>>
>> While 1) and 2) are perfectly acceptable, 3) is out of the scope of
>> the architecture... Let's mimick the code in kvm_handle_cp_32 and
>> be more cautious.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 20 +++++++++-----------
>>  1 file changed, 9 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 4e5d4eee8cec..1080a76e960f 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1678,20 +1678,18 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>>  		params.regval |= vcpu_get_reg(vcpu, Rt2) << 32;
>>  	}
>>  
>> -	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
>> -		goto out;
>> -	if (!emulate_cp(vcpu, &params, global, nr_global))
>> -		goto out;
>> -
>> -	unhandled_cp_access(vcpu, &params);
>> +	if (!emulate_cp(vcpu, &params, target_specific, nr_specific) ||
>> +	    !emulate_cp(vcpu, &params, global, nr_global)) {
> 
> super nit: I choked a bit on this contruct, any objections to adding a
> comment like the following above:
> 
> 	/*
> 	 * Try to emulate the coprocessor access using the target
> 	 * specific table first, and using the global table aftwards.
> 	 * If either of the tables contains a handler, handle the
> 	 * potential register operation in the case of a read and return
> 	 * with success.
> 	 */
> 
> Too much?
> 
> (If not, I can also add this when applying).

No, that's great. Thanks!

	M.
-- 
Jazz is not dead. It just smells funny...
