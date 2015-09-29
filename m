From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: Re: [PATCH v4 10/15] KVM: arm: implement world switch for debug registers
Date: Tue, 29 Sep 2015 13:32:35 +0800
Message-ID: <560A2273.6050207@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org> <1439213167-8988-11-git-send-email-zhichao.huang@linaro.org> <20150902145327.GL10991@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150902145327.GL10991@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/9/2 22:53, Christoffer Dall wrote:
>> +/* Reads cp14 registers from hardware.
>> + * Writes cp14 registers in-order to the CP14 struct pointed to by r10
>> + *
>> + * Assumes vcpu pointer in vcpu reg
>> + *
>> + * Clobbers r2-r12
>> + */
>> +.macro save_debug_state
>> +	read_hw_dbg_num
>> +	cp14_read_and_str r10, 4, cp14_DBGBVR0, r11
>> +	cp14_read_and_str r10, 5, cp14_DBGBCR0, r11
>> +	cp14_read_and_str r10, 6, cp14_DBGWVR0, r12
>> +	cp14_read_and_str r10, 7, cp14_DBGWCR0, r12
>> +
>> +	/* DBGDSCR reg */
>> +	mrc	p14, 0, r2, c0, c1, 0
>> +	str	r2, [r10, #CP14_OFFSET(cp14_DBGDSCRext)]
> 
> so again we're touching the scary register on every world-switch.  Since
> it sounds like we have experience telling us that this can cause
> troubles, I'm wondering if we can get around it by:
> 
> Only ever allow the guest to use debugging registers if we managed to
> enter_monitor_mode on the host, and in that case only allow guest
> debugging with the configuration of DBGDSCR that the host has.
> 
> If the host never managed to enable debugging, the guest probably won't
> succeed either, and we should just trap all guest accesses to the debug
> registers.
> 
> Does this work?
> 

I think it works. Since the register is dangerous, we will try not to
world switch it. It means that the guest will not be able to write the register,
and will always see what the host set. So the guest will not be able to use
hardware debug feature if the host disable it.

> 
> -Christoffer
> 
