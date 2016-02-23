From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v12 03/21] KVM: ARM64: Add offset defines for PMU registers
Date: Tue, 23 Feb 2016 09:46:46 +0800
Message-ID: <56CBBA06.4040902@huawei.com>
References: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
 <1456133877-9584-4-git-send-email-zhaoshenglong@huawei.com>
 <56CB4A98.2020403@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA16F41E71
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2016 20:44:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wt0i3335HXJw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2016 20:44:51 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF725412F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2016 20:44:50 -0500 (EST)
In-Reply-To: <56CB4A98.2020403@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/23 1:51, Marc Zyngier wrote:
> On 22/02/16 09:37, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> We are about to trap and emulate accesses to each PMU register
>> individually. This adds the context offsets for the AArch64 PMU
>> registers.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> ---
>>  arch/arm64/include/asm/kvm_host.h | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 6f0241f..6bab7fb 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -115,6 +115,21 @@ enum vcpu_sysreg {
>>  	MDSCR_EL1,	/* Monitor Debug System Control Register */
>>  	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
>>  
>> +	/* Performance Monitors Registers */
>> +	PMCR_EL0,	/* Control Register */
>> +	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
>> +	PMSELR_EL0,	/* Event Counter Selection Register */
>> +	PMEVCNTR0_EL0,	/* Event Counter Register (0-30) */
>> +	PMEVCNTR30_EL0 = PMEVCNTR0_EL0 + 30,
>> +	PMCCNTR_EL0,	/* Cycle Counter Register */
>> +	PMEVTYPER0_EL0,	/* Event Type Register (0-30) */
>> +	PMEVTYPER30_EL0 = PMEVTYPER0_EL0 + 30,
>> +	PMCCFILTR_EL0,	/* Cycle Count Filter Register */
>> +	PMCNTENSET_EL0,	/* Count Enable Set Register */
>> +	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
>> +	PMUSERENR_EL0,	/* User Enable Register */
>> +	PMSWINC_EL0,	/* Software Increment Register */
>> +
> 
> I've just noticed a rather fundamental issue with this: this makes it
> impossible to bisect the whole series.
> 
Ah, sorry. Will fix this.

> I was trying to pinpoint a performance regression with this series, and
> started bisecting.
You mean this series introduce a performance regression? Is there any
method to measure that? Then I can have a look too.

> Unfortunately, declaring these registers in one go
> means that we end-up with uninitialized registers after this patch (and
> probably until PMUSERENR is dealt with). The consequence of that is
> something like this:
> 
> Kernel panic - not syncing: Didn't reset vcpu_sys_reg(25)
> CPU: 1 PID: 1994 Comm: lkvm Tainted: G        W       4.5.0-rc5+ #5563
> Hardware name: Default string Default string/Default string, BIOS
> ROD0084E 09/03/2015
> Call trace:
> [<ffffffc000089a20>] dump_backtrace+0x0/0x1a8
> [<ffffffc000089bdc>] show_stack+0x14/0x20
> [<ffffffc00033490c>] dump_stack+0x94/0xb8
> [<ffffffc00014ddbc>] panic+0x10c/0x250
> [<ffffffc0000a9c94>] kvm_reset_sys_regs+0xec/0xf0
> [<ffffffc0000a7878>] kvm_reset_vcpu+0x58/0x80
> [<ffffffc0000a2c44>] kvm_arch_vcpu_ioctl+0x294/0x310
> [<ffffffc00009d6b4>] kvm_vcpu_ioctl+0xcc/0x698
> [<ffffffc0001cb184>] do_vfs_ioctl+0xa4/0x750
> [<ffffffc0001cb8bc>] SyS_ioctl+0x8c/0xa0
> [<ffffffc000085d30>] el0_svc_naked+0x24/0x28
> 
> The obvious fix would be to introduce each register with the patch that
> handles it. At least, we'll be able to bisect it...
> 
> Thanks,
> 
> 	M.
> 

Thanks,
-- 
Shannon
