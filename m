From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/8] KVM/ARM: Guest Entry/Exit optimizations
Date: Wed, 10 Feb 2016 12:24:06 +0000
Message-ID: <56BB2BE6.8020600@arm.com>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <20160209205919.GF5171@cbox> <56BAF60D.6020506@arm.com>
 <20160210120211.fjp2sxzivdhxug6p@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160210120211.fjp2sxzivdhxug6p@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 10/02/16 12:02, Andrew Jones wrote:
> On Wed, Feb 10, 2016 at 08:34:21AM +0000, Marc Zyngier wrote:
>> On 09/02/16 20:59, Christoffer Dall wrote:
>>> On Mon, Feb 08, 2016 at 11:40:14AM +0000, Marc Zyngier wrote:
>>>> I've recently been looking at our entry/exit costs, and profiling
>>>> figures did show some very low hanging fruits.
>>>>
>>>> The most obvious cost is that accessing the GIC HW is slow. As in
>>>> "deadly slow", specially when GICv2 is involved. So not hammering the
>>>> HW when there is nothing to write is immediately beneficial, as this
>>>> is the most common cases (whatever people seem to think, interrupts
>>>> are a *rare* event).
>>>>
>>>> Another easy thing to fix is the way we handle trapped system
>>>> registers. We do insist on (mostly) sorting them, but we do perform a
>>>> linear search on trap. We can switch to a binary search for free, and
>>>> get immediate benefits (the PMU code, being extremely trap-happy,
>>>> benefits immediately from this).
>>>>
>>>> With these in place, I see an improvement of 20 to 30% (depending on
>>>> the platform) on our world-switch cycle count when running a set of
>>>> hand-crafted guests that are designed to only perform traps.
>>>
>>> I'm curious about the weight of these two?  My guess based on the
>>> measurement work I did is that the GIC is by far the worst sinner, but
>>> that was exacerbated on X-Gene compared to Seattle.
>>
>> Indeed, the GIC is the real pig. 80% of the benefit is provided by not
>> accessing it when not absolutely required. The sysreg access is only
>> visible for workloads that are extremely trap-happy, but that's what
>> happens with as soon as you start exercising the PMU code.
>>
>>>>
>>>> Methodology:
>>>>
>>>> * NULL-hypercall guest: Perform 65536 PSCI_0_2_FN_PSCI_VERSION calls,
>>>> and then a power-off:
>>>>
>>>> __start:
>>>> 	mov	x19, #(1 << 16)
>>>> 1:	mov	x0, #0x84000000
>>>> 	hvc	#0
>>>> 	sub	x19, x19, #1
>>>> 	cbnz	x19, 1b
>>>> 	mov	x0, #0x84000000
>>>> 	add	x0, x0, #9
>>>> 	hvc	#0
>>>> 	b	.
>>>>
>>>> * sysreg trap guest: Perform 2^20 PMSELR_EL0 accesses, and power-off:
>>>>
>>>> __start:
>>>> 	mov	x19, #(1 << 20)
>>>> 1:	mrs	x0, PMSELR_EL0
>>>> 	sub	x19, x19, #1
>>>> 	cbnz	x19, 1b
>>>> 	mov	x0, #0x84000000
>>>> 	add	x0, x0, #9
>>>> 	hvc	#0
>>>> 	b	.
>>>>
>>>> * These guests are profiled using perf and kvmtool:
>>>>
>>>> taskset -c 1 perf stat -e cycles:kh lkvm run -c1 --kernel do_sysreg.bin 2>&1 >/dev/null| grep cycles
>>>
>>> these would be good to add to kvm-unit-tests so we can keep an eye on
>>> this sort of thing...
> 
> I can work on that. (Actually I already had put this on my TODO when I
> saw this series. Your interest in it just bumped it up in priority :-)

Ah! You're in charge, then! ;-)

>>
>> Yeah, I was thinking of that too. In the meantime, I've also created a
>> GICv2 self-IPI test case, which has led to further improvement (a 10%
>> reduction in the number of cycles on Seattle). The ugly thing about that
>> test is that it knows where kvmtool places the GIC (I didn't fancy
>> parsing the DT in assembly code). Hopefully there is a way to abstract this.
> 
> I have a simple IPI test written for kvm-unit-tests already[*], but it's
> been laying around for a while. I can dust it off and make a self-IPI
> test out of it yet today though. I've been hesitating to post any gic
> related stuff to kvm-unit-tests, because I know Andre has been looking
> into it (and he has the gic expertise to do it more cleanly than I). I'll
> go ahead and post my little thing now though, as he can always review it
> and/or clean it up later :-)
> 
> [*] https://github.com/rhdrjones/kvm-unit-tests/commit/05af9b0361ac5eab58f46e5451e585c9625c3b75

For the record, the test case I've been running is this:

__start:
	mov	x19, #(1 << 20)

	mov	x0, #0x3fff0000		// Dist
	mov	x1, #0x3ffd0000		// CPU
	mov	w2, #1
	str	w2, [x0]		// Enable Group0
	ldr	w2, =0xa0a0a0a0
	str	w2, [x0, 0x400]		// A0 priority for SGI0-3
	mov	w2, #0x0f
	str	w2, [x0, #0x100]	// Enable SGI0-3
	mov	w2, #0xf0
	str	w2, [x1, #4]		// PMR
	mov	w2, #1
	str	w2, [x1]		// Enable CPU interface
	
1:
	mov	w2, #(2 << 24)		// Interrupt self with SGI0
	str	w2, [x0, #0xf00]

2:	ldr	w2, [x1, #0x0c]		// GICC_IAR
	cmp	w2, #0x3ff
	b.ne	3f

	wfi
	b	2b

3:	str	w2, [x1, #0x10]		// EOI

	sub	x19, x19, #1
	cbnz	x19, 1b

// Die
	mov	x0, #0x84000000
	add	x0, x0, #9
	hvc	#0
	b	.

Feel free to adapt it so it fits in your framework if you find it useful
(but I guess you'll be inclined to rewrite it in C).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
