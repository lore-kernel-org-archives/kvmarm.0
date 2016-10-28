From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Fri, 28 Oct 2016 15:38:46 +0100
Message-ID: <3928feee-cb23-8635-20bd-4c068b649a1d@arm.com>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
 <de375a6e-095c-a17a-0db7-876a5619df42@suse.de>
 <3e85d538-2539-f190-0d17-a2ecfe7b48ce@suse.de> <20160930154335.GB7996@cbox>
 <71b0ae9d-baea-1f65-3c01-5d87f4f4746f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5094055B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2016 10:38:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VepbqyY0yaGw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2016 10:38:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 866AA406C3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2016 10:38:43 -0400 (EDT)
In-Reply-To: <71b0ae9d-baea-1f65-3c01-5d87f4f4746f@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Alex,

On 30/09/16 20:31, Alexander Graf wrote:
> 
> 
> On 30.09.16 17:43, Christoffer Dall wrote:
>> On Fri, Sep 30, 2016 at 05:38:11PM +0200, Alexander Graf wrote:
>>>
>>>
>>> On 30.09.16 16:54, Alexander Graf wrote:
>>>>
>>>>
>>>> On 27.09.16 21:08, Christoffer Dall wrote:
>>>>> Hi Alex,
>>>>>
>>>>> Marc and I have been looking at this during Linaro connect and have
>>>>> slightly reworked your patch into this small series.
>>>>>
>>>>> It would be good if you could have a look at it and test it out.
>>>>>
>>>>> I've tested it with your QEMU, and it works for UP, but secondary CPUs
>>>>> fail to come up, and it looks like the kernel never gets an IPI for
>>>>> those CPUs from userspace.  Any chance you're willing to take a look at
>>>>> that?
>>>>
>>>> I still need to see whether I can come up with a prettier solution, but
>>>> for now this works:
>>>>
>>>> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
>>>
>>> Eh, no, not in i386 code :). But the problem seems to be a missing
>>> mpstate sync.
>>>
>> Yeah, that looked really dodgy.  Have you tested it? :)
> 
> This time around tested with the correct command line parameters I hope
> :). I'll send a pretty patch later.
> 
> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> index b4c8fe2..b549f00 100644
> --- a/target-arm/kvm.c
> +++ b/target-arm/kvm.c
> @@ -173,6 +173,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>       */
>      kvm_async_interrupts_allowed = true;
> 
> +    /*
> +     * PSCI wakes up secondary cores, so we always need to
> +     * have vCPUs waiting in kernel space
> +     */
> +    kvm_halt_in_kernel_allowed = true;
> +
>      cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
> 
>      type_register_static(&host_arm_cpu_type_info);

What the status of userspace for this thing? Are QEMU patches being
posted and reviewed?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
