From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 2/3] arm64: KVM: Allow for direct call of HYP functions
 when using VHE
Date: Wed, 9 Jan 2019 14:51:03 +0000
Message-ID: <e09db09d-e781-00d7-5247-525969413e44@arm.com>
References: <20190109135435.178664-1-marc.zyngier@arm.com>
 <20190109135435.178664-3-marc.zyngier@arm.com>
 <20190109142407.GH56789@e119886-lin.cambridge.arm.com>
 <a4f68a4c-5e5c-a60e-2f24-712028689422@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1A24A455
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 09:51:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g9HD3WKTdrqx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jan 2019 09:51:06 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 703194A43C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 09:51:06 -0500 (EST)
In-Reply-To: <a4f68a4c-5e5c-a60e-2f24-712028689422@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andrew Murray <andrew.murray@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 09/01/2019 14:45, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 09/01/2019 14:24, Andrew Murray wrote:
>> On Wed, Jan 09, 2019 at 01:54:34PM +0000, Marc Zyngier wrote:
>>> When running VHE, there is no need to jump via some stub to perform
>>> a "HYP" function call, as there is a single address space.
>>>
>>> Let's thus change kvm_call_hyp() and co to perform a direct call
>>> in this case. Although this results in a bit of code expansion,
>>> it allows the compiler to check for type compatibility, something
>>> that we are missing so far.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  arch/arm64/include/asm/kvm_host.h | 32 +++++++++++++++++++++++++++++--
>>>  1 file changed, 30 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index e54cb7c88a4e..df32edbadd69 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -370,8 +370,36 @@ void kvm_arm_halt_guest(struct kvm *kvm);
>>>  void kvm_arm_resume_guest(struct kvm *kvm);
>>>  
>>>  u64 __kvm_call_hyp(void *hypfn, ...);
>>> -#define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
>>> -#define kvm_call_hyp_ret(f, ...) kvm_call_hyp(f, ##__VA_ARGS__)
>>> +
>>> +/*
>>> + * The couple of isb() below are there to guarantee the same behaviour
>>> + * on VHE as on !VHE, where the eret to EL1 acts as a context
>>> + * synchronization event.
>>> + */
>>> +#define kvm_call_hyp(f, ...)						\
>>> +	do {								\
>>> +		if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN)) {	\
>>> +			f(__VA_ARGS__);					\
>>> +			isb();						\
>>> +		} else {						\
>>> +			__kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__); \
>>> +		}							\
>>> +	} while(0)
>>> +
>>> +#define kvm_call_hyp_ret(f, ...)					\
>>> +	({								\
>>> +		u64 ret;						\
>>> +									\
>>> +		if (cpus_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN)) {	\
>>> +			ret = f(__VA_ARGS__);				\
>>
>> __kvm_get_mdcr_el2 and __kvm_vcpu_run_nvhe don't return u64 type, they
>> return a smaller type. I guess any issues would be picked up when compiling,
>> but should the name of the macro be clearer as to the assumptions it makes?
>> Or perhaps take an argument which is the type of ret?
> 
> kvm_call_hyp has always returned a u64, so no semantic has changed here.
> 
> Otherwise, your suggestion of specifying a return type is interesting,
> but it also gives the programmer another chance to shoot itself in the
> foot by not providing the return type corresponding to the function that
> is called.
> 
> Unless we can extract the return type by pure magic, I'm not sure we
> gain much.
> 

Would the following work?

	typeof(f(__VA_ARGS__)) ret;

If typeof works anything like sizeof, I'd expect it would evaluate stuff
passed as argument and we'd have the return type of the function.

Cheers,

-- 
Julien Thierry
