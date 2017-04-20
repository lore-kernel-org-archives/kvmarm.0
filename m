From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] ARM: hyp-stub: Fix Thumb-2 compilation
Date: Thu, 20 Apr 2017 15:56:50 +0100
Message-ID: <bb5bb658-3143-5085-40a1-9b520122b8c7@arm.com>
References: <20170420101620.1368-1-marc.zyngier@arm.com>
 <20170420112306.GE4104@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170420112306.GE4104@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 20/04/17 12:23, Christoffer Dall wrote:
> On Thu, Apr 20, 2017 at 11:16:20AM +0100, Marc Zyngier wrote:
>> The assembler defaults to emiting the short form of ADR, leading
>> to an out-of-range immediate. Using the wide version solves this
>> issue.
>>
>> Fixes: bc845e4fbbbb ("ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall in the init code")
>> Reported-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm/kernel/hyp-stub.S | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
>> index d8523cc47a54..ec7e7377d423 100644
>> --- a/arch/arm/kernel/hyp-stub.S
>> +++ b/arch/arm/kernel/hyp-stub.S
>> @@ -125,7 +125,7 @@ ENTRY(__hyp_stub_install_secondary)
>>   * (see safe_svcmode_maskall).
>>   */
>>  	@ Now install the hypervisor stub:
>> -	adr	r7, __hyp_stub_vectors
>> +	W(adr)	r7, __hyp_stub_vectors
>>  	mcr	p15, 4, r7, c12, c0, 0	@ set hypervisor vector base (HVBAR)
>>  
>>  	@ Disable all traps, so we don't get any nasty surprise
>> -- 
>> 2.11.0
>>
> 
> This fixes the compile, but I get this when booting it on TC2:
> 
> kvm [1]: 8-bit VMID
> kvm [1]: IDMAP page: 80201000
> kvm [1]: HYP VA range: 80000000:ffffffff
> kvm [1]: Hyp mode initialized successfully
> kvm [1]: vgic-v2@2c004000
> kvm [1]: vgic interrupt IRQ16
> kvm [1]: virtual timer IRQ19
> Kernel panic - not syncing:
> HYP panic: UNDEF PC:802010ac CPSR:800001da
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc3+ #140
> Hardware name: ARM-Versatile Express
> [<8021c5f1>] (unwind_backtrace) from [<802199eb>] (show_stack+0xb/0xc)
> [<802199eb>] (show_stack) from [<803ccc15>] (dump_stack+0x71/0x80)
> [<803ccc15>] (dump_stack) from [<80289467>] (panic+0xbb/0x1d4)
> [<80289467>] (panic) from [<8020b1f5>]
> (_kvm_arch_hardware_disable+0x11/0x20)
> [<8020b1f5>] (_kvm_arch_hardware_disable) from [<8026c497>]
> (flush_smp_call_function_queue+0x77/0x134)
> [<8026c497>] (flush_smp_call_function_queue) from [<8021b8f9>]
> (handle_IPI+0xd9/0x150)
> [<8021b8f9>] (handle_IPI) from [<80201425>] (gic_handle_irq+0x65/0x6c)
> [<80201425>] (gic_handle_irq) from [<8021a213>] (__irq_svc+0x53/0x7c)
> Exception stack(0x80a01f18 to 0x80a01f60)
> 1f00:                                                       00000001
> 00000000
> 1f20: 80a01f70 802231c1 00000000 80a00000 00000000 80a03c80 80a03c34
> 808445d8
> 1f40: 80a01f70 80a03c88 805b31d1 80a01f68 80217ce1 80217ce2 40000033
> ffffffff
> [<8021a213>] (__irq_svc) from [<80217ce2>] (arch_cpu_idle+0x22/0x24)
> [<80217ce2>] (arch_cpu_idle) from [<8024ca89>] (do_idle+0xf9/0x158)
> [<8024ca89>] (do_idle) from [<8024ccaf>] (cpu_startup_entry+0x13/0x14)
> [<8024ccaf>] (cpu_startup_entry) from [<80800a4d>]
> (start_kernel+0x309/0x314)
> [<80800a4d>] (start_kernel) from [<80008095>] (0x80008095)
> CPU1: stopping
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.11.0-rc3+ #140
> Hardware name: ARM-Versatile Express
> [<8021c5f1>] (unwind_backtrace) from [<802199eb>] (show_stack+0xb/0xc)
> [<802199eb>] (show_stack) from [<803ccc15>] (dump_stack+0x71/0x80)
> [<803ccc15>] (dump_stack) from [<8021b95d>] (handle_IPI+0x13d/0x150)
> [<8021b95d>] (handle_IPI) from [<80201425>] (gic_handle_irq+0x65/0x6c)
> [<80201425>] (gic_handle_irq) from [<8021a213>] (__irq_svc+0x53/0x7c)
> Exception stack(0xeec47e20 to 0xeec47e68)
> 7e20: 00000000 ef1a96dc 80000000 80000000 80a03de4 80a03cf8 ef1b5a84
> ef1b5a80
> 7e40: 00000001 00000008 80a03de4 80845a00 00000000 eec47e70 8026c9ed
> 8026ca02
> 7e60: a0000033 ffffffff
> [<8021a213>] (__irq_svc) from [<8026ca02>]
> (smp_call_function_many+0x1aa/0x1f0)
> [<8026ca02>] (smp_call_function_many) from [<8026ca89>]
> (on_each_cpu+0x1d/0x30)
> [<8026ca89>] (on_each_cpu) from [<8020c369>] (kvm_arch_init+0x339/0x3fc)
> [<8020c369>] (kvm_arch_init) from [<80207149>] (kvm_init+0x11/0x214)
> [<80207149>] (kvm_init) from [<8020177d>] (do_one_initcall+0x2d/0x104)
> [<8020177d>] (do_one_initcall) from [<80800bed>]
> (kernel_init_freeable+0x195/0x208)
> [<80800bed>] (kernel_init_freeable) from [<805b2383>]
> (kernel_init+0x7/0xd4)
> [<805b2383>] (kernel_init) from [<80217361>] (ret_from_fork+0x11/0x30)
> SMP: failed to stop secondary CPUs
> ---[ end Kernel panic - not syncing:
> HYP panic: UNDEF PC:802010ac CPSR:800001da

Grmbl... We inadvertently switched to ARM by applying a pretty silly
correction to the target PC when branching to the stub, while the
assembler has already provided us with a valid Thumb address.

/me hates Thumb, patch incoming.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
