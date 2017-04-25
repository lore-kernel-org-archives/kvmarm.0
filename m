From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V9 1/3] irq: Allow to pass the IRQF_TIMER flag with percpu
 irq request
Date: Tue, 25 Apr 2017 14:22:04 +0100
Message-ID: <a4faf3bb-1641-8b6d-3e15-9f8ef46c9411@arm.com>
References: <1493042494-14057-1-git-send-email-daniel.lezcano@linaro.org>
 <398f3f3d-c567-0f1f-1a43-9b8d5805d5fd@arm.com> <20170424185909.GD2137@mai>
 <92e2a022-93d4-d4f3-78af-c9b5d51bb867@arm.com> <20170424195948.GE2137@mai>
 <16042494-2e67-e1a5-b9f6-af57e349d8a7@arm.com> <20170425083451.GA16888@mai>
 <f840e9d2-8aac-dc1d-6468-44f7658b55b1@arm.com> <20170425094927.GB16888@mai>
 <c98a5ff3-c2ea-5f94-d136-391bd7c224f3@arm.com> <20170425125103.GC16888@mai>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E1E440C90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 09:19:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IU-l+99nSsfk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 09:19:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B465340C54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 09:19:20 -0400 (EDT)
In-Reply-To: <20170425125103.GC16888@mai>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, kernel@stlinux.com, kvm@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>, Patrice Chotard <patrice.chotard@st.com>, Krzysztof Kozlowski <krzk@kernel.org>, linux-kernel@vger.kernel.org, Javier Martinez Canillas <javier@osg.samsung.com>, Kukjin Kim <kgene@kernel.org>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de, linux-snps-arc@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 25/04/17 13:51, Daniel Lezcano wrote:
> On Tue, Apr 25, 2017 at 11:21:21AM +0100, Marc Zyngier wrote:
>> On 25/04/17 10:49, Daniel Lezcano wrote:
>>> On Tue, Apr 25, 2017 at 10:10:12AM +0100, Marc Zyngier wrote:
>>
>> [...]
>>
>>>>> +static inline void setup_timings(struct irq_desc *desc, struct irqaction *act)
>>>>> +{
>>>>> +	/*
>>>>> +	 * We don't need the measurement because the idle code already
>>>>> +	 * knows the next expiry event.
>>>>> +	 */
>>>>> +	if (act->flags & __IRQF_TIMER)
>>>>> +		return;
>>>>
>>>> And that's where this is really wrong for the KVM guest timer. As I
>>>> said, this timer is under complete control of the guest, and the rest of
>>>> the system doesn't know about it. KVM itself will only find out when the
>>>> vcpu does a VM exit for a reason or another, and will just save/restore
>>>> the state in order to be able to give the timer to another guest.
>>>>
>>>> The idle code is very much *not* aware of anything concerning that guest
>>>> timer.
>>>
>>> Just for my own curiosity, if there are two VM (VM1 and VM2). VM1 sets a timer1
>>> at <time> and exits, VM2 runs and sets a timer2 at <time+delta>.
>>>
>>> The timer1 for VM1 is supposed to expire while VM2 is running. IIUC the virtual
>>> timer is under control of VM2 and will expire at <time+delta>.
>>>
>>> Is the host wake up with the SW timer and switch in VM1 which in turn restores
>>> the timer and jump in the virtual timer irq handler?
>>
>> Indeed. The SW timer causes VM1 to wake-up, either on the same CPU
>> (preempting VM2) or on another. The timer is then restored with the
>> pending virtual interrupt injected, and the guest does what it has to
>> with it.
> 
> Thanks for clarification.
> 
> So there is a virtual timer with real registers / interruption (waking up the
> host) for the running VMs and SW timers for non-running VMs.
> 
> What is the benefit of having such mechanism instead of real timers injecting
> interrupts in the VM without the virtual timer + save/restore? Efficiency in
> the running VMs when setting up timers (saving privileges change overhead)?


You can't dedicate HW resources to virtual CPUs. It just doesn't scale.
Also, injecting HW interrupts in a guest is pretty hard work, and for
multiple reasons:
  - the host needs to be in control of interrupt delivery (don't hog the
CPU with guest interrupts)
  - you want to be able to remap interrupts (id X on the host becomes id
Y on the guest),
  - you want to deal with migrating vcpus,
  - you want deliver an interrupt to a vcpu that is *not* running.

It *is* doable, but it is not cheap at all from a HW point of view.

	M.
-- 
Jazz is not dead. It just smells funny...
