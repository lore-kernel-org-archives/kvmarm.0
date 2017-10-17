From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 06/10] KVM: arm/arm64: Only clean the dcache on
 translation fault
Date: Tue, 17 Oct 2017 15:52:36 +0100
Message-ID: <07d1238a-78e2-af45-c2fd-bd7c9d1edf4d@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-7-marc.zyngier@arm.com> <20171016200811.GH1845@lvm>
 <210cf2dc-2566-a29b-637e-901f3dcc80b6@arm.com> <20171017143634.GI5886@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171017143634.GI5886@lvm>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 17/10/17 15:36, Christoffer Dall wrote:
> On Tue, Oct 17, 2017 at 10:34:15AM +0100, Marc Zyngier wrote:
>> On 16/10/17 21:08, Christoffer Dall wrote:
>>> On Mon, Oct 09, 2017 at 04:20:28PM +0100, Marc Zyngier wrote:
>>>> The only case where we actually need to perform a dache maintenance
>>>> is when we map the page for the first time, and subsequent permission
>>>> faults do not require cache maintenance. Let's make it conditional
>>>> on not being a permission fault (and thus a translation fault).
>>>
>>> Why do we actually need to do any dcache maintenance when faulting in a
>>> page?
>>>
>>> Is this for the case when the stage 1 MMU is disabled, or to support
>>> guest mappings using uncached attributes?
>>
>> These are indeed the two cases that require cleaning the dcache to PoC.
>>
>>> Can we do better, for example
>>> by only flushing the cache if the guest MMU is disabled?
>>
>> The guest MMU being disabled is easy. But the uncached mapping is much
>> trickier, and would involve parsing the guest page tables. Not something
>> I'm really eager to implement.
>>
> 
> Hmm, if the guest actually maps memory uncached, wouldn't it have to
> invalidate caches itself, or is this the annoying thing where disabling
> the MMU on hardware that doesn't have stage 2 would in fact always
> completely bypass the cache, and therefore we have to do this work?

The architecture is massively ambiguous about what is actually required
in terms of CMOs when using an uncached mapping (and whether you can hit
in the cache or not).

But even if the guest had done an invalidate in order not to hit in the
cache, the host could have evicted the page to disk, the guest faulted
the page back in, and it would still be the host's responsibility to
ensure that the guest sees something consistent.

> Sorry, I have forgotten all the details here, but wanted to make sure
> we're not being overly careful.

No worries, I'm always happy to revisit this particular rabbit hole... ;-)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
