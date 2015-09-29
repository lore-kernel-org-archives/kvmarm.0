From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: Re: [PATCH v4 01/15] KVM: arm: plug guest debug exploit
Date: Tue, 29 Sep 2015 13:13:01 +0800
Message-ID: <560A1DDD.1060100@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org> <1439213167-8988-2-git-send-email-zhichao.huang@linaro.org> <20150902113804.GJ10991@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150902113804.GJ10991@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/9/2 19:38, Christoffer Dall wrote:
> 
> I really think that we should read the register, clear the bits you care
> about (MDBGen and HDBGen) and then write back the register.
> 
> So, if I recall correctly, this is to avoid having to set HDCR_TDE
> below?
> 
> Given Will's concerns about touching this register, I'm thinking if we
> shouldn't start with the HDCR_TDE enabled (and a handler in KVM) and
> then see if we want to add this optimization later?
> 
> At the very least, you should do as Will pointed out and predicate
> writes to this register based on whether the reset code in
> hw_breakpoint.c successfully reset the debug regs.  I think checking the
> debug_err_mask variable from the C code and pass this on to the Hyp code
> would be the right way to go.
> 
> But as I said, I think we should just trap debug exceptions to begin
> with (to plug the hole) and then add the more intelligent stuff later.
> 

OK, I will set HDCR_TDE, and ignore all the debug exceptions in
KVM handlers to prevent the guest to mess with the host states.

>> +	.endif
>> +
>> +	mcr	p14, 0, r2, c0, c2, 2	@ DBGDSCR
>>  .endm
>>  
>>  /*
>> @@ -620,7 +633,7 @@ ARM_BE8(rev	r6, r6  )
>>   * (hardware reset value is 0) */
>>  .macro set_hdcr operation
>>  	mrc	p15, 4, r2, c1, c1, 1
>> -	ldr	r3, =(HDCR_TPM|HDCR_TPMCR)
>> +	ldr	r3, =(HDCR_TPM|HDCR_TPMCR|HDCR_TDRA|HDCR_TDOSA|HDCR_TDA)
> 
> 
> 
>>  	.if \operation == vmentry
>>  	orr	r2, r2, r3		@ Trap some perfmon accesses
>>  	.else
>> -- 
>> 1.7.12.4
>>
> 
> Thanks,
> -Christoffer
> 
