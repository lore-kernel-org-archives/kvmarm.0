From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] arm64: KVM: VHE: save and restore some PSTATE bits
Date: Wed, 6 Sep 2017 17:49:56 +0800
Message-ID: <9396c8ff-98e3-af57-742a-bbe2ac54ad34@huawei.com>
References: <0184EA26B2509940AA629AE1405DD7F2015DF717@DGGEMA503-MBX.china.huawei.com>
 <2a5d4299-2523-aef5-7db1-f351ca66b562@arm.com>
 <e47a9304-b429-b2bd-f151-d65f1c32044c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B2D40C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 05:48:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YHu0tmNLlKXb for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Sep 2017 05:48:29 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0268A40A86
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Sep 2017 05:48:28 -0400 (EDT)
In-Reply-To: <e47a9304-b429-b2bd-f151-d65f1c32044c@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "vladimir.murzin@arm.com" <vladimir.murzin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, mark.rutland@arm.com, catalin.marinas@arm.com
Cc: Huangshaoyu <huangshaoyu@huawei.com>, zhanghaibin7@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

For UAO, if not save/restore PSTATE.UAO, we can use below fixing.

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 9341376..c3dd761 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -21,6 +21,8 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>

+#include <asm/exec.h>
+
 /* Yes, this does nothing, on purpose */
 static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }

@@ -121,8 +123,13 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
 }

+static void __hyp_text __sysreg_restore_state_vhe(struct kvm_cpu_context *ctxt)
+{
+    uao_thread_switch(current);
+}
+
 static hyp_alternate_select(__sysreg_call_restore_host_state,
-			    __sysreg_restore_state, __sysreg_do_nothing,
+			    __sysreg_restore_state, __sysreg_restore_state_vhe,
 			    ARM64_HAS_VIRT_HOST_EXTN);

 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)



On 2017/9/6 17:32, gengdongjiu wrote:
> Hi Marc,
> 
> On 2017/9/6 16:17, Marc Zyngier wrote:
>> On 05/09/17 19:58, gengdongjiu wrote:
>>> when exit from guest, some host PSTATE bits may be lost, such as
>>> PSTATE.PAN or PSTATE.UAO. It is because host and hypervisor all run
>>> in the EL2, host PSTATE value cannot be saved and restored via
>>> SPSR_EL2. So if guest has changed the PSTATE, host continues with
>>> a wrong value guest has set.
>>>
>>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>>> Signed-off-by: Haibin Zhang <zhanghaibin7@huawei.com>
>>> ---
>>>  arch/arm64/include/asm/kvm_host.h |  8 +++++++
>>>  arch/arm64/include/asm/kvm_hyp.h  |  2 ++
>>>  arch/arm64/include/asm/sysreg.h   | 23 +++++++++++++++++++
>>>  arch/arm64/kvm/hyp/entry.S        |  2 --
>>>  arch/arm64/kvm/hyp/switch.c       | 24 ++++++++++++++++++--
>>>  arch/arm64/kvm/hyp/sysreg-sr.c    | 48 ++++++++++++++++++++++++++++++++++++---
>>>  6 files changed, 100 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index e923b58..cba7d3e 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -193,6 +193,12 @@ struct kvm_cpu_context {
>>>  	};
>>>  };
>>>  
>>> +struct kvm_cpu_host_pstate {
>>> +	u64 daif;
>>> +	u64 uao;
>>> +	u64 pan;
>>> +};
>>
>> I love it. This is the most expensive way of saving/restoring a single
>> 32bit value.
>>
>> More seriously, please see the discussion between James and Christoffer
>> there[1]. I expect James to address the PAN/UAO states together with the
>> debug state in the next iteration of his patch.
> 
> I roughly see the discussion between James and Christoffer, Seems Christoffer does not suggest save and
> restore it, and suggest to do below, and UAO/PAN may not use the same ways.
> 
>       __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>       {
>           if (has_vhe())
>               asm("msr     daifset, #0xf");
> 
>  	...
>          exit_code = __guest_enter(vcpu, host_ctxt);
>  	...
> 
>  	if (has_vhe())
>               asm("msr     daifclr, #0xd");
>       }
> 
> 
> If not save/restore them, the KVM will set them according to the CPU capability. For example below fixing, it will check CPU capability, If CPU supports PAN,
> the kvm will always enable the PAN for the host. But in fact, the host may be not enable the PAN.
> Of course for the UAO, we can use the similar fixing if Marc or Christoffer is agreed. but seems not make sense.
> 
> commit cb96408da4e11698674abd04aeac941c1bed2038
> Author: Vladimir Murzin <vladimir.murzin@arm.com>
> Date:   Thu Sep 1 15:29:03 2016 +0100
> 
>     arm64: KVM: VHE: reset PSTATE.PAN on entry to EL2
> 
>     SCTLR_EL2.SPAN bit controls what happens with the PSTATE.PAN bit on an
>     exception. However, this bit has no effect on the PSTATE.PAN when
>     HCR_EL2.E2H or HCR_EL2.TGE is unset. Thus when VHE is used and
>     exception taken from a guest PSTATE.PAN bit left unchanged and we
>     continue with a value guest has set.
> 
>     To address that always reset PSTATE.PAN on entry from EL1.
> 
>     Fixes: 1f364c8c48a0 ("arm64: VHE: Add support for running Linux in EL2 mode")
> 
>     Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>     Reviewed-by: James Morse <james.morse@arm.com>
>     Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>     Cc: <stable@vger.kernel.org> # v4.6+
>     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 3967c231..b5926ee 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -96,6 +96,8 @@ ENTRY(__guest_exit)
> 
>         add     x1, x1, #VCPU_CONTEXT
> 
> +       ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
> +
>         // Store the guest regs x2 and x3
>         stp     x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
> 
> 
>>
>> Thanks,
>>
>> 	M.
>>
>> [1] https://www.spinics.net/lists/arm-kernel/msg599798.html
>>
