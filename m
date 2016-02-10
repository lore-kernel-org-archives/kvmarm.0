From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/8] KVM/ARM: Guest Entry/Exit optimizations
Date: Wed, 10 Feb 2016 08:34:21 +0000
Message-ID: <56BAF60D.6020506@arm.com>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <20160209205919.GF5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18ABE49A9D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 03:28:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mrEP+updnwzq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2016 03:28:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD6F49A85
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 03:28:33 -0500 (EST)
In-Reply-To: <20160209205919.GF5171@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 09/02/16 20:59, Christoffer Dall wrote:
> On Mon, Feb 08, 2016 at 11:40:14AM +0000, Marc Zyngier wrote:
>> I've recently been looking at our entry/exit costs, and profiling
>> figures did show some very low hanging fruits.
>>
>> The most obvious cost is that accessing the GIC HW is slow. As in
>> "deadly slow", specially when GICv2 is involved. So not hammering the
>> HW when there is nothing to write is immediately beneficial, as this
>> is the most common cases (whatever people seem to think, interrupts
>> are a *rare* event).
>>
>> Another easy thing to fix is the way we handle trapped system
>> registers. We do insist on (mostly) sorting them, but we do perform a
>> linear search on trap. We can switch to a binary search for free, and
>> get immediate benefits (the PMU code, being extremely trap-happy,
>> benefits immediately from this).
>>
>> With these in place, I see an improvement of 20 to 30% (depending on
>> the platform) on our world-switch cycle count when running a set of
>> hand-crafted guests that are designed to only perform traps.
> 
> I'm curious about the weight of these two?  My guess based on the
> measurement work I did is that the GIC is by far the worst sinner, but
> that was exacerbated on X-Gene compared to Seattle.

Indeed, the GIC is the real pig. 80% of the benefit is provided by not
accessing it when not absolutely required. The sysreg access is only
visible for workloads that are extremely trap-happy, but that's what
happens with as soon as you start exercising the PMU code.

>>
>> Methodology:
>>
>> * NULL-hypercall guest: Perform 65536 PSCI_0_2_FN_PSCI_VERSION calls,
>> and then a power-off:
>>
>> __start:
>> 	mov	x19, #(1 << 16)
>> 1:	mov	x0, #0x84000000
>> 	hvc	#0
>> 	sub	x19, x19, #1
>> 	cbnz	x19, 1b
>> 	mov	x0, #0x84000000
>> 	add	x0, x0, #9
>> 	hvc	#0
>> 	b	.
>>
>> * sysreg trap guest: Perform 2^20 PMSELR_EL0 accesses, and power-off:
>>
>> __start:
>> 	mov	x19, #(1 << 20)
>> 1:	mrs	x0, PMSELR_EL0
>> 	sub	x19, x19, #1
>> 	cbnz	x19, 1b
>> 	mov	x0, #0x84000000
>> 	add	x0, x0, #9
>> 	hvc	#0
>> 	b	.
>>
>> * These guests are profiled using perf and kvmtool:
>>
>> taskset -c 1 perf stat -e cycles:kh lkvm run -c1 --kernel do_sysreg.bin 2>&1 >/dev/null| grep cycles
> 
> these would be good to add to kvm-unit-tests so we can keep an eye on
> this sort of thing...

Yeah, I was thinking of that too. In the meantime, I've also created a
GICv2 self-IPI test case, which has led to further improvement (a 10%
reduction in the number of cycles on Seattle). The ugly thing about that
test is that it knows where kvmtool places the GIC (I didn't fancy
parsing the DT in assembly code). Hopefully there is a way to abstract this.

We definitely run that kind of things on a regular basis and track the
evolutions...

> 
>>
>> The result is then divided by the number of iterations (2^16 or 2^20).
>>
>> These tests have been run on Seattle, Mustang, and LS2085, and shown
>> significant improvements in all cases. I've only touched the arm64
>> GIC code, but obviously the 32bit code should use it as well once
>> we've migrated it to C.
>>
>> I've pushed out a branch (kvm-arm64/suck-less) to the usual location.
>>
> 
> Looks promising!

I thought as much. I'll keep on updating this branch, as it looks like
there is a few more low hanging fruits around there...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
