From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 00/28] arm/arm64: KVM: Rework the hyp-stub API
Date: Wed, 22 Mar 2017 16:14:44 +0000
Message-ID: <3dab2f39-88c2-e10b-942c-58a1d8053b71@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170322133724.GA10969@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170322133724.GA10969@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 22/03/17 13:37, Christoffer Dall wrote:
> Hi Marc,
> 
> 
> On Tue, Mar 21, 2017 at 07:20:30PM +0000, Marc Zyngier wrote:
>> As noticed by RMK in this thread[1], the hyp-stub API on 32bit ARM
>> could do with some TLC (it cannot perform a soft-restart at HYP, and
>> has holes in the hyp-stub support in a number of places). In general,
>> it would be desirable for the 32bit behaviour to align on 64bit, if
>> only to ease maintenance.
>>
>> This series implements the following:
>> - Add HVC_[GS]ET_VECTORS and HVC_SOFT_RESTART to the 32bit code
>> - Add HVC_RESET_VECTORS to both arm and arm64, removing the need for
>>   __hyp_reset_vectors
>> - Implement add the stub entry points in the KVM init code, which
>>   didn't implement any so far
>> - Convert the HYP code to use the init code stubs directly
>> - Some general cleanup as a result of these changes (which includes
>>   killing HVC_GET_VECTORS)
>> - Add some API documentation that covers the above
>>
>> Patches 12 to 14 would be better squashed into 10 and 11, but I've
>> kept them separate so that I can take the blame for everything I've
>> broken.
> 
> This series looks great overall.  I'm still going through the details of
> the patches, but one high level questions:
> 
> What if we formalized the way to call a function in Hyp mode, whatever
> its current configuration may be, via a specific HVC number.  That would
> mean that the documentation say nothing of a hypervisor specific
> implementaiton.

Do you mean an actual function call indirected via an HVC? Similar to
what we already do today for KVM when we want to call HYP functions?

> Could we then use that to initialize hyp mode for a hypervisor, i.e.
> KVM, without having to actually change the vectors?  Couldn't we simply
> use the the hvc stub to call a function in the physical address space,
> and be rid of the concept of hyp-init alltogether?

My problem here is when you say "in the physical space". Do you want to
be able to call such a function from any context? That's certainly
doable now, but I'm not completely sure of what we get.

Maybe I just don't see the use case - can you enlighten me?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
