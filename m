From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v4] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Thu, 22 Feb 2018 16:53:12 +0000
Message-ID: <2d4e89d3-f930-bf99-1cf6-e989bd88fa00@arm.com>
References: <1519311090-19998-1-git-send-email-shankerd@codeaurora.org>
 <20180222152244.zozx2tlptgnnfu6b@lakrids.cambridge.arm.com>
 <32c8cfd3-2883-177b-7736-1bb6ab679df4@arm.com>
 <20180222163330.o5lqant4fjenapcz@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180222163330.o5lqant4fjenapcz@lakrids.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Philip Elcan <pelcan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 22/02/18 16:33, Mark Rutland wrote:
> On Thu, Feb 22, 2018 at 04:28:03PM +0000, Robin Murphy wrote:
>> [Apologies to keep elbowing in, and if I'm being thick here...]
>>
>> On 22/02/18 15:22, Mark Rutland wrote:
>>> On Thu, Feb 22, 2018 at 08:51:30AM -0600, Shanker Donthineni wrote:
>>>> +#define CTR_B31_SHIFT		31
>>>
>>> Since this is just a RES1 bit, I think we don't need a mnemonic for it,
>>> but I'll defer to Will and Catalin on that.
>>>
>>>>    ENTRY(invalidate_icache_range)
>>>> +#ifdef CONFIG_ARM64_SKIP_CACHE_POU
>>>> +alternative_if ARM64_HAS_CACHE_DIC
>>>> +	mov	x0, xzr
>>>> +	dsb	ishst
>>>> +	isb
>>>> +	ret
>>>> +alternative_else_nop_endif
>>>> +#endif
>>>
>>> As commented on v3, I don't believe you need the DSB here. If prior
>>> stores haven't been completed at this point, the existing implementation
>>> would not work correctly here.
>>
>> True in terms of ordering between stores prior to entry and the IC IVAU
>> itself, but what about the DSH ISH currently issued *after* the IC IVAU
>> before returning? Is provably impossible that existing callers might be
>> relying on that ordering *anything*, or would we risk losing something
>> subtle by effectively removing it?
> 
> AFAIK, the only caller of this is KVM, before page table updates occur
> to add execute permissions to the page this is applied to.
> 
> At least in that case, I do not beleive there would be breakage.
> 
> If we're worried about subtleties in callers, then we'd need to stick
> with DSB ISH rather than optimising to DSH ISHST.

Hmm, I probably am just squawking needlessly. It is indeed hard to 
imagine how callers could be relying on the invalidating the I-cache for 
ordering unless doing something unreasonably stupid, and if the current 
caller is clearly OK then there should be nothing to worry about.

This *has* helped me realise that I was indeed being somewhat thick 
before, because the existing barrier is of course not about memory 
ordering per se, but about completing the maintenance operation. Hooray 
for overloaded semantics...

On a different track, I'm now wondering whether the extra complexity of 
these alternatives might justify removing some obvious duplication and 
letting __flush_cache_user_range() branch directly into 
invalidate_icache_range(), or might that adversely affect the user fault 
fixup path?

Robin.
