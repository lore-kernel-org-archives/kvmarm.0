From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 00/26] KVM/arm64: Randomise EL2 mappings (variant 3a
 mitigation)
Date: Thu, 15 Mar 2018 16:52:20 +0000
Message-ID: <8bf3d76a-3811-c6f8-06f5-0ca40510baaa@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180315155741.7syqjajb77kh5vx2@kamzik.brq.redhat.com>
 <1a57727e-d4b8-f0e8-e910-ee1bc136ac0f@arm.com>
 <20180315164058.xmx3ap37o4gazptn@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDAF440458
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 12:45:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7CUsFHNakNJd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 12:44:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 413E1402D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 12:44:49 -0400 (EDT)
In-Reply-To: <20180315164058.xmx3ap37o4gazptn@kamzik.brq.redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/03/18 16:40, Andrew Jones wrote:
> On Thu, Mar 15, 2018 at 04:19:56PM +0000, Marc Zyngier wrote:
>> On 15/03/18 15:57, Andrew Jones wrote:
>>> On Wed, Mar 14, 2018 at 04:50:23PM +0000, Marc Zyngier wrote:
>>>> Whilst KVM benefits from the kernel randomisation via KASLR, there is
>>>> no additional randomisation when the kernel is running at EL1, as we
>>>> directly use a fixed offset from the linear mapping. This is not
>>>> necessarily a problem, but we could do a bit better by independently
>>>> randomizing the HYP placement.
>>>>
>>>> This series proposes to randomise the offset by inserting a few random
>>>> bits between the MSB of the RAM linear mapping and the top of the HYP
>>>> VA (VA_BITS - 2). That's not a lot of random bits (on my Mustang, I
>>>> get 13 bits), but that's better than nothing.
>>>>
>>>> In order to achieve this, we need to be able to patch dynamic values
>>>> in the kernel text. This results in a bunch of changes to the
>>>> alternative framework, the insn library, and a few more hacks in KVM
>>>> itself (we get a new way to map the GIC at EL2).
>>>>
>>>> Another (and more recent) goal of this series is to work around what
>>>> has been described as "variant 3a", which covers speculative reads of
>>>> privileged system registers. Randomizing the location of the
>>>> hypervisor would be pointless if one could simply obtain VBAR_EL2. In
>>>> order to work around this, we place the vectors at a fairly static
>>>> location (next to the idmap), independently of the hypervisor's own
>>>> mappings. This ensures that we can leak VBAR_EL2 without disclosing
>>>> much about HYP itself (and is similar to what the rest of the kernel
>>>> does with KPTI). This is only enabled at runtime for Cortex-A57 and
>>>> Cortex-A72.
>>>>
>>>> This has been tested on the FVP model, Seattle (both 39 and 48bit VA),
>>>> Mustang and Thunder-X. I've also done a sanity check on 32bit (which
>>>> is only impacted by the HYP IO VA stuff).
>>>>
>>>
>>> I've smoke tested this series on a seattle with several busy VMs running
>>> simultaneously. My host kernel configures 64K pages. I didn't see any
>>> problems.
>>
>> Excellent, thanks for testing. Out of curiosity: do you have a firmware
>> that implements the SMCCC_ARCH_WORKAROUND_1 call or not?
> 
> Unfortunately not, so I guess that means I was testing the
> __kvm_bp_vect_base base with the __kvm_harden_el2_vector_slot slot.

Indeed. That's a good data point nonetheless, and a good complement to
my own setup where the workaround is implemented. Getting full coverage
is pretty mind-boggling...

	M.
-- 
Jazz is not dead. It just smells funny...
