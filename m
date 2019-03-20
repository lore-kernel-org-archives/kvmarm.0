From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v7 9/10] KVM: arm64: docs: document KVM support of pointer
 authentication
Date: Wed, 20 Mar 2019 15:04:15 +0000
Message-ID: <648d66dd-519c-7567-a3e1-c23208f68cf2@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-10-git-send-email-amit.kachhap@arm.com>
 <7bf19035-02ba-ae47-b08c-7d7622a45dbf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7bf19035-02ba-ae47-b08c-7d7622a45dbf@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 20/03/2019 13:37, Julien Thierry wrote:
> Hi Amit,
> 
> On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
>> This adds sections for KVM API extension for pointer authentication.
>> A brief description about usage of pointer authentication for KVM guests
>> is added in the arm64 documentations.

[...]

>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 7de9eee..b5c66bc 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2659,6 +2659,12 @@ Possible features:
>>  	  Depends on KVM_CAP_ARM_PSCI_0_2.
>>  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>>  	  Depends on KVM_CAP_ARM_PMU_V3.
>> +	- KVM_ARM_VCPU_PTRAUTH_ADDRESS:
>> +	- KVM_ARM_VCPU_PTRAUTH_GENERIC:
>> +	  Enables Pointer authentication for the CPU.
>> +	  Depends on KVM_CAP_ARM_PTRAUTH and only on arm64 architecture. If
>> +	  set, then the KVM guest allows the execution of pointer authentication
>> +	  instructions. Otherwise, KVM treats these instructions as undefined.
>>  
> 
> Overall I feel one could easily get confused to whether
> PTRAUTH_ADDRESS/GENERIC are two individual features, whether one is a
> superset of the other, if the names are just an alias of one another, etc...
> 
> I think the doc should at least stress out that *both* flags are
> required to enable ptrauth in a guest. However it raises the question,
> if we don't plan to support the features individually (because we
> can't), should we really expose two feature flags? I seems odd to
> introduce two flags that only do something if used together...

Why can't we support the features individually? For example, if we ever
get a system where all CPUs support address authentication and none of
them support generic authentication, then we could still support address
authentication in the guest.

Thanks,
Kristina
