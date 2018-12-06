From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 2/4] arm64: KVM: add accessors to track guest/host only
 counters
Date: Thu, 6 Dec 2018 18:51:37 +0000
Message-ID: <fefadc01-05dd-f714-667e-71c3589083e7@arm.com>
References: <1544023815-16958-1-git-send-email-andrew.murray@arm.com>
 <1544023815-16958-3-git-send-email-andrew.murray@arm.com>
 <97301473-69d0-9a0b-b957-5568a43a6551@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 471024A2E6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 13:51:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1gbkQYDWd+ia for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Dec 2018 13:51:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 376044A214
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 13:51:41 -0500 (EST)
In-Reply-To: <97301473-69d0-9a0b-b957-5568a43a6551@arm.com>
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
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 06/12/2018 17:21, Suzuki K Poulose wrote:
> Hi Andrew,
> 
> On 05/12/2018 15:30, Andrew Murray wrote:
>> In order to effeciently enable/disable guest/host only perf counters
>> at guest entry/exit we add bitfields to kvm_cpu_context for guest and
>> host events as well as accessors for updating them.
>>
>> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>> ---
>>    arch/arm64/include/asm/kvm_host.h | 24 ++++++++++++++++++++++++
>>    1 file changed, 24 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 1550192..800c87b 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -203,6 +203,8 @@ struct kvm_cpu_context {
>>    	};
>>    
>>    	struct kvm_vcpu *__hyp_running_vcpu;
>> +	u32 events_host;
>> +	u32 events_guest;
>>    };
>>    
>>    typedef struct kvm_cpu_context kvm_cpu_context_t;
>> @@ -467,11 +469,33 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
>>    void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
>>    void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
>>    
>> +#define KVM_PMU_EVENTS_HOST	1
>> +#define KVM_PMU_EVENTS_GUEST	2
>> +
>>    #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
>>    static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>>    {
>>    	return kvm_arch_vcpu_run_map_fp(vcpu);
>>    }
>> +static inline void kvm_set_pmu_events(u32 set, int flags)
>> +{
>> +	kvm_cpu_context_t *ctx = this_cpu_ptr(&kvm_host_cpu_state);
>> +
>> +	if (flags & KVM_PMU_EVENTS_HOST)
>> +		ctx->events_host |= set;
>> +	if (flags & KVM_PMU_EVENTS_GUEST)
>> +		ctx->events_guest |= set;
> 
> You seem to be passing a single flag at a time ever, in the next patch.
> Either we can batch the calls in the next patch, or make this a real number and
> not a flag. g.g, enum { HOST,  GUEST } or even a bool.
> 
> I think the former sounds better.

Having another look at patch-3, we can never club set() calls for host & guest 
events, we should go for the latter.

Suzuki
